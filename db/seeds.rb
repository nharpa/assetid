# ── Users ────────────────────────────────────────────────────────────────────
admin = User.find_or_create_by!(email: "admin@assetid.com") do |u|
  u.name     = "Admin User"
  u.password = "password123"
  u.role     = "admin"
end

staff = User.find_or_create_by!(email: "staff@assetid.com") do |u|
  u.name     = "Staff Member"
  u.password = "password123"
  u.role     = "staff"
end

puts "Users: #{User.count}"

# ── Locations ────────────────────────────────────────────────────────────────
hillview = Location.find_or_create_by!(plant_name: "Hillview Water Treatment Plant") do |l|
  l.address_line_1 = "123 Treatment Road"
  l.suburb         = "Hillview"
  l.state          = "NSW"
  l.notes          = "Primary drinking water treatment facility serving the Hillview region."
end

riverside = Location.find_or_create_by!(plant_name: "Riverside Wastewater Treatment Plant") do |l|
  l.address_line_1 = "456 River Drive"
  l.suburb         = "Riverside"
  l.state          = "VIC"
  l.notes          = "Municipal wastewater treatment plant with tertiary treatment capability."
end

puts "Locations: #{Location.count}"

# ── Asset Classes ─────────────────────────────────────────────────────────────
plant_class    = AssetClass.find_or_create_by!(name: "Plant")           { |ac| ac.description = "Top-level plant or facility." }
module_class   = AssetClass.find_or_create_by!(name: "Treatment Module") { |ac| ac.description = "A discrete treatment process module within a plant." }
building_class = AssetClass.find_or_create_by!(name: "Building")        { |ac| ac.description = "A physical building or structure." }
area_class     = AssetClass.find_or_create_by!(name: "Area")            { |ac| ac.description = "A functional area or zone within a building." }
pump_class     = AssetClass.find_or_create_by!(name: "Pump")            { |ac| ac.description = "Mechanical pump for fluid transfer." }
valve_class    = AssetClass.find_or_create_by!(name: "Valve")           { |ac| ac.description = "Flow control valve." }
sensor_class   = AssetClass.find_or_create_by!(name: "Sensor")          { |ac| ac.description = "Measurement or monitoring sensor." }
tank_class     = AssetClass.find_or_create_by!(name: "Tank")            { |ac| ac.description = "Storage or process tank." }

puts "Asset Classes: #{AssetClass.count}"

# ── Characteristics ───────────────────────────────────────────────────────────
manufacturer  = Characteristic.find_or_create_by!(name: "Manufacturer")  { |c| c.data_type = "string";  c.description = "Equipment manufacturer name." }
capacity      = Characteristic.find_or_create_by!(name: "Capacity")      { |c| c.data_type = "decimal"; c.unit = "L/s";  c.description = "Rated flow or volume capacity." }
condition     = Characteristic.find_or_create_by!(name: "Condition")     { |c| c.data_type = "enum";    c.description = "Current physical condition of the asset." }
voltage       = Characteristic.find_or_create_by!(name: "Voltage")       { |c| c.data_type = "decimal"; c.unit = "V";    c.description = "Operating voltage." }
flow_rate     = Characteristic.find_or_create_by!(name: "Flow Rate")     { |c| c.data_type = "decimal"; c.unit = "m³/h"; c.description = "Measured or rated flow rate." }
material      = Characteristic.find_or_create_by!(name: "Material")      { |c| c.data_type = "string";  c.description = "Primary construction material." }

puts "Characteristics: #{Characteristic.count}"

# ── Allowed values for Condition (enum) ───────────────────────────────────────
%w[Good Fair Poor].each do |val|
  CharacteristicAllowedValue.find_or_create_by!(characteristic: condition, value: val)
end

puts "Allowed values: #{CharacteristicAllowedValue.count}"

# ── Asset Class Characteristics ───────────────────────────────────────────────
def assign(asset_class, characteristic, required: false, order: 10)
  AssetClassCharacteristic.find_or_create_by!(asset_class: asset_class, characteristic: characteristic) do |acc|
    acc.required      = required
    acc.display_order = order
  end
end

