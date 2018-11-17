class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])
    authorize @topic
    @posts = @topic.posts.includes(:creator, :category).page(params[:page])
  end

  def new
    @category = Category.find(params[:category_id])
    @topic = @category.topics.build
    authorize @topic
    @topic.build_first_post
  end

  def create
    @category = Category.find(params[:category_id])
    @topic = @category.topics.create(topic_params)
    authorize @topic
    if @topic.errors.empty?
      redirect_to @topic
    else
      render :new
    end
  end

  private

  def topic_params
    first_post_params = params.require(:topic).require(:first_post_attributes)
      .permit(:content, images: [])
      .merge(category: @category, creator: current_user)
      .permit!

    params.require(:topic).permit(:name)
      .merge(creator: current_user, first_post_attributes: first_post_params)
      .permit!
  end
end
