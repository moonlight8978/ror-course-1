require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'GET /categories' do
    before('@create_list') { @categories = create_list(:category, 2) }
    before { get root_path }

    it 'render successfully' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the home page' do
      expect(response.body).to include('<span class="breadcrumb">Home</span>')
    end

    it 'return the categories', create_list: true do
      expect(response.body).to include(@categories[0].name)
      expect(response.body).to include(@categories[1].name)
    end
  end
end
