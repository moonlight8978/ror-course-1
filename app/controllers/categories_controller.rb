class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(last_topic: :creator)
  end
end
