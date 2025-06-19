module Notes
  class IndexService < ApplicationService
    ARCHIVED_PARAMS = [ "true", "false" ].freeze

    def call
      @notes = Note.all
      filter_archived_notes
      apply_pagination
      build_result
    end

    private

    def filter_archived_notes
      params = @context[:params]
      return unless ARCHIVED_PARAMS.include?(params[:archived])

      @notes = params[:archived] == "true" ? @notes.archived : @notes.active
    end

    def apply_pagination
      params = @context[:params]
      page = params[:page]&.to_i || 1
      per_page = params[:per_page]&.to_i || 20
      per_page = 100 if per_page > 100 # Max limit

      @notes = @notes.page(page).per(per_page)
    end

    def build_result
      result.data = {
        notes: NoteBlueprint.render_as_hash(@notes, view: :default),
        meta: {
          current_page: @notes.current_page,
          total_pages: @notes.total_pages,
          total_count: @notes.total_count,
          per_page: @notes.limit_value
        }
      }

      result
    end
  end
end
