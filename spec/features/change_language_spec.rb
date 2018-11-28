require 'rails_helper'

RSpec.feature 'User change app language', type: :feature do
  before { page.driver.header 'Accept-Language', 'en' }

  scenario 'user want to change language to japanese' do
    visit root_path

    expect(page)
      .to have_css('#languageSwitcher .current-language', text: 'English')

    click_link '日本語', href: languages_path(locale: :ja)

    expect(page)
      .to have_css('#languageSwitcher .current-language', text: '日本語')
  end
end