assign pump_class,   manufacturer, required: true,  order: 10
assign pump_class,   capacity,     required: true,  order: 20
assign pump_class,   voltage,      required: false, order: 30
assign pump_class,   condition,    required: true,  order: 40

assign valve_class,  manufacturer, required: false, order: 10
assign valve_class,  material,     required: false, order: 20
assign valve_class,  condition,    required: true,  order: 30

assign tank_class,   manufacturer, required: false, order: 10
assign tank_class,   capacity,     required: true,  order: 20
assign tank_class,   condition,    required: true,  order: 30

assign sensor_class, manufacturer, required: false, order: 10
assign sensor_class, voltage,      required: false, order: 20

puts "Asset Class Characteristics: #{AssetClassCharacteristic.count}"

# ── Asset Hierarchy – Hillview WTP ────────────────────────────────────────────
hv_plant = Asset.find_or_create_by!(asset_tag: "HV-PLANT-001") do |a|
  a.name       = "Hillview Water Treatment Plant"
  a.asset_class = plant_class
  a.location    = hillview
  a.status      = "active"
  a.installation_date = Date.new(2005, 3, 15)
end

hv_tm1 = Asset.find_or_create_by!(asset_tag: "HV-TM-001") do |a|
  a.name         = "Primary Treatment Module"
  a.asset_class  = module_class
  a.location     = hillview
  a.parent_asset = hv_plant
  a.status       = "active"
end

hv_bldg1 = Asset.find_or_create_by!(asset_tag: "HV-BLDG-001") do |a|
  a.name         = "Pump Station A"
  a.asset_class  = building_class
  a.location     = hillview
  a.parent_asset = hv_tm1
  a.status       = "active"
  a.installation_date = Date.new(2005, 3, 15)
end

hv_area1 = Asset.find_or_create_by!(asset_tag: "HV-AREA-001") do |a|
  a.name         = "Ground Level – Pump Bay"
  a.asset_class  = area_class
  a.location     = hillview
  a.parent_asset = hv_bldg1
  a.status       = "active"
end

hv_pump1 = Asset.find_or_create_by!(asset_tag: "HV-PUMP-001") do |a|
  a.name          = "Primary Feed Pump 1"
  a.asset_class   = pump_class
  a.location      = hillview
  a.parent_asset  = hv_area1
  a.make          = "Grundfos"
  a.model         = "CM5-6"
  a.serial_number = "GF-20180423-001"
  a.purchase_date = Date.new(2018, 4, 23)
  a.purchase_cost = 12_500.00
  a.installation_date = Date.new(2018, 5, 10)
  a.status        = "active"
  a.last_inspected_at = DateTime.new(2025, 11, 14, 9, 0, 0)
end

hv_pump2 = Asset.find_or_create_by!(asset_tag: "HV-PUMP-002") do |a|
  a.name          = "Primary Feed Pump 2"
  a.asset_class   = pump_class
  a.location      = hillview
  a.parent_asset  = hv_area1
  a.make          = "KSB"
  a.model         = "Etanorm 32-200"
  a.serial_number = "KSB-20190801-007"
  a.purchase_date = Date.new(2019, 8, 1)
  a.purchase_cost = 9_800.00
  a.installation_date = Date.new(2019, 9, 3)
  a.status        = "under_maintenance"
  a.last_inspected_at = DateTime.new(2026, 1, 20, 14, 30, 0)
end

hv_vlv1 = Asset.find_or_create_by!(asset_tag: "HV-VLV-001") do |a|
  a.name          = "Primary Inlet Valve"
  a.asset_class   = valve_class
  a.location      = hillview
  a.parent_asset  = hv_area1
  a.make          = "AVK"
  a.model         = "Series 55"
  a.serial_number = "AVK-20180423-002"
  a.purchase_date = Date.new(2018, 4, 23)
  a.status        = "active"
end

hv_tm2 = Asset.find_or_create_by!(asset_tag: "HV-TM-002") do |a|
  a.name         = "Secondary Treatment Module"
  a.asset_class  = module_class
  a.location     = hillview
  a.parent_asset = hv_plant
  a.status       = "active"
end

