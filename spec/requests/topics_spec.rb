require 'rails_helper'

RSpec.describe 'Topics', type: :request do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }
  let!(:visible_post) { create(:post, topic: topic) }
  let!(:deleted_post) { create(:post, :deleted, topic: topic) }

  describe 'GET /topics/:id' do
    context 'when banned user request' do
      before do
        sign_in_as(banned_user.email)
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

  describe 'POST /categories/:category_id/topics' do
    let(:topic_params) do
      Hash[
        name: 'topic name',
        first_post_attributes: {
          content: 'topic content',
          images: get_attachment('favicon.ico', 'image/ico')
        }
      ]
    end

    subject do
      post category_topics_path(category), params: { topic: topic_params }
    end

    it_behaves_like 'request_require_authentication', proc { subject }

    it_behaves_like 'request_forbidden', proc {
      sign_in_as(banned_user.email)
      subject
    }

    context 'when non-banned user send request' do
      before { sign_in_as(user.email) }

      it 'create new topic' do
        expect { subject }.to change { Topic.count }.by(1)
      end

      it 'redirect the user to new topic' do
        subject
        expect(response).to redirect_to(topic_path(Topic.last))
      end
    end
  end
end
