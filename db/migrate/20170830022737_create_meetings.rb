class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
    	t.string :meetingId 
    	t.string :name
    	t.string :country
    	t.timestamps
    end
  end
end
