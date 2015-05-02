#!/usr/bin/python
# -*- coding: utf-8 -*- 

import DbElecciones as db

class Eleccion:
    def __init__(self, fila = None):
        if (fila == None):
            self.id_eleccion = None
            self.fecha = None
            # self.tipo = None
            self.id_jurisdiccion = None
        else:
            self.id_eleccion = fila[0]
            self.fecha = fila[1]
            # self.tipo = fila[2]
            self.id_jurisdiccion = fila[3]

class Consulta(Eleccion):
    def __init__(self, fila = None):
        Eleccion.__init__(self, fila)
        self.texto = fila[4]

class Cargo(Eleccion):
    def __init__(self, fila = None):
        Eleccion.__init__(self, fila)
        self.titulo = fila[4]

def get_elecciones():
    res = []
    filas = db.runReadQuery("SELECT e.*, c.titulo FROM eleccion e INNER JOIN cargo c ON e.id_eleccion = c.id_eleccion UNION SELECT e.*, c.texto FROM eleccion e INNER JOIN consulta c ON e.id_eleccion = c.id_eleccion")
    for f in filas:
        if f[2] == 'consulta':
            res.append(Consulta(f))
        elif f[2] == 'cargo':
            res.append(Cargo(f))
    
    return res

class Ciudadano:
    def __init__(self, fila = None):
        if (fila == None):
            self.id_ciudadano = None
            self.DNI = None
            self.nombres = None
            self.apellidos = None
            self.fecha_nacimiento = None
        else:
            self.id_ciudadano = fila[0]
            self.DNI = fila[1]
            self.nombres = fila[2]
            self.apellidos = fila[3]
            self.fecha_nacimiento = fila[4]
    
def get_poblacion():
    res = []
    filas = db.runReadQuery("SELECT * FROM `ciudadano`")
    for f in filas:
        res.append(Ciudadano(f))

    return res

class Mesa:
    def __init__(self, numero, id_eleccion, id_centro):
        self.numero = numero
        self.id_eleccion = id_eleccion
        self.id_presidente = None
        self.id_vice = None
        self.id_tecnico = None
        self.id_centro = None

class Centro:
    def __init__(self):
        self.direccion = "En algún lado"


