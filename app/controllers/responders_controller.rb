class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update]

  # GET /responders
  def index
    @responders = Responder.all
  end

  # GET /responders/1
  def show
    @responder = Responder.find(params[:id])
  end

  # POST /responders
  def create
    @responder = Responder.new(responder_params)

    if @responder.save
      render :show, status: :created, location: @responder
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /responders/1
  def update
    if @responder.update(responder_params)
      render :show, status: :ok, location: @responder
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /responders/1
  def destroy
    @responder = Responder.find(params[:id])
    @responder.destroy
    head :no_content
  end

  private

  def set_responder
    @responder = Responder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end
end
