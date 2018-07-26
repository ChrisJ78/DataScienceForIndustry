library(tidyverse)

load("output/recommender.RData")

# Create Matrix
sorted_my_users <- as.character(unlist(viewed_movies[,1]))
viewed_movies <- as.matrix(viewed_movies[,-1])
row.names(viewed_movies) <- sorted_my_users

# function calculating cosine similarity
cosine_sim <- function(a, b){crossprod(a, b) / sqrt(crossprod(a) * crossprod(b))}

user_similarities = matrix(0, nrow = 15, ncol = 15)
for (i in 1:14) {
  for (j in (i + 1):15) {
    user_similarities[i,j] <- cosine_sim(viewed_movies[i,], viewed_movies[j,])
  }
}
user_similarities <- user_similarities + t(user_similarities)
diag(user_similarities) <- 0
row.names(user_similarities) <- row.names(viewed_movies)
colnames(user_similarities) <- row.names(viewed_movies)

# a function to generate a recommendation for any user
user_based_recommendations <- function(user, user_similarities, viewed_movies){
  
  # turn into character if not already
  user <- ifelse(is.character(user), user, as.character(user))
  
  # get scores
  user_scores <- data.frame(title = colnames(viewed_movies), 
                            score = as.vector(user_similarities[user,] %*% viewed_movies), 
                            seen = viewed_movies[user,])
  
  # sort unseen movies by score and remove the 'seen' column
  user_scores %>% 
    filter(seen == 0) %>% 
    arrange(desc(score)) %>% 
    select(-seen)
  
}