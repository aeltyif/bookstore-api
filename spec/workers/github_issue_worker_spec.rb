RSpec.describe GithubIssueWorker do
  describe '#perform' do
    it 'Will Perform' do
      expect(GithubIssueWorker.new.perform({}.to_json)).to eq(nil)
    end
  end
end
