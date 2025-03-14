
  
    

        create or replace transient table mixue_sample_data.gold_data.mart_order_per_outlet
         as
        (select fo.year, fo.month, fo.outlet_id, do.outlet_name, sum(fo.total_quantity) total_quantity,  sum(fo.total_sales) total_sales 
from mixue_sample_data.silver_data.fact_total_order_outlet fo 
inner join 
    mixue_sample_data.silver_data.dim_outlet do ON do.OUTLET_ID = fo.outlet_id
group by fo.year, fo.month, fo.outlet_id, do.outlet_name
        );
      
  