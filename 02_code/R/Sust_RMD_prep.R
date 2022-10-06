
# Import, libraries -------------------------------------------------------

pacman::p_load(tidyverse,
               scales,
               viridis,
               here,
               likert,
               sjPlot)

here()

knitr::purl("Datasets & Source Code/02_R/Results Sustainability Final.Rmd")
list.functions.in.file("Datasets & Source Code/02_R/Results Sustainability Final.Rmd")

sust<-haven::read_sas("Data_Transformed/sustain.sas7bdat")
#Remove all sas attributes from the data
sust[]<- lapply(sust, function(x) {attributes(x) <- NULL; x})
sust <- sust %>%
  rename(
    BH = Q1x7,
    HIT = Q1x12,
    Addtl = Q1x18
  )

# March 2022: Remove cohort from tables (per Doug)
sust <- sust %>% 
  select(-cohort, -cohortnum, -cohortchars)
pracs <- subset(pracs, select = -c(cohort, cohortchars, cohortnum))
sust_f <- subset(sust_f, select = -c(cohort, cohortnum))
sust_f_unique1 <- subset(sust_f_unique1, select = -c(cohort))
sust_likert <- subset(sust_likert, select = -c(cohort))
sust_num <- subset(sust_num, select = -c(cohortnum))  

# Results Sig Lists -------------------------------------------------------

library(readxl)
Sigs050607 <- read_excel("AtlasMeans.xlsx", 
                         sheet = "Sigs")    

Sigs050607 <- Sigs050607 %>% 
  mutate_if(sapply(Sigs050607, is.character), as.factor)  

means_all <- read_excel("C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code/AtlasMeans.xlsx")

Means_Yes_atlas <- read_excel("C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code/AtlasMeans.xlsx", 
                              sheet = "MeansYes_Groups")


Means_Yes_sig <- Means_Yes_atlas %>% 
  filter(Sig == "Yes") %>% 
  filter(!Var_Group == "TotalAvg") %>% 
  mutate(percent_var = percent(PercentYes, accuracy = 1)) %>% 
  mutate(Variable_Group = paste(Var, ":", Var_Group))

sig_atlas_need <- subset(Means_Yes_sig, Column1 == "need")
sig_atlas_what <- subset(Means_Yes_sig, Column1 == "what")
sig_atlas_why_1 <- Means_Yes_sig %>% 
  filter(Var == "orgTyp") %>% 
  filter(Column1 == "why")
sig_atlas_why_2 <- Means_Yes_sig %>% 
  filter(!Var == "orgTyp") %>% 
  filter(Column1 == "why")




facet_var <- function(df) {
  ggplot(df, aes(x = PercentYes, y = reorder(Variable_Group, PercentYes), fill = Var_Name)) + 
  geom_bar(stat="identity",
           color = "black") + 
  facet_wrap(Var_Name ~ ., scales = "free", ncol = 1, strip.position = "top") + 
  theme(strip.text.y = element_text(angle = 0)) +
  labs(title = "Practice Characteristics (n=318)",
       subtitle = "Responses related to significant DVs",
       x = "Percent Endorsing Item",
       y = "Characteristic", 
       fill = "Var_Name") +
  geom_text(data = df,
            mapping = aes(PercentYes, Variable_Group, label = percent_var)) + 
  scale_fill_grey(start = 0.7,
                  end = 0.9) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(0,1),
                     labels = scales::percent) + 
  theme_minimal() +
  theme(legend.position = "none",
        strip.text.x = element_text(hjust = -0.01),
        panel.background = element_rect(fill = "grey95",
                                        color = NA))
}

facet_var(sig_atlas_need)
facet_var(sig_atlas_what)
facet_var(sig_atlas_why_1)
facet_var(sig_atlas_why_2)


sigs <- Sigs050607

# Find dupes --------------------------------------------------------------

pracs<- sust %>%
  dplyr::select(-PFvCHITA,-RoleDual) %>%
  filter(!duplicated(pracid))

pracid<-rle(sort(sust$pracid))
pracid2<- data.frame(number = pracid$values, n=pracid$lengths)

pracid2 %>%
  group_by(n) %>%
  count()


pracid_dup <- pracid2 %>%
  filter(n>1)
pracid_dup1 <- sust %>%
  filter(pracid %in% pracid_dup$number) 
pracid_dup1

#Since there's >1 response per practice, all by column PF v CHITA I think...
sust %>%
  count(pracid, sort = TRUE) %>%
  filter(n>1)

