module Chief
  class Tame < Sequel::Model
    set_dataset db[:chief_tame].
                order(:audit_tsmp.asc)

    set_primary_key [:msrgp_code, :msr_type, :tty_code, :fe_tsmp]

    one_to_one :measure_type, key: {}, primary_key: {},
      dataset: -> { Chief::MeasureTypeAdco.where(chief_measure_type_adco__measure_group_code: msrgp_code,
                                                 chief_measure_type_adco__measure_type: msr_type,
                                                 chief_measure_type_adco__tax_type_code: tty_code) },
                                                 class_name: 'Chief::MeasureTypeAdco'

    one_to_one :duty_expression, key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate],
                                 primary_key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate]

    one_to_many :tamfs, key:{}, primary_key: {}, dataset: -> {
      Chief::Tamf.filter{ |o| {:fe_tsmp => fe_tsmp} &
                              {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code} &
                              {:tar_msr_no => tar_msr_no} &
                              {:amend_indicator => amend_indicator}
                              }
    }, class_name: 'Chief::Tamf'

    one_to_many :mfcms, key: {}, primary_key: {}, dataset: -> {
      Chief::Mfcm.filter{ |o| {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code} &
                              {:tar_msr_no => tar_msr_no}
                        }.order(:audit_tsmp.asc)
    }

    dataset_module do
      def untransformed
        filter(transformed: false)
      end
    end

    def adval1_rate; 1; end
    def adval2_rate; 0; end
    def spfc1_rate; 0; end
    def spfc2_rate; 0; end

    def has_tamfs?
      tamfs.any?
    end

    def was_processed?
      mfcms_dataset.where(amend_indicator: ["I", "U"])
                   .untransformed
                   .order(:audit_tsmp.asc)
                   .any?
    end

    def audit_tsmp
      self[:audit_tsmp].presence || Time.now
    end
  end
end


