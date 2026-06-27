# Load a parcellation atlas

Loads a `boldR_atlas` object either from the bundled atlas library or
from a custom NIfTI label map. The `boldR_atlas` schema is the extension
point for user-defined parcellations.

## Usage

``` r
load_atlas(atlas, labels = NULL, space = NULL)
```

## Arguments

- atlas:

  Character. Name of a built-in atlas (see
  [`list_atlases()`](https://boldr.circadia-lab.uk/reference/list_atlases.md))
  or a path to a custom NIfTI label image.

- labels:

  Character vector or `NULL`. ROI labels, one per integer value in the
  atlas image (excluding 0). If `NULL` and `atlas` is a built-in, labels
  are loaded automatically. Required for custom NIfTI inputs.

- space:

  Character or `NULL`. Template space of the atlas. Inferred for
  built-ins; should be specified for custom inputs.

## Value

A list of class `boldR_atlas` with components:

- name:

  Character. Atlas name or file path.

- nifti_path:

  Character. Path to the atlas NIfTI label image.

- labels:

  Character vector. ROI label for each integer index.

- indices:

  Integer vector. Non-zero integer values in the atlas.

- n_rois:

  Integer. Number of ROIs.

- space:

  Character. Template space.

## Examples

``` r
if (FALSE) { # \dontrun{
atlas <- load_atlas("schaefer100_7n")
atlas

# Custom atlas
atlas <- load_atlas(
  atlas  = "my_parcellation.nii.gz",
  labels = paste0("ROI_", 1:80),
  space  = "MNI152NLin2009cAsym"
)
} # }
```
