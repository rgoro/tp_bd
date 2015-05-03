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
    filas = db.runReadQuery("select * from `territorio`")
    return [Territorio(f) for f in filas]

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


class Partido:
    def __init__(self, fila = None):
        if fila == None:
            self.id_partido = None
            self.nombre = None
        else:
            self.id_partido = fila[0]
            self.nombre = fila[1]

def get_partidos():
    filas = db.runReadQuery("SELECT * FROM `partido`;")
    return [Partido(f) for f in filas]

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
    filas = db.runReadQuery("SELECT * FROM `ciudadano`")
    return [Ciudadano(f) for f in filas]

def get_padron_eleccion(e):
   filas = db.runReadQuery("SELECT c.* FROM ciudadano c INNER JOIN mesa m INNER JOIN vota_en v ON v.id_ciudadano = c.id_ciudadano AND v.id_mesa = m.id_mesa WHERE m.id_eleccion = " + str(e.id_eleccion))
   return [Ciudadano(f) for f in filas]

class Mesa:
    def __init__(self, *args, **kwargs):
        if 'fila' in kwargs.keys():
            fila = kwargs.get('fila')
            self.id_mesa = fila[0]
            self.numero = fila[1]
            self.id_eleccion = fila[2]
            self.id_presidente = fila[3]
            self.id_vicepresidente = fila[4]
            self.id_tecnico = fila[5]
            self.id_centro = fila[6]
        else:
            numero = kwargs.get('numero', None)
            id_eleccion = kwargs.get('id_eleccion', None)

            self.id_mesa = None
            self.numero = numero
            self.id_eleccion = id_eleccion
            self.id_presidente = None
            self.id_vicepresidente = None
            self.id_tecnico = None
            self.id_centro = None

    def __repr__(self):
        if self.id_mesa == None:
            return "«" + str(self.numero) + ", " + str(self.id_eleccion) + "»"
        else:
            return "(" + str(self.id_mesa) + ")«" + str(self.numero) + ", " + str(self.id_eleccion) + "»"

    @classmethod
    def get_insert_query(self):
        query  = """INSERT INTO `mesa` (`numero`, `id_eleccion`, `id_presidente`, `id_vicepresidente`, `id_tecnico`, `id_centro`)"""
        query += """ VALUES (%s, %s, %s, %s, %s, %s)"""
        
        return query

def get_mesas():
    filas = db.runReadQuery("SELECT * FROM `mesa` ORDER BY `id_mesa`;")
    return [Mesa(fila=f) for f in filas]

def get_mesas_eleccion(e):
    return [Mesa(fila=f) for f in db.runReadQuery("SELECT * from `mesa` WHERE `id_eleccion` = " + str(e.id_eleccion))]

def get_autoridades_mesa_eleccion(e):
    mesas = get_mesas_eleccion(e)
    autoridades = set()
    for m in mesas:
        autoridades.add(m.id_presidente)
        autoridades.add(m.id_vicepresidente)
        autoridades.add(m.id_tecnico)
        fiscales = db.runReadQuery("SELECT `id_ciudadano` FROM `fiscal` WHERE `id_mesa` = " + str(m.id_mesa))
        for f in fiscales:
            autoridades.add(f[0])

    return list(autoridades)

class Centro:
    def __init__(self, fila = None):
        if fila == None:
            self.id_centro = None
            self.direccion = u"En algún lado"
        else:
            self.id_centro = fila[0]
            self.direccion = fila[1]


    def get_insert_query(self):
        return "INSERT INTO `centro` (`direccion`) VALUES ('" + self.direccion + "');"

def get_centros():
    filas = db.runReadQuery("SELECT * FROM `centro`;")
    return [Centro(f) for f in filas]
        
