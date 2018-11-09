class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def manage?
    ultimate?
  end

  protected

  def ultimate?
    signed_in? && user.admin?
  end

  def signed_in?
    user.present?
  end

  def guest?
    user.nil?
  end

  def not_user?
    guest? || user.has_role?(:moderator)
  end
end
