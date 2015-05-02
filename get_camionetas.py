#!/usr/bin/python
# -*- coding: utf-8 -*- 

from random import choice, randint
import DbElecciones as db
from Modelo import *

centros = get_centros()
ciudadanos = get_poblacion()

print "INSERT INTO `camioneta` (`patente`, `id_centro`, `id_responsable`) VALUES"
for c in centros:
    for i in range(3):
        print "(", randint(99999, 1000000), ",", c.id_centro, ",", choice(ciudadanos).id_ciudadano, "),"

