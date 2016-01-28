class AddImagePathToEvents < ActiveRecord::Migration
  def change
    add_column :events, :imagePath, :string
  end
end
