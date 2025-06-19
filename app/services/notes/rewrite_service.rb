module Notes
  class RewriteService < ApplicationService
    VALID_REWRITE_MODES = %w[polite cheerful mysterious].freeze

    def call
      note = @context[:note]
      rewrite_mode = @context[:rewrite_mode]

      unless valid_rewrite_mode?(rewrite_mode)
        result.add_error("Invalid rewrite mode", field: "rewrite_mode", code: "invalid")
        return result
      end

      rewritten_text = AiRewriteService.call(
        text: note.body,
        mode: rewrite_mode
      )

      if rewritten_text.success?
        if note.update(body: rewritten_text.data)
          result.data = NoteBlueprint.render_as_hash(note, view: :detailed)
        else
          note.errors.each do |error|
            result.add_error(error.message, field: error.attribute, code: error.type)
          end
        end
      else
        result.add_error("Failed to rewrite text", code: "ai_service_error")
      end

      result
    rescue StandardError => e
      result.add_error("Rewrite service error: #{e.message}", code: "service_error")
      result
    end

    def valid_rewrite_mode?(rewrite_mode)
      VALID_REWRITE_MODES.include?(rewrite_mode)
    end
  end
end
