module UsersHelper

  # 根据传入的参数比较返回true或false
  #【引数】
  #【返値】
  #【注意】
  #【著作】by zj 20130627
  def check_flag(user_ids, id)
    flag = false
    user_ids.each do |user_id|
      if user_id == id
        flag = true
        break
      end
    end
    return flag
  end

  #获取接受任务者的任务状态
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130703
  def issue_status_name(task,user_id)
    user_task = UserTask.find_by_user_id_and_task_id(user_id,task.id)
    if user_task.present?
      status = user_task.issue_status
      if status == '0'
        return "Not start"
      elsif status == '1'
        return "In"
      elsif status == '2'
        return "Has been completed"
      end
    else
      ""
    end
  end

  #改变用户任务状态
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130703
  def task_status(task,user_id)
    user_task = UserTask.find_by_user_id_and_task_id(user_id,task.id)
    if user_task.present?
      status = user_task.issue_status
      if status == '0'
        return "0"
      elsif status == '1'
        return "1"
      elsif status == '2'
        return "2"
      end
    else
      ""
    end
  end

  #获取附件的地址
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130704
  def file_path(task)
    documents = Document.find_all_by_task_id(task.id)
    if documents.present?
      return documents
    else
      ""
    end
  end

  #获取接受任务者的任务状态
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130705
  def group_issue_status_name(task,group_id)
    group_task = GroupTask.find_by_group_id_and_task_id(group_id,task.id)
    if group_task.present?
      status = group_task.issue_status
      if status == '0'
        return "Not start"
      elsif status == '1'
        return "In"
      elsif status == '2'
        return "Has been completed"
      end
    else
      ""
    end
  end

  #改变群组任务状态
  #【引数】
  #【返値】
  #【注意】
  #【著作】zj 20130705
  def group_task_status(task,group_id)
    group_task = GroupTask.find_by_group_id_and_task_id(group_id,task.id)
    if group_task.present?
      status = group_task.issue_status
      if status == '0'
        return "0"
      elsif status == '1'
        return "1"
      elsif status == '2'
        return "2"
      end
    else
      ""
    end
  end

end
