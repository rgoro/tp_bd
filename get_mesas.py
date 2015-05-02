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
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
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
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Martin' and territorios[territorios[e.id_jurisdiccion].id_padre].nombre == 'Buenos Aires':
        for i in range(0, 50):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Cordoba tiene 50 habitantes de un solo municipio, que resulta que se llama Cordoba, y 50 sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Cordoba' and territorios[e.id_jurisdiccion].nivel == 'provincia':
        for i in range(100, 200):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'Cordoba' and territorios[e.id_jurisdiccion].nivel == 'municipio':
        for i in range(100, 150):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Mendoza tiene 50 habitantes de dos municipios, y 50 sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Mendoza':
        for i in range(200, 350):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Martin' and territorios[territorios[e.id_jurisdiccion].id_padre].nombre == 'Mendoza':
        for i in range(200, 250):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    elif territorios[e.id_jurisdiccion].nombre == 'San Rafael':
        for i in range(300, 350):
            if i % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])

    #Neuquen tiene 150 habitantes sueltos
    elif territorios[e.id_jurisdiccion].nombre == 'Neuquen':
        for i in range(350, 500):
            if (i-10) % 20 == 0:
                mesa = Mesa(numero=(i/20)+1, id_eleccion=e.id_eleccion)
                mesas.append(mesa)
                padron[mesa] = []

            vota_en[poblacion[i]].append(mesas[-1])
            padron[mesas[-1]].append(poblacion[i])


mesas.sort(lambda m1, m2: cmp(m1.id_eleccion, m2.id_eleccion))

centros = []
id_eleccion = mesas[0]
count_mesas = 0
id_centro = None

db.runInsertQuery("DELETE FROM `centro`")
for m in mesas:
    if m.id_eleccion != id_eleccion:
        count_mesas = 0
        id_eleccion = m.id_eleccion

    if count_mesas % 3 == 0:
        c = Centro()
        db.runInsertQuery(c.get_insert_query())
        id_centro = db.runReadQuery("SELECT MAX(id_centro) FROM `centro`")[0][0]
    
    m.id_centro = id_centro
    count_mesas += 1
    
insert_data = []
for m in mesas:
    m.id_presidente = random.choice(padron[m]).id_ciudadano
    m.id_vicepresidente = random.choice(padron[m]).id_ciudadano
    while m.id_presidente == m.id_vicepresidente:
        m.id_vicepresidente = random.choice(padron[m]).id_ciudadano
    m.id_tecnico = random.choice(padron[m]).id_ciudadano
    while m.id_vicepresidente == m.id_tecnico or m.id_presidente == m.id_tecnico:
        m.id_tecnico = random.choice(padron[m]).id_ciudadano
    
    insert_data.append((m.numero, m.id_eleccion, m.id_presidente, m.id_vicepresidente, m.id_tecnico, m.id_centro))

db.runInsertQuery(Mesa.get_insert_query(), insert_data)

