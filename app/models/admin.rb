#encoding: utf-8
class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # attr_accessible :title, :body
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :tel, :zip_code, :address1, :address2

  acts_as_paranoid
  PREFS = [
      ['北海道', "1"], ['青森県', "2"], ['岩手県', "3"], ['宮城県', "4"],
      ['秋田県', "5"], ['山形県', "6"], ['福島県', "7"], ['茨城県', "8"], ['栃木県', "9"],
      ['群馬県', "10"], ['埼玉県', "11"], ['千葉県', "12"], ['東京都', "13"], ['神奈川県', "14"],
      ['新潟県', "15"], ['富山県', "16"], ['石川県', "17"], ['福井県', "18"], ['山梨県', "19"],
      ['長野県', "20"], ['岐阜県', "21"], ['静岡県', "22"], ['愛知県', "23"], ['三重県', "24"],
      ['滋賀県', "25"], ['京都府', "26"], ['大阪府', "27"], ['兵庫県', "28"], ['奈良県', "29"],
      ['和歌山県', "30"], ['鳥取県', "31"], ['島根県', "32"], ['岡山県', "33"], ['広島県', "34"],
      ['山口県', "35"], ['徳島県', "36"], ['香川県', "37"], ['愛媛県', "38"], ['高知県', "39"],
      ['福岡県', "40"], ['佐賀県', "41"], ['長崎県', "42"], ['熊本県', "43"], ['大分県', "44"],
      ['宮崎県', "45"], ['鹿児島県', "46"], ['沖縄県', "47"]
  ]

  validate :email, :uniquencess => true

  # 设定默认的管理者
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130716
  def self.add_default_admin
    admin = Admin.find_by_email("admin@cr.com")
    admin = Admin.new(:email => "admin@cr.com") if admin.blank?
    admin.email = "admin@cr.com"
    admin.password = "12345678"
    admin.password_confirmation = "12345678"
    admin.save!
  end

end
