class AddOhlohAccount < ActiveRecord::Migration
  def change
    add_column :programmers, :ohloh_username, :string
  end
end
