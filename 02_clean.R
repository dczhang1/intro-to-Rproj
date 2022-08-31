# Import Raw Data------------------------------------------
df.raw.t1 <- read_csv("Data/df.raw.t1.csv")
df.raw.t2 <- read_csv("Data/df.raw.t2.csv")

# Data Management -----------------------------------------

#Merging Time 1 Time 2 Data
df.raw.combine <- merge(df.raw.t1, df.raw.t2, 
                        by.x = "PROLIFID_T1",
                        by.y = "PROLIFIC_PID",
                        all.x = T)

# Clean and Wrangling -------------------------------------

df.clean.combine <- df.raw.combine %>%
            select(-PROLIFID_T1) %>% # deselect extra variable
            rename(DV_Height = DV8,
                   DV_Weight = DV9) %>% #renaming DVs
            mutate(DV_BMI = DV_Weight*703/(DV_Height^2)) %>% #Calculating BMI from weight and height
            mutate(ATTENTION_1 = case_when(
                               DOSPERT_T1_20 == 7 ~ 1,
                               DOSPERT_T1_20 < 7 ~ 0)) %>%
            filter(ATTENTION_1 == 1)


# New Variables--------------------------------------------
df.clean.combine$Mean_GRIPS <-
            as.vector(scoreItems(
            keys = c(1,1,1,1,1,1,1,1),
            items = select(df.clean.combine,
            GRIPS_T1_1:GRIPS_T1_8))$score)

# Sub-setting Data ----------------------------------------
