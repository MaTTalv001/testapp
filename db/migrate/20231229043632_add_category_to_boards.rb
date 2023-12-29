class AddCategoryToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :category, :string
  end
end
