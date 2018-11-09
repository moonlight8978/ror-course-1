require 'rails_helper'

RSpec.describe 'categories/index', type: :view do
  let(:categories) { [] }

  before { assign(:categories, categories) }

  it 'display the Home breadcrumb' do
    render
    expect(view.content_for(:breadcrumbs))
      .to have_css('span.breadcrumb', text: 'Home')
  end

  context 'with no categories' do
    it 'show the placeholder' do
      render
      expect(rendered).to match(/No categories/)
    end
  end

  context 'with categories' do
    let(:categories) { create_list(:category, 2) }

    it 'display the category titles' do
      render
      expect(rendered).to have_css('.category-name', text: categories[0].name)
      expect(rendered).to have_css('.category-name', text: categories[1].name)
    end

    context 'when category has topics' do
      let(:topics) { create_list(:topic, 2, category: categories.first) }
      let(:last_topic) { topics.last }
      let!(:posts) { create_list(:post, 2, topic: last_topic) }

      before { render }

      it 'display the last topic' do
        expect(rendered)
          .to have_link(last_topic.name, href: topic_path(last_topic))
      end

      it 'show the topics count' do
        expect(rendered).to have_css('.topics-count', text: 2)
      end

      it 'show the posts count' do
        expect(rendered).to have_css('.posts-count', text: 4)
      end
    end

    context 'when category has no topics' do
      before { render }

      it 'display the placeholder text' do
        expect(rendered).to have_text('No topics', count: 2)
      end

      it 'show the posts count with 0' do
        expect(rendered).to have_css('.posts-count', text: 0, count: 2)
      end
    end
  end
end
