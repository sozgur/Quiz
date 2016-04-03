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

get '/users' do
	User.all.to_json
end


get '/users/:user_id/carts' do
	user = User.find(params[:user_id])
	user.carts.to_json
end

get '/products' do
	Product.all.to_json
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
  		cart_item = CartItem.create(cart_id: cart.id, product_id: params[:product_id], quantity: 1)
  		cart.cart_items.to_json
  	else
  		products = cart.cart_items.where(product_id: params[:product_id])
  		if products.blank?
  			CartItem.create(cart_id: cart.id, product_id: params[:product_id], quantity: 1)
  			cart.cart_items.to_json
  		else
  			quantity = products.first.quantity
  			products.first.update(quantity: quantity+1)
  			cart.cart_items.to_json
  		end
  	end
 
  end
end

###### Remove product from the cart #######
delete '/carts/:cart_id/products/:product_id' do 
  cart = Cart.find(params[:cart_id])
  if cart.nil?
  	status 404
  else
  	cart_items = cart.cart_items.where(product_id: params[:product_id])
  	if cart_items.blank?
  		status 404
  	else
  		quantity = cart_items.first.quantity
  		if quantity != 1
  			cart_items.first.update(quantity: quantity-1)
  		else
  			cart_items.first.destroy
  		end
  	end
  	cart.cart_items.to_json
  end
end
 
###### Clean cart  ######
put '/carts/:cart_id/clean' do
	cart = Cart.find(params[:cart_id])
	if cart.nil?
  		status 404
    else
	  	cart_items = cart.cart_items
	  	if cart_items.blank?
	  		status 404
	  	else
	  		cart_items.destroy_all
	  	end
	  	cart.id.to_json
    end

end

##### Set quantity for a product #####
put '/carts/:cart_id/products/:product_id' do #paremetre quantity
	cart = Cart.find(params[:cart_id])
	if cart.nil?
  		status 404
    else
    	cart_items = cart.cart_items.where(product_id: params[:product_id])
	  	if cart_items.blank?
	  		status 404
	  	else
	  		if params[:quantity].to_i >= 1 
	  			cart_items.first.update(quantity: params[:quantity])
	  		elsif params[:quantity].to_i == 0
	  			cart_items.first.destroy
	  		end
	  	end
	  	cart.cart_items.to_json
    end

end

###### Returns detail of the cart #####
get '/carts/:cart_id' do
	cart = Cart.find(params[:cart_id])
	if cart.nil?
  		status 404
    else
    	cart.cart_items.all.to_json
    end

end






