
  create or replace   view mixue_sample_data.silver_data.dim_category
  
   as (
    select * from bronze_data.dim_category
  );

