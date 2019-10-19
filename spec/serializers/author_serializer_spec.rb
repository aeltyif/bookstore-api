RSpec.describe AuthorSerializer, type: :serializer do
  let(:author)        { FactoryBot.build(:author) }
  let(:serializer)    { AuthorSerializer.new(author) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject             { JSON.parse(serialization.to_json)['data']['attributes'] }

  it 'has an id that matches' do
    expect(subject['id']).to eq(author.id)
  end

  it 'has a name that matches' do
    expect(subject['name']).to eq(author.name)
  end

  it 'has a biography that matches' do
    expect(subject['biography']).to eq(author.biography)
  end

  it 'has a discount that matches' do
    expect(subject['discount']).to eq(author.discount)
  end
end
