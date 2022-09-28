Lab 06
================
CB
2022-09-28

## R Markdown

\#Load required libraries

``` r
library(tidytext)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyverse)
```

    ## ── Attaching packages
    ## ───────────────────────────────────────
    ## tidyverse 1.3.2 ──

    ## ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.8     ✔ stringr 1.4.1
    ## ✔ tidyr   1.2.0     ✔ forcats 0.5.2
    ## ✔ readr   2.1.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(ggplot2)
library(forcats)
```

\#Load in data

``` r
download.file("https://raw.githubusercontent.com//USCbiostats//data-science-data//master//00_mtsamples//mtsamples.csv", "mtsamples.csv", method="libcurl", timeout=60)
```

``` r
mts<-read.csv("mtsamples.csv")
dim(mts)
```

    ## [1] 4999    6

``` r
str(mts)
```

    ## 'data.frame':    4999 obs. of  6 variables:
    ##  $ X                : int  0 1 2 3 4 5 6 7 8 9 ...
    ##  $ description      : chr  " A 23-year-old white female presents with complaint of allergies." " Consult for laparoscopic gastric bypass." " Consult for laparoscopic gastric bypass." " 2-D M-Mode. Doppler.  " ...
    ##  $ medical_specialty: chr  " Allergy / Immunology" " Bariatrics" " Bariatrics" " Cardiovascular / Pulmonary" ...
    ##  $ sample_name      : chr  " Allergic Rhinitis " " Laparoscopic Gastric Bypass Consult - 2 " " Laparoscopic Gastric Bypass Consult - 1 " " 2-D Echocardiogram - 1 " ...
    ##  $ transcription    : chr  "SUBJECTIVE:,  This 23-year-old white female presents with complaint of allergies.  She used to have allergies w"| __truncated__ "PAST MEDICAL HISTORY:, He has difficulty climbing stairs, difficulty with airline seats, tying shoes, used to p"| __truncated__ "HISTORY OF PRESENT ILLNESS: , I have seen ABC today.  He is a very pleasant gentleman who is 42 years old, 344 "| __truncated__ "2-D M-MODE: , ,1.  Left atrial enlargement with left atrial diameter of 4.7 cm.,2.  Normal size right and left "| __truncated__ ...
    ##  $ keywords         : chr  "allergy / immunology, allergic rhinitis, allergies, asthma, nasal sprays, rhinitis, nasal, erythematous, allegr"| __truncated__ "bariatrics, laparoscopic gastric bypass, weight loss programs, gastric bypass, atkin's diet, weight watcher's, "| __truncated__ "bariatrics, laparoscopic gastric bypass, heart attacks, body weight, pulmonary embolism, potential complication"| __truncated__ "cardiovascular / pulmonary, 2-d m-mode, doppler, aortic valve, atrial enlargement, diastolic function, ejection"| __truncated__ ...

``` r
mts<-as_tibble(mts)
mts
```

    ## # A tibble: 4,999 × 6
    ##        X description                             medic…¹ sampl…² trans…³ keywo…⁴
    ##    <int> <chr>                                   <chr>   <chr>   <chr>   <chr>  
    ##  1     0 " A 23-year-old white female presents … " Alle… " Alle… "SUBJE… "aller…
    ##  2     1 " Consult for laparoscopic gastric byp… " Bari… " Lapa… "PAST … "baria…
    ##  3     2 " Consult for laparoscopic gastric byp… " Bari… " Lapa… "HISTO… "baria…
    ##  4     3 " 2-D M-Mode. Doppler.  "               " Card… " 2-D … "2-D M… "cardi…
    ##  5     4 " 2-D Echocardiogram"                   " Card… " 2-D … "1.  T… "cardi…
    ##  6     5 " Morbid obesity.  Laparoscopic anteco… " Bari… " Lapa… "PREOP… "baria…
    ##  7     6 " Liposuction of the supraumbilical ab… " Bari… " Lipo… "PREOP… "baria…
    ##  8     7 " 2-D Echocardiogram"                   " Card… " 2-D … "2-D E… "cardi…
    ##  9     8 " Suction-assisted lipectomy - lipodys… " Bari… " Lipe… "PREOP… "baria…
    ## 10     9 " Echocardiogram and Doppler"           " Card… " 2-D … "DESCR… "cardi…
    ## # … with 4,989 more rows, and abbreviated variable names ¹​medical_specialty,
    ## #   ²​sample_name, ³​transcription, ⁴​keywords
    ## # ℹ Use `print(n = ...)` to see more rows

\#Question 1: What specialties do we have and how many of each are there
in the dataset? We can use count() from dplyr”

``` r
mts %>% count(medical_specialty)
```

    ## # A tibble: 40 × 2
    ##    medical_specialty                 n
    ##    <chr>                         <int>
    ##  1 " Allergy / Immunology"           7
    ##  2 " Autopsy"                        8
    ##  3 " Bariatrics"                    18
    ##  4 " Cardiovascular / Pulmonary"   372
    ##  5 " Chiropractic"                  14
    ##  6 " Consult - History and Phy."   516
    ##  7 " Cosmetic / Plastic Surgery"    27
    ##  8 " Dentistry"                     27
    ##  9 " Dermatology"                   29
    ## 10 " Diets and Nutritions"          10
    ## # … with 30 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

\#*The specialties are definitely overlapping. For instance there is
surgery in addition to urology which is a surgical subspecialty. They
are not evenly distributed, some categories have more than 1000 entries
and others \<10)*

``` r
colnames(mts)
```

    ## [1] "X"                 "description"       "medical_specialty"
    ## [4] "sample_name"       "transcription"     "keywords"

``` r
specialties<-mts %>% count(medical_specialty)
specialties %>% arrange(desc(n))
```

    ## # A tibble: 40 × 2
    ##    medical_specialty                    n
    ##    <chr>                            <int>
    ##  1 " Surgery"                        1103
    ##  2 " Consult - History and Phy."      516
    ##  3 " Cardiovascular / Pulmonary"      372
    ##  4 " Orthopedic"                      355
    ##  5 " Radiology"                       273
    ##  6 " General Medicine"                259
    ##  7 " Gastroenterology"                230
    ##  8 " Neurology"                       223
    ##  9 " SOAP / Chart / Progress Notes"   166
    ## 10 " Obstetrics / Gynecology"         160
    ## # … with 30 more rows
    ## # ℹ Use `print(n = ...)` to see more rows

``` r
#Make a barplot of specialty counts
specialties %>% 
  top_n(10) %>% 
  ggplot (aes(x=n, y=fct_reorder(medical_specialty,n)))+
  geom_col()
