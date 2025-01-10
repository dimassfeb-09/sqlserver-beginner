CREATE DATABASE sales_npm; -- Ubah dengan NPM kalian yaa

USE sales_npm; -- Ubah dengan NPM kalian yaa

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    stock INT NOT NULL
);

INSERT INTO products 
VALUES	(101, 'Smartphone', 12), 
		(102, 'Laptop', 15),
		(103, 'iPad', 8),
		(104, 'Headphone', 20),
		(105, 'Keyboard', 10);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY IDENTITY(1,1), 
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE failed_sales_log (
    log_id INT PRIMARY KEY IDENTITY(1,1), 
    product_id INT,
    error_message VARCHAR(80),
    quantity INT,
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- CREATE TRIGGER reduce_stock_products
CREATE TRIGGER reduce_stock_products
ON sales
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.stock = p.stock - i.quantity
    FROM products p
    INNER JOIN inserted i
    ON p.product_id = i.product_id;
END;

-- CREATE TRIGGER check_stock_before_sale
CREATE TRIGGER check_stock_before_sale
ON sales
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @product_id INT, @quantity INT, @stock INT;

    SELECT @product_id = product_id, @quantity = quantity FROM inserted;

    SELECT @stock = stock FROM products WHERE product_id = @product_id;

    IF @stock < @quantity
    BEGIN
        -- SAVE FAILED TRANSACTION INTO TABLE LOG
        INSERT INTO failed_sales_log (product_id, error_message, quantity)
        VALUES (@product_id, 'Mohon maaf stok produk tidak mencukupi', @quantity);
        RAISERROR('Mohon maaf stok produk tidak mencukupi', 16, 1);
    END
    ELSE
    BEGIN
        -- Insert into table sales if stock avail
        INSERT INTO sales (product_id, quantity, sale_date)
        SELECT product_id, quantity, sale_date
        FROM inserted;

        -- Reduce Stock
        UPDATE products SET stock = stock - @quantity
        WHERE product_id = @product_id;
    END;
END;

INSERT INTO sales (product_id, quantity, sale_date)
VALUES  (101, 15, '2025-01-05');

INSERT INTO sales (product_id, quantity, sale_date)
VALUES  (102, 10, '2025-01-05');

SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM failed_sales_log;