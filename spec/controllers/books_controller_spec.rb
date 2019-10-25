RSpec.describe BooksController, type: :request do
  let(:author)            { create(:author) }
  let(:resource)          { create(:book, author: author, publisher: author) }
  let(:valid_book)        { build(:book, author: author, publisher: author) }
  let(:invalid_book)      { build(:book, :invalid, author: author, publisher: author) }
  let(:resource_constant) { Book }
  let(:resource_name)     { 'books' }
  let(:valid_params)      { ActiveModelSerializers::SerializableResource.new(valid_book, polymorphic: [:publisher]).as_json }
  let(:invalid_params)    { ActiveModelSerializers::SerializableResource.new(invalid_book, polymorphic: [:publisher]).as_json }

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
        post "/#{resource_name}", params: valid_params
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
        post "/#{resource_name}", params: invalid_params
      end
      it 'returns status unprocessable entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)
        expect(error_message).to eq('title'=>["can't be blank"])
      end
    end
  end

  describe '#update' do
    context 'With valid parameters' do
      before do
        put "/#{resource_name}/#{resource.id}", params: valid_params
      end
      it 'returns status unprocessable entity' do
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
        put "/#{resource_name}/#{resource.id}", params: invalid_params
      end
      it 'returns status unprocessable entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns error message' do
        error_message = JSON.parse(response.body)
        expect(error_message).to eq('title'=>["can't be blank"])
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
