Medicare Drug Spending
================

``` r
library(feather)
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
library(jsonlite)
```

    ## 
    ## Attaching package: 'jsonlite'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     flatten

``` r
## -- Spending data --------------------------------------------------------------------------------
## Read in drug names (brand + generic)
drugnames <- read_feather('data/drugnames.feather')

## Function to add a column with spending year to a data frame
add_drug_year <- function(df, yr){
  mutate(df, drug_year = yr)
}

drug.years <- 2011:2015

## Read in each year's data set, add year and drug names, and combine into a single data.frame
spending.data <- map(paste0('data/spending-', drug.years, '.feather'), read_feather) %>%
  map2(drug.years, add_drug_year) %>%
  map(bind_cols, drugnames) %>%
  bind_rows()
```

``` r
head(spending.data)
```

    ## # A tibble: 6 × 13
    ##   claim_count total_spending user_count total_spending_per_user unit_count
    ##         <dbl>          <dbl>      <dbl>                   <dbl>      <dbl>
    ## 1          24        1569.19         16                98.07438       5170
    ## 2        2472       57666.73        893                64.57641     293160
    ## 3          NA             NA         NA                      NA         NA
    ## 4          12         350.10         11                31.82727        497
    ## 5          11        9003.26         NA                      NA        298
    ## 6          30         212.86         29                 7.34000        451
    ## # ... with 8 more variables: unit_cost_wavg <dbl>,
    ## #   user_count_non_lowincome <dbl>, out_of_pocket_avg_non_lowincome <dbl>,
    ## #   user_count_lowincome <dbl>, out_of_pocket_avg_lowincome <dbl>,
    ## #   drug_year <int>, drugname_brand <chr>, drugname_generic <chr>

``` r
## -- Combine data by year for all brand names for the same generic --------------------------------
spending.data.bygeneric <- spending.data %>%
  group_by(drug_year, drugname_generic) %>%
  summarise(claim_count = sum(claim_count, na.rm = TRUE),
            total_spending = sum(total_spending, na.rm = TRUE),
            user_count = sum(user_count, na.rm = TRUE),
            total_spending_per_user = sum(total_spending_per_user, na.rm = TRUE),
            unit_count = sum(unit_count, na.rm = TRUE),
            user_count_non_lowincome = sum(user_count_non_lowincome, na.rm = TRUE),
            out_of_pocket_avg_non_lowincome = sum(out_of_pocket_avg_non_lowincome, na.rm = TRUE),
            user_count_lowincome = sum(user_count_lowincome, na.rm = TRUE),
            out_of_pocket_avg_lowincome = sum(out_of_pocket_avg_lowincome, na.rm = TRUE))
```

``` r
## -- Therapeutic areas ----------------------------------------------------------------------------
## Read in JSON
therapeutic.areas <- read_json('data/drug_list.json', simplifyDataFrame = TRUE)

all.areas <- unique(flatten_chr(therapeutic.areas$therapeutic_areas))
area.abbrevs <- c('cardiology', 'immunology', 'otolaryngology', 'pulmonary', 'family', 'infection',
                  'neurology', 'sleep', 'musculoskeletal', 'orthopedic', 'gastroenterology',
                  'pediatrics', 'vaccine', 'hepatology', 'oncology', 'ophthalmology', 'nephrology',
                  'urology', 'genetic', 'endocrinology', 'rheumatology', 'psychiatry', 'hematology',
                  'pharmacology', 'nutrition', 'dermatology', 'podiatry', 'obgyn', 'healthyvols',
                  'trauma', 'device', 'internal', 'dental')

## Create indicators for whether each drug is in each unique therapeutic area
## Areas are lists in column therapeutic_areas; write function to determine if a given area is
## included for a particular drug
in_this_area <- function(area, df){
  indicator.col <- rep(FALSE, nrow(df))
  indicator.col[grep(area, df$therapeutic_areas, fixed = TRUE)] <- TRUE
  indicator.col
}

## Iterate over all unique therapeutic areas and combine into a matrix -> data.frame
area.indicators <- do.call(cbind,
                           map(all.areas, in_this_area, df = therapeutic.areas)) %>%
  as.data.frame()

## Give useful column names
names(area.indicators) <- paste0('used.', area.abbrevs)

## Bind indicators with original data set
therapeutic.areas <- bind_cols(therapeutic.areas, area.indicators)
```

