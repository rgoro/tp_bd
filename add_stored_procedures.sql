START TRANSACTION;

USE `elecciones`;

DELIMITER //
CREATE PROCEDURE `get_ganadores_ultimo_anyo` ()
	BEGIN
		SELECT ca.titulo, t.nombre, DATE_FORMAT(totales.fecha, "%d/%m/%Y") AS fecha, totales.nombres, totales.apellidos, totales.total_votos FROM (
			SELECT e.id_eleccion, e.fecha, e.id_jurisdiccion, ci.nombres, ci.apellidos, COUNT(v.id_voto) AS total_votos
				FROM `voto` AS v
				INNER JOIN mesa AS m ON m.id_mesa = v.id_mesa
				INNER JOIN candidato ca ON v.id_boleta = ca.id_boleta
				INNER JOIN ciudadano ci ON ci.id_ciudadano = ca.id_ciudadano
				INNER JOIN eleccion e ON e.id_eleccion = m.id_eleccion
				WHERE e.tipo = "cargo" AND e.fecha <= NOW() AND e.fecha > DATE_SUB(NOW(), INTERVAL 1 YEAR) 
				GROUP BY e.id_eleccion, ca.id_boleta
				ORDER BY e.id_eleccion, total_votos DESC
			) AS totales
			INNER JOIN cargo AS ca ON ca.id_eleccion = totales.id_eleccion
			INNER JOIN territorio AS t ON t.id_territorio = totales.id_jurisdiccion
			GROUP BY totales.id_eleccion;
	END//

CREATE PROCEDURE `get_votantes_sobre_la_hora` (IN id_eleccion INT(11))
	BEGIN
		SELECT ci.DNI, ci.nombres, ci.apellidos, ve.hora FROM `centro` AS c
			INNER JOIN `mesa` AS m ON m.id_centro = c.id_centro
			INNER JOIN `vota_en` AS ve ON ve.id_mesa = m.id_mesa
			INNER JOIN `ciudadano` AS ci ON ve.id_ciudadano = ci.id_ciudadano
			WHERE m.id_eleccion = id_eleccion
			ORDER BY hora DESC
			LIMIT 5;
	END//


DELIMITER ;

COMMIT;
