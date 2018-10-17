require_relative 'fix_integer'
require_relative 'entry_mapper'
require_relative 'pkp_query'
require_relative 'log'
require_relative 'daemon'

LOCATIONS = {
    mik: 5104134,
    wro: 5100069,
    zach: 5102597
}.freeze

if ARGV.count.zero?
  Daemon.new.run
else
  require 'time'
  SOURCE_STATION_ID = LOCATIONS[ARGV[0].to_s.to_sym] || LOCATIONS[:zach]
  DEST_STATION_ID = LOCATIONS[ARGV[1].to_s.to_sym] || LOCATIONS[:wro]
  TIME = Time.parse ARGV[2]

  puts EntryMapper.new(PkpQuery.new.from(SOURCE_STATION_ID).to(DEST_STATION_ID).at(TIME).get).map_rows.map(&:to_s)
end
