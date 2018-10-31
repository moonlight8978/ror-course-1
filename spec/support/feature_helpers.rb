module FeatureHelpers
  def sign_in_as(email, password = '1111')
    visit sign_in_path

    within 'form' do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end
  end
end
