#encoding: utf-8
class AddColumnUserIdOnGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :user_id, :integer
  end

  def self.down
    remove_column :groups, :user_id
  end
end
