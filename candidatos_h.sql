SELECT ci.nombres, ci.apellidos, p.nombre, e.fecha, cr.titulo, t.nombre FROM `candidato` AS ca
	inner join ciudadano as ci on ca.id_ciudadano = ci.id_ciudadano
	inner join partido as p on ca.id_partido = p.id_partido
	inner join eleccion as e on ca.id_eleccion = e.id_eleccion
    inner join cargo as cr on e.id_eleccion = cr.id_eleccion
    inner join territorio t on e.id_jurisdiccion = t.id_territorio;
	
    
-- UPDATE candidato set id_ciudadano = (select ca.id_ciudadano from candidato inner join eleccion as e on ca.id_eleccion = e.id_eleccion where id_jurisdiccion = 1 order by limit 1
