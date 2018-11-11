require 'rails_helper'

RSpec.feature 'User visit category page', type: :feature do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:topics) { create_list(:topic, 13, category: category) }
  let!(:locked_topic) { create(:topic, category: category, status: :locked) }

  context 'when banned' do
    let!(:ban) { create(:category_banning, user: user, category: category) }

    before { sign_in_as(user.email) }

    scenario 'user cannot see the category' do
      visit category_path(category, page: 2)

      expect(page).not_to have_content(category.name)
    end

    scenario 'user see the unauthorized page' do
      visit category_path(category, page: 2)

      expect(page).to have_title('403 - Unauthorized | CLvOZ')
    end
  end

  context 'when not banned' do
    scenario 'user can visit the category topics' do
      visit root_path

      find_link(href: category_path(category)).click

      expect(page).to have_current_path(category_path(category))
      expect(page).to have_content(category.name)
      expect(page).to have_link(2, href: category_path(category, page: 2))
    end

    scenario 'user can visit next page' do
      visit category_path(category, page: 2)

      expect(page).to have_css('.topic-list-item', count: 4)
      expect(page).to have_content(topics[10].name)
    end

    scenario 'user sees the locked badge' do
      visit category_path(category, page: 2)

      expect(page).to have_css('.badge[data-badge-caption="Locked"]', count: 1)
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
end
