class Image < Attachment
  belongs_to  :task
  has_attached_file :datafile,
                    :styles => { :mini => '48x48#', :small => '100x100>', :medium => '240x240>', :large => '600x600>' },
                    :default_style => :medium,
                    :default_url => "/images/noimage/:style.jpg",
                    :url => "/images/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/images/products/:id/:style/:basename.:extension"

  #validates_attachment_presence :datafile
  #validates_attachment_size :datafile, :less_than => 5.megabytes
  validates_attachment_content_type :datafile, :content_type => [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/jpg']

  def self.image_preview(file)
    file_name = "temp" + File.extname(file.original_filename)
    file_path = "#{RAILS_ROOT}/public/images/products/#{file_name}"
    File.open(file_path, "wb" ) do |f|
      f.write(file.read)
    end
    img = Magick::Image.read(file_path).first
    size = set_size(img, APP_CONFIG[:preview_size])
    resize_img = img.resize(size[0], size[1])
    resize_img.write(file_path)
    return file_name
  end

  def self.get_image(state, name)
    "/#{state}/products/" + name
  end

  def set_size(original_image, img_size="70x53")
    width_min = img_size.split("x")[0].to_i
    height_min = img_size.split("x")[1].to_i
    width = original_image.columns
    height = original_image.rows

    if width/width_min.to_f > height/height_min.to_f
      size = [width_min, height.to_f/width*width_min]
    else
      size = [width.to_f/height*height_min, height_min]
    end
    return size
  end

end
