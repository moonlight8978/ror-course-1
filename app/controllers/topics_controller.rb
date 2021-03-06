class TopicsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @topic = Topic.find(params[:id])
    authorize @topic
    @first_post = Post.with_attached_images.find(@topic.first_post.id)
    @posts = @topic.posts.with_attached_images.includes(:creator, :category)
      .order(created_at: :asc)
      .page(params[:page])
  end

  def new
    @category = Category.find(params[:category_id])
    @topic = @category.topics.build
    authorize @topic
    @topic.build_first_post
  end

  def create
    @category = Category.find(params[:category_id])
    @topic = @category.topics.build(create_topic_params)
    authorize @topic
    if @topic.save
      redirect_to @topic
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize @topic
  end

  def update
    @topic = Topic.find(params[:id])
    authorize @topic
    if @topic.update(topic_params)
      redirect_to @topic
    else
      render :edit
    end
  end

  private

  def create_topic_params
    first_post_params = params.require(:topic).require(:first_post_attributes)
      .permit(:content, images: [])
      .merge(category: @category, creator: current_user)
      .permit!

    params.require(:topic).permit(:name)
      .merge(creator: current_user, first_post_attributes: first_post_params)
      .permit!
  end

  def topic_params
    permitted_params = [first_post_attributes: [:id, :content, images: []]]
    permitted_params.push(:name) if policy(@topic.category).manage?
    params.require(:topic).permit(permitted_params)
  end
end
