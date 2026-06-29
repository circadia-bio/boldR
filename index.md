# 🧠 boldR

> **fmriprep gets you clean data. boldR gets you useful data.**

------------------------------------------------------------------------

> ⚠️ **boldR is in early development and has not been formally tested.**
> The API may change without notice, estimation results have not yet
> been validated against a reference implementation, and the package has
> not undergone peer review. Use with caution and verify outputs
> independently before using in any research context.

------------------------------------------------------------------------

`boldR` is an R package for analysing Blood-Oxygen-Level-Dependent
(BOLD) fMRI data in the context of sleep and circadian research. It
picks up exactly where [fMRIPrep](https://fmriprep.org) leaves off —
working directly with preprocessed BIDS derivatives — and transforms
them into analysis-ready outputs.

`boldR` is part of the [Circadia Lab](https://circadia-lab.uk) R
ecosystem at Northumbria University.

------------------------------------------------------------------------

## Key features

- **fMRIPrep as the input standard** — reads preprocessed BIDS
  derivatives directly; no custom preprocessing required.
- **Atlas-agnostic parcellation** — built-in support for common atlases
  (Schaefer, AAL); custom atlases accepted via a simple `boldR_atlas`
  schema.
- **Voxelwise metrics** — temporal SNR, voxelwise GLM contrasts.
- **ROI-level outputs** — timeseries extraction, functional connectivity
  matrices, summary metrics per ROI.
- **syncR-ready export** — parcellated BOLD data flows directly into
  `syncR::sync()` alongside actigraphy, PSG, and questionnaire data.

------------------------------------------------------------------------

## Installation

``` r

# Install from GitHub (development version)
# install.packages("pak")
pak::pak("circadia-bio/boldR")
```

------------------------------------------------------------------------

## Ecosystem

    fmriprep → boldR ──────────────────→ syncR
                     └─→ (parcellated)

`boldR` is designed to be used alongside:

| Package | Role |
|----|----|
| [`zeitR`](https://zeitr.circadia-lab.uk) | Actigraphy & circadian metrics |
| [`mrpheus`](https://mrpheus.circadia-lab.uk) | PSG signal analysis |
| [`hypnor`](https://hypnor.circadia-lab.uk) | Hypnogram handling & sleep architecture |
| [`slumbR`](https://github.com/circadia-bio/slumbR) | Sleep diary processing |
| [`syncR`](https://github.com/circadia-bio/syncR) | Unified participant database |

------------------------------------------------------------------------

## Authors

- [Lucas França](https://orcid.org/0000-0003-0853-1319) — Circadia Lab,
  Northumbria University
- [Mario Leocadio-Miguel](https://orcid.org/0000-0002-7248-3529) —
  Circadia Lab, Northumbria University

------------------------------------------------------------------------

## License

MIT © 2026 Lucas França, Mario Leocadio-Miguel
