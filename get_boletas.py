#!/usr/bin/python
# -*- coding: utf-8 -*- 

import random
import DbElecciones as db
from Modelo import *

elecciones = get_elecciones()
partidos = get_partidos()
poblacion = get_poblacion()
id_SM_Mendoza = db.runReadQuery("SELECT id_territorio FROM territorio WHERE nombre = 'San Martin' and id_padre IN (SELECT id_territorio FROM territorio WHERE nombre = 'Mendoza');")[0][0]

data_boletas = []
list_candidatos = []
list_opciones = []

candidatos_presi = {}
for e in elecciones:
    padron_eleccion = get_padron_eleccion(e)
    if isinstance(e, Cargo):
        autoridades_eleccion = get_autoridades_mesa_eleccion(e)
        for p in partidos:
            #Partido de Marrek se presenta sólo a las municipales de SMM
            if p.nombre == 'Partido de Marrek' and e.id_jurisdiccion != id_SM_Mendoza:
                continue

            #Ojo, nada asegura que el candidato no sea autoridad de mesa
            id_candidato = None
            if p.nombre != "Partido Colocado" and e.titulo == "Presidente":
                if candidatos_presi.has_key(p):
                    id_candidato = candidatos_presi[p]
                else:
                    id_candidato = random.choice(padron_eleccion).id_ciudadano
                    while id_candidato in autoridades_eleccion:
                        id_candidato = random.choice(padron_eleccion).id_ciudadano
                    candidatos_presi[p] = id_candidato
            else:
                id_candidato = random.choice(padron_eleccion).id_ciudadano
                while id_candidato in autoridades_eleccion:
                    id_candidato = random.choice(padron_eleccion).id_ciudadano

            data_boletas.append((e.id_eleccion, 'candidato'))
            list_candidatos.append([id_candidato, p.id_partido, e.id_eleccion])
    else:
        for i in range(random.randint(2, 6)):
            data_boletas.append((e.id_eleccion, 'opcion'))
            list_opciones.append([u"Este sería el texto de la opción " + str(i), e.id_eleccion])

db.runInsertQuery("INSERT INTO `boleta` (id_eleccion, tipo) VALUES (%s, %s)", data_boletas)

boletas_completas = db.runReadQuery("SELECT * FROM `boleta`")

offset = 0
for i in range(len(boletas_completas)):
    # ESTO LO PONGO ASÍ PORQUE VI QUE LAS OPCIONES VAN PRIMERAS
    if boletas_completas[i][2] == 'opcion':
        list_opciones[i].append(boletas_completas[i][0])
        offset += 1
    else:
        list_candidatos[i - offset].append(boletas_completas[i][0])


data_opciones = [tuple(i) for i in list_opciones]
data_candidatos = [tuple(i) for i in list_candidatos]

db.runInsertQuery("INSERT INTO `opcion` (texto, id_eleccion, id_boleta) VALUES (%s, %s, %s)", data_opciones)
db.runInsertQuery("INSERT INTO `candidato` (id_ciudadano, id_partido, id_eleccion, id_boleta) VALUES (%s, %s, %s, %s)", data_candidatos)

