class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount
  belongs_to :author
  belongs_to :publisher

  def discount
    object.discount.to_f
  end
end
