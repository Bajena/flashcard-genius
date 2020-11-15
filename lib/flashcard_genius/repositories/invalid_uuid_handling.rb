module InvalidUuidHandling
  private

  def with_invalid_uuid_handling
    begin
      yield
    rescue => e
      raise unless e.message =~ /invalid input syntax .* uuid/
    end
  end
end
