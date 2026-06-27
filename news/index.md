# Changelog

## boldR 0.1.0 (2026-06)

#### Initial scaffold

- Package skeleton:
  [`read_fmriprep()`](https://boldr.circadia-lab.uk/reference/read_fmriprep.md),
  [`prepare_bold()`](https://boldr.circadia-lab.uk/reference/prepare_bold.md),
  [`load_atlas()`](https://boldr.circadia-lab.uk/reference/load_atlas.md),
  [`list_atlases()`](https://boldr.circadia-lab.uk/reference/list_atlases.md),
  [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md),
  [`compute_tsnr()`](https://boldr.circadia-lab.uk/reference/compute_tsnr.md),
  [`compute_fc()`](https://boldr.circadia-lab.uk/reference/compute_fc.md),
  [`compute_roi_metrics()`](https://boldr.circadia-lab.uk/reference/compute_roi_metrics.md),
  [`export_bold()`](https://boldr.circadia-lab.uk/reference/export_bold.md).
- Atlas-agnostic design: extensible `boldR_atlas` S3 class with a schema
  that accepts bundled atlases (Schaefer-100, AAL-116) or custom NIfTI
  label maps conforming to the `boldR_atlas` structure.
- fMRIPrep BIDS derivatives as the canonical input standard.
- pkgdown site with Bootstrap 5 and Circadia Lab branding.
