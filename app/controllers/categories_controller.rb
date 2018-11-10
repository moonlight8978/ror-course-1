class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(last_topic: :creator)
  end

  def show
    @category = Category.find(params[:id])
    authorize @category
    @topics = @category.topics
      .includes(:creator, :first_post, last_post: :creator)
      .page(params[:page])
  end
end
