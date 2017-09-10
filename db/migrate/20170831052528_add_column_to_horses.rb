class AddColumnToHorses < ActiveRecord::Migration[5.1]
  def change
  	add_column :horses, :days_since_last_run, :string
  	add_column :horses, :form, :string
  	add_column :horses, :jockey, :string
  	add_column :horses, :trainer, :string
  	add_column :horses, :stall_draw, :string
  	add_column :horses, :sex, :string
  end
end
