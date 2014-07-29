class CombineItemsInCart < ActiveRecord::Migration
  def up
    # カート内に、1つの商品に対して、複数の品目があった場合、1つの品目に置き換える
    Cart.all.each do |cart|
      # カート内の、各商品の数をカウントする
      sums = cart.line_items.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        if quantity > 1
          # 個別の品目を削除する
          cart.line_items.where(product_id: product_id).delete_all

          # 1つの品目に置き換える
          
          # (mass-assign protected attributes error occured)
          # cart.line_items.create(product_id: product_id, quantity: quantity)

          # (so change these code avoid this error)
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!

        end
      end
    end
  end

  def down
    # 数量>1の品目を複数の品目に分割する
    LineItem.where("quantity>1").each do |line_item|
      # 個別の品目を追加する
      line_item.quantity.times do

        # (mass-assign protected attributes error occured)
        # LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
        
        # (so change this line to avoid error above)
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id

      end
      
      # 元の品目を削除する
      line_item.destroy
    end
  end
end

