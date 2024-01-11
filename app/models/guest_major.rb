class GuestMajor < ApplicationRecord
  belongs_to :board, counter_cache: true

  def self.ransackable_attributes(auth_object = nil)
    ["board_id", "created_at", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["board"]
  end
end
