class ChangeProgrammerRateToHourlyRate < ActiveRecord::Migration
  def change
    rename_column :programmers, :rate, :hourly_rate
  end
end
