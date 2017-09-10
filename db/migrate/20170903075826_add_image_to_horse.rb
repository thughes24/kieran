class AddImageToHorse < ActiveRecord::Migration[5.1]
  def change
  	add_column :horses, :image, :string
  	add_column :tips, :image, :string
  end
end
