require 'net/http'

desc 'Generate github issues from authors'
task authors_to_github_issues: %i[environment] do
  client = Octokit::Client.new(login:    Rails.application.secrets[:github_username],
                               password: Rails.application.secrets[:github_password])
  begin
    client.authorizations
    Author.all.each do |author|
      github_issue = client.create_issue('aeltyif/bookstore-api', author.name, author.biography)
      author.update(issue_id: github_issue[:id])
    end
    puts 'Finished Successfully'
  rescue Octokit::Unauthorized
    puts 'Wrong authentication was provided, please check the login and the password'
  end
end
