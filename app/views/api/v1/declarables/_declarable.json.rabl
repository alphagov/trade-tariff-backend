node(:declarable) { true }

child :section do
  attributes :title, :position, :numeral
end

child :chapter do
  attributes :short_code, :code, :description
end

node(:import_measures) { |commodity|
  commodity.import_measures.map do |import_measure|
    partial "api/v1/measures/measure", object: import_measure
  end
}

node(:export_measures) { |commodity|
  commodity.export_measures.map do |export_measure|
    partial "api/v1/measures/_measure", object: export_measure
  end
}