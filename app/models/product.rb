class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item
  
  # VALIDATIONS:
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  # validate correct image url
  validates :image_url, :format => {:with => %r{\.(gif|jpg|png)\z}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'}
  # title must be 10 char long
  validates :title, :uniqueness => true, :length => {
    :minimum => 10,
    :message => 'must be at least ten characters long.'
  }
    
  private
  # ensure that there are no line items referencing this product  
    def ensure_not_referenced_by_any_line_item
      if line_items.count.zero?
        return true
      else
        error[:base] << "Line Items present"
        return false
      end
    end

end
