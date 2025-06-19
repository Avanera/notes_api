module Notes
  class UpdateService < ApplicationService
    def call
      note = @context[:note]
      params = @context[:params]

      if note.update(params)
        result.data = NoteBlueprint.render_as_hash(note, view: :detailed)
      else
        note.errors.each do |error|
          result.add_error(error.message, field: error.attribute, code: error.type)
        end
      end

      result
    end
  end
end
