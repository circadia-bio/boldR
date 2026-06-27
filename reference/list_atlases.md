# List available built-in atlases

Returns a data frame describing the atlases bundled with `boldR`. Custom
atlases can be loaded via
[`load_atlas()`](https://boldr.circadia-lab.uk/reference/load_atlas.md).

## Usage

``` r
list_atlases()
```

## Value

A tibble with columns `name`, `n_rois`, `space`, and `description`.

## Examples

``` r
list_atlases()
#> # A tibble: 4 × 4
#>   name           n_rois space               description                         
#>   <chr>           <dbl> <chr>               <chr>                               
#> 1 schaefer100_7n    100 MNI152NLin2009cAsym Schaefer 2018, 100 parcels, 7 netwo…
#> 2 schaefer200_7n    200 MNI152NLin2009cAsym Schaefer 2018, 200 parcels, 7 netwo…
#> 3 aal116            116 MNI152NLin6Asym     AAL 116 regions (Tzourio-Mazoyer 20…
#> 4 destrieux148      148 MNI152NLin2009cAsym Destrieux 2010, 148 cortical parcels
```
