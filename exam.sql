-- 1. Вывести названия продуктов (без повторений) из бронзы или гранита и ценой от 3_000 до 7_000
select distinct name 
from goods_11u gu 
join vendor_goods_info_god vgig on gu.id = vgig.goods_id 
where price > 3000 
and price < 7000 
and (material = 'Bronze' or material = 'Granite');


-- 2. Вывести названия компаний, содержащие в названии цифры.
select distinct name 
from vendor_7tn vt 
where name ~ '[0-9]';


-- 3. Вывести названия компаний (без повторений), поставляющие компьютеры, но не клавиатуры.
select distinct vt.name 
from vendor_goods_info_god vgig join vendor_7tn vt on vt.id = vgig.vendor_id 
join goods_11u gu on gu.id = vgig.goods_id
where gu.name = 'Computer' and gu.name != 'Keyboard';


-- 4. Вывести названия компаний (без повторений), поставляющие как машины, так и мотоциклы.
select distinct vt.name
from vendor_goods_info_god vgig join vendor_7tn vt on vt.id = vgig.vendor_id 
join goods_11u gu on gu.id = vgig.goods_id
where gu.name = 'Car'
intersect
select distinct vt.name
from vendor_goods_info_god vgig join vendor_7tn vt on vt.id = vgig.vendor_id 
join goods_11u gu on gu.id = vgig.goods_id
where gu.name = 'Bike';


-- 5. Для компании, имеющей максимальную суммарную грузоподъемность, вывести минимальную цену продуктов.
select vt.name, min(vgig.price) 
from vendor_7tn vt
join vendor_goods_info_god vgig on vt.id = vgig.vendor_id 
join automobile_g23 ag on vt.id = ag.vendor_id 
group by vt.name 
having sum(ag.load_capacity) = (select max(sum_load_capacity) FROM 
                               (select vendor_id, sum(load_capacity) as sum_load_capacity 
                                from automobile_g23 
                                group by vendor_id) as sum_load_capacity);


-- 6. Для каждой компании, имеющей суммарную грузоподъемность транспортых средств более 100, вывести количество продуктов компании.
select vt.name, count(distinct g.name) 
from vendor_7tn vt 
join vendor_goods_info_god vgig  on vt.id = vgig.vendor_id  
join goods_11u g on vgig.goods_id = g.id 
join automobile_g23 ag on vt.id = ag.vendor_id  
group by vt.name 
having sum(ag.load_capacity) > 100;


-- 7. Вывести названия компаний, имеющих товаров на сумму не менее 1_000_000_000 или не менее 10 единиц транспорта.
select vt.name 
from vendor_7tn vt 
join vendor_goods_info_god vgig  ON vt.id = vgig.vendor_id  
join goods_11u g ON vgig.goods_id = g.id 
group by vt.name 
having sum(vgig.price) >= 1000000000 
or (select count(distinct vendor_id) from automobile_g23) >= 10;
