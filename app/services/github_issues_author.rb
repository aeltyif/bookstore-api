class GithubIssuesAuthor
  ALLOWED_ACTIONS = %w[opened edited deleted].freeze

  def perform(action, issue)
    return unless ALLOWED_ACTIONS.include?(action) && valid?(issue)

    send("issue_#{action}", issue)
  end

  private

  def valid?(issue)
    %w[id title body].all? { |attribute| issue.key? attribute }
  end

  def issue_opened(issue)
    ActiveRecord::Base.transaction do
      author = Author.create(id: issue['id'], name: issue['title'], biography: issue['body'])
      author.books.create(title: Faker::Book.title, price: Faker::Commerce.price, publisher: author)
    end
  end

  def issue_edited(issue)
    Author.find_by_id(issue['id']).try(:update_attributes, biography: issue['body'])
  end

  def issue_deleted(issue)
    Author.find_by_id(issue['id']).try(:destroy)
  end
end
