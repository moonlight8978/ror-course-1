require 'rails_helper'

RSpec.describe TopicPolicy do
  let(:category) { create(:category) }
  let(:topic) { create(:topic, category: category, creator: user) }
  let(:post) { topic.posts.first }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }

  subject { described_class }

  permissions :read? do
    it 'does not grant access to banned user' do
      expect(user).to receive(:can_interact_with_category?).with(category)
        .and_return(false)
      expect(subject).not_to permit(user, post)
    end

    it 'grants access to guest' do
      expect(subject).to permit(nil, post)
    end

    it 'grants access to moderator' do
      expect(subject).to permit(moderator, post)
    end

    it 'grants access to admin' do
      expect(subject).to permit(admin, post)
    end
  end

  permissions :create? do
    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, post)
    end

    it 'does not grant access to banned user' do
      expect(user).to receive(:can_interact_with_category?).with(category)
        .and_return(false)
      expect(subject).not_to permit(user, post)
    end

    it 'grants access to not banned user' do
      expect(subject).to permit(user, post)
    end

    it 'grants access to moderator' do
      expect(subject).to permit(moderator, post)
    end

    it 'grants access to admin' do
      expect(subject).to permit(admin, post)
    end
  end

  permissions :update? do
    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, post)
    end

    it 'does not grant access to user who is not poster' do
      expect(subject).not_to permit(user2, post)
    end

    it 'does not grant access to moderator who does not manage the category' do
      expect(moderator).to receive(:can_manage_category?).with(post.category)
        .and_return(false)
      expect(subject).not_to permit(moderator, post)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(user, post)
    end

    it 'grants access to moderator who manage the category' do
      expect(moderator).to receive(:can_manage_category?).with(post.category)
        .and_return(true)
      expect(subject).to permit(moderator, post)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(admin, post)
    end
  end

  permissions :destroy? do
    it 'does not grant access to guest' do
      expect(subject).not_to permit(nil, post)
    end

    it 'does not grant access to user who is not poster' do
      expect(subject).not_to permit(user2, post)
    end

    it 'does not grant access even to the original poster' do
      expect(subject).not_to permit(user, post)
    end

    it 'does not grant access to moderator who does not manage the category' do
      expect(moderator).to receive(:can_manage_category?).with(post.category)
        .and_return(false)
      expect(subject).not_to permit(moderator, post)
    end

    it 'grants access to moderator who manage the category' do
      expect(moderator).to receive(:can_manage_category?).with(post.category)
        .and_return(true)
      expect(subject).to permit(moderator, post)
    end

    it 'grants access to the original poster' do
      expect(subject).to permit(admin, post)
    end
  end
end
