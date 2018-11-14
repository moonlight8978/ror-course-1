class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.includes(:creator, :category).page(params[:page])
  end
end
