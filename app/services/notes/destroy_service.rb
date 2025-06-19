module Notes
  class DestroyService < ApplicationService
    def call
      note = @context[:note]

      if note.destroy
        result.success = true
      else
        errors = note.errors.map do |error|
          { message: error.message, field: error.attribute, code: error.type }
        end
        result.success = false
        result.add_error(errors)
      end

      result
    end
  end
end
