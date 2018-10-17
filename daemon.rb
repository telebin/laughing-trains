require_relative 'fix_integer'
require_relative 'pkp_query'
require_relative 'log'
require_relative 'entry_cache'
require_relative 'notification'
require_relative 'gir_notification_executor'

class Daemon
  def initialize
    @notifier = GirNotificationExecutor.new
    @mik_wro_cache = EntryCache.new PkpQuery.new.from(LOCATIONS[:mik]).to(LOCATIONS[:wro])
    @wro_zach_cache = EntryCache.new PkpQuery.new.from(LOCATIONS[:wro]).to(LOCATIONS[:zach])
  end

  def run
    while true
      # TODO add support for closer trains (i.e. 10 min from now - instant notification?)
      now = Time.now
      soonest_conn = @mik_wro_cache.get_conn_after(now + 30.minutes)
      change_conn = @wro_zach_cache.get_conn_after(soonest_conn.destination.time + 6.minutes)

      log "Now waiting #{soonest_conn.source.time - (now + 30.minutes)}s with notification..."
      sleep(soonest_conn.source.time - (now + 30.minutes))
      notification = Notification.new 'Interesting trainz', soonest_conn, change_conn
      log 'Executing notification'
      @notifier.execute notification
    end
  end
end
