-- public.dim_buy_time_range definition

-- Drop table

-- DROP TABLE public.dim_buy_time_range;

CREATE TABLE public.dim_buy_time_range (
	buy_time_id int4 NULL,
	buy_time_range varchar(50) NULL
);


-- public.dim_category definition

-- Drop table

-- DROP TABLE public.dim_category;

CREATE TABLE public.dim_category (
	category_id int4 NULL,
	category_name varchar(50) NULL
);


-- public.dim_cup_type definition

-- Drop table

-- DROP TABLE public.dim_cup_type;

CREATE TABLE public.dim_cup_type (
	cup_type_id int4 NULL,
	cup_type varchar(50) NULL
);


-- public.dim_day_sales definition

-- Drop table

-- DROP TABLE public.dim_day_sales;

CREATE TABLE public.dim_day_sales (
	day_id int4 NULL,
	day_name varchar(50) NULL
);


-- public.dim_ice_level definition

-- Drop table

-- DROP TABLE public.dim_ice_level;

CREATE TABLE public.dim_ice_level (
	ice_level_id int4 NULL,
	ice_level varchar(50) NULL
);


-- public.dim_outlet definition

-- Drop table

-- DROP TABLE public.dim_outlet;

CREATE TABLE public.dim_outlet (
	outlet_id int4 NULL,
	outlet_name varchar(50) NULL
);


-- public.dim_products definition

-- Drop table

-- DROP TABLE public.dim_products;

CREATE TABLE public.dim_products (
	product_id int4 NULL,
	product_name varchar(50) NULL
);


-- public.dim_sugar_level definition

-- Drop table

-- DROP TABLE public.dim_sugar_level;

CREATE TABLE public.dim_sugar_level (
	sugar_level_id int4 NULL,
	sugar_level varchar(50) NULL
);


-- public.mixue_order definition

-- Drop table

-- DROP TABLE public.mixue_order;

CREATE TABLE public.mixue_order (
	sales_date varchar(50) NULL,
	day_id int4 NULL,
	buy_time_id int4 NULL,
	outlet_id int4 NULL,
	category_id int4 NULL,
	ice_level_id int4 NULL,
	sugar_level_id int4 NULL,
	cup_type_id int4 NULL,
	product_id int4 NULL,
	price int4 NULL,
	quantity int4 NULL,
	total_sales int4 NULL
);