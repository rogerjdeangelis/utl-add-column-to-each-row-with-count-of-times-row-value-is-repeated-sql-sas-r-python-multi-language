%let pgm=utl-add-column-to-each-row-with-count-of-times-row-value-is-repeated-sql-sas-r-python-multi-language;

%stop_submission;

Add column to each row with number of times a row value is repeated sql sas r python multi language

     SOLUTIONS

        1 sas sql
        2 r sql
        3 python sql

github
https://tinyurl.com/2kumz8ut
https://github.com/rogerjdeangelis/utl-add-column-to-each-row-with-count-of-times-row-value-is-repeated-sql-sas-r-python-multi-language

stackoverflow r
https://stackoverflow.com/questions/79173937/r-add-column-to-dataset-with-number-of-times-that-a-row-value-is-repeated

SOAPBOX ON

ISSUE (NONE ARE SELF EXPLANATORY?)

  Six R solutions and six different R 'syntax/languages'
  Less is more ?. Just SQL?

   1  rle
   2  dplyr
   3  base R
   4  tigyr

   IBM was very caucious about expamding the
   syntax of PL/1. PL/1 as the basis for the
   version 1 of sas

SOAPBOX OFF

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/


/************************************************************************************************************************/
/*                          |                                         |                                                 */
/*            INPUT         |      PROCESSES                          |          OUTPUT                                 */
/*            -----         |     ----------                          |          ------                                 */
/*                          |                                         |                                                 */
/*        A          B      | SAS (AUTOMATIC REMERGING)               |     A          B       C                        */
/*                          | -------------------------               |                                                 */
/*      John      Student   |    SELF EXPANATORY?                     |   John      Student    3                        */
/*      John      Student   |                                         |   John      Student    3                        */
/*      John      Student   | The query requires remerging            |   John      Student    3                        */
/*      Sarah     Student   | summary statistics                      |   Sarah     Student    2                        */
/*      Sarah     Student   | back with the original data             |   Sarah     Student    2                        */
/*      Mickey    Student   |                                         |   Mickey    Student    1                        */
/*                          |   select                                |                                                 */
/*                          |      a                                  |                                                 */
/*                          |     ,b                                  |                                                 */
/*                          |     ,count(a) as c                      |                                                 */
/*                          |   from                                  |                                                 */
/*                          |      sd1.have                           |                                                 */
/*                          |   group                                 |                                                 */
/*                          |      by a                               |                                                 */
/*                          |                                         |                                                 */
/*                          |==-------------------------------------==|                                                 */
/*                          |                                         |                                                 */
/*                          |  R  and PYTHON                          |                                                 */
/*                          |  (NO ATTOMATIC REMERGING MANUAL REMERGE |                                                 */
/*                          |                                         |                                                 */
/*                          |  with                                   |                                                 */
/*                          |     cnt as (                            |                                                 */
/*                          |  select                                 |                                                 */
/*                          |     a                                   |                                                 */
/*                          |    ,b                                   |                                                 */
/*                          |    ,count(a) as c                       |                                                 */
/*                          |  from                                   |                                                 */
/*                          |     have                                |                                                 */
/*                          |  group                                  |                                                 */
/*                          |     by a )                              |                                                 */
/*                          |  select                                 |                                                 */
/*                          |     l.*                                 |                                                 */
/*                          |    ,r.c                                 |                                                 */
/*                          |  from                                   |                                                 */
/*                          |     have as l left join cnt as r        |                                                 */
/*                          |  on l.a = r.a                           |                                                 */
/*                          |                                         |                                                 */
/*                          |==---------------------------------------|                                                 */
/*                          |                                         |                                                 */
/*                          |  SIX R SOLUTIOND                        |                                                 */
/*                          |==-------------------------------------  |                                                 */
/*                          |                                         |                                                 */
/*                          |  transform(people, C =                  |                                                 */
/*                          |   unsplit(lapply(split(people, ~ A)     |                                                 */
/*                          |   ,nrow), A))                           |                                                 */
/*                          |                                         |                                                 */
/*                          |==------------------------------------   |                                                 */
/*                          |                                         |                                                 */
/*                          |  aggregate(cbind(C = people$A), people  |                                                 */
/*                          |   ,\(x) rep(length(x), length(x))) |>   |                                                 */
/*                          |   unnest(C)                             |                                                 */
/*                          |                                         |                                                 */
/*                          |==---------------------------------------|                                                 */
/*                          |                                         |                                                 */
/*                          |  transform(people, C =                  |                                                 */
/*                          |    unlist(aggregate(cbind(C = A)        |                                                 */
/*                          |   ,people, \(x)                         |                                                 */
/*                          |  setNames(rep(length(x)                 |                                                 */
/*                          |   ,length(x)), x))$C)[A])               |                                                 */
/*                          |                                         |                                                 */
/*                          |-----------------------------------------|                                                 */
/*                          |                                         |                                                 */
/*                          |  people$C <- as.numeric(ave(people$A    |                                                 */
/*                          |  ,people$A, FUN = length))              |                                                 */
/*                          |                                         |                                                 */
/*                          |-----------------------------------------|                                                 */
/*                          |                                         |                                                 */
/*                          |  people$C <- with(rle(people$A)         |                                                 */
/*                          |   ,rep(lengths, lengths))               |                                                 */
/*                          |                                         |                                                 */
/*                          |-----------------------------------------|                                                 */
/*                          |                                         |                                                 */
/*                          |  people %>% mutate(C = n(), .by = A)    |                                                 */
/*                          |                                         |                                                 */
/************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data sd1.norm;
options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input   A$       B$;
cards4;
John Student
John Student
John Student
Sarah Student
Sarah Student
Mickey Student
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  SD1.HAVE total obs=6                                                                                                  */
/*                                                                                                                        */
/*     A          B                                                                                                       */
/*                                                                                                                        */
/*   John      Student                                                                                                    */
/*   John      Student                                                                                                    */
/*   John      Student                                                                                                    */
/*   Sarah     Student                                                                                                    */
/*   Sarah     Student                                                                                                    */
/*   Mickey    Student                                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
     table want as
  select
     a
    ,b
    ,count(a) as c
  from
     sd1.have
  group
     by a
;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  SD1.PYWANT total obs=6                                                                                                */
/*                                                                                                                        */
/*     A          B       C                                                                                               */
/*                                                                                                                        */
/*   John      Student    3                                                                                               */
/*   John      Student    3                                                                                               */
/*   John      Student    3                                                                                               */
/*   Sarah     Student    2                                                                                               */
/*   Sarah     Student    2                                                                                               */
/*   Mickey    Student    1                                                                                               */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have <- read_sas("d:/sd1/have.sas7bdat")
want <- sqldf('
  with
     cnt as (
  select
     a
    ,b
    ,count(a) as c
  from
     have
  group
     by a )
  select
     l.*
    ,r.c
  from
     have as l left join cnt as r
  on l.a = r.a

  ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                    |                                                                                                   */
/*  R                 | SAS                                                                                               */
/*                    |                                                                                                   */
/*  want              |                                                                                                   */
/*       A       B C  | ROWNAMES      A          B       C                                                                */
/*                    |                                                                                                   */
/*    John Student 3  |     1       John      Student    3                                                                */
/*    John Student 3  |     2       John      Student    3                                                                */
/*    John Student 3  |     3       John      Student    3                                                                */
/*   Sarah Student 2  |     4       Sarah     Student    2                                                                */
/*   Sarah Student 2  |     5       Sarah     Student    2                                                                */
/*  Mickey Student 1  |     6       Mickey    Student    1                                                                */
/*                    |                                                                                                   */
/**************************************************************************************************************************/

 /*____               _   _
|___ /   _ __  _   _| |_| |__   ___  _ __
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \
 ___) | | |_) | |_| | |_| | | | (_) | | | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_|
        |_|    |___/
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
want=pdsql('''
  with
     cnt as (
  select
     a
    ,b
    ,count(a) as c
  from
     have
  group
     by a )
  select
     l.*
    ,r.c
  from
     have as l left join cnt as r
  on l.a = r.a
''')
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                         |                                                                                              */
/*  PYTHON                 |  SAS                                                                                         */
/*                         |                                                                                              */
/*          A        B  C  |  Obs      A          B       C                                                               */
/*                         |                                                                                              */
/*  0    John  Student  3  |   1     John      Student    3                                                               */
/*  1    John  Student  3  |   2     John      Student    3                                                               */
/*  2    John  Student  3  |   3     John      Student    3                                                               */
/*  3   Sarah  Student  2  |   4     Sarah     Student    2                                                               */
/*  4   Sarah  Student  2  |   5     Sarah     Student    2                                                               */
/*  5  Mickey  Student  1  |   6     Mickey    Student    1                                                               */
/*                         |                                                                                              */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
