## ----setup, include=FALSE-----------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)

pacman::p_load(tidyverse,
               janitor,
              kableExtra,
              gtsummary,
              summarytools,
              broom,
              ggpubr,
              sjPlot,
              patchwork)


load("env.RData") 




## ----fig.width=10-------------------------------------------------------------------------------------------
plot_ageTyp + plot_location + plot_OrgTyp + plot_size


## ----fig.width=8--------------------------------------------------------------------------------------------
sust_f_unique %>%
  dplyr::select(org, size, age, loc) %>% 
  tbl_summary(
    percent = "column",
    label = list(org ~ "Organization Type",
                 size ~ "Practice Size",
                 age ~ "Age Type",
                 loc ~ "Location")) %>%
  modify_header(label ~ "**Practice Characteristics**") %>%
  bold_labels()



## -----------------------------------------------------------------------------------------------------------
plot_BH / plot_HIT / plot_Addtl


## -----------------------------------------------------------------------------------------------------------
ggplot(sust_f, aes(x = loc, y = BH))+
    geom_jitter(alpha = .5,
                height = .2,
                width = .2,
                aes(color = BH),
                show.legend = FALSE) + 
    facet_grid(age ~ org, margins = TRUE) + 
    theme(axis.text.x = element_text(hjust = 1, vjust = 1)) + 
  scale_color_viridis_d(option = "D",
                      direction = -1) +
  ggtitle("Respondent Confidence Ratings: Behavioral Health Improvements") + 
  xlab("")+
    theme(plot.caption = element_text(hjust = 0, face= "italic"),
        plot.title.position = "plot", 
        plot.caption.position =  "plot") 


## -----------------------------------------------------------------------------------------------------------
ggplot(sust_f, aes(x = loc, y = HIT))+
    geom_jitter(alpha = .5,
                height = .2,
                width = .2,
                aes(color = BH),
                show.legend = FALSE) + 
    facet_grid(age ~ org, margins = TRUE) + 
    theme(axis.text.x = element_text(hjust = 1, vjust = 1)) + 
  scale_color_viridis_d(option = "D",
                      direction = -1) +
  ggtitle("Respondent Confidence Ratings: HIT") + 
  xlab("")+
    theme(plot.caption = element_text(hjust = 0, face= "italic"),
        plot.title.position = "plot", 
        plot.caption.position =  "plot") 


## -----------------------------------------------------------------------------------------------------------
ggplot(sust_f, aes(x = loc, y = Addtl))+
    geom_jitter(alpha = .5,
                height = .2,
                width = .2,
                aes(color = BH),
                show.legend = FALSE) + 
    facet_grid(age ~ org, margins = TRUE) + 
    theme(axis.text.x = element_text(hjust = 1, vjust = 1)) + 
  scale_color_viridis_d(option = "D",
                      direction = -1) +
  ggtitle("Respondent Confidence Ratings: Additional Improvements") + 
  xlab("")+
    theme(plot.caption = element_text(hjust = 0, face= "italic"),
        plot.title.position = "plot", 
        plot.caption.position =  "plot") 


## ----fig.align='left'---------------------------------------------------------------------------------------
pracid2 %>%
  tbl_summary(include = n)


## -----------------------------------------------------------------------------------------------------------
sust_f_unique1 %>%
  dplyr::select(-pracid) %>% 
  tbl_summary(
    by = count,
    percent = "row") %>% 
  add_overall() %>% 
  modify_spanning_header(all_stat_cols() ~ "By Count of Responses Received Per Practice: 1 or 2")



## -----------------------------------------------------------------------------------------------------------
plot_frq(sust_f$BH, type = "h", show.mean = TRUE, show.mean.val = TRUE,
         normal.curve = TRUE, show.sd = TRUE, normal.curve.color = "blue",
         normal.curve.size = 3, ylim = c(0,300), title = "Behavioral Health: Confidence in Ability to Sustain Improvements")


## -----------------------------------------------------------------------------------------------------------
plot_frq(sust_f$HIT, type = "h", show.mean = TRUE, show.mean.val = TRUE,
         normal.curve = TRUE, show.sd = TRUE, normal.curve.color = "blue",
         normal.curve.size = 3, ylim = c(0,300), title = "Health Information Technology: Confidence in Ability to Sustain Improvements")


## -----------------------------------------------------------------------------------------------------------
plot_frq(sust_f$Addtl, type = "h", show.mean = TRUE, show.mean.val = TRUE,
         normal.curve = TRUE, show.sd = TRUE, normal.curve.color = "blue",
         normal.curve.size = 3, ylim = c(0,300), title = "Additional Improvements: Confidence in Ability to Sustain Improvements")

