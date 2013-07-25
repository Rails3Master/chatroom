#encoding: utf-8
class CreateUserMessages < ActiveRecord::Migration
  def self.up
    create_table :user_messages do |t|
      t.column :user_id ,                  :integer
      t.column :message_id ,               :integer
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :user_messages
  end
end
