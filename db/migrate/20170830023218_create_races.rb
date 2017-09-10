class CreateRaces < ActiveRecord::Migration[5.1]
  def change
    create_table :races do |t|
    	t.string :marketId
    	t.string :meetingId
    	t.string :time
    	t.string :name
    	t.timestamps
    end
  end
end
