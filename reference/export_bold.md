# Export parcellated BOLD data for syncR

Packages the output of
[`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md)
into a `boldR_export` object suitable for ingestion by `syncR::sync()`.
The export includes the ROI timeseries matrix, functional connectivity
matrix (if computed), ROI metrics, and participant metadata.

## Usage

``` r
export_bold(parcellated, fc = NULL, roi_metrics = NULL, participant_id = NULL)
```

## Arguments

- parcellated:

  A `boldR_parcellated` object from
  [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md).

- fc:

  A `boldR_fc` object from
  [`compute_fc()`](https://boldr.circadia-lab.uk/reference/compute_fc.md),
  or `NULL` (default).

- roi_metrics:

  A tibble from
  [`compute_roi_metrics()`](https://boldr.circadia-lab.uk/reference/compute_roi_metrics.md),
  or `NULL` (default). If `NULL`, metrics are computed automatically.

- participant_id:

  Character or `NULL`. Override the subject label for use in `syncR`. If
  `NULL`, taken from the `boldR_bold` object.

## Value

A list of class `boldR_export` ready for `syncR::sync()`.

## Examples

``` r
if (FALSE) { # \dontrun{
parcel <- parcellate(bold, atlas)
fc     <- compute_fc(parcel)
exp    <- export_bold(parcel, fc = fc)

# Pass to syncR
syncR::sync(..., bold = exp)
} # }
```
