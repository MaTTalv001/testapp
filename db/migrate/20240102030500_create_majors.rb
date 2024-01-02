class CreateMajors < ActiveRecord::Migration[7.1]
  def change
    create_table :majors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
    add_index :majors, [:user_id, :board_id], unique: true
  end
end
