require 'rails_helper'

RSpec.describe TopicPolicy do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category, creator: user) }
  let(:deleted_topic) { create(:topic, :deleted, category: category) }
  let(:locked_topic) { create(:topic, :locked, category: category) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:banned_user) { create(:user, banned_from: category) }
  let(:moderator) { create(:user, :moderator) }
  let(:manager) { create(:user, :moderator, manage: category) }
  let(:admin) { create(:user, :admin) }

  subject { described_class }

  permissions :show? do
    context 'when the topic is not deleted' do
      it 'does not grant access to banned user' do
        expect(subject).not_to permit(banned_user, topic)
      end

      it 'grants access to guest' do
        expect(subject).to permit(nil, topic)
      end

      it 'grants access to moderator' do
        expect(subject).to permit(moderator, topic)
      end

      it 'grants access to admin' do
        expect(subject).to permit(admin, topic)
      end
    end

    context 'when the topic is deleted' do
      it 'does not grant access to user/guest' do
        expect(subject).not_to permit(user, deleted_topic)
      end

      it 'does not grant access to other category manager' do
        expect(subject).not_to permit(moderator, deleted_topic)
      end

      it 'grants access to category manager' do
        expect(subject).to permit(manager, deleted_topic)
      end

      it 'grants access to admin' do
        expect(subject).to permit(admin, deleted_topic)
      end
    end
  end

  permissions :update? do
    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, topic)
    end

    it 'does not grant access to user who is not poster' do
      expect(subject).not_to permit(user2, topic)
    end

    it 'does not grant access to moderator who does not manage the category' do
      expect(subject).not_to permit(moderator, topic)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(user, topic)
    end

    it 'grants access to moderator who manage the category' do
      expect(subject).to permit(manager, topic)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :destroy? do
    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, topic)
    end

    it 'does not grant access to user who is not poster' do
      expect(subject).not_to permit(user2, topic)
    end

    it 'does not grant access even to the original poster' do
      expect(subject).not_to permit(user, topic)
    end

    it 'does not grant access to moderator who does not manage the category' do
      expect(subject).not_to permit(moderator, topic)
    end

    it 'grants access to moderator who manage the category' do
      expect(subject).to permit(manager, topic)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :reply? do
    context 'when topic is deleted' do
      it 'does not grants access to all people' do
        expect(subject).not_to permit(admin, deleted_topic)
      end
    end

    context 'when topic is locked' do
      it 'does not grants access to all people' do
        expect(subject).not_to permit(admin, locked_topic)
      end
    end

    context 'when topic is opening' do
      it 'does not grants access to banned user' do
        expect(subject).not_to permit(banned_user, topic)
      end

      it 'does not grants access to guest' do
        expect(subject).not_to permit(nil, topic)
      end

      it 'grants access to normal user' do
        expect(subject).to permit(user, topic)
      end

      it 'grants access to moderator' do
        expect(subject).to permit(moderator, topic)
      end

      it 'grants access to manager' do
        expect(subject).to permit(manager, topic)
      end

      it 'grants access to admin' do
        expect(subject).to permit(admin, topic)
      end
    end
  end
end