hv_bldg2 = Asset.find_or_create_by!(asset_tag: "HV-BLDG-002") do |a|
  a.name         = "Filter Building"
  a.asset_class  = building_class
  a.location     = hillview
  a.parent_asset = hv_tm2
  a.status       = "active"
end

hv_area2 = Asset.find_or_create_by!(asset_tag: "HV-AREA-002") do |a|
  a.name         = "Filter Floor"
  a.asset_class  = area_class
  a.location     = hillview
  a.parent_asset = hv_bldg2
  a.status       = "active"
end

hv_tank1 = Asset.find_or_create_by!(asset_tag: "HV-TNK-001") do |a|
  a.name          = "Sand Filter Tank 1"
  a.asset_class   = tank_class
  a.location      = hillview
  a.parent_asset  = hv_area2
  a.make          = "Pentair"
  a.model         = "FNS Plus"
  a.serial_number = "PNT-20100601-001"
  a.purchase_date = Date.new(2010, 6, 1)
  a.purchase_cost = 45_000.00
  a.status        = "active"
end

# ── Asset Hierarchy – Riverside WWTP ─────────────────────────────────────────
rv_plant = Asset.find_or_create_by!(asset_tag: "RV-PLANT-001") do |a|
  a.name        = "Riverside Wastewater Treatment Plant"
  a.asset_class = plant_class
  a.location    = riverside
  a.status      = "active"
  a.installation_date = Date.new(1998, 7, 1)
end

rv_tm1 = Asset.find_or_create_by!(asset_tag: "RV-TM-001") do |a|
  a.name         = "Influent Treatment Module"
  a.asset_class  = module_class
  a.location     = riverside
  a.parent_asset = rv_plant
  a.status       = "active"
end

rv_pump1 = Asset.find_or_create_by!(asset_tag: "RV-PUMP-001") do |a|
  a.name          = "Influent Pump 1"
  a.asset_class   = pump_class
  a.location      = riverside
  a.parent_asset  = rv_tm1
  a.make          = "Flygt"
  a.model         = "NT 3153"
  a.serial_number = "FLY-20150310-001"
  a.purchase_date = Date.new(2015, 3, 10)
  a.purchase_cost = 18_200.00
  a.installation_date = Date.new(2015, 4, 8)
  a.status        = "active"
  a.last_inspected_at = DateTime.new(2025, 12, 3, 10, 0, 0)
end

puts "Assets: #{Asset.count}"

# ── Characteristic Values ─────────────────────────────────────────────────────
def set_value(asset, characteristic_name, value)
  acc = asset.asset_class.asset_class_characteristics
              .joins(:characteristic)
              .find_by(characteristics: { name: characteristic_name })
  return unless acc

  AssetCharacteristicValue.find_or_create_by!(asset: asset, asset_class_characteristic: acc) do |v|
    v.value = value
  end
end

set_value(hv_pump1, "Manufacturer", "Grundfos")
set_value(hv_pump1, "Capacity",     "15.5")
set_value(hv_pump1, "Voltage",      "415")
set_value(hv_pump1, "Condition",    "Good")

set_value(hv_pump2, "Manufacturer", "KSB")
set_value(hv_pump2, "Capacity",     "12.0")
set_value(hv_pump2, "Voltage",      "415")
set_value(hv_pump2, "Condition",    "Fair")

set_value(hv_vlv1, "Manufacturer", "AVK")
set_value(hv_vlv1, "Material",     "Ductile Iron")
set_value(hv_vlv1, "Condition",    "Good")

set_value(hv_tank1, "Manufacturer", "Pentair")
set_value(hv_tank1, "Capacity",     "250.0")
set_value(hv_tank1, "Condition",    "Good")

set_value(rv_pump1, "Manufacturer", "Flygt")
set_value(rv_pump1, "Capacity",     "22.0")
set_value(rv_pump1, "Voltage",      "415")
set_value(rv_pump1, "Condition",    "Good")

puts "Characteristic Values: #{AssetCharacteristicValue.count}"
puts ""
puts "Seed complete."
puts "  Admin login:  admin@assetid.com / password123"
puts "  Staff login:  staff@assetid.com / password123"
