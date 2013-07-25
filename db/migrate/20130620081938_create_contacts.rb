#encoding: utf-8
class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column :user_id ,                  :integer
      t.column :friend_id ,                :integer
      t.column :content ,                  :text
      t.column :confirm_flag ,             :boolean, :default=>false
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
