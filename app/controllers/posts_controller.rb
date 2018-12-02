class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(category: @topic.category)
    authorize @post
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(create_post_params)
    authorize @post
    if @post.save
      redirect_to topic_path(@topic, page: @topic.posts.page.total_pages)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    if @post.update(post_params)
      redirect_to topic_path(@post.topic)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    @post.soft_destroy
    redirect_back fallback_location: root_path
  end

  private

  def create_post_params
    post_params.merge(creator: current_user, category: @topic.category).permit!
  end

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
