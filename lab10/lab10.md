Lab 10
================
CB
2022-11-02

## R Markdown

``` r
library(RSQLite)
```

    ## Warning: package 'RSQLite' was built under R version 4.2.2

``` r
library(DBI)
```

    ## Warning: package 'DBI' was built under R version 4.2.2

``` r
# Initialize a temporary in memory database
con <- dbConnect(SQLite(), ":memory:")

# Download tables
actor <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/actor.csv")
rental <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/rental.csv")
customer <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/customer.csv")
payment <- read.csv("https://raw.githubusercontent.com/ivanceras/sakila/master/csv-sakila-db/payment_p2007_01.csv")

# Copy data.frames to database
dbWriteTable(con, "actor", actor)
dbWriteTable(con, "rental", rental)
dbWriteTable(con, "customer", customer)
dbWriteTable(con, "payment", payment)
```

``` r
dbListTables(con)
```

    ## [1] "actor"    "customer" "payment"  "rental"

``` sql
PRAGMA table_info(actor)
```

| cid | name        | type    | notnull | dflt_value |  pk |
|:----|:------------|:--------|--------:|:-----------|----:|
| 0   | actor_id    | INTEGER |       0 | NA         |   0 |
| 1   | first_name  | TEXT    |       0 | NA         |   0 |
| 2   | last_name   | TEXT    |       0 | NA         |   0 |
| 3   | last_update | TEXT    |       0 | NA         |   0 |

4 records

``` r
#in order to do the SQL query FROM R use the dbGetQuery command to do it
dbGetQuery(con, "PRAGMA table_info(actor)")
```

    ##   cid        name    type notnull dflt_value pk
    ## 1   0    actor_id INTEGER       0         NA  0
    ## 2   1  first_name    TEXT       0         NA  0
    ## 3   2   last_name    TEXT       0         NA  0
    ## 4   3 last_update    TEXT       0         NA  0

## Exercise 1

