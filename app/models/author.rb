class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :published, foreign_key: :publisher_id, class_name: 'Book', as: :publisher

  validates :name, presence: true
  validates_uniqueness_of :id

  def discount() 10 end
end
