require 'rails_helper'

RSpec.feature 'Visit a topic', type: :feature do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:admin) { create(:user, :admin) }

  context 'when topic is deleted' do
    context 'when guest visit' do
      it_behaves_like 'feature_forbidden', proc {
        visit topic_path(deleted_topic)
      }
    end

    context 'when normal user visit' do
      it_behaves_like 'feature_forbidden', proc {
        sign_in_as(user.email)
        visit topic_path(deleted_topic)
      }
    end

    context 'when banned user visit' do
      it_behaves_like 'feature_forbidden', proc {
        sign_in_as(banned_user.email)
        visit topic_path(deleted_topic)
      }
    end

    context 'when moderator visit' do
      it_behaves_like 'feature_forbidden', proc {
        sign_in_as(moderator.email)
        visit topic_path(deleted_topic)
      }
    end

    context 'when manager or admin visit' do
      before do
        sign_in_as(manager.email)
        visit topic_path(deleted_topic)
      end

      scenario 'can see the topic page' do
        expect(page).to have_content(deleted_topic.first_post.content)
      end
    end
  end

  context 'when topic is visible' do
    let!(:posts) { create_list(:post, 3, topic: topic) }
    let!(:deleted_post) { create(:post, :deleted, topic: topic) }

    context 'when banned user visits' do
      it_behaves_like 'feature_forbidden', proc {
        sign_in_as(banned_user.email)
        visit topic_path(topic)
      }
    end

    context 'when member visits' do
      before do
        sign_in_as(user.email)
        visit topic_path(topic)
      end

      scenario 'sees the topic title' do
        expect(page).to have_content(topic.name)
      end

      scenario 'sees the posts includes first post and deleted post' do
        expect(page).to have_css('.post-list-item', count: 5)
      end

      scenario 'sees the deleted post message' do
        expect(page).to have_content('Post has been deleted')
      end

      scenario 'sees the deleted post message' do
        expect(page).to have_content('Post has been deleted')
      end
    end

    context 'when manager visits' do
      before do
        sign_in_as(manager.email)
        visit topic_path(topic)
      end

      scenario 'can see the deleted post' do
        expect(page).to have_content(deleted_post.content)
        expect(page).to have_css('.badge[data-badge-caption="Deleted"]')
      end
    end
  end
end
