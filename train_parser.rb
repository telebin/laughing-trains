require_relative 'entry_cache'
require_relative 'pkp_query'
require_relative 'log'
require_relative 'notification'
require_relative 'gir_notification_executor'

class Integer
  def minutes
    self * 60
  end

  def hours
    self * 60.minutes
  end
end

LOCATIONS = {
    mik: 5104134,
    wro: 5100069,
    zach: 5102597
}.freeze

if ARGV.count.zero?
  notifier = GirNotificationExecutor.new
  mik_wro_cache = EntryCache.new PkpQuery.new.from(LOCATIONS[:mik]).to(LOCATIONS[:wro])
  wro_zach_cache = EntryCache.new PkpQuery.new.from(LOCATIONS[:wro]).to(LOCATIONS[:zach])

  while true
    # TODO add support for closer trains (i.e. 10 min from now - instant notification?)
    now = Time.now
    soonest_conn = mik_wro_cache.get_conn_after(now + 30.minutes)
    change_conn = wro_zach_cache.get_conn_after(soonest_conn.destination.time + 10.minutes)

    log "Now waiting #{soonest_conn.source.time - (now + 30.minutes)}s with notification..."
    sleep(soonest_conn.source.time - (now + 30.minutes))
    notification = Notification.new 'Interesting trainz', soonest_conn, change_conn
    log 'Executing notification'
    notifier.execute notification
  end
else
  require 'time'
  SOURCE_STATION_ID = LOCATIONS[ARGV[0].to_s.to_sym] || LOCATIONS[:zach]
  DEST_STATION_ID = LOCATIONS[ARGV[1].to_s.to_sym] || LOCATIONS[:wro]
  TIME = Time.parse ARGV[2]

  puts EntryMapper.new(PkpQuery.new.from(SOURCE_STATION_ID).to(DEST_STATION_ID).at(TIME).get).map_rows.map(&:to_s)
end
