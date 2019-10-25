RSpec.describe GithubIssueWorker do
  describe '#perform' do
    it 'Return correct handler class' do
      handler = GithubIssueWorker.new.perform({ action: 'opened', issue: {} }.to_json)
      expect(handler.class).to eq(GithubIssuesAuthor)
    end
  end
end
