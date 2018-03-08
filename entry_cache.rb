require_relative 'entry_mapper'

class EntryCache
  def initialize(query)
    @query = query
    @entries = []
  end

  def get_conn_after(time)
    closest_entry = find_entry_closest_to(time)
    return closest_entry if closest_entry
    fill_cache(time)
    find_entry_closest_to(time)
  end

  def fill_cache(time)
    @entries += EntryMapper.new(@query.at(time).get).map_rows
  end

  private
  def find_entry_closest_to(time)
    @entries.select {|e| e.source.time > time}.min_by {|e| e.source.time}
  end
end
