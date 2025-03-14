
  create or replace   view mixue_sample_data.silver_data.dim_day_sales
  
   as (
    select
	dds.day_id,
	dds.day_name
from
	bronze_data.dim_day_sales dds
  );

