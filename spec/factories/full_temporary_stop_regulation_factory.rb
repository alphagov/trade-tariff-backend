FactoryGirl.define do
  factory :full_temporary_stop_regulation do
    full_temporary_stop_regulation_role { Forgery(:basic).number }
    full_temporary_stop_regulation_id   { Forgery(:basic).text(exactly: 8) }
    validity_start_date                 { Time.now.ago(2.years) }
    validity_end_date                   { nil }
    effective_enddate                   { nil }
  end
end
