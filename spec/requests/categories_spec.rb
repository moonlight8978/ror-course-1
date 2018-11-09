require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:user) { create(:user) }

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

  describe 'GET /categories/:id' do
    let(:category) { create(:category) }
    let!(:banned) { create(:category_banning, category: category, user: user) }

    context 'banned user' do
      before do
        sign_in_as(user.email)
        get category_path(category)
      end

      it 'does not returns the category' do
        expect(response.body).not_to include(category.name)
      end

      it 'returns the unauthorized page' do
        expect(response.body).to include('403 - Unauthorized')
      end
    end

    context 'guest' do
      let!(:topics) { create_list(:topic, 2, category: category) }

      before { get category_path(category) }

      it 'returns the category' do
        expect(response.body).to include(category.name)
      end

      it 'returns the topics' do
        expect(response.body).to include(topics[0].name)
        expect(response.body).to include(topics[1].name)
      end
    end
  end
end
