class TestController < ApplicationController
  def index
    render file: 'public/404.slim'
  end
end
