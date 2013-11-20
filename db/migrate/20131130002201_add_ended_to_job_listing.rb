class AddEndedToJobListing < ActiveRecord::Migration
  def change
    add_column :job_listings, :ended, :boolean
  end
end
