-- # 1 : create all the tables for the sales management system

-- 1. Create Categories (No dependencies)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR2(50),
    parent_category_id INT REFERENCES Categories(category_id)
);

-- 2. Create Customers (No dependencies)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    city VARCHAR2(50),
    join_date DATE
);

-- 3. Create Orders (Depends on Customers)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date DATE,
    total_amount NUMBER(10,2)
);

-- 4. Create Order_Items (Depends on Orders and Categories)
CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_name VARCHAR2(100),
    category_id INT REFERENCES Categories(category_id),
    quantity INT,
    unit_price NUMBER(10,2)
);


-- # 2 : instert sample data 

-- Insert Categories
INSERT INTO Categories VALUES (1, 'Electronics', NULL);
INSERT INTO Categories VALUES (2, 'Computers', 1);
INSERT INTO Categories VALUES (3, 'Laptops', 2);
INSERT INTO Categories VALUES (4, 'Clothing', NULL);

-- Insert Customers
INSERT INTO Customers VALUES (101, 'Jean', 'Mugisha', 'Kigali', TO_DATE('2025-01-15', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (102, 'Alice', 'Umutoni', 'Huye', TO_DATE('2025-02-20', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (103, 'Eric', 'Kwizera', 'Kigali', TO_DATE('2025-03-10', 'YYYY-MM-DD'));

-- Insert Orders
INSERT INTO Orders VALUES (1001, 101, TO_DATE('2026-06-01', 'YYYY-MM-DD'), 1250.00);
INSERT INTO Orders VALUES (1002, 102, TO_DATE('2026-06-02', 'YYYY-MM-DD'), 450.00);
INSERT INTO Orders VALUES (1003, 101, TO_DATE('2026-06-15', 'YYYY-MM-DD'), 800.00);
INSERT INTO Orders VALUES (1004, 103, TO_DATE('2026-06-20', 'YYYY-MM-DD'), 1500.00);

-- Insert Order Items
INSERT INTO Order_Items VALUES (1, 1001, 'MacBook Pro', 3, 1, 1200.00);
INSERT INTO Order_Items VALUES (2, 1001, 'Laptop Sleeve', 3, 1, 50.00);
INSERT INTO Order_Items VALUES (3, 1002, 'T-Shirt', 4, 3, 50.00);
INSERT INTO Order_Items VALUES (4, 1002, 'Leather Jacket', 4, 1, 300.00);
INSERT INTO Order_Items VALUES (5, 1003, 'Monitor', 2, 2, 400.00);
INSERT INTO Order_Items VALUES (6, 1004, 'Gaming Laptop', 3, 1, 1500.00);
COMMIT;

-- # 3 : apply CTE 

-- 1. Simple CTE
-- Business Value: Identifies premium high-value transactions above $1000 for VIP support tracking.
WITH HighValueOrders AS (
    SELECT order_id, customer_id, total_amount 
    FROM Orders 
    WHERE total_amount > 1000
)
SELECT * FROM HighValueOrders;


-- 2. Multiple CTEs
-- Business Value: Chains filter layers to extract structural sales facts specifically localized to Kigali.
WITH KigaliCustomers AS (
    SELECT customer_id FROM Customers WHERE city = 'Kigali'
),
KigaliOrders AS (
    SELECT order_id, total_amount FROM Orders 
    WHERE customer_id IN (SELECT customer_id FROM KigaliCustomers)
)
SELECT AVG(total_amount) AS kigali_average_sales FROM KigaliOrders;

-- 3. Recursive CTE
-- Business Value: Traverses the multi-level operational product taxonomy tree from top-level to leaf nodes.
WITH CategoryHierarchy (category_id, category_name, lvl) AS (
    SELECT category_id, category_name, 1 AS lvl 
    FROM Categories WHERE parent_category_id IS NULL
    UNION ALL
    SELECT c.category_id, c.category_name, ch.lvl + 1 
    FROM Categories c
    JOIN CategoryHierarchy ch ON c.parent_category_id = ch.category_id
)
SELECT * FROM CategoryHierarchy;

-- 4. CTE with Aggregation
-- Business Value: Provides an executive performance snapshot of accumulated spending trends grouped by user.
WITH CustomerSpending AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT customer_id, total_spent FROM CustomerSpending WHERE total_spent > 500;

-- 5. CTE combined with JOIN operations
-- Business Value: Enriches transactional data sets with profile details for precision marketing outreach.
WITH DetailedItems AS (
    SELECT order_id, product_name, unit_price FROM Order_Items
)
SELECT o.order_id, o.order_date, di.product_name, di.unit_price
FROM Orders o
JOIN DetailedItems di ON o.order_id = di.order_id;

-- # 4 : window functions 

-- Business Value: Classes transactions dynamically using standard competitive and fractional metrics.
SELECT order_id, total_amount,
       ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS row_num,
       RANK() OVER (ORDER BY total_amount DESC) AS rnk,
       DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dense_rnk,
       PERCENT_RANK() OVER (ORDER BY total_amount DESC) AS pct_rnk
FROM Orders;

-- Business Value: Benchmarks individual purchase weights directly against cumulative runtime market bounds.
SELECT order_id, total_amount,
       SUM(total_amount) OVER () AS cumulative_revenue,
       AVG(total_amount) OVER () AS system_average,
       MIN(total_amount) OVER () AS lowest_sale,
       MAX(total_amount) OVER () AS highest_sale
FROM Orders;

-- Business Value: Builds historical sequences to run delta evaluations across sequential buying dates.
SELECT order_id, order_date, total_amount,
       LAG(total_amount, 1, 0) OVER (ORDER BY order_date) AS previous_order_amount,
       LEAD(total_amount, 1, 0) OVER (ORDER BY order_date) AS next_order_amount
FROM Orders;

-- Business Value: Computes customer cohort bands and explicit continuous percentiles for targeting arrays.
SELECT order_id, total_amount,
       NTILE(2) OVER (ORDER BY total_amount DESC) AS sales_tier_bucket,
       CUME_DIST() OVER (ORDER BY total_amount DESC) AS cumulative_distribution
FROM Orders;



