class Api::V1::NotesController < ApplicationController
  before_action :set_note, only: [ :show, :update, :destroy, :rewrite, :archive, :unarchive ]

  # GET /api/v1/notes
  def index
    result = Notes::IndexService.call(params: filter_params)

    if result.success?
      render json: {
        data: result.data[:notes],
        meta: result.data[:meta]
      }
    else
      render json: { errors: result.errors }, status: :bad_request
    end
  end

  # GET /api/v1/notes/1
  def show
    render json: {
      data: NoteBlueprint.render_as_hash(@note, view: :detailed)
    }
  end

  # POST /api/v1/notes
  def create
    result = Notes::CreateService.call(params: note_params)

    if result.success?
      render json: { data: result.data }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/notes/1
  def update
    result = Notes::UpdateService.call(note: @note, params: note_params)

    if result.success?
      render json: {
        data: result.data
      }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/notes/1
  def destroy
    result = Notes::DestroyService.call(note: @note)

    if result.success?
      head :no_content
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/notes/1/rewrite
  def rewrite
    result = Notes::RewriteService.call(
      note: @note,
      rewrite_mode: params[:rewrite_mode]
    )

    if result.success?
      render json: { data: result.data }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/notes/1/archive
  def archive
    result = Notes::ArchiveService.call(note: @note)

    if result.success?
      render json: { data: result.data }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/notes/1/unarchive
  def unarchive
    result = Notes::UnarchiveService.call(note: @note)
    
    if result.success?
      render json: { data: result.data }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.expect(note: [ :title, :body ])
  end

  def filter_params
    params.permit(:page, :per_page, :archived)
  end
end
