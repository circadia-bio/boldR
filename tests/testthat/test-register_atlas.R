test_that("register_atlas validates required metadata columns", {
  skip_if_not_installed("RNifti")

  # Minimal 3D integer NIfTI array
  labels_arr <- array(c(rep(0L, 8), rep(1L, 4), rep(2L, 4)), dim = c(4, 4, 4))
  img <- RNifti::asNifti(labels_arr)

  meta_good <- data.frame(label = c(1L, 2L), name = c("ROI_A", "ROI_B"))
  expect_no_error(register_atlas(img, meta_good, name = "test_atlas"))

  meta_bad <- data.frame(id = c(1L, 2L), roi = c("ROI_A", "ROI_B"))
  expect_error(register_atlas(img, meta_bad), regexp = "missing required column")
})

test_that("register_atlas rejects non-3D images", {
  skip_if_not_installed("RNifti")

  arr_4d <- array(1L, dim = c(4, 4, 4, 5))
  img_4d <- RNifti::asNifti(arr_4d)
  meta   <- data.frame(label = 1L, name = "ROI_A")
  expect_error(register_atlas(img_4d, meta), regexp = "3D")
})

test_that("palette_bold has 8 named colours", {
  expect_length(palette_bold, 8)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", palette_bold)))
  expect_named(palette_bold)
})
