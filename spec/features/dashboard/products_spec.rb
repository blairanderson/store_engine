require 'spec_helper'

describe Product do 
  context "viewing products" do

    let!(:admin) {User.create(email: "admin@admin.com", username: "admin", 
        password: "admin", password_confirmation: "admin", admin: true)}

      def login_admin
        visit login_path
        fill_in 'username', :with => "admin@admin.com"
        fill_in 'password', :with => "admin"
        click_button "Login"
      end
      
      let!(:product) { Product.create(title: "ironing board", price: 10000, long_description:"we do ironing boards well") }


    xit "should show one product" do 
      Product.create(title: "Nalgene Water Bottle", long_description:"a really strong water bottle", price:"12345", categories_list:"bottle")
      visit '/'
      expect( page ).to have_content "Nalgene Water Bottle"
    end

    xit "should show all products" do 
      Product.create(title: "Macbook Air", long_description:"a really strong water bottle", price:"12345", categories_list:"computer")
      Product.create(title: "Pizza Box", long_description:"a really strong water bottle", price:"12345", categories_list:"pizza")
      visit root_path
      expect( page ).to have_content "Macbook Air"
      expect( page ).to have_content "Pizza Box"
    end

    xit "product title should link to detail page" do 
      Product.create!(title: "Nalgene Water Bottle", long_description:"a really strong water bottle", price:"12345", categories_list:"bottle")
      visit '/'
      expect( page ).to have_link "Nalgene Water Bottle"
    end

    xit "link to detail page displays details" do
      Product.create(title: "Nalgene Water Bottle", long_description:"a really strong water bottle", price:"12345", categories_list:"bottle")
      visit '/'
      click_link "Nalgene Water Bottle"
      expect( page ).to have_content "a really strong water bottle"
    end

    xit "should have link to categories" do
      visit root_path
      expect( page ).to have_link "Categories"
    end

    xit "should create a new product" do
      login_admin
      visit new_dashboard_product_path
      fill_in "product_title", :with => "ironing board"
      fill_in "product_price", :with => "100"
      fill_in "product_long_description", :with => "we do ironing boards well"
      click_button "Create Product"
      expect( page ).to have_content "ironing board"
    end

    xit "should show the categories associated with the product" do
      visit new_dashboard_product_path
      fill_in "product_title", :with => "ironing board"
      fill_in "product_price", :with => "100"
      fill_in "product_long_description", :with => "we do ironing boards well"
      fill_in "product_categories_list", :with => "ironing,laundry"
      click_button "Create Product"
      expect( page ).to have_link "Ironing"
      expect( page ).to have_link "Laundry"
    end

    
    context "editing and updating" do
      let!(:admin) {User.create(email: "admin@admin.com", username: "admin", 
        password: "admin", password_confirmation: "admin", admin: true)}

      def login_admin
        visit login_path
        fill_in 'username', :with => "admin@admin.com"
        fill_in 'password', :with => "admin"
        click_button "Login"
      end

      let!(:product) { Product.create!(title: "ironing board", price: 1000, cost_cents:500, long_description:"we do ironing boards well", categories_list: "laundry") }

      xit "product detail should have edit link" do
        login_admin
        binding.pry
        visit dashboard_product_path(product)
        expect( page ).to have_link "Edit Product"
      end

      xit "should show the edit product page" do
        visit edit_dashboard_product_path(product)
        expect(find_field('product_title').value).to eq "ironing board"
      end

      xit "should change when updates are submitted" do 
        visit edit_dashboard_product_path(product)
        fill_in 'product_long_description', :with => "Hermans Hideaway"
        click_button "Update Product"
        expect( page ).to have_content "Hermans Hideaway"
      end

      xit "should have a retire button" do
        visit dashboard_product_path(product)
        expect( page ).to have_link "Retire"
      end

      xit "should have a categories field" do 
        visit new_dashboard_product_path
        expect( find_field("product_categories_list").value ).to eq ""
      end

      xit "should link to product edit page" do
        login_admin
        visit dashboard_products_path
        click_link "Edit Product"
        expect( current_path ).to eq edit_dashboard_product_path(product)
      end

      xit "should link to category detail page" do
        login_admin
        visit dashboard_product_path(product)
        click_link "Laundry"
        expect( current_path ).to eq dashboard_category_path(product)
      end

      xit "should put a product on sale" do 
        login_admin
        visit dashboard_product_path(product)
      end

    end

  end
end
