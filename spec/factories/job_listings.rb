FactoryGirl.define do
  factory :job_listing do
    client
    suggested_rate_type 'hourly'
    visibility 'public'
    title 'Test title'
    description 'Test description'
    min_hours_per_week 5
    max_hours_per_week 10
    min_hourly_rate 40
    max_hourly_rate 50
  end
end
