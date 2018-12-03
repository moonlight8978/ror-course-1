class TopicPolicy < ApplicationPolicy
  def show?
    return true if category_policy.manage?
    return false if record.deleted?

    not_user? || user.can_interact_with_category?(record.category)
  end

  def create?
    category_policy.show?
  end

  def new?
    create?
  end

  def update?
    return false unless reply?

    category_policy.manage? || user.posted?(record)
  end

  def edit?
    update?
  end

  def destroy?
    category_policy.manage?
  end

  def reply?
    return false if guest? || record.deleted? || record.locked?

    user.can_interact_with_category?(record.category)
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end
end
