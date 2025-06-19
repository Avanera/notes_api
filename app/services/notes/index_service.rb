module Notes
  class IndexService < ApplicationService
    ARCHIVED_PARAMS = ['true', 'false'].freeze

    def call
      params = @context[:params]
      @notes = Note.all

      # Apply archived filter if present
      if ARCHIVED_PARAMS.include?(params[:archived])
        @notes = params[:archived] == "true" ? @notes.archived : @notes.active
      end

      # Apply pagination
      page = params[:page]&.to_i || 1
      per_page = params[:per_page]&.to_i || 20
      per_page = 100 if per_page > 100 # Max limit
      
      @notes = @notes.page(page).per(per_page)


      result.data = {
        notes: NoteBlueprint.render_as_hash(@notes, view: :default),
        meta: {
          current_page: @notes.current_page,
          total_pages: @notes.total_pages,
          total_count: @notes.total_count,
          per_page: per_page
        }
      }

      result
    end
  end
end
