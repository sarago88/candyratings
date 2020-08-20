### Practice your R skills: Analyzng candy ratings ###
### Sara Gottlieb-Cohen, StatLab Manager           ###

# Load the data and packages

candy <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/candy-power-ranking/candy-data.csv")
library(tidyverse)

# Inspect the data

head(candy)
str(candy)
nrow(candy)

# Which candies have the highest rating?
# Replicate the first table in the article.

candy %>%
  select(competitorname, winpercent) %>%
  arrange(desc(winpercent))

# Each factor (e.g., chocolate, fruity) shoudl be factor variables,
# not numeric. We need to first change them all to factors.

# Fast way (change all variables in one step):

candy <- candy %>%
  mutate_if(is.integer, as.factor)

str(candy)

# Slow way (change each variable separately):

candy$chocolate <- as.factor(candy$chocolate)
candy$fruity <- as.factor(candy$fruity)
candy$caramel <- as.factor(candy$caramel)
candy$peanutyalmondy <- as.factor(candy$peanutyalmondy)
candy$nougat <- as.factor(candy$nougat)
candy$crispedricewafer <- as.factor(candy$crispedricewafer)
candy$hard <- as.factor(candy$hard)
candy$bar <- as.factor(candy$bar)
candy$pluribus <- as.factor(candy$pluribus)

# Build the models in the article.
# The first model is the one with the low R-squared, using just sugar and price
# to predict win percent.
# The second model uses each factor variable as a predictor.

candy_model1 <- lm(winpercent ~ sugarpercent + pricepercent, data = candy)
summary(candy_model1)

candy_model2 <- lm(winpercent ~ chocolate + fruity + caramel + peanutyalmondy +
                    nougat + crispedricewafer + hard + bar + pluribus,
                  data = candy)
summary(candy_model2)

# Now replicate the second table in the article.
# The first step to summarizing the data is to reshape the data
# from wide to long format.

# I have demonstrated three different ways to do this.

candy_long <- candy %>%
  gather(key = "candy_type", value = "includes", 
         -competitorname, -sugarpercent, -pricepercent, -winpercent)

candy_long2 <- candy %>% 
        select(-sugarpercent, -pricepercent) %>% 
        pivot_longer(cols = c(chocolate, fruity, caramel, peanutyalmondy, nougat, 
                              crispedricewafer, hard, bar, pluribus), 
        names_to = 'candy_type', 
        values_to = 'includes')

# Summarze the data to show the avg_win_share of each candy type.
# Present it in descending order

candy_summary <- candy_long %>%
  filter(includes == 1) %>%
  group_by(candy_type) %>%
  summarize(avg_win_share = mean(winpercent))

candy_summary

# Join the summary table with the coefficients from our model
# We are aiming to recreate the table at the end of the article.

candy_model2$coefficients

# Remove the 1 at the end of the coefficient names.
# I have demonstrated several different ways to do this.

coef_names <- gsub(1, "", names(candy_model2$coefficients))
coef_names

coef_names2 <- str_replace(names(candy_model2$coefficients), "1", "")
coef_names2

coef_names3 <- str_replace(names(candy_model2$coefficients), "[0-9]", "")
coef_names3

names(candy_model2$coefficients) <- str_sub(names(candy_model2$coefficients), 1, 
                                           nchar(names(candy_model2$coefficients))-1)

# Remove the intercept

candy_model2$coefficients <- candy_model2$coefficients[-1]

# Turn the coefficients into a data frame, with names/coefficients as columns, so that we 
# can ultimately join it with our candy_summary table.

coef_df <- data.frame(names(candy_model2$coefficients), candy_model2$coefficients)

# Rename the columns more appropriately.

coef_df <- coef_df %>%
  rename(candy_type = names.candy_model2.coefficients.,
         value_add_to_win = candy_model2.coefficients)

# Join the two tables!

full_table <- candy_summary %>%
  right_join(coef_df, by = "candy_type") %>%
  arrange(desc(value_add_to_win))

full_table



