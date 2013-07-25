#encoding: UTF-8
class AdminUsersController < AdminsController

  # 用户list
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130621
  def list
    @users = User.paginate(:all,
                           :page => params[:page],
                           :per_page => APP_CONFIG[:per_page_3],
                           :order => "updated_at desc"
    )
  end

  # 用户新规
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130621
  def sign_request
    @user = User.new(params[:user])
    return unless request.post?
    @user.company_id = session[:admin]
    @user.uuid_random = UUID.random_create.to_s
    @user.save!
    redirect_back_or_default(:controller => '/admin/user', :action => 'list')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'sign_request'
  end

  # 用户编辑
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130621
  def edit
    @user = User.find_by_id(params[:id])
    @image = Image.new
    if @user.blank?
      flash[:notice] = 'ご指定の内容が見つかりませんでした。ご入力されたキーワードを確認してください。'
      redirect_to :action => 'list'
    end
    return unless request.post?
    #写入图片
    if(params[:image].present?)
      file_name = params[:id] + File.extname(params[:image][:datafile].original_filename)
      file_path = "#{RAILS_ROOT}/public/images/photos/#{file_name}"
      File.open(file_path, "wb") do |f|
        f.write(params[:image][:datafile].read)
      end
      #压缩图片
      img = Magick::Image.read(file_path).first
      size = set_size(img, APP_CONFIG[:preview_size])
      resize_img = img.resize(size[0], size[1])
      resize_img.write(file_path)
    end

    #更新user
    user = User.find_by_id(params[:id])
    user.company_id = session[:admin]
    user.attributes = params[:user]
    if file_name.present?
      user.photo_path = "/images/photos/#{file_name}"
    end
    user.save!
    flash[:notice]="edit success"
    redirect_to :action => :list
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  # 上传头像预览
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130621
  def logo_preview
    @image_name = Image.image_preview(params[:image][:datafile])
    responds_to_parent do
      render :update do |page|
        text = render :partial => 'logo_preview'
        page.replace_html 'logo_preview', text
      end
    end
  end

  # 根据条件检索
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130624
  def search
    @users =User.paginate(:all,
                          :conditions => User.get_array(params),
                          :page => params[:page],
                          :per_page => APP_CONFIG[:per_page_3],
                          :include => [:tasks,:groups],
                          :order => "updated_at desc")
    render :action => 'list'
  end

  # 用户密码修改
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def password_reset
    @user = User.find_by_uuid_random(params[:uuid_random])
    return unless request.post?
    @user.attributes = params[:user]
    @user.save!
    flash[:notice]="password reset success!"
    redirect_back_or_default(:controller => '/user', :action => 'login')

  rescue ActiveRecord::RecordInvalid
    render :action => 'password_reset'


  end

  # 用户密码变更发送邮件
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def password_reset_send_mail
    @user = User.find_by_uuid_random(params[:uuid_random])
    return unless request.post?
    if params[:user][:email].present?
      @user.email = params[:user][:email]
    end
    if PasswordResetMail.deliver_password_reset(@user)
      redirect_to :action => 'password_confirm' ,:email => @user.email
    end
  end

  # 用户CSV导出
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130625
  def user_export_csv
    #取到所要导出的users
    users = User.find(:all,
                      :conditions => User.get_array(params),
                      :include => [:tasks,:groups]
    )
    #导出文件
    content  =  User.export(users)
    send_data content,
              #  导出的文件类型
              :type=>'text/csv',
              #  导出的文件名
              :filename => "user_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
  end

  # 用户CSV导入
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130626
  def user_import_csv
    return unless request.post?
    if params[:user].present?
      file = params[:user][:csv]
      if file.blank?
        flash[:notice] = "no file"
        redirect_to :action => "user_import_csv"
      else
        file_name = file.original_filename
        if file_name =~ /.*(.csv)$/
          messages = User.import(file)
          if  messages.blank?
            flash[:notice] = "successful!!"
            redirect_to :action => "list"
          else
            flash[:notice] = messages
            redirect_to :action => "user_import_csv"
          end
        else
          flash[:notice] = "wrong file"
          redirect_to :action => "user_import_csv"
        end
      end
    else
      flash[:notice] = "no file"
      redirect_to :action => "user_import_csv"
    end
  end

  # 用户CSV导入sample
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130626
  def user_sample_csv
    file_path = "#{RAILS_ROOT}/public/csv/user_sample.csv"
    send_file(file_path)
  end

  # 用户消除
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130626
  def deleted
    user = User.find_by_id(params[:id])
    if user.destroy
      flash[:notice] = "Successfully deleted"
      redirect_back_or_default(:controller => 'admin/user', :action => 'list')
    end
  end

  # 群组一覧
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130626
  def group_list
    @groups = Group.paginate(:all,
                             :page => params[:page],
                             :per_page => APP_CONFIG[:per_page_3],
                             :order => "updated_at desc" )
  end

  # 群组新规
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130627
  def group_new
    @group = Group.new(params[:group])
    @user_ids = Array.new
    @users = User.all
    return unless request.post?
    @group.company_id=session[:admin]
    if params[:user_ids].present?
      params[:user_ids].each do |id|
        user = User.find_by_id(id)
        @group.users << user
      end
    end

    @group.save!
    flash[:notice] = "Group new successful!"
    redirect_back_or_default(:controller => "admin/user",:action => 'group_list')
  rescue ActiveRecord::RecordInvalid
    render :action => 'group_new'
  end

  # 群组編集
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130627
  def group_edit
    @group = Group.find_by_id(params[:id])
    @user_groups = UserGroup.find_all_by_group_id(params[:id])
    @user_ids = Array.new
    if @user_groups.present?
      @user_groups.each do |user_group|
        @user_ids << user_group.user_id
      end
    end
    @users = User.all
    return unless request.post?
    @group.attributes = params[:group]
    @group.company_id=session[:admin]
    if @user_groups.present?
      @user_groups.each do |user_group|
        user_group.destroy
      end
    end
    if params[:user_ids].present?
      params[:user_ids].each do |id|
        user = User.find_by_id(id)
        @group.users << user
      end
    end
    @group.save!
    flash[:notice] = "Group edit successful!"
    redirect_back_or_default(:controller => "admin/user",:action => 'group_list')
  rescue ActiveRecord::RecordInvalid
    render :action => 'group_edit'
  end

  # 群组根据条件检索
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130627
  def group_search
    @groups = Group.paginate(:all,
                             :page => params[:page],
                             :per_page => APP_CONFIG[:per_page_3],
                             :conditions => ['name like ?',"%"+params[:group][:name]+"%"],
                             :order => 'id desc'
    )
    render :action => 'group_list'
  end

  # 批量删除群组中的用户
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130628
  def group_user_delete
    @group = Group.find_by_id(params[:id])
    @user_ids = Array.new
    @users = Array.new
    #根据中间表找到该群的用户
    @user_groups = UserGroup.find_all_by_group_id(params[:id])
    if @user_groups.present?
      @user_groups.each do |user_group|
        @users << user_group.user
      end
    end
    return unless request.post?
    Group.transaction do
      user_ids = params[:user_ids]
      if user_ids.present?
        user_ids.each do |user_id|
          #根据group_id和user_id从中间表user_groups中找到记录
          user_group = UserGroup.find_by_group_id_and_user_id(@group.id,user_id)
          if user_group.present?
            #删除不成功就rollback
            if !user_group.destroy
              raise ActiveRecord::Rollback
            end
          end
        end
        flash[:notice] = "Successfully deleted!!!"
      else
        flash[:notice] = "The group has no user!!!"
      end
    end
    redirect_to :action => :group_list
  end

  # 一个一个的删除群组中的用户
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130628
  def delete_user_group
    user_group = UserGroup.find_by_group_id_and_user_id(params[:group_id],params[:user_id])
    if user_group.present?
      if user_group.destroy
        flash[:notice] = "Successfully deleted!!!"
      else
        flash[:notice] = "Delete failed"
      end
    else
      flash[:notice] = "The group has no user!!!"
    end
    redirect_back_or_default(:controller => "admin/user", :action => :group_user_delete,:id=>params[:group_id])
  end

  # 删除群组
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130628
  def group_deleted
    group = Group.find_by_id(params[:id])
    if group.present?
      if group.destroy
        flash[:notice] = "Successfully deleted!!!"
      else
        flash[:notice] = "Delete failed"
      end
    end
    redirect_back_or_default(:controller => "admin/user", :action => :group_list)
  end


  # 用户详细
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def detail
    @user = User.find_by_id(params[:id])
    if @user.blank?
      flash[:notice] = "The user does not exist"
      redirect_to :action => 'list'
    else
      contacts = Contact.find_all_by_user_id_and_confirm_flag(params[:id],true)
      @users = Array.new
      if contacts.present?
        contacts.each do |contact|
          @users << User.find_by_id(contact.friend_id)
        end
      end
      @groups = Group.find(:all,
                           :conditions => ["user_groups.user_id = ? and user_groups.deleted = ?",@user.id,false],
                           :include => :user_groups)
      confirmation_contacts = Contact.find_all_by_friend_id_and_confirm_flag(params[:id],false)
      @number = confirmation_contacts.size
      if params[:tab].blank?
        return
      end
    end

    if request.xml_http_request?
      case params[:tab]

        # 联系人管理
        when 'contact'
          get_contact

        #添加联系人
        when  'add_contact'
          contact_ids = Array.new
          contact_ids << params[:id].to_i
          contacts = Contact.find_all_by_user_id(params[:id])
          contacts.each do |contact|
            contact_ids << contact.friend_id
          end
          users = User.find(:all,
                            :conditions => ["id not in (?)",contact_ids])
          @users = users.paginate(:page => params[:page],
                                  :per_page => APP_CONFIG[:per_page_3])
          @user_ids = Array.new
          render :partial => 'add_contact'

        #确认添加联系人
        when  'contact_confirmation_user'
          @contacts = Contact.find_all_by_friend_id_and_confirm_flag(params[:id],false)
          render :partial => 'contact_confirmation_user'

        #用户消息管理 || 用户发出的消息
        when 'user_message', 'user_send_message'
          get_user_message

        #删除用户发出的消息
        when 'user_send_message_deleted'
          user_send_message_deleted

        #用户接收的消息
        when 'user_receive_message'
          user_receive_message

        #用户任务管理新建任务一览
        when "user_task" , "user_new_task"
          @tasks = Task.find_all_by_user_id(params[:id])
          user_tasks = Task.find(:all,
                                 :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                                 :include => ["user_tasks","group_tasks"])
          group_tasks = Task.find(:all,
                                  :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                                  :include => ["user_tasks","group_tasks"])
          @number = user_tasks.size + group_tasks.size
          render :partial => "user_new_task"

        #用户新建任务
        when "user_create_new_task"
          @file_id = 1
          @task = Task.new
          @task.user_id = @user.id
          if request.xml_http_request?
            @user = User.find_by_id(params[:id])
            render :partial => 'user_create_new_task'
          end

        #用户接受的任务
        when "user_receive_task"
          user_receive_task

        #用户完成的任务
        when "user_finish_task"
          user_finish_task

        #用户未完成的任务
        when "user_unfinished_task"
          user_unfinished_task

        #用户任务进度
        when "user_task_issue_status"
          user_task_issue_status

        #用户对完成的任务确认
        when "user_task_confirm"
          user_tasks = Task.find(:all,
                                 :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                                 :include => ["user_tasks","group_tasks"])
          group_tasks = Task.find(:all,
                                  :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                                  :include => ["user_tasks","group_tasks"])
          @tasks = Array.new
          @tasks << user_tasks
          @tasks << group_tasks
          @tasks.flatten!
          @number = user_tasks.size + group_tasks.size
          render :partial => 'user_task_confirm'

        #发放任务者确认已完成的任务
        when "user_confirm_task"
          user_confirm_task

        #任务创建者删除任务
        when "user_task_delete"
          user_task_delete

        #群组管理
        when "user_group"
          @groups = Group.find(:all,
                               :conditions => ["user_groups.user_id = ? and user_groups.deleted = ? or groups.user_id = ?",@user.id,false,@user.id],
                               :include => ["user_groups"])

          render :partial => "user_create_new_group"

        #用户加入的群
        when "user_join_group"
          @groups = Group.find(:all,
                               :conditions => ["user_groups.user_id = ? and user_groups.deleted = ?",@user.id,false],
                               :include => ["user_groups"])
          render :partial => "user_create_new_group"

        #用户新建的群
        when "user_create_group"
          @groups = Group.find(:all,
                               :conditions => ["user_groups.deleted = ? and groups.user_id = ?",false,@user.id],
                               :include => ["user_groups"])
          render :partial => "user_create_new_group"

        #用户退出该群组
        when "user_group_deleted"
          user_group_deleted

        #用户给群组新建任务
        when "user_group_create_new_task"
          @task = Task.new
          @task.user_id = @user.id
          if request.xml_http_request?
            @user = User.find_by_id(params[:id])
            render :partial => 'user_group_create_new_task'
          end

        #用户新建群组
        when "user_new_group"
          @user = User.find_by_id(params[:id])
          @user_ids = Array.new
          @users = User.find(:all,:conditions => ["users.id not in (?)",params[:id]])
          render :partial => 'user_new_group'
      end
    end
  end

  # 取到用户的联系人
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def get_contact
    contacts = Contact.find_all_by_user_id_and_confirm_flag(params[:id],true)
    @users = Array.new
    if contacts.present?
      contacts.each do |contact|
        @users << User.find_by_id(contact.friend_id)
      end
    end
    confirmation_contacts = Contact.find_all_by_friend_id_and_confirm_flag(params[:id],false)
    @number = confirmation_contacts.size
    render :partial => "contact"
  end

  # 用户添加联系人
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def add_contact
    @contact = Contact.new
    if request.xml_http_request?
      @user = User.find_by_id(params[:user_id])
      render :partial => 'add_contact'
    end
    return unless request.post?
    user_ids = params[:contact][:user_ids]
    if user_ids.present?
      user_ids.each do |user_id|
        @contact = Contact.new
        @contact.attributes = {:content=>params[:contact][:content],
                               :user_id => params[:user][:id],
                               :friend_id => user_id}
        if @contact.save
          flash[:notice] = "add Success"
        else
          flash[:notice] = "add Failure"
        end
      end
    end
    redirect_to :action => 'detail',:id => params[:user][:id]

  end

  # 联系人确认添加用户
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def contact_confirmation_user
    contact = Contact.find_by_id(params[:id])
    contact.confirm_flag = true
    if contact.save
      #成功后联系人也要添加用户
      contact_users = Contact.find(:all,:conditions => ["user_id=? and friend_id=? and confirm_flag=?",
                                                        contact.friend_id,contact.user_id,false])
      #如果已经存在就直接更新
      if contact_users.present?
        size = contact_users.size
        if size == 1
          contact_user =contact_users[0]
          contact_user.confirm_flag = true
        end
      else
        contact_user = Contact.new
        contact_user.attributes = {:friend_id => contact.user_id,
                                   :user_id => contact.friend_id,
                                   :confirm_flag => true}
      end

      if contact_user.save
        flash[:notice]="Confirmation Successfully"
      else
        flash[:notice]="Confirmation Failure"
      end
    end
    redirect_to :action => 'detail',:id => contact.friend_id
  end

  # 用户删除联系人
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def contact_delete
    contact_user = Contact.find_by_user_id_and_friend_id(params[:user_id],params[:friend_id])
    friend_id = contact_user.friend_id
    user_contact = Contact.find_by_user_id_and_friend_id(friend_id,contact_user.user_id)
    Contact.transaction do
      #用户删除联系人的同时联系人也要删除用户
      if contact_user.destroy
        if !user_contact.destroy
          flash[:notice]="delete Failure"
          raise ActiveRecord::Rollback
        end
        flash[:notice]="delete Success"
      else
        flash[:notice]="delete Failure"
        raise ActiveRecord::Rollback
      end
    end
    redirect_to :action => 'detail',:id => friend_id
  end

  # 用户发送消息给联系人
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130701
  def send_user_message
    @message = Message.new
    @message.user_id = params[:user_id]
    @user = User.find_by_id(params[:friend_id])
    return unless request.post?
    @message.attributes = params[:message]
    @message.receiver_type = 0
    @message.users << @user
    if @message.save
      flash[:notice]="send success"
    else
      flash[:notice]="send Failure"
    end
  end

  # 用户消息管理
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130702
  def  get_user_message
    @messages = Message.find_all_by_user_id(params[:id])
    render :partial => 'user_send_message'
  end

  # 删除用户发出的消息
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130702
  def user_send_message_deleted
    message = Message.find_by_id(params[:message_id])
    if message.destroy
      flash[:notice]="delete success"
    else
      flash[:notice]="delete failure"
    end
    @messages = Message.find_all_by_user_id(params[:id])
    render :partial => 'user_send_message'
  end

  # 用户接收的消息
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130702
  def user_receive_message
    @messages = Message.find(:all,
                             :conditions => ["users.id = ?",params[:id]],
                             :include => :users)
    render :partial => 'user_receive_message'
  end

  # 用户给联系人的新建和分配任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130703
  def user_create_new_task
    task = Task.new(params[:task])
    if params[:documents].present?
      params[:documents].each_value do |document|
        task.documents << Document.new(document)
      end
    end
    if task.save
      flash[:notice]="Task creation success"
    else
      flash[:notice]="Task creation failed"
    end
    redirect_to :action => "detail", :id => task.user_id
  end

  # 用户接受的任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130703
  def user_receive_task
    @tasks = Task.find(:all,
                       :conditions => ["users.id = ?",params[:id]],
                       :include => "users")
    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @number = user_tasks.size + group_tasks.size
    render :partial => 'user_receive_task'
  end

  # 用户完成的任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130703
  def user_finish_task
    @tasks = Task.find(:all,
                       :conditions => ["users.id = ? and user_tasks.issue_status = ?",params[:id],2],
                       :include => ["users","user_tasks"])
    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @number = user_tasks.size + group_tasks.size
    render :partial => 'user_finish_task'
  end

  # 用户未完成的任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130703
  def user_unfinished_task
    @tasks = Task.find(:all,
                       :conditions => ["users.id = ? and user_tasks.issue_status = ?",params[:id],"1"],
                       :include => ["users","user_tasks"])

    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @number = user_tasks.size + group_tasks.size
    render :partial => 'user_unfinished_task'
  end

  # 用户任务进度跟进和删除已完成的任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130704
  def user_task_issue_status
    user_task = UserTask.find_by_user_id_and_task_id(params[:id],params[:task_id])
    task = Task.find_by_id(params[:task_id])
    #开启任务
    if user_task.issue_status == "0"
      user_task.issue_status = "1"
      user_task.save
      flash[:notice] = "Open the #{task.title} task success"
      #结束任务
    elsif user_task.issue_status == "1"
      user_task.issue_status = "2"
      user_task.save
      flash[:notice] = "End the  #{task.title} task success"
      #删除任务发起人确认后的任务
    elsif user_task.issue_status == "2"
      if task.confirm_flag == true
        user_task.destroy
        flash[:notice] = "Delete the  #{task.title} task success"
      else
        flash[:notice] = "Cannot delete the  #{task.title} task did not confirm"
      end
    end

    @tasks = Task.find(:all,
                       :conditions => ["users.id = ?",params[:id]],
                       :include => "users")

    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @number = user_tasks.size + group_tasks.size
    render :partial => 'user_receive_task'
  end

  # 任务创建者删除确认的任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130704
  def user_task_delete
    task = Task.find_by_id(params[:task_id])
    if task.confirm_flag == true
      task.destroy
      flash[:notice] = "Delete the  #{task.title} task success"
    else
      flash[:notice] = "Cannot delete the  #{task.title} task did not confirm"
    end
    @tasks = Task.find_all_by_user_id(params[:id])
    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",params[:id],"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",params[:id],false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @number = user_tasks.size + group_tasks.size
    render :partial => "user_new_task"
  end
  # 用户任务的附件下载
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130704
  def user_download_task_document
    attachment = Attachment.find_by_id(params[:attachment_id])
    file_path = "#{RAILS_ROOT}/public/documents/products/#{params[:attachment_id]}/#{attachment.datafile_file_name}"
    send_file(file_path)
  end

  # 用户完成的任务确认
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130704
  def user_confirm_task
    task = Task.find_by_id(params[:task_id])
    task.confirm_flag = true
    if task.save
      flash[:notice] = "confirm success"
    else
      flash[:notice] = "confirm failed"
    end

    user_tasks = Task.find(:all,
                           :conditions => ["tasks.user_id = ? and user_tasks.issue_status = ? and tasks.confirm_flag = ?",@user.id,"2",false],
                           :include => ["user_tasks","group_tasks"])
    group_tasks = Task.find(:all,
                            :conditions => ["tasks.user_id = ? and tasks.confirm_flag = ?
                                    and group_tasks.issue_status = ?",@user.id,false,"2"],
                            :include => ["user_tasks","group_tasks"])
    @tasks = Array.new
    @tasks << user_tasks
    @tasks << group_tasks
    @tasks.flatten!
    @number = user_tasks.size + group_tasks.size
    render :partial => 'user_task_confirm'
  end

  # 用户给群组发送消息
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130705
  def send_user_group_message
    @message = Message.new
    @message.user_id = params[:user_id]
    @group = Group.find_by_id(params[:group_id])
    return unless request.post?
    @message.attributes = params[:message]
    @message.receiver_type = 1
    @message.groups << @group
    if @message.save
      flash[:notice]="send success"
    else
      flash[:notice]="send Failure"
    end
  end

  # 用户退出群组
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130705
  def user_group_deleted
    user_groups = UserGroup.find_all_by_user_id_and_group_id(params[:user_id],params[:group_id])
    if user_groups.present?
      user_groups.each do |user_group|
        if user_group.destroy
          flash[:notice] = "Successfully deleted!!!"
        else
          flash[:notice] = "Delete failed"
        end
      end
    else
      flash[:notice] = "Does not exist"
    end
    @groups = Group.find(:all,
                         :conditions => ["user_groups.user_id = ? and user_groups.deleted = ?",params[:user_id],false],
                         :include => :user_groups)
    render :partial => "user_create_new_group"
  end

  # 用户给群组新建和分配任务
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130705
  def user_group_create_new_task
    task = Task.new(params[:task])
    if params[:documents].present?
      params[:documents].each_value do |document|
        task.documents << Document.new(document)
      end
    end
    if task.save
      flash[:notice]="Task creation success"
    else
      flash[:notice]="Task creation failed"
    end
    redirect_to :action => 'detail',:id => task.user_id
  end

  # 群组详细
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130705
  def group_detail
    @group = Group.find_by_id(params[:id])
    if @group.blank?
      flash[:notice] = "The group does not exist"
      redirect_to :action => 'group_list'
    else
      @users = User.find(:all,
                         :conditions => ["user_groups.group_id = ? and user_groups.deleted = ?",params[:id],false],
                         :include => [:user_groups])
      @messages = Message.find(:all,
                               :conditions => ["groups.id = ? and group_messages.deleted = ?",params[:id],false],
                               :include => ["groups","group_messages"])
      if params[:tab].blank?
        return
      end
    end

    if request.xml_http_request?
      case params[:tab]

        #群组消息
        when "group_message"
          render :partial => "group_message"

        #群组任务|完成的任务一览
        when "group_task","group_finish_task"
          @tasks = Task.find(:all,
                             :conditions => ["group_tasks.group_id = ? and group_tasks.issue_status = ?",params[:id],"2"],
                             :include => ["group_tasks"])
          render :partial => "group_finish_task"

        #未完成的任务一览
        when "group_unfinished_task"
          @tasks = Task.find(:all,
                             :conditions =>  ["group_tasks.group_id = ? and group_tasks.issue_status in (?)",params[:id],["0","1"]],
                             :include => ["group_tasks"])

          render :partial => "group_unfinished_task"

        when "group_task_issue_status"
          group_task_issue_status

        # 删除群组中的信息
        when "group_message_delete"
          group_message_delete
      end
    end
  end

  # 群组任务进度
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130705
  def group_task_issue_status
    group_task = GroupTask.find_by_group_id_and_task_id(params[:id],params[:task_id])
    task = Task.find_by_id(params[:task_id])
    #开启任务
    if group_task.issue_status == "0"
      group_task.issue_status = "1"
      group_task.save
      flash[:notice] = "Open the #{task.title} task success"
      #结束任务
    elsif group_task.issue_status == "1"
      group_task.issue_status = "2"
      group_task.save
      flash[:notice] = "End the  #{task.title} task success"
      #删除任务发起人确认后的任务
    elsif group_task.issue_status == "2"
      if task.confirm_flag == true
        group_task.destroy
        flash[:notice] = "Delete the  #{task.title} task success"
      else
        flash[:notice] = "Cannot delete the  #{task.title} task did not confirm"
      end
    end
    @tasks = Task.find(:all,
                       :conditions => ["group_tasks.group_id = ? and group_tasks.issue_status in (?)",params[:id],["0","1"]],
                       :include => ["group_tasks"])

    render :partial => 'group_unfinished_task'
  end

  def user_new_group
    group = Group.new(params[:group])
    if params[:user_ids].present?
      params[:user_ids].each do |user_id|
        group.users << User.find_by_id(user_id)
      end
    end

    if group.save
      flash[:notice] = "User new group successful!"
    else
      flash[:notice] = "User new group failed!"
    end
    redirect_to :action => 'detail',:id => params[:group][:user_id]
  end

  # 添加上传框
  #【引数】
  #【返値】
  #【注意】
  #【著作】 by zj 20130708
  def add_field
    @file_id = params[:file_id].to_i + 1
    render :update do |page|
      text = render :partial => 'file_fields'
      page.insert_html :bottom, 'file_field', text
      page.replace_html "add_button", @template.link_to_remote('增加', :url => { :controller => 'admin/user',
                                                                               :action => "add_field",
                                                                               :file_id => @file_id,
                                                                               :before => 'this.remove()' })
    end
  end

  # 删除群组中的信息
  #【引数】
  #【返値】
  #【注意】
  #【著作】 by zj 20130709
  def group_message_delete
    message = Message.find_by_id(params[:message_id])
    if message.present?
      if message.destroy
        flash[:notice] = "Delete successful!"
      else
        flash[:notice] = "Delete failed!"
      end
    end
    @messages = Message.find(:all,
                             :conditions => ["groups.id = ?",params[:id]],
                             :include => :groups)
    render :partial => "group_message"
  end

end
