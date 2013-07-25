#encoding: UTF-8
class UserMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :message
end
