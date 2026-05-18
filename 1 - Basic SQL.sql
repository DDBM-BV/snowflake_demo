-- Set up context for worksheet
use role sysadmin;
use warehouse compute_wh;

-- Create database and schema
create database if not exists demo;
create schema if not exists demo.basic;

-- Create tables
create or replace table demo.basic.departments (
    department_id int primary key,
    department_name varchar(100),
    location varchar(200),
    manager_name varchar(100)
);

create table demo.basic.people (
    user_id int primary key,
    username varchar(100),
    email varchar(200),
    created_at timestamp,
    department_id int
);

-- Fill tables with data
insert into demo.basic.departments (department_id, department_name, location, manager_name) values
    (1, 'Engineering', 'San Francisco', 'Alice Johnson'),
    (2, 'Marketing', 'New York', 'Bob Smith'),
    (3, 'Finance', 'Chicago', 'Carol Davis');

insert into demo.basic.people (user_id, username, email, created_at, department_id) values
    (1, 'jdoe', 'jdoe@example.com', '2025-01-15 09:00:00', 1),
    (2, 'asmith', 'asmith@example.com', '2025-02-10 10:30:00', 1),
    (3, 'mjones', 'mjones@example.com', '2025-03-05 14:00:00', 2),
    (4, 'kwilson', 'kwilson@example.com', '2025-04-20 08:45:00', 2),
    (5, 'lbrown', 'lbrown@example.com', '2025-05-12 11:15:00', 3),
    (6, 'tgarcia', 'tgarcia@example.com', '2025-06-01 16:00:00', 1),
    (7, 'nlee', 'nlee@example.com', '2025-07-18 09:30:00', 3),
    (8, 'rmartin', 'rmartin@example.com', '2025-08-25 13:00:00', 2),
    (9, 'pclark', 'pclark@example.com', '2025-09-10 10:00:00', 1),
    (10, 'dwright', 'dwright@example.com', '2025-10-03 15:30:00', 3);


-- Query: all people
select * from people;

-- Query: count people per department
select 
    departments.department_name,
    departments.location,
    count(people.username) as people_count
from people
left join departments 
    on people.department_id = departments.department_id
group by 
    departments.department_name, 
    departments.location;


drop schema if exists demo.basic;