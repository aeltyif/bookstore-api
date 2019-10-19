class GithubIssuesAuthor
  attr_reader :existing_authors_ids

  ALLOWED_ACTIONS = %w[opened edited deleted].freeze

  def initialize(author_ids = [])
    @existing_authors_ids = author_ids
  end

  def perform(action, issue)
    return unless ALLOWED_ACTIONS.include?(action) && valid_issue?(issue)

    send("issue_#{action}", issue)
  end

  private

  def valid_issue?(issue)
    %w[id title body].all? { |attribute| issue.key? attribute }
  end

  def issue_opened(issue)
    return if existing_authors_ids.include?(issue['id'])

    ActiveRecord::Base.transaction do
      Book.create!(title:     Faker::Book.title,
                   price:     Faker::Number.decimal(l_digits: 2),
                   author:    create_author(issue),
                   publisher: create_publishing_house)
    end
  end

  def issue_edited(issue)
    find_author_by_id(issue['id']).try(:update_attributes, biography: issue['body'])
  end

  def issue_deleted(issue)
    find_author_by_id(issue['id']).try(:destroy)
  end

  def find_author_by_id(id)
    Author.find_by(id: id)
  end

  def create_author(issue)
    Author.create!(id:        issue['id'],
                   name:      issue['title'],
                   biography: issue['body'])
  end

  def create_publishing_house
    PublishingHouse.create!(name:     Faker::Name.name,
                            discount: Faker::Number.positive(from: 15, to: 60))
  end
end
