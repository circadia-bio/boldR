# boldR: fMRI BOLD Signal Analysis for Circadian and Sleep Research

`boldR` analyses Blood-Oxygen-Level-Dependent (BOLD) fMRI data in the
context of sleep and circadian research. It picks up exactly where
[fMRIPrep](https://fmriprep.org) leaves off — working directly with
preprocessed BIDS derivatives — and transforms them into analysis-ready
outputs: atlas-agnostic parcellation, ROI-level timeseries, functional
connectivity matrices, and voxelwise quality metrics.

**fmriprep gets you clean data. boldR gets you useful data.**

### Core workflow

    fmriprep → read_fmriprep() → prepare_bold()
                                      ↓
                                load_atlas() + parcellate()
                                      ↓
                        compute_fc() / compute_roi_metrics()
                                      ↓
                                export_bold() → syncR

### Ecosystem

`boldR` is part of the Circadia Lab R ecosystem at Northumbria
University. See <https://circadia-lab.uk> for the full package suite.

## See also

Useful links:

- <https://boldr.circadia-lab.uk>

- <https://github.com/circadia-bio/boldR>

- Report bugs at <https://github.com/circadia-bio/boldR/issues>

## Author

**Maintainer**: Lucas França <lucas.franca@northumbria.ac.uk>
([ORCID](https://orcid.org/0000-0003-0853-1319))

Authors:

- Lucas França <lucas.franca@northumbria.ac.uk>
  ([ORCID](https://orcid.org/0000-0003-0853-1319))

- Mario Leocadio-Miguel <mario.miguel@northumbria.ac.uk>
  ([ORCID](https://orcid.org/0000-0002-7248-3529))
