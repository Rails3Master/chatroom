#encoding: utf-8
class CreateGroupTasks < ActiveRecord::Migration
  def self.up
    create_table :group_tasks do |t|
      t.column :task_id ,                 :integer
      t.column :group_id ,                :integer
      t.column :issue_status ,            :string,   :default=> 0
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :group_tasks
  end
end
