require 'net/http'

desc 'Generate Authors & Books from Github repository URL'
task issues_to_authors: %i[environment] do
  client = Octokit::Client.new(login: 'username_here', password: 'password_here')
  begin
    client.authorizations
    Author.all.each do |author|
      client.create_issue('aeltyif/bookstore-api', author.name, author.biography)
    end
    puts 'Finished Successfully'
  rescue Octokit::Unauthorized
    puts 'Wrong authentication was provided please check the login and the password'
  end
end