``` r
dbGetQuery(con, "
SELECT actor_id, first_name, last_name
FROM actor
ORDER by last_name, first_name")
```

    ##     actor_id  first_name    last_name
    ## 1         58   CHRISTIAN       AKROYD
    ## 2        182      DEBBIE       AKROYD
    ## 3         92     KIRSTEN       AKROYD
    ## 4        118        CUBA        ALLEN
    ## 5        145         KIM        ALLEN
    ## 6        194       MERYL        ALLEN
    ## 7         76    ANGELINA      ASTAIRE
    ## 8        112     RUSSELL       BACALL
    ## 9        190      AUDREY       BAILEY
    ## 10        67     JESSICA       BAILEY
    ## 11       115    HARRISON         BALE
    ## 12       187       RENEE         BALL
    ## 13        47       JULIA    BARRYMORE
    ## 14       158      VIVIEN     BASINGER
    ## 15       174     MICHAEL       BENING
    ## 16       124    SCARLETT       BENING
    ## 17        14      VIVIEN       BERGEN
    ## 18       121        LIZA      BERGMAN
    ## 19        91 CHRISTOPHER        BERRY
    ## 20        60       HENRY        BERRY
    ## 21        12        KARL        BERRY
    ## 22       189        CUBA        BIRCH
    ## 23        25       KEVIN        BLOOM
    ## 24       185     MICHAEL       BOLGER
    ## 25        37         VAL       BOLGER
    ## 26        98       CHRIS      BRIDGES
    ## 27        39      GOLDIE        BRODY
    ## 28       159       LAURA        BRODY
    ## 29       167    LAURENCE      BULLOCK
    ## 30        40      JOHNNY         CAGE
    ## 31        11        ZERO         CAGE
    ## 32       181     MATTHEW       CARREY
    ## 33        86        GREG      CHAPLIN
    ## 34         3          ED        CHASE
    ## 35       176         JON        CHASE
    ## 36       183     RUSSELL        CLOSE
    ## 37        16        FRED      COSTNER
    ## 38       129       DARYL     CRAWFORD
    ## 39        26         RIP     CRAWFORD
    ## 40        49        ANNE       CRONYN
    ## 41       104    PENELOPE       CRONYN
    ## 42       105      SIDNEY        CROWE
    ## 43        57        JUDE       CRUISE
    ## 44       201         TOM       CRUISE
    ## 45       203         TOM       CRUISE
    ## 46       205         TOM       CRUISE
    ## 47       207         TOM       CRUISE
    ## 48        80       RALPH         CRUZ
    ## 49        81    SCARLETT        DAMON
    ## 50         4    JENNIFER        DAVIS
    ## 51       101       SUSAN        DAVIS
    ## 52       110       SUSAN        DAVIS
    ## 53        48     FRANCES    DAY-LEWIS
    ## 54        35        JUDY         DEAN
    ## 55       143       RIVER         DEAN
    ## 56       148       EMILY          DEE
    ## 57       138     LUCILLE          DEE
    ## 58       107        GINA    DEGENERES
    ## 59        41       JODIE    DEGENERES
    ## 60       166        NICK    DEGENERES
    ## 61        89    CHARLIZE        DENCH
    ## 62       123    JULIANNE        DENCH
    ## 63       160       CHRIS         DEPP
    ## 64       100     SPENCER         DEPP
    ## 65       109   SYLVESTER         DERN
    ## 66       173        ALAN     DREYFUSS
    ## 67        36        BURT      DUKAKIS
    ## 68       188        ROCK      DUKAKIS
    ## 69       106     GROUCHO        DUNST
    ## 70        19         BOB      FAWCETT
    ## 71       199       JULIA      FAWCETT
    ## 72        10   CHRISTIAN        GABLE
    ## 73       165          AL      GARLAND
    ## 74       184    HUMPHREY      GARLAND
    ## 75       127       KEVIN      GARLAND
    ## 76       154       MERYL       GIBSON
    ## 77        46      PARKER     GOLDBERG
    ## 78       139        EWAN      GOODING
    ## 79       191     GREGORY      GOODING
    ## 80        71        ADAM        GRANT
    ## 81       179          ED      GUINESS
    ## 82         1    PENELOPE      GUINESS
    ## 83        90        SEAN      GUINESS
    ## 84        32         TIM      HACKMAN
    ## 85       175     WILLIAM      HACKMAN
    ## 86       202         TOM        HANKS
    ## 87       204         TOM        HANKS
    ## 88       206         TOM        HANKS
    ## 89       208         TOM        HANKS
    ## 90       152         BEN       HARRIS
    ## 91       141        CATE       HARRIS
    ## 92        56         DAN       HARRIS
    ## 93        97         MEG        HAWKE
    ## 94       151    GEOFFREY       HESTON
    ## 95       169     KENNETH      HOFFMAN
    ## 96        79         MAE      HOFFMAN
    ## 97        28       WOODY      HOFFMAN
    ## 98       161      HARVEY         HOPE
    ## 99       134        GENE      HOPKINS
    ## 100      113      MORGAN      HOPKINS
    ## 101       50     NATALIE      HOPKINS
    ## 102      132        ADAM       HOPPER
    ## 103      170        MENA       HOPPER
    ## 104       65      ANGELA       HUDSON
    ## 105       52      CARMEN         HUNT
    ## 106      140      WHOOPI         HURT
    ## 107      131        JANE      JACKMAN
    ## 108      119      WARREN      JACKMAN
    ## 109      146      ALBERT    JOHANSSON
    ## 110        8     MATTHEW    JOHANSSON
    ## 111       64         RAY    JOHANSSON
    ## 112       82       WOODY        JOLIE
    ## 113       43        KIRK     JOVOVICH
    ## 114      130       GRETA       KEITEL
    ## 115      198        MARY       KEITEL
    ## 116       74       MILLA       KEITEL
    ## 117       55         FAY       KILMER
    ## 118      153      MINNIE       KILMER
    ## 119      162       OPRAH       KILMER
    ## 120       45       REESE       KILMER
    ## 121       23      SANDRA       KILMER
    ## 122      103     MATTHEW        LEIGH
    ## 123        5      JOHNNY LOLLOBRIGIDA
    ## 124      157       GRETA       MALDEN
    ## 125      136          ED    MANSFIELD
    ## 126       22       ELVIS         MARX
    ## 127       77        CARY  MCCONAUGHEY
    ## 128       70    MICHELLE  MCCONAUGHEY
    ## 129      114      MORGAN    MCDORMAND
    ## 130      177        GENE     MCKELLEN
    ## 131       38         TOM     MCKELLEN
    ## 132      128        CATE      MCQUEEN
    ## 133       27       JULIA      MCQUEEN
    ## 134       42         TOM      MIRANDA
    ## 135      178        LISA       MONROE
    ## 136      120    PENELOPE       MONROE
    ## 137        7       GRACE       MOSTEL
    ## 138       99         JIM       MOSTEL
    ## 139       61   CHRISTIAN       NEESON
    ## 140       62       JAYNE       NEESON
    ## 141        6       BETTE    NICHOLSON
    ## 142      125      ALBERT        NOLTE
    ## 143      150       JAYNE        NOLTE
    ## 144      122       SALMA        NOLTE
    ## 145      108      WARREN        NOLTE
    ## 146       34      AUDREY      OLIVIER
    ## 147       15        CUBA      OLIVIER
    ## 148       69     KENNETH      PALTROW
    ## 149       21     KIRSTEN      PALTROW
    ## 150       33       MILLA         PECK
    ## 151       30      SANDRA         PECK
    ## 152       87     SPENCER         PECK
    ## 153       73        GARY         PENN
    ## 154      133     RICHARD         PENN
    ## 155       88     KENNETH        PESCI
    ## 156      171     OLYMPIA     PFEIFFER
    ## 157       51        GARY      PHOENIX
    ## 158       54    PENELOPE      PINKETT
    ## 159       84       JAMES         PITT
    ## 160       75        BURT        POSEY
    ## 161       93       ELLEN      PRESLEY
    ## 162      135        RITA     REYNOLDS
    ## 163      142        JADA        RYDER
    ## 164      195       JAYNE  SILVERSTONE
    ## 165      180        JEFF  SILVERSTONE
    ## 166       78     GROUCHO      SINATRA
    ## 167       31       SISSY     SOBIESKI
    ## 168       44        NICK     STALLONE
    ## 169       24     CAMERON       STREEP
    ## 170      116         DAN       STREEP
    ## 171      192        JOHN       SUVARI
    ## 172        9         JOE        SWANK
    ## 173      155         IAN        TANDY
    ## 174       66        MARY        TANDY
    ## 175       59      DUSTIN       TAUTOU
    ## 176      193        BURT       TEMPLE
    ## 177       53        MENA       TEMPLE
    ## 178      149     RUSSELL       TEMPLE
    ## 179      200       THORA       TEMPLE
    ## 180      126     FRANCES        TOMEI
    ## 181       18         DAN         TORN
    ## 182       94     KENNETH         TORN
    ## 183      102      WALTER         TORN
    ## 184       20     LUCILLE        TRACY
    ## 185      117       RENEE        TRACY
    ## 186       17       HELEN       VOIGHT
    ## 187       95       DARYL     WAHLBERG
    ## 188        2        NICK     WAHLBERG
    ## 189      196        BELA       WALKEN
    ## 190       29        ALEC        WAYNE
    ## 191      163 CHRISTOPHER         WEST
    ## 192      197       REESE         WEST
    ## 193      172     GROUCHO     WILLIAMS
    ## 194      137      MORGAN     WILLIAMS
    ## 195       72        SEAN     WILLIAMS
    ## 196       83         BEN       WILLIS
    ## 197       96        GENE       WILLIS
    ## 198      164    HUMPHREY       WILLIS
    ## 199      168        WILL       WILSON
    ## 200      147         FAY      WINSLET
    ## 201       68         RIP      WINSLET
    ## 202      144      ANGELA  WITHERSPOON
    ## 203      156         FAY         WOOD
    ## 204       13         UMA         WOOD
    ## 205       63     CAMERON         WRAY
    ## 206      111     CAMERON    ZELLWEGER
    ## 207      186       JULIA    ZELLWEGER
    ## 208       85      MINNIE    ZELLWEGER

``` sql
SELECT actor_id, first_name, last_name
FROM actor
ORDER by last_name, first_name
LIMIT 15
```

| actor_id | first_name | last_name |
|---------:|:-----------|:----------|
|       58 | CHRISTIAN  | AKROYD    |
|      182 | DEBBIE     | AKROYD    |
|       92 | KIRSTEN    | AKROYD    |
|      118 | CUBA       | ALLEN     |
|      145 | KIM        | ALLEN     |
|      194 | MERYL      | ALLEN     |
|       76 | ANGELINA   | ASTAIRE   |
|      112 | RUSSELL    | BACALL    |
|      190 | AUDREY     | BAILEY    |
|       67 | JESSICA    | BAILEY    |

Displaying records 1 - 10

## Exercise 2.

``` sql
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name IN ('WILLIAMS', 'DAVIS')
ORDER BY last_name
```

| actor_id | first_name | last_name |
|---------:|:-----------|:----------|
|        4 | JENNIFER   | DAVIS     |
|      101 | SUSAN      | DAVIS     |
|      110 | SUSAN      | DAVIS     |
|       72 | SEAN       | WILLIAMS  |
|      137 | MORGAN     | WILLIAMS  |
|      172 | GROUCHO    | WILLIAMS  |

