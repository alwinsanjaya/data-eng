
  create or replace   view mixue_sample_data.silver_data.dim_cup_type
  
   as (
    select
	dct.cup_type_id,
	dct.cup_type
from
	bronze_data.dim_cup_type dct
  );

