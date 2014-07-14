class Tag < ActiveRecord::Base
  has_many :tag_entries, dependent: :destroy
end
