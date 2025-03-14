
  create or replace   view mixue_sample_data.silver_data.dim_products
  
   as (
    select
	dp.product_id,
	dp.product_name
from
	bronze_data.dim_products dp
  );

