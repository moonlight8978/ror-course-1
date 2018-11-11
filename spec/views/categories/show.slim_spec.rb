require 'rails_helper'

RSpec.describe 'categories/show', type: :view do
  let(:category) { create(:category) }
  let(:topics) { create_list(:topic, 5, category: category) }
  let(:user) { create(:user) }
  let(:manager) { create(:user, :admin) }

  before { assign(:category, category) }

  describe 'breadcrumbs' do
    before do
      mock_authentication(false)
      paginate([])
    end

    it 'shows the category name' do
      render
      expect(view.content_for(:breadcrumbs))
        .to have_css('span.breadcrumb', text: category.name)
    end
  end

  describe 'topic list' do
    before { mock_authentication(true) }

    context 'when there are no topics' do
      before { paginate([]) }

      it 'shows the placeholder' do
        render
        expect(rendered).to have_content('No topics')
      end
    end

    context 'when topic list are not empty' do
      let!(:posts) { create_list(:post, 3, topic: topics[0]) }

      before do
        assign(:topics, paginate(topics))
        mock_policy(user)
        render
      end

      it 'shows topics' do
        expect(rendered).to have_css('.topic-list-item', count: 5)
      end

      it 'shows the replies count' do
        expect(rendered)
          .to have_css('.topic-list-item:first-child .posts-count', text: 3)
      end
    end

    context 'when there is locked topic' do
      let!(:locked_topic) { create(:topic, status: :locked) }

      before do
        assign(:topics, paginate([locked_topic]))
        mock_policy(user)
        render
      end

      it 'shows the locked badge' do
        expect(rendered)
          .to have_css('.badge[data-badge-caption="Locked"]')
      end
    end

    context 'when there is deleted topic' do
      let(:topics) { create_list(:topic, 2, category: category) }
      let(:deleted_topic) { create(:topic, :deleted, category: category) }

      before { assign(:topics, paginate([*topics, deleted_topic])) }

      context 'when managers visits' do
        before do
          mock_policy(manager)
          render
        end

        it 'shows the deleted badge' do
          expect(rendered).to have_css('.badge[data-badge-caption="Deleted"]')
        end

        it 'shows the deleted topic' do
          expect(rendered).to have_content(deleted_topic.name)
        end
      end

      context 'when user or guest visits' do
        before { mock_policy(user) }

        it 'shows the deleted message' do
          render
          expect(rendered).to have_content('Topic has been deleted')
        end
      end
    end
  end

  describe 'new thread button' do
    before { paginate([]) }

    context 'guest' do
      before do
        mock_authentication(false)
        render
      end

      it 'show the button with tooltip' do
        expect(rendered)
          .to have_css('.btn.tooltipped[data-tooltip="Login required"]')
      end
    end

    context 'signed in user' do
      before do
        mock_authentication(true)
        render
      end

      it 'show the link to create new thread' do
        expect(rendered)
          .to have_css("a[href='#{new_category_topic_path(category)}']")
      end
    end
  end
end
