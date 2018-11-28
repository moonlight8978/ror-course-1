RSpec.shared_examples 'request_guest_only' do |request|
  let(:user) { create(:user) }

  before { sign_in_as(user.email) }

  it 'redirect_to root_path' do
    instance_eval(&request)
    expect(response).to redirect_to(root_path)
  end
end

RSpec.shared_examples 'request_require_authentication' do |request|
  it 'raise error' do
    expect { instance_eval(&request) }
      .to raise_error(ApplicationController::Unauthenticated)
  end
end

RSpec.shared_examples 'request_forbidden' do |request|
  scenario 'sees the 403 forbidden page' do
    instance_eval(&request)
    expect(response).to have_http_status(:forbidden)
  end
end
