class Author < ApplicationRecord
  has_many :books, dependent: :delete_all
  has_many :published, foreign_key: :publisher_id, class_name: 'Book', as: :publisher, dependent: :delete_all, inverse_of: :author

  validates :name, presence: true
  validates :issue_id, uniqueness: true, allow_blank: true

  def discount
    10
  end
end
