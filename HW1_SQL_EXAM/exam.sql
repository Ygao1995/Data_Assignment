##Q1 Employees all over the world. Can you tell me the top three cities that we have employees?
use classicmodels;

SELECT O.city, count(employeeNumber) as employee_count
FROM employees e 
join offices o
on e.officeCode = o.officeCode
group by o.city
order by employee_count desc
limit 3;

##Q2 For company products, each product has inventory and buy price, msrp. Assume that every product is sold on msrp price. 
##   Can you write a query to tell company executives: profit margin on each productlines
##   Profit margin= sum(profit if all sold) - sum(cost of each=buyPrice) / sum (buyPrice)
##   Product line = each product belongs to a product line. You need group by product line. 

SELECT productLine,(sum(quantityInStock * MSRP)- SUM(quantityInStock * buyPrice))/SUM(quantityInStock * buyPrice) as profitMargin
FROM products 
group by productLine
order by profitMargin desc;

##Q3 company wants to award the top 3 sales rep They look at who produces the most sales revenue.
##   A. can you write a query to help find the employees. 
##   B. if we want to promote the employee to a manager, what do you think are the tables to be updated. 
##   C. An employee  is leaving the company, write a stored procedure to handle the case. 
##   1). Make the current employee inactive, 2). Replaced with its manager employeenumber in order table. 

##A
SELECT
	e.employeeNumber, e.lastName, e.firstName, sum(t1.sales) as sales
FROM
	employees e
join
	(SELECT c.customerNumber, c.salesRepEmployeeNumber, sum(p.amount) as sales
	FROM customers c
	join payments p
	on c.customerNumber = p.customerNumber
	group by c.customerNumber) as t1
on e.employeeNumber = t1.salesRepEmployeeNumber
group by e.employeeNumber
order by sales desc
limit 3;

##B
/*UPDATE	employees 
 SET 
  jobTitle = 'Sales Manager' 
  reportsTo = 1056(number for vp sales)
WHERE employeeNumber in (employee number for promotion)
*/

### C


/*=======following challenge:
Employee 
[employee_id, employee_name, gender, current_salary, department_id, start_date, term_date]

Employee_salary 
[employee_id, salary, year, month]

Department 
[department_id, department_name]

Q4. Employee Salary Change Times 
Ask to provide a table to show for each employee in a certain department how many times their Salary changes 
*/

SELECT t1.*, d.department_name	
From
    (SELECT
		e.employee_id, e.employee_name, e.department_id, count(distinct s.salary) as salary_change
	From 
		employee e
	left join 
		employee_salary s
	on e.employee_id = s.employee_id
	group by e..employee_id) as t1
left join Department d
on t1.department_id = d.department_id
    
/*
Q5 top 3 salary
Ask to provide a table to show for each department the top 3 salary with employee name 
and employee has not left the company.
*/
SELECT e.employee_name, d.department_name, e.salary,
dense_rank() over
(Partition by d.department_name order by e.salary desc ) as rank
From employee e
left join 
department d 
on e.department_id = d. department_id
Where rank <=3 and e.term_date >= '5/1/2020'




