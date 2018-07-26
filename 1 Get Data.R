# GET DATA #

dir.create("data")

download.file(
  url = "http://files.grouplens.org/datasets/movielens/ml-latest-small.zip", 
  destfile = "data/ml-latest-small.zip"
)
unzip("data/ml-latest-small.zip", exdir = "data")


# read in the csv files
movies <- read.csv("data/ml-latest-small/movies.csv")  # movie info: title and genre
ratings <- read.csv("data/ml-latest-small/ratings.csv") # user ratings for each movie
tags <- read.csv("data/ml-latest-small/tags.csv") # additional user reviews ("tag")
links <- read.csv("data/ml-latest-small/links.csv") # lookup for imdb movie IDs

# save as .RData
save(links, movies, ratings, tags, file = "data/movielens-small.RData")

# check that it's worked
rm(list = ls())
load("data/movielens-small.RData")
