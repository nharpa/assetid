class CharacteristicsController < ApplicationController
  before_action :set_characteristic, only: [:show, :edit, :update, :destroy]

  def index
    @characteristics = Characteristic.order(:name)
  end

  def show
    @allowed_values = @characteristic.characteristic_allowed_values.order(:value)
    @new_allowed_value = CharacteristicAllowedValue.new(characteristic: @characteristic)
    @asset_classes = @characteristic.asset_classes.order(:name)
  end

  def new
    @characteristic = Characteristic.new
  end

  def create
    @characteristic = Characteristic.new(characteristic_params)
    if @characteristic.save
      redirect_to @characteristic, notice: "Characteristic created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @characteristic.update(characteristic_params)
      redirect_to @characteristic, notice: "Characteristic updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @characteristic.destroy
      redirect_to characteristics_path, notice: "Characteristic deleted."
    else
      redirect_to @characteristic, alert: @characteristic.errors.full_messages.join(", ")
    end
  end

  private

  def set_characteristic
    @characteristic = Characteristic.find(params[:id])
  end

  def characteristic_params
    params.require(:characteristic).permit(:name, :data_type, :description, :unit)
  end
end
