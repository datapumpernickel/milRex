
<!-- README.md is generated from README.Rmd. Please edit that file -->

# milRex

<!-- badges: start -->

[![R-CMD-check](https://github.com/datapumpernickel/milRex/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/datapumpernickel/milRex/actions/workflows/R-CMD-check.yaml)

[![codecov](https://codecov.io/gh/datapumpernickel/milRex/graph/badge.svg?token=08ULI3CEWH)](https://codecov.io/gh/datapumpernickel/milRex)

<!-- badges: end -->

The goal of milRex is to make it easy to query military expenditure data
from SIPRI.

# 🚧 Under construction 🚧

Currently this package is under construction. Only constant USD of
military expenditure are queried.

## Installation

You can install the development version of milRex from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("datapumpernickel/milRex")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(milRex)
data <- mr_get_data()
```
