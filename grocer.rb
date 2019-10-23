def consolidate_cart(cart)
  cart_hash = {}
    cart.each  do |item_hash|
    item_hash.each do |key, data|
      if cart_hash[key]
        cart_hash[key][:count] += 1
      else
        cart_hash[key] = data
        cart_hash[key][:count] = 1
      end
    end
  end
   return cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon.each do |key, value|
      name = coupon[:item]
      if cart[name] && cart[name][:count] >= coupon[:num]
        if cart[name + " W/COUPON"]
          cart[name + " W/COUPON"][:count] += coupon[:num]
        else
          cart[name + " W/COUPON"] = {:price => (coupon[:cost] / coupon[:num]), :clearance => cart[name][:clearance], :count => coupon[:num]}
        end
        cart[name][:count] -=  coupon[:num]
      end
    end
  end
   cart
      
end

def apply_clearance(cart)
  cart.each do |item, values_hash|
    if values_hash[:clearance] == true
      values_hash[:price] = (values_hash[:price] * 0.8).round(2)
    end
  end
 cart
end

def checkout(cart, coupons)
  cost = 0
  new_cart = consolidate_cart(cart)
  cart_w_coupons = apply_coupons(new_cart, coupons)
  cart_w_clearance = apply_clearance(cart_w_coupons)
  
  cart_w_clearance.each do |item, values|
    cost += (values[:price] * values[:count])
  end
  
  if cost > 100
    cost = (cost * 0.9).round(2)
  end
  cost
end
