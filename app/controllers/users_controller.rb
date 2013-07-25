# encoding: UTF-8
class UsersController < ApplicationController
  layout :get_layout #, :except => [:login, :signup]
  before_filter :authenticate_user!


  def get_layout
    return "user"
  end

  # say something nice, you goof!  something sweet.
  def index
    #查找当前登录用户的好友
    @contacts = Contact.where("user_id=? and confirm_flag = ?", current_user.id, true)
    @users = Array.new
    @contacts.each do |contact|
      @users <<  User.find_by_id(contact.friend_id)
    end
    #查找用户所在群组
    @userGroups = UserGroup.where(["user_id=?",current_user.id])
    @groups = Array.new
    @userGroups.each{ |group|
      @groups<<  Group.find_by_id(group.group_id)
    }
  end


  # 显示当前聊天用户相关聊天信息
  #【引数】
  #【返値】
  #【注意】
  #【著作】by fw 20130712
  def show_chat

    chat_type = params[:chat_type]
    @current_user = current_user
    #保存聊天对象
    session[:chat_type] = chat_type
    session[:chat_id] = params[:chat_id]
    #查找用户聊天对象信息
    if chat_type == "user"
      @chat_info = User.find_by_id(params[:chat_id])
      @messages = Message.where(:include => "user_messages",
                                :conditions => ["messages.id = user_messages.message_id and ((user_messages.user_id = ? and  messages.user_id = ?) or (user_messages.user_id = ? and  messages.user_id = ?) )",
                                                    params[:chat_id],current_user.id,current_user.id,params[:chat_id]])
    elsif chat_type=="group"
      @chat_info = Group.find_by_id(params[:chat_id])
      @messages = Message.where(:include=>"group_messages",
                                :conditions=>["messages.id = group_messages.message_id and group_messages.group_id = ?",
                                                  params[:chat_id]])
    end

    #保存最后一天消息的id
    if  @messages.present?
      session[:message_last] = @messages.last.id
    else
      session[:message_last] = 0
    end

    #替换聊天信息
    #respond_to_parent do
    render :update do |page|
      text = render :partial => "main_content"
      page.replace_html '_mainContent', text
      page.replace_html "title","ChatRoom - " + @chat_info.name
    end
    #end
  end

end
