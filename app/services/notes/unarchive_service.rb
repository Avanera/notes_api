module Notes
  class UnarchiveService < ApplicationService
    def call
      note = @context[:note]

      if note.unarchive!
        result.data = NoteBlueprint.render_as_hash(note, view: :detailed)
      else
        note.errors.each do |error|
          result.add_error(error.message, field: error.attribute, code: error.type)
        end
      end

      result
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.each do |error|
        result.add_error(error.message, field: error.attribute, code: error.type)
      end
      result
    end
  end
end
