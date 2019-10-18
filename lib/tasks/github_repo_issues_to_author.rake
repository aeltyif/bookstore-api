require 'net/http'

desc 'Generate Authors & Books from Github repository URL'
task :issues_to_authors => [ :environment ] do
  begin
    results = JSON.parse(Net::HTTP.get(URI.parse('https://api.github.com/repos/aeltyif/bookstore-api/issues')))
    if results.class == Hash
      puts results['message']
    else
      handler = GithubIssuesAuthor.new(Author.ids)
      results.each { |issue| handler.perform('opened', issue) }
    end
  rescue SocketError
    puts 'Please check the URL provided'
  end
end
