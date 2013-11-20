class AddDeliveryDateToJobListings < ActiveRecord::Migration
  def change
    add_column :job_listings, :delivery_date, :date
    remove_column :job_listings, :duration, :string
  end
end
