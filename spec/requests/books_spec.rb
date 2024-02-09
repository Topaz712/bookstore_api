require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'POST /books' do
    let(:valid_attributes) { { title: 'Fahrenheit 451' } }
    let(:invalid_attributes) { { title: '' } }

    context 'when the request is valid' do
      it 'creates a new book' do
        expect {
          post '/books', params: { book: valid_attributes }
        }.to change(Book, :count).by(1)

        expect(response).to have_http_status(201)
        expect(json['title']).to eq('Fahrenheit 451')
      end
    end

    context 'when the request is invalid' do
      it 'does not create a new book' do
        expect {
          post '/books', params: { book: invalid_attributes }
        }.not_to change(Book, :count)

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET /books' do
    let!(:books) { create_list(:book, 10) }

    it 'returns all books' do
      get '/books'

      expect(response).to have_http_status(200)
      expect(json.size).to eq(10)
    end
  end

  describe 'GET /books/:id' do
    let!(:book) { create(:book) }

    it 'returns a specific book' do
      get "/books/#{book.id}"

      expect(response).to have_http_status(200)
      expect(json['title']).to eq(book.title)
    end

    it 'returns status code 404' do
      get '/books/100'

      expect(response).to have_http_status(404)
    end
  end

  describe 'PUT /books/:id' do
    let!(:book) { create(:book) }

    context 'when the request is valid' do
      it 'updates the specified book' do
        patch "/books/#{book.id}", params: { book: { title: 'New Title' } }

        expect(response).to have_http_status(200)
        expect(json['title']).to eq('New Title')
      end
    end

    context 'when the request is invalid' do
      it 'does not update the book' do
        patch "/books/#{book.id}", params: { book: { title: '' } }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { create(:book) }

    it 'deletes the specified book' do
      expect {
        delete "/books/#{book.id}"
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(204)
    end
  end

  def json
    JSON.parse(response.body)
  end
end