with guests as (

    select * from {{ ref('stg_guests') }}

),

bookings as (

    select * from {{ ref('fact_bookings') }}

),

guest_bookings as (

    select
        guest_id,
        min(booking_date) as first_booking_date,
        max(booking_date) as most_recent_booking_date,
        count(booking_id) as number_of_bookings,
        sum(amount) as lifetime_value

    from bookings
    where status not in ('cancelled')
    group by guest_id

),

final as (

    select
        guests.guest_id,
        guests.first_name,
        guests.last_name,
        guests.email,
        guest_bookings.first_booking_date,
        guest_bookings.most_recent_booking_date,
        coalesce(guest_bookings.number_of_bookings, 0) as number_of_bookings,
        coalesce(guest_bookings.lifetime_value, 0) as lifetime_value,

        -- simple value-based segmentation, based on booking value and frequency only
        -- (deliberately general - not a substitute for hotel revenue-management metrics
        -- like RevPAR or ADR, which this model does not attempt to calculate)
        case
            when coalesce(guest_bookings.lifetime_value, 0) >= 40 then 'high_value'
            when coalesce(guest_bookings.lifetime_value, 0) >= 20 then 'medium_value'
            when coalesce(guest_bookings.lifetime_value, 0) > 0 then 'low_value'
            else 'no_booking'
        end as value_segment

    from guests
    left join guest_bookings on guests.guest_id = guest_bookings.guest_id

)

select * from final
