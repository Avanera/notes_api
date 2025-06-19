class ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  private

  def render_not_found(exception)
    render json: {
      errors: [ {
        message: exception.message,
        code: "not_found"
      } ]
    }, status: :not_found
  end

  def render_bad_request(exception)
    render json: {
      errors: [ {
        message: exception.message,
        code: "bad_request"
      } ]
    }, status: :bad_request
  end

  def render_unprocessable_entity(exception)
    errors = exception.record.errors.map do |error|
      {
        field: error.attribute,
        message: error.message,
        code: error.type
      }
    end

    render json: { errors: errors }, status: :unprocessable_entity
  end
end
