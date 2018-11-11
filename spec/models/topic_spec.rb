require 'rails_helper'

RSpec.describe Topic, type: :model do
  it_behaves_like 'soft_deletable_model'
end
