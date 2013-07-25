# encoding: UTF-8
class AdminTasksController < AdminsController
  #任務一覧
  #【引数】
  #【返値】
  #【注意】
  #【著作】by www 20130627
  def index
    @tasks=Task.paginate(:page => params[:page],
                           :per_page => APP_CONFIG[:per_page_3],
                           :order => "updated_at desc" )
  end

  # 任務検索
  #【引数】
  #【返値】
  #【注意】
  #【著作】by www 20130627
  def search
    @tasks=Task.paginate(:all, :page => params[:page],
                           :per_page => APP_CONFIG[:per_page_3],
                           :conditions =>Task.get_array(params[:task]),
                           :order => "updated_at desc"
    )
    render :action => "index"
  end

  #任務詳細
  #【引数】
  #【返値】
  #【注意】
  #【著作】 www 20130627
  def view
    @task = Task.find_by_id(params[:id])
  end

  #任務削除
  #【引数】
  #【返値】
  #【注意】
  #【著作】 www 20130628
  def delete
    task = Task.find_by_id(params[:id])
    task.destroy
    redirect_to :action => "index"
  end

  #任務編集
  #【引数】
  #【返値】
  #【注意】
  #【著作】by www 20130628
  def edit
    @task = Task.find_by_id(params[:id])
    if @task.blank?
      flash[:notice] = "IDが存在しません。 "
      redirect_to :action => "index"
    end
    return unless request.post?
    if @task.update_attributes(params[:task])
        @task.save
        flash[:error] ="データを更新しました。"
        redirect_to :action => "index"
      end
  end
end
