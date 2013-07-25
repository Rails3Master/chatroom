class GroupMessage < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_paranoid
  belongs_to :group
  belongs_to :message
end
