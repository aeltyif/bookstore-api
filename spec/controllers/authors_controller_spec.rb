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
end
