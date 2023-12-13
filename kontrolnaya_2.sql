

--1. Вывести названия компаний, содержащих в email цифры.
select name from provider_2xu px 
where email ~ '[\D]+[0-9]+[\D]+' or email ~ '[0-9]+[\D]+' or email ~ '[\D]+[0-9]+';


--2. Вывести названия компаний, имеющих транспортные средства грузоподъемностью как 30, так и 5.
select name from provider_2xu p
join vehicle_3ng v on v.provider_id = p.id
where v.load_capacity = 30
intersect
select name from provider_2xu p
join vehicle_3ng v on v.provider_id = p.id
where v.load_capacity = 5;


--3. Вывести названия компаний, имеющих транспортные средства грузоподъемностью не менее 15, но не более 20.
select distinct name from provider_2xu p
join vehicle_3ng v on v.provider_id = p.id
where v.load_capacity >= 15 and v.load_capacity <= 20;


--4. Для каждой компании, имеющих среднюю грузоподъемность транспортных средств не менее 15 и не более 20, вывести минимальную цену продуктов.
with new_table as (with name_avg_cap as (select name, avg(load_capacity) avg_capacity from provider_2xu p
join vehicle_3ng v on v.provider_id = p.id group by name)
select name from name_avg_cap
where avg_capacity >= 15 and avg_capacity <= 20),

second_table as (select name, min(price) min_price
from provider_2xu p
join provider_product_info_2tf pp on pp.provider_id = p.id group by name)

select name, min_price
from second_table 
where name in (select * from new_table);


--5. Для компании, имеющей максимальное суммарное количество продуктов, вывести суммарную грузоподъемность.
--Не дописала.
with sum_quantity as
(select sum(quantity) from provider_product_info_2tf),
max_sum_quantity as max(select * from sum_quantity)

select p.name from provider_2xu p
join provider_product_info_2tf pp on p.id = pp.provider_id
where (select * from sum_quantity) = (select * from max_sum_quantity);


--6. Вывести названия компаний, имеющих товаров на сумму не менее 120_000_000 или суммарную грузоподъемность не менее 70.
with new_table as (select name, sum(load_capacity) load_sum
from provider_2xu p
join  vehicle_3ng v on v.provider_id = p.id group by name),

name_price as (select name, sum(price * quantity) price_sum
from provider_2xu p
join provider_product_info_2tf pp on pp.provider_id = p.id group by name)

select name from name_price where price_sum >= 120000000
union
select name from new_table where load_sum >= 70;

