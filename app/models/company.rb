class Company < Admin
  # attr_accessible :title, :body

  has_many :users , :dependent => :destroy
  has_many :groups , :dependent => :destroy


  #条件検索
  #【引数】params
  #【返値】array
  #【注意】
  #【著作】www 20130621
  def self.get_array(params)
    conditions = [["1=1"]]
    conditions[0] << " type = ? "
    conditions << "Company"
    unless params[:name].blank?
      conditions[0] << ' name like ? '
      conditions << "%"+params[:name]+"%"
    end

    if params[:id].present?
      conditions[0] << " id = ? "
      conditions << params[:id]
    end
    if params[:tel].present?
      conditions[0] << " tel like ? "
      conditions << "%"+params[:tel]+"%"
    end

    if params[:email].present?
      conditions[0] << " email like ? "
      conditions << "%"+params[:email]+"%"
    end

    conditions[0] = conditions[0].join(' and  ')
    return conditions
  end

end
