module Slugifiable
  module ClassMethods
    def find_by_slug(slug)
      self.all.detect {|obj| obj.slug == slug}
    end
  end

  module InstanceMethods
    def slug()
      self.username.strip.downcase.gsub(/\W+/, '-')
    end
  end
end