RSpec.describe PublishingHouse, type: :model do
  describe 'Associations' do
    it { should have_many(:published)}
  end
end
