class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, polymorphic: true

  validates :title, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1, allow_nil: false }

  def price
    read_attribute(:price).to_f
  end
end
