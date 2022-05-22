USE `pharmacy`;

-- 1. Добавить внешние ключи.
ALTER TABLE `dealer`
    ADD CONSTRAINT `dealer_company_id_company_fk` FOREIGN KEY (`id_company`) REFERENCES `company` (`id_company`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `production`
    ADD CONSTRAINT `production_company_id_company_fk` FOREIGN KEY (`id_company`) REFERENCES `company` (`id_company`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `production`
    ADD CONSTRAINT `production_medicine_id_medicine_fk` FOREIGN KEY (`id_medicine`) REFERENCES `medicine` (`id_medicine`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `order`
    ADD CONSTRAINT `order_production_id_production_fk` FOREIGN KEY (`id_production`) REFERENCES `production` (`id_production`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `order`
    ADD CONSTRAINT `order_dealer_id_dealer_fk` FOREIGN KEY (`id_dealer`) REFERENCES `dealer` (`id_dealer`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `order`
    ADD CONSTRAINT `order_pharmacy_id_pharmacy_fk` FOREIGN KEY (`id_pharmacy`) REFERENCES `pharmacy` (`id_pharmacy`) ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с
-- указанием названий аптек, дат, объема заказов.

SELECT `order`.id_order, pharmacy.name, `order`.date, `order`.quantity FROM `order`
JOIN pharmacy ON `order`.id_pharmacy = pharmacy.id_pharmacy
JOIN production ON `order`.id_production = production.id_production
JOIN company ON production.id_company = company.id_company
JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус';

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы
-- до 25 января.
EXPLAIN format=json
SELECT * FROM medicine
JOIN production on medicine.id_medicine = production.id_medicine
JOIN company  on company.id_company = production.id_company
WHERE company.name = 'Фарма' AND medicine.id_medicine NOT IN
(
    SELECT DISTINCT medicine.id_medicine FROM `order`
    JOIN production ON `order`.id_production = production.id_production
    JOIN company  on company.id_company = production.id_company
    JOIN medicine ON production.id_medicine = medicine.id_medicine
    WHERE company.name = 'Фарма' AND `order`.date <= '2019-01-25'
);

EXPLAIN format = json
SELECT T.name FROM (SELECT medicine.name, MIN(`order`.date) as min_order_date FROM medicine
  LEFT JOIN production ON medicine.id_medicine = production.id_medicine
  LEFT JOIN company ON company.id_company = production.id_company
  LEFT JOIN `order` ON `order`.id_production = production.id_production
  WHERE company.name = 'Фарма'
  GROUP BY medicine.name) as T
WHERE T.min_order_date >= '2019-01-25';

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
-- оформила не менее 120 заказов.
EXPLAIN format=json
SELECT company.id_company, company.name, count(*) AS orders_count, MAX(production.rating) AS max, MIN(production.rating) AS min FROM `order`
JOIN production ON `order`.id_production = production.id_production
JOIN company ON company.id_company = production.id_company
GROUP BY company.id_company
HAVING orders_count >= 120;

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
-- Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT dealer.name, pharmacy.name FROM `dealer`
JOIN company ON company.id_company = dealer.id_company
LEFT JOIN `order` on `order`.id_dealer = dealer.id_dealer
LEFT JOIN pharmacy on `order`.id_pharmacy = pharmacy.id_pharmacy
WHERE company.name = 'AstraZeneca';

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
-- длительность лечения не более 7 дней.

UPDATE production , (
    SELECT id_production FROM production
    JOIN medicine on production.id_medicine = medicine.id_medicine
    WHERE cure_duration <= 7 AND production.price > 3000
) as T
SET production.price = 0.8 * production.price
WHERE production.id_production = T.id_production;


UPDATE production , (
    SELECT id_production FROM production
    JOIN medicine on production.id_medicine = medicine.id_medicine
    WHERE cure_duration <= 7 AND production.price > 3000
) as T
SET production.price = production.price / 0.8
WHERE production.id_production = T.id_production;

SELECT id_production, price from production;

-- 7. Добавить необходимые индексы.
CREATE INDEX dealer_id_company_index
    ON dealer (id_company ASC);

CREATE INDEX production_id_company_index_2
    ON production (id_company ASC);

CREATE INDEX production_id_medicine_index
    ON production (id_medicine ASC);

CREATE INDEX order_id_production_index
    ON `order` (id_production ASC);

CREATE INDEX order_id_dealer_index
    ON `order` (id_dealer ASC);

CREATE INDEX order_id_pharmacy_index
    ON `order` (id_pharmacy ASC);

