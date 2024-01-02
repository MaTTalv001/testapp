class AddMajorsCountToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :majors_count, :integer, default: 0
  end
end
