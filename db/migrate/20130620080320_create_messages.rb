#encoding: utf-8
class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :user_id ,                 :integer
      t.column :receiver_type ,           :string
      t.column :content ,                 :text
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
