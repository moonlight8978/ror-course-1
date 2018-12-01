class DashboardPolicy < ApplicationPolicy
  def index?
    manage?
  end
end