table(sust$RoleDual, sust$PFvCHITA)

#with filter n>1 there are no results, so all are by PF and CHITA

sustU<- sust %>%
  pivot_wider(id_cols = pracid,
              names_from = PFvCHITA,
              values_from = PFvCHITA)
  



# Factors -----------------------------------------------------------------


  #make a df with vars as factors for some commands
#new df
sust_f <- sust %>% 
  dplyr::select(
  BH, HIT, Addtl, orgTypNum, sizenum, ageTypNum, cohortnum, locationnum, PFvCHITA, pracid
)

#factor-level attributes
sust_f$org <- factor(sust_f$orgTypNum, levels = c(1,2,3,4), labels=c("FQHC", "Hosp","Private","SBD"))
sust_f$size <- factor(sust_f$sizenum, levels = c(1,2,3), labels = c("Small", "Medium", "Large"))
sust_f$BH <- factor(sust_f$BH, levels = c(1,2,3,4,5), labels = c("Not Confident At All",
                                                               "Less Confident",
                                                               "Confident",
                                                               "Very Confident",
                                                               "Extremely Confident"))
sust_f$HIT <- factor(sust_f$HIT, levels = c(1,2,3,4,5), labels = c("Not Confident At All",
                                                                 "Less Confident",
                                                                 "Confident",
                                                                 "Very Confident",
                                                                 "Extremely Confident"))
sust_f$Addtl <- factor(sust_f$Addtl, levels = c(1,2,3,4,5), labels = c("Not Confident At All",
                                                                     "Less Confident",
                                                                     "Confident",
                                                                     "Very Confident",
                                                                     "Extremely Confident"))
sust_f$age <- factor(sust_f$ageTypNum, levels = c(1,2,3), labels=c("GIM", "MPC","Ped"))
sust_f$cohort <- factor(sust_f$cohortnum, levels = c(1,2,3), labels=c("C1", "C2","C3"))
sust_f$loc <- factor(sust_f$locationnum, levels = c(1,2), labels=c("Rural","Urban"))
sust_f$PFvCHITA<-factor(sust_f$PFvCHITA, levels = c(0,1), labels = c("0","1"))


sust_f_unique <- sust_f %>%
  dplyr::select(pracid,org:loc)%>%
  distinct(pracid, .keep_all = TRUE)
sust_f_unique1<- cbind(sust_f_unique, count = pracid$lengths)


#Categorical data summary
prop.Fun <- function(x){
  dfProp <- cbind(table(x, useNA="ifany"),round(prop.table(table(x, useNA="ifany"))*100, 2))
  colnames(dfProp) <- c("Count", "Proportion (%)")
  dfProp
}

x <- lapply(sust_f_unique[,c(2:6)], prop.Fun)
y <- x$org %>%
  rbind(x$size) %>%
  rbind(x$age) %>%
  rbind(x$loc)
print(y)

y1<-as.data.frame(y)
library(tibble)
y1 <- tibble::rownames_to_column(y, "Characteristic")

#ended up saving as text file just to get in that damn column name...

count_table <- read.table("C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code/Step2_R/table_counts_prop.txt", header = TRUE)
class(count_table)

pracs <- mutate_if(pracs, is.character, as.factor)

plot_size <- count_table %>% 
  filter(Characteristic %in% c("Small", "Medium", "Large")) %>%
    ggplot() +
  geom_col(aes(x = reorder(Characteristic, Count), y=Count, fill = Count, color = I("black")), alpha = .95) +
  geom_label(aes(x = Characteristic, y=Count, label = Count)) +
    scale_fill_gradient2(low = "gray99",
                          high = "cadetblue4") + 
  ylim(0,250)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  ggtitle("Practice Size")

plot_size

plot_OrgTyp <- count_table %>% 
  filter(Characteristic %in% c("FQHC", "Hosp", "Private", "SBD")) %>%
  ggplot() +
  geom_col(aes(x = reorder(Characteristic, Count), y=Count, fill = Count, color = I("black")), alpha = .95) +
  geom_label(aes(x = Characteristic, y=Count, label = Count)) +
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ylim(0,250)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  ggtitle("Practice Organization Type")

plot_ageTyp <- count_table %>% 
  filter(Characteristic %in% c("GIM", "MPC", "Ped")) %>%
  ggplot() +
  geom_col(aes(x = reorder(Characteristic, Count), y=Count, fill = Count, color = I("black")), alpha = .95) +
  geom_label(aes(x = Characteristic, y=Count, label = Count)) +
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ylim(0,250)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  ggtitle("Practice: Ages Served")

