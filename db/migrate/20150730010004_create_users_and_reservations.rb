class CreateUsersAndReservations < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
    end

    create_table :reservations do |t|
      t.integer :user_id
      t.timestamp :reserved_at

      t.timestamps
    end
   end
end