``` r
head(therapeutic.areas)
```

    ##                                                                                                                     therapeutic_areas
    ## 1                                                                                                        Cardiology/Vascular Diseases
    ## 2 Immunology, Otolaryngology (Ear, Nose, Throat), Pulmonary/Respiratory Diseases, Family Medicine, Infections and Infectious Diseases
    ## 3                                                                                                   Neurology, Family Medicine, Sleep
    ## 4                                                         Musculoskeletal, Neurology, Family Medicine, Orthopedics/Orthopedic Surgery
    ## 5                                                      Immunology, Pulmonary/Respiratory Diseases, Infections and Infectious Diseases
    ## 6                                                                                                  Otolaryngology (Ear, Nose, Throat)
    ##                                                     name
    ## 1                                                Niaspan
    ## 2                                     Cedax (ceftibuten)
    ## 3                                      Silenor (doxepin)
    ## 4 Amrix (cyclobenzaprine hydrochloride extended release)
    ## 5                                Zyrtec (cetirizine HCl)
    ## 6        Bactroban Nasal 2% (mupirocin calcium ointment)
    ##          approval_status             company
    ## 1       October 28, 1999 Kos Pharmaceuticals
    ## 2 Approved December 1995     Schering-Plough
    ## 3    Approved March 2010      Somaxon Pharma
    ## 4 Approved February 2007            Cephalon
    ## 5 Approved December 1995              Pfizer
    ## 6    Approved April 1996  SmithKline Beecham
    ##                                                                            specific_treatment
    ## 1 Treatment for increasing HDL cholesterol ("good cholesterol") in patients with dyslipidemia
    ## 2                    chronic bronchitis, infection of the middle ear, pharyngitis/tonsillitis
    ## 3                                                                                    insomnia
    ## 4                      muscle spasm associated with acute, painful musculoskeletal conditions
    ## 5                                                                                     allergy
    ## 6                                                                              nasal bacteria
    ##   used.cardiology used.immunology used.otolaryngology used.pulmonary
    ## 1            TRUE           FALSE               FALSE          FALSE
    ## 2           FALSE            TRUE                TRUE           TRUE
    ## 3           FALSE           FALSE               FALSE          FALSE
    ## 4           FALSE           FALSE               FALSE          FALSE
    ## 5           FALSE            TRUE               FALSE           TRUE
    ## 6           FALSE           FALSE                TRUE          FALSE
    ##   used.family used.infection used.neurology used.sleep
    ## 1       FALSE          FALSE          FALSE      FALSE
    ## 2        TRUE           TRUE          FALSE      FALSE
    ## 3        TRUE          FALSE           TRUE       TRUE
    ## 4        TRUE          FALSE           TRUE      FALSE
    ## 5       FALSE           TRUE          FALSE      FALSE
    ## 6       FALSE          FALSE          FALSE      FALSE
    ##   used.musculoskeletal used.orthopedic used.gastroenterology
    ## 1                FALSE           FALSE                 FALSE
    ## 2                FALSE           FALSE                 FALSE
    ## 3                FALSE           FALSE                 FALSE
    ## 4                 TRUE            TRUE                 FALSE
    ## 5                FALSE           FALSE                 FALSE
    ## 6                FALSE           FALSE                 FALSE
    ##   used.pediatrics used.vaccine used.hepatology used.oncology
    ## 1           FALSE        FALSE           FALSE         FALSE
    ## 2           FALSE        FALSE           FALSE         FALSE
    ## 3           FALSE        FALSE           FALSE         FALSE
    ## 4           FALSE        FALSE           FALSE         FALSE
    ## 5           FALSE        FALSE           FALSE         FALSE
    ## 6           FALSE        FALSE           FALSE         FALSE
    ##   used.ophthalmology used.nephrology used.urology used.genetic
    ## 1              FALSE           FALSE        FALSE        FALSE
    ## 2              FALSE           FALSE        FALSE        FALSE
    ## 3              FALSE           FALSE        FALSE        FALSE
    ## 4              FALSE           FALSE        FALSE        FALSE
    ## 5              FALSE           FALSE        FALSE        FALSE
    ## 6              FALSE           FALSE        FALSE        FALSE
    ##   used.endocrinology used.rheumatology used.psychiatry used.hematology
    ## 1              FALSE             FALSE           FALSE           FALSE
    ## 2              FALSE             FALSE           FALSE           FALSE
    ## 3              FALSE             FALSE           FALSE           FALSE
    ## 4              FALSE             FALSE           FALSE           FALSE
    ## 5              FALSE             FALSE           FALSE           FALSE
    ## 6              FALSE             FALSE           FALSE           FALSE
    ##   used.pharmacology used.nutrition used.dermatology used.podiatry
    ## 1             FALSE          FALSE            FALSE         FALSE
    ## 2             FALSE          FALSE            FALSE         FALSE
    ## 3             FALSE          FALSE            FALSE         FALSE
    ## 4             FALSE          FALSE            FALSE         FALSE
    ## 5             FALSE          FALSE            FALSE         FALSE
    ## 6             FALSE          FALSE            FALSE         FALSE
    ##   used.obgyn used.healthyvols used.trauma used.device used.internal
    ## 1      FALSE            FALSE       FALSE       FALSE         FALSE
    ## 2      FALSE            FALSE       FALSE       FALSE         FALSE
    ## 3      FALSE            FALSE       FALSE       FALSE         FALSE
    ## 4      FALSE            FALSE       FALSE       FALSE         FALSE
    ## 5      FALSE            FALSE       FALSE       FALSE         FALSE
    ## 6      FALSE            FALSE       FALSE       FALSE         FALSE
    ##   used.dental
    ## 1       FALSE
    ## 2       FALSE
    ## 3       FALSE
    ## 4       FALSE
    ## 5       FALSE
    ## 6       FALSE

Out-of-pocket cost over time for low-income vs non-low-income users of aripiprazole (Aricept)
=============================================================================================

``` r
plotdata <- spending.data.bygeneric %>%
  filter(drugname_generic == 'ARIPIPRAZOLE ') %>%
  select(drug_year, out_of_pocket_avg_lowincome, out_of_pocket_avg_non_lowincome) %>%
  gather(key = income_level, value = out_of_pocket,
         out_of_pocket_avg_lowincome:out_of_pocket_avg_non_lowincome) %>%
  mutate(income_level = gsub('out_of_pocket_avg_', '', income_level, fixed = TRUE))

ggplot(data = plotdata, aes(x = drug_year, y = out_of_pocket)) +
  geom_line(aes(group = income_level, colour = income_level)) +
  geom_point(aes(group = income_level, colour = income_level)) +
  scale_colour_manual(values = c('#003D79', '#258CF0')) +
  theme_minimal()
```

![](explore_drugspending_files/figure-markdown_github/plot_aripiprazole-1.png)
