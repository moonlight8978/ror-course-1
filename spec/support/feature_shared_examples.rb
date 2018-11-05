RSpec.shared_examples 'feature_require_authentication' do |behavior|
  # TODO: Change to redirect to sign_in_path
  scenario 'raise error' do
    expect { instance_eval(&behavior) }
      .to raise_error(ApplicationController::Unauthenticated)
  end
end
