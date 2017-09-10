class CreateHorses < ActiveRecord::Migration[5.1]
  def change
    create_table :horses do |t|
    	t.string :selectionId
    	t.string :name
    	t.integer :order
    	t.string :marketId
    	t.string :meetingId
    	t.timestamps
    end
  end
end
