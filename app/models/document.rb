class Document < ActiveRecord::Base
  acts_as_paranoid
  # attr_accessible :title, :body
  belongs_to  :task
  has_attached_file :datafile,
                    :url => "/documents/products/:id/:basename.:extension",
                    :path => ":rails_root/public/documents/products/:id/:basename.:extension"
end
