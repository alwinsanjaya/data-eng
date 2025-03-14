
  create or replace   view mixue_sample_data.silver_data.dim_outlet
  
   as (
    select
	do2.outlet_id,
	do2.outlet_name
from
	bronze_data.dim_outlet do2
  );

