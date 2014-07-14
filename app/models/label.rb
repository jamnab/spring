class Label < ActiveRecord::Base
  has_many :label_entries, dependent: :destroy
end