6 records

## Exercise 3.

``` r
dbGetQuery(con,"
      PRAGMA table_info(rental)
           "
)
```

    ##   cid         name    type notnull dflt_value pk
    ## 1   0    rental_id INTEGER       0         NA  0
    ## 2   1  rental_date    TEXT       0         NA  0
    ## 3   2 inventory_id INTEGER       0         NA  0
    ## 4   3  customer_id INTEGER       0         NA  0
    ## 5   4  return_date    TEXT       0         NA  0
    ## 6   5     staff_id INTEGER       0         NA  0
    ## 7   6  last_update    TEXT       0         NA  0

``` r
dbGetQuery(con,"
SELECT DISTINCT customer_id, rental_date
FROM  rental
WHERE date(rental_date) = '2005-07-05'
")
```

    ##    customer_id         rental_date
    ## 1          565 2005-07-05 22:49:24
    ## 2          242 2005-07-05 22:51:44
    ## 3           37 2005-07-05 22:56:33
    ## 4           60 2005-07-05 22:57:34
    ## 5          594 2005-07-05 22:59:53
    ## 6            8 2005-07-05 23:01:21
    ## 7          490 2005-07-05 23:02:37
    ## 8          476 2005-07-05 23:05:17
    ## 9          322 2005-07-05 23:05:44
    ## 10         298 2005-07-05 23:08:53
    ## 11         382 2005-07-05 23:11:43
    ## 12         138 2005-07-05 23:13:07
    ## 13         520 2005-07-05 23:13:22
    ## 14         536 2005-07-05 23:13:51
    ## 15         114 2005-07-05 23:23:11
    ## 16         111 2005-07-05 23:25:54
    ## 17         296 2005-07-05 23:29:55
    ## 18         586 2005-07-05 23:30:36
    ## 19         349 2005-07-05 23:32:49
    ## 20         397 2005-07-05 23:33:40
    ## 21         369 2005-07-05 23:37:13
    ## 22         421 2005-07-05 23:41:08
    ## 23         142 2005-07-05 23:44:37
    ## 24         169 2005-07-05 23:46:19
    ## 25         348 2005-07-05 23:47:30
    ## 26         553 2005-07-05 23:50:04
    ## 27         295 2005-07-05 23:59:15

``` r
dbGetQuery(con,"
SELECT customer_id, 
     COUNT(*) AS N
FROM  rental
WHERE date(rental_date) = '2005-07-05'
GROUP BY customer_id
")
```

    ##    customer_id N
    ## 1            8 1
    ## 2           37 1
    ## 3           60 1
    ## 4          111 1
    ## 5          114 1
    ## 6          138 1
    ## 7          142 1
    ## 8          169 1
    ## 9          242 1
    ## 10         295 1
    ## 11         296 1
    ## 12         298 1
    ## 13         322 1
    ## 14         348 1
    ## 15         349 1
    ## 16         369 1
    ## 17         382 1
    ## 18         397 1
    ## 19         421 1
    ## 20         476 1
    ## 21         490 1
    ## 22         520 1
    ## 23         536 1
    ## 24         553 1
    ## 25         565 1
    ## 26         586 1
    ## 27         594 1

## Exercise 4.1

Construct a query that retrieves all rows from the payment table where
the amount is either 1.99, 7.99, 9.99.

``` r
dbGetQuery(con,"
      PRAGMA table_info(payment)
")
```

    ##   cid         name    type notnull dflt_value pk
    ## 1   0   payment_id INTEGER       0         NA  0
    ## 2   1  customer_id INTEGER       0         NA  0
    ## 3   2     staff_id INTEGER       0         NA  0
    ## 4   3    rental_id INTEGER       0         NA  0
    ## 5   4       amount    REAL       0         NA  0
    ## 6   5 payment_date    TEXT       0         NA  0

``` r
dbGetQuery(con,"
SELECT *
FROM payment
WHERE amount IN (1.99, 7.99, 9.99)
LIMIT 10
  ")
```

    ##    payment_id customer_id staff_id rental_id amount               payment_date
    ## 1       16050         269        2         7   1.99 2007-01-24 21:40:19.996577
    ## 2       16056         270        1       193   1.99 2007-01-26 05:10:14.996577
    ## 3       16081         282        2        48   1.99 2007-01-25 04:49:12.996577
    ## 4       16103         294        1       595   1.99 2007-01-28 12:28:20.996577
    ## 5       16133         307        1       614   1.99 2007-01-28 14:01:54.996577
    ## 6       16158         316        1      1065   1.99 2007-01-31 07:23:22.996577
    ## 7       16160         318        1       224   9.99 2007-01-26 08:46:53.996577
    ## 8       16161         319        1        15   9.99 2007-01-24 23:07:48.996577
    ## 9       16180         330        2       967   7.99 2007-01-30 17:40:32.996577
    ## 10      16206         351        1      1137   1.99 2007-01-31 17:48:40.996577

## Exercise 4.2

Construct a query that retrieves all rows from the payment table where
the amount is greater than 5

``` r
dbGetQuery(con,"
SELECT *
FROM payment
WHERE amount > 5
LIMIT 10
")
```

    ##    payment_id customer_id staff_id rental_id amount               payment_date
    ## 1       16052         269        2       678   6.99 2007-01-28 21:44:14.996577
    ## 2       16058         271        1      1096   8.99 2007-01-31 11:59:15.996577
    ## 3       16060         272        1       405   6.99 2007-01-27 12:01:05.996577
    ## 4       16061         272        1      1041   6.99 2007-01-31 04:14:49.996577
    ## 5       16068         274        1       394   5.99 2007-01-27 09:54:37.996577
    ## 6       16073         276        1       860  10.99 2007-01-30 01:13:42.996577
    ## 7       16074         277        2       308   6.99 2007-01-26 20:30:05.996577
    ## 8       16082         282        2       282   6.99 2007-01-26 17:24:52.996577
    ## 9       16086         284        1      1145   6.99 2007-01-31 18:42:11.996577
    ## 10      16087         286        2        81   6.99 2007-01-25 10:43:45.996577

## Exercise 4.2, second part –Greater than 5 and less than 8

