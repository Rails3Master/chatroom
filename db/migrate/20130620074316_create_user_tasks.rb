#encoding: utf-8
class CreateUserTasks < ActiveRecord::Migration
  def self.up
    create_table :user_tasks do |t|
      t.column :task_id ,              :integer
      t.column :user_id ,              :integer
      t.column :issue_status ,         :string, :default=> 0
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :user_tasks
  end
end
