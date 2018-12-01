module Admin
  class DashboardsController < ApplicationController
    layout 'admin'

    before_action :authenticate_user!

    def index
      authorize :dashboard
      @statistics = NewItemsStatisticsService.perform
    end
  end
end
