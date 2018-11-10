require 'rails_helper'

RSpec.feature 'User visits home page', type: :feature do
  let!(:categories) { create_list(:category, 3) }
  let!(:topic) { create(:topic, category: categories.first, name: 'Topic 1') }

  scenario 'user can visit the category page' do
    visit root_path

    expect(page).to have_css('.category-list-item', count: 3)
    expect(page).to have_content(categories.first.name)
  end

  scenario 'user can see the last topic of each categories' do
    visit root_path

    expect(page).to have_content('Topic 1')
    expect(page).to have_content(topic.creator.username)
  end
end
