# frozen_string_literal: true

module Auth
  extend ActiveSupport::Concern
  include Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from JWT::DecodeError, with: :token_error
    rescue_from JWT::ExpiredSignature, with: :token_error
    rescue_from JWT::InvalidIssuerError, with: :token_error
    rescue_from JWT::InvalidIatError, with: :token_error

    after_action :verify_authorized
  end

  def permitted_attributes(record, action = action_name)
    policy = policy(record)
    method_name = if policy.respond_to?("permitted_attributes_for_#{action}")
                    "permitted_attributes_for_#{action}"
                  else
                    "permitted_attributes"
                  end
    params.require(:data).permit(*policy.public_send(method_name))
  end

  def require_login
    not_authenticated unless logged_in?
  end

  def logged_in?
    current_user.user?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_factory.from_jwt(bearer_token)
  end

  # Not used yet until user profile pictures are supported
  def current_user_with_images
    # @current_user = current_user_with_images_factory.from_token(http_token)
  end

  def token_error(exception)
    logger.warn { "Token error: #{exception.message}" }
    render status: :forbidden, json: { "error": "Forbidden: Request missing valid Authorization header",
                                       "message": truncate_error_message(exception.message) }
  end

  def not_authenticated
    render status: :unauthorized, json: { "error": "Unauthorized: Request missing valid Authorization header",
                                          "message": "User is not authenticated" }
  end

  def user_not_authorized
    render status: :forbidden, json: { "error": "Forbidden: You are not authorized to perform this action",
                                       "message": "You are not authorized to perform this action" }
  end

  def bearer_token
    request.headers['Authorization'].slice(7..-1) if request.headers['Authorization'].present?
  end

  def current_user_factory_producer
    @@current_user_factory_producer ||= proc { |args = {}| CurrentUserFactory.new(args) }
  end

  def current_user_factory
    @@current_user_factory ||= current_user_factory_producer.call
  end

  def current_user_with_images_factory
    @@current_user_with_images_factory ||= current_user_factory_producer.call(user_finder: lambda do |external_user_id|
      User.with_images.find_by(external_user_id: external_user_id)
    end)
  end

  def truncate_error_message(message)
    @@exception_message_handler ||= ->(msg) { msg.split('.')&.first }
    @@exception_message_handler.call(message)
  end

  # For testing use only
  def self.current_user_factory_producer=(current_user_factory_producer)
    @@current_user_factory_producer = current_user_factory_producer
  end

  def self.exception_message_handler=(exception_message_handler)
    @@exception_message_handler = exception_message_handler
  end
end
