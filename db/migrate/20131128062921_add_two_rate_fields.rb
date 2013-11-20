class AddTwoRateFields < ActiveRecord::Migration
  def change
    add_column :jobs, :fixed_rate, :integer
    rename_column :jobs, :rate, :hourly_rate
    Job.update_all(rate_type: 'hourly')
  end
end
