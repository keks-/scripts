#!/usr/bin/env python2.7

import os
import imdb
import re
import sys

from imdb import IMDb


ia = IMDb() # get all infos from the interwebz

# TODO: Maybe some avi file search here?
# for now getting the movie title from user

title = raw_input('Enter movie title: ')

# the actual search in imdb, returns an array of hits(strings)
movie_results = ia.search_movie(title)

counter = 1
for item in movie_results:
    print(str(counter) + ' ' * 2 + item['long imdb canonical title'], \
    item.movieID)
    counter += 1

print '\n'
get_infos = raw_input('Enter numbers of movies to dump into txt file: ')

movies_to_get = list()
for i in get_infos.split():
    movies_to_get.append(movie_results[int(i) - 1])
print movies_to_get

fobj = open('Movies.txt', 'w')
for movie in movies_to_get:
    ia.update(movie)
    title = movie['long imdb canonical title']
    #director = movie['director']
    rating = movie['rating']
    runtime = movie['runtime']
    fobj.write(title + '\n' + str(rating) + '   ' + str(runtime) + '\n')

fobj.close()
print 'done'
