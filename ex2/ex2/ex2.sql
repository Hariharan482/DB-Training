use ex_2_copy;
select * from employees where first_name like '%even';
delete from employees where first_name like '%even';

select * from employees order by salary limit 3;

create table employee as select * from employees;
truncate table employees;
select * from employee;   

-- alter table tablename drop Age

select concat(first_name,' ',last_name) as fullname,email,year(hire_date) from employee where year(hire_date)<2000;

select employee_id,job_id from employee where year(hire_date) between 1990 and 1999;

select employee_id,email,charindex('A',email) from employee;

select employee_id,concat(first_name,' ',last_name) as full_name,email from employee where length(full_name)<12;

select employee_id,concat(first_name,'-',last_name,'-',email) as UNQ_ID from employee;

alter table employee modify email varchar(30);

-- select * from countries;
-- update employee set 

select first_name,email,left(phone_number,7) as phone , split_part(phone_number,'.',-1) as extension from employee;

select * from employee order by salary desc limit 2 offset 1;
select * from employee order by salary desc offset 1 fetch first 2 rows only;

select * from employee where department_id in (60,50) order by salary desc limit 3 ;
-- select * from departments;

-- select employee_id,job_id from employee union select job_id,job_title from jobs ;
select employee.employee_id , jobs.job_title from employee,jobs where employee.job_id=jobs.job_id 
union
select employee.employee_id,job_history.job_id from employee,job_history where employee.employee_id=job_history.employee_id 
order by employee_id;

-- select first_name,DATENAME(WEEKDAY,hire_date) from employee;
select first_name, concat(dayname(HIRE_DATE),',',monthname(HIRE_DATE),' ',day(HIRE_DATE),',',year(HIRE_DATE)) as Date_Joined from employee;


alter session set autocommit=false;

insert into jobs values('DT_ENGG','Data Engineer',12000,30000);
commit;
update jobs set max_salary=40000 where job_id='DT_ENGG';
select * from jobs;
rollback;
select * from jobs;

alter session set autocommit=true;

select round(avg(salary),3) as avg_salary from employee where hire_date between '1999-01-08' and '2000-01-01';


select region_name from regions union all select 'Australia' union all select 'Antartica' union all select 'Europe';
select region_name from regions union  select 'Australia' union select 'Antartica' union select 'Europe';

drop table employee;