```

    ## Selecting by n

![](lab06_files/figure-gfm/unnamed-chunk-7-1.png)<!-- --> \# Tokenize in
transcription column and count number of times top 20 words appear

``` r
library(tidytext)
mts %>%
  unnest_tokens(word,transcription) %>% 
   count(word, sort=TRUE) %>% 
    top_n(20, n)
```

    ## # A tibble: 20 × 2
    ##    word         n
    ##    <chr>    <int>
    ##  1 the     149888
    ##  2 and      82779
    ##  3 was      71765
    ##  4 of       59205
    ##  5 to       50632
    ##  6 a        42810
    ##  7 with     35815
    ##  8 in       32807
    ##  9 is       26378
    ## 10 patient  22065
    ## 11 no       17874
    ## 12 she      17593
    ## 13 for      17049
    ## 14 he       15542
    ## 15 were     15535
    ## 16 on       14694
    ## 17 this     13949
    ## 18 at       13492
    ## 19 then     12430
    ## 20 right    11587

\#*Lots of stop words, so we do not get much information from this.*

## Question 3

\#Remove stop words

``` r
mts %>%
  unnest_tokens(word, transcription) %>%
  anti_join(stop_words, by = c("word")) %>%
  count(word, sort = TRUE) %>% 
  top_n(20, n) %>% 
  ggplot(aes(n, fct_reorder(word, n))) +
  geom_col()
```

![](lab06_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

\#*Lots of numbers here*, remove these.\_

``` r
mts %>%
  unnest_tokens(word, transcription) %>%
  count(word, sort = TRUE) %>%
  anti_join(stop_words, by = c("word")) %>%
  
  filter( !grepl(pattern = "^[0-9]+$", x = word)) %>%
  top_n(20, n) %>%
  ggplot(aes(n, fct_reorder(word, n))) +
  geom_col()
```

![](lab06_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

\#*Now the numbers are gone, the words are much more useful to determine
what text is about*

## Question 4
