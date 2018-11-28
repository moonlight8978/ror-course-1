require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:category) { create(:category) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:topic) { create(:topic, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }

  describe 'POST topics/:topic_id/posts' do
    let(:post_params) do
      Hash[
        content: 'topic content',
        images: get_attachment('favicon.ico', 'image/ico')
      ]
    end

    context 'when topic is opening' do
      subject { post topic_posts_path(topic), params: { post: post_params } }

      it_behaves_like 'request_require_authentication', proc { subject }

      it_behaves_like 'request_forbidden', proc {
        sign_in_as(banned_user.email)
        subject
      }

      context 'when non-banned user make request' do
        before { sign_in_as(user.email) }

        it 'creates a new reply' do
          expect { subject }.to change { topic.posts.count }.by(1)
        end
      end
    end

    context 'when topic is locked' do
      subject do
        post topic_posts_path(locked_topic), params: { post: post_params }
      end

      before { sign_in_as(admin.email) }

      it 'no one can reply the topic' do
        expect { subject }.not_to change { topic.posts.count }
      end
    end

    context 'when topic is deleted' do
      subject do
        post topic_posts_path(deleted_topic), params: { post: post_params }
      end

      before { sign_in_as(admin.email) }

      it 'no one can reply the topic' do
        expect { subject }.not_to change { topic.posts.count }
      end
    end
  end
end
