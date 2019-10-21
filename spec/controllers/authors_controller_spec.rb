RSpec.describe AuthorsController, type: :request do
  let(:resource)          { create(:author) }
  let(:valid_params)      { FactoryBot.attributes_for(:author) }
  let(:invalid_params)    { FactoryBot.attributes_for(:author, :invalid) }
  let(:resource_constant) { Author }
  let(:resource_name)     { 'authors' }
  let(:params)            { {} }

  describe '#index' do
    context 'Available resource to list' do
      before do
        resource
        get "/#{resource_name}"
      end
      it 'returns status success' do
        expect(response).to have_http_status :success
      end
      it 'returns list of resources' do
        parsed_data = JSON.parse(response.body)['data']
        expect(parsed_data).not_to be_empty
        serialized = ActiveModelSerializers::SerializableResource.new(resource).serializable_hash
        expect(parsed_data).to eq([serialized[:data].as_json])
      end
    end
    context 'No resource found to list' do
      before do
        get "/#{resource_name}"
      end
      it 'returns status success' do
        expect(response).to have_http_status :success
      end
      it 'returns list of resources' do
        parsed_data = JSON.parse(response.body)['data']
        expect(parsed_data).to eq([])
      end
    end
  end

  describe '#show' do
    context 'Available resource to show' do
      before do
        get "/#{resource_name}/#{resource.id}"
      end
      it 'returns status success' do
        expect(response).to have_http_status :success
      end
      it 'returns list of resources' do
        parsed_data = JSON.parse(response.body)['data']
        expect(parsed_data).not_to be_empty
        serialized = ActiveModelSerializers::SerializableResource.new(resource).serializable_hash
        expect(parsed_data).to eq(serialized[:data].as_json)
      end
    end
    context 'No resource found to show' do
      before do
        get "/#{resource_name}/#{resource.id + 1}"
      end
      it 'returns status not found' do
        expect(response).to have_http_status :not_found
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq('Record you are looking for is not found')
      end
    end
  end

  describe '#create' do
    context 'With valid parameters' do
      before do
        params[resource_name.singularize] = valid_params
        post "/#{resource_name}", params: params
      end
      it 'returns status success' do
        expect(response).to have_http_status :success
      end
      it 'returns list of resources' do
        parsed_data = JSON.parse(response.body)['data']
        expect(parsed_data).not_to be_empty
      end
    end
    context 'With invalid parameters' do
      before do
        params[resource_name.singularize] = invalid_params
        post "/#{resource_name}", params: params
      end
      it 'returns status unprocessable entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)
        expect(error_message).to eq('name'=>["can't be blank"])
      end
    end
  end

  describe '#issue_to_author' do
    before do
      params[:payload] = { action: 'opened', issue: [] }
      post "/#{resource_name}/issue_to_author", params: params
    end
    it 'returns status success' do
      expect(response).to have_http_status :accepted
    end
    it 'returns success message' do
      expect(JSON.parse(response.body)).to eq({ body: 'Request received' }.as_json)
    end
  end

  describe '#update' do
    context 'With valid parameters' do
      before do
        params[resource_name.singularize] = valid_params
        put "/#{resource_name}/#{resource.id}", params: params
      end
      it 'returns status success' do
        expect(response).to have_http_status :success
      end
      it 'returns error message' do
        resource.reload
        parsed_data = JSON.parse(response.body)
        expect(parsed_data).not_to be_empty
        serialized = ActiveModelSerializers::SerializableResource.new(resource).serializable_hash
        expect(parsed_data).to eq(serialized.as_json)
      end
    end
    context 'With invalid parameters' do
      before do
        params[resource_name.singularize] = invalid_params
        put "/#{resource_name}/#{resource.id}", params: params
      end
      it 'returns status unprocessable entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)
        expect(error_message).to eq('name'=>["can't be blank"])
      end
    end
  end

  describe '#destroy' do
    context 'With valid parameters' do
      before do
        delete "/#{resource_name}/#{resource.id}"
      end
      it 'returns status no content' do
        expect(response).to have_http_status :no_content
      end
      it 'successfully delete the resource' do
        expect(response.body).to           eq('')
        expect(resource_constant.count).to eq(0)
      end
    end
    context 'With invalid parameters' do
      before do
        delete "/#{resource_name}/#{resource.id + 1}"
      end
      it 'returns status not found' do
        expect(response).to have_http_status :not_found
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq('Record you are looking for is not found')
      end
    end
  end
end
