-- Mastering SQL 50
use classicmodels;
show tables;

select * from products;
select * from productlines;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from customers;
select * from employees;

-- Part - 1 (50)
-- Task 1 - Generate a report showing the total sales per product line. 
-- Include the product line, the total number of products sold, and the total sales amount.
    
select p.productLine,
	   sum(od.quantityOrdered) TotalSales,
	   sum(od.quantityOrdered * priceEach) TotalSalesAmount
from orderdetails od
inner join products p on od.productCode = p.productCode
group by p.productLine ;

-- Task 2 - Determine the total sales for each office, including office city, number of orders processed, and total sales amount.

select os.city officecity, 
	   sum(od.quantityOrdered * priceEach) TotalSalesAmount,
       count(o.orderNumber) as Nop
from orderdetails od 
inner join orders o on od.orderNumber  = o.orderNumber
inner join customers c on o.customerNumber = c.customerNumber
inner join offices os on os.city = c.city
group by os.city;

-- Part - 2 (50)
-- Task - 2 Filter product lines that have an average product sale price above a specific value.

select p.productLine ,avg(od.priceEach) APS
from products p
inner join orderdetails od on p.productCode = od.productCode
group by p.productLine
having avg(od.priceEach) > 60;

-- Task 1 - High-Value Order Analysis: Identify offices with an average order value greater than a certain threshold. 
-- 			Include office city, average order value, and total number of orders.
            
select ofc.city, AVG(od.quantityOrdered * od.priceEach) Avgordervalue, 
COUNT(od.orderNumber) totalnumberoforders		
from orderdetails od
inner join orders o on od.orderNumber = o.orderNumber
inner join customers cs on o.customerNumber = cs.customerNumber
inner join offices ofc on ofc.city = cs.city
group by ofc.city
having AVG(od.quantityOrdered * od.priceEach) > 3000;

-- select AVG(quantityOrdered * priceEach) as average
-- from orderdetails;
desc customers;

-- Task -1 (51)
-- Create a query to find product names that start with "Classic", include any characters in the middle, and end with "Car".

select productName 
from products
where productName like 'Classic%car';

--  Identify all customer addresses that contain the word "Street" or "Avenue" in any part of the address field.

select addressLine1 
from customers 
where addressLine1 like "%Street%" or addressLine1 like "%Avenue%" or addressLine1 like "%st%";

-- Task - 2 Find all orders with total amounts between two values, indicating mid-range transactions

select o.orderNumber, sum(od.quantityOrdered * od.priceEach) totalAmount
from orderdetails od 
inner join orders o on od.orderNumber = o.orderNumber
group by o.orderNumber 
having totalAmount between 1200 and 4500;

-- Retrieve all payments made within a specific date range, focusing on a high-activity period.

select paymentDate,amount  
from payments
where paymentDate between '2004-01-01' and '2005-05-01';

-- Task - 3 Identify orders where the total amount exceeds the average sale amount across all orders. (exists, any , all)

select orderNumber, sum(quantityOrdered * priceEach) totalamount 
from orderdetails
group by orderNumber 
having sum(quantityOrdered * priceEach) > any(
			select avg(totalamount) from
							(select sum(quantityOrdered * priceEach) totalamount from orderdetails group by orderNumber)as avgsales 
);

-- Find products that have been ordered in quantities equal to the maximum quantity ordered for any product

select productCode
from orderdetails where quantityOrdered = all(
				select max(quantityOrdered) from orderdetails); 
                
-- Task - 4 Identify customers who have made payments in the top 10% of all payments and are located in specific geographic regions.

select cs.customerName
from payments p
inner join customers cs on p.customerNumber = cs.customerNumber
where p.amount > any(select 0.9 * max(amount) from payments)
and (cs.city like '%Los Angeles%' or cs.city like '%NYC%');



