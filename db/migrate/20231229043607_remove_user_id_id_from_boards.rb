class RemoveUserIdIdFromBoards < ActiveRecord::Migration[7.1]
  def change
    remove_column :boards, :user_id_id, :integer
  end
end
