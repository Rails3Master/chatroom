#encoding: utf-8
class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :type ,                 :string
      t.column :task_id ,              :integer
      t.column :deleted_at,            :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
