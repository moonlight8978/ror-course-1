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
end
