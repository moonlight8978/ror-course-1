class PostPolicy < ApplicationPolicy
  def show?
    return true if category_policy.manage?
    return false if record.deleted?

    not_user? || user.can_interact_with_category?(record.category)
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end
end
