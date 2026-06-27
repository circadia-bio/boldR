# Read fMRIPrep BIDS derivatives for a participant

Reads preprocessed fMRI outputs from an [fMRIPrep](https://fmriprep.org)
BIDS derivatives directory for a single participant and session,
returning a structured `boldR_fmriprep` object containing paths to the
BOLD, T1w, T2w, and segmentation files.

## Usage

``` r
read_fmriprep(
  derivatives_dir,
  subject,
  session = NULL,
  task = NULL,
  space = "MNI152NLin2009cAsym",
  resolution = NULL
)
```

## Arguments

- derivatives_dir:

  Character. Path to the fMRIPrep derivatives root (e.g.
  `"sub-01/func/"`... or the top-level `derivatives/fmriprep/`).

- subject:

  Character. Subject label without the `sub-` prefix (e.g. `"01"`).

- session:

  Character or `NULL`. Session label without the `ses-` prefix. If
  `NULL` (default), assumes a single-session dataset.

- task:

  Character or `NULL`. Task label (e.g. `"rest"`). If `NULL`, the first
  task found is used.

- space:

  Character. Template space for the BOLD and mask files. Default
  `"MNI152NLin2009cAsym"`.

- resolution:

  Character or `NULL`. Resolution label (e.g. `"2"`). If `NULL`,
  resolution is not filtered.

## Value

A list of class `boldR_fmriprep` with components:

- bold:

  Character. Path to the BOLD NIfTI file.

- bold_mask:

  Character. Path to the brain mask NIfTI file.

- t1w:

  Character. Path to the T1w NIfTI file in template space.

- t2w:

  Character or `NA`. Path to the T2w NIfTI file if available.

- dseg:

  Character. Path to the discrete segmentation NIfTI file.

- confounds:

  Character. Path to the confounds TSV file.

- subject:

  Character. Subject label.

- session:

  Character or `NA`. Session label.

- task:

  Character. Task label.

- space:

  Character. Template space.

- derivatives_dir:

  Character. Resolved path to the derivatives root.

## Examples

``` r
if (FALSE) { # \dontrun{
fprep <- read_fmriprep(
  derivatives_dir = "data/derivatives/fmriprep",
  subject         = "01",
  task            = "rest"
)
fprep
} # }
```
