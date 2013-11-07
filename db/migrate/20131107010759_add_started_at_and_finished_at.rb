class AddStartedAtAndFinishedAt < ActiveRecord::Migration
  def change
    add_column :jobs, :started_at, :timestamp
    add_column :jobs, :finished_at, :timestamp
  end
end
