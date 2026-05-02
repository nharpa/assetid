class CharacteristicAllowedValuesController < ApplicationController
  before_action :require_admin
  before_action :set_characteristic

  def create
    @cav = @characteristic.characteristic_allowed_values.build(cav_params)
    if @cav.save
      redirect_to @characteristic, notice: "Allowed value added."
    else
      redirect_to @characteristic, alert: @cav.errors.full_messages.join(", ")
    end
  end

  def destroy
    @characteristic.characteristic_allowed_values.find(params[:id]).destroy
    redirect_to @characteristic, notice: "Allowed value removed."
  end

  private

  def set_characteristic
    @characteristic = Characteristic.find(params[:characteristic_id])
  end

  def cav_params
    params.require(:characteristic_allowed_value).permit(:value)
  end
end
