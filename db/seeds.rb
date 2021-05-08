# Admin User
puts 'Seeding Admin User'
User.create("email"=>"admin@meiduoni.com", "password"=>"123123", "admin"=>true, "name"=>"Admin", "guest"=>false)

# Products
puts 'Seeding Products'
Product.create("sku"=>"111", "color"=>"black", "image"=>"https://res.cloudinary.com/storedan/image/upload/v1620506285/111/111-white.jpg")
Product.create("sku"=>"222", "color"=>"brown", "image"=>"https://res.cloudinary.com/storedan/image/upload/v1606253622/222/222-black.jpg")
Product.create("sku"=>"222", "color"=>"white", "image"=>"https://res.cloudinary.com/storedan/image/upload/v1606781841/222/222-brown.jpg")

# Inventory
puts 'Seeding Inventory'
Inventory.find_by("product_id"=>1, "size"=>"35").update("quantity"=>1)
Inventory.find_by("product_id"=>1, "size"=>"36").update("quantity"=>2)
Inventory.find_by("product_id"=>1, "size"=>"37").update("quantity"=>2)
Inventory.find_by("product_id"=>1, "size"=>"38").update("quantity"=>2)
Inventory.find_by("product_id"=>1, "size"=>"39").update("quantity"=>2)
Inventory.find_by("product_id"=>1, "size"=>"40").update("quantity"=>0)
Inventory.find_by("product_id"=>2, "size"=>"35").update("quantity"=>1)
Inventory.find_by("product_id"=>2, "size"=>"36").update("quantity"=>2)
Inventory.find_by("product_id"=>2, "size"=>"37").update("quantity"=>2)
Inventory.find_by("product_id"=>2, "size"=>"38").update("quantity"=>2)
Inventory.find_by("product_id"=>2, "size"=>"39").update("quantity"=>2)
Inventory.find_by("product_id"=>2, "size"=>"40").update("quantity"=>1)
Inventory.find_by("product_id"=>3, "size"=>"35").update("quantity"=>0)
Inventory.find_by("product_id"=>3, "size"=>"36").update("quantity"=>1)
Inventory.find_by("product_id"=>3, "size"=>"37").update("quantity"=>2)
Inventory.find_by("product_id"=>3, "size"=>"38").update("quantity"=>2)
Inventory.find_by("product_id"=>3, "size"=>"39").update("quantity"=>0)
Inventory.find_by("product_id"=>3, "size"=>"40").update("quantity"=>0)

# Properties
puts 'Seeding Properties'
Property.find_by("product_id"=>1).update("gender"=>"female", "material"=>"canvas", "season"=>"all season", "price"=>118)
Property.find_by("product_id"=>2).update("gender"=>"female", "material"=>"leather", "season"=>"all", "price"=>200)
Property.find_by("product_id"=>3).update("gender"=>"male", "material"=>"leather", "season"=>"all", "price"=>198)

puts 'Seeding Complete'