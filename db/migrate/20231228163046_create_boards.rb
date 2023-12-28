class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.references :user_id, foreign_key: true
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
