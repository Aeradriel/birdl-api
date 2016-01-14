class AddWasThereToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :was_there, :boolean
  end
end
