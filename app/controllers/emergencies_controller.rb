class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update, :destroy]

  def index
    @emergencies = Emergency.all
    @full_responses = Emergency.full_responses_info
    render :index
  end

  def show
    render :show
  end

  def create
    @emergency = Emergency.new(emergency_params)

    if @emergency.valid?
      @emergency.dispatch_and_save!

      render :show, status: :created, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @emergency.clean_and_update(update_emergency_params)
      render :show, status: :ok, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @emergency.destroy
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find_by_code(params[:id])
    fail ActiveRecord::RecordNotFound if @emergency.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def update_emergency_params
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end
end
