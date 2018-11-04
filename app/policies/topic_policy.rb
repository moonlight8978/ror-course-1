class TopicPolicy < ApplicationPolicy
  def read?
    return true if not_user?

    user.can_interact_with_category?(record.category)
  end

  def create?
    return false if guest?
    return true if user.has_role?(:moderator)

    user.can_interact_with_category?(record.category)
  end

  def update?
    return false if guest?
    return false unless user.can_interact_with_category?(record.category)
    return true if user.id == record.creator_id

    category_policy.patrol?
  end

  def destroy?
    category_policy.patrol?
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end
end
