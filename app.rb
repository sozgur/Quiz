require "sinatra"
require 'json'
require "sinatra/activerecord"
require './models/user'
require './models/product'
require './models/cart'
require './models/cart_item'

set :database_file, "./config/database.yml"

post '/users' do
  user = User.new(params[:user])
  if user.save
  	status 201
  else
  	status 500
  end
end

post '/products' do
  product = Product.new(params[:product])
  if product.save
  	status 201
  else
  	status 500
  end
end

##### Create a new cart #####
post '/carts' do
  cart = Cart.new(params[:cart])
  if cart.save
  	status 201
  else
  	status 500
  end
end

##### Add product to the cart #####
post '/carts/:cart_id/products' do #parametre product_id
  cart = Cart.find(params[:cart_id])
  if cart.nil?
  	status 404
  else
  	if cart.cart_items.blank?
  		cart_item = CartItem.create(cart_id: cart.id, product_id: params[:cart_item][:product_id], quantity: 1)
  	else
  		product = cart.cart_items.where(product_id: params[:cart_item][:product_id])
  		if product.blank?
  			CartItem.create(cart_id: cart.id, product_id: params[:cart_item][:product_id], quantity: 1)
  		else
  			quantity = product.first.quantity
  			product.first.update(quantity: quantity+1)
  		end
  	end
 
  end
end

###### Remove product from the cart #######

delete '/carts/:cart_id/products/:product_id' do #parametre product_id
  cart = Cart.find(params[:cart_id])
  if cart.nil?
  	status 404
  else
  	product = cart.cart_items.where(product_id: params[:product_id])
  	if product.blank?
  		status 404
  	else
  		quantity = product.first.quantity
  		if quantity != 1
  			product.first.update(quantity: quantity-1)
  		else
  			product.first.destroy
  		end
  	end
  end
end
 
###### Clean cart  ######