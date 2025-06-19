require 'swagger_helper'

RSpec.describe 'Notes API', type: :request do
  path '/api/v1/notes' do
    get 'Retrieves filtered notes' do
      tags 'Notes'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'
      parameter name: :archived, in: :query, type: :string, required: false, description: 'Filter by archived status'

      let(:page) { 1 }
      let(:per_page) { 10 }
      let(:archived) { false }

      response '200', 'Notes found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: { '$ref' => '#/components/schemas/NoteListItem' }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                total_pages: { type: :integer },
                total_count: { type: :integer },
                per_page: { type: :integer }
              }
            }
          }

        let!(:notes) { create_list(:note, 3) }
        let!(:archived_note) { create(:note, :archived) }
        run_test! do
          parsed_response = JSON.parse(response.body, symbolize_names: true)
          expect(parsed_response[:data].count).to eq(3)
          expect(parsed_response[:data].include?(archived_note)).to eq(false)
          expect(parsed_response[:meta]).to eq(
            { current_page: 1, total_pages: 1, total_count: 3, per_page: 10 }
            )
        end
      end
    end

    post 'Creates a note' do
      tags 'Notes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :note, in: :body, schema: {
        type: :object,
        properties: {
          note: { '$ref' => '#/components/schemas/NoteInput' }
        }
      }

      response '201', 'Note created' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/Note' }
          }

        let(:note) { { note: { title: 'Test Note', body: 'Test body' } } }
        run_test! do
          expect(Note.last.title).to eq('Test Note')
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Error'

        let(:note) { { note: { title: '' } } }
        run_test! do
          expect(Note.count).to eq(0)
        end
      end
    end
  end

  path '/api/v1/notes/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a note' do
      tags 'Notes'
      produces 'application/json'

      response '200', 'note found' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/Note' }
          }

        let(:id) { create(:note).id }
        run_test!
      end

      response '404', 'note not found' do
        schema '$ref' => '#/components/schemas/Error'

        let(:id) { 999999 }
        run_test!
      end
    end

    patch 'Updates a note' do
      tags 'Notes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :note, in: :body, schema: {
        type: :object,
        properties: {
          note: { '$ref' => '#/components/schemas/NoteInput' }
        }
      }

      response '200', 'note updated' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/Note' }
          }

        let(:id) { create(:note).id }
        let(:note) { { note: { title: 'Updated Title' } } }
        run_test!
      end
    end

    delete 'Deletes a note' do
      tags 'Notes'

      response '204', 'note deleted' do
        let(:id) { create(:note).id }
        run_test!
      end
    end
  end

  path '/api/v1/notes/{id}/rewrite' do
    parameter name: :id, in: :path, type: :integer

    patch 'Rewrites note content using AI' do
      tags 'Notes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :rewrite_mode, in: :body, schema: {
        type: :object,
        properties: {
          rewrite_mode: {
            type: :string,
            enum: [ 'polite', 'cheerful', 'mysterious' ]
          }
        }
      }

      response '200', 'note rewritten' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/Note' }
          }

        let(:id) { create(:note).id }
        let(:rewrite_mode) { { rewrite_mode: 'polite' } }
        run_test!
      end
    end
  end
end
