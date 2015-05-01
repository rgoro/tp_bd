-- TP 1 Bases de Datos 2015 1c
-- Autor: Román Gorojovsky, L.U. 530/02

START TRANSACTION;

DROP DATABASE IF EXISTS `elecciones`;
CREATE DATABASE IF NOT EXISTS `elecciones` COLLATE 'utf8_general_ci';

USE `elecciones`

-- Entidades.
CREATE TABLE IF NOT EXISTS `boleta` (
	`id_boleta` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`id_eleccion` INT(11) NOT NULL,
	`tipo` ENUM('opcion', 'candidato') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `camioneta` (
	`id_camioneta` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`patente` VARCHAR(6) NOT NULL UNIQUE,
	`id_centro` INT(11) NOT NULL, -- Atención acá con asignar en distintas elecciones.
	`id_responsable` INT(11) NOT NULL -- Atención acá con asignar en distintas elecciones.
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- FALTA KEY: La tripla debería ser UNIQUE
CREATE TABLE IF NOT EXISTS `candidato` (
	`id_boleta` INT(11) NOT NULL PRIMARY KEY,
	`id_ciudadano` INT(11) NOT NULL, -- NO ESTÁ EN EL DER
	`id_partido` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `centro` (
	`id_centro` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`direccion` VARCHAR(200) NOT NULL
	-- `id_territorio` INT(11) NOT NULL -- Por ahora no se si uso esto.
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ciudadano` (
	`id_ciudadano` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`DNI` INT(8) NOT NULL UNIQUE,
	`nombres` VARCHAR(200) NOT NULL, 
	`apellidos` VARCHAR(200) NOT NULL,
	`fecha_nacimiento` DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `eleccion` (
	`id_eleccion` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`fecha` DATETIME NOT NULL,
	`tipo` ENUM('cargo', 'consulta') NOT NULL,
	`id_jurisdiccion` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `mesa` (
	`id_mesa` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`numero` INT(6) NOT NULL,
	`id_eleccion` INT(11) NOT NULL,
	`id_presidente` INT(11) NOT NULL,
	`id_vicepresidente` INT(11) NOT NULL,
	`id_tecnico` INT(11) NOT NULL,
	`id_centro` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `opcion` (
	`id_boleta` INT(11) NOT NULL PRIMARY KEY,
	`texto` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `partido` (
	`id_partido` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`nombre` VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `territorio` (
	`id_territorio` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`nombre` VARCHAR(200) NOT NULL,
	`nivel` ENUM('Nacion', 'Provincia', 'Municipio'),
	`id_padre` INT(11) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `voto` (
	`id_voto` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`id_contenido` INT(11) NOT NULL,
	`id_mesa` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Relaciones muchos a muchos
CREATE TABLE IF NOT EXISTS `fiscal` ( 
	`id_partido` INT(11) NOT NULL,
	`id_ciudadano` INT(11) NOT NULL,
	`id_mesa` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `vota_en` ( 
	`id_ciudadano` INT(11) NOT NULL,
	`id_mesa` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Foreign Keys


-- Unique Keys?


COMMIT;
