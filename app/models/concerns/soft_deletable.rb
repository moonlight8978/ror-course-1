module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :visible, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }
  end

  def deleted?
    deleted_at.present?
  end

  def visible?
    deleted_at.nil?
  end

  def soft_destroy
    deleted_at.nil? && update(deleted_at: Time.current)
  end

  def recover
    deleted_at.present? && update(deleted_at: nil)
  end
end
