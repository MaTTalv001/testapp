class AddImageFilenameToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :image_filename, :string
  end
end
