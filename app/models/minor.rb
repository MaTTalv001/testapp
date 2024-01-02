class Minor < ApplicationRecord
  belongs_to :user
  belongs_to :board, counter_cache: true

  def self.ransackable_attributes(auth_object = nil)
    ["board_id", "created_at", "id", "id_value", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["board", "user"]
  end
end
