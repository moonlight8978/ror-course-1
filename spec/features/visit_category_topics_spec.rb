require 'rails_helper'

RSpec.feature 'User visit category page', type: :feature do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:deleted_topic) { create(:topic, :deleted, category: category) }
  let!(:locked_topic) { create(:topic, :locked, category: category) }
  let!(:topics) { create_list(:topic, 13, category: category) }

  context 'when user is banned' do
    let!(:ban) { create(:category_banning, user: user, category: category) }

    before { sign_in_as(user.email) }

    scenario 'user is restricted to the category' do
      visit category_path(category)

      expect(page).not_to have_content(category.name)
      expect(page).to have_title('403 - Forbidden | CLvOZ')
    end
  end

  context 'when user is not banned' do
    scenario 'user can visit the category topics' do
      visit root_path

      find_link(href: category_path(category)).click

      expect(page).to have_current_path(category_path(category))
      expect(page).to have_content(category.name)
      expect(page).to have_link(2, href: category_path(category, page: 2))
    end

    scenario 'user sees the locked badge' do
      visit category_path(category)

      expect(page).to have_css('.badge[data-badge-caption="Locked"]', count: 1)
    end

    scenario 'user sees the deleted topic' do
      visit category_path(category)

      expect(page).to have_content('Topic has been deleted')
    end

    scenario 'user can visit next page' do
      visit category_path(category, page: 2)

      expect(page).to have_css('.topic-list-item', count: 5)
    end

    context 'when not signed in' do
      scenario 'see the button with authentication message' do
        visit category_path(category)

        expect(page).to have_css('button[data-tooltip="Login required"]')
      end
    end

    context 'when signed in' do
      scenario 'can see the link to create new topic' do
        sign_in_as(user.email)
        visit category_path(category)

        expect(page)
          .to have_css("a[href='#{new_category_topic_path(category)}']")
      end
    end
  end

  context 'when manager visits' do
    let(:manager) { create(:user, :moderator) }

    before do
      create(:category_management, category: category, manager: manager)
      sign_in_as(manager.email)
    end

    scenario 'manager can see the content of deleted topic with badge' do
      visit category_path(category)

      expect(page).to have_content(deleted_topic.name)
      expect(page).to have_css('.badge[data-badge-caption="Deleted"]')
    end
  end
end
