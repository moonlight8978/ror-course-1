require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }

  describe '#has_role?' do
    context 'with admin' do
      it 'return true for role admin' do
        expect(admin).to have_role(:admin)
      end

      it 'return true for role moderator' do
        expect(admin).to have_role(:moderator)
      end

      it 'return true for role user' do
        expect(admin).to have_role(:user)
      end
    end

    context 'with moderator' do
      it 'return false for role admin' do
        expect(moderator).not_to have_role(:admin)
      end

      it 'return true for role moderator' do
        expect(moderator).to have_role(:moderator)
      end

      it 'return true for role user' do
        expect(moderator).to have_role(:user)
      end
    end

    context 'with normal user user' do
      it 'return false for role admin' do
        expect(user).not_to have_role(:admin)
      end

      it 'return false for role moderator' do
        expect(user).not_to have_role(:moderator)
      end

      it 'return true for role user' do
        expect(user).to have_role(:user)
      end
    end
  end

  describe '#can_manage_category?' do
    let(:category) { create(:category) }

    context 'admin' do
      it 'returns false' do
        expect(admin).not_to be_can_manage_category(category)
      end
    end

    context 'category manager' do
      let!(:management) do
        create(:category_management, manager: moderator, category: category)
      end

      it 'returns true' do
        expect(moderator).to be_can_manage_category(category)
      end
    end
  end

  describe '#can_interact_with_category?' do
    let(:category) { create(:category) }

    context 'with not banned user' do
      it 'returns true' do
        expect(user).to be_can_interact_with_category(category)
      end
    end

    context 'with banned user' do
      before { create(:category_banning, user: user, category: category) }

      it 'returns true' do
        expect(user).not_to be_can_interact_with_category(category)
      end
    end
  end
end
