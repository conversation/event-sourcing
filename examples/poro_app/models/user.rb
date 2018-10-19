class PoroApp
  class User
    attr_accessor :active, :description, :name, :visible

    # @param [Hash] attributes
    def initialize(attributes = {})
      @active = attributes[:active]
      @description = attributes[:description]
      @name = attributes[:name]
      @visible = attributes[:visible]
    end
  end
end