``` r
dbGetQuery(con,"
SELECT *
FROM payment
WHERE amount > 5   AND amount < 8
LIMIT 10
")
```

    ##    payment_id customer_id staff_id rental_id amount               payment_date
    ## 1       16052         269        2       678   6.99 2007-01-28 21:44:14.996577
    ## 2       16060         272        1       405   6.99 2007-01-27 12:01:05.996577
    ## 3       16061         272        1      1041   6.99 2007-01-31 04:14:49.996577
    ## 4       16068         274        1       394   5.99 2007-01-27 09:54:37.996577
    ## 5       16074         277        2       308   6.99 2007-01-26 20:30:05.996577
    ## 6       16082         282        2       282   6.99 2007-01-26 17:24:52.996577
    ## 7       16086         284        1      1145   6.99 2007-01-31 18:42:11.996577
    ## 8       16087         286        2        81   6.99 2007-01-25 10:43:45.996577
    ## 9       16092         288        2       427   6.99 2007-01-27 14:38:30.996577
    ## 10      16094         288        2       565   5.99 2007-01-28 07:54:57.996577

## Exercise 5. Retrive all the payment IDs and their amount from the customers whose last name is ‘DAVIS’.

``` r
dbGetQuery(con,"
SELECT *
FROM customer AS c INNER JOIN payment AS p
ON c.customer_id = p.customer_id
WHERE c.last_name=='DAVIS'
/* WHERE c.last_name == 'DAVIS' */ /* This is a comment */
")
```

    ##   customer_id store_id first_name last_name                             email
    ## 1           6        2   JENNIFER     DAVIS JENNIFER.DAVIS@sakilacustomer.org
    ## 2           6        2   JENNIFER     DAVIS JENNIFER.DAVIS@sakilacustomer.org
    ## 3           6        2   JENNIFER     DAVIS JENNIFER.DAVIS@sakilacustomer.org
    ##   address_id activebool create_date         last_update active payment_id
    ## 1         10          t  2006-02-14 2006-02-15 09:57:20      1      16685
    ## 2         10          t  2006-02-14 2006-02-15 09:57:20      1      16686
    ## 3         10          t  2006-02-14 2006-02-15 09:57:20      1      16687
    ##   customer_id staff_id rental_id amount               payment_date
    ## 1           6        2        57   4.99 2007-01-25 07:11:58.996577
    ## 2           6        1       577   2.99 2007-01-28 09:37:40.996577
    ## 3           6        2       916   0.99 2007-01-30 09:53:27.996577

## Exercise 6. Use COUNT(\*) to count the number of rows in rental

``` r
dbGetQuery(con,"
SELECT COUNT(*)
FROM rental")
```

    ##   COUNT(*)
    ## 1    16044

## Exercise 6.2 - Use COUNT(\*) and GROUP BY to count the number of rentals for each customer_id

