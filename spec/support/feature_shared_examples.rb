RSpec.shared_examples 'feature_require_authentication' do |behavior|
  # TODO: Change to redirect to sign_in_path
  scenario 'raise error' do
    expect { instance_eval(&behavior) }
      .to raise_error(ApplicationController::Unauthenticated)
  end
end

RSpec.shared_examples 'feature_guest_only' do |behavior|
  let(:user) { create(:user) }

  before { sign_in_as(user.email) }

  scenario 'redirect to home page' do
    instance_eval(&behavior)
    expect(page.current_path).to eq(root_path)
  end
end
