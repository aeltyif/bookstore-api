class GithubIssuesAuthor
  attr_reader :existing_authors_ids

  ALLOWED_ACTIONS = %w[opened edited deleted].freeze

  def initialize(author_ids = [])
    @existing_authors_ids = author_ids
  end

  def perform(action, issue)
    return unless ALLOWED_ACTIONS.include?(action) && valid?(issue)

    send("issue_#{action}", issue)
  end

  private

  def valid?(issue)
    %w[id title body].all? { |attribute| issue.key? attribute }
  end

  def issue_opened(issue)
    return if existing_authors_ids.include?(issue['id'])

    ActiveRecord::Base.transaction do
      author = Author.create!(id: issue['id'], name: issue['title'], biography: issue['body'])
      author.books.create!(title: Faker::Book.title, price: Faker::Number.positive(from: 5, to: 30), publisher: author) if author.persisted?
    end
  end

  def issue_edited(issue)
    Author.find_by_id(issue['id']).try(:update_attributes, biography: issue['body'])
  end

  def issue_deleted(issue)
    Author.find_by_id(issue['id']).try(:destroy)
  end
end
