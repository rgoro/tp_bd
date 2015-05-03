-- TP 1 Bases de Datos 2015 1c
-- Autor: Román Gorojovsky, L.U. 530/02

START TRANSACTION;

DROP DATABASE IF EXISTS `elecciones`;
CREATE DATABASE IF NOT EXISTS `elecciones` COLLATE 'utf8_general_ci';

USE `elecciones`;

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
	`id_partido` INT(11) NOT NULL,
	`id_eleccion` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cargo` (
	`id_eleccion` INT(11) NOT NULL PRIMARY KEY,
	`titulo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `centro` (
	`id_centro` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`direccion` VARCHAR(200) NOT NULL
	-- `id_territorio` INT(11) NOT NULL -- NO ESTÁ EN EL DER
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ciudadano` (
	`id_ciudadano` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`DNI` INT(8) NOT NULL UNIQUE,
	`nombres` VARCHAR(200) NOT NULL, 
	`apellidos` VARCHAR(200) NOT NULL,
	`fecha_nacimiento` DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `consulta` (
	`id_eleccion` INT(11) NOT NULL PRIMARY KEY,
	`texto` varchar(100) NOT NULL
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
	`texto` VARCHAR(100),
	`id_eleccion` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `partido` (
	`id_partido` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`nombre` VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `territorio` (
	`id_territorio` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`nombre` VARCHAR(200) NOT NULL,
	`nivel` ENUM('nacion', 'provincia', 'municipio'),
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
	`id_mesa` INT(11) NOT NULL,
	PRIMARY KEY (`id_partido`, `id_ciudadano`, `id_mesa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `vota_en` ( 
	`id_ciudadano` INT(11) NOT NULL,
	`id_mesa` INT(11) NOT NULL,
	`hora` DATETIME NULL,
	PRIMARY KEY (`id_ciudadano`, `id_mesa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Foreign Keys

ALTER TABLE `boleta` ADD FOREIGN KEY `FK_boleta_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `camioneta` ADD FOREIGN KEY `FK_camioneta_centro` 
	(`id_centro`) REFERENCES `centro` (`id_centro`)
	ON DELETE CASCADE;

ALTER TABLE `camioneta` ADD FOREIGN KEY `FK_camioneta_responsable` 
	(`id_responsable`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `candidato` ADD FOREIGN KEY `FK_boleta_id` 
	(`id_boleta`) REFERENCES `boleta` (`id_boleta`)
	ON DELETE CASCADE;

ALTER TABLE `candidato` ADD FOREIGN KEY `FK_candidato_ciudadano` 
	(`id_ciudadano`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `candidato` ADD FOREIGN KEY `FK_candidato_partido` 
	(`id_partido`) REFERENCES `partido` (`id_partido`)
	ON DELETE CASCADE;

ALTER TABLE `candidato` ADD FOREIGN KEY `FK_candidato_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `eleccion` ADD FOREIGN KEY `FK_eleccion_territorio` 
	(`id_jurisdiccion`) REFERENCES `territorio` (`id_territorio`)
	ON DELETE CASCADE;

ALTER TABLE `cargo` ADD FOREIGN KEY `FK_cargo_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `consulta` ADD FOREIGN KEY `FK_consulta_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `mesa` ADD FOREIGN KEY `FK_mesa_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `mesa` ADD FOREIGN KEY `FK_mesa_presidente` 
	(`id_presidente`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `mesa` ADD FOREIGN KEY `FK_mesa_vicepresidente` 
	(`id_vicepresidente`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `mesa` ADD FOREIGN KEY `FK_mesa_tecnico` 
	(`id_tecnico`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `mesa` ADD FOREIGN KEY `FK_mesa_centro` 
	(`id_centro`) REFERENCES `centro` (`id_centro`)
	ON DELETE CASCADE;

ALTER TABLE `opcion` ADD FOREIGN KEY `FK_opcion_boleta` 
	(`id_boleta`) REFERENCES `boleta` (`id_boleta`)
	ON DELETE CASCADE;

ALTER TABLE `opcion` ADD FOREIGN KEY `FK_opcion_eleccion` 
	(`id_eleccion`) REFERENCES `eleccion` (`id_eleccion`)
	ON DELETE CASCADE;

ALTER TABLE `territorio` ADD FOREIGN KEY `FK_territorio_padre` 
	(`id_padre`) REFERENCES `territorio` (`id_territorio`)
	ON DELETE SET NULL;

ALTER TABLE `voto` ADD FOREIGN KEY `FK_voto_contenido` 
	(`id_contenido`) REFERENCES `boleta` (`id_boleta`)
	ON DELETE CASCADE;

ALTER TABLE `voto` ADD FOREIGN KEY `FK_voto_mesa` 
	(`id_mesa`) REFERENCES `mesa` (`id_mesa`)
	ON DELETE CASCADE;

ALTER TABLE `fiscal` ADD FOREIGN KEY `FK_fiscal_partido` 
	(`id_partido`) REFERENCES `partido` (`id_partido`)
	ON DELETE CASCADE;

ALTER TABLE `fiscal` ADD FOREIGN KEY `FK_fiscal_ciudadano` 
	(`id_ciudadano`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `fiscal` ADD FOREIGN KEY `FK_fiscal_mesa` 
	(`id_mesa`) REFERENCES `mesa` (`id_mesa`)
	ON DELETE CASCADE;

ALTER TABLE `vota_en` ADD FOREIGN KEY `FK_vota_en_ciudadano` 
	(`id_ciudadano`) REFERENCES `ciudadano` (`id_ciudadano`)
	ON DELETE CASCADE;

ALTER TABLE `vota_en` ADD FOREIGN KEY `FK_vota_en_mesa` 
	(`id_mesa`) REFERENCES `mesa` (`id_mesa`)
	ON DELETE CASCADE;

-- Unique Keys?


COMMIT;
