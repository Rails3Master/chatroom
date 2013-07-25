class TasksController < UsersController

  layout "shadow"

  # 添加联系人
  #【引数】
  #【返値】
  #【注意】
  #【著作】by lb 20130716
  def search_user
    @condition = params[:condition]
    #查询符合条件的所有用户
    if  @condition.blank?
      @users = [].paginate
    else
      @users = User.paginate(:per_page => APP_CONFIG[:per_page_3], :page => params[:page],
                             :conditions => ["login like ? and id != ? and id not in (select friend_id from contacts where user_id = ?)",
                                             "%"+@condition+"%", current_user.id, current_user.id])
    end
    #respond_to_parent do
    #  render :update do |page|
    #    text = render :partial => "contact_list"
    #    page.replace_html '_contactWindowBox', text
    #  end
    #end
    render :update do |page|
      page.replace_html '_contactWindowBox', :partial => "contact_list"
      if @users.size > 0
        page << "$('_contactWindowCheckAllButton').writeAttribute('class','_button btnLarge _cwBN button');"
        page << "$('_contactWindowCheckAllButton').writeAttribute('aria-disabled','false');"
        page.replace_html '_contactWindowPager', will_paginate_remote(@users, {:params => {:condition => @condition}})
      else
        page << "$('_contactWindowCheckAllButton').writeAttribute('class','_button btnLarge _cwBN button btnDisable');"
        page << "$('_contactWindowCheckAllButton').writeAttribute('aria-disabled','true');"
        page.replace_html '_contactWindowPager', ''
      end
    end
  end

  # 联系人管理
  #【引数】
  #【返値】
  #【注意】
  #【著作】by lb 20130716
  def add_friend
    friend_id = params[:friend_id]
    @contact = Contact.find(:first, :conditions => ["user_id = ? and friend_id = ?", current_user.id, friend_id])
    @contact = Contact.new if @contact.blank?
    @contact.user_id = current_user.id
    @contact.friend_id =  friend_id
    @contact.save!
    render :text => "#{friend_id}"
    #render :update do |page|
    #  #<li data-aid=**>
    #  page << "delete_contact_li(#{friend_id})"
    #end
  end

end
