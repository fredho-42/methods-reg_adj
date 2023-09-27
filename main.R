library(tidyverse)
library(gtsummary)

# dat <- haven::read_dta('./data/stata/stata13_se/hse16_eul_v5.dta')

datc <- dat |> 
  transmute(
    age=case_when(
      ag16g10 == 1 ~ 20, 
      ag16g10 == 2 ~ 30, 
      ag16g10 == 3 ~ 40, 
      ag16g10 == 4 ~ 50, 
      ag16g10 == 5 ~ 60, 
      ag16g10 == 6 ~ 70, 
      ag16g10 == 7 ~ 80, 
      .default=NA
    ), 
    sex=if_else(Sex<0, NA, Sex), 
    educ=case_when(
      EducEnd == 8 ~ 1, 
      EducEnd <  0 ~ NA, 
      .default = 0), 
    pa  =case_when(
      recs12_2 < 0 ~ NA,  
      recs12_2 == 3 ~ 1, 
      .default=0), 
    bmi = if_else(BMI < 0, NA, BMI), 
    sbp = if_else(omsysval < 0, NA, omsysval), 
    statin=if_else(LipidTakg2 < 0, NA, LipidTakg2), 
    obs=if_else(BMI < 0, NA, if_else(BMI > 30, 1, 0)), 
    ill=if_else(condlcnt2 < 0, NA, condlcnt2), 
    
    hba1c=if_else(IFCCA1 < 0, NA, IFCCA1), 
  ) |> 
  na.omit()


m0 <- lm(hba1c ~ pa, data=datc)
m1 <- m0 |> update(~ . + age + sex + educ)
m2 <- m1 |> update(~ . + obs)
m3 <- m1 |> update(~ . + ill)


tbl_stack(
  list(
    m0 |> tbl_regression(include = 'pa'), 
    m1 |> tbl_regression(include = 'pa'), 
    m2 |> tbl_regression(include = 'pa'), 
    m3 |> tbl_regression(include = 'pa')
  )) |> 
  as_flex_table() |> 
  flextable::save_as_docx(path = './export/tab1.docx')
