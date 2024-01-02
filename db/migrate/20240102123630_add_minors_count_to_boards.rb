class AddMinorsCountToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :minor_count, :integer, default: 0
  end
end
