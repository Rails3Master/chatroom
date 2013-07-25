#encoding: utf-8
class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :user_id ,                   :integer
      t.column :title ,                      :string
      t.column :description ,               :string
      t.column :limit_time ,                :date
      t.column :confirm_flag ,              :boolean, :default=>false
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
