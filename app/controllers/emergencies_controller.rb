class EmergenciesController < ApplicationController
  def index
    @emergencies = Emergency.all
    @full_responses = Emergency.full_responses_info
  end

  def show
    @emergency = Emergency.find_by_code!(params[:code])
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
    @emergency = Emergency.find_by_code!(params[:code])
    if @emergency.clean_and_update(update_emergency_params)
      render :show, status: :ok, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @emergency = Emergency.find_by_code!(params[:code])
    @emergency.destroy
    head :no_content
  end

  private

  def emergency_params
    params.require(:emergency).permit(:code, *Emergency::SEVERITY_FIELDS)
  end

  def update_emergency_params
    params.require(:emergency).permit(*Emergency::SEVERITY_FIELDS, :resolved_at)
  end
end
