RSpec.describe PublishingHouseSerializer, type: :serializer do
  let(:publisher)     { build(:publishing_house) }
  let(:serializer)    { PublishingHouseSerializer.new(publisher) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject             { JSON.parse(serialization.to_json)['data']['attributes'] }

  it 'has an id that matches' do
    expect(subject['id']).to eq(publisher.id)
  end

  it 'has a name that matches' do
    expect(subject['name']).to eq(publisher.name)
  end

  it 'has a discount that matches' do
    expect(subject['discount']).to eq(publisher.discount)
  end
end
