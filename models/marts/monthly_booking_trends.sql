with bookings as (

    select * from {{ ref('fact_bookings') }}

),

monthly as (

    select
        date_trunc('month', booking_date) as booking_month,
        count(booking_id) as total_bookings,
        sum(case when status = 'cancelled' then 1 else 0 end) as cancelled_bookings,
        sum(amount) as total_revenue,
        round(avg(amount), 2) as avg_booking_value

    from bookings
    group by 1

)

select * from monthly
order by booking_month