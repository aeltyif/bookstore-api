RSpec.describe Author, type: :model do
  subject { create(:author) }

  describe 'Associations' do
    it { should have_many(:books).dependent(:destroy) }
    it { should have_many(:published).dependent(:destroy) }
    it { is_expected.to validate_uniqueness_of(:issue_id).allow_nil }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#discount' do
    it 'return static value of 10' do
      expect(subject.discount).to eq(10)
    end
  end
end
