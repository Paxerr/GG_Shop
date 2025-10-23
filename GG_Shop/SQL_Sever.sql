Create database GG_Shop
go
Use GG_Shop
go
-- USERS
CREATE TABLE users (
  id INT IDENTITY(1,1) PRIMARY KEY,
  username NVARCHAR(50) UNIQUE NOT NULL,
  email NVARCHAR(100) UNIQUE NOT NULL,
  password_hash NVARCHAR(255) NOT NULL,
  full_name NVARCHAR(100) NOT NULL,
  mobile NVARCHAR(20),
  role NVARCHAR(20) NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE shipping_addresses (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  receiver_name NVARCHAR(100) NOT NULL,
  phone NVARCHAR(20),
  address NVARCHAR(255) NOT NULL,
  city NVARCHAR(100) NOT NULL,
  state NVARCHAR(100) NULL,
  postal_code NVARCHAR(20) NULL,
  country NVARCHAR(100) NOT NULL,
  is_default BIT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IDX_shipping_addresses_user_id ON shipping_addresses(user_id);


-- CATEGORIES
CREATE TABLE categories (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(100) NOT NULL,
  description NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT GETDATE()
);

-- PRODUCTS
CREATE TABLE products (
  id INT IDENTITY(1,1) PRIMARY KEY,
  title NVARCHAR(255) NOT NULL,
  category_id INT NOT NULL,
  description NVARCHAR(MAX),
  original_price DECIMAL(10,2) NOT NULL,
  sale_price DECIMAL(10,2) NOT NULL,
  status NVARCHAR(20) DEFAULT 'active',
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE INDEX IDX_products_category_id ON products(category_id);
CREATE INDEX IDX_products_title ON products(title);

-- PRODUCT ATTRIBUTES
CREATE TABLE product_attributes (
  id INT IDENTITY(1,1) PRIMARY KEY,
  product_id INT NOT NULL,
  attribute_name NVARCHAR(50) NOT NULL,
  attribute_value NVARCHAR(50) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX IDX_product_attributes_product_id ON product_attributes(product_id);

-- PRODUCT SKUs (size/color variant)
CREATE TABLE product_skus (
  id INT IDENTITY(1,1) PRIMARY KEY,
  product_id INT NOT NULL,
  sku NVARCHAR(50) UNIQUE NOT NULL,
  color NVARCHAR(30),
  size NVARCHAR(10),
  quantity INT DEFAULT 0,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX IDX_product_skus_product_id ON product_skus(product_id);

-- PRODUCT IMAGES
CREATE TABLE product_images (
  id INT IDENTITY(1,1) PRIMARY KEY,
  product_id INT NOT NULL,
  image_url NVARCHAR(255) NOT NULL,
  is_main BIT DEFAULT(0),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX IDX_product_images_product_id ON product_images(product_id);

-- ORDERS
CREATE TABLE orders (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status NVARCHAR(30) DEFAULT 'pending',
  shipping_address NVARCHAR(255),
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IDX_orders_user_id ON orders(user_id);

-- ORDER ITEMS
CREATE TABLE order_items (
  id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT NOT NULL,
  sku_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (sku_id) REFERENCES product_skus(id)
);

CREATE INDEX IDX_order_items_order_id ON order_items(order_id);
CREATE INDEX IDX_order_items_sku_id ON order_items(sku_id);

-- PAYMENT DETAILS
CREATE TABLE payment_details (
  id INT IDENTITY(1,1) PRIMARY KEY,
  order_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_method NVARCHAR(30),
  payment_status NVARCHAR(30) DEFAULT 'pending',
  created_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE INDEX IDX_payment_details_order_id ON payment_details(order_id);

-- CART
CREATE TABLE carts (
  id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  created_at DATETIME2 DEFAULT GETDATE(),
  updated_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IDX_carts_user_id ON carts(user_id);

-- CART ITEMS
CREATE TABLE cart_items (
  id INT IDENTITY(1,1) PRIMARY KEY,
  cart_id INT NOT NULL,
  sku_id INT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (cart_id) REFERENCES carts(id),
  FOREIGN KEY (sku_id) REFERENCES product_skus(id)
);

CREATE INDEX IDX_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX IDX_cart_items_sku_id ON cart_items(sku_id);

-- PROMOTIONS
CREATE TABLE promotions (
  id INT IDENTITY(1,1) PRIMARY KEY,
  promo_code NVARCHAR(50) UNIQUE NOT NULL,
  description NVARCHAR(255),
  discount_percentage DECIMAL(5,2) NULL,
  discount_amount DECIMAL(10,2) NULL,
  start_date DATETIME2 NOT NULL,
  end_date DATETIME2 NOT NULL,
  min_order_value DECIMAL(10,2) NULL,
  max_uses INT NULL,
  uses_count INT DEFAULT 0,
  status NVARCHAR(20) DEFAULT 'active'
);
