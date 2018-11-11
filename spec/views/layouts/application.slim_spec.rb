require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  let(:user) { create(:user) }

  before { mock_policy(user) }

  context 'when guest visits' do
    before do
      mock_authentication(false)
      render
    end

    it 'does not render the user settings dropdown' do
      expect(rendered).not_to have_css('#userSettingsDropdown')
    end

    it 'does not render the user utilities menu' do
      expect(rendered).not_to have_css('#userNavUtils')
    end

    it 'renders the guest utilities menu' do
      expect(rendered).to have_css('#guestNavUtils')
    end
  end

  context 'when user is already signed in' do
    before do
      mock_authentication(true)
      render
    end

    it 'does not render the guest utilities menu' do
      expect(rendered).not_to have_css('#guestNavUtils')
    end

    it 'renders the user settings dropdown' do
      expect(rendered).to have_css('#userSettingsDropdown')
    end

    it 'renders the user utilities menu' do
      expect(rendered).to have_css('#userNavUtils')
    end
  end
end
