class AddRankScore < ActiveRecord::Migration
  def change
    add_column :programmers, :rank_score, :integer
    add_column :programmers, :modified_rank_score, :float

    add_index :programmers, :modified_rank_score
  end
end
