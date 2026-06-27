# Compute functional connectivity from parcellated BOLD timeseries

Estimates a ROI-to-ROI functional connectivity matrix from a parcellated
BOLD timeseries using Pearson correlation (default) or partial
correlation. Returns both the full symmetric matrix and a tidy
long-format data frame.

## Usage

``` r
compute_fc(parcellated, method = c("pearson", "partial"), fisher_z = TRUE)
```

## Arguments

- parcellated:

  A `boldr_parcellated` object from
  [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md).

- method:

  Character. Connectivity metric. One of:

  `"pearson"`

  :   (Default) Pearson product-moment correlation.

  `"partial"`

  :   Partial correlation (requires `corpcor` in Suggests).

- fisher_z:

  Logical. Whether to apply Fisher r-to-z transformation before
  returning values. Default `TRUE`. Diagonal is set to `NA`.

## Value

A list of class `boldr_fc` with components:

- matrix:

  Numeric matrix (n_rois × n_rois). Symmetric FC matrix with `NA` on the
  diagonal.

- long:

  Data frame (long format). Columns: `roi_i`, `roi_j`, `roi_name_i`,
  `roi_name_j`, `fc`.

- method:

  Character. Connectivity method used.

- fisher_z:

  Logical. Whether Fisher z was applied.

- atlas_name:

  Character. Atlas identifier.

## Examples

``` r
if (FALSE) { # \dontrun{
parc <- parcellate(cleaned, atlas)
fc   <- compute_fc(parc)
dim(fc$matrix)
head(fc$long)
} # }
```
