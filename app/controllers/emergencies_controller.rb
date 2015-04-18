class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update]
  # GET /emergencies
  def index
    @emergencies = Emergency.all
    render formats: [:json]
  end

  # GET /emergencies/1
  def show
    render formats: [:json]
  end

  # POST /emergencies
  def create
    @emergency = Emergency.new(emergency_params)

    if @emergency.save
      render :show, formats: [:json], status: :created, location: @emergency
    else
      render json: @emergency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emergencies/1
  def update
    if @emergency.update(emergency_params)
      render :show, formats: [:json], status: :ok, location: @emergency
    else
      render json: @emergency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emergencies/1
  def destroy
    @emergency = Emergency.find(params[:id])
    @emergency.destroy
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end
end
