require_relative 'entry_mapper'
require_relative 'log'

class EntryCache
  def initialize(query)
    @query = query
    @entries = []
  end

  def get_conn_after(time)
    closest_entry = find_entry_closest_to(time)
    if closest_entry
      log "Taking closest entry from cache: #{closest_entry}"
      return closest_entry
    end
    fill_cache(time)
    find_entry_closest_to(time)
  end

  private
  def fill_cache(time)
    log 'Filling cache with query for time ' + time.to_s
    @entries += EntryMapper.new(@query.at(time).get).map_rows
  end

  def find_entry_closest_to(time)
    log 'Searching for closest entry in cache'
    @entries.select {|e| e.source.time > time}.min_by {|e| e.source.time}
  end
end
