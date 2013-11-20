class CreateJobListingsAndJobApplications < ActiveRecord::Migration
  def change
    create_table :job_listings do |t|
      t.string :title
      t.string :description
      t.integer :client_id
      t.integer :min_hours_per_week
      t.integer :max_hours_per_week
      t.string :duration
      t.string :visibility
      t.integer :suggested_fixed_rate
      t.integer :suggested_hourly_rate
      t.string :suggested_rate_type
      t.timestamps
    end
    create_table :job_applications do |t|
      t.integer :programmer_id
      t.integer :bid_rate
      t.string :bid_rate_type
      t.timestamps
    end
  end
end
