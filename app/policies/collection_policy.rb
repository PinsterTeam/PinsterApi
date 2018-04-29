# frozen_string_literal: true

class CollectionPolicy
  attr_reader :user, :collection

  def initialize(user, collection)
    @user = user
    @collection = collection
  end

  def index?
    user&.admin?
  end

  def show?
    user&.admin? or collection.public? or user&.owns?(collection)
  end

  def create?
    user&.user?
  end

  def new?
    user&.user?
  end

  def update?
    user&.admin? or user&.owns?(collection)
  end

  def destroy?
    user&.admin? or user&.owns?(collection)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.all if user.admin?
      scope.where(user_id: user.id)
    end
  end
end
