require 'goods_nomenclature_mapper'

module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.actual
                          .non_grouping
                          .where(goods_nomenclatures__goods_nomenclature_item_id: heading_id)
                          .take

        if @heading.declarable?
          @measures = MeasurePresenter.new(@heading.measures_dataset.eager({geographical_area: [:geographical_area_description, :children_geographical_areas]},
                                                      {footnotes: :footnote_description},
                                                      {type: :measure_type_description},
                                                      {measure_components: [:duty_expression,
                                                                            {measurement_unit: :measurement_unit_description},
                                                                            :monetary_unit,
                                                                            :measurement_unit_qualifier]},
                                                      {measure_conditions: [{measure_action: :measure_action_description},
                                                                            {certificate: :certificate_description},
                                                                            {certificate_type: :certificate_type_description},
                                                                            {measurement_unit: :measurement_unit_description},
                                                                            :monetary_unit,
                                                                            :measurement_unit_qualifier,
                                                                            :measure_condition_code,
                                                                            :measure_condition_components]},
                                                      {quota_order_number: :quota_definition},
                                                      {excluded_geographical_areas: :geographical_area_description},
                                                      :additional_code,
                                                      :full_temporary_stop_regulation,
                                                      :measure_partial_temporary_stop).all, @heading).validate!
        else
          @commodities = GoodsNomenclatureMapper.new(@heading.commodities_dataset.eager(:goods_nomenclature_indent,
                                                                                        :goods_nomenclature_description)
                                                             .all
                                                             .delete_if{|c| c.goods_nomenclature_item_id =~ HiddenGoodsNomenclature.to_pattern}).all

        end

        respond_with @heading
      end

      def heading_id
        "#{params[:id]}000000"
      end
    end
  end
end
