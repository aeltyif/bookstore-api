RSpec.describe GithubIssueWorker do
  describe '#perform' do
    it 'Return nil both cases we are delegating the action to the GithubIssuesAuthor' do
      expect(GithubIssueWorker.new.perform({}.to_json)).to eq(nil)
    end
  end
end
