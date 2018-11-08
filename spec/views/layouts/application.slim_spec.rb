require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  context 'when guest visits' do
    before do
      without_partial_double_verification do
        allow(view).to receive(:signed_in?).and_return(false)
      end
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
      without_partial_double_verification do
        allow(view).to receive(:signed_in?).and_return(true)
      end
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
