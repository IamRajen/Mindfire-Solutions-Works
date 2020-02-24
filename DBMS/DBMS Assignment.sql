CREATE DATABASE Employee;

USE Employee;
/*
CREATE TABLE tblEmp
(
	[ntEmpID] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [vcName] [varchar](100) NULL,
    [vcMobieNumer] [varchar](15) NULL,
    [vcSkills] [varchar](max) NULL,
    [moSalary] [money] DEFAULT(0) NOT NULL,
    [ntLevel] [bit] DEFAULT(0) NOT NULL
)
*/
SELECT * FROM tblEmp;

truncate table tblEmp;

INSERT [dbo].[tblEmp] VALUES
    ('Scott','123-456-3456','CF,HTML,JavaScript',50,0),
    ('Greg',NULL,'HTML5,JavaScript,Jquery',80,0),
    ('Alan','123-456-3459','C#,VB,XQuery',60,1),
	('David','123-456-3458','Sql,JavaScript',30,1),
    ('Jhon',NULL,'XML,HTML',80,1),
    ('Alan','123-456-3461','Sql,Oracle,DB2',70,1)


-- 1. Write a single sql query with following information's:

-- a. Total number number of employees
-- b. Minimum salary received by any employees.
-- c. Total distinct ntLevel

SELECT count(ntEmpID) 'Total Employees',MIN(moSalary) 'Minimum Salary',Count(distinct ntLevel) 'Total Distinct nthLevel'
FROM tblEmp;
------------------------------------------------------------------------------------------

/*2. Correct this query:

    SELECT [ntEmpID], E.[vcName],tblEmp.[vcMobieNumer]
    FROM tblEmp E */
	

SELECT E.[ntEmpID], E.[vcName],E.[vcMobieNumer]
FROM tblEmp E
------------------------------------------------------------------------------------------
/*3. Write a single select query which satisfies the following conditions:
    a. If any employee does not have a phone number then select that employee if ntLevel  equal to 1
    b. else select those employees whose ntLevel is equal to 0 */
        
SELECT * FROM tblEmp
WHERE (ntLevel = 1 and vcMobieNumer is null) or ntLevel = 0;
------------------------------------------------------------------------------------------

-- 4.  Write a sql query which displays those employee data first, who knows javascript.
SELECT @@VERSION
select * from tblEmp
order by(case
			when vcSkills not like '%JavaScript%' then 1
			else 0
		end);
------------------------------------------------------------------------------------------
/*5. Explain the TOP clause in the following sql queries?
    
    a. SELECT TOP(1) * FROM tblEmp 
    b. SELECT TOP(SELECT 3/2) * FROM tblEmp 
    c. SELECT TOP(1) PERCENT * FROM tblEmp
    d. SELECT TOP(1) WITH TIES * FROM tblEmp ORDER BY vcName*/

-- a. Selects the Top 1 tuple from table tblEmp
-- b. Selects the Top 1 tuple from table tblEmp
-- c. Selects the Top 1 percent tuples from table tblEmp with respect to the tblEmp Size


------------------------------------------------------------------------------------------
/*6. When I executed this query:
           
   SELECT [vcName],[vcMobieNumer] FROM [dbo].[tblEmp] GROUP BY [vcName]
           
    I got following error message:
    Column 'dbo.tblEmp.vcMobieNumer' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.

    Can you explain above error message? Write at least two possible solutions. */

SELECT vcName,vcMobieNumer 
FROM tblEmp 
GROUP BY vcName,vcMobieNumer



------------------------------------------------------------------------------------------

-- 7. Write a sql query to get the ntLevel of the employees getting salary greater than average salary.
select vcName, ntLevel 
from tblEmp
where moSalary > (select AVG(moSalary) from tblEmp);
------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------

use AdventureWorks2014;

-------------------------------------------------------------------------------------------
-- 8. Write a query to get the count of employees with a valid Suffix 

select Count(Suffix) 
from Person.Person
where Suffix is Not NULL;

-------------------------------------------------------------------------------------------
-- 9. Using BusinessEntityAddress table (and other tables as required), list the full name of people living in the city of Frankfurt.
--select COALESCE(person.FirstName, person.MiddleName , person.LastName)
select person.FirstName +' '+ + ISNULL(person.MiddleName,'') +' ' + ISNULL(person.LastName,'')
from ((Person.BusinessEntityAddress as bea
Inner join Person.Address on Person.Address.AddressID = bea.AddressID and Person.Address.City = 'Frankfurt')
Inner Join Person.Person as person on person.BusinessEntityID = bea.BusinessEntityID);


-------------------------------------------------------------------------------------------
-- 10. "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.

select [SalesOrderID], [OrderQty], [ProductID]
from [Sales].[SalesOrderDetail]
where [SalesOrderID] In (
select SalesOrderID
from [Sales].[SalesOrderDetail]
group by SalesOrderID 
having Count(SalesOrderID) =1) and OrderQty =1;

-------------------------------------------------------------------------------------------
-- 11. Show the product description for culture 'fr' for product with ProductID 736.

select pd.Description
from Production.ProductDescription as pd
join Production.ProductModelProductDescriptionCulture as ppdc
on pd.ProductDescriptionID = ppdc.ProductDescriptionID
join Production.ProductModel as pm
on ppdc.ProductModelID = pm.ProductModelID
join Production.Product as p
on pm.ProductModelID = p.ProductModelID
where ppdc.CultureID = 'fr' and p.ProductID = '736';

-------------------------------------------------------------------------------------------
-- 12. Show OrderQty, the Name and the ListPrice of the order made by CustomerID 635

select sod.OrderQty , p.ListPrice ,p.Name
from Sales.SalesOrderDetail as sod
join Sales.SalesOrderHeader as soh
on sod.SalesOrderID = soh.SalesOrderID
join Production.Product as p
on p.ProductID = sod.ProductID
where CustomerID = 635;


-------------------------------------------------------------------------------------------
-- 13. How many products in ProductSubCategory 'Cranksets' have been sold to an address in 'London'?


select sum(orderDetails.OrderQty)
from Production.ProductSubcategory as subcategory
join Production.Product as product on subcategory.ProductSubcategoryID = product.ProductSubcategoryID
join Sales.SalesOrderDetail as orderDetails on product.ProductID = orderDetails.ProductID
join Sales.SalesOrderHeader as soh on orderDetails.SalesOrderID = soh.SalesOrderID
join Person.Address on soh.ShipToAddressID = Address.AddressID
where Address.City = 'London' AND subcategory.Name = 'Cranksets';

-------------------------------------------------------------------------------------------
-- 14. Describe Char, Varchar and NVarChar datatypes with examples. 




-------------------------------------------------------------------------------------------


