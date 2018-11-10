class CategoryPolicy < ApplicationPolicy
  def show?
    return true if not_user?

    user.can_interact_with_category?(record)
  end

  def manage?
    return false if guest?
    return true if user.admin?

    user.moderator? && user.can_manage_category?(record)
  end
end