``` r
dbGetQuery(con,"
SELECT customer_ID, COUNT(*) as count
FROM rental
GROUP BY customer_id")
```

    ##     customer_id count
    ## 1             1    32
    ## 2             2    27
    ## 3             3    26
    ## 4             4    22
    ## 5             5    38
    ## 6             6    28
    ## 7             7    33
    ## 8             8    24
    ## 9             9    23
    ## 10           10    25
    ## 11           11    24
    ## 12           12    28
    ## 13           13    27
    ## 14           14    28
    ## 15           15    32
    ## 16           16    28
    ## 17           17    21
    ## 18           18    22
    ## 19           19    24
    ## 20           20    30
    ## 21           21    35
    ## 22           22    22
    ## 23           23    30
    ## 24           24    25
    ## 25           25    29
    ## 26           26    34
    ## 27           27    31
    ## 28           28    32
    ## 29           29    36
    ## 30           30    34
    ## 31           31    26
    ## 32           32    29
    ## 33           33    21
    ## 34           34    24
    ## 35           35    32
    ## 36           36    27
    ## 37           37    23
    ## 38           38    34
    ## 39           39    29
    ## 40           40    27
    ## 41           41    25
    ## 42           42    30
    ## 43           43    24
    ## 44           44    26
    ## 45           45    27
    ## 46           46    34
    ## 47           47    22
    ## 48           48    17
    ## 49           49    28
    ## 50           50    35
    ## 51           51    33
    ## 52           52    29
    ## 53           53    30
    ## 54           54    29
    ## 55           55    22
    ## 56           56    30
    ## 57           57    28
    ## 58           58    27
    ## 59           59    27
    ## 60           60    25
    ## 61           61    14
    ## 62           62    23
    ## 63           63    25
    ## 64           64    33
    ## 65           65    22
    ## 66           66    34
    ## 67           67    22
    ## 68           68    22
    ## 69           69    25
    ## 70           70    18
    ## 71           71    30
    ## 72           72    30
    ## 73           73    24
    ## 74           74    27
    ## 75           75    41
    ## 76           76    23
    ## 77           77    28
    ## 78           78    31
    ## 79           79    22
    ## 80           80    30
    ## 81           81    22
    ## 82           82    26
    ## 83           83    25
    ## 84           84    33
    ## 85           85    23
    ## 86           86    33
    ## 87           87    30
    ## 88           88    21
    ## 89           89    32
    ## 90           90    28
    ## 91           91    35
    ## 92           92    28
    ## 93           93    23
    ## 94           94    21
    ## 95           95    18
    ## 96           96    27
    ## 97           97    18
    ## 98           98    25
    ## 99           99    24
    ## 100         100    24
    ## 101         101    24
    ## 102         102    33
    ## 103         103    31
    ## 104         104    24
    ## 105         105    26
    ## 106         106    23
    ## 107         107    30
    ## 108         108    30
    ## 109         109    26
    ## 110         110    14
    ## 111         111    26
    ## 112         112    30
    ## 113         113    29
    ## 114         114    33
    ## 115         115    30
    ## 116         116    27
    ## 117         117    19
    ## 118         118    21
    ## 119         119    34
    ## 120         120    32
    ## 121         121    26
    ## 122         122    32
    ## 123         123    24
    ## 124         124    18
    ## 125         125    32
    ## 126         126    28
    ## 127         127    24
    ## 128         128    32
    ## 129         129    34
    ## 130         130    24
    ## 131         131    30
    ## 132         132    28
    ## 133         133    27
    ## 134         134    23
    ## 135         135    30
    ## 136         136    15
    ## 137         137    39
    ## 138         138    34
    ## 139         139    27
    ## 140         140    18
    ## 141         141    32
    ## 142         142    26
    ## 143         143    22
    ## 144         144    42
    ## 145         145    28
    ## 146         146    29
    ## 147         147    34
    ## 148         148    46
    ## 149         149    26
    ## 150         150    25
    ## 151         151    27
    ## 152         152    21
    ## 153         153    24
    ## 154         154    30
    ## 155         155    25
    ## 156         156    25
    ## 157         157    31
    ## 158         158    32
    ## 159         159    21
    ## 160         160    27
    ## 161         161    30
    ## 162         162    20
    ## 163         163    29
    ## 164         164    16
    ## 165         165    21
    ## 166         166    28
    ## 167         167    32
    ## 168         168    34
    ## 169         169    22
    ## 170         170    26
    ## 171         171    26
    ## 172         172    33
    ## 173         173    29
    ## 174         174    21
    ## 175         175    24
    ## 176         176    37
    ## 177         177    23
    ## 178         178    39
    ## 179         179    29
    ## 180         180    23
    ## 181         181    34
    ## 182         182    26
    ## 183         183    23
    ## 184         184    23
    ## 185         185    23
    ## 186         186    31
    ## 187         187    28
    ## 188         188    25
    ## 189         189    22
    ## 190         190    27
    ## 191         191    20
    ## 192         192    23
    ## 193         193    25
    ## 194         194    18
    ## 195         195    19
    ## 196         196    35
    ## 197         197    40
    ## 198         198    37
    ## 199         199    25
    ## 200         200    27
    ## 201         201    25
    ## 202         202    26
    ## 203         203    20
    ## 204         204    35
    ## 205         205    18
    ## 206         206    27
    ## 207         207    34
    ## 208         208    26
    ## 209         209    32
    ## 210         210    31
    ## 211         211    34
    ## 212         212    20
    ## 213         213    28
    ## 214         214    31
    ## 215         215    26
    ## 216         216    23
    ## 217         217    23
    ## 218         218    18
    ## 219         219    26
    ## 220         220    27
    ## 221         221    28
    ## 222         222    21
    ## 223         223    17
    ## 224         224    22
    ## 225         225    26
    ## 226         226    21
    ## 227         227    24
    ## 228         228    27
    ## 229         229    25
    ## 230         230    33
    ## 231         231    26
    ## 232         232    25
    ## 233         233    23
    ## 234         234    26
    ## 235         235    25
    ## 236         236    42
    ## 237         237    33
    ## 238         238    21
    ## 239         239    34
    ## 240         240    26
    ## 241         241    34
    ## 242         242    32
    ## 243         243    24
    ## 244         244    32
    ## 245         245    32
    ## 246         246    23
    ## 247         247    22
    ## 248         248    15
    ## 249         249    23
    ## 250         250    20
    ## 251         251    31
    ## 252         252    22
    ## 253         253    29
    ## 254         254    32
    ## 255         255    18
    ## 256         256    30
    ## 257         257    37
    ## 258         258    24
    ## 259         259    32
    ## 260         260    31
    ## 261         261    26
    ## 262         262    28
    ## 263         263    29
    ## 264         264    25
    ## 265         265    29
    ## 266         266    28
    ## 267         267    36
    ## 268         268    29
    ## 269         269    30
    ## 270         270    25
    ## 271         271    18
    ## 272         272    20
    ## 273         273    35
    ## 274         274    35
    ## 275         275    30
    ## 276         276    28
    ## 277         277    32
    ## 278         278    26
    ## 279         279    31
    ## 280         280    27
    ## 281         281    14
    ## 282         282    27
    ## 283         283    28
    ## 284         284    28
    ## 285         285    26
    ## 286         286    27
    ## 287         287    29
    ## 288         288    24
    ## 289         289    30
    ## 290         290    28
    ## 291         291    23
    ## 292         292    27
    ## 293         293    31
    ## 294         294    26
    ## 295         295    38
    ## 296         296    30
    ## 297         297    33
    ## 298         298    26
    ## 299         299    30
    ## 300         300    31
    ## 301         301    21
    ## 302         302    29
    ## 303         303    26
    ## 304         304    26
    ## 305         305    25
    ## 306         306    32
    ## 307         307    30
    ## 308         308    25
    ## 309         309    31
    ## 310         310    20
    ## 311         311    23
    ## 312         312    26
    ## 313         313    23
    ## 314         314    33
    ## 315         315    17
    ## 316         316    29
    ## 317         317    28
    ## 318         318    12
    ## 319         319    30
    ## 320         320    20
    ## 321         321    22
    ## 322         322    28
    ## 323         323    31
    ## 324         324    25
    ## 325         325    22
    ## 326         326    25
    ## 327         327    26
    ## 328         328    23
    ## 329         329    32
    ## 330         330    25
    ## 331         331    27
    ## 332         332    28
    ## 333         333    27
    ## 334         334    30
    ## 335         335    23
    ## 336         336    30
    ## 337         337    29
    ## 338         338    28
    ## 339         339    30
    ## 340         340    31
    ## 341         341    23
    ## 342         342    32
    ## 343         343    25
    ## 344         344    18
    ## 345         345    23
    ## 346         346    32
    ## 347         347    30
    ## 348         348    36
    ## 349         349    29
    ## 350         350    23
    ## 351         351    24
    ## 352         352    23
    ## 353         353    18
    ## 354         354    36
    ## 355         355    20
    ## 356         356    30
    ## 357         357    26
    ## 358         358    21
    ## 359         359    25
    ## 360         360    34
    ## 361         361    31
    ## 362         362    32
    ## 363         363    29
    ## 364         364    23
    ## 365         365    23
    ## 366         366    37
    ## 367         367    22
    ## 368         368    35
    ## 369         369    25
    ## 370         370    19
    ## 371         371    35
    ## 372         372    34
    ## 373         373    35
    ## 374         374    28
    ## 375         375    24
    ## 376         376    28
    ## 377         377    26
    ## 378         378    19
    ## 379         379    23
    ## 380         380    36
    ## 381         381    35
    ## 382         382    24
    ## 383         383    27
    ## 384         384    25
    ## 385         385    26
    ## 386         386    29
    ## 387         387    26
    ## 388         388    30
    ## 389         389    26
    ## 390         390    33
    ## 391         391    30
    ## 392         392    23
    ## 393         393    31
    ## 394         394    22
    ## 395         395    19
    ## 396         396    27
    ## 397         397    29
    ## 398         398    16
    ## 399         399    21
    ## 400         400    28
    ## 401         401    21
    ## 402         402    20
    ## 403         403    35
    ## 404         404    30
    ## 405         405    32
    ## 406         406    32
    ## 407         407    27
    ## 408         408    30
    ## 409         409    23
    ## 410         410    38
    ## 411         411    26
    ## 412         412    21
    ## 413         413    21
    ## 414         414    25
    ## 415         415    23
    ## 416         416    31
    ## 417         417    25
    ## 418         418    30
    ## 419         419    25
    ## 420         420    21
    ## 421         421    27
    ## 422         422    26
    ## 423         423    26
    ## 424         424    30
    ## 425         425    26
    ## 426         426    27
    ## 427         427    24
    ## 428         428    20
    ## 429         429    21
    ## 430         430    22
    ## 431         431    23
    ## 432         432    23
    ## 433         433    25
    ## 434         434    27
    ## 435         435    25
    ## 436         436    30
    ## 437         437    23
    ## 438         438    33
    ## 439         439    36
    ## 440         440    22
    ## 441         441    28
    ## 442         442    32
    ## 443         443    22
    ## 444         444    30
    ## 445         445    26
    ## 446         446    31
    ## 447         447    29
    ## 448         448    29
    ## 449         449    20
    ## 450         450    26
    ## 451         451    33
    ## 452         452    32
    ## 453         453    23
    ## 454         454    33
    ## 455         455    24
    ## 456         456    25
    ## 457         457    28
    ## 458         458    19
    ## 459         459    38
    ## 460         460    25
    ## 461         461    28
    ## 462         462    33
    ## 463         463    25
    ## 464         464    16
    ## 465         465    17
    ## 466         466    23
    ## 467         467    29
    ## 468         468    39
    ## 469         469    40
    ## 470         470    32
    ## 471         471    27
    ## 472         472    30
    ## 473         473    34
    ## 474         474    26
    ## 475         475    24
    ## 476         476    22
    ## 477         477    22
    ## 478         478    19
    ## 479         479    31
    ## 480         480    22
    ## 481         481    29
    ## 482         482    29
    ## 483         483    18
    ## 484         484    30
    ## 485         485    29
    ## 486         486    26
    ## 487         487    26
    ## 488         488    22
    ## 489         489    21
    ## 490         490    24
    ## 491         491    27
    ## 492         492    16
    ## 493         493    23
    ## 494         494    31
    ## 495         495    26
    ## 496         496    21
    ## 497         497    28
    ## 498         498    27
    ## 499         499    30
    ## 500         500    28
    ## 501         501    21
    ## 502         502    34
    ## 503         503    32
    ## 504         504    28
    ## 505         505    21
    ## 506         506    35
    ## 507         507    25
    ## 508         508    25
    ## 509         509    20
    ## 510         510    26
    ## 511         511    24
    ## 512         512    26
    ## 513         513    31
    ## 514         514    22
    ## 515         515    28
    ## 516         516    26
    ## 517         517    25
    ## 518         518    26
    ## 519         519    23
    ## 520         520    32
    ## 521         521    23
    ## 522         522    33
    ## 523         523    22
    ## 524         524    19
    ## 525         525    19
    ## 526         526    45
    ## 527         527    24
    ## 528         528    25
    ## 529         529    29
    ## 530         530    23
    ## 531         531    25
    ## 532         532    32
    ## 533         533    33
    ## 534         534    24
    ## 535         535    32
    ## 536         536    25
    ## 537         537    25
    ## 538         538    29
    ## 539         539    22
    ## 540         540    24
    ## 541         541    24
    ## 542         542    18
    ## 543         543    22
    ## 544         544    22
    ## 545         545    21
    ## 546         546    25
    ## 547         547    23
    ## 548         548    19
    ## 549         549    20
    ## 550         550    32
    ## 551         551    26
    ## 552         552    21
    ## 553         553    24
    ## 554         554    22
    ## 555         555    17
    ## 556         556    21
    ## 557         557    24
    ## 558         558    28
    ## 559         559    28
    ## 560         560    30
    ## 561         561    27
    ## 562         562    25
    ## 563         563    29
    ## 564         564    24
    ## 565         565    29
    ## 566         566    34
    ## 567         567    20
    ## 568         568    21
    ## 569         569    32
    ## 570         570    26
    ## 571         571    24
    ## 572         572    25
    ## 573         573    29
    ## 574         574    28
    ## 575         575    29
    ## 576         576    34
    ## 577         577    27
    ## 578         578    22
    ## 579         579    27
    ## 580         580    27
    ## 581         581    27
    ## 582         582    25
    ## 583         583    23
    ## 584         584    30
    ## 585         585    24
    ## 586         586    19
    ## 587         587    26
    ## 588         588    29
    ## 589         589    28
    ## 590         590    25
    ## 591         591    27
    ## 592         592    29
    ## 593         593    26
    ## 594         594    27
    ## 595         595    30
    ## 596         596    28
    ## 597         597    25
    ## 598         598    22
    ## 599         599    19

