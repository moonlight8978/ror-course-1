require 'rails_helper'

RSpec.describe 'categories/show', type: :view do
  let(:category) { create(:category) }
  let(:topics) { create_list(:topic, 5, category: category) }

  before { assign(:category, category) }

  def mock_authentication
    without_partial_double_verification do
      allow(view).to receive(:signed_in?).and_return(false)
    end
  end

  def paginate(array = Topic.none)
    assign(:topics, Kaminari.paginate_array(array).page(1))
  end

  context 'without authentication' do
    before do
      mock_authentication
      paginate
    end

    describe 'breadcrumbs' do
      it 'shows the category name' do
        render
        expect(view.content_for(:breadcrumbs))
          .to have_css('span.breadcrumb', text: category.name)
      end
    end

    describe 'topic list' do
      context 'no topics' do
        before { paginate }

        it 'shows the placeholder' do
          render
          expect(rendered).to have_content('No topics')
        end
      end

      context 'with topics' do
        let!(:posts) { create_list(:post, 3, topic: topics[0]) }

        before do
          assign(:topics, paginate(topics))
          render
        end

        it 'shows topics' do
          expect(rendered).to have_css('.topic-list-item', count: 5)
        end

        it 'shows the posts count' do
          expect(rendered)
            .to have_css('.topic-list-item:first-child .posts-count', text: 3)
        end
      end

      context 'with locked topic' do
        let!(:locked_topic) { create(:topic, status: :locked) }

        before do
          assign(:topics, paginate([locked_topic]))
          render
        end

        it 'shows the locked badge' do
          expect(rendered)
            .to have_css('.badge[data-badge-caption="Locked"]')
        end
      end
    end
  end

  context 'with authentication' do
    before { paginate }

    describe 'new thread button' do
      context 'guest' do
        before do
          without_partial_double_verification do
            allow(view).to receive(:signed_in?).and_return(false)
          end
          render
        end

        it 'show the button with tooltip' do
          expect(rendered)
            .to have_css('.btn.tooltipped[data-tooltip="Login required"]')
        end
      end

      context 'signed in user' do
        before do
          without_partial_double_verification do
            allow(view).to receive(:signed_in?).and_return(true)
          end
          render
        end

        it 'show the link to create new thread' do
          expect(rendered)
            .to have_css("a[href='#{new_category_topic_path(category)}']")
        end
      end
    end
  end
end
