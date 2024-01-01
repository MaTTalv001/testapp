class RemoveImageFilenameFromBoards < ActiveRecord::Migration[7.1]
  def change
    remove_column :boards, :image_filename, :string
  end
end
