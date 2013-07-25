#encoding: UTF-8
class PasswordResetMail < ActionMailer::Base
  def password_reset(user)
    @recipients =user.email		# 收件人邮箱
    @from       =  "info@dsk-omp-imagingedc.jp"	# 发件人邮箱
    @subject    = "パスワード再発行のお知らせ"	# 邮件主题
    @sent_on    = Time.now		# 发送时间
    @body[:uuid_random] = user.uuid_random		# 邮件内容
    @headers = {}
  end


end