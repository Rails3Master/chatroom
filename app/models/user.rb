#encoding: utf-8
class User < ActiveRecord::Base
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # attr_accessible :title, :body
  attr_accessible :email, :password, :password_confirmation, :remember_me

  validate :email, :uniquencess => true


  # 用户检索sql语句的拼接
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130624
  def self.get_array(hash)
    conn = [['1 = 1']]

    #search the user_id
    if hash[:user][:id].present?
      conn[0] << ' users.id = ? '
      conn << hash[:user][:id]
    end

    #search the user_name
    if hash[:user][:name].to_s.strip.present?
      conn[0] << '(users.name like ?)'
      conn << "%"+hash[:user][:name]+"%"
    end

    # search the user_tel
    if hash[:user][:tel].to_s.strip.present?
      conn[0] << '(users.tel like ?)'
      conn << "%"+hash[:user][:tel]+"%"
    end

    #search the user_email
    if hash[:user][:email].to_s.strip.present?
      conn[0] << '(users.email like ?)'
      conn << "%"+hash[:user][:email]+"%"
    end

    #search the task_title
    if hash[:task][:title].to_s.strip.present?
      conn[0] << '(tasks.title like ?)'
      conn << "%" + hash[:task][:title]+"%"
    end

    #search the group_name
    if hash[:group][:name].to_s.strip.present?
      conn[0] << '(groups.name like ?)'
      conn << "%" + hash[:group][:name]+"%"
    end

    conn[0] = conn[0].join(" and ")
    return conn
  end

  # 用户csv导出
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def self.export(users)
    #获取表的字段
    output = FasterCSV.generate do |csv|
      csv << ["id", "name", "login", "email", "tel", "skype_id", "zip_code", "address1", "address2"]
      users.each do |user|
        csv << [user.id, user.name, user.login, user.email, user.tel, user.skype_id, user.zip_code, user.pref, user.address2]
      end
    end
    output = NKF.nkf("-s", output)
  end

  #取到用户的pref
  def pref
    Admin::PREFS[self.address1.to_i-1][0]
  end

  # 用户csv导入
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def self.import(file)
    #创建文件夹
    file_path = "#{RAILS_ROOT}/tmp/csv/"
    #临时文件命名，不能有非法字符，比如"()"因为在linux下文件名不支持"()"等特殊符号
    FileUtils.mkdir(file_path) if !File.exist?(file_path)
    file_name = "temp.csv"
    begin
      data_utf = file.read
      #他读取的file中的数据写入file_path 路径下的file_name文件中
      File.open(file_path + file_name, 'wb') do |f|
        f.write(data_utf)
        f.close
      end
    ensure
      file.close
    end
    #随机产生不同的数
    key_id = UUID.random_create().to_s
    system("nkf -Lu -S -w80 #{file_path + file_name} > #{file_path + key_id + file_name}")
    messages = []
    f_path = file_path + key_id + file_name
    index = -1
    User.transaction do
      FasterCSV.foreach(f_path) do |row|
        flag = true
        index += 1
        next if index == 0
        GC.start if index % 50 == 0
        row.each do |r|
          r = r.to_s.toutf8 unless r.blank?
        end
        user = User.new
        user.name=row[0]
        user.login = row[1]
        user.email = row[2]
        user.tel = row[3]
        user.skype_id = row[4]
        user.password = row[5]
        user.password_confirmation= row[6]
        user.uuid_random = UUID.random_create.to_s

        if user.valid?
          user.save!
        else
          messages << "第#{index}行:#{user.errors.full_messages}<p>"
        end
      end
      if !messages.blank?
        raise ActiveRecord::Rollback
      end
    end
    FileUtils.rm_rf(file_path) if File.exists?(file_path)
    return messages
  end

  # 获取company的名字
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def company_name
    self.company.present? ? self.company.name : "Admin"
  end

end
