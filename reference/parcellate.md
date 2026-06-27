# Extract ROI-level timeseries from a BOLD image

Applies a parcellation atlas to a preprocessed BOLD image, returning
mean timeseries per ROI. Works with any `boldR_atlas` object – built-in
or custom – as long as the atlas is in the same template space as the
BOLD.

## Usage

``` r
parcellate(bold, atlas, summary_fn = mean, min_voxels = 10L)
```

## Arguments

- bold:

  A `boldR_bold` object from
  [`prepare_bold()`](https://boldr.circadia-lab.uk/reference/prepare_bold.md).

- atlas:

  A `boldR_atlas` object from
  [`load_atlas()`](https://boldr.circadia-lab.uk/reference/load_atlas.md).

- summary_fn:

  Function. Applied across voxels within each ROI at each timepoint.
  Default `mean`. Common alternatives: `median`.

- min_voxels:

  Integer. Minimum number of in-mask voxels an ROI must contain to be
  included in the output. ROIs below this threshold are returned with
  `NA` timeseries and a warning. Default `10L`.

## Value

A list of class `boldR_parcellated` with components:

- timeseries:

  Numeric matrix, timepoints x ROIs. Column names are ROI labels from
  the atlas.

- roi_voxel_counts:

  Integer vector. Number of in-mask voxels per ROI.

- atlas:

  The `boldR_atlas` object used.

- bold:

  The `boldR_bold` object used.

- n_rois:

  Integer. Number of ROIs in output.

- n_timepoints:

  Integer. Number of timepoints.

## Examples

``` r
if (FALSE) { # \dontrun{
fprep  <- read_fmriprep("data/derivatives/fmriprep", subject = "01")
bold   <- prepare_bold(fprep, tr = 2, drop_volumes = 4)
atlas  <- load_atlas("schaefer100_7n")
parcel <- parcellate(bold, atlas)
dim(parcel$timeseries)  # timepoints x 100
} # }
```
