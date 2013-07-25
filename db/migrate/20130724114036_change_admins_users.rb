#encoding: utf-8
class ChangeAdminsUsers < ActiveRecord::Migration
  def up
    #for admins
    add_column  :admins, :type, :string, :limit => 20
    add_column  :admins, :name, :string, :limit => 100
    add_column  :admins, :tel, :string, :limit => 20
    add_column  :admins, :zip_code, :string, :limit => 20
    add_column  :admins, :address1, :string, :limit => 100
    add_column  :admins, :address2, :string, :limit => 100
    add_column  :admins, :photo_path, :string, :limit => 100
    add_column  :admins, :deleted_at, :datetime

    #for users
    add_column  :users, :company_id, :integer, :limit => 10
    add_column  :users, :name, :string, :limit => 50
    add_column  :users, :tel, :string, :limit => 20
    add_column  :users, :skype_id, :string, :limit => 20
    add_column  :users, :zip_code, :string, :limit => 20
    add_column  :users, :address1, :string, :limit => 100
    add_column  :users, :address2, :string, :limit => 100
    add_column  :users, :photo_path, :string, :limit => 100
    add_column  :users, :deleted_at, :datetime
  end

  def down
  end
end
