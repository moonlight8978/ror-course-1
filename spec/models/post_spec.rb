require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  def attach(attachment = get_attachment('icon.svg', 'image/svg'))
    post.images.attach(attachment)
  end

  it_behaves_like 'soft_deletable_model'

  describe '#validate_images_format' do
    it 'reject any other types than image' do
      attach(get_attachment('report.pdf', 'application/pdf'))
      expect(post).to be_invalid
    end

    it 'accepts images' do
      attach
      expect(post).to be_valid
    end
  end

  describe '#validate_images_size' do
    it 'is not allowed to be bigger than 1MB' do
      attach(get_attachment('racecar.jpg', 'image/jpg'))
      expect(post).to be_invalid
    end

    it 'must have the size less than 1MB' do
      attach
      expect(post).to be_valid
    end
  end

  describe '#validate_images_count' do
    it 'can not have more than 5 attachments' do
      6.times { attach }
      expect(post).to be_invalid
    end

    it 'is allowed to have 5 images or less' do
      3.times { attach }
      expect(post).to be_valid
    end
  end
end
