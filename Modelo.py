#!/usr/bin/python
# -*- coding: utf-8 -*- 

import DbElecciones as db

class Territorio:
    def __init__(self, fila = None):
        if fila == None:
            self.id_territorio = None
            self.nombre = None
            self.nivel = None
            self.id_padre = None
        else:
            self.id_territorio = fila[0]
            self.nombre = fila[1]
            self.nivel = fila[2]
            self.id_padre = fila[3]

def get_territorios():
    res = []
    filas = db.runReadQuery("select * from `territorio`")
    for f in filas:
        res.append(Territorio(f))

    return res

def get_dicc_territorios():
    return dict([(t.id_territorio, t) for t in get_territorios()])

class Eleccion:
    def __init__(self, fila = None):
        if fila == None:
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
    query_elecciones = "SELECT e.*, c.titulo FROM eleccion e"
    query_elecciones += " INNER JOIN cargo c ON e.id_eleccion = c.id_eleccion"
    query_elecciones += " WHERE e.tipo = 'cargo'"
    query_elecciones += " UNION SELECT e.*, c.texto FROM eleccion e"
    query_elecciones += " INNER JOIN consulta c ON e.id_eleccion = c.id_eleccion"
    query_elecciones += " WHERE e.tipo = 'consulta'"
    query_elecciones += " ORDER BY id_eleccion"
    
    filas = db.runReadQuery(query_elecciones)
    for f in filas:
        if f[2] == 'consulta':
            res.append(Consulta(f))
        elif f[2] == 'cargo':
            res.append(Cargo(f))
    
    return res

class Ciudadano:
    def __init__(self, fila = None):
        if fila == None:
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
    filas = db.runReadQuery("select * from `ciudadano`")
    for f in filas:
        res.append(Ciudadano(f))

    return res

class Mesa:
    def __init__(self, numero, id_eleccion):
        self.numero = numero
        self.id_eleccion = id_eleccion
        self.id_presidente = None
        self.id_vicepresidente = None
        self.id_tecnico = None
        self.id_centro = None

    def __repr__(self):
        return "«" + str(self.numero) + ", " + str(self.id_eleccion) + "»"

    @classmethod
    def get_insert_query(self):
        query  = """INSERT INTO `mesa` (`numero`, `id_eleccion`, `id_presidente`, `id_vicepresidente`, `id_tecnico`, `id_centro`)"""
        query += """ VALUES (%s, %s, %s, %s, %s, %s)"""
        
        return query

class Centro:
    def __init__(self):
        self.direccion = u"En algún lado"

    def get_insert_query(self):
        return "INSERT INTO `centro` (`direccion`) VALUES ('" + self.direccion + "');"


