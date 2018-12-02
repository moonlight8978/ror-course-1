module NewItemsStatisticsService
  class << self
    # TODO: filter visible posts/topics, unbanned_users ?! (not sure if needed)
    def perform(time = this_month)
      new_users = User.where(created_at: time).count
      new_posts = Post.without_first_posts.where(created_at: time).count
      new_topics = Topic.where(created_at: time).count
      NewItemsStatistics.new(
        new_users_count: new_users,
        new_posts_count: new_posts,
        new_topics_count: new_topics
      )
    end

    private

    def this_month
      (Date.current.at_beginning_of_month..Date.current.at_end_of_month)
    end
  end

  class NewItemsStatistics
    attr_reader :new_users_count, :new_posts_count, :new_topics_count

    def initialize(**args)
      self.new_users_count = args[:new_users_count]
      self.new_posts_count = args[:new_posts_count]
      self.new_topics_count = args[:new_topics_count]
    end

    private

    attr_writer :new_users_count, :new_posts_count, :new_topics_count
  end
end
