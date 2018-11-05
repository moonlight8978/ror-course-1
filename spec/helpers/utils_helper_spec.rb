require 'rails_helper'

RSpec.describe UtilsHelper, type: :helper do
  describe '#classnames' do
    it 'concat the class names arrays' do
      expect(helper.classnames('input', 'valid')).to eq('input valid')
    end

    it 'concat the class name which condition returns true' do
      expect(helper.classnames('input', valid: true)).to eq('input valid')
    end

    it 'ignore the class names which condition returns false' do
      expect(helper.classnames(invalid: false, valid: true)).to eq('valid')
    end
  end

  describe '#error_message_for' do
    let(:model) { double('User') }

    context 'model has errors' do
      it "return the first error message of the model attribute's errors" do
        allow(model).to receive_message_chain(
          :errors,
          messages: { email: ['blank', 'too short'] }
        )
        expect(helper.error_message_for(model, :email).scan(/error="blank"/))
          .to be_truthy
      end
    end

    context 'model does not have any errors' do
      it 'return empty string' do
        allow(model).to receive_message_chain(:errors, messages: { email: [] })
        expect(helper.error_message_for(model, :email)).to be_nil
      end
    end
  end

  describe '#breadcrumbs_for' do
    context 'with path' do
      let(:breadcrumb_link) { Hash[path: '/xxx', title: 'Link 1'] }

      it 'generate hyperlinks' do
        helper.breadcrumbs_for(breadcrumb_link)
        expect(helper.content_for(:breadcrumbs)).to(
          include('<a alt="Link 1" class="breadcrumb" href="/xxx">Link 1</a>')
        )
      end
    end

    context 'without path' do
      let(:breadcrumb) { Hash[title: 'Home'] }

      it 'generate text span' do
        helper.breadcrumbs_for(breadcrumb)
        expect(helper.content_for(:breadcrumbs)).to(
          include('<span class="breadcrumb">Home</span>')
        )
      end
    end
  end
end
