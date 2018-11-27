require 'rails_helper'

RSpec.describe LanguagesHelper, type: :helper do
  describe '#selectable_locales' do
    it 'returns all languages except current language' do
      I18n.locale = :en
      expect(helper.selectable_locales).not_to be_include(:en)
    end
  end
end
