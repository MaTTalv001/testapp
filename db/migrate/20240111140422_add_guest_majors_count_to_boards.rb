class AddGuestMajorsCountToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :guest_majors_count, :integer, default: 0
  end
end
