require 'rails_helper'

RSpec.describe PostPolicy do
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let(:category) { create(:category) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:admin) { create(:user, :admin) }
  let(:topic) { create(:topic, category: category, creator: user) }
  let(:banned_user_post) { create(:post, topic: topic, creator: banned_user) }
  let(:visible_post) { create(:post, topic: topic, creator: user) }
  let(:deleted_post) { create(:post, :deleted, topic: topic, creator: user) }

  subject { described_class }

  permissions :show? do
    context 'when post is visible' do
      it 'does not grants access to banned user' do
        expect(subject).not_to permit(banned_user, visible_post)
      end

      it 'grants access to whom not be banned' do
        expect(subject).to permit(user, visible_post)
      end
    end

    context 'when post has been deleted' do
      it 'does not grant access to moderator' do
        expect(subject).not_to permit(moderator, deleted_post)
      end

      it 'does not grant access to normal users' do
        expect(subject).not_to permit(user, deleted_post)
      end

      it 'does not grant access to guests' do
        expect(subject).not_to permit(nil, deleted_post)
      end

      it 'does not grant access to banned users' do
        expect(subject).not_to permit(banned_user, deleted_post)
      end

      it 'grants access to admin' do
        expect(subject).to permit(admin, deleted_post)
      end

      it 'grants access to manager' do
        expect(subject).to permit(manager, deleted_post)
      end
    end
  end

  permissions :update? do
    it 'does not grant access to banned users' do
      expect(subject).not_to permit(banned_user, banned_user_post)
    end

    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, visible_post)
    end

    context 'when topic is opening and visible' do
      it 'does not grant access to other' do
        expect(subject).not_to permit(visitor, visible_post)
      end

      it 'does not grant access to other moderators' do
        expect(subject).not_to permit(moderator, visible_post)
      end

      it 'grants access to category managers' do
        expect(subject).to permit(manager, visible_post)
      end

      it 'grants access to admin' do
        expect(subject).to permit(admin, visible_post)
      end

      it 'grants access to creator' do
        expect(subject).to permit(user, visible_post)
      end
    end

    context 'when topic is locked' do
      let(:topic) { create(:topic, :locked, category: category) }

      it 'does not even grant access to admin' do
        expect(subject).not_to permit(admin, visible_post)
      end
    end

    context 'when topic is deleted' do
      let(:topic) { create(:topic, :deleted, category: category) }

      it 'does not even grant access to admin' do
        expect(subject).not_to permit(admin, visible_post)
      end
    end

    context 'when post is deleted' do
      it 'does not even grant access to admin' do
        expect(subject).not_to permit(admin, deleted_post)
      end
    end
  end
end
