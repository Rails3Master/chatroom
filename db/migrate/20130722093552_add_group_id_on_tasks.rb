#encoding: utf-8
class AddGroupIdOnTasks < ActiveRecord::Migration
  def self.up
    add_column  :tasks, :group_id, :integer
  end

  def self.down
    remove_column   :tasks, :group_id
  end
end
