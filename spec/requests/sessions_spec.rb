require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /sign_in' do
    context 'guest' do
      it 'returns the login form' do
        get sign_in_path
        expect(response.body).to include('Sign in to continue')
      end
    end

    it_behaves_like 'request_guest_only', proc { get sign_in_path }
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

    it_behaves_like 'request_guest_only', proc { post(sign_in_path) }
  end

  describe 'GET /sign_out' do
    let(:user) { create(:user, password: '1111') }

    context 'when user signed in' do
      before { sign_in_as(user.email) }

      it 'signed out the user and redirect to login page' do
        get sign_out_path
        expect(response).to redirect_to(sign_in_path)
      end
    end

    it_behaves_like 'request_require_authentication', proc {
      get sign_out_path
    }
  end
end
