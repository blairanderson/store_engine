require 'spec_helper'

describe "Shopping Cart" do 

  context "views" do 
    xit "should be on the index page" do
      visit root_path
      expect( page ).to have_content "0"
    end

    let!(:product) { Product.create(title: "ironing board", price: 10000, cost_cents:5000, long_description:"we do ironing boards well", :categories_list => "laundry") }

    it "should persist on Category#index" do
      visit product_path(product)
      click_link "Add to Cart"
      visit categories_path
      within( "#shopping_cart" ) do
        expect( page ).to have_content product.title
      end
    end

    it "should persist on Category#show" do
      visit product_path(product)
      click_link "Add to Cart"
      target_category = Category.find_by_name('laundry')
      visit category_path(target_category)
      within( "#shopping_cart" ) do
        expect( page ).to have_content product.title
      end
    end

    it "should persist on Product#show" do
      visit product_path(product)
      click_link "Add to Cart"
      visit product_path(product)
      within( "#shopping_cart" ) do 
        expect( page ).to have_content product.title
      end
    end 

    it "should persist on Product#index" do
      visit product_path(product)
      click_link "Add to Cart"
      visit products_path
      within( "#shopping_cart" ) do 
        expect( page ).to have_content product.title
      end
    end

    it "should add content to shopping_cart" do
      visit product_path(product)
      click_link "Add to Cart"
      within( "#shopping_cart" ) do 
        expect( page ).to have_content product.title
      end
    end

    xit "increase quantity on + click" do
      visit product_path(product)
      click_link "Add to Cart"
      visit products_path
      click_link("increase_count")
      within( "#shopping_cart" ) do 
        expect( page ).to have_content "2 x"
      end
    end

    xit "decrease quantity on - click" do
      visit product_path(product)
      click_link "Add to Cart"
      visit products_path
      click_link("decrease_count")
      expect( page ).to have_content "0"
    end

    it "should have a View Cart button" do 
      visit product_path(product)
      click_link "Add to Cart"
      expect( page ).to have_link "Cart"
    end

  end #--- view context

  context "cart review" do 

    let!(:product) { Product.create(title: "ironing board", price: "10012", description:"we do ironing boards well", :categories_list => "laundry") }

    xit "should have a cart route" do
      visit product_path(product)
      click_link "Add to Cart"
      # click_link "Cart"
      # expect( current_path ).to eq cart_path
    end

    xit "should list cart contents" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      expect( page ).to have_content product.title
    end

    xit "should not have a View Cart link" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      expect( page ).to_not have_link "View Cart"
      expect( page ).to_not have_selector "#shopping_cart"
    end

    xit "should link to product detail page" do 
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      expect( page ).to have_link "ironing board"
    end

    xit "should show item price" do 
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      expect( page ).to have_content "$100.12"
    end

    xit "should have subtotal of 2 items in cart" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      click_link "+"
      within( "#cart_subtotal" ) do 
        expect( page ).to have_content "$200.24"
      end
    end

    xit "should have subtotal of 3 items in cart" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      click_link "+"
      click_link "+"
      within( "#cart_subtotal" ) do 
        expect( page ).to have_content "$300.36"
      end
    end

    xit "should have a remove button" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      expect( page ).to have_button "Remove"
    end

    xit "should remove product" do
      visit product_path(product)
      click_link "Add to Cart"
      click_link "View Cart"
      click_button "Remove"
      expect( page ).to have_content "0 items"
    end

    xit "should have a pay now link" do
      visit product_path(product)
      click_link "Add to Cart"
      visit cart_path
      expect( page ).to have_link "Checkout"
    end

    xit "unauthenticated users should be redirected to login" do
      visit product_path(product)
      click_link "Add to Cart"
      visit cart_path
      click_link "Checkout"
      expect( page ).to have_content "Email"
      expect( page ).to have_content "Password"
    end

    xit "should show flash message for unauthenticated users" do
      visit product_path(product)
      click_link "Add to Cart"
      visit cart_path
      click_link "Checkout"
      expect(page).to have_content "Must Be Logged In"
    end
  end

  context "cart persists through login/logout" do 

    def user_logs_in
      visit login_path
      fill_in "username", :with => "admin"
      fill_in "password", :with => "admin"
      click_button "Login"
    end

    let!(:product) { Product.create(title: "ironing board", price: "10012", description:"we do ironing boards well", :categories_list => "laundry") }
    let!(:user) { User.create(email:"admin@admin.com", username:"admin", password:"admin", password_confirmation:"admin")}
    
    xit "shows products before and after logout/login" do
      user_logs_in

      visit product_path(product)
      click_link "Add to Cart"
      visit logout_path
      
      user_logs_in

      visit cart_path

      expect(page).to have_content "ironing board"
      expect(page).to have_content "we do ironing boards well"
    end
  end
end






