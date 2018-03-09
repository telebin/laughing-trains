class Notification
  attr_reader :header

  def initialize(header, connection, *connections)
    @header = header
    @connections = [connection] + connections
  end

  def generate_body
    @connections.join "\n"
  end
end
