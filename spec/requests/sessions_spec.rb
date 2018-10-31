require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /sign_in' do
    context 'guest' do
      it 'returns the login form' do
        get sign_in_path
        expect(response.body).to include('Sign in to continue')
      end
    end

    it_behaves_like 'guest_only', lambda { |request|
      request.get request.sign_in_path
    }
  end

  describe 'POST /sign_in' do
    let(:user) { create(:user, password: '1111') }

    context 'guest' do
      context 'invalid email or password' do
        let(:login_params) { Hash[email: user.email, password: '2222'] }

        it 'login failed and show the login form' do
          post sign_in_path, params: { user: login_params }
          expect(response.body).to include('Sign in to continue')
        end

        it 'not redirect' do
          post sign_in_path, params: { user: login_params }
          expect(response).to_not redirect_to(root_path)
        end
      end

      context 'credentials are valid' do
        let(:login_params) { Hash[email: user.email, password: '1111'] }

        it 'login success and redirect to root_path' do
          post sign_in_path, params: { user: login_params }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    it_behaves_like 'guest_only', lambda { |request|
      request.post request.sign_in_path
    }
  end
end
