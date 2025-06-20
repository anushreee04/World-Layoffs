DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;






CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

#SELECT statement
select * 
from parks_and_recreation. employee_demographics;

select first_name
from parks_and_recreation. employee_demographics;

select first_name, 
last_name, 
birth_date,
age
from parks_and_recreation. employee_demographics;

#PEMDAS
select first_name, 
age,
(age+10)*10+10
from parks_and_recreation. employee_demographics;

#DISTINCT
select distinct gender
from parks_and_recreation. employee_demographics;

#WHERE clause
select *
from employee_salary
where first_name="leslie"
;

select *
from employee_salary
where salary <=50000
;

select *
from employee_demographics
where birth_date > '1985-01-01'
;

#logical operators under where clause- AND/OR/NOT

select *
from employee_demographics
where birth_date > '1985-01-01' or not gender='male'
;

select *
from employee_demographics
where (first_name='leslie' and age=44) or age>55
;

#LIKE statement- % and _
# % sign means anything can follow as long as 'jer' is met
select *
from employee_demographics
where first_name like 'jer%'
;

# % before after means anything can come befoe or after 'a' is present 
select *
from employee_demographics
where first_name like "%a%"
;

#a__ 2 undersocre means starts with a and has 2 characters after alter 'a'
select *
from employee_demographics
where first_name like "a__"
;

#a__% a and then atleast 2 charachters or more 
select *
from employee_demographics
where first_name like "a__%"
;

#GROUP BY
select gender
from employee_demographics
group by gender
;

#grouping by aggregate function
select gender, avg(age)
from employee_demographics
group by gender
;

select occupation
from employee_salary
group by occupation 
;

select occupation, salary
from employee_salary
group by occupation, salary
#salary of both office managers are different hence two different rows
;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender
;

#ORDER BY (ascending by default)
select *
from employee_demographics
order by first_name desc
;

select *
from employee_demographics
order by gender, age
# age then gender doesn't make sense order is important 
;

select *
from employee_demographics
order by 5, 4
#column number
;

#HAVING and WHERE
select gender, avg(age)
from employee_demographics
where avg(age)>40
# shows error because grp by function has not been executed hence where function does not hold
group by gender
;

select gender, avg(age)
from employee_demographics
group by gender
having avg(age)>40
;

select occupation, avg(salary)
from employee_salary
where occupation like "%manager%"  #filter at roe level
group by occupation
having avg(salary)>75000  #filter at aggregate function level
;

#LIMIT and ALIASING
select *
from employee_demographics
order by age desc #top 3 oldest people in table 
limit 3
;

#ALIASING
select gender, avg(age) as avg_age
from employee_demographics
group by gender
having avg_age> 40
;

#JOINS
select *
from employee_demographics
;

select *
from employee_salary
;

#INNER JOINS- returns all columns for same employee id- here we're missing id=2 because it's not on employee salary table
select dem.employee_id, age, occupation
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id=sal.employee_id
;

select dem.employee_id, age, occupation
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id=sal.employee_id
;

#OUTTER JOINS- left and right join 
select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id=sal.employee_id
;

#SELF JOIN-- secret santa suppose id 1 gets id 2 as secret santa
select sal1.employee_id as santa,
sal1.first_name as first_name_santa,
sal1.last_name as last_name_santa,
sal2.employee_id as gift_to,
sal2.first_name as first_name_gift,
sal1.last_name as last_name_gift
from employee_salary sal1
join employee_salary sal2
	on sal1.employee_id +1 =sal2.employee_id
;

#JOINING MULTIPLE TABLE
select *
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id=sal.employee_id
inner join parks_departments as pd
	on sal.dept_id=pd.department_id
 ;

#UNIONS- distinct by default/ all
select first_name, last_name
from employee_demographics
union 
select first_name, last_name
from employee_salary
;

select first_name, last_name
from employee_demographics
union 
select first_name, last_name
from employee_salary
;

select first_name, last_name, "old" as label
from employee_demographics
where age>40 and gender='male'
union 
select first_name, last_name, "old" as label
from employee_demographics
where age>40 and gender='female'
union 
select first_name, last_name, "high pay" as label
from employee_salary
where salary>70000
order by first_name, last_name
;

#STRING FUNCTIONS

#LENGTH (uses- data cleaning phone number etc)
select length('skyfall');

select first_name, length (first_name)
from employee_demographics
order by 2
;

#UPPER(use- solves standardization issue)
select upper('sky');
select upper('sky');

select first_name, last_name, upper (first_name), upper (last_name)
from employee_demographics;

#TRIM, LEFT TRIM LTRIM, RIGHT TRIM RTRIM
select trim('  sky  ');

select first_name,   #how many character from the left have to be selected 
left(first_name,4),
right(first_name, 4)
from employee_demographics;

#SUBSTRING (shows only part of string that we want)
select first_name,  
left(first_name,4),
right(first_name, 4),
substring(first_name, 3, 2)  # 3=which position to start at, 2=how many character
birth_date,
substring(birth_date, 6, 2) as birth_month
from employee_demographics;

