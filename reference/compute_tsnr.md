# Compute voxelwise temporal SNR

Calculates temporal signal-to-noise ratio (tSNR) for every in-mask voxel
in a cleaned BOLD image. tSNR is defined as the ratio of the mean signal
to its temporal standard deviation across the timeseries. It is a
standard quality metric for fMRI acquisitions and preprocessing
pipelines.

Calculates temporal signal-to-noise ratio (tSNR) for each voxel in the
BOLD image: mean signal divided by standard deviation across timepoints.
A standard quality metric for assessing fMRI data quality after
preprocessing.

## Usage

``` r
compute_tsnr(bold)

compute_tsnr(bold)
```

## Arguments

- bold:

  A `boldR_bold` object from
  [`prepare_bold()`](https://boldr.circadia-lab.uk/reference/prepare_bold.md).

## Value

A list of class `boldr_tsnr` with components:

- tsnr:

  3D numeric array (same x × y × z as input). Contains tSNR values for
  in-mask voxels and `NA` elsewhere.

- mean_tsnr:

  Numeric. Mean tSNR across in-mask voxels.

- median_tsnr:

  Numeric. Median tSNR across in-mask voxels.

- n_voxels:

  Integer. Number of in-mask voxels.

A list of class `boldR_tsnr` with components:

- tsnr:

  Numeric array. tSNR map with same x/y/z dimensions as BOLD.

- mean_tsnr:

  Numeric. Mean tSNR across in-mask voxels.

- median_tsnr:

  Numeric. Median tSNR across in-mask voxels.

- bold:

  The input `boldR_bold` object.

## Examples

``` r
if (FALSE) { # \dontrun{
sub      <- read_fmriprep("data/derivatives/fmriprep", "01", task = "rest")
cleaned  <- prepare_bold(sub)
tsnr_out <- compute_tsnr(cleaned)
tsnr_out$mean_tsnr
} # }
if (FALSE) { # \dontrun{
fprep <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
bold  <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
tsnr  <- compute_tsnr(bold)
tsnr$mean_tsnr
} # }
```
