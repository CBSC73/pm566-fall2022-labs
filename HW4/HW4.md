Homework 4
================
CB
2022-11-14

## HPC

### Problem 1: Make sure your code is nice

#### Create a matrix with a set seed

``` r
set.seed(2315)
dat <- matrix(rnorm(200 * 100), nrow = 200)
```

#### Find total row sums

``` r
fun1 <- function(dat) {
  n <- nrow(dat)
  ans <- double(n) 
  for (i in 1:n) {
    ans[i] <- sum(dat[i, ])
  }
  ans
}
```

#### Alternative code to run faster

``` r
fun1alt <-function(dat) {
  x <- rowSums(dat)
  return(x)
}
```

#### Find cumulative row sums

``` r
# Cumulative sum by row
fun2 <- function(dat) {
  n <- nrow(dat)
  k <- ncol(dat)
  ans <- dat
  for (i in 1:n) {
    for (j in 2:k) {
      ans[i,j] <- dat[i, j] + ans[i, j - 1]
    }
  }
  ans
}
```

#### Alternative code to run faster

``` r
install.packages("matrixStats")
```

    ## Installing package into 'C:/Users/clair/AppData/Local/R/win-library/4.2'
    ## (as 'lib' is unspecified)

    ## package 'matrixStats' successfully unpacked and MD5 sums checked

    ## Warning: cannot remove prior installation of package 'matrixStats'

    ## Warning in file.copy(savedcopy, lib, recursive = TRUE):
    ## problem copying C:\Users\clair\AppData\Local\R\win-
    ## library\4.2\00LOCK\matrixStats\libs\x64\matrixStats.dll
    ## to C:\Users\clair\AppData\Local\R\win-
    ## library\4.2\matrixStats\libs\x64\matrixStats.dll: Permission denied

    ## Warning: restored 'matrixStats'

    ## 
    ## The downloaded binary packages are in
    ##  C:\Users\clair\AppData\Local\Temp\Rtmp4asnv7\downloaded_packages

``` r
library(matrixStats)
```

    ## Warning: package 'matrixStats' was built under R version 4.2.2

``` r
fun2alt <-function(dat) {
  x <- rowCumsums(dat)
  return(x)
}
```

### Benchmarking

#### Test for the first

``` r
microbenchmark::microbenchmark(
  fun1(dat),
  fun1alt(dat), check = "equivalent"
)
```

    ## Unit: microseconds
    ##          expr     min       lq      mean  median       uq      max neval
    ##     fun1(dat) 116.301 163.2515 192.29798 192.901 217.4005  316.401   100
    ##  fun1alt(dat)  41.001  48.1010  62.11996  48.401  50.0015 1426.302   100

#### Test for the second

``` r
microbenchmark::microbenchmark(
  fun2(dat),
  fun2alt(dat), check = "equivalent"
)
```

    ## Unit: microseconds
    ##          expr     min       lq       mean    median        uq      max neval
    ##     fun2(dat) 997.400 1033.551 1110.25795 1090.0510 1173.5010 1590.801   100
    ##  fun2alt(dat)  17.701   37.901   57.75001   42.3505   49.0515  982.402   100

## SQL

``` r
if (!require(RSQLite)) install.packages(c("RSQLite"))
```

    ## Loading required package: RSQLite

    ## Warning: package 'RSQLite' was built under R version 4.2.2

``` r
if (!require(DBI))     install.packages(c("DBI"))
```

    ## Loading required package: DBI

    ## Warning: package 'DBI' was built under R version 4.2.2

``` r
library(RSQLite)
library(DBI)
```

### Question 1.
