class User < ApplicationRecord
  validates :access_token, presence: true, uniqueness: true

  has_many :pins, dependent: :destroy

  before_validation :set_access_token

  def set_access_token
    return if access_token.present?
    self.access_token = SecureRandom.hex(16)
  end

  def storage_limit_reached?
    used_storage >= storage_limit
  end

  # Note: Using a lock to prevent race conditions from saving a wrong value.
  def update_used_storage(add: nil, remove: nil)
    with_lock do
      self.used_storage += add if add
      self.used_storage -= remove if remove
      self.used_storage = 0 if used_storage.negative?
      save!
    end
  end
end
