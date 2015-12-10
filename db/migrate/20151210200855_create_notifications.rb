class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user, index: true
      t.string :text, default: ''
      t.string :subject, default: ''
      t.boolean :seen, default: false

      t.timestamps null: false
    end
    add_foreign_key :notifications, :users
  end
end
