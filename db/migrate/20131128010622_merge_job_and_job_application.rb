class MergeJobAndJobApplication < ActiveRecord::Migration
  def change
    drop_table :job_applications
    add_column :jobs, :rate_type, :string
  end
end
