module Slugify

  module InstanceMethods
    def slug
      slug = self.username
      .downcase.split(" ").join("-")
    end
  end

  module ClassMethods
    def find_by_slug(slug)
      self.all.detect {|username| username.slug == slug}
    end
  end

end
