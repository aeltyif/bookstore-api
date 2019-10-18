RSpec.describe Book, type: :model do
  describe 'Associations' do
    it { should belong_to(:author)}
    it { should belong_to(:publisher)}
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(1) }
  end
end
