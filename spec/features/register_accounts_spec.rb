require 'rails_helper'

RSpec.feature 'User register new account', type: :feature do
  let(:user) { build(:user) }

  context 'guest' do
    context 'without email' do
      scenario 'stay at sign up page and show errors' do
        visit sign_up_path

        within 'form' do
          fill_in 'Username', with: user.username
          fill_in 'Password', with: '1111'
          click_button 'Sign up'
        end

        expect(page.current_path).to eq(sign_up_path)
        expect(page).to have_css('.helper-text[data-error="Email is required"]')
      end
    end

    context 'with valid informations' do
      scenario 'create account successfully and redirect to home page' do
        visit sign_up_path

        within 'form' do
          fill_in 'Email', with: user.email
          fill_in 'Username', with: user.username
          fill_in 'Password', with: '1111'
          fill_in 'Password confirmation', with: '1111'
          click_button 'Sign up'
        end

        expect(page.current_path).to eq(root_path)
      end
    end
  end

  it_behaves_like 'feature_guest_only', proc { visit sign_up_path }
end
