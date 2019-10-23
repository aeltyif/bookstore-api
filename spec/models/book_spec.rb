RSpec.describe Book, type: :model do
  let(:author)    { create(:author) }
  let(:publisher) { create(:publishing_house) }
  subject         { create(:book, author: author, publisher: publisher) }

  describe 'Associations' do
    it { should belong_to(:author) }
    it { should belong_to(:publisher) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(1) }
  end

  describe '#price' do
    it 'return correct float price of the book' do
      expect(subject.price.class).to eq(Float)
    end
  end

  describe 'Book discount' do
    context 'Correct discount amount accordingly to the publisher object' do
      it 'return the author discount' do
        subject.publisher = author
        subject.save
        expect(subject.discount).to eq(author.discount)
      end
      it 'return the publishing house discount' do
        expect(subject.discount).to eq(publisher.discount)
      end
    end
  end
end
