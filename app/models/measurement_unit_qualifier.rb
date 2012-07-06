class MeasurementUnitQualifier < ActiveRecord::Base
  self.primary_keys =  :measurement_unit_qualifier_code

  has_many :measure_components, foreign_key: :measurement_unit_qualifier_code
  has_many :quota_definitions, foreign_key: :measurement_unit_qualifier_code
  has_many :measure_condition_components, foreign_key: :measurement_unit_qualifier_code
  has_many :measure_conditions, foreign_key: :condition_measurement_unit_qualifier_code
  has_many :measurements, foreign_key: :measurement_unit_qualifier_code
  has_one  :measurement_unit_qualifier_description, foreign_key: :measurement_unit_qualifier_code
end

# == Schema Information
#
# Table name: measurement_unit_qualifiers
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  measurement_unit_qualifier_code :string(255)
#  validity_start_date             :date
#  validity_end_date               :date
#  created_at                      :datetime
#  updated_at                      :datetime
#

