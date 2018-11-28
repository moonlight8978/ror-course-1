require 'rails_helper'

RSpec.feature 'Reply a topic', type: :feature do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:admin) { create(:user, :admin) }

  scenario 'a guest want to reply' do
    visit topic_path(topic)

    expect(page)
      .to have_css('.btn[data-tooltip="Login required"]', text: 'Reply')
    expect(page).not_to have_css("a[href='#{new_topic_post_path(topic)}']")
  end

  context 'when the topic is opening' do
    it_behaves_like 'feature_require_authentication', proc {
      visit new_topic_post_path(topic)
    }

    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(banned_user.email)
      visit new_topic_post_path(topic)
    }

    scenario 'authenticated user reply a topic' do
      sign_in_as(user.email)
      visit topic_path(topic)
      first(:link, 'Reply').click

      expect(page).to have_current_path(new_topic_post_path(topic))

      within 'form' do
        fill_in 'Content', with: 'this is a reply'
        attach_file 'post_images', get_attachment_path('icon.svg')

        click_button 'Submit reply'
      end

      expect(page.current_path).to match(%r{^/topics/\d+$})
    end
  end

  context 'when the topic is locked' do
    subject { visit new_topic_post_path(locked_topic) }

    it_behaves_like 'feature_require_authentication', proc { subject }

    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(admin.email)
      visit topic_path(locked_topic)
      first(:link, 'Reply').click
    }
  end

  context 'when the topic is deleted' do
    subject { visit new_topic_post_path(deleted_topic) }

    it_behaves_like 'feature_require_authentication', proc { subject }

    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(admin.email)
      visit topic_path(deleted_topic)
      first(:link, 'Reply').click
    }
  end
end
