require 'rails_helper'

RSpec.feature 'User edit topic content', type: :feature do
  let(:category) { create(:category) }
  let(:user) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :moderator, manage: category) }

  context 'when topic is locked' do
    let(:topic) { create(:topic, :locked, category: category) }
    let!(:reply) { create(:post, topic: topic, creator: admin) }

    scenario 'no one can edit the topic' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Edit')
    end
  end

  context 'when topic is deleted' do
    let(:topic) { create(:topic, :deleted, category: category) }
    let!(:reply) { create(:post, topic: topic, creator: admin) }

    scenario 'no one can edit the topic' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Edit')
    end
  end

  context 'when topic is opening' do
    let(:topic) { create(:topic, category: category, creator: user) }

    scenario 'user can edit their own topic' do
      sign_in_as(user.email)
      visit topic_path(topic)

      expect(page).to have_link('Edit', href: edit_topic_path(topic))

      click_link 'Edit', href: edit_topic_path(topic)
      within 'form' do
        fill_in 'Content', with: 'new topic content'
        click_button 'Save topic'
      end

      expect(page).to have_content('new topic content')
    end

    scenario 'admin can edit the topic name' do
      sign_in_as(admin.email)
      visit topic_path(topic)
      click_link 'Edit', href: edit_topic_path(topic)
      within 'form' do
        fill_in 'Name', with: 'new topic name'
        click_button 'Save topic'
      end

      expect(page).to have_content('new topic name')
    end
  end
end
