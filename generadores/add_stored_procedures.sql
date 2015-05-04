START TRANSACTION;

USE `elecciones`;

-- Calcula los candidatos que ganaron las elecciones transcurridas en el ultimo anyo
-- La subquery hace el join natural de todas las tablas necesarias, agrupa y ordena
-- Aprovechando esto la query externa toma el primero de cada eleccion, mediante 
-- otro GROUP BY, y agrega informacion para hacer el resultado legible.
DELIMITER //
CREATE PROCEDURE `get_ganadores_ultimo_anyo` ()
	BEGIN
		SELECT ca.titulo, t.nombre, DATE_FORMAT(totales.fecha, "%d/%m/%Y") AS fecha, totales.nombres, totales.apellidos, totales.total_votos FROM (
			SELECT e.id_eleccion, e.fecha, e.id_jurisdiccion, ci.nombres, ci.apellidos, COUNT(v.id_voto) AS total_votos
				FROM `voto` AS v
				INNER JOIN mesa AS m ON m.id_mesa = v.id_mesa
				INNER JOIN eleccion e ON e.id_eleccion = m.id_eleccion
				INNER JOIN candidato ca ON v.id_boleta = ca.id_boleta AND e.id_eleccion = ca.id_eleccion
				INNER JOIN ciudadano ci ON ci.id_ciudadano = ca.id_ciudadano
				WHERE e.tipo = "cargo" AND e.fecha <= NOW() AND e.fecha > DATE_SUB(NOW(), INTERVAL 1 YEAR) 
				GROUP BY e.id_eleccion, ca.id_boleta
				ORDER BY e.id_eleccion, total_votos DESC
			) AS totales
			INNER JOIN cargo AS ca ON ca.id_eleccion = totales.id_eleccion
			INNER JOIN territorio AS t ON t.id_territorio = totales.id_jurisdiccion
			GROUP BY totales.id_eleccion
	END//

-- Calcula, dado un id de eleccion, los ultimo cinco votantes en llegar a cada centro.
-- Se trata de un join natural de las tablas correspondientes, un ORDER BY y un LIMIT.
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


-- Calcula los partidos que superaron el 20% en las ultimas cinco elecciones provinciales a gobernador.
-- En este caso se opto por crear tablas temporales con los datos necesarios para el calculo y
-- finalmente presentar la informacion relevante.
CREATE PROCEDURE `get_partidos_sobre_20_porciento` ()
	BEGIN
		CREATE TEMPORARY TABLE IF NOT EXISTS `votos_totales_eleccion`
			SELECT e.id_eleccion, e.id_jurisdiccion, count(v.id_voto) AS total
				FROM voto AS v
				INNER JOIN mesa AS m ON m.id_mesa = v.id_mesa
				INNER JOIN eleccion AS e ON m.id_eleccion = e.id_eleccion
				GROUP BY e.id_eleccion;


		CREATE TEMPORARY TABLE IF NOT EXISTS `votos_partido_eleccion`
			SELECT e.id_eleccion, e.id_jurisdiccion, p.id_partido, COUNT(v.id_voto) AS total
				FROM voto AS v
				INNER JOIN mesa AS m ON m.id_mesa = v.id_mesa
				INNER JOIN eleccion AS e ON m.id_eleccion = e.id_eleccion
				INNER JOIN candidato AS ca ON ca.id_boleta = v.id_boleta AND ca.id_eleccion = e.id_eleccion
				INNER JOIN partido AS p ON p.id_partido = ca.id_partido
				GROUP BY e.id_eleccion, p.id_partido;

		-- Es necesaria esta tabla? Creo que podria ser una subquery del SELECT final, pero resulta
		-- mas claro asi.
		CREATE TEMPORARY TABLE IF NOT EXISTS `porcentaje_partido_eleccion`
			SELECT vpe.id_eleccion, vpe.id_partido, vpe.total AS total_partido, vte.total AS total_eleccion, (vpe.total/vte.total)*100 as porcentaje
				FROM votos_totales_eleccion AS vte
					INNER JOIN votos_partido_eleccion AS vpe ON vpe.id_eleccion = vte.id_eleccion;

		-- Esto es necesario porque mysql no soporta limit en subqueries, si no seria una subquery
		-- en el SELECT final.
		-- El territorio y su nivel son innecesarios, no hay gobernadores que no son de provincia
		--   pero los pongo para respetar mas fielmente el enunciado
		CREATE TEMPORARY TABLE IF NOT EXISTS `ids_ultimas_cinco_elecciones_gob`
			SELECT e.id_eleccion FROM eleccion e
				INNER JOIN cargo AS ca ON e.id_eleccion = ca.id_eleccion
				INNER JOIN territorio AS t ON t.id_territorio = e.id_jurisdiccion
			WHERE ca.titulo = "Gobernador" AND t.nivel = "provincia" AND e.fecha <= NOW()
			ORDER BY e.fecha DESC
			LIMIT 5;

		SELECT e.id_eleccion, DATE_FORMAT(e.fecha, "%d/%m/%Y") AS fecha, t.nombre AS provincia, p.nombre, ppe.total_eleccion AS 'votos emitidos', ppe.total_partido AS 'votos totales', ppe.porcentaje
			FROM porcentaje_partido_eleccion AS ppe
			INNER JOIN eleccion AS e ON ppe.id_eleccion = e.id_eleccion
			INNER JOIN territorio AS t ON t.id_territorio = e.id_jurisdiccion
			INNER JOIN partido AS p ON p.id_partido = ppe.id_partido
			WHERE ppe.porcentaje > 20 
				AND ppe.id_eleccion IN (SELECT * FROM ids_ultimas_cinco_elecciones_gob)
			ORDER BY e.id_eleccion, p.nombre;
	END//
DELIMITER ;

COMMIT;
