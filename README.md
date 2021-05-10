# meiduoni-store

## Set up
- Run the following commands:
  - `git clone https://github.com/DanLi222/meiduoni-store.git`
  - `cd meiduoni-store`
  - `yarn install`
  - `bundle install`
  - `bin/rails db:setup`
  - `rails s`
- Navigate to localhost:3000

## Functions

### Add to cart
- Click on one of the shoes
- Choose the color, size, and quantity
- Click the "Add to cart" button
- Repeat the steps above with a different shoe

### Cart
- Click the "Cart" button on the top navigation bar
- Click the "Trash Bin" icon in front of an item to remove it from the cart
- Click the "Proceed to checkout" button to go to checkout

### Checkout
- Fill in the address form and click the "Place order" button
  - Your address will be saved for the next time you enter checkout 
- Click the "Paypal" button to pay
- Log in to paypal with these credentials 
  - email: `sb-jz9zr4081648@personal.example.com`
  - password: `sZ9<^}V0`
- Pay with Paypal
- Click the "Confirm Order" button

### Switch language
- Click the "Language" button from the top navigation bar to switch between English and Chinese

### Authentication
- Add an item to your cart
- Click on the "Login" button from the top navigation bar
- Click on the "Sign Up" link
- Create an account
  - Notice that your cart has been transfered to your new account
- Click on your email address on the top navigation bar
- From the dropdown menu, click on the "Log out" button
  - Notice that logging out has emptied the cart to protect your privacy

### Guest account
- As a guest, add an item to your cart
- Close and reopen your browser
  - Notice that your cart was preserved

### Admin account
- Log in as an admin with these credentials:
  - Email: `admin@meiduoni.com`
  - Password: `123123`

  ##### Create a product
  - Click the "New Product" button on the top navigation bar
  - Enter Sku, Color, and choose an image
    - Feel free to use this image: 
    - ![alt text](https://user-images.githubusercontent.com/60045359/117695869-b1b78980-b18e-11eb-8adf-f35eaeb0c5c3.png)

  - Click the "Create Product" button to create the product
    - Notice that the new product is displayed

  ##### Edit a product
  - Click the "Edit" button below one of the products
  - Enter the fields that needs to be updated
    - eg. Change the quantity for each size
  - Click the "Update Product" button
  - Click "Edit" button below the same product again
    - Notice the updated information are displayed

  ##### Switch between admin view and customer view
  - Click the "View" button on the top navigation bar to switch between "Admin View" and "Customer View"
