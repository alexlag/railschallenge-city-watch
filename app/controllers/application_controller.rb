class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameter

  def unpermitted_parameter(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def not_found
    render json: { message: 'page not found' }, status: :not_found
  end
end
