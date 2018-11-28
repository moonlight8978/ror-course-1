class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(category: @topic.category)
    authorize @post
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    authorize @post
    if @post.save
      redirect_to topic_path(@topic, page: @topic.posts.page.total_pages)
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
      .merge(creator: current_user, category: @topic.category)
      .permit!
  end
end
