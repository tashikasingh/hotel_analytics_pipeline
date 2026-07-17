with source as (

    select * from {{ ref('raw_bookings') }}

),

renamed as (

    select
        id as booking_id,
        guest_id,
        booking_date,
        status

    from source

)

select * from renamed
