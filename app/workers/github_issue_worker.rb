class GithubIssueWorker
  include Sidekiq::Worker

  def perform(payload)
    handler = GithubIssuesAuthor.new
    handler.perform(JSON.parse(payload))
    handler
  end
end
