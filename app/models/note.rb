class Note < ApplicationRecord
  include AASM

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }

  aasm column: :rewrite_status do
    state :original, initial: true
    state :rewriting
    state :rewritten
    state :rewrite_failed

    event :start_rewriting do
      transitions from: [ :original, :rewrite_failed ], to: :rewriting
    end

    event :complete_rewriting do
      transitions from: :rewriting, to: :rewritten
    end

    event :fail_rewriting do
      transitions from: :rewriting, to: :rewrite_failed
    end
  end
end
