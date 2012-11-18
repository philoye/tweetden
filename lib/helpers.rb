# This is a very ghetto, and limited, version of url_for
def url_for(path, options)
  uri = Addressable::URI.new(:path => path)
  uri.query_values = params.merge(options)
  return uri
end

def pagination_stats(total,page,per)
  start  = (page-1) * per + 1
  finish = [ per*page, total ].min
  return "#{start}-#{finish} of #{total} found"
end

def jquery_url
  '/js/jquery-1.4.2'
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

def tweet_status_url(tweet_id,screen_name = ENV['TWEETDEN_SCREEN_NAME'])
  "http://twitter.com/#{screen_name}/status/#{tweet_id}"
end

# http://huri.net/tech/renaming-hash-keys
class Hash
  def rename_key(old,new)
    self[new] = self.delete(old)
  end
end
