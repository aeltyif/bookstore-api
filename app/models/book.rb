class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, polymorphic: true

  validates :title, :author_id, :publisher_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1, allow_nil: false }

  delegate :discount, to: :publisher

  def price
    self[:price].to_f
  end
end
