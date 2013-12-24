# encoding: utf-8





require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  fixtures :products
  
  
  test "attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  
  test "price must be positive" do
    product = Product.new(title: "qqq", description: "www", image_url: "eee.jpg")
    
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('xxx')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 1
    assert product.valid?
  end
  
  
  
  def new_product(image_url)
    Product.new(title: "aaa", description: "sss", price: 1, image_url: image_url)
  end
  
  test "image url" do
   ok = %w{ zzz.gif xxx.jpg ccc.png VVV.GIF BBB.JPG NNN.PNG http://a.b.c/x/y/z/mmm.gif}
   bad = %w{ aaa.doc sss.gif/more ddd.gif.more }
   
   ok.each do |name|
     assert new_product(name).valid?, "#{name} should't be invalid"
   end
   
   bad.each do |name|
     assert new_product(name).invalid?, "#{name} should't be valid"
   end
   
  end
  
  
  # 商品名が一意であること
  test "product is not valid without a unique title" do
    product = Product.new(
      title: products(:ruby).title,
      description: "qqq",
      price: 1,
      image_url: "fred.gif")
    
    assert !product.save

    # assert_equal "has already been taken", product.errors[:title].join('; ')
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')

  end
  
  
  
  
  
  
  
end

