module InvalidUuidHandling
  private

  def with_invalid_uuid_handling
    begin
      yield
    rescue => e
      raise unless e.message =~ /invalid input syntax for type uuid/
    end
  end
end
