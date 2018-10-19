class User < ApplicationRecord
  has_many :events, -> { order(id: :asc) }, class_name: "Users::Events::Base"

  validates :name, :active, :description, presence: true
end
