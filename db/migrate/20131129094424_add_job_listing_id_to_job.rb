class AddJobListingIdToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :job_listing_id, :integer
  end
end
