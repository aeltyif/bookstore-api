RSpec.describe GithubIssuesAuthor do
  let(:author)  { create(:author) }
  let(:book)    { create(:book, author: author, publisher: author) }
  let(:handler) { GithubIssuesAuthor.new }

  describe '#perform' do
    it 'Only allowed actions' do
      expect(GithubIssuesAuthor::ALLOWED_ACTIONS).to eq(%w[opened edited deleted])
    end

    it 'Wrong action to be passed' do
      handler.perform('action' => 'wrong_action', 'issue' => {})
      expect(Author.all.size).to eq(0)
    end

    it 'Wrong issue body' do
      handler.perform('action' => 'opened', 'issue' => {})
      expect(Author.count).to eq(0)
      expect(Book.count).to   eq(0)
    end

    context 'Opened Issue, Correct action and issue structure' do
      it 'Without previous record' do
        handler.perform('action' => 'opened', 'issue' => { id: 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.count).to eq(1)
        expect(Book.count).to   eq(1)
      end

      it 'With previous record' do
        author
        book
        options = { id: author.issue_id, title: 'Hello', body: 'Bio' }.as_json
        expect { handler.perform('action' => 'opened', 'issue' => options) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'Edited Issue, Correct action and issue structure' do
      it 'Without previous record' do
        author
        book
        handler.perform('action' => 'edited', 'issue' => { id: author.issue_id + 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:biography)).not_to eq([['Bio']])
      end

      it 'With previous record' do
        author
        book
        handler.perform('action' => 'edited', 'issue' => { id: author.issue_id, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:name, :biography)).to eq([[author.name, 'Bio']])
      end
    end

    context 'Deleted Issue' do
      it 'Without previous record' do
        author
        book
        handler.perform('action' => 'deleted', 'issue' => { id: author.issue_id + 1, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.all.pluck(:biography)).not_to eq([['Bio']])
      end

      it 'With previous record' do
        author
        book
        handler.perform('action' => 'deleted', 'issue' => { id: author.issue_id, title: 'Hello', body: 'Bio' }.as_json)
        expect(Author.count).to eq(0)
        expect(Book.count).to   eq(0)
      end
    end
  end
end
