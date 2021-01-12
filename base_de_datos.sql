-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-08-2020 a las 17:27:28
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pruebita2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarPedido` (IN `id_u` INT, IN `id_p` INT, IN `cantidad` INT, OUT `total` DOUBLE, OUT `id_new` INT)  NO SQL
BEGIN

SELECT (precio_producto*cantidad)
  INTO total 
  FROM producto
 WHERE id_producto = id_p;

INSERT INTO pedido_usuario (id_usuario,precio_total_pedido) 
                    VALUES (id_u,total);
      
SELECT LAST_INSERT_ID()
INTO id_new;

INSERT INTO pedidousuario_and_producto (id_producto,cantidad,id_pedidoUsuario) 
VALUES (id_p,cantidad,id_new);

END$$

CREATE DEFINER=`` PROCEDURE `pagarListProducto` (IN `id_prod` INT(100), IN `cant_prod` INT(255), OUT `id_p_x_u` INT(100), OUT `total` DOUBLE)  NO SQL
BEGIN

SELECT id_pedidoUsuario 
  INTO id_p_x_u
  FROM pedido_usuario
 ORDER BY 1 DESC
 LIMIT 1;
 
 
INSERT INTO `pedidousuario_and_producto` (`cantidad`, `id_pedidoUsuario`, `id_producto`) 
                                VALUES (cant_prod,id_p_x_u,id_prod        );


SELECT SUM(p.precio_producto * pp.cantidad) 
  INTO total
  FROM producto AS p,
       pedidousuario_and_producto AS pp
  WHERE p.id_producto = id_prod
    AND p.id_producto = pp.id_producto
    AND pp.id_pedidoUsuario = id_p_x_u;

UPDATE pedido_usuario 
   SET precio_total_pedido = total 
 WHERE id_pedidoUsuario = id_p_x_u;
 
 
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePedidoById` (IN `id_p` INT, IN `id_pu` INT, IN `cant` INT)  NO SQL
BEGIN

insert into pedidousuario_and_producto (id_producto,cantidad,id_pedidoUsuario) values (id_p,cant,id_pu);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `nomb_categoria` varchar(50) DEFAULT NULL,
  `foto_categoria` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nomb_categoria`, `foto_categoria`) VALUES
(1, 'Insumo', 'insumos.jpg'),
(2, 'Decoraciones', 'decoracion.jpg'),
(3, 'Accesorios', 'accesorios.jpg'),
(4, 'Chocolateria', 'chocolateria.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `id_marca` int(11) NOT NULL,
  `desc_marca` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidousuario_and_producto`
--

