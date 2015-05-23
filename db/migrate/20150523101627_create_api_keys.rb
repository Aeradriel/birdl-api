class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.belongs_to :user, index: true
      t.integer :available

      t.timestamps null: false
    end
    add_foreign_key :api_keys, :users
  end
end
