# Validate and prepare a fMRIPrep object for analysis

Checks file existence, reads NIfTI headers to confirm dimensionality and
TR, and returns an annotated `boldR_bold` object ready for downstream
analysis functions.

## Usage

``` r
prepare_bold(fmriprep, tr = NULL, drop_volumes = 0L)
```

## Arguments

- fmriprep:

  A `boldR_fmriprep` object from
  [`read_fmriprep()`](https://boldr.circadia-lab.uk/reference/read_fmriprep.md).

- tr:

  Numeric or `NULL`. Repetition time in seconds. If `NULL` (default),
  extracted from the BOLD NIfTI header.

- drop_volumes:

  Integer. Number of initial volumes to discard (dummy scans). Default
  `0`.

## Value

A list of class `boldR_bold` with components:

- fmriprep:

  The input `boldR_fmriprep` object.

- dims:

  Integer vector. BOLD array dimensions `[x, y, z, t]`.

- tr:

  Numeric. Repetition time in seconds.

- n_voxels:

  Integer. Total in-mask voxels.

- n_timepoints:

  Integer. Number of volumes after dummy-scan removal.

- drop_volumes:

  Integer. Volumes dropped.

## Examples

``` r
if (FALSE) { # \dontrun{
fprep <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
bold  <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
bold
} # }
```
