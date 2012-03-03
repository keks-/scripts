#!/usr/bin/env python2.7
#----------------------------------------------------
# Author:       Max "keks" Fischer
#
# License:      Beerware
#----------------------------------------------------
# Getting movie infos straight from imdb
#----------------------------------------------------
# NOTE:
# Usage of IMDbPY restricts python 2.7
# TODO: Maybe some avi file search here?
# for now getting the movie title from user

import os
import imdb
import re
import sys

from imdb import IMDb

# getting all infos from the interwebz
# lxhtml parser throws bunch of warnings => using beautifulsoup
ia = IMDb('http', useModule='beautifulsoup')

def search_imdb(title):
    # the actual search in imdb; returns array of hits
    movie_results = ia.search_movie(title)

    counter = 1
    for item in movie_results:
        print str(counter) + ' ' * 2 + item['long imdb canonical title'], \
                item.movieID
        counter += 1
    print '\n'
    get_infos = raw_input('Enter numbers of movies to dump into txt file: ')

    movies_to_get = list()
    for i in get_infos.split():
        movies_to_get.append(movie_results[int(i) - 1])

    fobj = open('Movies.txt', 'a')
    for movie in movies_to_get:
        # getting further infos for selection
        ia.update(movie)
        title = movie['long imdb canonical title']
        #director = movie['director']
        try:
            rating = str(movie['rating'])
        except KeyError, e:
            rating = 'NA'
        try:
            runtime = unicode(movie['runtime'][0])
        except KeyError, e:
            runtime = 'NA'
        fobj.write(title + '\n' + 'Rating: ' + rating + '\n'
                + 'Runtime: ' + runtime + ' min' + '\n' * 2)

    fobj.close()
    print 'ADDED'
    main() # recursion, no restart for different titles

def main():
    title = raw_input('Enter movie title, enter nothing to quit\n>: ')
    if len(title) is not 0:
        search_imdb(title)
    else:
        sys.exit()

if __name__ == "__main__":
    main()
