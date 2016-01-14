class AddEventIdToUserRatings < ActiveRecord::Migration
  def change
    add_reference :user_ratings, :event, index: true
    add_foreign_key :user_ratings, :events
  end
end
