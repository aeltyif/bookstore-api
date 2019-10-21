class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount
  belongs_to :author
  belongs_to :publisher
end
