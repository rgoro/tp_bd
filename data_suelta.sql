-- TP 1 Bases de Datos 2015 1c
-- Autor: Román Gorojovsky, L.U. 530/02

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
START TRANSACTION;

USE `elecciones`

-- Territorios
TRUNCATE TABLE `territorio`;
INSERT INTO `territorio` (`nombre`, `nivel`) VALUES ('Argentina', 'nacion');

SELECT LAST_INSERT_ID() INTO @ID_ARGENTINA;

INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('Buenos Aires', 'provincia', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_BUENOS_AIRES;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('Mendoza', 'provincia', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_MENDOZA;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('Cordoba', 'provincia', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_CORDOBA;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('Neuquen', 'provincia', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_NEUQUEN;

INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('San Martin', 'municipio', @ID_BUENOS_AIRES);
SELECT LAST_INSERT_ID() INTO @ID_SM_BSAS;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('San Rafael', 'municipio', @ID_MENDOZA);
SELECT LAST_INSERT_ID() INTO @ID_SAN_RAFAEL;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('San Martin', 'municipio', @ID_MENDOZA);
SELECT LAST_INSERT_ID() INTO @ID_SM_MZA;
INSERT INTO `territorio` (`nombre`, `nivel`, `id_padre`) VALUES ('Cordoba', 'municipio', @ID_CORDOBA);
SELECT LAST_INSERT_ID() INTO @ID_CORDOBA_CIUDAD;

-- Elecciones
TRUNCATE TABLE `eleccion`;
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'consulta', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_CONS_NAC;
INSERT INTO `consulta` (`id_eleccion`, `texto`) VALUES (@ID_CONS_NAC, '¿Al final en qué quedamos?');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-31', 'consulta', @ID_SAN_RAFAEL);
SELECT LAST_INSERT_ID() INTO @ID_CONS_MUNI;
INSERT INTO `consulta` (`id_eleccion`, `texto`) VALUES (@ID_CONS_MUNI, 'De qué color se pintarán las paradas de el colectivo');

INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_PRES1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_PRES1, 'Presidente');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_PRES2;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_PRES2, 'Presidente');

INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_ARGENTINA);
SELECT LAST_INSERT_ID() INTO @ID_DIPU_NAC;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_DIPU_NAC, 'Diputado');

INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_BUENOS_AIRES);
SELECT LAST_INSERT_ID() INTO @ID_GOB_BSAS1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_BSAS1, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_BUENOS_AIRES);
SELECT LAST_INSERT_ID() INTO @ID_GOB_BSAS2;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_BSAS2, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_CORDOBA);
SELECT LAST_INSERT_ID() INTO @ID_GOB_COR1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_COR1, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_CORDOBA);
SELECT LAST_INSERT_ID() INTO @ID_GOB_COR2;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_COR2, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_MENDOZA);
SELECT LAST_INSERT_ID() INTO @ID_GOB_MZA1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_MZA1, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_MENDOZA);
SELECT LAST_INSERT_ID() INTO @ID_GOB_MZA2;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_MZA2, 'Gobernador');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_NEUQUEN);
SELECT LAST_INSERT_ID() INTO @ID_GOB_NQN1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_GOB_NQN1, 'Gobernador');

INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_SM_BSAS);
SELECT LAST_INSERT_ID() INTO @ID_INT_SM_BSAS;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_INT_SM_BSAS, 'Intendente');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_SM_MZA);
SELECT LAST_INSERT_ID() INTO @ID_INT_SM_MZA1;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_INT_SM_MZA1, 'Intendente');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2019-05-05', 'cargo', @ID_SM_MZA);
SELECT LAST_INSERT_ID() INTO @ID_INT_SM_MZA2;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_INT_SM_MZA2, 'Intendente');
INSERT INTO `eleccion` (`fecha`, `tipo`, `id_jurisdiccion`) VALUES ('2015-05-03', 'cargo', @ID_CORDOBA_CIUDAD);
SELECT LAST_INSERT_ID() INTO @ID_INT_CBA;
INSERT INTO `cargo` (`id_eleccion`, `titulo`) VALUES (@ID_INT_CBA, 'Intendente');


TRUNCATE `partido`;
INSERT INTO `partido` (`nombre`) VALUES ('Partido Colorado'), ('Partido Colocado'), ('Partido Verde'), ('Partido de Marrek'), ('Partido nro 1');

COMMIT;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
