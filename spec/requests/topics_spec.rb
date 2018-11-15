require 'rails_helper'

RSpec.describe 'Topics', type: :request do
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }
  let(:topic) { create(:topic) }
  let!(:visible_post) { create(:post, topic: topic) }
  let!(:deleted_post) { create(:post, :deleted, topic: topic) }
  let(:category) { visible_post.category }

  describe 'GET /topics/:id' do
    context 'when banned user request' do
      let!(:ban) { create(:category_banning, user: user, category: category) }

      before do
        sign_in_as(user.email)
        get topic_path(topic)
      end

      it 'does not process the request' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when non-banned user request' do
      before { get topic_path(topic) }

      it 'accepts the request' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the topic name' do
        expect(response.body).to include(topic.name)
      end

      it 'returns the visible posts' do
        expect(response.body).to include(visible_post.content)
      end

      context 'when guest or normal user request' do
        it 'returns the deleted message' do
          expect(response.body).to include('Post has been deleted')
        end
      end
    end
  end
end