plot_location <- count_table %>% 
  filter(Characteristic %in% c("Rural", "Urban")) %>%
  ggplot() +
  geom_col(aes(x = reorder(Characteristic, Count), y=Count, fill = Count, color = I("black")), alpha = .95) +
  geom_label(aes(x = Characteristic, y=Count, label = Count)) +
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ylim(0,250)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  ggtitle("Practice Location")

# DV Tables and plots -----------------------------------------------------



BH_table <- sust_f %>% 
  select(BH) %>% 
  group_by(BH) %>% 
  summarise(n = n()) %>% 
  mutate(rel.freq = paste0(round(100*n/sum(n), 0), "%"))

BH_table$n <- as.numeric(BH_table$n)

plot_BH <- ggplot(BH_table, aes(x = as.factor(BH), y = as.numeric(n), fill = n)) +
  geom_col(aes(x = reorder(BH, n), y=as.numeric(n), color = I("black"))) +
  geom_label(aes(x = BH, y=as.numeric(n), label = n), fill = "white") +
  ylim(0,300)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ggtitle("Confidence Ratings: Ability to Sustain Behavioral Health Improvements")
plot_BH


HIT_table <- sust_f %>% 
  select(HIT) %>% 
  group_by(HIT) %>% 
  summarise(n = n()) %>% 
  mutate(rel.freq = paste0(round(100*n/sum(n), 0), "%"))

HIT_table$n <- as.numeric(HIT_table$n)

plot_HIT <- ggplot(HIT_table, aes(x = as.factor(HIT), y = as.numeric(n), fill = n)) +
  geom_col(aes(x = reorder(HIT, n), y=as.numeric(n), color = I("black"))) +
  geom_label(aes(x = HIT, y=as.numeric(n), label = n), fill = "white") +
  ylim(0,300)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ggtitle("Confidence Ratings: Ability to Sustain HIT Improvements")
plot_HIT

Addtl_table <- sust_f %>% 
  select(Addtl) %>% 
  group_by(Addtl) %>% 
  summarise(n = n()) %>% 
  mutate(rel.freq = paste0(round(100*n/sum(n), 0), "%"))

Addtl_table$n <- as.numeric(Addtl_table$n)

plot_Addtl <- ggplot(Addtl_table, aes(x = as.factor(Addtl), y = as.numeric(n), fill = n)) +
  geom_col(aes(x = reorder(Addtl, n), y=as.numeric(n), color = I("black"))) +
  geom_label(aes(x = Addtl, y=as.numeric(n), label = n), fill = "white") +
  ylim(0,300)+
  theme(legend.position = "none",
        axis.title.x = element_blank()) + 
  scale_fill_gradient2(low = "gray99",
                       high = "cadetblue4") + 
  ggtitle("Confidence Ratings: Ability to Sustain Addtl Improvements")
plot_Addtl


facetBoxJitter <- function(y, title) {
  ggplot(sust, aes(x = cohort, y = y, color = y)) + 
#    geom_boxplot(size = .75) + 
    geom_jitter(alpha = .50,
                width = .2)+
    scale_color_viridis(trans = 'reverse') + 
    labs(title = title,
         y = "Rating")
}

wrap_by <- function(...) {
  facet_wrap(vars(...), labeller = label_both)
}


HITAge<-facetBoxJitter(sust$HIT,
                       title= "HIT Confidence: Practices by Age Type") 
HITAge + wrap_by(orgTyp)
HITAge

plot_4IV <- sust_f_unique %>% 
  select(-pracid, -cohort) %>% 
  pivot_longer(cols = org:loc,
               names_to = "Var",
               values_to = "Count")

library(scales)
plot_4IV_table <- plot_4IV %>% 
  group_by(Var, Count) %>% 
  count(name = "n_var") %>% 
  group_by(Var) %>% 
  mutate(percent_var = n_var / sum(n_var)) %>% 
  ungroup() %>% 
  mutate(percent_var = percent(percent_var, accuracy = 1))


FourIVs <- ggplot(plot_4IV_table, 
       aes(Count, n_var, fill = Var)) + 
  geom_bar(stat = "identity",
           position = "dodge") + 
  geom_text(data = plot_4IV_table,
            mapping = aes(Count, n_var, label = percent_var)) + 
  coord_flip()

library(RColorBrewer)

