module OSM
  class Base < ActiveRecord::Base
    scope :buildings, -> { where("tags @> '{building}'").select {|o| o.tags.try(:[], 'building').present? } }
    scope :water, -> { where("tags @> '{water}'").select {|o| o.tags.try(:[], 'water').present? } }

    def tags
      read_attribute(:tags).try(:in_groups_of, 2).try(:to_h)
    end
  end
end
