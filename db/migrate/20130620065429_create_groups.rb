#encoding: utf-8
class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :company_id, :integer
      t.column :name,        :string
      t.column :memo,        :text
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
