
  
    

        create or replace transient table mixue_sample_data.silver_data.fact_total_order_outlet
         as
        (select
	EXTRACT(YEAR FROM TO_DATE(sales_date, 'DD/MM/YYYY')) AS year,
	EXTRACT(MONTH FROM TO_DATE(sales_date, 'DD/MM/YYYY')) AS MONTH,
	dds.day_name ,
	dbtr.buy_time_range ,
	do2.outlet_name ,
	dc.category_name ,
	dil.ice_level ,
	dsl.sugar_level ,
	dct.cup_type ,
	dp.product_name ,
	mo.price ,
	mo.quantity,
	SUM((mo.price * mo.quantity)) total_sales
from
	MIXUE_SAMPLE_DATA.BRONZE_DATA.MIXUE_ORDER mo
inner join 
	mixue_sample_data.silver_data.dim_buy_time_range  dbtr on
	dbtr.buy_time_id = mo.buy_time_id
inner join 
	mixue_sample_data.silver_data.dim_category  dc on
	dc.category_id = mo.category_id
inner join 
	mixue_sample_data.silver_data.dim_cup_type  dct on
	dct.cup_type_id = mo.cup_type_id
inner join
	mixue_sample_data.silver_data.dim_day_sales  dds on
	dds.day_id = mo.day_id
inner join 
	mixue_sample_data.silver_data.dim_ice_level  dil on
	dil.ice_level_id = mo.ice_level_id
inner join 
	mixue_sample_data.silver_data.dim_outlet  do2 on
	do2.outlet_id = mo.outlet_id
inner join 
	mixue_sample_data.silver_data.dim_products  dp on
	dp.product_id = mo.product_id
inner join
	mixue_sample_data.silver_data.dim_sugar_level  dsl on
	dsl.sugar_level_id = mo.sugar_level_id
group by 
	EXTRACT(YEAR FROM TO_DATE(sales_date, 'DD/MM/YYYY')) ,
	EXTRACT(MONTH FROM TO_DATE(sales_date, 'DD/MM/YYYY')),
	dds.day_id ,
	dds.day_name ,
	dbtr.buy_time_range ,
	do2.outlet_name ,
	dc.category_name ,
	dil.ice_level ,
	dsl.sugar_level ,
	dct.cup_type ,
	dp.product_name ,
	mo.price ,
	mo.quantity
order by 
	EXTRACT(YEAR FROM TO_DATE(sales_date, 'DD/MM/YYYY')) ,
	EXTRACT(MONTH FROM TO_DATE(sales_date, 'DD/MM/YYYY')),
	dds.day_id asc
        );
      
  