facet <- ggplot(plot_4IV_table, aes(x = n_var, y = reorder(Count, n_var), fill = Var)) + 
  geom_bar(stat="identity") + 
  facet_grid(Var ~ ., scales = "free", space = "free") + 
  theme(strip.text.y = element_text(angle = 0)) +
  labs(title = "Practice Characteristics (n=318)",
       x = "Count",
       y = "Variable Grouping", 
       fill = "Var") +
  geom_text(data = plot_4IV_table,
            mapping = aes(n_var, Count, label = percent_var)) + 
  scale_fill_brewer(palette = "PRGn") +
  scale_x_continuous(expand = c(0,0),
                     limits = c(0,250)) + 
  theme_minimal() +
  theme(legend.position = "none",
        strip.text.x = element_text(hjust = -0.01),
        panel.background = element_rect(fill = "grey95",
                                        color = NA))
  
facet  


# atlas data --------------------------------------------------------------


atlas_var_DVs <- atlas_data %>% 
  select(25:43) %>% 
  pivot_longer(cols = 1:19,
               values_to = "Response",
               names_to = "Variable") %>% 
  group_by(Variable, Response) %>% 
  count(name = "n_response") %>% 
  group_by(Variable) %>% 
  mutate(percent_var = n_response/ sum(n_response)) %>% 
  ungroup() %>% 
  mutate(percent_var = percent(percent_var, accuracy = 1)) 

atlasDV <- unique(atlas_var_DVs$Variable)
atlasDV_group <- c(rep("need", 5), 
                   rep("what", 7), 
                   rep("why",7))  

atlas_varNames <- map2_dfr(atlasDV, atlasDV_group, ~ tibble(
  atlasDV = .x, 
  atlasDV_group = .y
))  

atlas_var_DVs <- atlas_var_DVs %>% 
  left_join(atlas_varNames, by = c("Variable" = "atlasDV"), keep = FALSE)

Yes_atlas_var_DVs <- atlas_var_DVs %>% 
  filter(Response == 1) %>% 
  select(-Response)
 

facet_atlas_vars_1 <- ggplot(Yes_atlas_var_DVs, aes(x = n_response, y = reorder(Variable, n_response), fill = atlasDV_group)) + 
  geom_bar(stat="identity",
           color = "grey") + 
  facet_grid(atlasDV_group ~ ., scales = "free", space = "free") + 
  theme(strip.text.y = element_text(angle = 0)) +
  labs(title = "Atlas Responses Coded 0,1 (n=320)",
       x = "Count",
       y = "Variable Grouping", 
       fill = "atlasDV_group") +
  geom_text(data = Yes_atlas_var_DVs,
            mapping = aes(n_response, Variable, label = percent_var)) + 
  scale_fill_brewer(palette = "PuBuGn", direction = -1) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(0,270)) + 
  theme_minimal() +
  theme(legend.position = "none",
        strip.text.x = element_text(hjust = -0.01),
        panel.background = element_rect(fill = "grey95",
                                        color = NA))

facet_atlas_vars_1



# Likert ------------------------------------------------------------------



summary(sust_likert)


library(RColorBrewer)

lsust
plot(lsust)
summary(lsust)

cohort_likert<-likert(sust_likert[,c(1:3)], 
                      grouping = sust_likert$cohort)

sust_likert_rev <- reverse.levels(sust_likert)
sust_likert <- as.data.frame(sust_likert)

lik <- likert(reverse.levels(sust_likert[,c(1:3)]),
              grouping = sust_likert[,5]) %>% 
  plot(low.color = 'palegreen4',
       high.color = 'pink')
lik

sust_f_lik <- sust_f %>%
  dplyr::select(BH, HIT, Addtl, org, size, age, loc)
summary(sust_f_lik)
sust_f_lik <- as.data.frame(sust_f_lik)
f_lik_org <- likert(reverse.levels(sust_f_lik[,c(1:3)]),
                grouping = sust_f_lik[,c(4)]) %>%
  plot(low.color = 'palegreen4',
       high.color = 'pink')
f_lik_org

if(require("dplyr") && require ("gridExtra")) {
  sust_f %>% 
    group_by(org) %>% 
    plot_frq(BH) %>% 
    plot_grid()
}

plot_frq(sust_f$BH, type = "h", show.mean = TRUE, show.mean.val = TRUE,
         normal.curve = TRUE, show.sd = TRUE, normal.curve.color = "blue",
         normal.curve.size = 3, ylim = c(0,300))
