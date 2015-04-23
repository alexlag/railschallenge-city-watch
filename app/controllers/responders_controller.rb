class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update, :destroy]

  def index
    if params[:show] == 'capacity'
      @info = Responder.capacity_info
      render :capacity
    else
      @responders = Responder.all
    end
  end

  def show
  end

  def create
    @responder = Responder.new(responder_params)

    if @responder.save
      render :show, status: :created, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @responder.update(update_responder_params)
      render :show, status: :ok, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @responder.destroy
    head :no_content
  end

  private

  def set_responder
    @responder = Responder.find_by_name(params[:id])
    fail ActiveRecord::RecordNotFound if @responder.nil?
  end

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
