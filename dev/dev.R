## boldR development script
## Run interactively, never source() as a whole.

# ── Setup ──────────────────────────────────────────────────────────────────────
library(devtools)

# ── Load / check ───────────────────────────────────────────────────────────────
load_all()       # fast iterative reload
check()          # full R CMD CHECK
test()           # run testthat suite

# ── Documentation ──────────────────────────────────────────────────────────────
document()       # regenerate man/ and NAMESPACE via roxygen2

# ── pkgdown ────────────────────────────────────────────────────────────────────
pkgdown::build_site()
pkgdown::build_reference()
pkgdown::build_article("getting-started")

# ── Hex sticker ────────────────────────────────────────────────────────────────
# TODO: design hex sticker for boldR
# hexSticker::sticker(...)
# pkgdown::build_favicons()  # after logo.svg is in man/figures/

# ── Install ────────────────────────────────────────────────────────────────────
install()
