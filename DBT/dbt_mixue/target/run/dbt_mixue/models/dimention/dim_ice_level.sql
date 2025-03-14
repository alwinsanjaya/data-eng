
  create or replace   view mixue_sample_data.silver_data.dim_ice_level
  
   as (
    select
	dil.ice_level_id,
	dil.ice_level
from
	bronze_data.dim_ice_level dil
  );

