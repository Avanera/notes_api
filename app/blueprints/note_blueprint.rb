class NoteBlueprint < Blueprinter::Base
  identifier :id

  view :default do
    fields :title, :archived, :created_at
  end

  view :detailed do
    fields :title, :body, :archived, :created_at, :updated_at
  end
end
