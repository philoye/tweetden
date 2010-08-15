# Lifted from Padrino, then tweaked according to the Plugin pattern on RailsTips
# http://github.com/padrino/padrino-contrib/blob/master/lib/padrino-contrib/orm/mm/search.rb
# http://railstips.org/blog/archives/2010/02/21/mongomapper-07-plugins/

module SearchPlugin
  # This module provides full text search in specified fileds with pagination support.
  #
  #   # model.rb
  #   has_search  :title, :body
  #
  #   # controller.rb
  #   Model.search("some thing")
  #   Model.search("some thing", :order => "position", :page => (params[:page] || 1), :draft => false, :paginate => true)
  #

  def self.included(model)
    model.plugin SearchPlugin
  end

  module ClassMethods
    def has_search(*fields)
      class_inheritable_accessor  :search_fields
      write_inheritable_attribute :search_fields, fields
    end

    def search(text, options={})
      if text
        re = Regexp.new(Regexp.escape(text), 'i').to_json
        where = search_fields.map { |field| "this.#{field}.match(#{re})" }.join(" || ")
        options.merge!("$where" => where)
      end
      options.delete(:paginate) ? paginate(options) : all(options)
    end
  end
end

MongoMapper::Document.append_inclusions(SearchPlugin)