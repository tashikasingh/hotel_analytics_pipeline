with bookings as (

    select * from {{ ref('stg_bookings') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),

booking_payments as (

    select
        booking_id,
        sum(amount) as total_amount

    from payments
    group by booking_id

),

final as (

    select
        bookings.booking_id,
        bookings.guest_id,
        bookings.booking_date,
        bookings.status,
        coalesce(booking_payments.total_amount, 0) as amount

    from bookings
    left join booking_payments on bookings.booking_id = booking_payments.booking_id

)

select * from final
