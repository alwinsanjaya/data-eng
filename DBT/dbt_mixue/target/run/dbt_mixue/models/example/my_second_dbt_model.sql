
  create or replace   view mixue_sample_data.gold_data.my_second_dbt_model
  
   as (
    -- Use the `ref` function to select from other models

select *
from mixue_sample_data.gold_data.my_first_dbt_model
where id = 1
  );

