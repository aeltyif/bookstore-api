class GithubIssueWorker
  include Sidekiq::Worker

  def perform(payload)
    parsed_payload = JSON.parse(payload)
    return unless valid_payload?(parsed_payload)

    GithubIssuesAuthor.new(Author.ids)
                      .perform(parsed_payload['action'], parsed_payload['issue'])
  end

  private

  def valid_payload?(parsed_payload)
    %w[action issue].all? { |attribute| parsed_payload.key? attribute }
  end
end
