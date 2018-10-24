class User < ApplicationRecord
  has_many :events, -> { order(id: :asc) }, class_name: "Users::Events::Base"

  scope :active, -> { where(deleted_at: nil) }

  validates :name, :description, presence: true
end
