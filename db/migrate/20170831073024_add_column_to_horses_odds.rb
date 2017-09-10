class AddColumnToHorsesOdds < ActiveRecord::Migration[5.1]
  def change
	add_column :horses, :william_hill_odds, :string
  end
end
