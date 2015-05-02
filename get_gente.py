#!/usr/bin/python
# -*- coding: utf-8 -*- 

import requests
import time

from sys import stderr
from random import random, randint, shuffle

def strTimeProp(start, end, format, prop):
    """Get a time at a proportion of a range of two formatted times.

    start and end should be strings specifying times formated in the
    given format (strftime-style), giving an interval [start, end].
    prop specifies how a proportion of the interval to be taken after
    start.  The returned time will be in the specified format.
    """

    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(format, time.localtime(ptime))


def randomDate(start, end, prop):
    return strTimeProp(start, end, '%Y-%m-%d', prop)

print 

total = 50*4 + 100 + 200
#total = 5

gente = []
for i in range(1, total):
    print >>stderr, ".",
    stderr.flush()
    r = requests.post('http://www.genware.es/xGenNombre.php', {'IdIdioma' : 1, 'EsHombre' : i < total/2})
    gente.append(r.content.split('|')[1].decode('iso-8859-1').encode('utf8').title())

print >> stderr, "\n"

shuffle(gente)

print "INSERT INTO `ciudadano` (`DNI`, `nombres`, `apellidos`, `fecha_nacimiento`) VALUES"
for g in gente:
    print "(" + str(randint(11000000, 40000000)) + ", '" + g + "', '" + randomDate('1940-01-01', '2001-01-01', random()) + "'),"


