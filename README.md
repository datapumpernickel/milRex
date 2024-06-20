
<!-- README.md is generated from README.Rmd. Please edit that file -->

# milRex

<!-- badges: start -->

[![R-CMD-check](https://github.com/datapumpernickel/milRex/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/datapumpernickel/milRex/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/datapumpernickel/milRex/graph/badge.svg?token=08ULI3CEWH)](https://codecov.io/gh/datapumpernickel/milRex)

<!-- badges: end -->

The goal of milRex is to make it easy to query military expenditure data
from the Stockholm International Peace Research Institute. They offer
the most up-to date, openly available data on military expenditure.

## Installation

You can install the development version of milRex from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("datapumpernickel/milRex")
```

## Getting Military Expenditure in constant USD

This would query all the data, for military expenditure in constant USD.

``` r
library(milRex)
data <- sipri_get_data(indicator = "constantUSD", 
                    cache = TRUE,
                    verbose = FALSE,
                    footnotes = FALSE)
```

The available indicators are:

| sheet_name                     | indicator      |
|:-------------------------------|:---------------|
| Constant (2022) US\$           | constantUSD    |
| Current US\$                   | currentUSD     |
| Share of GDP                   | shareOfGDP     |
| Share of Govt. spending        | shareGovt      |
| Regional totals                | regionalTotals |
| Local currency financial years | currencyFY     |
| Local currency calendar years  | currencyCY     |
| Per capita                     | perCapita      |
| all of the above               | all            |

## Sources and Methods

Military Expenditure is a concept that is difficult to measure
adequately in a comparative manner across the globe. The dataset by
SIPRI is the best effort that exists today, using only open sources.
Nonetheless, there is limitation to their data. I **highly** encourage
anyone who wants to use this dataset, to read their Sources and Methods
section here:

<https://www.sipri.org/databases/milex/sources-and-methods>

## Estimates and uncertain data

Some of the SIPRI estimates reported in their dataset are marked as
uncertain or estimations (e.g. all the data for China). These cells are
marked in blue or red in the resulting excel-file. Unfortunately, color
coding is not machine-readable, hence this information cannot be
translated into data.frames in R and is missing. Please be aware of this
limitation.

## Copyright

The Stockholm International Peace Research Institute limits the copying
and redistribution of its data to the following two use-cases:

- the excerption of SIPRI copyrighted material for such purposes as
  criticism, comment, news reporting, teaching, scholarship or research
  in which the use is for non-commercial purposes
- the reproduction of less than 10 per cent of a published data set.

Hence, this package does **not** contain any SIPRI data itself. It
merely automatizes the access through the website, by making the
corresponding POST request and cleaning the resulting xlsx file into
tidy formats.

Please make sure to cite SIPRI when using their data with:

*SIPRI Military Expenditure Database 2024,
<https://www.sipri.org/databases/milex>*
