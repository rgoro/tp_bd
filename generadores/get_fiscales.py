#!/usr/bin/python
# -*- coding: utf-8 -*- 

import random
import DbElecciones as db
from Modelo import *

mesas = get_mesas()
partidos = get_partidos()
p_marrek = filter(lambda p: p.nombre == "Partido de Marrek", partidos)[0]
id_SM_Mendoza = db.runReadQuery("SELECT id_territorio FROM territorio WHERE nombre = 'San Martin' and id_padre IN (SELECT id_territorio FROM territorio WHERE nombre = 'Mendoza');")[0][0]
ids_elecciones_smm = map(lambda e: e.id_eleccion, filter(lambda e: e.id_jurisdiccion == id_SM_Mendoza, get_elecciones()))

data_fiscales = []

for m in mesas:
    fiscales = []
    padron = db.runReadQuery("SELECT * FROM `vota_en` WHERE id_mesa = " + str(m.id_mesa) + ";")
    for p in partidos:
        if p == p_marrek and m.id_eleccion not in ids_elecciones_smm:
            continue

        if random.randint(0, 100) < 80:
            id_fiscal = random.choice(padron)[0]
            while id_fiscal in fiscales or id_fiscal in (m.id_presidente, m.id_vicepresidente, m.id_tecnico):
                id_fiscal = random.choice(padron)[0]
            fiscales.append(id_fiscal)
            data_fiscales.append((p.id_partido, id_fiscal, m.id_mesa))


db.runInsertQuery("INSERT INTO `fiscal` (id_partido, id_ciudadano, id_mesa) VALUES (%s, %s, %s)", data_fiscales)
    
