with source as (
        select * from {{ source('thelook_ecommerce', 'distribution_centers') }}
  ),
  renamed as (
      select
          {{ adapter.quote("id") }},
        {{ adapter.quote("name") }},
        {{ adapter.quote("latitude") }},
        {{ adapter.quote("longitude") }},
        {{ adapter.quote("distribution_center_geom") }}

      from source
  )
  select * from renamed
    