#REPLACE replaces specific characters just like find and replace in excel
select first_name, replace(first_name, 'a', 'z')
from employee_demographics;

#LOCATE
select locate('x','alexander');

select first_name, locate ('An', first_name)
from employee_demographics;

#CONCAT
select first_name, last_name,
concat (first_name, ' ', last_name)
from employee_demographics;

#CASE STATEMENT
select first_name, last_name, age,
case
	when age<=30 then 'young'
    when age between 31 and 50 then 'old'
end as age_bracket
from employee_demographics;

#PAY INCREASE AND BONUS
	#<50000= 5%
    #>50000= 7%
    #Finance= 10% bonus
    
select first_name, last_name, salary,
case
	when salary<50000 then salary*(1.05)
    when salary>50000 then salary*(1.07)
end as new_salary,
case
	when dept_id=6 then salary*1.1
end as bonus
from employee_salary;

#SUBQUERIES
select *
from employee_demographics
where employee_id in (select employee_id
						from employee_salary
                        where dept_id=1)
;

select first_name, salary,
(select avg(salary)
from employee_salary)
from employee_salary;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender;

select avg(max_age)
from 
(select gender, 
avg(age) as avf_age, 
max(age) as max_age, 
min(age) as min_age, 
count(age) as count_age
from employee_demographics
group by gender) as aggregated_table
;

#WINDOW FUNCTION
select dem.first_name, gender, avg(salary) as avg_salary
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id
group by dem.first_name, gender;

select dem.first_name, gender, avg(salary) over (partition by gender) #independent
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;

select dem.first_name, gender, 
sum(salary) over (partition by gender) #independent
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;

#ROLLINGTOTAL
select dem.first_name, gender, salary,
sum(salary) over (partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;

#ROW NUMBER/ RANK/ DENSE RANK 
select dem.employee_id, dem.first_name, gender, salary,
row_number() over(partition by gender order by salary desc), #row number has no duplicates
rank() over(partition by gender order by salary desc) as rank_num, #rank gives repeated rank looks for duplicate based on order by # next number positional number
dense_rank() over(partition by gender order by salary desc) as dense_rank_num #rank gives repeated rank looks for duplicate based on order by #next number is numeric number
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id;

##ADVANCED
#CTE-- COMMON TABE EXPRESSION (key word WITH)
#one time tables
with CTE_example as
(
select gender, 
avg(salary) avg_sal, 
max(salary) max_sal, 
min(salary) min_sal, 
count(salary) count_sal
from employee_demographics dem
join employee_salary sal
	on dem.employee_id=sal.employee_id
group by gender
)
#CTE can only be used immediately after
select *
from CTE_example;

with CTE_example as
(
select gender,  employee_id, birth_date
from employee_demographics 
where birth_date>'1985-01-01'
),
CTE_example2 as
(select employee_id, salary
from employee_salary
where salary>50000
)
#CTE can only be used immediately after
select*
from CTE_example
join CTE_example2
	on	CTE_example.employee_id=CTE_example2.employee_id
;

#TEMPORARY TABLES
#RUN ONLY UNTIL THE SESSION IS WORKING (TILL YOU DON'T CLOSE SQL)
#FIRST WAY
create temporary table temp_table
(
first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(100)
);

insert into temp_table
values ('Anushree', 'Choudhury', 'Me Before You');

select *
from temp_table;

#SECOND WAY

select *
from employee_salary;
create temporary table salary_over_50k
select *
from employee_salary
where salary>=50000;

select *
from salary_over_50k;

#STORED PROCESDURES
create procedure large_sal()
select *
from employee_salary
where salary>=50000;

call large_sal();

#delimiter ; essentially mean one code is finished
#CHANGE DELIMiTER
delimiter $$
create procedure large_sal2()
begin 
	select *
	from employee_salary
	where salary>=50000;
	select *
	from employee_salary
	where salary>=10000;
end $$
delimiter ;

call large_sal2()

#PARAMETER variables that allow to accept input value into code
delimiter $$
create procedure large_sal3(employee_id_param int)
begin 
	select salary
	from employee_salary
	where employee_id=employee_id_param
    ;
end $$
delimiter ;
 
call large_sal3(1);

#TRIGGERS AND EVENTS
#block of code tha executes automatically for a specific table
#automatically update second table if first table is updated
select *
from employee_demographics;

select *
from employee_salary;

drop trigger if exists employee_insert;

delimiter $$
create trigger employee_insert
	after insert on employee_salary #(can be before as well but rn it's after inserting)
    for each row  #for each new row that is inserted
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values ( 13, 'Anushree', 'Choudhury', 'Data Analytics 720 Associate', 65000, null);

#EVENTS-- scheduled automator 
#create event check every month and if above 50 they retire
select *
from employee_demographics;

delimiter $$
create event delete_retirees
on schedule every 6 month
do
begin
	delete
    from employee_demographics
    where age>=60;
end $$
delimiter ;

select *
from employee_demographics;

show variables like 'event%';
