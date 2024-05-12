-- Set params
set session pg.number_of_clients = '100';
set session pg.number_of_payments = '1000';
set session pg.number_of_dishes = '100';
set session pg.number_of_category = '50';
set session pg.number_of_orders = '500';

set session pg.max_bonus_balance = '1000';
set session pg.max_min_payment = '100000';
set session pg.max_dish_price = '20000.0';
set session pg.max_dish_amount = '10';
set session pg.max_tips = '10000.0';

set session pg.start_date = '2024-05-01 00:00:00';
set session pg.end_date = '2024-06-01 00:00:00';

-- Filling of category
INSERT INTO public.category
SELECT  id, -- category_id
        concat('Category ', id), -- name
        random() * (current_setting('pg.max_bonus_balance')::float) + 1, -- percent
        floor(random() * (current_setting('pg.max_min_payment')::int) + 1)::varchar -- min_payment
FROM GENERATE_SERIES(1, current_setting('pg.number_of_category')::int) as id;

-- Filling of client
INSERT INTO public.client
SELECT  id, -- client_id
        floor(random() * (current_setting('pg.max_bonus_balance')::int) + 1)::int, -- bonus_balance
        floor(random() * (current_setting('pg.number_of_category')::int) + 1)::int -- category_id
FROM GENERATE_SERIES(1, current_setting('pg.number_of_clients')::int) as id;

-- Filling of dish
INSERT INTO public.dish
SELECT  id, -- dish_id
        concat('Dish ', id), -- name
        random() * (current_setting('pg.max_dish_price')::float) + 1 -- price
FROM GENERATE_SERIES(1, current_setting('pg.number_of_dishes')::int) as id;

-- Filling of payment
INSERT INTO public.payment
SELECT id, client_id, dish_id, dish_amount, order_id, order_time, dish_amount * dish_price, tips FROM(
    SELECT t1.price as dish_price, t2.* FROM dish as t1 LEFT JOIN 
        (SELECT
            id,
            floor(random() * (current_setting('pg.number_of_clients')::int) + 1)::int as client_id, -- client_id
            floor(random() * (current_setting('pg.number_of_dishes')::int) + 1) as dish_id, -- dish_id
            floor(random() * (current_setting('pg.max_dish_amount')::int) + 1) as dish_amount,
            floor(random() * (current_setting('pg.number_of_dishes')::int) + 1)::int as order_id,
            TO_TIMESTAMP(start_date, 'YYYY-MM-DD HH24:MI:SS') + 
                random()* (TO_TIMESTAMP(end_date, 'YYYY-MM-DD HH24:MI:SS') - TO_TIMESTAMP(start_date, 'YYYY-MM-DD HH24:MI:SS')) as order_time,
            floor(random() * (current_setting('pg.max_tips')::float) + 1)::float as tips
    FROM GENERATE_SERIES(1, current_setting('pg.number_of_payments')::int) as id,
                            current_setting('pg.start_date') as start_date,
                            current_setting('pg.end_date') as end_date) as t2 
    ON t2.dish_id=t1.dish_id
)

