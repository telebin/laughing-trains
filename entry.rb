class Entry
  class Record
    attr_reader :time, :station

    def initialize(station, time)
      @station = station
      @time = time
    end
  end

  attr_reader :to, :from, :time

  def initialize(start, depart, stop, arriv, time)
    @from = Record.new start, depart
    @to = Record.new stop, arriv
    @time = time
  end
end
