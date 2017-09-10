class CreateTips < ActiveRecord::Migration[5.1]
  def change
    create_table :tips do |t|
    	t.integer :user_id
    	t.string :selectionId
    	t.string :name
    	t.integer :order
    	t.string :marketId
    	t.string :meetingId
    	t.string :meeting_name
    	t.string :race_time
    	t.string :average_odds
    	t.string :deductions
    	t.string :bsp
    	t.string :result
    	t.timestamps
    end
  end
end
