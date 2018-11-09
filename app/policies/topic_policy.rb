class TopicPolicy < ApplicationPolicy
  def show?
    not_user? || user.can_interact_with_category?(record.category)
  end

  def update?
    return false if guest? || !user.can_interact_with_category?(record.category)

    user.posted?(record) || category_policy.manage?
  end

  def destroy?
    category_policy.manage?
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end
end
