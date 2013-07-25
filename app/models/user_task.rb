#encoding: utf-8
class UserTask < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :task
end
