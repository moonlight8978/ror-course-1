class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(last_topic: :creator).order(id: :asc)
  end

  def show
    @category = Category.find(params[:id])
    authorize @category
    @topics = @category.topics
      .includes(:creator, :first_post, last_post: :creator)
      .order(created_at: :desc)
      .page(params[:page])
  end
end
