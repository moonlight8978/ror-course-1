require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'GET /sign_up' do
    context 'when not signed in' do
      before { get sign_up_path }

      it 'return the sign up form' do
        expect(response.body).to include('Create CLvOZ account')
      end
    end

    it_behaves_like 'request_guest_only', proc { get sign_up_path }
  end

  describe 'POST /signup' do
    context 'when not signed in' do
      let(:user) { build(:user) }

      subject { post sign_up_path, params: { user: registration_params } }

      context 'with invalid params' do
        let(:registration_params) { Hash[password: '1111', email: user.email] }

        it 'does not make any changes' do
          expect { subject }.not_to change { User.count }
        end

        it 're-render the form' do
          subject
          expect(response.body).to include('Create CLvOZ account')
        end
      end

      context 'with valid params' do
        let(:registration_params) do
          Hash[
            username: user.username, email: user.email,
            password: '1111', password_confirmation: '1111'
          ]
        end

        it 'create new user' do
          expect { subject }.to change { User.count }.by(1)
        end

        it 'redirect to home page' do
          subject
          expect(response).to redirect_to(root_path)
        end
      end
    end

    it_behaves_like 'request_guest_only', proc { post sign_up_path }
  end
end
