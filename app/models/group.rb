class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :user_groups , :dependent =>  :destroy
  has_many :users, :through =>  :user_groups
  has_many :group_messages , :dependent =>  :destroy
  has_many :messages, :through =>  :group_messages
  belongs_to :company
  has_many :group_tasks , :dependent =>  :destroy
  has_many :tasks, :through =>  :group_tasks

  #假删除
  acts_as_paranoid

  validates_presence_of :name, :memo
  validates_length_of       :name, :within => 4..20,  :if => proc{|group| group.name.present?}
  validates_uniqueness_of :name, :case_sensitive => false

  # 获取company的名字
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def main_group
    user = User.find_by_id(self.user_id)
    if self.company.present?
      return self.company.name
    elsif user.present?
      return user.name
    else
      "Admin"
    end
  end

end
