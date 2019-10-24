class GithubIssuesAuthor
  ALLOWED_ACTIONS = %w[opened edited deleted].freeze

  def perform(payload)
    return unless valid_payload?(payload) &&
                  ALLOWED_ACTIONS.include?(payload['action']) &&
                  valid_issue?(payload['issue'])

    send("issue_#{payload['action']}", payload['issue'])
  end

  private

  def valid_payload?(payload)
    %w[action issue].all? { |attribute| payload.key? attribute }
  end

  def valid_issue?(issue)
    %w[id title body].all? { |attribute| issue.key? attribute } &&
      issue['pull_request'].nil?
  end

  def issue_opened(issue)
    ActiveRecord::Base.transaction do
      Book.create!(title:     Faker::Book.title,
                   price:     Faker::Number.decimal(l_digits: 2),
                   author:    create_author(issue),
                   publisher: create_publishing_house)
    end
  end

  def issue_edited(issue)
    author_by_issue_id(issue['id']).try(:update_attributes, biography: issue['body'])
  end

  def issue_deleted(issue)
    author_by_issue_id(issue['id']).try(:destroy)
  end

  def author_by_issue_id(id)
    Author.find_by(issue_id: id)
  end

  def create_author(issue)
    Author.create!(issue_id:  issue['id'],
                   name:      issue['title'],
                   biography: issue['body'])
  end

  def create_publishing_house
    PublishingHouse.create!(name:     Faker::Name.name,
                            discount: Faker::Number.positive(from: 15, to: 60))
  end
end
