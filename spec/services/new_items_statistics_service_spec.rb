require 'rails_helper'

RSpec.describe NewItemsStatisticsService do
  let(:today) { Date.new(2018, 12, 10) }

  def mock_today
    allow(Date).to receive(:current).and_return(today)
  end

  describe '#today' do
    before { mock_today }

    it 'returns current month' do
      expect(described_class.send(:this_month))
        .to eq((Date.new(2018, 12, 1)..Date.new(2018, 12, 31)))
    end
  end

  describe '#perform' do
    context 'when calculate statistics of this month' do
      # rubocop:disable Metrics/LineLength
      let!(:u1) { create(:user, created_at: today - 1.month) }
      let!(:us) { create_list(:user, 5, created_at: today) }
      let!(:t1) { create(:topic, creator: u1, created_at: today - 1.month) }
      let!(:ts) { create_list(:topic, 5, creator: u1, created_at: today) }
      let!(:p1) { create(:post, creator: u1, topic: t1, created_at: today - 1.month) }
      let!(:ps) { create_list(:post, 5, creator: u1, topic: t1, created_at: today) }
      # rubocop:enable Metrics/LineLength

      subject { described_class.perform }

      before { mock_today }

      it 'returns users count created this month' do
        expect(subject.new_users_count).to eq(5)
      end

      it 'returns topics count created this month' do
        expect(subject.new_topics_count).to eq(5)
      end

      it 'returns posts count created this month' do
        expect(subject.new_posts_count).to eq(5)
      end
    end

    context 'when calculate statistics in specific time' do
      # rubocop:disable Metrics/LineLength
      let(:time) { (Date.current.at_beginning_of_day..Date.current.at_end_of_day) }
      let!(:u1) { create(:user, created_at: today.yesterday) }
      let!(:us) { create_list(:user, 5, created_at: today) }
      let!(:t1) { create(:topic, creator: u1, created_at: today.yesterday) }
      let!(:ts) { create_list(:topic, 5, creator: u1, created_at: today) }
      let!(:p1) { create(:post, creator: u1, topic: t1, created_at: today.yesterday) }
      let!(:ps) { create_list(:post, 5, creator: u1, topic: t1, created_at: today) }
      # rubocop:enable Metrics/LineLength

      subject { described_class.perform(time) }

      before { mock_today }

      it 'returns users count created today' do
        expect(subject.new_users_count).to eq(5)
      end

      it 'returns topics count created today' do
        expect(subject.new_topics_count).to eq(5)
      end

      it 'returns posts count created today' do
        expect(subject.new_posts_count).to eq(5)
      end
    end
  end
end
