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





# Each factor (e.g., chocolate, fruity) shoudl be factor variables,
# not numeric. We need to first change them all to factors.




# Build the models in the article.
# The first model is the one with the low R-squared, using just sugar and price
# to predict win percent.
# The second model uses each factor variable as a predictor.





# Now replicate the second table in the article.
# The first step to summarizing the data is to reshape the data
# from wide to long format.





# Summarze the data to show the avg_win_share of each candy type.
# Present it in descending order





# Join the summary table with the coefficients from our model
# We are aiming to recreate the table at the end of the article.

# Remove the 1 at the end of the coefficient names.



# Remove the intercept



# Turn the coefficients into a data frame, with names/coefficients as columns, so that we 
# can ultimately join it with our candy_summary table.



# Rename the columns more appropriately.




# Join the two tables!





