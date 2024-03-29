data("sample_explan_data")
sample_model_data2 <- dplyr::sample_n(sample_explan_data, 50)
biome_layer <- terra::rast(sample_extent_data)
terra::res(biome_layer) <- 10
biome_layer <- terra::setValues(biome_layer,
                                     1:terra::ncell(biome_layer))

test_that("stops if no occ.data provided", {
  expect_error(
    spatiotemp_block(
      spatial.layer = biome_layer,
      spatial.split.degrees = 3,
      temporal.block = c("month"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 10
    )
  )
})

test_that("stops if no vars.to.block.by provided", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = biome_layer,
      spatial.split.degrees = 3,
      temporal.block = c("month"),
      n.blocks = 10
    )
  )
})

test_that("stops if spatial.layer not class RasterLayer", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = c(0, 20, -20, 30),
      spatial.split.degrees = 3,
      temporal.block = c("month"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 10
    )
  )
})

test_that("stops if spatial.split.degrees not class numeric", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = biome_layer,
      spatial.split.degrees = "three",
      temporal.block = c("month"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 10
    )
  )
})

test_that("stops if spatial.layer given but no spatial.split.degrees", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = biome_layer,
      temporal.block = c("month"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 10
    )
  )
})

test_that("stops if temporal.block not accepted", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = biome_layer,
      spatial.split.degrees = 3,
      temporal.block = c("decadal"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 10
    )
  )
})

test_that(
  "Only temporal blocking by one level, results in correct number of unique blocking categories",
  {
    n <- as.numeric(2)
    df <- spatiotemp_block(
        occ.data = sample_model_data2,
        temporal.block = c("month"),
        vars.to.block.by = colnames(sample_model_data2)[14:16],
        n.blocks = n,
        iterations = 2000
      )
    expect_equal(length(unique(df$BLOCK.CATS)), n)
  }
)

test_that("Doesn't error with only temporal blocking by two feature", {
  n <- as.numeric(2)
  df <- spatiotemp_block(
      occ.data = sample_model_data2,
      temporal.block = c("quarter", "year"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = n,
      iterations = 2000
    )
  expect_equal(length(unique(df$BLOCK.CATS)), n)
})

test_that("Only spatial blocking, results in correct number of unique blocking categories",
          {
            n <- as.numeric(2)
            df <- spatiotemp_block(
                occ.data = sample_model_data2,
                spatial.layer = biome_layer,
                spatial.split.degrees = 3,
                vars.to.block.by = colnames(sample_model_data2)[14:16],
                n.blocks = n,
                iterations = 2000
              )
            expect_equal(length(unique(df$BLOCK.CATS)), n)
          })

test_that(
  "Both spatial and temporal blocking, results in correct number of unique blocking categories",
  {
    n <- as.numeric(2)
    df <- spatiotemp_block(
        occ.data = sample_model_data2,
        spatial.layer = biome_layer,
        spatial.split.degrees = 3,
        temporal.block = c("month"),
        vars.to.block.by = colnames(sample_model_data2)[14:16],
        n.blocks = n,
        iterations = 2000
      )
    expect_equal(length(unique(df$BLOCK.CATS)), n)
  }
)

test_that("Errors if too many blocks expected", {
  expect_error(
    spatiotemp_block(
      occ.data = sample_model_data2,
      spatial.layer = biome_layer,
      spatial.split.degrees = 3,
      temporal.block = c("month"),
      vars.to.block.by = colnames(sample_model_data2)[14:16],
      n.blocks = 100000
    )
  )
})

