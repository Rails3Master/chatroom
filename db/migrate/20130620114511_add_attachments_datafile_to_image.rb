#encoding: utf-8
class AddAttachmentsDatafileToImage < ActiveRecord::Migration
  def self.up
    add_column :attachments, :datafile_file_name, :string
    add_column :attachments, :datafile_content_type, :string
    add_column :attachments, :datafile_file_size, :integer
    add_column :attachments, :datafile_updated_at, :datetime
  end

  def self.down
    remove_column :attachments, :datafile_file_name
    remove_column :attachments, :datafile_content_type
    remove_column :attachments, :datafile_file_size
    remove_column :attachments, :datafile_updated_at
  end
end
