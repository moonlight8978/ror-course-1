require 'rails_helper'

RSpec.describe DashboardPolicy do
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }

  subject { described_class }

  permissions :index? do
    it 'does not grant access to guests' do
      expect(subject).not_to permit(nil)
    end

    it 'does not grant access to users' do
      expect(subject).not_to permit(user)
    end

    it 'does not grant access to moderators' do
      expect(subject).not_to permit(moderator)
    end

    it 'grants access to admins' do
      expect(subject).to permit(admin)
    end
  end
end
