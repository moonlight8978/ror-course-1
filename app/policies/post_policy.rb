class PostPolicy < ApplicationPolicy
  def show?
    return true if category_policy.manage?
    return false if record.deleted?

    not_user? || user.can_interact_with_category?(record.category)
  end

  def create?
    topic_policy.reply?
  end

  def new?
    create?
  end

  def update?
    return false unless topic_policy.reply?
    return false if record.deleted?

    category_policy.manage? || user.posted?(record)
  end

  def edit?
    update?
  end

  private

  def category_policy
    @category_policy ||= CategoryPolicy.new(user, record.category)
  end

  def topic_policy
    @topic_policy ||= TopicPolicy.new(user, record.topic)
  end
end
