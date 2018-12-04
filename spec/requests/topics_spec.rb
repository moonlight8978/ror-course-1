require 'rails_helper'

RSpec.describe 'Topics', type: :request do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category, creator: user) }
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
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

  describe 'PUT /topics/:id' do
    let(:topic_params) do
      Hash[
        name: 'new name',
        first_post_attributes: {
          content: 'new content',
          id: topic.first_post.id
        }
      ]
    end

    subject { put topic_path(topic), params: { topic: topic_params } }

    context 'when topic is locked' do
      let(:locked_topic) do
        create(:topic, :locked, category: category, creator: user)
      end
      let(:topic) { locked_topic }

      before { sign_in_as(admin.email) }

      it_behaves_like 'request_forbidden', proc { subject }

      it 'does not change the topic' do
        expect { subject }.not_to change { topic.first_post.reload.content }
      end
    end

    context 'when topic is deleted' do
      let(:deleted_topic) do
        create(:topic, :deleted, category: category, creator: user)
      end
      let(:topic) { deleted_topic }

      before { sign_in_as(admin.email) }

      it_behaves_like 'request_forbidden', proc { subject }

      it 'does not change the topic' do
        expect { subject }.not_to change { topic.first_post.reload.content }
      end
    end

    context 'when topic is opening' do
      context 'when guest send request' do
        it_behaves_like 'request_require_authentication', proc { subject }
      end

      context 'when banned user send request' do
        before { sign_in_as(banned_user.email) }

        it_behaves_like 'request_forbidden', proc { subject }

        it 'does not change the topic' do
          expect { subject }.not_to change { topic.first_post.reload.content }
        end
      end

      context 'when visitor send request' do
        before { sign_in_as(visitor.email) }

        it_behaves_like 'request_forbidden', proc { subject }

        it 'does not change the topic' do
          expect { subject }.not_to change { topic.first_post.reload.content }
        end
      end

      context 'when moderator send request' do
        before { sign_in_as(moderator.email) }

        it_behaves_like 'request_forbidden', proc { subject }

        it 'does not change the topic' do
          expect { subject }.not_to change { topic.first_post.reload.content }
        end
      end

      context 'when creator send request' do
        before { sign_in_as(user.email) }

        it 'change the topic content' do
          expect { subject }.to change { topic.first_post.reload.content }
        end

        it 'does not change the topic name' do
          expect { subject }.not_to change { topic.reload.name }
        end
      end

      context 'when manager send request' do
        before { sign_in_as(manager.email) }

        it 'change the topic content' do
          expect { subject }.to change { topic.first_post.reload.content }
        end

        it 'does not change the topic name' do
          expect { subject }.to change { topic.reload.name }
        end
      end

      context 'when admin send request' do
        before { sign_in_as(admin.email) }

        it 'change the topic content' do
          expect { subject }.to change { topic.first_post.reload.content }
        end

        it 'does not change the topic name' do
          expect { subject }.to change { topic.reload.name }
        end
      end
    end
  end
end
