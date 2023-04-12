use ex_2_copy;

-- Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
select sum(salary) as total_sum_in_seattle from EMPLOYEE
inner join departments
on EMPLOYEE.DEPARTMENT_ID=departments.department_id
inner join locations
on departments.location_id=locations.location_id where city='Seattle' and first_name!='Nancy';

-- 2.	 Fetch all details of employees who has salary more than the avg salary by each department.
select * from employees e1 where salary > (select avg(salary) from employees e2 where e1.department_id=e2.department_id) order by department_id;

-- where salary between 70000 and 100000;
-- 3.	Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
select first_name,city from employees inner join departments on employees.department_id = departments.department_id inner join locations on departments.location_id=locations.location_id where salary between 7000 and 10000;

-- 4.	Fetch max salary, min salary and avg salary by job and department. 
select department_id ,job_id, max(salary),min(salary),avg(salary) 
from employees 
group by department_id,job_id 
order by department_id,max(salary);

-- select * from countries inner join locations on countries.country_id=locations.country_id;
-- 5.	Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
select sum(salary) from countries c,locations l,employees e where c.country_id=l.country_id and c.country_id='US' and first_name!='Nancy' group by c.country_id;

-- 6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
select department_id,job_id, max(salary),min(salary),avg(salary) from employees
where job_id in (select job_id from job_history)
group by department_id,job_id order by department_id,max(salary) desc;

-- 7.	Display the employee count in each department and also in the same result.  
select department_id, count(*) as total from employees group by department_id;
-- 8.	Display the jobs held and the employee count. 
select employee_id ,job_id from employees union
SELECT employee_id ,job_id
FROM job_history;


--9. Display average salary by department and country
select employees.department_id,locations.country_id, avg(salary) from EMPLOYEES 
inner join 
departments on employees.department_id=departments.department_id 
inner join 
locations on departments.location_id=locations.location_id group by employees.department_id,locations.country_id order by employees.department_id ;

-- 10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select departments.manager_id,locations.country_id,count(*) from EMPLOYEES
inner join 
departments on employees.department_id=departments.department_id
inner join 
locations on locations.location_id=departments.location_id
group by departments.manager_id,locations.country_id ;
-- 11.	 Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000
select department_id,
  count(case when SALARY between 0 and 10000 then 1 end),
  count(case when SALARY between 10001 and 20000 then 1 end),
  count(case when SALARY between 20001 and 30000 then 1 end),
  count(case when SALARY > 30000 then 1 end)
from EMPLOYEES
group by department_id;

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
        
select employees.department_id,regions.region_name, count(countries.region_id) from EMPLOYEES
inner join 
departments on EMPLOYEES.DEPARTMENT_ID=departments.department_id
inner join 
locations on locations.location_id=departments.location_id
inner join
countries on countries.country_id=locations.country_id
inner join 
regions on regions.region_id=countries.region_id
group by employees.department_id, countries.region_id,regions.region_name;

-- 14.	 Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
select * from employees where department_id is null;
-- 15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
select employee_id,first_name,last_name, manager_id from employees;
-- 16.	write a SQL query to display the department name, city, and state province for each department.
select department_name , city ,state_province from departments  
inner join locations on departments.location_id = locations.location_id;
-- 17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
select first_name , last_name ,department_name  from employees
inner join
departments on employees.department_id =departments.department_id
where employees.department_id is not null;
-- 18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name
select employees.department_id ,departments.department_name, count(employees.department_id) as count_of_the_employees , avg(salary) from EMPLOYEES 
inner join departments on employees.department_id=departments.department_id
group by employees.department_id ,departments.department_name order by department_id;
-- 19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select * from employees 
cross join 
jobs;
-- Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select first_name , last_name , email,region_name from employees
inner join departments on employees.department_id =departments.department_id
inner join locations on locations.location_id = departments.location_id
inner join countries on countries.country_id = locations.country_id
inner join regions on regions.region_id =countries.region_id
where region_name in('Europe' , 'Asia');
-- Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select concat(first_name,' ',last_name) as full_name ,city ,department_name from EMPLOYEES
left join departments on employees.department_id=departments.department_id
left join locations on locations.location_id=departments.location_id
where city='Oxford'  and substr (full_name,-2,1) ='e';
-- 22.	 Display the first name and phone number of employees who have less than 50 months of experience
select first_name , phone_number ,hire_date , datediff(month,hire_date,current_date) from EMPLOYEES
where datediff(month,hire_date,current_date) > 50;
-- Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
select employee_id , first_name , last_name , hire_date , salary from employees where (extract(year from hire_date),salary) in(
select hire_year, max(salary)
    from (
        select extract(year from hire_date) as hire_year, salary
        from employees
    ) 
    group by hire_year)
    order by hire_date;