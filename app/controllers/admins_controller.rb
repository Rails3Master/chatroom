# encoding: UTF-8
class AdminsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin!#, :except => ['sign_in']

  #def index
  #  redirect_to :controller => '/admin/admin', :action => 'index'
  #end


  #def show
  #  @admin = Admin.find_by_id(params[:id])
  #end

  def index
    @admin = Company.new()
    @admins = Company.paginate(:page => params[:page],
                               :per_page => APP_CONFIG[:per_page_3],
                               :order => "updated_at desc"
    )
  end

  # 企業検索
  #【引数】
  #【返値】
  #【注意】
  #【著作】by www 20130621
  def search
    #redirect_to 'index' if request.get?
    if request.get?
      redirect_to :action => 'index'
      return
    end

    @admin = Company.new(params[:admin])
    @admins=Company.paginate(:page => params[:page],
                             :per_page => APP_CONFIG[:per_page_3],
                             :conditions =>Company.get_array(params[:admin]),
                             :order => "updated_at desc"
    )
    render "index"
  end

  # 企業新規
  #【引数】
  #【返値】
  #【注意】
  #【著作】www 20130621
  def new
    return unless request.post?
  end

  def create
    render('new') && return unless request.post?
    @admin = Company.new(params[:admin])
    if @admin.save
      UserMail.deliver_company_create_success(current_admin)
      redirect_back_or_default(:controller => '/admin/admin', :action =>'index')
      flash[:notice] = "登録しました。"
      render 'view'
    else
      render 'new'
    end
  end


  #企業管理者編集
  #【引数】
  #【返値】
  #【注意】
  #【著作】by www 20130624
  def edit
    @admin = Company.find_by_id(params[:id])
    if @admin.blank?
      flash[:notice] = "IDが存在しません。 "
      redirect_to :action => "index"
    end
    return unless request.post?
    if (params[:image].present?)
      file_name = "company_phpto_#{params[:id]}" + File.extname(params[:image][:datafile].original_filename)
      file_path = "#{RAILS_ROOT}/public/images/company/#{file_name}"
      photo_path = "/images/company/#{file_name}"
      File.open(file_path, "wb" ) do |f|
        f.write(params[:image][:datafile].read)
      end
      img = Magick::Image.read(file_path).first
      size = set_size(img, APP_CONFIG[:preview_size])
      resize_img = img.resize(size[0], size[1])
      resize_img.write(file_path)
    end
    if @admin.update_attributes(params[:admin])
      if (file_path.present?)
        @admin.photo_path = photo_path
        @admin.save
      end
      flash[:error] ="データを更新しました。"
      redirect_to :action => "index"
    end
  end

  #画像のプレビュー
  #【引数】
  #【返値】
  #【注意】
  #【著作】 www 20130624
  def image_preview
    @image_name = Image.image_preview(params[:image][:datafile])
    responds_to_parent do
      render :update do |page|
        text = render :partial => 'image_preview'
        page.replace_html 'image_preview', text
      end
    end
  end

  #企業管理者詳細
  #【引数】
  #【返値】
  #【注意】
  #【著作】 www 20130625
  def view
    @admin = Company.find_by_id(params[:id])
  end

  #企業管理者削除
  #【引数】
  #【返値】
  #【注意】
  #【著作】 www 20130625
  def delete
    users = User.find(:all, :conditions => ["company_id=?", params[:id]])
    if users.present?
      flash[:delete] = "ユーザーがあるので、削除できない"
    else
      admin = Admin.find_by_id(params[:id])
      admin.destroy
    end
    redirect_to :action => "index"
  end
end
