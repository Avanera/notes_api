class Api::V1::NotesController < ApplicationController
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
    note = Note.find(params[:id])

    render json: {
      data: NoteBlueprint.render_as_hash(note, view: :detailed)
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

  # PATCH /api/v1/notes/1
  def update
    note = Note.find(params[:id])
    result = Notes::UpdateService.call(note:, params: note_params)

    if result.success?
      render json: { data: result.data }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/notes/1
  def destroy
    note = Note.find(params[:id])
    result = Notes::DestroyService.call(note:)

    if result.success?
      head :no_content
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/notes/1/rewrite
  def rewrite
    note = Note.find(params[:id])
    result = Notes::RewriteService.call(
      note:,
      rewrite_mode: params[:rewrite_mode].to_i
    )

    if result.success?
      render json: { data: result.data }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.expect(note: [ :title, :body, :archived ])
  end

  def filter_params
    params.permit(:page, :per_page, :archived)
  end
end
