module EventSourcing
  class ReactorJob
    def perform_later
      raise NotImplementedError
    end
  end
end
