class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Ordering
  #   1. all mixins
  #   2. other stuffs: acts_as_taggable, paginates, ...., and the last is enum
  #   3. associations:
  #       belongs_to
  #       has_one
  #       has_many
  #       has_many, through
  #       has_and_belongs_to_many
  #   4. scopes
  #   5. validations
  #   6. callbacks
  #   7. class methods (public - protected - private)
  #   8. instance methods (public - protected - private)
end
