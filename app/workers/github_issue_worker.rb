class GithubIssueWorker
  include Sidekiq::Worker

  def perform(payload)
    parsed_payload = JSON.parse(payload)
    return unless valid_payload?(parsed_payload)

    handler = GithubIssuesAuthor.new(Author.ids)
    handler.perform(parsed_payload['action'], parsed_payload['issue'])
    handler
  end

  private

  def valid_payload?(parsed_payload)
    %w[action issue].all? { |attribute| parsed_payload.key? attribute }
  end
end
