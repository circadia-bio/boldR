# Register a custom brain atlas

Validates and registers a NIfTI label map and optional metadata table as
a `boldR_atlas` object. The schema is intentionally minimal: any
parcellation that provides a 3D integer label image and a label-to-name
mapping can be registered and passed to
[`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md).
Bundled atlas helpers (Schaefer, AAL, Glasser) use this same interface.

## Usage

``` r
register_atlas(
  labels_img,
  metadata,
  name = "custom",
  space = "MNI152NLin2009cAsym"
)
```

## Arguments

- labels_img:

  A `niftiImage` (3D integer) or a file path to a NIfTI label map.
  Voxels containing `0` are treated as background.

- metadata:

  A data frame with at minimum two columns:

  `label`

  :   Integer. The integer value in `labels_img`.

  `name`

  :   Character. Human-readable ROI name.

  Additional columns (hemisphere, network, x/y/z centroid, colour, etc.)
  are stored and carried through to output.

- name:

  Character. A short identifier for this atlas (e.g. `"Schaefer200"`,
  `"AAL3"`, `"custom"`).

- space:

  Character. The standard space this atlas is defined in. Default
  `"MNI152NLin2009cAsym"`. Must match the space used in
  [`read_fmriprep()`](https://boldr.circadia-lab.uk/reference/read_fmriprep.md)
  /
  [`parcellate()`](https://boldr.circadia-lab.uk/reference/parcellate.md).

## Value

A list of class `boldR_atlas` with components:

- labels_img:

  `niftiImage`. The 3D integer label map.

- metadata:

  Data frame. ROI metadata.

- name:

  Character. Atlas identifier.

- space:

  Character. Standard space.

- n_rois:

  Integer. Number of unique non-zero labels.

## Examples

``` r
if (FALSE) { # \dontrun{
atlas <- register_atlas(
  labels_img = "atlases/Schaefer2018_200Parcels_7Networks_MNI.nii.gz",
  metadata   = read.csv("atlases/Schaefer2018_200Parcels_labels.csv"),
  name       = "Schaefer200",
  space      = "MNI152NLin2009cAsym"
)
atlas
} # }
```
