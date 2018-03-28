class Notification
  def initialize(header, connection, *connections)
    @header = header
    @connections = [connection] + connections.to_a
  end

  def header
    @connections.first.source.name + '->' + @connections.last.destination.name
  end

  def generate_body
    first = @connections.first
    "<b>#{first.source.time.strftime '%H:%M'}</b> -(#{first.travel_time})> #{first.destination.name}, and then:\n" +
        @connections[1..-1].map {|c| [c.source.time, c.travel_time, c.destination.name, c.destination.time]}.
            map {|a, b, c, d| "<b>#{a.strftime '%H:%M'}</b> -(#{b})> #{c} (#{d.strftime '%H:%M'})\n"}.join
  end
end
