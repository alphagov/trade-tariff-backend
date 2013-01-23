class ChiefImporter
  module Strategies
    class TAME < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: 2,
          msr_type: 3,
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          adval_rate: 8,
          alch_sgth: 9,
          audit_tsmp: [10, :chief_date],
          cap_ai_stmt: 11,
          cap_max_pct: 12,
          cmdty_msr_xhdg: 13,
          comp_mthd: 14,
          cpc_wvr_phb: 15,
          ec_msr_set: 16,
          mip_band_exch: 17,
          mip_rate_exch: 18,
          mip_uoq_code: 19,
          nba_id: 20,
          null_tri_rqd: 21,
          qta_code_uk: 22,
          qta_elig_use: 23,
          qta_exch_rate: 24,
          qta_no: 25,
          qta_uoq_code: 26,
          rfa: 27,
          rfs_code_1: 28,
          rfs_code_2: 29,
          rfs_code_3: 30,
          rfs_code_4: 31,
          rfs_code_5: 32,
          tdr_spr_sur: 33,
          exports_use_ind: 34,
          amend_indicator: 1

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }

      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }

      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }
    end

    class TAMF < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: [2, :chief_string],
          msr_type: [3, :chief_string],
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          adval1_rate: [7, :chief_decimal],
          adval2_rate: [8, :chief_decimal],
          ai_factor: [9, :chief_string],
          cmdty_dmql: [10, :chief_decimal],
          cmdty_dmql_uoq: [11, :chief_string],
          cngp_code: [12, :chief_string],
          cntry_disp: [13, :chief_string],
          cntry_orig: [14, :chief_string],
          duty_type: [15, :chief_string],
          ec_supplement: [16, :chief_string],
          ec_exch_rate: [17, :chief_string],
          spcl_inst: [18, :chief_string],
          spfc1_cmpd_uoq: [19, :chief_string],
          spfc1_rate: [20, :chief_decimal],
          spfc1_uoq: [21, :chief_string],
          spfc2_rate: [22, :chief_decimal],
          spfc2_uoq: [23, :chief_string],
          spfc3_rate: [24, :chief_decimal],
          spfc3_uoq: [25, :chief_string],
          tamf_dt: [26, :chief_string],
          tamf_sta: [27, :chief_string],
          tamf_ty: [28, :chief_string],
          amend_indicator: 1

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
    end

    class MFCM < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: 2,
          msr_type: 3,
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          audit_tsmp: [8, :chief_date],
          cmdty_code: [9, :chief_code],
          cmdty_msr_xhdg: [10, :chief_string],
          null_tri_rqd: [11, :chief_string],
          exports_use_ind: 12,
          amend_indicator: 1

      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Mfcm.insert map
        end
      }

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
            Chief::Mfcm.insert map
        end
      }

      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
            Chief::Mfcm.insert map
        end
      }
    end

    class COMM < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          amend_indicator: 1,
          cmdty_code: [2, :chief_code],
          le_tsmp: [3, :chief_date],
          add_rlf_alwd_ind: 5,
          alcohol_cmdty: 6,
          audit_tsmp: [7, :chief_date],
          chi_doti_rqd: 8,
          cmdty_bbeer: 9,
          cmdty_beer: 10,
          cmdty_euse_alwd: 11,
          cmdty_exp_rfnd: 12,
          cmdty_mdecln: 13,
          exp_lcnc_rqd: 14,
          ex_ec_scode_rqd: 15,
          full_dty_adval1: [16, :chief_decimal],
          full_dty_adval2: [17, :chief_decimal],
          full_dty_exch: [18, :chief_string],
          full_dty_spfc1: [19, :chief_decimal],
          full_dty_spfc2: [20, :chief_decimal],
          full_dty_ttype: [21, :chief_string],
          full_dty_uoq_c2: [22, :chief_string],
          full_dty_uoq1: [23, :chief_string],
          full_dty_uoq2: [24, :chief_string],
          full_duty_type: [25, :chief_string],
          im_ec_score_rqd: 26,
          imp_exp_use: 27,
          nba_id: [28, :chief_string],
          perfume_cmdty: 29,
          rfa: [30, :chief_string],
          season_end: 31,
          season_start: 32,
          spv_code: [33, :chief_string],
          spv_xhdg: 34,
          uoq_code_cdu1: [35, :chief_string],
          uoq_code_cdu2: [36, :chief_string],
          uoq_code_cdu3: [37, :chief_string],
          whse_cmdty: 38,
          wines_cmdty: 39

      process(:update) {
        Chief::Comm.insert(map)
      }

      process(:insert) {
        Chief::Comm.insert(map)
      }

      process(:delete) {
        Chief::Comm.insert(map)
      }
    end

    class TBL9 < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          amend_indicator: 1,
          tbl_type: [2, :chief_string],
          tbl_code: [3, :chief_string],
          txtlnno: 4,
          tbl_txt: [6, :chief_string]

      process(:update) {
        # TODO we only need UNOQ table at this point
        Chief::Tbl9.insert(map)
      }

      process(:insert) {
        # TODO we only need UNOQ table at this point
        Chief::Tbl9.insert(map)
      }

      process(:delete) {
        # TODO we only need UNOQ table at this point
        Chief::Tbl9.insert(map)
      }
    end
  end
end
