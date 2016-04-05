# Quiz

##Models:
 **User:** username, Name, email, password 
 **Product:** name, price
 **Cart:** identifier, user[FK] 
 **CartItem:** cart[FK], product[FK], quantity

##API Implementation:
 **Endpoints:**

**Create a new cart:**
  * POST /carts
  - user_id: integer


**Add product to the cart**
 * POST /carts/{cart_id}/products
 - product_id: integer
 - quantity: integer (default=1)

**Remove product from the cart**
 * DELETE /carts/{cart_id}/products/{product_id}
 - cart_id: integer
 - product_id: integer

**Clean cart**
 * PUT /carts/{cart_id}/clean
 - cart_id: integer

**Set quantity for a product**
 * PUT /carts/{cart_id}/products/{product_id}
 - cart_id: integer
 - product_id: integer
 - quantity: integer

**Returns detail of the cart**
 * GET /carts/{cart_id}
 - cart_id: integer
