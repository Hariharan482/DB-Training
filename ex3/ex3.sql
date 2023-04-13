use ex_2_copy;

select * from locations;
-- Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
select sum(salary) as total_sum_in_seattle from EMPLOYEE
inner join departments
on EMPLOYEE.DEPARTMENT_ID=departments.department_id
inner join locations
on departments.location_id=locations.location_id where city='Venice' and first_name!='Nancy';

-- 2.	 Fetch all details of employees who has salary more than the avg salary by each department.
SELECT *  FROM employees e1
JOIN (SELECT avg(salary) as avg_salary,department_id FROM employees GROUP BY department_id) e2
ON e1.department_id=e2.department_id 
WHERE e1.salary > e2.avg_salary
ORDER BY e1.department_id;

-- where salary between 70000 and 100000;
-- 3.	Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
select first_name,city,salary from employees inner join departments on employees.department_id = departments.department_id inner join locations on departments.location_id=locations.location_id where salary between 7000 and 10000;

-- 4.	Fetch max salary, min salary and avg salary by job and department. 
select department_id ,job_id, max(salary),min(salary),avg(salary) 
from employees 
group by department_id,job_id 
order by department_id,max(salary);

-- select * from countries inner join locations on countries.country_id=locations.country_id;
-- 5.	Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
select sum(salary) from countries c,locations l,employees e where c.country_id=l.country_id and c.country_id='US' and first_name!='Nancy' group by c.country_id;

-- 6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
select department_id,job_id, max(salary),min(salary),avg(salary),count(employee_id) from employees
where job_id in (select job_id from job_history)
group by department_id,job_id order by department_id,max(salary) desc;

-- 7.	Display the employee count in each department and also in the same result.  
SELECT coalesce(cast(department_id as string),'-') as department_id, count(employee_id) as employee_count
FROM employees GROUP BY department_id
UNION SELECT 'Total',count(employee_id) FROM employees
ORDER BY department_id;
-- 8.	Display the jobs held and the employee count. 
SELECT jobs_held, count(s1.employee_id) as employee_count FROM
(SELECT t1.employee_id,count(t1.employee_id) as jobs_held FROM employee t1
LEFT OUTER JOIN job_history  t2 
ON t1.employee_id=t2.employee_id 
GROUP BY t1.employee_id) s1
GROUP BY s1.jobs_held;


--9. Display average salary by department and country
select employees.department_id,locations.country_id, avg(salary) from EMPLOYEES 
inner join 
departments on employees.department_id=departments.department_id 
inner join 
locations on departments.location_id=locations.location_id group by employees.department_id,locations.country_id order by employees.department_id ;

-- 10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
SELECT concat(e2.first_name,' ',e2.last_name) as manager,count(e1.manager_id) as employees_reporting,c.country_name
FROM employees e1 
JOIN employees e2 ON e1.manager_id=e2.employee_id
JOIN departments d ON d.department_id=e1.department_id
JOIN locations l ON l.location_id=d.location_id
JOIN countries c ON c.country_id=l.country_id
GROUP BY e1.manager_id,e2.first_name,e2.last_name,c.country_name;
-- 11.	 Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000

SELECT department_id,
count(case when salary >= 0 and salary <= 10000 then 1 end) as "0-10000",
count(case when salary > 10000 and salary <= 20000 then 1 end) as "10000-20000",
count(case when salary > 20000 and salary <= 30000 then 1 end) as "20000-30000",
count(case when salary > 30000 then 1 end ) AS "Above 30000"
FROM employee
GROUP BY department_id;

-- 12.	 Display employee count by country and the avg salary 
select count(*) as Emp_count,countries.country_name,avg(salary) as average_salary from EMPLOYEES
left join 
departments on departments.department_id=employees.department_id 
left join 
locations on locations.location_id=departments.location_id
left join 
countries on locations.country_id=countries.country_id
 where country_name is not null group by countries.country_name;
-- 13.	 Display region and the number off employees by department
        
SELECT e.department_id,
coalesce(nullif(cast(count(case when region_name = 'Europe' then 1 end) as string),'0'),'-') as europe,
coalesce(nullif(cast(count(case when region_name = 'Americas' then 1 end) as string),'0'),'-') as "Americas",
coalesce(nullif(cast(count(case when region_name = 'Asia' then 1 end) as string),'0'),'-') as "Asia",
coalesce(nullif(cast(count(case when region_name = 'Middle East and Africa' then 1 end ) as string),'0'),'-') AS "Middle East and Africa"
FROM employee e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id
GROUP BY e.department_id HAVING count(e.employee_id)>0
ORDER BY e.department_id ;

-- 14.	 Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
SELECT employee_id,iff(count(department_id)=0, 'Not yet joined','Working in one or more department')
FROM employees 
GROUP BY employee_id,department_id;
-- 15.write a SQL query to find the employees and their respective managers.
-- Return the first name, last name of the employees and their managers
SELECT e1.first_name,e1.last_name, concat(e2.first_name,' ',e2.last_name) as manager_name
FROM employee e1 
LEFT OUTER JOIN employee e2 on e1.manager_id = e2.employee_id;

-- 16.write a SQL query to display the department name, city, and state province for each department.
SELECT d.department_name,l.city,l.state_province FROM departments d
JOIN locations l on d.location_id = l.location_id;

-- 17.write a SQL query to list the employees (first_name , last_name, department_name) 
-- who belong to a department or don't
SELECT first_name,last_name,department_name,
iff(e.department_id IS NULL, 'Does not belong to a department','Belongs to a department') as department_status
FROM employees e LEFT OUTER JOIN departments d ON e.department_id=d.department_id; 

-- 18.The HR decides to make an analysis of the employees working in every department.
-- Help him to determine the salary given in average per department 
-- and the total number of employees working in a department.
-- List the above along with the department id, department name
SELECT e.department_id,d.department_name,e.employee_count,e.average_salary FROM (
SELECT department_id,avg(salary) as average_salary,count(*) as employee_count
FROM employee GROUP BY department_id) e
JOIN departments d ON d.department_id = e.department_id;

-- 19.Write a SQL query to combine each row of the employees 
-- with each row of the jobs to obtain a consolidated results.
-- (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT * FROM employee JOIN jobs;

-- 20.Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
SELECT e.first_name,e.last_name,e.email,region_name FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id
WHERE region_name in ('Europe','Asia');

-- 21.Write a query to display full name with alias as FULL_NAME 
-- (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry")
-- who are from oxford city and their second last character of their last name is 'e'
-- and are not from finance and shipping department.
SELECT concat(e.first_name,' ',e.last_name) as full_name FROM employee e
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id 
WHERE l.city = 'Oxford' AND substr(e.last_name, -2, 1) = 'e' AND d.department_name NOT IN ('Shipping','Finance');

-- 22.Display the first name and phone number of employees who have less than 50 months of experience
SELECT employee_id,sum(datediff('month',start_date,end_date)) as experience FROM job_history
GROUP BY employee_id HAVING experience < 50;

-- 23.Display Employee id, first_name, last name, hire_date and salary for employees
-- who has the highest salary for each hiring year.(For eg: John and Deepika joined on year 2023,
-- and john has a salary of 5000, and Deepika has a salary of 6500.
-- Output should show Deepika’s details only).
SELECT employee_id, first_name, last_name, hire_date, salary
FROM (SELECT *, year(hire_date) as join_year,
row_number() OVER (PARTITION BY join_year ORDER BY salary DESC) as rn
FROM employees)
WHERE rn=1 ORDER BY join_year;