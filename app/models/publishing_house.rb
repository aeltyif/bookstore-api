class PublishingHouse < ApplicationRecord
  has_many :published, as: :publisher, foreign_key: :publisher_id, class_name: 'Book', dependent: :destroy, inverse_of: :author

  validates :name, presence: true
end
