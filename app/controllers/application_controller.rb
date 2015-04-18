class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def routing_error
    render json: { message: 'page not found' }, status: 404
  end

  private

  def record_not_found
    render json: { message: 'page not found' }, status: 404
  end
end
