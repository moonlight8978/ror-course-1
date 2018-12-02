require 'rails_helper'

RSpec.feature 'User delete a reply', type: :feature do
  let(:category) { create(:category) }
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:admin) { create(:user, :admin) }
  let(:opening_topic) { create(:topic, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }

  context 'when topic is locked' do
    let(:topic) { locked_topic }
    let!(:reply) { create(:post, topic: topic, creator: user) }

    scenario 'there is no delete button to delete the post' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Delete', href: post_path(reply))
    end
  end

  context 'when topic is deleted' do
    let(:topic) { deleted_topic }
    let!(:reply) { create(:post, topic: topic, creator: user) }

    scenario 'there is no delete button to delete the post' do
      sign_in_as(admin.email)
      visit topic_path(topic)

      expect(page).not_to have_link('Delete', href: post_path(reply))
    end
  end

  context 'when topic is open' do
    # rubocop:disable Metrics/LineLength
    let(:topic) { opening_topic }
    let!(:deleted_reply) { create(:post, :deleted, topic: topic, creator: user) }
    let!(:replies) { create_list(:post, 10, topic: topic, creator: user) }
    let!(:prev_reply) { create(:post, content: 'qwe', topic: topic, creator: user) }
    let!(:reply) { create(:post, content: 'abc', topic: topic, creator: user) }
    # rubocop:enable Metrics/LineLength

    scenario 'user can delete the reply' do
      sign_in_as(user.email)
      visit category_path(category)

      expect(page).to have_content('abc')

      click_link(topic.name, href: topic_path(topic))
      first(:link, href: topic_path(topic, page: 2)).click

      expect(page).to have_content('abc')
      expect(page).to have_link('Delete', href: post_path(reply))

      click_link('Delete', href: post_path(reply))

      expect(page).not_to have_content('abc')
      expect(page).to have_content('Post has been deleted')

      click_link(category.name, href: category_path(category))

      expect(page).not_to have_content('abc')
      expect(page).to have_content('qwe')
    end

    scenario 'manager can delete the user reply' do
      sign_in_as(manager.email)
      visit topic_path(topic)

      within '.post-list-item:nth-child(2)' do
        expect(page).to have_css('.badge.red')
        expect(page).to have_content(deleted_reply.content)
        expect(page).not_to have_link('Delete')
      end

      within '.post-list-item:nth-child(3)' do
        expect(page).not_to have_css('.badge.red')
      end

      click_link 'Delete', href: post_path(replies.first)

      within '.post-list-item:nth-child(3)' do
        expect(page).to have_css('.badge.red')
        expect(page).not_to have_link('Delete')
      end
    end
  end
end
