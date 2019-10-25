RSpec.describe PublishingHouse, type: :model do
  describe 'Associations' do
    it { should have_many(:published).dependent(:delete_all) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
