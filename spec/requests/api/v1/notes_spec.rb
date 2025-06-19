require 'rails_helper'

RSpec.describe 'Api::V1::Notes', type: :request do
  describe 'GET /api/v1/notes' do
    let!(:active_notes) { create_list(:note, 3) }
    let!(:archived_notes) { create_list(:note, 2, :archived) }

    it 'returns all notes by default' do
      get '/api/v1/notes'

      expect(response).to have_http_status(:ok)
      expect_json_response([ :data, :meta ])
      expect(json_response['data'].size).to eq(5)
    end

    it 'filters by archived status' do
      get '/api/v1/notes', params: { archived: 'true' }

      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(2)
    end

    it 'returns all notes if param `archived` is invalid' do
      get '/api/v1/notes', params: { archived: 'invalid' }

      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(5)
    end

    it 'includes pagination metadata' do
      get '/api/v1/notes'

      expect(json_response['meta']).to include(
        'current_page',
        'total_pages',
        'total_count',
        'per_page'
      )
    end

    it 'supports pagination' do
      get '/api/v1/notes', params: { page: 1, per_page: 2 }

      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(2)
      expect(json_response['meta']['per_page']).to eq(2)
    end
  end

  describe 'GET /api/v1/notes/:id' do
    let(:note) { create(:note) }

    it 'returns the note' do
      get "/api/v1/notes/#{note.id}"

      expect(response).to have_http_status(:ok)
      expect_json_response([ :data ])
      expect(json_response['data']['id']).to eq(note.id)
    end

    it 'returns 404 for non-existent note' do
      get '/api/v1/notes/100500'

      expect(response).to have_http_status(:not_found)
      expect(json_response['errors']).to be_present
    end
  end

  describe 'POST /api/v1/notes' do
    let(:valid_params) do
      {
        note: {
          title: 'Test Note',
          body: 'This is a test note body'
        }
      }
    end

    it 'creates a new note' do
      expect {
        post '/api/v1/notes', params: valid_params
      }.to change(Note, :count).by(1)

      expect(response).to have_http_status(:created)
      expect_json_response([ :data ])
      expect(json_response['data']['title']).to eq('Test Note')
    end

    it 'returns validation errors for invalid data' do
      post '/api/v1/notes', params: { note: { title: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to be_present
    end
  end

  describe 'PATCH /api/v1/notes/:id' do
    let(:note) { create(:note) }
    let(:update_params) do
      {
        note: {
          title: 'Updated Title'
        }
      }
    end

    it 'updates the note' do
      patch "/api/v1/notes/#{note.id}", params: update_params

      expect(response).to have_http_status(:ok)
      expect_json_response([ :data ])
      expect(json_response['data']['title']).to eq('Updated Title')
    end
  end

  describe 'DELETE /api/v1/notes/:id' do
    let!(:note) { create(:note) }
    it 'deletes the note' do
      expect {
        delete "/api/v1/notes/#{note.id}"
      }.to change(Note, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PATCH /api/v1/notes/:id/archive' do
    let(:note) { create(:note) }

    it 'archives the note' do
      patch "/api/v1/notes/#{note.id}/archive"

      expect(response).to have_http_status(:ok)
      expect(json_response['data']['archived']).to be(true)
    end
  end

  describe 'PATCH /api/v1/notes/:id/unarchive' do
    let(:note) { create(:note, :archived) }

    it 'unarchives the note' do
      patch "/api/v1/notes/#{note.id}/unarchive"

      expect(response).to have_http_status(:ok)
      expect(json_response['data']['archived']).to be(false)
    end
  end

  describe 'PATCH /api/v1/notes/:id/rewrite' do
    let(:note) { create(:note, body: 'Original text') }

    it 'rewrites the note text' do
      patch "/api/v1/notes/#{note.id}/rewrite", params: { rewrite_mode: 'polite' }

      expect(response).to have_http_status(:ok)
      expect(json_response['data']['body']).to include('Please note')
    end

    it 'returns error for invalid rewrite mode' do
      patch "/api/v1/notes/#{note.id}/rewrite", params: { rewrite_mode: 'invalid' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).to be_present
    end
  end
end