CREATE TABLE `pedidousuario_and_producto` (
  `cantidad` int(11) DEFAULT NULL,
  `id_pedidoUsuario` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pedidousuario_and_producto`
--

INSERT INTO `pedidousuario_and_producto` (`cantidad`, `id_pedidoUsuario`, `id_producto`) VALUES
(23, 1, 3),
(4, 6, 3),
(10, 7, 3),
(4, 8, 3),
(15, 9, 3),
(15, 10, 15),
(15, 11, 15),
(15, 12, 15),
(15, 13, 15),
(15, 15, 15),
(1, 16, 15),
(2, 17, 32),
(2, 17, 33),
(4, 17, 14),
(3, 17, 1),
(1, 17, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_usuario`
--

CREATE TABLE `pedido_usuario` (
  `id_pedidoUsuario` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `flg_pedido` varchar(1) DEFAULT 'N',
  `precio_total_pedido` double DEFAULT NULL,
  `fecha_pedido` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pedido_usuario`
--

INSERT INTO `pedido_usuario` (`id_pedidoUsuario`, `id_usuario`, `flg_pedido`, `precio_total_pedido`, `fecha_pedido`) VALUES
(1, 1, 'N', 314.79, NULL),
(2, 1, 'N', 2111, NULL),
(3, 1, 'N', NULL, '2020-08-13'),
(4, 1, 'N', NULL, '2020-08-13'),
(5, 1, 'N', NULL, '2020-08-13'),
(6, 1, 'N', 59.96, '2020-08-13'),
(7, 1, 'N', 149.9, '2020-08-13'),
(8, 1, 'N', 59.96, '2020-08-13'),
(9, 1, 'N', 224.85, '2020-08-13'),
(10, 1, 'N', 63, '2020-08-13'),
(11, 1, 'N', 63, '2020-08-13'),
(12, 1, 'N', 63, '2020-08-13'),
(13, 1, 'N', 63, '2020-08-13'),
(14, 1, 'N', NULL, '2020-08-13'),
(15, 1, 'N', 63, '2020-08-13'),
(16, 1, 'N', 4.2, '2020-08-13'),
(17, 2, 'N', 14.99, '2020-08-13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `caract_producto` varchar(255) DEFAULT NULL,
  `nomb_producto` varchar(50) DEFAULT NULL,
  `precio_producto` double DEFAULT 0,
  `img_producto` varchar(100) DEFAULT NULL,
  `desc_producto` varchar(255) DEFAULT NULL,
  `_id_marca` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `id_categoria`, `caract_producto`, `nomb_producto`, `precio_producto`, `img_producto`, `desc_producto`, `_id_marca`) VALUES
(1, 1, 'Harina de maiz preparada para tortas y kekes.', 'HARINA PASTELERA', 4, 'https://i.ibb.co/xSb9vrT/3269-1.png', 'Se llama harina pastelera o panificable a la harina con una fuerza intermedia (W175) que no contiene tanto gluten como la harina de fuerza. Esto se consigue seleccionando el trigo para la molienda porque no todas las variedades del cereal tienen la misma.', NULL),
(3, 3, 'Molde antiadherente para raviolis con rodillo.', 'MOLDE RAVIOLIS CON RODILLO', 14.99, 'https://i.ibb.co/bFpVTxY/molde-raviolis-con-rodillo.jpg', 'Molde antiadherente para raviolis con rodillo. Realiza rápidamente raviolis y dulces rellenos. Fabricado en aluminio estampado sobre una base de acero esmaltado. Incluye tacos de goma antideslizantes y rodillo de madera.', NULL),
(14, 1, 'Endulzante de barillas de azucar. ', 'AZÚCAR RUBIA', 5.9, 'https://i.ibb.co/2MNSS4C/Wafers-Nik-Costa-Chocolate-Pack-6-Unid-x-29-g-402457001.png', 'endulzante natural de bara de azucar extraidas de las sierra peruana, y almacenada por industrias azucareras.', NULL),
(15, 1, 'Endulzante de barillas de azucar. ', 'AZÚCAR BLANCA', 4.2, 'https://i.ibb.co/zGCYGRd/20084094-1.png', 'endulzante natural de bara de azucar extraidas de las sierra peruana, y almacenada por industrias azucareras.', NULL),
(16, 1, 'Mantequilla natura vegetal sin grasa. ', 'MANTEQUILLA SELLO DE ORO', 5.9, 'https://i.ibb.co/K0jjqsz/sello-de-oro-margarina-a-granel-x-2-kg.jpg', 'mantequilla natural de grasas vegetales y sin conservantes de leche destilada de vaca.', NULL),
(17, 1, 'Endulzante de granos de cacao. ', 'COCOA WINTER', 2.9, 'https://i.ibb.co/ZW5xTz8/winter-s-cocoa-x-160-gr.jpg', 'endulzante natural de bara de azucar extraidas de las sierra peruana, y almacenada por industrias azucareras.', NULL),
(18, 1, 'Endulzante de granos de cacao de azucar. ', 'CACAO EN POLVO HERSHEY', 3.9, 'https://i.ibb.co/85tBC5s/cacao.jpg', 'Endulzante natural de bara de azucar extraidas de las sierra peruana, y almacenada por industrias azucareras.', NULL),
(20, 1, 'Trozos de duraznos enlatados. ', 'DURAZNO EN ALMIBAR - DOS CABALLOS LATA 820g', 1.9, 'https://i.ibb.co/SJcdqg9/frontal-3311.png', 'Trozos de duraznos enlatados. ', NULL),
(21, 2, 'Figuritas de azúcar con forma de confeti, bolitas y barritas de múltiples colores, de Happy Sprinkles.', 'SPRINKLES MULTICOLOR', 3.49, 'https://i.ibb.co/Y3tWQR2/sprinkles-multicolor-birthday-parade-happy-sprinkles-1.jpg', 'Figuritas de azúcar con forma de confeti, bolitas y barritas de múltiples colores, de Happy Sprinkles.', NULL),
(22, 2, 'Set de 24 decoraciones de azúcar comestibles, ideales para decorar tartas, cupcakes y galletas.', 'FLORES ROSAS GRANDES', 9.99, 'https://i.ibb.co/zPKP3xg/set-flores-rosa-de-azucar-grande.jpg', 'Están elaboradas a mano con colores de extracción natural. El tallo de la flor no es comestible.', NULL),
(23, 2, 'Set de 24 decoraciones de azúcar comestibles, ideales para decorar tartas, cupcakes y galletas.', '\r\nFLORES ROSAS GRANDES MARFILES DE AZÚCAR', 9.9, 'https://i.ibb.co/DG0Bsz1/set-flores-rosa-de-azucar-grande-marfil.jpg', 'Están elaboradas a mano con colores de extracción natural. El tallo de la flor no es comestible.', NULL),
(24, 2, 'Set de 6 orquídeas de azúcar comestibles, ideales para decorar tartas, cupcakes y galletas.', 'ORQUÍDEAS PHALENOPSIS DE AZÚCAR LILAS, FUCSIAS Y V', 9.9, 'https://i.ibb.co/87rmDNn/set-6-orquideas-de-azucar-lila-fucsia-y-violeta-decora-1.jpg', 'Están elaboradas a mano con colores de extracción natural. Incluye diseños en 3 colores distintos: lila, fucsia y violeta. El tallo de la flor no es comestible.', NULL),
(25, 2, 'Set de 12 decoraciones de azúcar comestibles, ideales para decorar tartas, cupcakes y galletas.', 'FLORES GERBERAS LILAS, FUCSIAS Y VIOLETAS DE AZÚCA', 5.49, 'https://i.ibb.co/kSBg7sD/set-flores-gerbera-de-azucar-lila-fucsia-y-violeta.jpg', 'Están elaboradas a mano con colores de extracción natural. Incluye diseños en 3 colores distintos: lila, fucsia y violeta. El tallo de la flor no es comestible.', NULL),
(26, 2, '6 rosas de mazapán de colores blanco, rojo y rosa, con hojas verdes.', 'ROSAS DE MAZAPÁN SURTIDAS', 11.99, 'https://i.ibb.co/JvcGrKV/rosas-de-mazapan-surtidas.jpg', '6 rosas de mazapán de colores blanco, rojo y rosa, con hojas verdes. Alta calidad en forma, diseño y color.', NULL),
(27, 2, '125 nubes de azúcar o marshmallows, con dianas de colores, totalmente comestibles, ideales para la elaboración y decoración de las tartas de chuches.', 'NUBES DE AZÚCAR DIANAS DE COLORES ARCOÍRIS', 5.49, 'https://i.ibb.co/YhWy3PN/nubes-de-az-car-dianas-colores-arco-ris-125-fini0.jpg', 'Son perfectas para realizar tartas de chuches y servir en cumpleaños, comuniones o cualquier tipo de celebración. Fini Golosinas, con una experiencia de más de 40 años, es la mayor empresa española en la fabricación y distribución de golosinas. Es la marc', NULL),
(28, 2, '125 nubes de azúcar o marshmallows, rosas y blancas con forma de corazón, totalmente comestibles, ideales para la elaboración y decoración de las tartas de chuches.', 'NUBES DE AZÚCAR CORAZONES ROSAS Y BLANCOS', 5.49, 'https://i.ibb.co/n7VnBcw/nubes-de-az-car-rosas-y-blancas-corazones-125-fini.jpg', 'Son perfectas para realizar tartas de chuches y servir en cumpleaños, comuniones o cualquier tipo de celebración. Fini Golosinas, con una experiencia de más de 40 años, es la mayor empresa española en la fabricación y distribución de golosinas. Es la marc', NULL),
(29, 2, 'Set de 12 decoraciones de azúcar comestibles, ideales para decorar tartas, cupcakes y galletas.', 'FLORES AZALEAS BLANCAS Y AMARILLAS DE AZÚCAR ', 9.99, 'https://i.ibb.co/G2brgY4/set-flores-azalea-de-azucar-blanca-y-amarilla-3.jpg', 'Están elaboradas a mano con colores de extracción natural. Es de color blanca con el centro amarillo. El tallo de la flor no es comestible.', NULL),
(30, 2, 'Set de 50 cápsulas para cupcakes de oblea, 100% comestibles de color marrón, de Dekora.', 'CÁPSULAS COMESTIBLES DE OBLEA MARRONES', 4.49, 'https://i.ibb.co/0BnQMXx/capsulas-comestibles-de-oblea-marron-sin-gluten-dekora.jpg', 'Set de 50 cápsulas para cupcakes de oblea, 100% comestibles de color marrón, de Dekora. Estas cápsulas comestibles son aptas para meter en el horno y resisten temperaturas hasta 220 ºC.', NULL),
(31, 2, 'Set de 50 cápsulas para cupcakes de oblea, 100% comestibles de color beis, de Dekora.', 'CÁPSULAS COMESTIBLES DE OBLEA BEIS', 4.49, 'https://i.ibb.co/6nsP2pq/capsulas-comestibles-de-oblea-beis-sin-gluten-dekora.jpg', 'Set de 50 cápsulas para cupcakes de oblea, 100% comestibles de color marrón, de Dekora. Estas cápsulas comestibles son aptas para meter en el horno y resisten temperaturas hasta 220 ºC.', NULL),
(32, 3, 'Rodillo antiadherente con opción de grosor ajustable en 4 medidas diferentes.', 'RODILLO ANTIADHERENTE GROSOR AJUSTABLE 25 CM', 12.99, 'https://i.ibb.co/p4MQpvG/rodillo-antiadherente-grosor-ajustable-25-cm-2.jpg', 'Rodillo antiadherente con opción de grosor ajustable en 4 medidas diferentes. La superficie del rodillo garantiza la antiadherencia del mismo, por lo que será más fácil usarlo con todo tipo de masas sin que un exceso de harina pueda alterar la composición', NULL),
(33, 3, 'Rodillo de madera de haya de la marca Joseph Joseph, de extraordinaria calidad, con discos extraíbles de distintos colores para conseguir masas de distinto grosor.', 'RODILLO 4 MEDIDAS DISCOS EXTRAÍBLES MULTICOLOR 34 ', 12.99, 'https://i.ibb.co/Q840Lkp/rodillo-4-medidas-discos-extraibles-multicolor-cm-joseph-joseph.jpg', 'Apto para todo tipo de masas: masa de galletas, bases de pizza, hojas de lasaña, hojaldre, glaseado, fondant, mazapán, empanadas,etc. Incluye guías de medida grabadas en la madera. Los discos son aptos para lavar en el lavavajillas. El rodillo se recomien', NULL),
(34, 3, 'Rodillo de madera de haya Kruskavel o nudoso, para crear hoyuelos en la masa del pan.', 'RODILLO DE MADERA KRUSKAVEL 25 CM', 15.99, 'https://i.ibb.co/qWqcQMk/rodillo-de-madera-kruskavel-25-cm-exxent.jpg', 'Rodillo de madera de haya Kruskavel o nudoso, para crear hoyuelos en la masa del pan. El rodillo gira independientemente de las empuñaduras, para un cómodo uso. Está especialmente diseñado para elaborar los típicos panes crujientes con hoyuelos.', NULL),
(35, 3, 'Set compuesto por 8 anillos de diferentes colores, perfectos para asegurar un grosor uniforme a la masa.', 'SET 8 ANILLOS PARA RODILLO 4 CM DIÁMETRO', 9.99, 'https://i.ibb.co/hYM8ZvN/set-8-anillos-para-rodillo-grande.jpg', 'Set compuesto por 8 anillos de diferentes colores, perfectos para asegurar un grosor uniforme a la masa. Son ideales para el rodillo PME de 40 cm o para cualquier rodillo con un diámetro de 4 cm, como el rodillo Wilton de 50 cm.', NULL),
(36, 3, 'Batidor con un divertido mango en forma de jirafa y con un tamaño ideal para ser usado por niños.', 'BATIDOR CON VARILLAS Y MANGO DE JIRAFA 24 CM', 9.99, 'https://i.ibb.co/mDfh36k/batidor-con-mango-de-jirafa.jpg', 'Batidor con un divertido mango en forma de jirafa y con un tamaño ideal para ser usado por niños. Este batidor es ideal para los pequeños aspirantes a cocineros de la casa ya que su mango, además de aportar color y diversión a tu cocina, hace que sea muy ', NULL),
(37, 3, 'Kit de recipientes y tazas con diseño compacto, ideales para un ahorro práctico del espacio.', 'KIT DE RECIPIENTES Y TAZAS APILABLES', 9.99, 'https://i.ibb.co/6J4njhL/kit-de-recipientes-y-tazas-apilables-joseph-joseph.jpg', 'El diseño innovador, de diversos colores y medidas, permite que los elementos individuales se apilen ordenadamente entre sí lo que permite que ocupen el mínimo espacio.', NULL),
(38, 3, 'Práctico set de 3 boles y 1 separador de claras y yemas de huevo, ideal para la elaboración de masas.', 'SET 3 BOLES Y SEPARADOR DE YEMAS', 20.49, 'https://i.ibb.co/XLrhTCm/set-3-boles-y-separador-de-yemas-joseph-joseph.jpg', 'Este set está compuesto por 3 recipientes de diferentes tamaños con base antideslizante, perfectos para preparar masas; y 1 utensilio para romper huevos con orificios para serparar las claras de las yemas. ', NULL),
(39, 3, 'Bol tradicional de cerámica de gran calidad en 2 tonos: azul pastel y blanco roto.', 'BOL DE CERÁMICA AZUL PASTEL 4 LITROS', 25.49, 'https://i.ibb.co/sjvbTtX/bol-ceramica-azul-pastel-litros.jpg', 'Bol tradicional de cerámica de gran calidad en 2 tonos: azul pastel y blanco roto. Es ideal para preparar alimentos, amasar, mezclar, batir,etc. El exterior, de color azul pastel, tiene relieve que además de darle un toque decorativo, ayuda a cogerlo con ', NULL),
(40, 3, 'Batidor de silicona, ideal para el suavizado de salsas como la crema de leche o batir huevo, vinagretas', 'BATIDOR DE SILICONA CON VARILLAS ROSA 25 CM', 11.99, 'https://i.ibb.co/C5n6b7r/batidor-de-silicona-rosa-kitchen-craft.jpg', 'Batidor de silicona, ideal para el suavizado de salsas como la crema de leche o batir huevo, vinagretas,etc. Perfecto para usar en superficies antiadherentes y resistente a las manchas.', NULL),
(41, 3, 'Batidor de varillas de De Buyer, con varillas de acero inoxidable y mango ergonómico de plástico.', 'BATIDOR DE VARILLAS GÖMA 30 CM', 11.99, 'https://i.ibb.co/3S9H1Hm/batidor-de-varillas-de-buyer.jpg', 'Batidor de varillas de De Buyer, con varillas de acero inoxidable y mango ergonómico de plástico. Es un utensilio indispensable para la cocina y para usar en recetas de repostería y panadería para batir, mezclar, airear todo tipo de salsas y cremas, para ', NULL),
(42, 3, 'Bol multifunción con colador integrado, grande.', 'BOL MULTIFUNCIÓN COLADOR INTEGRADO', 24.49, 'https://i.ibb.co/1sF9Gg1/bol-prepara-y-sirve-grande-blanco.jpg', 'Bol multifunción con colador integrado, grande. Combina las funciones de un recipiente de preparación, de un colador y un recipiente para servir, todo en un cómodo diseño.', NULL),
(43, 3, 'Kit compuesto por 9 piezas de boquillas, adaptadores y clavo, de la marca Decora.', 'KIT BOQUILLAS PARA FLORES, ROSAS Y HOJAS, ADAPTADO', 12.99, 'https://i.ibb.co/wzc2tKb/kit-boquillas-adaptadores-y-clavo-grande-9-piezas-decora-jpg1-1.jpg', 'Kit compuesto por 9 piezas de boquillas, adaptadores y clavo, de la marca Decora. Se recomienda lavar las piezas en agua tibia y secarlas con cuidado.', NULL),
(44, 3, 'Kit compuesto por 9 piezas de boquillas, adaptadores y clavo, de la marca Decora.', 'KIT BOQUILLAS PARA FLORES Y HOJAS Y ADAPTADORES 8 ', 12.99, 'https://i.ibb.co/yXh15Jq/kit-boquillas-y-adaptadores-8-piezas-decora-1-1.jpg', 'Kit compuesto por 9 piezas de boquillas y adaptadores, de la marca Decora. Se recomienda lavar las piezas en agua tibia y secarlas con cuidado.', NULL),
(45, 3, 'Kit compuesto por 6 piezas de boquillas y un clavo, de la marca Decora.', 'KIT BOQUILLAS Y CLAVO 7 PIEZAS', 12.99, 'https://i.ibb.co/nDQWj0H/kit-boquillas-y-clavo-7-piezas-decora-jpg1-1.jpg', 'Kit compuesto por 6 piezas de boquillas, adaptadores y clavo, de la marca Decora. Se recomienda lavar las piezas en agua tibia y secarlas con cuidado.', NULL),
(46, 3, 'Kit compuesto por 9 piezas de boquillas, adaptadores y clavo, de la marca Decora.', 'KIT BOQUILLAS, ADAPTADORES Y CLAVO PEQUEÑO 9 PIEZA', 12.99, 'https://i.ibb.co/fqC3c3h/kit-boquillas-adaptador-y-clavo-9-piezas-decora-1-1.jpg', 'Kit compuesto por 9 piezas de boquillas, adaptadores y clavo, de la marca Decora. Se recomienda lavar las piezas en agua tibia y secarlas con cuidado.', NULL),
(47, 3, 'Caja de 100 mangas desechables en tamaño grande, de 55 centímetros de longitud.', 'MANGAS DESECHABLES 55 CM', 19.99, 'https://i.ibb.co/55dfKBX/mangas-pasteleras-desechables-1.jpg', 'Caja de 100 mangas desechables en tamaño grande, de 55 centímetros de longitud. Ideales para rellenar con cremas, masas, buttercream, frosting... y usar en la decoración y el relleno de tartas, cupcakes o galletas.', NULL),
(48, 3, 'Kit de 7 herramientas y un libro para aprender a hacer flores con buttercream, de Wilton.', 'KIT PARA APRENDER A HACER FLORES CON BUTTERCREAM', 14.99, 'https://i.ibb.co/zmjp8HF/kit-para-aprender-a-hacer-flores-con-buttercream-wilton.jpg', 'Kit de 7 herramientas y un libro para aprender a hacer flores con buttercream, de Wilton. Es ideal para aprender muchas técnicas básicas y proyectos de flores con buttercream en casa.', NULL),
(49, 3, 'Set de boquillas de Wilton con 22 piezas y todo lo necesario para la decoración con manga pastelera.', 'SET DE BOQUILLAS 22 PIEZAS', 22.49, 'https://i.ibb.co/Rh9JjH7/set-de-boquillas-22-piezas-wilton.jpg', 'Todo ello presentado en una caja organizadora de plástico rígido reforzado de larga duración, con apartados para colocar de forma ordenada las boquillas y con un apartado mayor para almacenar las boquillas de mayor tamaño.', NULL),
(50, 3, 'Set de boquillas Wilton con 9 piezas para la decoración con manga: 8 boquillas básicas y caja de lavado para boquillas.', 'SET DE BOQUILLAS Y CAJA DE LAVADO 9 PIEZAS', 15.49, 'https://i.ibb.co/s6PcPqd/set-de-boquillas-9-piezas-wilton.jpg', 'Set de boquillas Wilton con 9 piezas para la decoración con manga: 8 boquillas básicas y caja con bandeja de lavado para boquillas. La caja de almacenamiento está fabricada en plástico rígido reforzado de larga duración, y cuenta una bandeja organizadora ', NULL),
(52, 4, 'El cacao en polvo de Callebaut es cacao puro 100% con proceso holandés y se hace del mejor chocolate belga.', 'CACAO EN POLVO PURO 100% ALCALINIZADO', 25.99, 'https://i.ibb.co/89x74jQ/cacao-en-polvo-puro-100-alcalinizado-22-24-1-kg-callebaut.jpg', 'Tiene un color marrón cálido y un sabor a chocolate rotundo y muy agradable que viene principalmente de la mezcla de habas de África occidental que forma su base. Está aderezado con habas aromáticas de otras regiones de África, Latinoamérica y Asia.', NULL),
(53, 4, 'El chocolate blanco en callets contiene un 28% de cacao y se hace del mejor chocolate belga.', 'CALLETS CHOCOLATE BLANCO 1 KG', 16.99, 'https://i.ibb.co/cNd58Mq/callets-chocolate-blanco-1-kg-callebaut.jpg', 'Estos callets están diseñados para que se fusionen entre sí y tengan un sabor cremoso y equilibrado. Perfecto para hacer bombones o figuras de chocolate. Pero también es perfecto para decorar tus cupcakes y galletas.', NULL),
(54, 4, 'El chocolate con leche en callets contiene un 33,6% de cacao y se hace del mejor chocolate belga.', 'CALLETS CHOCOLATE CON LECHE 1 KG', 25.49, 'https://i.ibb.co/6yVJFqv/callets-chocolate-con-leche-1-kg-callebaut.jpg', 'Estos callets están diseñados para que se fusionen entre sí y tengan un sabor cremoso y equilibrado. Perfecto para hacer bombones o figuras de chocolate. Pero también es perfecto para decorar tus cupcakes y galletas.', NULL),
(55, 4, 'El chocolate negro en callets contiene un 54,5% de cacao y se hace del mejor chocolate belga.', 'CALLETS CHOCOLATE NEGRO 1 KG', 23.99, 'https://i.ibb.co/YXKVhd9/callets-chocolate-negro-1-kg-callebaut.jpg', 'Estos callets están diseñados para que se fusionen entre sí y tengan un sabor cremoso y equilibrado. Perfecto para hacer bombones o figuras de chocolate. Pero también es perfecto para decorar tus cupcakes y galletas.', NULL),
(56, 4, 'El chocolate blanco en callets contiene un 28% de cacao y se hace del mejor chocolate belga.', 'CALLETS CHOCOLATE BLANCO 2,5 KG', 23.99, 'https://i.ibb.co/56P5j02/callets-chocolate-blanco-1.jpg', 'El chocolate blanco en callets contiene un 28% de cacao y se hace del mejor chocolate belga. Estos callets están diseñados para que se fusionen entre sí y tengan un sabor cremoso y equilibrado.', NULL),
(57, 4, 'El chocolate rosa ruby en callets contiene un 47,3% de cacao y se hace del mejor chocolate belga.', 'CALLETS CHOCOLATE RUBY ROSA 2,5 KG', 23.49, 'https://i.ibb.co/zxVRx0H/callets-chocolate-ruby-rosa-2-5-kg-callebaut-1.jpg', 'El chocolate rosa ruby en callets contiene un 47,3% de cacao y se hace del mejor chocolate belga. Estos callets están diseñados para que se fusionen entre sí y tengan un sabor cremoso y equilibrado.', NULL),
(58, 4, 'Cobertura de chocolate con leche en gotas, ideal para elaborar dulces o como decoración.', 'COBERTURA DE CHOCOLATE CON LECHE 250 GR', 11.99, 'https://i.ibb.co/p0nFdX6/cobertura-de-chocolate-con-leche-250-gr.jpg', 'Cobertura de chocolate con leche en gotas, ideal para elaborar dulces o como decoración. También es perfecta para preparar chocolates, ganaché, cubiertas de tartas, helados.', NULL),
(59, 4, 'Cobertura de chocolate blanco en gotas, ideal para elaborar dulces o como decoración.', 'COBERTURA DE CHOCOLATE BLANCO 250 GR', 11.99, 'https://i.ibb.co/gjCDMLQ/cobertura-de-chocolate-blanco-250-gr.jpg', 'Cobertura de chocolate blanco en gotas, ideal para elaborar dulces o como decoración. También es perfecta para preparar chocolates, ganaché, cubiertas de tartas, helados.', NULL),
(60, 4, 'Cobertura de chocolate con negro en gotas, ideal para elaborar dulces o como decoración.', 'COBERTURA DE CHOCOLATE NEGRO 250 GR', 11.99, 'https://i.ibb.co/mXSFjxm/cobertura-de-chocolate-negro-250-gr.jpg', 'Cobertura de chocolate con negro en gotas, ideal para elaborar dulces o como decoración. También es perfecta para preparar chocolates, ganaché, cubiertas de tartas, helados.', NULL),
(61, 1, 'Harina de maiz con sabor a vainilla', 'BLANCA FLOR KEKE CASERO X 500 GR. VAINILLA', 6.99, 'https://i.ibb.co/2FNCSJn/blanca-flor-keke-casero-x-500-gr-vainilla.jpg', 'Se llama harina pastelera o panificable a la harina con una fuerza intermedia (W175) que no contiene tanto gluten como la harina de fuerza. Esto se consigue seleccionando el trigo para la molienda porque no todas las variedades del cereal tienen la misma.', NULL),
(62, 1, 'Harina de maiz con sabor a chocolate', 'BLANCA FLOR TORTA CASERO X 500 GR. CHOCOLATE', 6.99, 'https://i.ibb.co/VH0KSmT/blanca-flor-torta-casero-x-500-gr-chocolate.jpg', 'Se llama harina pastelera o panificable a la harina con una fuerza intermedia (W175) que no contiene tanto gluten como la harina de fuerza. Esto se consigue seleccionando el trigo para la molienda porque no todas las variedades del cereal tienen la misma.', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `desc_rol` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `desc_rol`) VALUES
(1, 'administrador'),
(2, 'colaborador'),
(3, 'cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `usuario` varchar(20) DEFAULT NULL,
  `contraseña` varchar(20) DEFAULT NULL,
  `nomb_usuario` varchar(45) DEFAULT NULL,
  `ape_usuario` varchar(45) DEFAULT NULL,
  `dni` varchar(8) DEFAULT NULL,
  `e_mail` varchar(25) DEFAULT NULL,
  `celular` varchar(9) DEFAULT NULL,
  `_id_rol` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `usuario`, `contraseña`, `nomb_usuario`, `ape_usuario`, `dni`, `e_mail`, `celular`, `_id_rol`) VALUES
(1, 'angelhr', '12345678', 'Angel', 'Huamanñahui robles', '70544414', 'angelhuamannahui@gmail.co', '920006280', 1),
(2, 'alvaro', '12345678', 'Alvaro', 'De la cruz Quispe', '70544413', NULL, NULL, 1),
(3, 'fabrizio', '12345678', 'Fabrizio', 'Condori Guzman', '', NULL, NULL, 1),
(4, 'angelo', '12345678', 'Luis Angel', 'Inga Mendoza', '', NULL, NULL, 3),
(10, 'juana45', '123456', 'juanito', 'alcachofa', NULL, NULL, NULL, 3),
(26, 'angelo1', 'angel123', 'angel', 'huamnañahui', NULL, NULL, NULL, 3),
(27, 'angelo12', 'angel123', 'angel', 'huamnañahui', NULL, NULL, NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`id_marca`);

--
-- Indices de la tabla `pedidousuario_and_producto`
--
ALTER TABLE `pedidousuario_and_producto`
  ADD KEY `id_pedidoUsuario` (`id_pedidoUsuario`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `pedido_usuario`
--
ALTER TABLE `pedido_usuario`
  ADD PRIMARY KEY (`id_pedidoUsuario`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `_id_marca` (`_id_marca`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `_id_rol` (`_id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pedido_usuario`
--
ALTER TABLE `pedido_usuario`
  MODIFY `id_pedidoUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `pedidousuario_and_producto`
--
ALTER TABLE `pedidousuario_and_producto`
  ADD CONSTRAINT `pedidousuario_and_producto_ibfk_1` FOREIGN KEY (`id_pedidoUsuario`) REFERENCES `pedido_usuario` (`id_pedidoUsuario`),
  ADD CONSTRAINT `pedidousuario_and_producto_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `pedido_usuario`
--
ALTER TABLE `pedido_usuario`
  ADD CONSTRAINT `pedido_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`_id_marca`) REFERENCES `marca` (`id_marca`),
  ADD CONSTRAINT `producto_ibfk_3` FOREIGN KEY (`_id_marca`) REFERENCES `marca` (`id_marca`),
  ADD CONSTRAINT `producto_ibfk_4` FOREIGN KEY (`_id_marca`) REFERENCES `marca` (`id_marca`),
  ADD CONSTRAINT `producto_ibfk_5` FOREIGN KEY (`_id_marca`) REFERENCES `marca` (`id_marca`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`_id_rol`) REFERENCES `rol` (`id_rol`),
  ADD CONSTRAINT `usuario_ibfk_2` FOREIGN KEY (`_id_rol`) REFERENCES `rol` (`id_rol`),
  ADD CONSTRAINT `usuario_ibfk_3` FOREIGN KEY (`_id_rol`) REFERENCES `rol` (`id_rol`),
  ADD CONSTRAINT `usuario_ibfk_4` FOREIGN KEY (`_id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
