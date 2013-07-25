#encoding: UTF-8
class UserMail < ActionMailer::Base
  def company_create_success (current_admin)
    @recipients = current_admin.email
    @from       =  "info@alpha-it-system.com"
    @subject    = "企業管理者が新規登録しました。"
    @sent_on    = Time.now
    @body[:str] = "成功しました！"
    @headers = {}
  end


end
