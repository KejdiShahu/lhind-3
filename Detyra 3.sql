-- Find the Customer who has the most orders. If more than 1 customer 
-- has the most orders then all customers should be displayed

SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS totalOrders
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING totalOrders = (
    SELECT MAX(order_count) FROM (
        SELECT customerNumber, COUNT(orderNumber) AS order_count
        FROM orders
        GROUP BY customerNumber
    ) AS order_counts
);

-- View all “Germany” customers and their orderdetails. If a customer has not 
-- made any orders then he should not be included in the result.

SELECT c.customerNumber, c.customerName, o.orderNumber, od.productCode, od.quantityOrdered, od.priceEach
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE c.country = 'Germany';

-- List all employees and the their revenue amount (based on payments table)

SELECT e.employeeNumber, e.firstName, e.lastName, COALESCE(SUM(p.amount), 0) AS totalRevenue
FROM employees e
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY totalRevenue DESC;

-- List all products which have been ordered the last month. 
-- (since the database is a bit old we assume we are now at 2005-01-01)

SELECT DISTINCT p.productCode, p.productName
FROM products p
INNER JOIN orderdetails od ON p.productCode = od.productCode
INNER JOIN orders o ON od.orderNumber = o.orderNumber
WHERE o.orderDate BETWEEN '2004-12-01' AND '2004-12-31';

-- Create a new table named employeedetails which should contain data like:
-- bankAccount
-- address
-- phoneNumber
-- personalEmail

CREATE TABLE employeedetails (
    employeeNumber INT,
    bankAccount VARCHAR(30),
    address VARCHAR(255),
    phoneNumber VARCHAR(20),
    personalEmail VARCHAR(100),
    PRIMARY KEY (employeeNumber),
    FOREIGN KEY (employeeNumber) REFERENCES employees(employeeNumber) ON DELETE CASCADE
);

-- DROP TABLE employeedetails;

