class LocationsController < ApplicationController
  before_action :set_location, only: [ :show, :edit, :update, :destroy ]

  def index
    @locations = Location.order(:plant_name)
  end

  def show
    @assets = @location.assets.includes(:asset_class).order(:asset_tag)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location, notice: "Location created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      redirect_to @location, notice: "Location updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @location.destroy
      redirect_to locations_path, notice: "Location deleted."
    else
      redirect_to @location, alert: @location.errors.full_messages.join(", ")
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:plant_name, :address_line_1, :address_line_2, :suburb, :state, :notes)
  end
end
