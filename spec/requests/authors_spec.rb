require 'rails_helper'

RSpec.describe 'Authors', type: :request do
  describe 'POST /authors' do
    let(:valid_attributes) { { name: 'John Doe' } }
    let(:invalid_attributes) { { name: '' } }

    context 'when the request is valid' do
      it 'creates a new author' do
        expect {
          post '/authors', params: { author: valid_attributes }
        }.to change(Author, :count).by(1)

        expect(response).to have_http_status(201)
        expect(json['name']).to eq('John Doe')
      end
    end

    context 'when the request is invalid' do
      it 'does not create a new author' do
        expect {
          post '/authors', params: { author: invalid_attributes }
        }.not_to change(Author, :count)

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET /authors' do
    let!(:authors) { create_list(:author, 10) }

    it 'returns all authors' do
      get '/authors'

      expect(response).to have_http_status(200)
      expect(json.size).to eq(10)
    end
  end

  describe 'GET /authors/:id' do
    let!(:author) { create(:author) }

    it 'returns a specific author' do
      get "/authors/#{author.id}"

      expect(response).to have_http_status(200)
      expect(json['name']).to eq(author.name)
    end

    it 'returns status code 404' do
      get '/authors/100'

      expect(response).to have_http_status(404)
    end
  end

  describe 'PUT /authors/:id' do
    let!(:author) { create(:author) }

    context 'when the request is valid' do
      it 'updates the specified author' do
        patch "/authors/#{author.id}", params: { author: { name: 'Jane Doe' } }

        expect(response).to have_http_status(200)
        expect(json['name']).to eq('Jane Doe')
      end
    end

    context 'when the request is invalid' do
      it 'does not update the author' do
        patch "/authors/#{author.id}", params: { author: { name: '' } }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /authors/:id' do
    let!(:author) { create(:author) }

    it 'deletes the specified author' do
      expect {
        delete "/authors/#{author.id}"
      }.to change(Author, :count).by(-1)

      expect(response).to have_http_status(204)
    end
  end

  def json
    JSON.parse(response.body)
  end
end