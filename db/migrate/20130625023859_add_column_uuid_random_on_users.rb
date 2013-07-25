#encoding: utf-8
class AddColumnUuidRandomOnUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :uuid_random, :string
  end

  def self.down
    remove_column :users, :uuid_random
  end
end
