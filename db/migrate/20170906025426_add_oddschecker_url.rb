class AddOddscheckerUrl < ActiveRecord::Migration[5.1]
  def change
  	add_column :meetings, :oddschecker_url, :string
  end
end
