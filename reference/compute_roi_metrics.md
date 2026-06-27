# Compute summary metrics per ROI

Returns a tibble of per-ROI summary statistics from the parcellated
timeseries: mean signal, standard deviation, and temporal SNR.

## Usage

``` r
compute_roi_metrics(parcellated)
```

## Arguments

- parcellated:

  A `boldR_parcellated` object from
  [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md).

## Value

A tibble with columns `roi`, `mean`, `sd`, `tsnr`, `n_voxels`.

## Examples

``` r
if (FALSE) { # \dontrun{
parcel  <- parcellate(bold, atlas)
metrics <- compute_roi_metrics(parcel)
metrics
} # }
```
