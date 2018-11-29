require 'rails_helper'

RSpec.feature 'User edit reply', type: :feature do
  let(:category) { create(:category) }
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:topic) { create(:topic, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }
  let!(:reply) { create(:post, topic: topic, creator: user) }
  let(:deleted_reply) { create(:post, :deleted, topic: topic, creator: user) }

  it_behaves_like 'feature_require_authentication', proc {
    visit edit_post_path(reply)
  }

  context 'when topic is locked' do
    let(:topic) { locked_topic }

    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(admin.email)
      visit edit_post_path(reply)
    }

    scenario 'even admin cannot see the edit button' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Edit', href: edit_post_path(reply))
    end
  end

  context 'when topic is deleted' do
    let(:topic) { deleted_topic }

    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(admin.email)
      visit edit_post_path(reply)
    }

    scenario 'even admin cannot see the edit button' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Edit', href: edit_post_path(reply))
    end
  end

  context 'when topic is opening' do
    context 'when post is deleted' do
      let!(:reply) { deleted_reply }

      it_behaves_like 'feature_forbidden', proc {
        sign_in_as(admin.email)
        visit edit_post_path(reply)
      }
    end

    context 'when post is visible' do
      scenario 'creator can edit the post' do
        sign_in_as(user.email)
        visit topic_path(topic)

        expect(page).to have_link('Edit', href: edit_post_path(reply))

        click_link('Edit', href: edit_post_path(reply))

        expect(page).to have_field('Content', with: reply.content)

        within 'form' do
          fill_in 'Content', with: 'new content'
          click_button 'Submit reply'
        end

        expect(page).to have_content('new content')
      end
    end
  end
end
