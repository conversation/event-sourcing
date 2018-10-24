class RailsUser < ActiveRecord::Base
  self.table_name = :users

  has_many :events, class_name: "RailsUserEvent"
end

class RailsUserEvent < ActiveRecord::Base
  include EventSourcing::Event
  include EventSourcing::Rails::EventRecord

  self.table_name = :user_events
  self.abstract_class = true

  belongs_to :user, class_name: "RailsUser"
end

class RailsUserCreated < RailsUserEvent
  data_attributes :name

  def apply(test_user)
    test_user.name = name
    test_user
  end

  private

  def build_aggregate
    @rails_user ||= RailsUser.new
  end

  def dispatch
    :dispatch
  end
end

class RailsUserUpdated < RailsUserEvent
  data_attributes :name, :record_id

  def apply(test_user)
    test_user.name = name
    test_user
  end

  private

  def build_aggregate
    @rails_user ||= RailsUser.find(record_id)
  end

  def dispatch
    :dispatch
  end
end

class RailsUserCreateCommand
  include EventSourcing::Command
  include EventSourcing::Rails::CommandRecord

  attributes :name

  validates :name, length: { minimum: 20 }

  private

  def build_event
    RailsUserCreated.assign(name: name)
  end
end

class RailsUserUpdateCommand
  include EventSourcing::Command
  include EventSourcing::Rails::CommandRecord

  attributes :name, :record_id

  validates :name, length: { minimum: 20 }

  private

  def build_event
    RailsUserUpdated.assign(name: name, record_id: record_id)
  end
end
