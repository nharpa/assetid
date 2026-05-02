class AssetClassesController < ApplicationController
  before_action :set_asset_class, only: [ :show, :edit, :update, :destroy ]

  def index
    @asset_classes = AssetClass.order(:name)
  end

  def show
    @asset_class_characteristics = @asset_class.asset_class_characteristics.includes(:characteristic).order(:display_order)
    @available_characteristics = Characteristic.order(:name) - @asset_class.characteristics
    @new_acc = AssetClassCharacteristic.new(asset_class: @asset_class)
    @assets = @asset_class.assets.includes(:location).order(:asset_tag)
  end

  def new
    @asset_class = AssetClass.new
  end

  def create
    @asset_class = AssetClass.new(asset_class_params)
    if @asset_class.save
      redirect_to @asset_class, notice: "Asset class created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @asset_class.update(asset_class_params)
      redirect_to @asset_class, notice: "Asset class updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @asset_class.destroy
      redirect_to asset_classes_path, notice: "Asset class deleted."
    else
      redirect_to @asset_class, alert: @asset_class.errors.full_messages.join(", ")
    end
  end

  private

  def set_asset_class
    @asset_class = AssetClass.find(params[:id])
  end

  def asset_class_params
    params.require(:asset_class).permit(:name, :description)
  end
end
