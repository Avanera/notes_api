module Notes
  class CreateService < ApplicationService
    def call
      note = Note.new(@context[:params])

      if note.save
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
