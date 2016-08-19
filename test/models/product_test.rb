require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end
  test "product attributes must not be empty" do 
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "price must be positive" do
    product = Product.new( title: '1st', description: '1st description', image_url: 'abc.png' )
    assert product.invalid?

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]    

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new( title: '1st', description: '1st description', price: 1, image_url: image_url )
  end

  test "image_url" do
    ok = %w{fred.gif abc.png fg.jpg sfd.bfgnf.png }
    bad = %w{fred.gif.d asa.bd.cdg sds.ad}
    ok.each do |name|
      assert new_product(name).valid?
    end

    bad.each do |name|
      assert new_product(name).invalid?
    end
  end

  test "product is not valid without unique title" do
    product = Product.new(title: products(:ruby).title, description: '1st description', price: 1, image_url:'abc.png')
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]   
  end
end
