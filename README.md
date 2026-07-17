
<!-- README.md is generated from README.Rmd. Please edit that file -->

# detectduplicate

<!-- badges: start -->

<!-- badges: end -->

`detectduplicate` detects duplicate sequences of numbers. It can also
detect pairs of sequences that have a constant offset, and/or a constant
multiplier.

`detectduplicate` can be installed with

``` r
# install.packages("pak")
pak::pak("richardjtelford/detectduplicate")
```

`detectduplicate` requires a vector of numbers as input.

``` r
library(detectduplicate)
data("kp2014") # part of the data from Keiser & Pruitt 2014
dup_find_all(x = kp2014$`Theridion murarium Aggressiveness...4`, type = "offset")
#> # A tibble: 16 × 9
#>    duplicate_no type   length  pos1  vec1  pos2  vec2 delta offset
#>           <int> <chr>   <dbl> <int> <dbl> <int> <dbl> <dbl>  <dbl>
#>  1            1 offset      9    67 166.     78 162.  -4.35  -4.35
#>  2            1 offset      9    68  47.7    79  43.3 -4.35  -4.35
#>  3            1 offset      9    69 125.     80 120.  -4.35  -4.35
#>  4            1 offset      9    70  91.0    81  86.6 -4.35  -4.35
#>  5            1 offset      9    71 134.     82 130.  -4.35  -4.35
#>  6            1 offset      9    72 158.     83 153.  -4.35  -4.35
#>  7            1 offset      9    73  46.4    84  42.0 -4.35  -4.35
#>  8            1 offset      9    74 186.     85 182.  -4.35  -4.35
#>  9            1 offset      9    75 148.     86 143.  -4.35  -4.35
#> 10            2 offset      7    29  13.2    62  15.3  2.03   2.03
#> 11            2 offset      7    30 202.     63 204.   2.03   2.03
#> 12            2 offset      7    31 229.     64 231.   2.03   2.03
#> 13            2 offset      7    32 645.     65 647.   2.03   2.03
#> 14            2 offset      7    33  15.2    66  17.3  2.03   2.03
#> 15            2 offset      7    34 164.     67 166.   2.03   2.03
#> 16            2 offset      7    35  45.6    68  47.7  2.03   2.03
```

The result give the position and values of the first and second sets of
duplicated values and any offset.

Alternatively, if several columns need of a data.frame to be checked, a
data.frame containing just these columns.

``` r
dup_find_all(
  x = kp2014[, c(
    "Theridion murarium Aggressiveness...4",
    "Theridion murarium Aggressiveness...5",
    "Theridion murarium Aggressiveness...6"
  )],
  type = "offset"
)
#> # A tibble: 32 × 11
#>    duplicate_no type   length col1     row1  vec1 col2   row2  vec2 delta offset
#>           <int> <chr>   <dbl> <chr>   <dbl> <dbl> <chr> <dbl> <dbl> <dbl>  <dbl>
#>  1            1 offset      9 Therid…    67 166.  Ther…    78 162.  -4.35  -4.35
#>  2            1 offset      9 Therid…    68  47.7 Ther…    79  43.3 -4.35  -4.35
#>  3            1 offset      9 Therid…    69 125.  Ther…    80 120.  -4.35  -4.35
#>  4            1 offset      9 Therid…    70  91.0 Ther…    81  86.6 -4.35  -4.35
#>  5            1 offset      9 Therid…    71 134.  Ther…    82 130.  -4.35  -4.35
#>  6            1 offset      9 Therid…    72 158.  Ther…    83 153.  -4.35  -4.35
#>  7            1 offset      9 Therid…    73  46.4 Ther…    84  42.0 -4.35  -4.35
#>  8            1 offset      9 Therid…    74 186.  Ther…    85 182.  -4.35  -4.35
#>  9            1 offset      9 Therid…    75 148.  Ther…    86 143.  -4.35  -4.35
#> 10            2 offset      9 Therid…    69 125.  Ther…    29 123.  -2.03  -2.03
#> # ℹ 22 more rows
```

To see the duplicate sequences in situ, use `dup_show`.

``` r
dup_show(kp2014, meta_cols = 1:3, test_cols = starts_with("Theridion"))
```

## Notes

`detectduplicate` will report the all the duplicate sequences it can
find.

`detectduplicate` will not report sequences of identical values as
duplicates. I don’t think it is useful to report “duplicates” within and
between long sequences of e.g. zeros.

`detectduplicate` reports duplicate values. It does not report why.
There may be valid reasons for duplicate sequences.

If very short sequences (e.g. length 3) are searched for, there is a
high risk of false positives. This risk is especially high if the data
are reported with low precision, cardinality is low, or test are made
for pairs of sequences with a constant multiplier and offset

If you find this package useful or have ideas about how it could be
improve, please leave a message in the issues tab.
