#!/usr/bin/python
# -*- coding: utf-8 -*- 

import MySQLdb

def getConexion():
    return MySQLdb.connect(host="localhost", # your host, usually localhost
                           user="root", # your username
                           passwd="root", # your password
                           db="elecciones")


def runReadQuery(read_query):
    db = getConexion()
    cur = db.cursor()
    cur.execute(read_query)
    return cur.fetchall()

def runInsertQuery(ins_query, data = None):
    db = getConexion()
    cur = db.cursor()
    if data != None:
        cur.executemany(ins_query, data)
    else:
        cur.execute(ins_query)
    db.commit()


if __name__ == "__main__":
    print str(runReadQuery("show databases"))

