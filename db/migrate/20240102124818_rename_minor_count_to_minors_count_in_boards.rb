class RenameMinorCountToMinorsCountInBoards < ActiveRecord::Migration[7.1]
  def change
    rename_column :boards, :minor_count, :minors_count
  end
end
