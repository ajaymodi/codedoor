class AddReferredUserId < ActiveRecord::Migration
  def change
    add_column :users, :referred_user_id, :integer
  end
end
