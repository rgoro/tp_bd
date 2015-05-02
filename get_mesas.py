#!/usr/bin/python
# -*- coding: utf-8 -*- 

import random
import DbElecciones as db
from Modelo import *

territorios = get_dicc_territorios()

elecciones = get_elecciones()
poblacion = get_poblacion()
count_poblacion = len(poblacion)

mesas = []
vota_en = {}
padron = {}

for e in elecciones:
    if territorios[e.id_jurisdiccion].nombre == 'Argentina':
        for i in range(0, count_poblacion):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            if vota_en.has_key(poblacion[i]):
                vota_en[poblacion[i]].append(mesas[-1])
            else:
                vota_en[poblacion[i]] = [mesas[-1]]
            padron[mesas[-1]].append(poblacion[i])

    #Buenos Aires tiene 50 habitantes de un solo municipio, y 50 sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Buenos Aires':
        for i in range(0, 100):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Martin' and territorios[territorios[e.id_jurisdiccion].id_padre].nombre == 'Buenos Aires':
        for i in range(0, 50):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Cordoba tiene 50 habitantes de un solo municipio, que resulta que se llama Cordoba, y 50 sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Cordoba' and territorios[e.id_jurisdiccion].nivel == 'provincia':
        for i in range(100, 200):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'Cordoba' and territorios[e.id_jurisdiccion].nivel == 'municipio':
        for i in range(100, 150):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Mendoza tiene 50 habitantes de dos municipios, y 50 sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Mendoza':
        for i in range(200, 350):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Martin' and territorios[territorios[e.id_jurisdiccion].id_padre].nombre == 'Mendoza':
        for i in range(200, 250):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Rafael':
        for i in range(300, 350):
            if i % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Neuquen tiene 150 habitantes sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Neuquen':
        for i in range(350, 500):
            if (i-10) % 20 == 0:
                mesa = Mesa((i/20)+1, e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])


#centros = []
#mesas.sort(lambda m1, m2: cmp(m1.id_eleccion, m2.id_eleccion))

