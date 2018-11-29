class Post < ApplicationRecord
  CONTENT_MAXIMUM_LENGTH = 500

  include SoftDeletable

  belongs_to :creator, class_name: 'User'
  # TODO: optimize counter cache
  belongs_to :topic, optional: true, counter_cache: true
  belongs_to :category, counter_cache: true

  has_many :votings
  has_many_attached :images

  has_many :voters, through: :votings

  validates :content,
    presence: true,
    length: { maximum: CONTENT_MAXIMUM_LENGTH }
  validate :validate_images_format, if: -> { images.attached? }
  validate :validate_images_size, if: -> { images.attached? }
  validate :validate_images_count, if: -> { images.attached? }

  def first_post?
    topic.nil?
  end

  private

  def validate_images_format
    return if images
      .detect { |image| !image.blob.content_type.start_with?('image/') }
      .nil?

    errors.add(:images, :format)
  end

  def validate_images_size
    return if images.detect { |image| image.blob.byte_size > 1_000_000 }.nil?

    errors.add(:images, :size)
  end

  def validate_images_count
    return if images.length < 5

    errors.add(:images, :too_many)
  end
end
