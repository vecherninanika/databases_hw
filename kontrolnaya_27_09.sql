
/*
1. Для каждого производителя вывести траспортные средства, имеющие топ-2 различные вместимости. Вывод - название производителя, номер ТС, вместимость.
2. Для каждого материала вывести топ-3 производителей, с наибольшим количеством продуктов из этого материала. Вывод - материал, название производителя, суммарное количество продуктов.
3. Для каждого материала вывести топ-3 производителей, с наименьшей суммарной стоимостью продуктов из этого материала. Вывод - материал, название производителя, суммарная стоимость продуктов.
4. Учитывая, что шаг вместимости ТС равен 5, вывести названия производителей, имеющих ТС с тремя идущими подряд вместимостями, например 5 10 15, 10 15 20 и т.д.

Для зачтения контрольной нужно решить все задачи. Решения без оконных функций не принимаются.
*/

drop table if exists provider_0i6, goods_yVo, provider_goods_info_Emd, automobile_df5 cascade;

create table provider_0i6
(
    id      uuid primary key,
    name    text,
    address text,
    phone   text,
    email   text
);

create table goods_yVo
(
    id       uuid primary key,
    name     text,
    material text
);

create table provider_goods_info_Emd
(
    goods_id  uuid references goods_yVo,
    provider_id uuid references provider_0i6,
    primary key (goods_id, provider_id),
    price       numeric,
    quantity    integer
);

create table automobile_df5
(
    id                uuid primary key,
    registration_mark text,
    load_capacity     integer,
    provider_id uuid references provider_0i6
);


insert into provider_0i6 values
('02dbf745-e6cc-49db-8102-74340dd7db7a', 'Bernhard Group', '787 Torphy Shoal', '(204) 610-9868 x12485', 'Katarina_Deckow89@yahoo.com');

--provider_0i6, goods_yVo, provider_goods_info_Emd, automobile_df5

--1. Для каждого производителя вывести траспортные средства, имеющие топ-2 различные вместимости. Вывод - название производителя, номер ТС, вместимость.
with temp as (
select p.name name,
a.registration_mark reg_mark, 
a.load_capacity load_capacity,
row_number() over (partition by p.name order by load_capacity desc) as row_n
from provider_0i6 p
join automobile_df5 a on p.id = a.provider_id
)

select name, reg_mark, load_capacity, row_n
from temp
where row_n <= 2;


--2. Для каждого материала вывести топ-3 производителей, с наибольшим количеством продуктов из этого материала. Вывод - материал, название производителя, 
--суммарное количество продуктов.
with temp as (
SELECT sum(pg.quantity) summ,
g.material material,
p.name provider,
dense_rank() over (partition by g.material order by sum(pg.quantity) desc) as dense_r
from goods_yVo g
join provider_goods_info_Emd pg on g.id = pg.goods_id 
join provider_0i6 p on p.id = pg.provider_id 
group by p.name, g.material
)

select material, provider, summ
from temp
where dense_r <= 3;

--3. Для каждого материала вывести топ-3 производителей, с наименьшей суммарной стоимостью продуктов из этого материала. Вывод - материал, название производителя, 
--суммарная стоимость продуктов.
with temp as (
SELECT sum(pg.price) summ,
g.material material,
p.name provider,
dense_rank() over (partition by g.material order by sum(pg.price)) as dense_r
from goods_yVo g
join provider_goods_info_Emd pg on g.id = pg.goods_id 
join provider_0i6 p on p.id = pg.provider_id 
group by p.name, g.material
)

select material, provider, summ
from temp
where dense_r <= 3;


--4. Учитывая, что шаг вместимости ТС равен 5, вывести названия производителей, имеющих ТС с тремя идущими подряд вместимостями, например 5 10 15, 10 15 20 и т.д.
with temp as (
select name,
load_capacity,
lead(load_capacity) over (partition by p.name order by load_capacity) as leadd,
lag(load_capacity) over (partition by p.name order by load_capacity) as lagg
from provider_0i6 p
join automobile_df5 a on p.id = a.provider_id
)

select name, load_capacity
from temp
where load_capacity = leadd + 5 and load_capacity = lagg - 5 or load_capacity = leadd - 5 and load_capacity = lagg + 5;





