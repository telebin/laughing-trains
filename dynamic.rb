require_relative 'entry_mapper.rb'
require_relative 'query.rb'

def log(msg)
  STDERR.puts msg.to_s
end

LOCATIONS = {
    mik: 5104134,
    wro: 5100069,
    zach: 5102597
}.freeze

query = PkpQuery.new.from(LOCATIONS[:mik]).to(LOCATIONS[:wro]).at(Time.new + 60 * 30)

timetable = EntryMapper.new(query.get).map_rows.map(&:to_s)
puts timetable
