RSpec.describe BookSerializer, type: :serializer do
  let(:author)        { create(:author) }
  let(:publisher)     { create(:publishing_house) }
  let(:book)          { FactoryBot.build(:book, author: author, publisher: publisher) }
  let(:serializer)    { BookSerializer.new(book) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject             { JSON.parse(serialization.to_json)['data']['attributes'] }

  it 'has an id that matches' do
    expect(subject['id']).to eq(book.id)
  end

  it 'has a title that matches' do
    expect(subject['title']).to eq(book.title)
  end

  it 'has a price that matches' do
    expect(subject['price']).to eq(book.price)
  end
end
