with source as (

    select * from {{ ref('raw_payments') }}

),

renamed as (

    select
        id as payment_id,
        booking_id,
        payment_method,
        -- amounts are stored in the source as an integer of cents, convert to decimal currency
        amount / 100.0 as amount

    from source

)

select * from renamed
