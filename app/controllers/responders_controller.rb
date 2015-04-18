class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update, :destroy]

  # GET /responders
  def index
    if params[:show] == 'capacity'
      @info = Responder.capacity_info
      render :capacity
    else
      @responders = Responder.all
      render :index
    end
  end

  # GET /responders/1
  def show
    render :show
  end

  # POST /responders
  def create
    @responder = Responder.new(responder_params)

    if @responder.save
      render :show, status: :created, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /responders/1
  def update
    if @responder.update(update_responder_params)
      render :show, status: :ok, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /responders/1
  def destroy
    @responder.destroy
    head :no_content
  end

  private

  def set_responder
    @responder = Responder.find_by_name(params[:id])
    fail ActiveRecord::RecordNotFound if @responder.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
