class AssetClassCharacteristicsController < ApplicationController
  before_action :require_admin
  before_action :set_asset_class

  def create
    @acc = @asset_class.asset_class_characteristics.build(acc_params)
    if @acc.save
      redirect_to @asset_class, notice: "Characteristic added."
    else
      redirect_to @asset_class, alert: @acc.errors.full_messages.join(", ")
    end
  end

  def destroy
    @asset_class.asset_class_characteristics.find(params[:id]).destroy
    redirect_to @asset_class, notice: "Characteristic removed."
  end

  private

  def set_asset_class
    @asset_class = AssetClass.find(params[:asset_class_id])
  end

  def acc_params
    params.require(:asset_class_characteristic).permit(:characteristic_id, :required, :display_order)
  end
end
