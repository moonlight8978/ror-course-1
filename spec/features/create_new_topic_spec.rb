require 'rails_helper'

RSpec.feature 'Create new topic', type: :feature do
  let!(:category) { create(:category) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:user) { create(:user) }

  context 'when banned users trying to create new topic' do
    it_behaves_like 'feature_forbidden', proc {
      sign_in_as(banned_user.email)
      visit new_category_topic_path(category)
    }
  end

  context 'when user is not banned' do
    before do
      sign_in_as(user.email)
      visit category_path(category)
      click_link 'New topic'
    end

    scenario 'user try to create invalid topic' do
      within 'form' do
        fill_in 'Name', with: 'a topic name'
        attach_file 'topic_first_post_attributes_images',
          get_attachment_path('racecar.jpg')
        click_button 'Create topic'
      end

      expect(page.body).to match(/Topic content is required/)
      expect(page.body).to match(/size must be less than 1MB/)
    end

    scenario 'user create topic successfully' do
      within 'form' do
        fill_in 'Name', with: 'a topic name'
        fill_in 'Content', with: 'topic content'
        attach_file 'topic_first_post_attributes_images',
          get_attachment_path('favicon.ico')
        click_button 'Create topic'
      end

      expect(page).to have_current_path(topic_path(Topic.last))
      expect(page).to have_content('a topic name')
      expect(page).to have_content('topic content')
    end
  end
end
