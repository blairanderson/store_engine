class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  attr_accessible :status, :subtotal
  validates_presence_of :user_id

  scope :abandoned, where(status: "abandoned")
  scope :pending, where(status: "pending")
  scope :cancelled, where(status: "cancelled")
  scope :paid, where(status: "paid")
  scope :shipped, where(status: "shipped")
  scope :returned, where(status: "returned")

  def self.stats
    keys = ["abandoned", "pending", "cancelled", "paid", "shipped", "returned"]
    keys.map{|scope|{status: scope, quantity:Order.send(scope.to_sym).size}}
  end

  def self.search(search)
    if search
      where(status:search)
    else
      find(:all)
    end
  end

  def self.for_user(user)
    order = user.orders.create(status: "pending")
    order.create_line_items(user.cart)
    order.calculate_subtotal
    order.save
    return order
  end

  def create_line_items(cart)
    cart.data.each do |id,quantity|
      product = Product.find(id)
      line_items.create(
        :product_id       => product.id,
        :quantity         => quantity, 
        :unit_price_cents => product.price)
    end
  end

  def calculate_subtotal
    result = []
    self.line_items.each do |line_item|
      result << line_item.quantity * line_item.unit_price_cents
    end
    self.subtotal = result.inject(:+)
  end

end
