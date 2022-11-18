Homework 4
================
CB
2022-11-17

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
fun2alt <- function(mat) {
    t(apply(mat, 1, cumsum))}
```

### Benchmarking

#### Test for the first

``` r
summary(microbenchmark::microbenchmark(
  fun1(dat),
  fun1alt(dat), check = "equivalent"
), unit="relative")
```

    ##           expr      min      lq     mean   median       uq       max neval
    ## 1    fun1(dat) 2.938875 4.22276 3.979299 4.927145 4.985714 0.4421965   100
    ## 2 fun1alt(dat) 1.000000 1.00000 1.000000 1.000000 1.000000 1.0000000   100

#### Test for the second

``` r
summary(microbenchmark::microbenchmark(
  fun2(dat),
  fun2alt(dat), check = "equivalent"
), unit="relative")
```

    ##           expr      min       lq     mean   median       uq      max neval
    ## 1    fun2(dat) 2.774581 2.331339 1.974931 2.223365 2.074409 1.036759   100
    ## 2 fun2alt(dat) 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000   100

### Problem 2. Make things run faster with parallel computing

``` r
sim_pi <- function(n = 1000, i = NULL) {
  p <- matrix(runif(n*2), ncol = 2)
  mean(rowSums(p^2) < 1) * 4
}


# Here is an example of the run
set.seed(156)
sim_pi(1000) # 3.132
```

    ## [1] 3.132

``` r
# This runs the simulation a 4,000 times, each with 10,000 points
set.seed(1231)
system.time({
  ans <- unlist(lapply(1:4000, sim_pi, n = 10000))
  print(mean(ans))
})
```

    ## [1] 3.14124

    ##    user  system elapsed 
    ##    1.41    0.33    1.80

#### Use parlapply to run faster

``` r
library(parallel)


cl <- makePSOCKcluster(4L)
clusterSetRNGStream(cl, 1231)
system.time({
  clusterExport(cl, "sim_pi")
  ans <- unlist(parLapply(cl, 1:4000, sim_pi, n=10000))
  print(mean(ans))

})
```

    ## [1] 3.141578

    ##    user  system elapsed 
    ##    0.00    0.00    0.78

``` r
stopCluster(cl)
```

## SQL

### Setup

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



# Initialize a temporary in memory database
con <- dbConnect(SQLite(), ":memory:")

# Download tables
film <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/film.csv")
film_category <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/film_category.csv")
category <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/category.csv")

# Copy data.frames to database
dbWriteTable(con, "film", film)
dbWriteTable(con, "film_category", film_category)
dbWriteTable(con, "category", category)
```

``` r
dbListTables(con)
```

    ## [1] "category"      "film"          "film_category"

### Brief data exploration to determine variable names

``` r
#View variables in each dataset
dbGetQuery(con, "PRAGMA table_info(film)")
```

    ##    cid                 name    type notnull dflt_value pk
    ## 1    0              film_id INTEGER       0         NA  0
    ## 2    1                title    TEXT       0         NA  0
    ## 3    2          description    TEXT       0         NA  0
    ## 4    3         release_year INTEGER       0         NA  0
    ## 5    4          language_id INTEGER       0         NA  0
    ## 6    5 original_language_id INTEGER       0         NA  0
    ## 7    6      rental_duration INTEGER       0         NA  0
    ## 8    7          rental_rate    REAL       0         NA  0
    ## 9    8               length INTEGER       0         NA  0
    ## 10   9     replacement_cost    REAL       0         NA  0
    ## 11  10               rating    TEXT       0         NA  0
    ## 12  11          last_update    TEXT       0         NA  0
    ## 13  12     special_features    TEXT       0         NA  0
    ## 14  13             fulltext    TEXT       0         NA  0

``` r
dbGetQuery(con, "PRAGMA table_info(film_category)")
```

    ##   cid        name    type notnull dflt_value pk
    ## 1   0     film_id INTEGER       0         NA  0
    ## 2   1 category_id INTEGER       0         NA  0
    ## 3   2 last_update    TEXT       0         NA  0

``` r
dbGetQuery(con, "PRAGMA table_info(category)")
```

    ##   cid        name    type notnull dflt_value pk
    ## 1   0 category_id INTEGER       0         NA  0
    ## 2   1        name    TEXT       0         NA  0
    ## 3   2 last_update    TEXT       0         NA  0

### Question 1. How many movies are avaliable in each rating category?

``` r
dbGetQuery(con, "
SELECT rating, COUNT (*) AS Rating_Count
FROM film
GROUP by rating
ORDER BY rating")
```

    ##   rating Rating_Count
    ## 1      G          180
    ## 2  NC-17          210
    ## 3     PG          194
    ## 4  PG-13          223
    ## 5      R          195

### Question 2. What is the average replacement cost and rental rate for each rating category?

``` r
dbGetQuery(con, "
SELECT rating, 
       AVG(replacement_cost) AS Avg_Replacement_Cost,
       AVG(rental_rate) AS Avg_Rental_Rate
FROM film
GROUP by rating
ORDER BY rating")
```

    ##   rating Avg_Replacement_Cost Avg_Rental_Rate
    ## 1      G             20.12333        2.912222
    ## 2  NC-17             20.13762        2.970952
    ## 3     PG             18.95907        3.051856
    ## 4  PG-13             20.40256        3.034843
    ## 5      R             20.23103        2.938718

### Question 3. Use table film_category together with film to find how many films there are with each category ID.

``` r
dbGetQuery(con, "
SELECT category_id, COUNT (category_id) AS Film_Count 
FROM (SELECT c.film_id, c.category_id, p.film_id 
FROM film_category AS c INNER JOIN film AS p
ON c.film_id = p.film_id)
GROUP BY category_id
ORDER BY Film_Count DESC")
```

    ##    category_id Film_Count
    ## 1           15         74
    ## 2            9         73
    ## 3            8         69
    ## 4            6         68
    ## 5            2         66
    ## 6            1         64
    ## 7           13         63
    ## 8            7         62
    ## 9           14         61
    ## 10          10         61
    ## 11           3         60
    ## 12           5         58
    ## 13          16         57
    ## 14           4         57
    ## 15          11         56
    ## 16          12         51

### Question 4. Incorporate table category into the answer to the previous question to find the name of the most popular category.

``` r
dbGetQuery(con, "
SELECT category_id, name, COUNT (category_id) AS Film_Count 
FROM (SELECT a.name, a.category_id, b.category_id, b.film_id
FROM (SELECT c.film_id, c.category_id, p.film_id 
FROM film_category AS c INNER JOIN film AS p
ON c.film_id = p.film_id) AS b INNER JOIN category AS a 
ON a.category_id = b.category_id)
GROUP BY category_id
ORDER BY Film_Count DESC")
```

    ##    category_id        name Film_Count
    ## 1           15      Sports         74
    ## 2            9     Foreign         73
    ## 3            8      Family         69
    ## 4            6 Documentary         68
    ## 5            2   Animation         66
    ## 6            1      Action         64
    ## 7           13         New         63
    ## 8            7       Drama         62
    ## 9           14      Sci-Fi         61
    ## 10          10       Games         61
    ## 11           3    Children         60
    ## 12           5      Comedy         58
    ## 13          16      Travel         57
    ## 14           4    Classics         57
    ## 15          11      Horror         56
    ## 16          12       Music         51

#### *Sports seems to be the most popular film category!*

#### Disconnect

``` r
dbDisconnect(con)
```
