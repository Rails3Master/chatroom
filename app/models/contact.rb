class Contact < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_paranoid
  belongs_to :user

  def user_name
    self.user.present? ? self.user.name : ""
  end

end
