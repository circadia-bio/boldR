test_that("list_atlases returns a tibble with required columns", {
  atlases <- list_atlases()
  expect_s3_class(atlases, "tbl_df")
  expect_true(all(c("name", "n_rois", "space", "description") %in% names(atlases)))
  expect_gt(nrow(atlases), 0)
})

test_that("load_atlas errors on unknown name", {
  expect_error(load_atlas("does_not_exist_atlas"),
               regexp = "not found|not registered",
               ignore.case = TRUE)
})

test_that("load_atlas errors on missing custom file", {
  expect_error(load_atlas("/nonexistent/path/atlas.nii.gz"),
               regexp = "not found",
               ignore.case = TRUE)
})

test_that("load_atlas errors when custom labels are missing", {
  # Create a temporary minimal NIfTI stand-in (not a real NIfTI, just checks
  # that the label argument is enforced before file reading)
  tmp <- tempfile(fileext = ".nii.gz")
  file.create(tmp)
  on.exit(unlink(tmp))
  expect_error(load_atlas(tmp, labels = NULL),
               regexp = "labels",
               ignore.case = TRUE)
})
