require 'net/http'

desc 'Generate Authors & Books from Github repository URL'
task :issues_to_authors => [ :environment ] do
  begin
    results = JSON.parse(Net::HTTP.get(URI.parse('https://api.github.com/repos/aeltyif/bookstore-api/issues')))
    if results.class == Hash
      puts results['message']
    else
      handler = GithubIssuesAuthor.new
      existing_authors_id = Author.ids
      results.each do |issue|
        next if existing_authors_id.include?(issue['id'])

        handler.perform('opened', issue)
      end
    end
  rescue SocketError
    puts 'Please check the URL provided'
  end
end
