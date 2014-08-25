# This is a very ghetto, and limited, version of url_for
def url_for(path, options)
  uri = Addressable::URI.new(:path => path)
  uri.query_values = params.merge(options)
  return uri
end

def pagination_stats(total, page, per)
  if total > 0
    start  = (page-1) * per + 1
    finish = [ per*page, total ].min
    return "#{start}-#{finish} of #{total} found"
  else
    return "No results"
  end
end

def pretty_date(date)
  format = "%e %B %Y"
  if date.is_a?(String)
    return Date.parse(date).strftime(format)
  else
    return date.strftime(format)
  end
end

def pretty_datetime(datetime)
  format = "%e %B %Y, %l:%m%p"
  if datetime.is_a?(String)
    return DateTime.parse(datetime).strftime(format)
  else
    return datetime.strftime(format)
  end
end

def tweet_status_url(tweet_id,screen_name = ENV['SCREEN_NAME'])
  "http://twitter.com/#{screen_name}/status/#{tweet_id}"
end

# http://huri.net/tech/renaming-hash-keys
class Hash
  def rename_key(old,new)
    self[new] = self.delete(old)
  end

  # Return a hash that includes everything but the given keys. This is useful for
  # limiting a set of parameters to everything but a few known toggles:
  #
  #   @person.update_attributes(params[:person].except(:admin))
  #
  # If the receiver responds to +convert_key+, the method is called on each of the
  # arguments. This allows +except+ to play nice with hashes with indifferent access
  # for instance:
  #
  #   {:a => 1}.with_indifferent_access.except(:a)  # => {}
  #   {:a => 1}.with_indifferent_access.except("a") # => {}
  #
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end

