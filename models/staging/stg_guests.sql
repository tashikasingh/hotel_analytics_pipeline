with source as (

    select * from {{ ref('raw_guests') }}

),

renamed as (

    select
        id as guest_id,
        first_name,
        last_name,
        email

    from source

)

select * from renamed
