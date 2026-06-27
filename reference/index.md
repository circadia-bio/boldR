# Package index

## Ingestion

Read and validate fMRIPrep BIDS derivatives.

- [`read_fmriprep()`](https://boldr.circadia-lab.uk/reference/read_fmriprep.md)
  : Read fMRIPrep BIDS derivatives for a participant
- [`prepare_bold()`](https://boldr.circadia-lab.uk/reference/prepare_bold.md)
  : Validate and prepare a fMRIPrep object for analysis

## Atlases

Atlas-agnostic parcellation schema, built-in atlases, and custom
registration.

- [`load_atlas()`](https://boldr.circadia-lab.uk/reference/load_atlas.md)
  : Load a parcellation atlas
- [`list_atlases()`](https://boldr.circadia-lab.uk/reference/list_atlases.md)
  : List available built-in atlases
- [`register_atlas()`](https://boldr.circadia-lab.uk/reference/register_atlas.md)
  : Register a custom brain atlas

## Parcellation

Extract ROI-level timeseries from volumetric BOLD data.

- [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md)
  : Extract ROI-level timeseries from a BOLD image

## Voxelwise metrics

Metrics computed at the voxel level.

- [`compute_tsnr()`](https://boldr.circadia-lab.uk/reference/compute_tsnr.md)
  : Compute voxelwise temporal SNR

## ROI metrics

Metrics computed at the ROI/parcellation level.

- [`compute_fc()`](https://boldr.circadia-lab.uk/reference/compute_fc.md)
  : Compute functional connectivity from parcellated BOLD timeseries
- [`compute_roi_metrics()`](https://boldr.circadia-lab.uk/reference/compute_roi_metrics.md)
  : Compute summary metrics per ROI

## Export

Export analysis-ready outputs for syncR.

- [`export_bold()`](https://boldr.circadia-lab.uk/reference/export_bold.md)
  : Export parcellated BOLD data for syncR

## Data

Bundled datasets and palettes.

- [`palette_bold`](https://boldr.circadia-lab.uk/reference/palette_bold.md)
  : boldR colour palette

## Package

Package-level documentation.

- [`boldR`](https://boldr.circadia-lab.uk/reference/boldR-package.md)
  [`boldR-package`](https://boldr.circadia-lab.uk/reference/boldR-package.md)
  : boldR: fMRI BOLD Signal Analysis for Circadian and Sleep Research
