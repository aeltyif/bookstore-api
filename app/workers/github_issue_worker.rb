class GithubIssueWorker
  include Sidekiq::Worker

  def perform(issue)
    return unless issue.length.positive?

    Author.create(name: issue['title'], biography: issue['body'])
  end
end
