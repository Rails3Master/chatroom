class Message < ActiveRecord::Base
  acts_as_paranoid
  has_many :user_messages , :dependent =>  :destroy
  has_many :users, :through => :user_messages
  has_many :group_messages , :dependent =>  :destroy
  has_many :groups, :through => :group_messages
  validates_presence_of     :content


  #获取receive type的类型
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130702
  def receiver_type_name
    if self.receiver_type != 0
      return 'Send to the user'
    else
      return 'Send to the group'
    end
  end

  #获取发送消息者的姓名
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130702
  def send_message_name
    if self.user_id.present?
      user = User.find_by_id(self.user_id)
      return user.name
    else
      return ''
    end
  end

  #条件検索
  #【引数】hash
  #【返値】array
  #【注意】
  #【著作】www 20130702
  def self.get_array(hash)
    conditions = [["1=1"]]
    if(!hash[:content].blank?)
      conditions[0] << "content like ?"
      conditions << "%#{hash[:content]}%"
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
end