## Exercise 6.3 - Repeat the previous query and sort by the count in descending order

``` r
dbGetQuery(con,"
SELECT customer_ID, COUNT(*) as count
FROM rental
GROUP BY customer_id
ORDER BY count DESC")
```

    ##     customer_id count
    ## 1           148    46
    ## 2           526    45
    ## 3           236    42
    ## 4           144    42
    ## 5            75    41
    ## 6           469    40
    ## 7           197    40
    ## 8           468    39
    ## 9           178    39
    ## 10          137    39
    ## 11          459    38
    ## 12          410    38
    ## 13          295    38
    ## 14            5    38
    ## 15          366    37
    ## 16          257    37
    ## 17          198    37
    ## 18          176    37
    ## 19          439    36
    ## 20          380    36
    ## 21          354    36
    ## 22          348    36
    ## 23          267    36
    ## 24           29    36
    ## 25          506    35
    ## 26          403    35
    ## 27          381    35
    ## 28          373    35
    ## 29          371    35
    ## 30          368    35
    ## 31          274    35
    ## 32          273    35
    ## 33          204    35
    ## 34          196    35
    ## 35           91    35
    ## 36           50    35
    ## 37           21    35
    ## 38          576    34
    ## 39          566    34
    ## 40          502    34
    ## 41          473    34
    ## 42          372    34
    ## 43          360    34
    ## 44          241    34
    ## 45          239    34
    ## 46          211    34
    ## 47          207    34
    ## 48          181    34
    ## 49          168    34
    ## 50          147    34
    ## 51          138    34
    ## 52          129    34
    ## 53          119    34
    ## 54           66    34
    ## 55           46    34
    ## 56           38    34
    ## 57           30    34
    ## 58           26    34
    ## 59          533    33
    ## 60          522    33
    ## 61          462    33
    ## 62          454    33
    ## 63          451    33
    ## 64          438    33
    ## 65          390    33
    ## 66          314    33
    ## 67          297    33
    ## 68          237    33
    ## 69          230    33
    ## 70          172    33
    ## 71          114    33
    ## 72          102    33
    ## 73           86    33
    ## 74           84    33
    ## 75           64    33
    ## 76           51    33
    ## 77            7    33
    ## 78          569    32
    ## 79          550    32
    ## 80          535    32
    ## 81          532    32
    ## 82          520    32
    ## 83          503    32
    ## 84          470    32
    ## 85          452    32
    ## 86          442    32
    ## 87          406    32
    ## 88          405    32
    ## 89          362    32
    ## 90          346    32
    ## 91          342    32
    ## 92          329    32
    ## 93          306    32
    ## 94          277    32
    ## 95          259    32
    ## 96          254    32
    ## 97          245    32
    ## 98          244    32
    ## 99          242    32
    ## 100         209    32
    ## 101         167    32
    ## 102         158    32
    ## 103         141    32
    ## 104         128    32
    ## 105         125    32
    ## 106         122    32
    ## 107         120    32
    ## 108          89    32
    ## 109          35    32
    ## 110          28    32
    ## 111          15    32
    ## 112           1    32
    ## 113         513    31
    ## 114         494    31
    ## 115         479    31
    ## 116         446    31
    ## 117         416    31
    ## 118         393    31
    ## 119         361    31
    ## 120         340    31
    ## 121         323    31
    ## 122         309    31
    ## 123         300    31
    ## 124         293    31
    ## 125         279    31
    ## 126         260    31
    ## 127         251    31
    ## 128         214    31
    ## 129         210    31
    ## 130         186    31
    ## 131         157    31
    ## 132         103    31
    ## 133          78    31
    ## 134          27    31
    ## 135         595    30
    ## 136         584    30
    ## 137         560    30
    ## 138         499    30
    ## 139         484    30
    ## 140         472    30
    ## 141         444    30
    ## 142         436    30
    ## 143         424    30
    ## 144         418    30
    ## 145         408    30
    ## 146         404    30
    ## 147         391    30
    ## 148         388    30
    ## 149         356    30
    ## 150         347    30
    ## 151         339    30
    ## 152         336    30
    ## 153         334    30
    ## 154         319    30
    ## 155         307    30
    ## 156         299    30
    ## 157         296    30
    ## 158         289    30
    ## 159         275    30
    ## 160         269    30
    ## 161         256    30
    ## 162         161    30
    ## 163         154    30
    ## 164         135    30
    ## 165         131    30
    ## 166         115    30
    ## 167         112    30
    ## 168         108    30
    ## 169         107    30
    ## 170          87    30
    ## 171          80    30
    ## 172          72    30
    ## 173          71    30
    ## 174          56    30
    ## 175          53    30
    ## 176          42    30
    ## 177          23    30
    ## 178          20    30
    ## 179         592    29
    ## 180         588    29
    ## 181         575    29
    ## 182         573    29
    ## 183         565    29
    ## 184         563    29
    ## 185         538    29
    ## 186         529    29
    ## 187         485    29
    ## 188         482    29
    ## 189         481    29
    ## 190         467    29
    ## 191         448    29
    ## 192         447    29
    ## 193         397    29
    ## 194         386    29
    ## 195         363    29
    ## 196         349    29
    ## 197         337    29
    ## 198         316    29
    ## 199         302    29
    ## 200         287    29
    ## 201         268    29
    ## 202         265    29
    ## 203         263    29
    ## 204         253    29
    ## 205         179    29
    ## 206         173    29
    ## 207         163    29
    ## 208         146    29
    ## 209         113    29
    ## 210          54    29
    ## 211          52    29
    ## 212          39    29
    ## 213          32    29
    ## 214          25    29
    ## 215         596    28
    ## 216         589    28
    ## 217         574    28
    ## 218         559    28
    ## 219         558    28
    ## 220         515    28
    ## 221         504    28
    ## 222         500    28
    ## 223         497    28
    ## 224         461    28
    ## 225         457    28
    ## 226         441    28
    ## 227         400    28
    ## 228         376    28
    ## 229         374    28
    ## 230         338    28
    ## 231         332    28
    ## 232         322    28
    ## 233         317    28
    ## 234         290    28
    ## 235         284    28
    ## 236         283    28
    ## 237         276    28
    ## 238         266    28
    ## 239         262    28
    ## 240         221    28
    ## 241         213    28
    ## 242         187    28
    ## 243         166    28
    ## 244         145    28
    ## 245         132    28
    ## 246         126    28
    ## 247          92    28
    ## 248          90    28
    ## 249          77    28
    ## 250          57    28
    ## 251          49    28
    ## 252          16    28
    ## 253          14    28
    ## 254          12    28
    ## 255           6    28
    ## 256         594    27
    ## 257         591    27
    ## 258         581    27
    ## 259         580    27
    ## 260         579    27
    ## 261         577    27
    ## 262         561    27
    ## 263         498    27
    ## 264         491    27
    ## 265         471    27
    ## 266         434    27
    ## 267         426    27
    ## 268         421    27
    ## 269         407    27
    ## 270         396    27
    ## 271         383    27
    ## 272         333    27
    ## 273         331    27
    ## 274         292    27
    ## 275         286    27
    ## 276         282    27
    ## 277         280    27
    ## 278         228    27
    ## 279         220    27
    ## 280         206    27
    ## 281         200    27
    ## 282         190    27
    ## 283         160    27
    ## 284         151    27
    ## 285         139    27
    ## 286         133    27
    ## 287         116    27
    ## 288          96    27
    ## 289          74    27
    ## 290          59    27
    ## 291          58    27
    ## 292          45    27
    ## 293          40    27
    ## 294          36    27
    ## 295          13    27
    ## 296           2    27
    ## 297         593    26
    ## 298         587    26
    ## 299         570    26
    ## 300         551    26
    ## 301         518    26
    ## 302         516    26
    ## 303         512    26
    ## 304         510    26
    ## 305         495    26
    ## 306         487    26
    ## 307         486    26
    ## 308         474    26
    ## 309         450    26
    ## 310         445    26
    ## 311         425    26
    ## 312         423    26
    ## 313         422    26
    ## 314         411    26
    ## 315         389    26
    ## 316         387    26
    ## 317         385    26
    ## 318         377    26
    ## 319         357    26
    ## 320         327    26
    ## 321         312    26
    ## 322         304    26
    ## 323         303    26
    ## 324         298    26
    ## 325         294    26
    ## 326         285    26
    ## 327         278    26
    ## 328         261    26
    ## 329         240    26
    ## 330         234    26
    ## 331         231    26
    ## 332         225    26
    ## 333         219    26
    ## 334         215    26
    ## 335         208    26
    ## 336         202    26
    ## 337         182    26
    ## 338         171    26
    ## 339         170    26
    ## 340         149    26
    ## 341         142    26
    ## 342         121    26
    ## 343         111    26
    ## 344         109    26
    ## 345         105    26
    ## 346          82    26
    ## 347          44    26
    ## 348          31    26
    ## 349           3    26
    ## 350         597    25
    ## 351         590    25
    ## 352         582    25
    ## 353         572    25
    ## 354         562    25
    ## 355         546    25
    ## 356         537    25
    ## 357         536    25
    ## 358         531    25
    ## 359         528    25
    ## 360         517    25
    ## 361         508    25
    ## 362         507    25
    ## 363         463    25
    ## 364         460    25
    ## 365         456    25
    ## 366         435    25
    ## 367         433    25
    ## 368         419    25
    ## 369         417    25
    ## 370         414    25
    ## 371         384    25
    ## 372         369    25
    ## 373         359    25
    ## 374         343    25
    ## 375         330    25
    ## 376         326    25
    ## 377         324    25
    ## 378         308    25
    ## 379         305    25
    ## 380         270    25
    ## 381         264    25
    ## 382         235    25
    ## 383         232    25
    ## 384         229    25
    ## 385         201    25
    ## 386         199    25
    ## 387         193    25
    ## 388         188    25
    ## 389         156    25
    ## 390         155    25
    ## 391         150    25
    ## 392          98    25
    ## 393          83    25
    ## 394          69    25
    ## 395          63    25
    ## 396          60    25
    ## 397          41    25
    ## 398          24    25
    ## 399          10    25
    ## 400         585    24
    ## 401         571    24
    ## 402         564    24
    ## 403         557    24
    ## 404         553    24
    ## 405         541    24
    ## 406         540    24
    ## 407         534    24
    ## 408         527    24
    ## 409         511    24
    ## 410         490    24
    ## 411         475    24
    ## 412         455    24
    ## 413         427    24
    ## 414         382    24
    ## 415         375    24
    ## 416         351    24
    ## 417         288    24
    ## 418         258    24
    ## 419         243    24
    ## 420         227    24
    ## 421         175    24
    ## 422         153    24
    ## 423         130    24
    ## 424         127    24
    ## 425         123    24
    ## 426         104    24
    ## 427         101    24
    ## 428         100    24
    ## 429          99    24
    ## 430          73    24
    ## 431          43    24
    ## 432          34    24
    ## 433          19    24
    ## 434          11    24
    ## 435           8    24
    ## 436         583    23
    ## 437         547    23
    ## 438         530    23
    ## 439         521    23
    ## 440         519    23
    ## 441         493    23
    ## 442         466    23
    ## 443         453    23
    ## 444         437    23
    ## 445         432    23
    ## 446         431    23
    ## 447         415    23
    ## 448         409    23
    ## 449         392    23
    ## 450         379    23
    ## 451         365    23
    ## 452         364    23
    ## 453         352    23
    ## 454         350    23
    ## 455         345    23
    ## 456         341    23
    ## 457         335    23
    ## 458         328    23
    ## 459         313    23
    ## 460         311    23
    ## 461         291    23
    ## 462         249    23
    ## 463         246    23
    ## 464         233    23
    ## 465         217    23
    ## 466         216    23
    ## 467         192    23
    ## 468         185    23
    ## 469         184    23
    ## 470         183    23
    ## 471         180    23
    ## 472         177    23
    ## 473         134    23
    ## 474         106    23
    ## 475          93    23
    ## 476          85    23
    ## 477          76    23
    ## 478          62    23
    ## 479          37    23
    ## 480           9    23
    ## 481         598    22
    ## 482         578    22
    ## 483         554    22
    ## 484         544    22
    ## 485         543    22
    ## 486         539    22
    ## 487         523    22
    ## 488         514    22
    ## 489         488    22
    ## 490         480    22
    ## 491         477    22
    ## 492         476    22
    ## 493         443    22
    ## 494         440    22
    ## 495         430    22
    ## 496         394    22
    ## 497         367    22
    ## 498         325    22
    ## 499         321    22
    ## 500         252    22
    ## 501         247    22
    ## 502         224    22
    ## 503         189    22
    ## 504         169    22
    ## 505         143    22
    ## 506          81    22
    ## 507          79    22
    ## 508          68    22
    ## 509          67    22
    ## 510          65    22
    ## 511          55    22
    ## 512          47    22
    ## 513          22    22
    ## 514          18    22
    ## 515           4    22
    ## 516         568    21
    ## 517         556    21
    ## 518         552    21
    ## 519         545    21
    ## 520         505    21
    ## 521         501    21
    ## 522         496    21
    ## 523         489    21
    ## 524         429    21
    ## 525         420    21
    ## 526         413    21
    ## 527         412    21
    ## 528         401    21
    ## 529         399    21
    ## 530         358    21
    ## 531         301    21
    ## 532         238    21
    ## 533         226    21
    ## 534         222    21
    ## 535         174    21
    ## 536         165    21
    ## 537         159    21
    ## 538         152    21
    ## 539         118    21
    ## 540          94    21
    ## 541          88    21
    ## 542          33    21
    ## 543          17    21
    ## 544         567    20
    ## 545         549    20
    ## 546         509    20
    ## 547         449    20
    ## 548         428    20
    ## 549         402    20
    ## 550         355    20
    ## 551         320    20
    ## 552         310    20
    ## 553         272    20
    ## 554         250    20
    ## 555         212    20
    ## 556         203    20
    ## 557         191    20
    ## 558         162    20
    ## 559         599    19
    ## 560         586    19
    ## 561         548    19
    ## 562         525    19
    ## 563         524    19
    ## 564         478    19
    ## 565         458    19
    ## 566         395    19
    ## 567         378    19
    ## 568         370    19
    ## 569         195    19
    ## 570         117    19
    ## 571         542    18
    ## 572         483    18
    ## 573         353    18
    ## 574         344    18
    ## 575         271    18
    ## 576         255    18
    ## 577         218    18
    ## 578         205    18
    ## 579         194    18
    ## 580         140    18
    ## 581         124    18
    ## 582          97    18
    ## 583          95    18
    ## 584          70    18
    ## 585         555    17
    ## 586         465    17
    ## 587         315    17
    ## 588         223    17
    ## 589          48    17
    ## 590         492    16
    ## 591         464    16
    ## 592         398    16
    ## 593         164    16
    ## 594         248    15
    ## 595         136    15
    ## 596         281    14
    ## 597         110    14
    ## 598          61    14
    ## 599         318    12

## Exercise 6.4 - Repeat the previous query but use HAVING to only keep the groups with 40 or more.

``` r
dbGetQuery(con,"
SELECT customer_ID, COUNT(*) as count
FROM rental
GROUP BY customer_id
HAVING count >= 40
ORDER BY count DESC
LIMIT 8
")
```

    ##   customer_id count
    ## 1         148    46
    ## 2         526    45
    ## 3         236    42
    ## 4         144    42
    ## 5          75    41
    ## 6         469    40
    ## 7         197    40

``` r
# clean up
dbDisconnect(con)
```
