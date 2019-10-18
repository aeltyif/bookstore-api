RSpec.describe GithubIssuesAuthor do
  let(:author)  { create(:author) }
  let(:book)    { create(:book, author: author, publisher: author) }
  let(:handler) { GithubIssuesAuthor.new }

  describe '#perform' do
    it 'Only allowed actions' do
      expect(GithubIssuesAuthor::ALLOWED_ACTIONS).to eq(%w[opened edited deleted])
    end

    it 'Wrong action to be passed' do
      handler.perform('wrong_action', {})
      expect(Author.all.size).to eq(0)
    end

    it 'Wrong issue body' do
      handler.perform('opened', {})
      expect(Author.count).to eq(0)
      expect(Book.count).to   eq(0)
    end

    context 'Opened Issue, Correct action and issue structure' do
      it 'Without previous record' do
        handler.perform('opened', { id: 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.count).to eq(1)
        expect(Book.count).to   eq(1)
      end

      it 'With previous record' do
        author
        book
        GithubIssuesAuthor.new(Author.ids).perform('opened', { id: author.id, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.count).to eq(1)
        expect(Book.count).to   eq(1)
      end
    end

    context 'Edited Issue, Correct action and issue structure' do
      it 'Without previous record' do
        author
        book
        handler.perform('edited', { id: author.id + 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:biography)).not_to eq([['Bio']])
      end

      it 'With previous record' do
        author
        book
        handler.perform('edited', { id: author.id, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:name, :biography)).to eq([[author.name, 'Bio']])
      end
    end

    context 'Deleted Issue' do
      it 'Without previous record' do
        author
        book
        handler.perform('deleted', { id: author.id + 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:biography)).not_to eq([['Bio']])
      end

      it 'With previous record' do
        author
        book
        handler.perform('deleted', { id: author.id, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.count).to eq(0)
        expect(Book.count).to   eq(0)
      end
    end
  end
end
