
  create or replace   view mixue_sample_data.silver_data.dim_sugar_level
  
   as (
    select
	dsl.sugar_level_id,
	dsl.sugar_level
from
	bronze_data.dim_sugar_level dsl
  );

