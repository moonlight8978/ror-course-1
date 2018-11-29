require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:category) { create(:category) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:topic) { create(:topic, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }

  describe 'POST /topics/:topic_id/posts' do
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

  describe 'PUT /posts/:id' do
    let(:reply) { create(:post, topic: topic, creator: admin) }
    let(:post_params) { Hash[content: 'new content'] }
    subject { put post_path(reply), params: { post: post_params } }

    context 'when topic is deleted' do
      let(:topic) { deleted_topic }

      it_behaves_like 'request_forbidden', proc {
        sign_in_as(admin.email)
        subject
      }
    end

    context 'when topic is locked' do
      let(:topic) { locked_topic }

      it_behaves_like 'request_forbidden', proc {
        sign_in_as(admin.email)
        subject
      }
    end

    context 'when topic is opening' do
      context 'when post is deleted' do
        let(:deleted_post) do
          create(:post, :deleted, topic: topic, creator: admin)
        end
        let(:reply) { deleted_post }

        it_behaves_like 'request_forbidden', proc {
          sign_in_as(admin.email)
          subject
        }
      end

      context 'when post is visible' do
        let(:reply) { create(:post, topic: topic, creator: user) }

        it_behaves_like 'request_require_authentication', proc { subject }

        it_behaves_like 'request_forbidden', proc {
          sign_in_as(banned_user.email)
          subject
        }

        it 'cannot be edited by other visitors' do
          sign_in_as(visitor.email)
          expect { subject }.not_to change { reply.content }
        end

        it 'can be edited by category managers' do
          sign_in_as(manager.email)
          expect { subject }.to change { reply.reload.content }
        end

        it 'can be edited by admin' do
          sign_in_as(admin.email)
          expect { subject }.to change { reply.reload.content }
        end

        it 'can be edited by creator' do
          sign_in_as(user.email)
          expect { subject }.to change { reply.reload.content }
        end
      end
    end
  end
end
