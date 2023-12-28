class AddDisplayNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :displayname, :string, null: false
  end
end
