# 0.4.2.pre

- Fixed `EventSourcing::ActiveRecord::Event#reify` method declaration (@tiagoamaro)

# 0.4.1.pre

- Added the `EventSourcing::ActiveRecord::Event#reify` method (@RohanM)

# 0.3.1.pre

- Renamed the `EventSourcing::Rails` module to `EventSourcing::ActiveRecord` (@nullobject)
    - Renamed the `EventSourcing::Rails::CommandRecord` to `EventSourcing::ActiveRecord::Command`
    - Renamed the `EventSourcing::Rails::EventRecord` to `EventSourcing::ActiveRecord::Event`
