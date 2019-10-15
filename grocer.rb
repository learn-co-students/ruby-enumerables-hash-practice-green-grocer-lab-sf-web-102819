def consolidate_cart(cart)
  consol_cart = {}
  counthash = Hash.new(0)
  
  cart.each do |hash|
    hash.each do |key, value|
        consol_cart[key] = value
        counthash[key] +=1
    end
  end  
  counthash.each do |key, value|
    consol_cart[key][:count] = value
  end
return consol_cart
end

def apply_coupons(cart, coupons)
    mod_cart = cart
   
  coupons.each do |hash|
    name = hash[:item]
    if cart[name] == nil
      next
    end
    if cart[name][:count] < hash[:num]
      next
    end 
    mod_cart[name][:count] -= hash[:num]
    couponname = "#{name} W/COUPON"
    price = (hash[:cost]/1.0)/hash[:num]
    if mod_cart[couponname] == nil
    mod_cart[couponname] = {:price => price, :clearance => cart[name][:clearance], :count => hash[:num]}
  else mod_cart[couponname][:count] += hash[:num]
  end
end
return mod_cart
end

def apply_clearance(cart)
    mod_cart = cart
   cart.each do |key, value|
    if cart[key][:clearance] == true
        mod_cart[key][:price] = (cart[key][:price]*0.8).round(2)
    end
end
    return mod_cart
end

def checkout(cart, coupons)
    mod_cart = consolidate_cart(cart)
    mod_cart = apply_coupons(mod_cart, coupons)
    mod_cart = apply_clearance(mod_cart)

    total = 0

    mod_cart.each do |key, value|
       total += mod_cart[key][:price] * mod_cart[key][:count]
    end
    if total > 100
      total = (total * 0.9).round(2)
    end
    return total

end
