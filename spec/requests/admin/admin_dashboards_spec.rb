require 'rails_helper'

RSpec.describe 'Admin::Dashboards', type: :request do
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }

  describe 'GET /admin/dashboards' do
    subject { get admin_dashboards_path }

    context 'when guest request' do
      it_behaves_like 'request_require_authentication', proc { subject }
    end

    context 'when user request' do
      before { sign_in_as(user.email) }

      it_behaves_like 'request_forbidden', proc { subject }
    end

    context 'when moderator request' do
      before { sign_in_as(moderator.email) }

      it_behaves_like 'request_forbidden', proc { subject }
    end

    context 'when admin request' do
      before do
        sign_in_as(admin.email)
        subject
      end

      it 'returns successfully' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the dashboard' do
        expect(response.body).to match(/Dashboard/)
      end
    end
  end
end
