class AddColumnToRaces < ActiveRecord::Migration[5.1]
  def change
	add_column :races, :william_hill_id, :string
  end
end
