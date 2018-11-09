require 'rails_helper'

RSpec.describe AuthorizationHelper, type: :helper do
  describe '#button_if_signed_in' do
    let(:path) { '/abc/1' }
    let(:content) { proc { 'New thread' } }

    context 'when signed in' do
      before do
        without_partial_double_verification do
          allow(view).to receive(:signed_in?).and_return(false)
        end
      end

      it 'show the tooltip' do
        expect(helper.button_if_signed_in(path, &content))
          .to have_css('.tooltipped[data-tooltip="Login required"]')
      end
    end

    context 'when signed in' do
      before do
        without_partial_double_verification do
          allow(view).to receive(:signed_in?).and_return(true)
        end
      end

      it 'show the link button' do
        expect(helper.button_if_signed_in(path, &content))
          .to have_css('a.btn[href="/abc/1"]')
      end
    end
  end
end
