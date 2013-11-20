class AddMinAndMaxHourlyRate < ActiveRecord::Migration
  def change
    add_column :job_listings, :min_hourly_rate, :integer
    add_column :job_listings, :max_hourly_rate, :integer
    remove_column :job_listings, :suggested_hourly_rate, :integer
  end
end
