#!/bin/sh

DB_USER=root
DB_PASS=root
MYSQL="mysql -u $DB_USER --password=$DB_PASS"

$MYSQL < elecciones.sql
$MYSQL < territorios_elecciones.sql
$MYSQL < gente.sql
python get_mesas.py
$MYSQL < camionetas.sql
