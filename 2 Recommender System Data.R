library(tidyverse)

load("data/movielens-small.RData")

ratings <- left_join(ratings, movies)
ratings <- as.tibble(ratings)

users_frq <- ratings %>% group_by(userId) %>% summarize(count = n()) %>% arrange(desc(count))
my_users <- users_frq$userId[101:115]

movies_frq <- ratings %>% group_by(movieId) %>% summarize(count = n()) %>% arrange(desc(count))
my_movies <- movies_frq$movieId[101:120]

ratings_red <- ratings %>% filter(userId %in% my_users, movieId %in% my_movies) 

# and check there are 15 users and 20 movies in the reduced dataset
n_users <- length(unique(ratings_red$userId))
n_movies <- length(unique(ratings_red$movieId))
paste("number of users is", n_users)
paste("number of movies is", n_movies)

movies %>% filter(movieId %in% my_movies) %>% select(title)

head(levels(ratings_red$title), 10)
ratings_red <- droplevels(ratings_red)
levels(ratings_red$title)


viewed_movies <- ratings_red %>% 
  complete(userId, title) %>% 
  mutate(seen = ifelse(is.na(rating), 0, 1)) %>% 
  select(userId, title, seen) %>% 
  spread(key = title, value = seen)

dir.create("output")

save(ratings_red, viewed_movies, file = "output/recommender.RData")