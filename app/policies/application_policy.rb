class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def read?
    true
  end

  def manage?
    ultimate?
  end

  def ultimate?
    signed_in? && user.admin?
  end

  protected

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
