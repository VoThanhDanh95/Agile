class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :description, length: {minimum: 3, message: 'must be more than 3 characters'}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    messages: 'not a image file type'
  }

  def self.latest
    Product.order(:updated_at).last
  end
end
