RSpec.shared_examples 'guest_only' do |action|
  let(:user) { create(:user) }

  before { sign_in_as(user.email) }

  it 'redirect_to root_path' do
    action.call(self)
    expect(response).to redirect_to(root_path)
  end
end
