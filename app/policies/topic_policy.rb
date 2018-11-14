class TopicPolicy < ApplicationPolicy
  def show?
    return true if category_policy.manage?
    return false if record.deleted?

    not_user? || user.can_interact_with_category?(record.category)
  end

  def update?
    return false if guest? || !user.can_interact_with_category?(record.category)

    user.posted?(record) || category_policy.manage?
  end

  def destroy?
    category_policy.manage?
  end

  def reply?
    return false if guest?
    return false unless user.can_interact_with_category?(record.category)

    record.opening? && record.visible?
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end
end
