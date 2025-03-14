
  create or replace   view mixue_sample_data.silver_data.dim_buy_time_range
  
   as (
    select
	buy_time_id,
	buy_time_range
from
	bronze_data.dim_buy_time_range
  );

