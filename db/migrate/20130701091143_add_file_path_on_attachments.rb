#encoding: utf-8
class AddFilePathOnAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :file_path, :string
  end

  def self.down
    remove_column :attachments, :file_path
  end
end
