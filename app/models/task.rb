#encoding: UTF-8
class Task < ActiveRecord::Base
  acts_as_paranoid
  has_many :user_tasks , :dependent =>  :destroy
  has_many :users, :through =>  :user_tasks
  has_many :group_tasks , :dependent =>  :destroy
  has_many :groups, :through =>  :group_tasks
  has_many :images
  has_many :documents
  CONFIRM = [
      ['未確認', false], ['確認済', true]
  ]
  validates_presence_of     :title, :description
  #条件検索
  #【引数】hash
  #【返値】array
  #【注意】
  #【著作】www 20130621
  def self.get_array(hash)
    conditions = [["1=1"]]
    if(!hash[:title].blank?)
      conditions[0] << "title like ?"
      conditions << "%"+hash[:title]+"%"
    end
    if(!hash[:user_id].blank?)
      conditions[0] << "user_id = ?"
      conditions << hash[:user_id]
    end
    conditions[0] = conditions[0].join(' and  ')
    return conditions
  end

  #ユーザー名が取得
  #【引数】
  #【返値】
  #【注意】
  #【著作】www 20130627
  def get_user_name(user_id)
    user =  User.find_by_id(user_id)
    return user.name
  end

  #任務の確認情況が取得
  #【引数】
  #【返値】
  #【注意】
  #【著作】www 20130628
  def confirm(comfirm_flag)
    if  comfirm_flag == true
      return "確認済"
    else
      return "未確認"
    end
  end

  #获取新建任务者的姓名
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130703
  def user_name
    if self.user_id.present?
      user = User.find_by_id(self.user_id)
      return user.name
    else
      return ''
    end
  end

end
