require 'rails_helper'

RSpec.describe CategoryPolicy do
  let(:category) { create(:category) }
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }

  subject { described_class }

  permissions :show? do
    it 'does not grant access to banned user' do
      expect(user).to receive(:can_interact_with_category?).with(category)
        .and_return(false)
      expect(subject).not_to permit(user, category)
    end

    it 'grants access to admin' do
      expect(subject).to permit(admin, category)
    end

    it 'grants access to moderator' do
      expect(subject).to permit(moderator, category)
    end

    it 'grants access to not banned user' do
      expect(subject).to permit(user, category)
    end

    it 'grants access to guest' do
      expect(subject).to permit(nil, category)
    end
  end

  permissions :patrol? do
    it 'does not grant access to guess' do
      expect(subject).not_to permit(nil, category)
    end

    it 'does not grant access to normal user' do
      expect(subject).not_to permit(user, category)
    end

    it 'does not grant access to manager of another category' do
      expect(subject).not_to permit(moderator, category)
    end

    it 'grants access to manager' do
      expect(moderator).to receive(:can_manage_category?).with(category)
        .and_return(true)
      expect(subject).to permit(moderator, category)
    end

    it 'grants access to admin' do
      expect(subject).to permit(admin, category)
    end
  end
end
