select fo.year, fo.month, fo.outlet_id, do.outlet_name, sum(fo.total_quantity) total_quantity,  sum(fo.total_sales) total_sales 
from {{ref ('fact_total_order_outlet') }} fo 
inner join 
    {{ref ('dim_outlet') }} do ON do.OUTLET_ID = fo.outlet_id
group by fo.year, fo.month, fo.outlet_id, do.outlet_name
