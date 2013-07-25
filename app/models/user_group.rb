#encoding: UTF-8
class UserGroup < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :group
end