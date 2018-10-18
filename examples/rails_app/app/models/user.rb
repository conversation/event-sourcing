class User < ApplicationRecord
  validates :name, :active, :description, presence: true
end
