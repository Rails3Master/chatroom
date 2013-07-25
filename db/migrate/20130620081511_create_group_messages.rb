#encoding: utf-8
class CreateGroupMessages < ActiveRecord::Migration
  def self.up
    create_table :group_messages do |t|
      t.column :group_id ,                 :integer
      t.column :message_id ,               :integer
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :group_messages
  end
end
