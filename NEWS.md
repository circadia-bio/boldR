# boldR 0.1.0  (2026-06)

### Initial scaffold

* Package skeleton: `read_fmriprep()`, `prepare_bold()`, `load_atlas()`,
  `list_atlases()`, `parcellate()`, `compute_tsnr()`, `compute_fc()`,
  `compute_roi_metrics()`, `export_bold()`.
* Atlas-agnostic design: extensible `boldR_atlas` S3 class with a schema
  that accepts bundled atlases (Schaefer-100, AAL-116) or custom NIfTI
  label maps conforming to the `boldR_atlas` structure.
* fMRIPrep BIDS derivatives as the canonical input standard.
* pkgdown site with Bootstrap 5 and Circadia Lab branding.
