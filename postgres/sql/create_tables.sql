-- Creation of category table
CREATE TABLE IF NOT EXISTS public.logs (
  id SERIAL NOT NULL,
  table_name TEXT NOT NULL,
  operation_time TIMESTAMP DEFAULT now() NOT NULL,
  operation_type VARCHAR(10) NOT NULL,
  operation_values jsonb NOT NULL,
  PRIMARY KEY (id)
);

-- Creation of category table
CREATE TABLE IF NOT EXISTS public.category (
  category_id SERIAL NOT NULL,
  name VARCHAR(250) NOT NULL,
  percent FLOAT NOT NULL,
  min_payment VARCHAR(250) NOT NULL,
  PRIMARY KEY (category_id)
);

-- Creation of dish table
CREATE TABLE IF NOT EXISTS public.dish (
  dish_id SERIAL NOT NULL,
  name VARCHAR(250),
  price FLOAT NOT NULL,
  PRIMARY KEY (dish_id)
);

-- Creation of client table
CREATE TABLE IF NOT EXISTS public.client (
  client_id SERIAL NOT NULL,
  bonus_balance DECIMAL(20,3) NOT NULL,
  category_id SERIAL NOT NULL,
  CONSTRAINT fk_category
    FOREIGN KEY(category_id)
    REFERENCES category(category_id),
  PRIMARY KEY (client_id)
);

-- Creation of payment table
CREATE TABLE IF NOT EXISTS public.payment (
  payment_id SERIAL NOT NULL,
  client_id SERIAL NOT NULL,
  dish_id SERIAL NOT NULL,
  dish_amount INT NOT NULL,
  order_id SERIAL NOT NULL,
  order_time TIMESTAMP NOT NULL,
  order_sum DECIMAL(20,3) NOT NULL,
  tips DECIMAL(20,3) NOT NULL,
  CONSTRAINT fk_client
    FOREIGN KEY(client_id)
    REFERENCES client(client_id),
  CONSTRAINT fk_dish
    FOREIGN KEY(dish_id) 
    REFERENCES dish(dish_id),
  PRIMARY KEY (payment_id)
);

CREATE OR REPLACE FUNCTION trigger() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.logs(table_name, operation_type, operation_values) 
  VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_trigger
  BEFORE INSERT OR UPDATE OR DELETE 
ON public.payment 
  FOR EACH ROW 
  EXECUTE FUNCTION trigger();

CREATE TRIGGER log_trigger
  BEFORE INSERT OR UPDATE OR DELETE 
ON public.client 
  FOR EACH ROW 
  EXECUTE FUNCTION trigger();

CREATE TRIGGER log_trigger
  BEFORE INSERT OR UPDATE OR DELETE 
ON public.category 
  FOR EACH ROW 
  EXECUTE FUNCTION trigger();

CREATE TRIGGER log_trigger
  BEFORE INSERT OR UPDATE OR DELETE 
ON public.dish 
  FOR EACH ROW 
  EXECUTE FUNCTION trigger();

CREATE SCHEMA IF NOT EXISTS staging AUTHORIZATION postgres;