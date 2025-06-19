require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Notes API V1',
        version: 'v1',
        description: 'API for managing notes with AI text rewriting capabilities'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        schemas: {
          Note: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              body: { type: :string },
              archived: { type: :boolean },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: [ :id, :title, :body, :archived ]
          },
          NoteInput: {
            type: :object,
            properties: {
              title: { type: :string },
              body: { type: :string }
            },
            required: [ :title, :body ]
          },
          NoteListItem: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              archived: { type: :boolean },
              created_at: { type: :string, format: 'date-time' }
            },
            required: [ :id, :title, :archived ]
          },
          Error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    field: { type: :string },
                    message: { type: :string },
                    code: { type: :string }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :json
end
