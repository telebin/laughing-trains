require_relative 'entry_mapper'
require_relative 'pkp_query'
require_relative 'log'

class Integer
  def minutes
    self * 60
  end
end

LOCATIONS = {
    mik: 5104134,
    wro: 5100069,
    zach: 5102597
}.freeze

if ARGV.count.zero?
  mik_wro_query = PkpQuery.new.from(LOCATIONS[:mik]).to(LOCATIONS[:wro]).at(Time.now + 30.minutes)
  log 'Getting mik->wro'
  mik_wro_trains = EntryMapper.new(mik_wro_query.get).map_rows

  next_train_time = mik_wro_trains.first.destination.time + 10.minutes
  wro_zach_query = PkpQuery.new.from(LOCATIONS[:wro]).to(LOCATIONS[:zach]).at(next_train_time)
  log 'Getting wro->zach'
  wro_zach_trains = EntryMapper.new(wro_zach_query.get).map_rows

  puts mik_wro_trains.map(&:to_s)
  puts 'and then'
  puts wro_zach_trains.map(&:to_s)
else
  require 'time'
  SOURCE_STATION_ID = LOCATIONS[ARGV[0].to_s.to_sym] || LOCATIONS[:zach]
  DEST_STATION_ID = LOCATIONS[ARGV[1].to_s.to_sym] || LOCATIONS[:wro]
  TIME = Time.parse ARGV[2]

  puts EntryMapper.new(PkpQuery.new.from(SOURCE_STATION_ID).to(DEST_STATION_ID).at(TIME).get).map_rows.map(&:to_s)
end
