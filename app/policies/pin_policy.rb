# frozen_string_literal: true

class PinPolicy < ApplicationPolicy
  attr_reader :user, :pin

  def initialize(user, pin)
    @user = user
    @pin = pin
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.can?('create:pin')
  end

  def update?
    user.can?('update:pin')
  end

  def destroy?
    user.can?('destroy:pin')
  end

  def publish?
    user.can?('publish:pin')
  end

  def permitted_attributes
    attributes = Pin.public_attribute_names

    attributes + Pin.restricted_attribute_names if user.can?('publish:pin')

    attributes
  end

  class Scope < Scope
    attr_reader :current_user, :scope

    def initialize(current_user, scope)
      @current_user = current_user
      @scope = scope
    end

    def resolve
      return scope if current_user.can?('publish:pin')

      scope.published
    end
  end
end
