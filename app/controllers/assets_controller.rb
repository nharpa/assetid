# Manages infrastructure assets — the core resource of the application.
# Handles standard CRUD plus characteristic value bulk editing and
# hierarchy tree rendering for the show page.
# Assets are located via asset_tag (not numeric id) in all URLs.
class AssetsController < ApplicationController
  before_action :set_asset, only: [ :show, :edit, :update, :destroy, :characteristic_values, :update_characteristic_values ]

  def index
    @assets = Asset.includes(:asset_class, :location, :parent_asset).all

    if params[:q].present?
      q = "%#{params[:q]}%"
      @assets = @assets.where("assets.asset_tag LIKE ? OR assets.name LIKE ?", q, q)
    end
    @assets = @assets.where(asset_class_id: params[:asset_class_id]) if params[:asset_class_id].present?
    @assets = @assets.where(location_id: params[:location_id]) if params[:location_id].present?
    @assets = @assets.where(status: params[:status]) if params[:status].present?

    @assets = @assets.order(:asset_tag)
    @asset_classes = AssetClass.order(:name)
    @locations = Location.order(:plant_name)
  end

  def show
    @ancestors = @asset.ancestor_chain
    @child_assets = @asset.child_assets.includes(:asset_class).order(:asset_tag)
    @acvs = @asset.asset_characteristic_values.includes(asset_class_characteristic: :characteristic)
    @accs = @asset.asset_class.asset_class_characteristics.includes(:characteristic).order(:display_order)

    # Tree pre-loading: all assets at the root's location are fetched in a single
    # query and indexed by id, avoiding N+1 queries during recursive tree rendering.
    @root = @asset.root_ancestor
    @tree_assets = Asset.includes(:asset_class)
                        .where(location_id: @root.location_id)
                        .index_by(&:id)
  end

  def new
    @asset = Asset.new
    load_form_data
  end

  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      redirect_to @asset, notice: "Asset created."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_data
  end

  def update
    if @asset.update(asset_params)
      redirect_to @asset, notice: "Asset updated."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @asset.destroy
    redirect_to assets_path, notice: "Asset deleted."
  end

  def characteristic_values
    @accs = @asset.asset_class.asset_class_characteristics.includes(:characteristic, characteristic: :characteristic_allowed_values).order(:display_order)
    @acv_map = @asset.asset_characteristic_values.index_by(&:asset_class_characteristic_id)
  end

  # Upserts characteristic values submitted from the bulk edit form.
  # find_or_initialize_by creates a new record or loads the existing one.
  # Blank submissions delete the existing value rather than saving an empty string.
  def update_characteristic_values
    (params[:values] || {}).each do |acc_id, val|
      acc = AssetClassCharacteristic.find_by(id: acc_id)
      next unless acc

      acv = @asset.asset_characteristic_values.find_or_initialize_by(asset_class_characteristic: acc)
      if val.blank?
        acv.destroy if acv.persisted?
      else
        acv.value = val
        acv.save
      end
    end
    redirect_to @asset, notice: "Characteristic values updated."
  end

  private

  # Looks up assets by asset_tag rather than numeric id to support
  # human-readable URLs (e.g. /register/HV-PUMP-001).
  def set_asset
    @asset = Asset.find_by!(asset_tag: params[:id])
  end

  # Excludes the current asset from parent_asset options to prevent
  # an asset being assigned as its own parent.
  def load_form_data
    @asset_classes = AssetClass.order(:name)
    @locations = Location.order(:plant_name)
    @parent_assets = Asset.where.not(id: @asset.id).order(:asset_tag)
  end

  def asset_params
    params.require(:asset).permit(
      :asset_tag, :name, :asset_class_id, :location_id, :parent_asset_id,
      :make, :model, :serial_number, :purchase_date, :purchase_cost,
      :installation_date, :status, :last_inspected_at
    )
  end
end
