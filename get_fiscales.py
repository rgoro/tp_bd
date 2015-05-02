#!/usr/bin/python
# -*- coding: utf-8 -*- 

import random
import DbElecciones as db
from Modelo import *

mesas = get_mesas()
partidos = get_partidos()


data_fiscales = []

for m in mesas:
    padron = db.runReadQuery("SELECT * FROM `vota_en` WHERE id_mesa = " + str(m.id_mesa) + ";")
    for p in partidos:
        if random.randint(0, 100) > 80:
            id_fiscal = random.choice(padron)[0]
            while id_fiscal in (m.id_presidente, m.id_vicepresidente, m.id_tecnico):
                id_fiscal = random.choice(padron)[0]
            data_fiscales.append((p.id_partido, id_fiscal, m.id_mesa))


db.runInsertQuery("INSERT INTO `fiscal` (id_partido, id_ciudadano, id_mesa) VALUES (%s, %s, %s)", data_fiscales)
    
