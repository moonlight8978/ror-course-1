require 'rails_helper'

RSpec.feature 'User sign in and sign out', type: :feature do
  let(:user) { create(:user, password: '1111') }

  feature 'Sign in' do
    context 'Has not signed in yet' do
      scenario 'Show error if email or password is invalid' do
        visit sign_in_path
        within 'form' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '2222'
          click_button 'Sign in'
        end
        expect(page.current_path).to eq sign_in_path
        expect(page).to have_css '.helper-text[data-error="Wrong password"]'
      end

      scenario 'Sign in successfully with correct email and password' do
        visit sign_in_path
        within 'form' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '1111'
          click_button 'Sign in'
        end
        expect(page.current_path).to eq root_path
      end
    end

    context 'Has been already signed in' do
      scenario 'Redirect to root path' do
        sign_in_as(user.email)
        visit sign_in_path
        expect(page.current_path).to eq root_path
      end
    end
  end

  feature 'Sign out' do
    # TODO: signout acceptance test
  end
end
