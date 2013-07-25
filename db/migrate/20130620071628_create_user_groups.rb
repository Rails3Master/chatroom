#encoding: utf-8
class CreateUserGroups < ActiveRecord::Migration
  def self.up
    create_table :user_groups do |t|
      t.column :user_id ,              :integer
      t.column :group_id ,             :integer
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :user_groups
  end
end
