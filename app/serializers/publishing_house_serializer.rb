class PublishingHouseSerializer < ActiveModel::Serializer
  attributes :id, :name, :discount
  has_many :published

  def discount
    object.discount.to_f
  end
end
