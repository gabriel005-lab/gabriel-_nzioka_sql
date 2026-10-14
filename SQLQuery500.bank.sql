create table customers(
customer_id int primary key,
account_id int not null,
name varchar(50) not null,
gender varchar(50) not null,
city varchar(50) not null);

create table accounts(
customer_id int primary key,
account_id int not null,
account_type varchar(50) not null,
balance int not null);

create table transactions(
transactions_id int primary key,
account_id int not null,
transaction_date date,
transaction_type varchar(50) not null,
amount int not null);

insert into customers(customer_id,account_id ,name,gender,city)
values(001,000145,'Gregory','Male','Nairobi'),
      (002,000146,'Nicholas','Male','Mombasa'),
      (003,000147,'Patricia','Female','Nyeri'),
      (004,000148,'Mary','Female','Kisumu'),
      (005,000149,'Henry','Male','Mombasa'),
      (006,000150,'Caleb','Male','Nairobi'),
      (007,000151,'Fiona','Female','Kisumu'),
      (008,000152,'Dennis','Male','Nyeri'),
      (009,000153,'Winnie','Female','Nairobi'),
      (010,000154,'Mitchell','Female','Kisumu');


insert into accounts(customer_id,account_id,account_type,balance)
values(001,000145,'savings',100000),
      (002,000146,'salary',45000),
      (003,000147,'student',60000),
      (004,000148,'savings',85000),
      (005,000149,'joint',420000),
      (006,000150,'Business',800000),
      (007,000151,'savings',500000),
      (008,000152,'current',900000),
      (009,000153,'student',75000),
      (010,000154,'money market',430000);

insert into transactions(transactions_id,account_id,transaction_date,transaction_type,amount)
values(021,000145,'2026-08-07','Deposit',100000),
      (012,000146,'2026-08-08','Withdrawal',25000),
      (063,000147,'2026-08-09','Transfer',10000),
      (054,000148,'2026-08-10','Deposit',85000),
      (065,000149,'2026-09-11','Salary',420000),
      (076,000150,'2026-09-12','intrest',800000),
      (077,000151,'2026-09-13','mobile transfer',10000),
      (098,000152,'2026-09-14','Cheque deposit',200000),
      (089,000153,'2026-09-14','Bank fee',1000),
      (010,000154,'2026-10-5','salary',230000);
--Total deposits
select
transaction_type,
sum(amount) total_amount
from transactions
where transaction_type = 'deposit'
group by transaction_type

--Total withdrawals
select
transaction_type,
sum(amount) total_amount
from transactions
where transaction_type = 'Withdrawal'
group by transaction_type

--Net transaction value
select
transactions.account_id,
sum(case
        WHEN transactions.transaction_type IN ('Deposit', 'Salary', 'Cheque deposit', 'intrest') THEN accounts.balance
        WHEN transactions.transaction_type IN ('Withdrawal', 'Transfer', 'mobile transfer', 'Bank fee') THEN -accounts.balance
        ELSE 0 
    END) AS net_transaction_value
FROM transactions 
INNER JOIN accounts 
    ON transactions.account_id = accounts.account_id
GROUP BY transactions.account_id;


drop table if exists customers;
go

create table customers(
customer_id int primary key,
account_id int not null,
name varchar(50) not null,
gender varchar(50) not null,
city varchar(50) not null);

insert into customers(customer_id,account_id ,name,gender,city)
values(001,000145,'Gregory','Male','Nairobi'),
      (002,000146,'Nicholas','Male','Mombasa'),
      (003,000147,'Patricia','Female','Nyeri'),
      (004,000148,'Mary','Female','Kisumu'),
      (005,000149,'Henry','Male','Mombasa'),
      (006,000150,'Caleb','Male','Nairobi'),
      (007,000151,'Fiona','Female','Kisumu'),
      (008,000152,'Dennis','Male','Nyeri'),
      (009,000153,'Winnie','Female','Nairobi'),
      (010,000154,'Mitchell','Female','Kisumu');

--Transactions per customer
select
customers.name,
    COUNT(t.transactions_id) AS number_of_transactions
FROM customers 
JOIN accounts 
    ON customers.customer_id = accounts.customer_id
JOIN transactions t
    ON accounts.account_id = t.account_id
GROUP BY customers.name;
 
 drop table if exists customers;
go
create table transactions(
transactions_id int primary key,
account_id int not null,
transaction_date date,
transaction_type varchar(50) not null,
amount int not null);
  
insert into transactions(transactions_id,account_id,transaction_date,transaction_type,amount)
values(021,000145,'2026-08-07','Deposit',100000),
      (012,000146,'2026-08-08','Withdrawal',25000),
      (063,000147,'2026-08-09','Transfer',10000),
      (054,000148,'2026-08-10','Deposit',85000),
      (065,000149,'2026-09-11','Salary',420000),
      (076,000150,'2026-09-12','intrest',800000),
      (077,000151,'2026-09-13','mobile transfer',10000),
      (098,000152,'2026-09-14','Cheque deposit',200000),
      (089,000153,'2026-09-14','Bank fee',1000),
      (010,000154,'2026-10-5','salary',230000);

--Largest transaction
select
    customers.name,
    max(t.transactions_amount) largest_transaction
from customers
    join accounts a
      on customers.customers_id =a.cus_id
    join transactions t
      on a.account_id =t.account_id
     group by customers.name;

--Average transaction
select
avg(amount) as average_transaction
from transactions

--Monthly transactions
SELECT
    MONTH(transaction_date) AS month,
    COUNT(transactions_id) AS number_of_transactions
FROM transactions
GROUP BY MONTH(transaction_date)
ORDER BY month;

--Customers with withdrawals above KSh 50,000
select 
transactions_id,
transaction_type,
amount
from transactions
where transaction_type ='withdrawal'
and amount > 50000
order by amount desc;

--Deposit vs withdrawal percentage
select
transactions_id,
transaction_type,
amount,
ROUND((COUNT(CASE WHEN transaction_type = 'Withdrawal' THEN 1 END) OVER() * 100.0) / COUNT(*) OVER(), 2) AS withdrawal_total_percentage,
    
    -- Calculates percentage of total rows that are deposits
    ROUND((COUNT(CASE WHEN transaction_type = 'Deposit' THEN 1 END) OVER() * 100.0) / COUNT(*) OVER(), 2) AS deposit_total_percentage
FROM transactions
WHERE transaction_type IN ('Withdrawal', 'Deposit')

--Customers with no transactions
select
transactions_id,
transaction_type,
amount
from transactions
where transaction_type is null
group by transactions_id