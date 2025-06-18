class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }

  enum :rewrite_mode, { polite: 0, cheerful: 1, mysterious: 2 }

  def archive!
    update!(archived: true)
  end

  def unarchive!
    update!(archived: false)
  end
end
