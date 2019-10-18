RSpec.describe AuthorsController do
  describe '#index' do
    it do
    end
  end

  describe '#show' do
    it do
    end
  end

  describe '#create' do
    it do
    end
  end

  describe '#issue_to_author' do
    it do
    end
  end

  describe '#update' do
    it do
    end
  end

  describe '#destroy' do
    it do
    end
  end
end


RSpec.describe AuthorsController, type: :request do
  let(:api_version)         { '/api/v1/' }
  let(:branch)              { create(:branch, company: create(:company)) }
  let(:manager)             { create(:employee, branch: branch) }
  let(:timeoff)             { create(:balanced_vacation, name: { en: 'specs test' }, allowed_after: 0, branch: branch) }
  let(:professional_datum)  { build(:professional_datum, manager: manager) }
  let(:employee)            { create(:employee, branch: branch, professional_data: [professional_datum], create_professional_data: false) }
  let(:auth_headers)        { employee.user.create_new_auth_token }

  describe '#index' do
    it do
    end
  end

  describe '#show' do
    it do
    end
  end

  describe '#create' do
    it do
    end
  end

  describe '#issue_to_author' do
    it do
    end
  end

  describe '#update' do
    it do
    end
  end

  describe '#destroy' do
    it do
    end
  end

  describe 'GET /dashboard' do
    before do
      timeoff
      get "#{api_version}dashboard", headers: auth_headers
    end

    it 'returns status success' do
      expect(response).to have_http_status :success
    end

    it 'returns dashboard data' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).not_to eq(0)
      # Check the keys being used by the mobile App
      expect(json['employee']['name']).not_to              be_empty
      expect(json['employee']['position_name']).not_to     be_empty
      expect(json['employee']['hiring_date']).not_to       be_empty
      expect(json['employee']['picture_url']).not_to       be_empty
      expect(json['employee']['manager']['name']).not_to   be_empty
      expect(json['employee']['company']['name']).not_to   be_empty
      expect(json['balances'].first['available_t']).not_to be_empty
      expect(json['balances'].first['end_t']).not_to       be_empty
      expect(json['balances'].first['timeoff_name']).to    eq(timeoff.name)
      expect(json['balances'].first['current_balance']).to eq(14)
      expect(json['balances'].first['total_balance']).to   eq(14)
    end
  end
end
