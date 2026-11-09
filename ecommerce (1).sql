-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-11-2025 a las 18:54:10
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ecommerce`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admins`
--

CREATE TABLE `admins` (
  `id_admin` int(11) NOT NULL,
  `rol_admin` text DEFAULT NULL,
  `name_admin` text DEFAULT NULL,
  `email_admin` text DEFAULT NULL,
  `password_admin` text DEFAULT NULL,
  `token_admin` text DEFAULT NULL,
  `token_exp_admin` text DEFAULT NULL,
  `date_created_admin` date DEFAULT NULL,
  `date_updated_admin` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `admins`
--

INSERT INTO `admins` (`id_admin`, `rol_admin`, `name_admin`, `email_admin`, `password_admin`, `token_admin`, `token_exp_admin`, `date_created_admin`, `date_updated_admin`) VALUES
(1, 'admin', 'Jose Tienda', 'admin@ecommerce.com', '$2a$07$azybxcags23425sdg23sdeanQZqjaf6Birm2NvcYTNtJw24CsO5uq', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NTYyNDY2MjAsImV4cCI6MTc1NjMzMzAyMCwiZGF0YSI6eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBlY29tbWVyY2UuY29tIn19.s-e2bdvVPWAw5ajvWXz55K7l7OnhQ7MeTQyZ1yaNiiE', '1756333020', '2022-09-21', '2025-08-26 22:18:27'),
(3, 'editor', 'Juan Editor', 'editor@ecommerce.com', '$2a$07$azybxcags23425sdg23sdeanQZqjaf6Birm2NvcYTNtJw24CsO5uq', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MTY4NTEwMDAsImV4cCI6MTcxNjkzNzQwMCwiZGF0YSI6eyJpZCI6IjMiLCJlbWFpbCI6ImVkaXRvckBlY29tbWVyY2UuY29tIn19.HOzoTXcQDEkjEATdFeM2EjWOts3p7U6L45aj444WRrk', '1716937400', '2024-05-27', '2024-05-27 23:05:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banners`
--

CREATE TABLE `banners` (
  `id_banner` int(11) NOT NULL,
  `location_banner` text DEFAULT NULL,
  `id_category_banner` int(11) NOT NULL DEFAULT 0,
  `id_subcategory_banner` int(11) NOT NULL DEFAULT 0,
  `background_banner` text DEFAULT NULL,
  `text_banner` text DEFAULT NULL,
  `discount_banner` text DEFAULT NULL,
  `end_banner` date DEFAULT NULL,
  `status_banner` int(11) NOT NULL DEFAULT 1,
  `date_created_banner` date DEFAULT NULL,
  `date_updated_banner` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `banners`
--

INSERT INTO `banners` (`id_banner`, `location_banner`, `id_category_banner`, `id_subcategory_banner`, `background_banner`, `text_banner`, `discount_banner`, `end_banner`, `status_banner`, `date_created_banner`, `date_updated_banner`) VALUES
(10, 'HOME', 0, 0, 'bg.jpg', 'Ofertas especiales', '40', '2025-12-31', 1, '2025-06-14', '2025-06-14 23:36:19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carts`
--

CREATE TABLE `carts` (
  `id_cart` int(11) NOT NULL,
  `id_user_cart` int(11) NOT NULL DEFAULT 0,
  `id_product_cart` int(11) NOT NULL DEFAULT 0,
  `id_variant_cart` int(11) NOT NULL DEFAULT 0,
  `id_seller_cart` int(11) DEFAULT NULL,
  `quantity_cart` int(11) DEFAULT 0,
  `price_cart` double NOT NULL DEFAULT 0,
  `ref_cart` text DEFAULT NULL,
  `order_cart` text DEFAULT NULL,
  `method_cart` text DEFAULT NULL,
  `date_created_cart` date DEFAULT NULL,
  `date_updated_cart` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id_category` int(11) NOT NULL,
  `name_category` text DEFAULT NULL,
  `url_category` text DEFAULT NULL,
  `icon_category` text DEFAULT NULL,
  `image_category` text DEFAULT NULL,
  `description_category` text DEFAULT NULL,
  `keywords_category` text DEFAULT NULL,
  `subcategories_category` int(11) DEFAULT 0,
  `products_category` int(11) DEFAULT 0,
  `views_category` int(11) DEFAULT 0,
  `status_category` int(11) DEFAULT 1,
  `date_created_category` date DEFAULT NULL,
  `date_updated_category` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id_category`, `name_category`, `url_category`, `icon_category`, `image_category`, `description_category`, `keywords_category`, `subcategories_category`, `products_category`, `views_category`, `status_category`, `date_created_category`, `date_updated_category`) VALUES
(8, 'Alimentos Y Bebidas', 'alimentos-y-bebidas', 'fas fa-utensils', 'alimentos-y-bebidas.jpg', 'Descubre nuestra amplia selección de alimentos y bebidas pensados para satisfacer todos los gustos y estilos de vida. Desde productos gourmet, snacks saludables, bebidas artesanales, hasta alimentos orgánicos y básicos para tu despensa diaria. Compra en línea con confianza, disfruta de productos frescos, de calidad y con entrega rápida hasta tu hogar. ¡Encuentra todo lo que necesitas en un solo lugar!', 'alimentos,bebidas,snacks,productos,supermercado', 6, 29, 0, 1, '2025-06-14', '2025-07-03 03:53:16'),
(9, 'Productos Fisicos', 'productos-fisicos', 'fas fa-box-open', 'productos-fisicos.jpg', 'Explora nuestra variedad de productos físicos diseñados para cubrir tus necesidades diarias y mejorar tu estilo de vida. Desde tecnología, artículos para el hogar, accesorios personales, hasta herramientas, juguetes y más. Cada producto cuenta con garantía de calidad, métodos de pago seguros y envíos rápidos. ¡Compra lo que necesitas con total confianza y recíbelo en la puerta de tu casa!', 'productos ,fisicos,articulos,materiales,ropa', 4, 9, 0, 1, '2025-06-14', '2025-07-03 04:54:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favorites`
--

CREATE TABLE `favorites` (
  `id_favorite` int(11) NOT NULL,
  `id_user_favorite` int(11) NOT NULL DEFAULT 0,
  `id_product_favorite` int(11) NOT NULL DEFAULT 0,
  `date_created_favorite` date DEFAULT NULL,
  `date_updated_favorite` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `favorites`
--

INSERT INTO `favorites` (`id_favorite`, `id_user_favorite`, `id_product_favorite`, `date_created_favorite`, `date_updated_favorite`) VALUES
(22, 8, 74, '2025-07-15', '2025-07-15 00:12:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id_order` int(11) NOT NULL,
  `uniqid_order` text DEFAULT NULL,
  `id_user_order` int(11) NOT NULL DEFAULT 0,
  `id_product_order` int(11) NOT NULL DEFAULT 0,
  `id_variant_order` int(11) NOT NULL DEFAULT 0,
  `quantity_order` int(11) NOT NULL DEFAULT 0,
  `price_order` double NOT NULL DEFAULT 0,
  `ref_order` text DEFAULT NULL,
  `number_order` text DEFAULT NULL,
  `method_order` text DEFAULT NULL,
  `warranty_order` int(11) NOT NULL DEFAULT 0,
  `process_order` int(11) NOT NULL DEFAULT 0,
  `track_order` text DEFAULT NULL,
  `start_date_order` date DEFAULT NULL,
  `medium_date_order` date DEFAULT NULL,
  `end_date_order` date DEFAULT NULL,
  `date_created_order` date DEFAULT NULL,
  `date_updated_order` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `id_product` int(11) NOT NULL,
  `id_category_product` int(11) NOT NULL DEFAULT 0,
  `id_subcategory_product` int(11) NOT NULL DEFAULT 0,
  `id_seller_product` int(11) DEFAULT NULL,
  `name_product` text DEFAULT NULL,
  `url_product` text DEFAULT NULL,
  `image_product` text DEFAULT NULL,
  `description_product` text DEFAULT NULL,
  `keywords_product` text DEFAULT NULL,
  `info_product` longtext DEFAULT NULL,
  `views_product` int(11) NOT NULL DEFAULT 0,
  `sales_product` int(11) NOT NULL DEFAULT 0,
  `status_product` int(11) NOT NULL DEFAULT 1,
  `date_created_product` date DEFAULT NULL,
  `date_updated_product` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`id_product`, `id_category_product`, `id_subcategory_product`, `id_seller_product`, `name_product`, `url_product`, `image_product`, `description_product`, `keywords_product`, `info_product`, `views_product`, `sales_product`, `status_product`, `date_created_product`, `date_updated_product`) VALUES
(51, 8, 18, 1, 'Menu Del Dia', 'menu-del-dia', 'menu-del-dia.jpg', 'Restaurante El Escondite', 'menu del dia,comida corrida', '<h2 data-start=\"272\" data-end=\"296\">???? <strong data-start=\"278\" data-end=\"294\">Menú del Día</strong></h2>\r\n<p data-start=\"297\" data-end=\"336\"><strong data-start=\"297\" data-end=\"336\">Comida completa, casera y deliciosa</strong></p>\r\n<p data-start=\"338\" data-end=\"355\">???? <strong data-start=\"341\" data-end=\"353\">Entrada:</strong></p>\r\n<ul data-start=\"356\" data-end=\"409\">\r\n<li data-start=\"356\" data-end=\"409\">\r\n<p data-start=\"358\" data-end=\"409\">Sopa de fideos / Consomé de pollo / Crema del día</p>\r\n</li>\r\n</ul>\r\n<p data-start=\"411\" data-end=\"445\">????️ <strong data-start=\"415\" data-end=\"443\">Plato fuerte (a elegir):</strong></p>\r\n<ul data-start=\"446\" data-end=\"654\">\r\n<li data-start=\"446\" data-end=\"484\">\r\n<p data-start=\"448\" data-end=\"484\">Mole de olla con arroz y tortillas</p>\r\n</li>\r\n<li data-start=\"485\" data-end=\"525\">\r\n<p data-start=\"487\" data-end=\"525\">Chiles rellenos con arroz y frijoles</p>\r\n</li>\r\n<li data-start=\"526\" data-end=\"574\">\r\n<p data-start=\"528\" data-end=\"574\">Chilaquiles rojos o verdes con pollo o huevo</p>\r\n</li>\r\n<li data-start=\"575\" data-end=\"614\">\r\n<p data-start=\"577\" data-end=\"614\">Pollo con Nopales con guarnición</p>\r\n</li>\r\n<li data-start=\"615\" data-end=\"654\">\r\n<p data-start=\"617\" data-end=\"654\">Enchiladas verdes con queso o pollo</p><p data-start=\"617\" data-end=\"654\">Pechuga empanizada</p><p data-start=\"617\" data-end=\"654\">Pollo con mole</p><p data-start=\"617\" data-end=\"654\">Flautas de Pollo</p><p data-start=\"617\" data-end=\"654\">Huevos (cocidos,revueltos,estrellados,a la mexicana ) con guarnicion</p>\r\n</li>\r\n</ul>\r\n<p data-start=\"656\" data-end=\"681\">???? <strong data-start=\"659\" data-end=\"679\">Bebida incluida:</strong></p>\r\n<ul data-start=\"682\" data-end=\"771\">\r\n<li data-start=\"682\" data-end=\"732\">\r\n<p data-start=\"684\" data-end=\"732\">Agua fresca del día (horchata, jamaica, limón)</p>\r\n</li>\r\n<li data-start=\"733\" data-end=\"771\">\r\n<p data-start=\"735\" data-end=\"771\">Opción: refresco con costo adicional</p>\r\n</li>\r\n</ul>\r\n<p data-start=\"773\" data-end=\"789\">???? <strong data-start=\"776\" data-end=\"787\">Postre:</strong></p>\r\n<ul data-start=\"790\" data-end=\"834\">\r\n<li data-start=\"790\" data-end=\"834\">\r\n<p data-start=\"792\" data-end=\"834\">Fruta fresca</p>\r\n</li>\r\n</ul>\r\n<p data-start=\"836\" data-end=\"939\">???? <strong data-start=\"839\" data-end=\"867\">Precio fijo por persona:</strong> $120 MXN<br data-start=\"876\" data-end=\"879\">\r\n<em data-start=\"879\" data-end=\"937\">(Incluye todo: entrada + plato fuerte + bebida + postre)</em></p>\r\n<p data-start=\"941\" data-end=\"1047\">???? Disponible de lunes a viernes de <strong data-start=\"977\" data-end=\"1002\">1:00 p.m. a 4:30 p.m.</strong><br data-start=\"1002\" data-end=\"1005\">\r\n???? Comida para llevar o disfrutar en local</p>', 49, 1, 1, '2025-06-15', '2025-08-26 19:10:14'),
(52, 8, 19, 1, 'Banderillas', 'banderillas', 'banderillas.jpg', 'La buena charla', 'comida rapida,banderillas,salchicha', '<h2 data-start=\"173\" data-end=\"221\">???? Banderillas – Botana crujiente y deliciosa</h2>\r\n<p data-start=\"223\" data-end=\"504\">Disfruta nuestras <strong data-start=\"241\" data-end=\"269\">banderillas estilo feria</strong>, preparadas con <strong data-start=\"286\" data-end=\"338\">salchichas empanizadas en masa de harina de maíz</strong>, fritas al momento hasta quedar doradas y crujientes. Son perfectas como antojo, snack o acompañamiento, y se sirven con salsas, mostaza, kétchup o aderezo al gusto.</p>\r\n<hr data-start=\"506\" data-end=\"509\">\r\n<h3 data-start=\"511\" data-end=\"543\">???? Ingredientes principales:</h3>\r\n<ul data-start=\"544\" data-end=\"752\">\r\n<li data-start=\"544\" data-end=\"578\">\r\n<p data-start=\"546\" data-end=\"578\">Salchicha tipo jumbo o regular</p>\r\n</li>\r\n<li data-start=\"579\" data-end=\"620\">\r\n<p data-start=\"581\" data-end=\"620\">Mezcla de harina con huevo y especias</p>\r\n</li>\r\n<li data-start=\"621\" data-end=\"648\">\r\n<p data-start=\"623\" data-end=\"648\">Palillo largo de madera</p>\r\n</li>\r\n<li data-start=\"649\" data-end=\"678\">\r\n<p data-start=\"651\" data-end=\"678\">Aceite vegetal para freír</p>\r\n</li>\r\n<li data-start=\"679\" data-end=\"752\">\r\n<p data-start=\"681\" data-end=\"752\">Salsas a elegir: kétchup, mostaza, mayonesa, valentina, aderezo ranch</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"754\" data-end=\"757\">\r\n<p data-start=\"759\" data-end=\"913\">✅ Preparadas al momento<br data-start=\"782\" data-end=\"785\">\r\n???? Crujientes por fuera, suaves por dentro<br data-start=\"827\" data-end=\"830\">\r\n???? Disponibles individuales o en paquete<br data-start=\"870\" data-end=\"873\">\r\n???? Opción para niños o combo con papas</p>', 0, 0, 1, '2025-06-18', '2025-07-31 17:57:36'),
(53, 8, 19, 2, 'Alitas', 'alitas', 'alitas.jpg', 'La buena charla', 'alitas,comida,comida rapida,fastfood', '<h2 data-start=\"168\" data-end=\"220\">???? Alitas de Pollo – Crujientes y llenas de sabor</h2>\r\n<p data-start=\"222\" data-end=\"491\">¡El antojo perfecto en cada mordida! Nuestras <strong data-start=\"268\" data-end=\"287\">alitas de pollo</strong> están sazonadas y fritas a la perfección, luego bañadas en la <strong data-start=\"350\" data-end=\"374\">salsa de tu elección</strong>, desde suaves y dulces hasta intensamente picantes. Se sirven calientes, con aderezo y bastones de apio o zanahoria.</p>\r\n<hr data-start=\"493\" data-end=\"496\">\r\n<h3 data-start=\"498\" data-end=\"530\">???? Ingredientes principales:</h3>\r\n<ul data-start=\"531\" data-end=\"691\">\r\n<li data-start=\"531\" data-end=\"560\">\r\n<p data-start=\"533\" data-end=\"560\">Alitas de pollo marinadas</p>\r\n</li>\r\n<li data-start=\"561\" data-end=\"606\">\r\n<p data-start=\"563\" data-end=\"606\">Harina sazonada (para versión empanizada)</p>\r\n</li>\r\n<li data-start=\"607\" data-end=\"626\">\r\n<p data-start=\"609\" data-end=\"626\">Salsas a elegir</p>\r\n</li>\r\n<li data-start=\"627\" data-end=\"658\">\r\n<p data-start=\"629\" data-end=\"658\">Aderezo ranch o blue cheese</p>\r\n</li>\r\n<li data-start=\"659\" data-end=\"691\">\r\n<p data-start=\"661\" data-end=\"691\">Guarnición: apio y/o zanahoria</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"693\" data-end=\"696\">\r\n<h3 data-start=\"698\" data-end=\"725\">????️ Salsas disponibles:</h3>\r\n<ul data-start=\"726\" data-end=\"908\">\r\n<li data-start=\"726\" data-end=\"749\">\r\n<p data-start=\"728\" data-end=\"749\"><strong data-start=\"728\" data-end=\"747\">Buffalo clásica</strong></p>\r\n</li>\r\n<li data-start=\"750\" data-end=\"772\">\r\n<p data-start=\"752\" data-end=\"772\"><strong data-start=\"752\" data-end=\"770\">Mango habanero</strong></p>\r\n</li>\r\n<li data-start=\"773\" data-end=\"800\">\r\n<p data-start=\"775\" data-end=\"800\"><strong data-start=\"775\" data-end=\"798\">BBQ dulce o ahumada</strong></p>\r\n</li>\r\n<li data-start=\"801\" data-end=\"827\">\r\n<p data-start=\"803\" data-end=\"827\"><strong data-start=\"803\" data-end=\"825\">Limón con pimienta</strong></p>\r\n</li>\r\n<li data-start=\"828\" data-end=\"853\">\r\n<p data-start=\"830\" data-end=\"853\"><strong data-start=\"830\" data-end=\"851\">Tamarindo picante</strong></p></li>\r\n<li data-start=\"876\" data-end=\"908\">\r\n<p data-start=\"878\" data-end=\"908\"><strong data-start=\"878\" data-end=\"908\">Inferno ???? (extra picante)</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"910\" data-end=\"913\">\r\n<p data-start=\"915\" data-end=\"1051\">✅ Servidas en porciones de 6, 12 o 24 piezas<br data-start=\"959\" data-end=\"962\">\r\n???? Combos con papas y bebida disponibles<br data-start=\"1002\" data-end=\"1005\">\r\n???? Para comer aquí, llevar o pedir a domicilio</p>', 1, 0, 1, '2025-06-18', '2025-07-31 17:57:39'),
(54, 8, 19, 2, 'Hamburguesa', 'hamburguesa', 'hamburguesa.jpg', 'La buena charla', 'hamburguesa,comida rapida,fast food', '<h2 data-start=\"277\" data-end=\"330\">???? <strong data-start=\"283\" data-end=\"330\">Hamburguesa Clásica – Sabor que nunca falla</strong></h2>\r\n<p data-start=\"332\" data-end=\"539\">Nuestra <strong data-start=\"340\" data-end=\"363\">hamburguesa clásica</strong> es todo lo que esperas: <strong data-start=\"388\" data-end=\"425\">carne de res jugosa a la parrilla</strong>, queso derretido, lechuga fresca, jitomate, cebolla morada y aderezo especial, todo en un pan suave con ajonjolí.</p>\r\n<p data-start=\"541\" data-end=\"592\">También puedes pedirla en dos deliciosas versiones:</p>\r\n<ul data-start=\"594\" data-end=\"730\">\r\n<li data-start=\"594\" data-end=\"657\">\r\n<h2 data-start=\"251\" data-end=\"312\">???????? <strong data-start=\"259\" data-end=\"312\">Hamburguesa Hawaiana – Sabor tropical con actitud</strong></h2><p data-start=\"596\" data-end=\"657\">\r\n</p><p data-start=\"314\" data-end=\"656\">¡Prepárate para una explosión de sabor! Nuestra <strong data-start=\"362\" data-end=\"386\">Hamburguesa Hawaiana</strong> es el equilibrio perfecto entre lo <strong data-start=\"422\" data-end=\"449\">jugoso, dulce y ahumado</strong>. Lleva una rebanada de <strong data-start=\"473\" data-end=\"494\">piña a la plancha</strong>, <strong data-start=\"496\" data-end=\"513\">jamón ahumado</strong>, queso fundido, lechuga fresca, jitomate y cebolla morada, todo en un <strong data-start=\"584\" data-end=\"614\">pan artesanal con ajonjolí</strong>. Una experiencia tropical en cada bocado.</p></li><li data-start=\"658\" data-end=\"730\">\r\n</li>\r\n</ul>\r\n<hr data-start=\"732\" data-end=\"735\">\r\n<p data-start=\"737\" data-end=\"835\">✅ Disponible en combo con papas y bebida<br data-start=\"777\" data-end=\"780\">\r\n???? Preparada al momento<br data-start=\"803\" data-end=\"806\">\r\n???? ¡Personalízala a tu gusto!</p>', 0, 0, 1, '2025-06-18', '2025-07-31 17:57:43'),
(55, 8, 19, 1, 'Burritos', 'burritos', 'burritos.jpg', 'La buena charla', 'comida rapida,burritos', '<h2 data-start=\"219\" data-end=\"258\">???? <strong data-start=\"225\" data-end=\"258\">Burritos – Envueltos en sabor</strong></h2>\r\n<p data-start=\"260\" data-end=\"544\">Nuestros <strong data-start=\"269\" data-end=\"281\">burritos</strong> están hechos con <strong data-start=\"299\" data-end=\"336\">tortilla de harina grande y suave</strong>, rellenos hasta el borde con ingredientes frescos, sabrosos y calientes. Cada mordida es una combinación perfecta de <strong data-start=\"454\" data-end=\"493\">proteína, guarnición y sazón casero</strong>, ideales para comer al paso o disfrutar con calma.</p>\r\n<hr data-start=\"546\" data-end=\"549\">\r\n<h3 data-start=\"551\" data-end=\"576\">???? Ingredientes base:</h3>\r\n<ul data-start=\"577\" data-end=\"751\">\r\n<li data-start=\"577\" data-end=\"595\">\r\n<p data-start=\"579\" data-end=\"595\">Arroz sazonado</p>\r\n</li>\r\n<li data-start=\"596\" data-end=\"627\">\r\n<p data-start=\"598\" data-end=\"627\">Frijoles refritos o enteros</p>\r\n</li>\r\n<li data-start=\"628\" data-end=\"647\">\r\n<p data-start=\"630\" data-end=\"647\">Queso derretido</p>\r\n</li>\r\n<li data-start=\"648\" data-end=\"677\">\r\n<p data-start=\"650\" data-end=\"677\">Pico de gallo o guacamole</p>\r\n</li>\r\n<li data-start=\"678\" data-end=\"706\">\r\n<p data-start=\"680\" data-end=\"706\">Aderezo o salsa a elegir</p>\r\n</li>\r\n<li data-start=\"707\" data-end=\"751\">\r\n<p data-start=\"709\" data-end=\"751\">Todo envuelto en tortilla de harina grande</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"753\" data-end=\"756\">\r\n<h3 data-start=\"758\" data-end=\"786\">???? Opciones de proteína:</h3>\r\n<ul data-start=\"787\" data-end=\"959\">\r\n<li data-start=\"787\" data-end=\"806\">\r\n<p data-start=\"789\" data-end=\"806\"><strong data-start=\"789\" data-end=\"804\">Carne asada</strong></p>\r\n</li>\r\n<li data-start=\"807\" data-end=\"847\">\r\n<p data-start=\"809\" data-end=\"847\"><strong data-start=\"809\" data-end=\"845\">Pollo a la parrilla o empanizado</strong></p>\r\n</li>\r\n<li data-start=\"848\" data-end=\"872\">\r\n<p data-start=\"850\" data-end=\"872\"><strong data-start=\"850\" data-end=\"870\">Chorizo con papa</strong></p>\r\n</li>\r\n<li data-start=\"873\" data-end=\"909\">\r\n<p data-start=\"875\" data-end=\"909\"><strong data-start=\"875\" data-end=\"907\">Arrachera (opcional premium)</strong></p>\r\n</li>\r\n<li data-start=\"910\" data-end=\"959\">\r\n<p data-start=\"912\" data-end=\"959\"><strong data-start=\"912\" data-end=\"959\">Vegetariano (con nopales, queso y frijoles)</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"961\" data-end=\"964\">\r\n<p data-start=\"966\" data-end=\"1078\">✅ Preparados al momento<br data-start=\"989\" data-end=\"992\">\r\n???? Disponibles individuales o en combo<br data-start=\"1030\" data-end=\"1033\">\r\n???? Opción de dorarlos al grill para más sabor</p>', 0, 0, 1, '2025-06-23', '2025-07-31 17:57:57'),
(56, 8, 19, 1, 'Chapatas', 'chapatas', 'chapatas.jpg', 'La buena charla', 'comida rapida,chapata', '<h2 data-start=\"178\" data-end=\"235\">???? <strong data-start=\"184\" data-end=\"235\">Chapata – Crujiente por fuera, suave por dentro</strong></h2>\r\n<p data-start=\"237\" data-end=\"540\">Nuestra <strong data-start=\"245\" data-end=\"256\">chapata</strong> está elaborada con pan artesanal estilo italiano, ligeramente tostado para lograr una textura crujiente por fuera y suave por dentro. Rellena con <strong data-start=\"403\" data-end=\"457\">ingredientes frescos y combinaciones irresistibles</strong>, es la opción perfecta para quienes buscan una comida ligera, sabrosa y diferente.</p>\r\n<hr data-start=\"542\" data-end=\"545\">\r\n<h3 data-start=\"547\" data-end=\"572\">???? Ingredientes base:</h3>\r\n<ul data-start=\"573\" data-end=\"780\">\r\n<li data-start=\"573\" data-end=\"598\">\r\n<p data-start=\"575\" data-end=\"598\">Pan chapata artesanal</p>\r\n</li>\r\n<li data-start=\"599\" data-end=\"645\">\r\n<p data-start=\"601\" data-end=\"645\">Queso derretido (manchego, panela o gouda)</p>\r\n</li>\r\n<li data-start=\"646\" data-end=\"703\">\r\n<p data-start=\"648\" data-end=\"703\">Vegetales frescos (lechuga, jitomate, cebolla morada)</p>\r\n</li>\r\n<li data-start=\"704\" data-end=\"737\">\r\n<p data-start=\"706\" data-end=\"737\">Aderezo de la casa o mayonesa</p>\r\n</li>\r\n<li data-start=\"738\" data-end=\"780\">\r\n<p data-start=\"740\" data-end=\"780\">Opción de acompañar con papas o ensalada</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"782\" data-end=\"785\">\r\n<h3 data-start=\"787\" data-end=\"815\">???? Rellenos disponibles:</h3>\r\n<ul data-start=\"816\" data-end=\"1002\">\r\n<li data-start=\"816\" data-end=\"837\">\r\n<p data-start=\"818\" data-end=\"837\"><strong data-start=\"818\" data-end=\"835\">Jamón y queso</strong></p>\r\n</li>\r\n<li data-start=\"838\" data-end=\"875\">\r\n<p data-start=\"840\" data-end=\"875\"><strong data-start=\"840\" data-end=\"873\">Pechuga de pollo a la plancha</strong></p>\r\n</li>\r\n<li data-start=\"876\" data-end=\"905\">\r\n<p data-start=\"878\" data-end=\"905\"><strong data-start=\"878\" data-end=\"903\">Carne asada con queso</strong></p>\r\n</li>\r\n<li data-start=\"906\" data-end=\"968\">\r\n<p data-start=\"908\" data-end=\"968\"><strong data-start=\"908\" data-end=\"966\">Vegetariana (con queso, aguacate, espinaca y jitomate)</strong></p>\r\n</li>\r\n<li data-start=\"969\" data-end=\"1002\">\r\n<p data-start=\"971\" data-end=\"1002\"><strong data-start=\"971\" data-end=\"1002\">Atún con mayonesa y lechuga</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"1004\" data-end=\"1007\">\r\n<p data-start=\"1009\" data-end=\"1124\">✅ Preparada al momento<br data-start=\"1031\" data-end=\"1034\">\r\n???? Disponible en combo con bebida o papas<br data-start=\"1075\" data-end=\"1078\">\r\n???? Ideal para lunch, cena ligera o para llevar</p>', 0, 0, 1, '2025-06-23', '2025-07-31 17:59:33'),
(57, 8, 19, 2, 'Sandwich', 'sandwich', 'sandwich.jpg', 'La buena charla', 'comida rapida', '<h2 data-start=\"205\" data-end=\"250\">???? <strong data-start=\"211\" data-end=\"250\">Club Sándwich – Tres pisos de sabor</strong></h2>\r\n<p data-start=\"252\" data-end=\"507\">El clásico <strong data-start=\"263\" data-end=\"280\">Club Sándwich</strong> es ideal para los que aman comer bien. Preparado con <strong data-start=\"334\" data-end=\"363\">tres capas de pan tostado</strong>, rellenas de <strong data-start=\"377\" data-end=\"458\">jamón, pechuga de pavo, tocino crujiente, queso, lechuga, jitomate y mayonesa</strong>. Una combinación completa, sabrosa y balanceada.</p>\r\n<p data-start=\"509\" data-end=\"574\">Perfecto para almuerzo, cena ligera o como antojo durante el día.</p>\r\n<hr data-start=\"576\" data-end=\"579\">\r\n<h3 data-start=\"581\" data-end=\"613\">???? Ingredientes principales:</h3>\r\n<ul data-start=\"614\" data-end=\"765\">\r\n<li data-start=\"614\" data-end=\"647\">\r\n<p data-start=\"616\" data-end=\"647\">Pan blanco o integral tostado</p>\r\n</li>\r\n<li data-start=\"648\" data-end=\"685\">\r\n<p data-start=\"650\" data-end=\"685\">Jamón de pierna y pechuga de pavo</p>\r\n</li>\r\n<li data-start=\"686\" data-end=\"703\">\r\n<p data-start=\"688\" data-end=\"703\">Tocino dorado</p>\r\n</li>\r\n<li data-start=\"704\" data-end=\"734\">\r\n<p data-start=\"706\" data-end=\"734\">Queso americano o manchego</p>\r\n</li>\r\n<li data-start=\"735\" data-end=\"765\">\r\n<p data-start=\"737\" data-end=\"765\">Lechuga, jitomate y mayonesa</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"767\" data-end=\"770\">\r\n<p data-start=\"772\" data-end=\"923\">✅ Disponible en combo con papas a la francesa y bebida<br data-start=\"826\" data-end=\"829\">\r\n???? También en versión doble con extra de proteína<br data-start=\"878\" data-end=\"881\">\r\n???? Preparado al momento y servido caliente</p>', 0, 0, 1, '2025-06-23', '2025-07-31 17:59:44'),
(58, 8, 18, 2, 'Costillas De Elote', 'costillas-de-elote', 'costillas-de-elote.jpg', 'La buena charla', 'comida rapida,botana,snaks,elote', '<h2 data-start=\"197\" data-end=\"258\">???? <strong data-start=\"203\" data-end=\"258\">Costillas de Elote – Crujientes, dulces y adictivas</strong></h2>\r\n<p data-start=\"260\" data-end=\"522\">Nuestras <strong data-start=\"269\" data-end=\"291\">costillas de elote</strong> son una explosión de sabor en cada mordida. Preparadas con <strong data-start=\"351\" data-end=\"397\">tiras de elote cortadas al estilo costilla</strong>, doradas al horno o fritas al punto perfecto, y bañadas en <strong data-start=\"457\" data-end=\"481\">salsas irresistibles</strong> como BBQ, buffalo o mantequilla con ajo.</p>\r\n<p data-start=\"524\" data-end=\"661\">Crujientes por fuera, suaves por dentro, y llenas del dulzor natural del maíz, son ideales como entrada, snack o acompañamiento original.</p>\r\n<hr data-start=\"663\" data-end=\"666\">\r\n<h3 data-start=\"668\" data-end=\"700\">???? Ingredientes principales:</h3>\r\n<ul data-start=\"701\" data-end=\"877\">\r\n<li data-start=\"701\" data-end=\"748\">\r\n<p data-start=\"703\" data-end=\"748\">Elote fresco cortado en tiras tipo costilla</p>\r\n</li>\r\n<li data-start=\"749\" data-end=\"773\">\r\n<p data-start=\"751\" data-end=\"773\">Aceite o mantequilla</p>\r\n</li>\r\n<li data-start=\"774\" data-end=\"807\">\r\n<p data-start=\"776\" data-end=\"807\">Sazonador especial de la casa</p>\r\n</li>\r\n<li data-start=\"808\" data-end=\"877\">\r\n<p data-start=\"810\" data-end=\"877\">Salsa a elección (BBQ, buffalo, ajo-parmesano, chipotle-miel, etc.)</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"879\" data-end=\"882\">\r\n<p data-start=\"884\" data-end=\"968\">✅ Opción vegana<br data-start=\"899\" data-end=\"902\">\r\n???? Preparadas al momento<br data-start=\"926\" data-end=\"929\">\r\n???? Disponibles para llevar o en combo</p>', 0, 0, 1, '2025-06-23', '2025-07-31 17:59:53'),
(59, 8, 19, 1, 'Cuernitos', 'cuernitos', 'cuernitos.jpg', 'La buena charla', 'comida rapida,cuernitos', '<h2 data-start=\"196\" data-end=\"261\">???? <strong data-start=\"202\" data-end=\"261\">Cuernitos – Delicadamente hojaldrados y siempre frescos</strong></h2>\r\n<p data-start=\"263\" data-end=\"512\">Disfruta nuestros <strong data-start=\"281\" data-end=\"306\">cuernitos artesanales</strong>, elaborados con masa hojaldrada y mantequilla de alta calidad. Son suaves, ligeros y dorados al punto exacto, con ese equilibrio entre crujiente por fuera y esponjoso por dentro que los hace irresistibles.</p>\r\n<p data-start=\"514\" data-end=\"593\">Perfectos para acompañar tu café, té o como base para un desayuno más completo.</p>\r\n<hr data-start=\"595\" data-end=\"598\">\r\n<h3 data-start=\"600\" data-end=\"628\">???? Opciones disponibles:</h3>\r\n<ul data-start=\"629\" data-end=\"782\">\r\n<li data-start=\"629\" data-end=\"658\">\r\n<p data-start=\"631\" data-end=\"658\"><strong data-start=\"631\" data-end=\"656\">Natural (sin relleno)</strong></p>\r\n</li>\r\n<li data-start=\"659\" data-end=\"691\">\r\n<p data-start=\"661\" data-end=\"691\"><strong data-start=\"661\" data-end=\"689\">Relleno de jamón y queso</strong></p>\r\n</li>\r\n<li data-start=\"692\" data-end=\"738\">\r\n<p data-start=\"694\" data-end=\"738\"><strong data-start=\"694\" data-end=\"736\">Relleno de crema pastelera o chocolate</strong></p>\r\n</li>\r\n<li data-start=\"739\" data-end=\"782\">\r\n<p data-start=\"741\" data-end=\"782\"><strong data-start=\"741\" data-end=\"780\">Tostado con mantequilla y mermelada</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"784\" data-end=\"787\">\r\n<p data-start=\"789\" data-end=\"913\">✅ Recién horneados todos los días<br data-start=\"822\" data-end=\"825\">\r\n☕ Ideal para desayuno o brunch<br data-start=\"855\" data-end=\"858\">\r\n???? Se puede pedir solo o en combo con bebida caliente</p>', 0, 0, 1, '2025-06-23', '2025-07-31 17:59:58'),
(60, 8, 19, 2, 'Empanadas Saladas', 'empanadas-saladas', 'empanadas-saladas.jpg', 'La buena charla', 'comida rapida,empanadas', '<h2 data-start=\"171\" data-end=\"230\">???? <strong data-start=\"177\" data-end=\"230\">Empanadas – Rellenas de sabor, horneadas o fritas</strong></h2>\r\n<p data-start=\"232\" data-end=\"473\">Nuestras <strong data-start=\"241\" data-end=\"254\">empanadas</strong> están hechas con una masa suave y dorada, rellenas con <strong data-start=\"310\" data-end=\"351\">ingredientes frescos y bien sazonados</strong>. Puedes elegirlas <strong data-start=\"370\" data-end=\"392\">horneadas o fritas</strong>, según tu antojo. Son perfectas como snack, entrada o comida rápida para llevar.</p>\r\n<hr data-start=\"475\" data-end=\"478\">\r\n<h3 data-start=\"480\" data-end=\"508\">???? Rellenos disponibles:</h3>\r\n<ul data-start=\"509\" data-end=\"711\">\r\n<li data-start=\"509\" data-end=\"550\">\r\n<p data-start=\"511\" data-end=\"550\"><strong data-start=\"511\" data-end=\"548\">Carne molida con papas y especias</strong></p>\r\n</li>\r\n<li data-start=\"551\" data-end=\"599\">\r\n<p data-start=\"553\" data-end=\"599\"><strong data-start=\"553\" data-end=\"597\">Pollo deshebrado con queso</strong></p>\r\n</li>\r\n<li data-start=\"600\" data-end=\"640\">\r\n<p data-start=\"602\" data-end=\"640\"><b>Hawaiiana</b></p>\r\n</li>\r\n<li data-start=\"641\" data-end=\"666\">\r\n<p data-start=\"643\" data-end=\"666\"><strong data-start=\"643\" data-end=\"664\">Atún con verduras</strong></p></li>\r\n</ul>\r\n<hr data-start=\"713\" data-end=\"716\">\r\n<p data-start=\"718\" data-end=\"845\">✅ Preparadas al momento<br data-start=\"741\" data-end=\"744\">\r\n???? Opción horneada (más ligera) o frita (más crujiente)<br data-start=\"799\" data-end=\"802\">\r\n???? Disponibles individuales o por paquete</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:06'),
(61, 8, 19, 1, 'Hot Dogs', 'hot-dogs', 'hot-dogs.jpg', 'La buena charla', 'comida rapida,salchichas,hotdog,perro caliente', '<h2 data-start=\"185\" data-end=\"238\">???? <strong data-start=\"191\" data-end=\"238\">Hot Dog Clásico – El antojo que nunca falla</strong></h2>\r\n<p data-start=\"240\" data-end=\"505\">Nuestro <strong data-start=\"248\" data-end=\"259\">hot dog</strong> está preparado con <strong data-start=\"279\" data-end=\"307\">salchicha tipo americana</strong> cocida al punto perfecto, servida en un pan suave y ligeramente tostado. Se acompaña con <strong data-start=\"397\" data-end=\"437\">mayonesa, mostaza, kétchup y cebolla</strong>, aunque tú puedes personalizarlo a tu gusto con ingredientes extra.</p>\r\n<hr data-start=\"507\" data-end=\"510\">\r\n<h3 data-start=\"512\" data-end=\"545\">???? Opcionales y complementos:</h3>\r\n<ul data-start=\"546\" data-end=\"704\">\r\n<li data-start=\"546\" data-end=\"566\">\r\n<p data-start=\"548\" data-end=\"566\">Tocino crujiente</p>\r\n</li>\r\n<li data-start=\"567\" data-end=\"594\">\r\n<p data-start=\"569\" data-end=\"594\">Queso fundido o rallado</p>\r\n</li>\r\n<li data-start=\"595\" data-end=\"630\">\r\n<p data-start=\"597\" data-end=\"630\">Jalapeños o chiles en escabeche</p>\r\n</li>\r\n<li data-start=\"631\" data-end=\"685\">\r\n<p data-start=\"633\" data-end=\"685\">Papas fritas o aros de cebolla como acompañamiento</p>\r\n</li>\r\n<li data-start=\"686\" data-end=\"704\">\r\n<p data-start=\"688\" data-end=\"704\">Combo con bebida</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"706\" data-end=\"709\">\r\n<p data-start=\"711\" data-end=\"791\">✅ Preparado al momento<br data-start=\"733\" data-end=\"736\">\r\n???? Disponible en combo<br data-start=\"758\" data-end=\"761\">\r\n???? Ideal para chicos y grandes</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:13'),
(62, 8, 19, 1, 'Papas A La Fancesa', 'papas-a-la-fancesa', 'papas-a-la-fancesa.jpg', 'El mito', 'comida rapida,snaks,papas,a la francesa,fritas', '<h2 data-start=\"162\" data-end=\"218\">???? <strong data-start=\"168\" data-end=\"218\">Papas Fritas – Crujientes, doradas y adictivas</strong></h2>\r\n<p data-start=\"220\" data-end=\"462\">Nuestras <strong data-start=\"229\" data-end=\"245\">papas fritas</strong> son el acompañamiento perfecto para cualquier platillo o para disfrutarlas solas. Cortadas en bastones y fritas al momento hasta quedar <strong data-start=\"382\" data-end=\"416\">doradas y crujientes por fuera</strong>, suaves por dentro, y sazonadas con sal fina.</p>\r\n<hr data-start=\"464\" data-end=\"467\">\r\n<h3 data-start=\"469\" data-end=\"497\">???? Opciones disponibles:</h3>\r\n<ul data-start=\"498\" data-end=\"696\">\r\n<li data-start=\"498\" data-end=\"524\">\r\n<p data-start=\"500\" data-end=\"524\"><strong data-start=\"500\" data-end=\"512\">Clásicas</strong> (con sal)</p>\r\n</li>\r\n<li data-start=\"525\" data-end=\"552\">\r\n<p data-start=\"527\" data-end=\"552\"><strong data-start=\"527\" data-end=\"550\">Con queso derretido</strong></p>\r\n</li>\r\n<li data-start=\"553\" data-end=\"610\">\r\n<p data-start=\"555\" data-end=\"610\"><strong data-start=\"555\" data-end=\"608\">Con aderezo especial (chipotle, ranch, BBQ, etc.)</strong></p>\r\n</li>\r\n<li data-start=\"611\" data-end=\"637\">\r\n<p data-start=\"613\" data-end=\"637\"><strong data-start=\"613\" data-end=\"635\">Con tocino y queso</strong></p>\r\n</li>\r\n<li data-start=\"638\" data-end=\"696\">\r\n<p data-start=\"640\" data-end=\"696\"><strong data-start=\"640\" data-end=\"673\">Papas a la francesa o en gajo</strong> (según disponibilidad)</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"698\" data-end=\"701\">\r\n<p data-start=\"703\" data-end=\"807\">✅ Preparadas al instante<br data-start=\"727\" data-end=\"730\">\r\n???? Servidas calientes y crocantes<br data-start=\"763\" data-end=\"766\">\r\n???? Para acompañar o como snack individual</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:19'),
(63, 8, 19, 2, 'Pambazos', 'pambazos', 'pambazos.jpg', 'La buena charla', 'comida rapida,pambazos', '<h2 data-start=\"193\" data-end=\"248\"><strong data-start=\"199\" data-end=\"248\">Pambazos – Tradición mexicana con mucho sabor</strong></h2>\r\n<p data-start=\"250\" data-end=\"572\">Nuestros <strong data-start=\"259\" data-end=\"271\">pambazos</strong> están hechos con pan suave <strong data-start=\"299\" data-end=\"330\">bañado en salsa de guajillo</strong>, dorado en comal y relleno de <strong data-start=\"361\" data-end=\"396\">papas con chorizo bien sazonado</strong>, lechuga fresca, crema, queso rallado y salsa al gusto. Dorados al punto exacto, son un clásico de la comida callejera que conquista por su sabor auténtico y su textura única.</p>\r\n<hr data-start=\"574\" data-end=\"577\">\r\n<h3 data-start=\"579\" data-end=\"599\">???? Ingredientes:</h3>\r\n<ul data-start=\"600\" data-end=\"806\">\r\n<li data-start=\"600\" data-end=\"629\">\r\n<p data-start=\"602\" data-end=\"629\">Pan tipo telera o bolillo</p>\r\n</li>\r\n<li data-start=\"630\" data-end=\"657\">\r\n<p data-start=\"632\" data-end=\"657\">Salsa de chile guajillo</p>\r\n</li>\r\n<li data-start=\"658\" data-end=\"689\">\r\n<p data-start=\"660\" data-end=\"689\">Relleno de papa con chorizo</p>\r\n</li>\r\n<li data-start=\"690\" data-end=\"708\">\r\n<p data-start=\"692\" data-end=\"708\">Lechuga picada</p>\r\n</li>\r\n<li data-start=\"709\" data-end=\"748\">\r\n<p data-start=\"711\" data-end=\"748\">Crema, queso fresco rallado y salsa</p>\r\n</li>\r\n<li data-start=\"749\" data-end=\"806\">\r\n<p data-start=\"751\" data-end=\"806\">Opción de agregar jalapeños, cebolla o extra de chorizo</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"808\" data-end=\"811\">\r\n<p data-start=\"813\" data-end=\"909\">✅ Preparados al momento<br data-start=\"836\" data-end=\"839\">\r\n???? Crujientes por fuera, suaves por dentro<br data-start=\"881\" data-end=\"884\">\r\n????️ Sabor 100% mexicano</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:23'),
(64, 8, 20, 2, 'Cafe', 'cafe', 'cafe.jpg', 'El mito del cafe', 'cafe,bebidas,bebidas calientes', '<h2 data-start=\"250\" data-end=\"302\">☕ <strong data-start=\"255\" data-end=\"302\">Bebidas Calientes – El Mito del Café Adonai</strong></h2>\r\n<p data-start=\"304\" data-end=\"561\">Disfruta una deliciosa selección de <strong data-start=\"340\" data-end=\"373\">bebidas calientes artesanales</strong>, preparadas al momento con ingredientes de alta calidad y opciones de sabores personalizables. Perfectas para cualquier ocasión: desayuno, tarde de estudio o simplemente para consentirte.</p>\r\n<hr data-start=\"563\" data-end=\"566\">\r\n<h3 data-start=\"568\" data-end=\"615\">???? <strong data-start=\"575\" data-end=\"615\">Sabores disponibles ( 14 oz):</strong></h3>\r\n<ul data-start=\"617\" data-end=\"849\">\r\n<li data-start=\"617\" data-end=\"654\">\r\n<p data-start=\"619\" data-end=\"654\"><strong data-start=\"619\" data-end=\"640\">Horchata caliente</strong>&nbsp;</p>\r\n</li>\r\n<li data-start=\"655\" data-end=\"682\">\r\n<p data-start=\"657\" data-end=\"682\"><strong data-start=\"657\" data-end=\"668\">Mazapán</strong>&nbsp;</p><p data-start=\"657\" data-end=\"682\"><b>Americano</b></p>\r\n</li>\r\n<li data-start=\"683\" data-end=\"721\">\r\n<p data-start=\"685\" data-end=\"721\"><strong data-start=\"685\" data-end=\"707\">Moka / Moka blanco</strong>&nbsp;</p>\r\n</li>\r\n<li data-start=\"722\" data-end=\"755\">\r\n<p data-start=\"724\" data-end=\"755\"><strong data-start=\"724\" data-end=\"741\">Chocoavellana</strong>&nbsp;</p>\r\n</li>\r\n<li data-start=\"756\" data-end=\"780\">\r\n<p data-start=\"758\" data-end=\"780\"><strong data-start=\"758\" data-end=\"766\">Taro</strong>&nbsp;</p>\r\n</li>\r\n<li data-start=\"781\" data-end=\"811\">\r\n<p data-start=\"783\" data-end=\"811\"><strong data-start=\"783\" data-end=\"797\">Chai negro</strong>&nbsp;</p>\r\n</li>\r\n<li data-start=\"812\" data-end=\"849\">\r\n<p data-start=\"814\" data-end=\"849\"><strong data-start=\"814\" data-end=\"835\">Capuccino / Latte</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"851\" data-end=\"854\">\r\n<h3 data-start=\"856\" data-end=\"888\">???? <strong data-start=\"863\" data-end=\"886\">Sabores especiales:</strong></h3>\r\n<p data-start=\"889\" data-end=\"1016\"><br></p>\r\n<hr data-start=\"1170\" data-end=\"1173\">\r\n<p data-start=\"1175\" data-end=\"1290\">✅ Personaliza tu bebida a tu gusto<br data-start=\"1209\" data-end=\"1212\">\r\n???? Preparadas al momento y servidas calientes<br data-start=\"1257\" data-end=\"1260\">\r\n???? Opción con leches vegetales</p>\r\n<p data-start=\"1297\" data-end=\"1441\" data-is-last-node=\"\" data-is-only-node=\"\"><br></p>', 6, 3, 1, '2025-06-23', '2025-08-26 22:29:19'),
(65, 8, 20, 2, 'Te', 'te', 'te.jpg', 'El mito del cafe', 'bebidas,bebidas calientes,te', '<h2 data-start=\"197\" data-end=\"263\">???? <strong data-start=\"203\" data-end=\"261\">Tés&nbsp; – Naturales, relajantes y reconfortantes</strong></h2>\r\n<p data-start=\"264\" data-end=\"520\">En <strong data-start=\"267\" data-end=\"294\">El Mito del Café Adonai</strong> tenemos una selección especial de <strong data-start=\"329\" data-end=\"361\">tés e infusiones artesanales</strong>, ideales para relajarte, acompañar tu día o disfrutar en cualquier momento. Todos disponibles en presentación de <strong data-start=\"475\" data-end=\"484\">16 oz</strong> y las tisanas también en <strong data-start=\"510\" data-end=\"519\">12 oz</strong>.</p>\r\n<hr data-start=\"522\" data-end=\"525\">\r\n<h3 data-start=\"527\" data-end=\"560\">???? <strong data-start=\"534\" data-end=\"560\">Tés naturales (16 oz):</strong></h3>\r\n<ul data-start=\"561\" data-end=\"670\">\r\n<li data-start=\"561\" data-end=\"581\">\r\n<p data-start=\"563\" data-end=\"581\">Té de Manzanilla</p>\r\n</li>\r\n<li data-start=\"582\" data-end=\"597\">\r\n<p data-start=\"584\" data-end=\"597\">Té de Limón</p>\r\n</li>\r\n<li data-start=\"598\" data-end=\"620\">\r\n<p data-start=\"600\" data-end=\"620\">Té Verde&nbsp;</p>\r\n</li>\r\n<li data-start=\"621\" data-end=\"644\">\r\n<p data-start=\"623\" data-end=\"644\">Té Rojo Chai Masala</p>\r\n</li>\r\n<li data-start=\"645\" data-end=\"670\">\r\n<p data-start=\"647\" data-end=\"670\">Té Digestión Amigable</p>\r\n</li>\r\n</ul>\r\n<p data-start=\"672\" data-end=\"815\"></p>\r\n<h3 data-start=\"822\" data-end=\"880\"></h3>\r\n<p data-start=\"1051\" data-end=\"1170\">✅ Servidas calientes<br data-start=\"1071\" data-end=\"1074\">\r\n???? 100% naturales, sin cafeína (en las tisanas)<br data-start=\"1121\" data-end=\"1124\">\r\n???? Puedes agregar miel o endulzante al gusto</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:27'),
(66, 8, 20, 2, 'Tisanas', 'tisanas', 'tisanas.jpg', 'El mito del cafe', 'bebidas,bebidas calientes,tisanas', '<h2 data-start=\"197\" data-end=\"263\">???? <strong data-start=\"203\" data-end=\"261\">&nbsp;Tisanas – Naturales, relajantes y reconfortantes</strong></h2>\r\n<p data-start=\"264\" data-end=\"520\">En <strong data-start=\"267\" data-end=\"294\">El Mito del Café Adonai</strong> tenemos una selección especial de <strong data-start=\"329\" data-end=\"361\">tés e infusiones artesanales</strong>, ideales para relajarte, acompañar tu día o disfrutar en cualquier momento. Todos disponibles en presentación de <strong data-start=\"475\" data-end=\"484\">16 oz</strong> y las tisanas también en <strong data-start=\"510\" data-end=\"519\">12 oz</strong>.</p>\r\n<hr data-start=\"522\" data-end=\"525\">\r\n<h3 data-start=\"527\" data-end=\"560\"><br></h3>\r\n<hr data-start=\"817\" data-end=\"820\">\r\n<h3 data-start=\"822\" data-end=\"880\">???? <strong data-start=\"829\" data-end=\"866\">Tisanas frutales ( 16 oz):</strong>&nbsp;</h3>\r\n<ul data-start=\"881\" data-end=\"1044\">\r\n<li data-start=\"881\" data-end=\"913\">\r\n<p data-start=\"883\" data-end=\"913\">Almendra, Arándano y Manzana</p>\r\n</li>\r\n<li data-start=\"914\" data-end=\"936\">\r\n<p data-start=\"916\" data-end=\"936\">Moras con Arándano</p>\r\n</li>\r\n<li data-start=\"937\" data-end=\"963\">\r\n<p data-start=\"939\" data-end=\"963\">Fresa, Kiwi y Arándano</p>\r\n</li>\r\n<li data-start=\"964\" data-end=\"994\">\r\n<p data-start=\"966\" data-end=\"994\">Guayaba, Manzana y Jamaica</p>\r\n</li>\r\n<li data-start=\"995\" data-end=\"1016\">\r\n<p data-start=\"997\" data-end=\"1016\">Frutos del Bosque</p>\r\n</li>\r\n<li data-start=\"1017\" data-end=\"1044\">\r\n<p data-start=\"1019\" data-end=\"1044\">Mango, Durazno y Papaya</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"1046\" data-end=\"1049\">\r\n<p data-start=\"1051\" data-end=\"1170\">✅ Servidas calientes<br data-start=\"1071\" data-end=\"1074\">\r\n???? 100% naturales, sin cafeína (en las tisanas)<br data-start=\"1121\" data-end=\"1124\">\r\n???? Puedes agregar miel o endulzante al gusto</p>', 0, 0, 1, '2025-06-23', '2025-07-31 18:00:36'),
(67, 8, 21, 1, 'Cocteles Y Cervesas', 'cocteles-y-cervesas', 'cocteles-y-cervesas.jpg', 'Drink lab oasis', 'bebidas,alcohol,verveza,licores,mojitos', '<h2 data-start=\"235\" data-end=\"298\">???? <strong data-start=\"241\" data-end=\"298\">Drink Lab Oasis – Cócteles creativos y con mucho flow</strong></h2>\r\n<p data-start=\"300\" data-end=\"497\">Sumérgete en un laboratorio de sabores con nuestros <strong data-start=\"352\" data-end=\"385\">cocteles preparados por litro</strong> y cervezas combinadas. Cada bebida tiene su propia personalidad, perfecta para compartir o disfrutar en grande.</p>\r\n<hr data-start=\"499\" data-end=\"502\">\r\n<h3 data-start=\"504\" data-end=\"543\">???? <strong data-start=\"511\" data-end=\"543\">Cócteles por litro&nbsp;</strong></h3>\r\n<h4 data-start=\"545\" data-end=\"568\">???? <strong data-start=\"553\" data-end=\"566\">Mojo jojo</strong></h4>\r\n<p data-start=\"569\" data-end=\"652\">Ron, limón y hierbabuena. Refrescante y clásico, ideal para los amantes del mojito.</p>\r\n<h4 data-start=\"654\" data-end=\"678\">???? <strong data-start=\"662\" data-end=\"676\">Mango jojo</strong></h4>\r\n<p data-start=\"679\" data-end=\"760\">Ron, mango, limón y hierbabuena. Una versión tropical del mojito con toque dulce.</p>\r\n<h4 data-start=\"762\" data-end=\"785\">???? <strong data-start=\"770\" data-end=\"783\">Mojo rojo</strong></h4>\r\n<p data-start=\"786\" data-end=\"849\">Ron, frutos rojos, limón y hierbabuena. Frutal, ácido y fresco.</p>\r\n<h4 data-start=\"851\" data-end=\"874\">???? <strong data-start=\"859\" data-end=\"872\">Coco jojo</strong></h4>\r\n<p data-start=\"875\" data-end=\"948\">Ron, coco, limón y hierbabuena. Refrescante y cremoso con sabor caribeño.</p>\r\n<h4 data-start=\"950\" data-end=\"970\">???? <strong data-start=\"958\" data-end=\"968\">Cubaby</strong></h4>\r\n<p data-start=\"971\" data-end=\"1038\">Ron con Coca-Cola o agua mineral. El clásico cubalibre con actitud.</p>\r\n<h4 data-start=\"1040\" data-end=\"1063\">???? <strong data-start=\"1048\" data-end=\"1061\">Baby blue</strong></h4>\r\n<p data-start=\"1064\" data-end=\"1132\">Vodka, bebida energizante y Sprite. Dulce, chispeante y energizante.</p>\r\n<h4 data-start=\"1134\" data-end=\"1157\">???? <strong data-start=\"1142\" data-end=\"1155\">Clericool</strong></h4>\r\n<p data-start=\"1158\" data-end=\"1242\">Vino tinto, vodka, mix de frutas y soda. Ligero, afrutado y perfecto para compartir.</p>\r\n<h4 data-start=\"1244\" data-end=\"1270\">???? <strong data-start=\"1252\" data-end=\"1268\">Piña coolada</strong></h4>\r\n<p data-start=\"1271\" data-end=\"1343\">Ron, jugo de piña, crema de coco y mucho hielo. Suave, dulce y tropical.</p>\r\n<hr data-start=\"1345\" data-end=\"1348\">\r\n<h3 data-start=\"1350\" data-end=\"1380\">???? <strong data-start=\"1357\" data-end=\"1380\">Caguamas preparadas</strong></h3><h3 data-start=\"1350\" data-end=\"1380\"><strong data-start=\"1357\" data-end=\"1380\"><br></strong></h3>\r\n<h4 data-start=\"1382\" data-end=\"1412\">???? <strong data-start=\"1390\" data-end=\"1410\">Limonchela&nbsp;</strong></h4>\r\n<p data-start=\"1413\" data-end=\"1487\">Cerveza con limón, sal y escarchado. Refrescante y perfecta para el calor.</p>\r\n<h4 data-start=\"1489\" data-end=\"1520\">❤️ <strong data-start=\"1497\" data-end=\"1518\">Monstruosa&nbsp;</strong></h4>\r\n<p data-start=\"1521\" data-end=\"1594\">Cerveza con ron y toque secreto de la casa. Intensa, picante y deliciosa.</p>', 55, 0, 1, '2025-06-23', '2025-09-03 18:13:36'),
(68, 8, 22, 1, 'Bebidas Frias', 'bebidas-frias', 'bebidas-frias.jpg', 'El mito del cafe', 'bebidas ,frias,frapes', '<h2 data-start=\"224\" data-end=\"280\">???? <strong data-start=\"230\" data-end=\"280\">Bebidas Frías – Refrescantes y llenas de sabor</strong></h2>\r\n<p data-start=\"282\" data-end=\"499\">En <strong data-start=\"285\" data-end=\"312\">El Mito del Café Adonai</strong>, también pensamos en los que prefieren lo frío. Disfruta nuestra selección de <strong data-start=\"391\" data-end=\"408\">bebidas frías</strong>, preparadas al momento, con opciones dulces, cremosas o frutales que refrescan y encantan.</p>\r\n<hr data-start=\"501\" data-end=\"504\">\r\n<h3 data-start=\"506\" data-end=\"548\">❄️ Opciones disponibles – <strong data-start=\"536\" data-end=\"548\">$70 c/u:</strong></h3>\r\n<ul data-start=\"549\" data-end=\"888\">\r\n<li data-start=\"549\" data-end=\"665\">\r\n<p data-start=\"551\" data-end=\"665\"><strong data-start=\"551\" data-end=\"564\">Taro Frío</strong>: Bebida cremosa con un suave sabor a taro, ideal para quienes buscan algo diferente y refrescante.</p>\r\n</li>\r\n<li data-start=\"666\" data-end=\"776\">\r\n<p data-start=\"668\" data-end=\"776\"><strong data-start=\"668\" data-end=\"681\">Moka Frío</strong>: Café frío con leche y un toque de chocolate, perfecto para los amantes del café con estilo.</p>\r\n</li>\r\n<li data-start=\"777\" data-end=\"888\">\r\n<p data-start=\"779\" data-end=\"888\"><strong data-start=\"779\" data-end=\"794\">Tisana Fría</strong>: Infusión frutal servida fría, ideal para quienes prefieren bebidas naturales, sin cafeína.</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"890\" data-end=\"893\">\r\n<h3 data-start=\"895\" data-end=\"928\">➕ Extras y personalizaciones:</h3>\r\n<ul data-start=\"929\" data-end=\"1027\">\r\n<li data-start=\"929\" data-end=\"973\">\r\n<p data-start=\"931\" data-end=\"973\"><strong data-start=\"931\" data-end=\"962\">Carga extra de café o sabor</strong> → <em data-start=\"965\" data-end=\"971\">+$10</em></p>\r\n</li>\r\n<li data-start=\"974\" data-end=\"1027\">\r\n<p data-start=\"976\" data-end=\"1027\"><strong data-start=\"976\" data-end=\"996\">Leches vegetales</strong>: soya, almendra, coco → <em data-start=\"1021\" data-end=\"1027\">+$10</em></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"1029\" data-end=\"1032\">\r\n<p data-start=\"1034\" data-end=\"1107\">✅ Preparadas al momento<br data-start=\"1057\" data-end=\"1060\">\r\n???? 100% personalizables<br data-start=\"1083\" data-end=\"1086\">\r\n???? Opción sin cafeína</p>', 48, 0, 1, '2025-07-02', '2025-08-26 19:10:22'),
(69, 8, 22, 1, 'Sodas Italianas', 'sodas-italianas', 'sodas-italianas.jpg', 'El mito del cafe', 'bebidas,sodas', '<h2 data-start=\"167\" data-end=\"239\">???? <strong data-start=\"173\" data-end=\"239\">Sodas – Refrescantes y siempre listas para acompañar tu comida</strong></h2>\r\n<p data-start=\"241\" data-end=\"429\">Disfruta nuestras <strong data-start=\"259\" data-end=\"279\">sodas bien frías</strong>, perfectas para acompañar cualquier platillo o refrescarte en cualquier momento del día. Disponibles en una variedad de sabores clásicos y populares.</p>\r\n<hr data-start=\"431\" data-end=\"434\">\r\n<h3 data-start=\"436\" data-end=\"467\">???? <strong data-start=\"443\" data-end=\"467\">Sabores disponibles:</strong></h3>\r\n<ul data-start=\"468\" data-end=\"653\">\r\n<li data-start=\"468\" data-end=\"516\">\r\n<p data-start=\"470\" data-end=\"516\">Coca-Cola / Coca-Cola Light / Coca-Cola Zero</p>\r\n</li>\r\n<li data-start=\"517\" data-end=\"540\">\r\n<p data-start=\"519\" data-end=\"540\">Pepsi / Pepsi Light</p>\r\n</li>\r\n<li data-start=\"541\" data-end=\"567\">\r\n<p data-start=\"543\" data-end=\"567\">Fanta (naranja, fresa)</p>\r\n</li>\r\n<li data-start=\"568\" data-end=\"584\">\r\n<p data-start=\"570\" data-end=\"584\">Sprite / 7UP</p>\r\n</li>\r\n<li data-start=\"585\" data-end=\"602\">\r\n<p data-start=\"587\" data-end=\"602\">Sidral Mundet</p>\r\n</li>\r\n<li data-start=\"603\" data-end=\"616\">\r\n<p data-start=\"605\" data-end=\"616\">Manzanita</p>\r\n</li>\r\n<li data-start=\"617\" data-end=\"653\">\r\n<p data-start=\"619\" data-end=\"653\">Agua mineral (natural o con sabor)</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"655\" data-end=\"658\">\r\n<p data-start=\"660\" data-end=\"733\">✅ Botella o lata<br data-start=\"676\" data-end=\"679\">\r\n???? Servidas frías<br data-start=\"696\" data-end=\"699\">\r\n???? Opción en combo con tu comida</p>', 1, 0, 1, '2025-07-02', '2025-07-31 18:00:52'),
(70, 8, 22, 2, 'Chamoyadas Y Smooties', 'chamoyadas-y-smooties', 'chamoyadas-y-smooties.jpg', 'El mito del cafe', 'chamoyadas,smoothies,frapes,bebidas', '<h2 data-start=\"218\" data-end=\"285\"><strong data-start=\"224\" data-end=\"285\">Chamoyadas &amp; Smoothies – El antojo perfecto para el calor</strong></h2>\r\n<p data-start=\"287\" data-end=\"507\">Refresca tu día con nuestras irresistibles <strong data-start=\"330\" data-end=\"356\">chamoyadas y smoothies</strong>, elaboradas con fruta natural, hielo frappeado y un toque especial de la casa. Ideales para quienes buscan un equilibrio entre dulce, ácido y picante.</p>\r\n<hr data-start=\"509\" data-end=\"512\">\r\n<h3 data-start=\"514\" data-end=\"555\">???? <strong data-start=\"521\" data-end=\"555\">Sabores disponibles – $65 c/u:</strong></h3>\r\n<ul data-start=\"556\" data-end=\"630\">\r\n<li data-start=\"556\" data-end=\"569\">\r\n<p data-start=\"558\" data-end=\"569\"><strong data-start=\"558\" data-end=\"567\">Limón</strong></p>\r\n</li>\r\n<li data-start=\"570\" data-end=\"587\">\r\n<p data-start=\"572\" data-end=\"587\"><strong data-start=\"572\" data-end=\"585\">Mandarina</strong></p>\r\n</li>\r\n<li data-start=\"588\" data-end=\"601\">\r\n<p data-start=\"590\" data-end=\"601\"><strong data-start=\"590\" data-end=\"599\">Mango</strong></p>\r\n</li>\r\n<li data-start=\"602\" data-end=\"618\">\r\n<p data-start=\"604\" data-end=\"618\"><strong data-start=\"604\" data-end=\"616\">Horchata</strong></p>\r\n</li>\r\n<li data-start=\"619\" data-end=\"630\">\r\n<p data-start=\"621\" data-end=\"630\"><strong data-start=\"621\" data-end=\"630\">Fresa</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"632\" data-end=\"635\">\r\n<p data-start=\"637\" data-end=\"788\">✅ Preparadas al momento<br data-start=\"660\" data-end=\"663\">\r\n???? Servidas bien frías<br data-start=\"685\" data-end=\"688\">\r\n????️ Chamoy y chilito incluido en las chamoyadas<br data-start=\"735\" data-end=\"738\">\r\n???? Smoothies sin picante, 100% frutales y cremosos</p>', 48, 0, 1, '2025-07-02', '2025-08-26 19:15:13'),
(71, 8, 23, 2, 'Empanadas Dulces', 'empanadas-dulces', 'empanadas-dulces.jpg', 'La buena charla', 'empanadas,postres,comida', '<h2 data-start=\"193\" data-end=\"262\">???????? <strong data-start=\"201\" data-end=\"262\">Empanadas Dulces – Rellenas de antojo, horneadas con amor</strong></h2>\r\n<p data-start=\"264\" data-end=\"489\">Nuestras <strong data-start=\"273\" data-end=\"293\">empanadas dulces</strong> están hechas con masa suave y doradita, rellenas con ingredientes clásicos y frutales que te harán volver por más. Perfectas para acompañar tu café, como postre o simplemente para darte un gusto.</p>\r\n<hr data-start=\"491\" data-end=\"494\">\r\n<h3 data-start=\"496\" data-end=\"573\">???? <strong data-start=\"503\" data-end=\"537\">Rellenos disponibles&nbsp;</strong></h3><h3 data-start=\"496\" data-end=\"573\"><strong data-start=\"503\" data-end=\"537\"><br></strong></h3>\r\n<ul data-start=\"575\" data-end=\"891\">\r\n<li data-start=\"575\" data-end=\"630\">\r\n<p data-start=\"577\" data-end=\"630\"><strong data-start=\"577\" data-end=\"585\">Piña</strong> – Dulce y tropical, con trocitos de fruta.</p>\r\n</li>\r\n<li data-start=\"631\" data-end=\"684\">\r\n<p data-start=\"633\" data-end=\"684\"><strong data-start=\"633\" data-end=\"642\">Fresa</strong> – Con mermelada suave y un toque ácido.</p>\r\n</li>\r\n<li data-start=\"685\" data-end=\"765\">\r\n<p data-start=\"687\" data-end=\"765\"><strong data-start=\"687\" data-end=\"697\">Cajeta</strong> – Cremosa y tradicional, irresistible para los amantes del dulce.</p>\r\n</li>\r\n<li data-start=\"766\" data-end=\"830\">\r\n<p data-start=\"768\" data-end=\"830\"><strong data-start=\"768\" data-end=\"790\">Manzana con canela</strong> – Estilo pie, cálida y reconfortante.</p></li>\r\n</ul>\r\n<hr data-start=\"893\" data-end=\"896\">\r\n<p data-start=\"898\" data-end=\"1030\">✅ Horneadas al momento (opcional también fritas)<br data-start=\"946\" data-end=\"949\">\r\n☕ Perfectas con café o chocolate<br data-start=\"981\" data-end=\"984\">\r\n???? Opción vegetariana (sin lácteos en la masa)</p>', 0, 0, 1, '2025-07-02', '2025-07-31 18:01:03');
INSERT INTO `products` (`id_product`, `id_category_product`, `id_subcategory_product`, `id_seller_product`, `name_product`, `url_product`, `image_product`, `description_product`, `keywords_product`, `info_product`, `views_product`, `sales_product`, `status_product`, `date_created_product`, `date_updated_product`) VALUES
(72, 8, 23, 2, 'Churros', 'churros', 'churros.jpg', 'La buena charla', 'postres,comida,churros', '<h2 data-start=\"146\" data-end=\"200\"><strong data-start=\"152\" data-end=\"200\">Churros – Crujientes, dulces y recién hechos</strong></h2>\r\n<p data-start=\"202\" data-end=\"438\">Nuestros <strong data-start=\"211\" data-end=\"222\">churros</strong> son dorados a la perfección, crujientes por fuera y suaves por dentro, espolvoreados con azúcar y canela. Son el clásico mexicano que nunca falla, perfectos para disfrutar solos o acompañados con tu bebida favorita.</p>\r\n<hr data-start=\"440\" data-end=\"443\">\r\n<h3 data-start=\"445\" data-end=\"477\">???? <strong data-start=\"452\" data-end=\"477\">Opciones disponibles:</strong></h3>\r\n<ul data-start=\"479\" data-end=\"624\">\r\n<li data-start=\"479\" data-end=\"525\">\r\n<p data-start=\"481\" data-end=\"525\"><strong data-start=\"481\" data-end=\"501\">Churros clásicos</strong> (con azúcar y canela)</p>\r\n</li>\r\n<li data-start=\"526\" data-end=\"624\">\r\n<p data-start=\"528\" data-end=\"569\"><br></p><ul data-start=\"572\" data-end=\"624\"><li data-start=\"615\" data-end=\"624\">\r\n</li>\r\n</ul>\r\n</li>\r\n</ul>\r\n<hr data-start=\"626\" data-end=\"629\">\r\n<p data-start=\"631\" data-end=\"755\">✅ Servidos calientitos<br data-start=\"653\" data-end=\"656\">\r\n☕ Perfectos con café, chocolate o atole<br data-start=\"695\" data-end=\"698\">\r\n???? También disponibles en porciones individuales o combos</p>', 0, 0, 1, '2025-07-02', '2025-07-31 18:01:08'),
(73, 8, 23, 2, 'Hotcakes', 'hotcakes', 'hotcakes.jpg', 'La buena charla', 'comida,postres,hotcakes', '<h2 data-start=\"157\" data-end=\"220\"><strong data-start=\"163\" data-end=\"220\">Hotcakesitos – Suaves, esponjosos y llenos de dulzura</strong></h2>\r\n<p data-start=\"222\" data-end=\"423\">Disfruta nuestros <strong data-start=\"240\" data-end=\"256\">hotcakesitos</strong>, mini hotcakes dorados y esponjosos, preparados al momento y servidos con tus toppings favoritos. Son perfectos como desayuno ligero, snack dulce o postre compartido.</p>\r\n<hr data-start=\"425\" data-end=\"428\">\r\n<h3 data-start=\"430\" data-end=\"465\">???? <strong data-start=\"437\" data-end=\"465\">Opciones y complementos:</strong></h3>\r\n<ul data-start=\"467\" data-end=\"703\">\r\n<li data-start=\"467\" data-end=\"488\">\r\n<p data-start=\"469\" data-end=\"488\"><strong data-start=\"469\" data-end=\"486\">Miel de maple</strong></p>\r\n</li>\r\n<li data-start=\"489\" data-end=\"525\">\r\n<p data-start=\"491\" data-end=\"525\"><strong data-start=\"491\" data-end=\"523\">Nutella o crema de avellanas</strong></p>\r\n</li>\r\n<li data-start=\"526\" data-end=\"560\">\r\n<p data-start=\"528\" data-end=\"560\"><strong data-start=\"528\" data-end=\"558\">Lechera (leche condensada)</strong></p>\r\n</li>\r\n<li data-start=\"561\" data-end=\"607\">\r\n<p data-start=\"563\" data-end=\"607\"><strong data-start=\"563\" data-end=\"605\">Mermelada (fresa, zarzamora o durazno)</strong></p>\r\n</li>\r\n<li data-start=\"608\" data-end=\"652\">\r\n<p data-start=\"610\" data-end=\"652\"><strong data-start=\"610\" data-end=\"650\">Fruta fresca (plátano, fresa o kiwi)</strong></p>\r\n</li>\r\n<li data-start=\"653\" data-end=\"703\">\r\n<p data-start=\"655\" data-end=\"703\"><strong data-start=\"655\" data-end=\"703\">Granola, chispas de chocolate o coco rallado</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"705\" data-end=\"708\">\r\n<p data-start=\"710\" data-end=\"835\">✅ Porción individual o para compartir<br data-start=\"747\" data-end=\"750\">\r\n???? Puedes combinarlos como combo dulce<br data-start=\"788\" data-end=\"791\">\r\n???? Servidos calientitos y suaves al centro</p>', 1, 0, 1, '2025-07-02', '2025-08-06 04:17:38'),
(74, 8, 23, 2, 'Crepas', 'crepas', 'crepas.jpg', 'La buena charla', 'comida,postre,crepas', '<h2 data-start=\"174\" data-end=\"240\">????✨ <strong data-start=\"181\" data-end=\"240\">Crepas – Delgadas, suaves y absolutamente irresistibles</strong></h2>\r\n<p data-start=\"242\" data-end=\"440\">Nuestras <strong data-start=\"251\" data-end=\"268\">crepas dulces</strong> están elaboradas con masa ligera y cocinadas al momento para lograr una textura suave, flexible y ligeramente dorada. Perfectas para consentirte en cualquier hora del día.</p>\r\n<hr data-start=\"442\" data-end=\"445\">\r\n<h3 data-start=\"447\" data-end=\"493\">???? <strong data-start=\"454\" data-end=\"493\">Rellenos y combinaciones populares:</strong></h3>\r\n<ul data-start=\"495\" data-end=\"717\">\r\n<li data-start=\"495\" data-end=\"530\">\r\n<p data-start=\"497\" data-end=\"530\"><strong data-start=\"497\" data-end=\"528\">Nutella con plátano o fresa</strong></p>\r\n</li>\r\n<li data-start=\"531\" data-end=\"554\">\r\n<p data-start=\"533\" data-end=\"554\"><strong data-start=\"533\" data-end=\"552\">Cajeta con nuez</strong></p>\r\n</li>\r\n<li data-start=\"555\" data-end=\"587\">\r\n<p data-start=\"557\" data-end=\"587\"><strong data-start=\"557\" data-end=\"585\">Lechera con coco rallado</strong></p>\r\n</li>\r\n<li data-start=\"588\" data-end=\"638\">\r\n<p data-start=\"590\" data-end=\"638\"><strong data-start=\"590\" data-end=\"636\">Mermelada de frutos rojos con crema batida</strong></p>\r\n</li>\r\n<li data-start=\"639\" data-end=\"673\">\r\n<p data-start=\"641\" data-end=\"673\"><strong data-start=\"641\" data-end=\"671\">Philadelphia con zarzamora</strong></p>\r\n</li>\r\n<li data-start=\"674\" data-end=\"717\">\r\n<p data-start=\"676\" data-end=\"717\"><strong data-start=\"676\" data-end=\"715\">Chocolate con chispas y malvaviscos</strong></p>\r\n</li>\r\n</ul>\r\n<p data-start=\"724\" data-end=\"819\"><br></p>\r\n<p data-start=\"821\" data-end=\"937\">✅ Preparadas al momento<br data-start=\"844\" data-end=\"847\">\r\n???? Disponibles para llevar o disfrutar en sitio<br data-start=\"894\" data-end=\"897\">\r\n???? Opción de personalizar tu combinación</p>', 1, 1, 1, '2025-07-02', '2025-07-31 18:01:15'),
(75, 8, 23, 2, 'Platanos Fritos', 'platanos-fritos', 'platanos-fritos.jpg', 'La buena charla', 'comida,postres,platanos fritos', '<h2 data-start=\"169\" data-end=\"234\">???? <strong data-start=\"175\" data-end=\"234\">Plátanos Fritos – Dulces, suaves y doraditos al momento</strong></h2>\r\n<p data-start=\"236\" data-end=\"462\">Nuestros <strong data-start=\"245\" data-end=\"264\">plátanos fritos</strong> son una delicia tradicional: rebanadas de plátano maduro fritas hasta obtener una textura crujiente por fuera y suave por dentro. Dulces de manera natural, son ideales como postre o acompañamiento.</p>\r\n<hr data-start=\"464\" data-end=\"467\">\r\n<h3 data-start=\"469\" data-end=\"501\">???? <strong data-start=\"476\" data-end=\"501\">Opciones disponibles:</strong></h3>\r\n<ul data-start=\"503\" data-end=\"707\">\r\n<li data-start=\"503\" data-end=\"565\">\r\n<p data-start=\"505\" data-end=\"565\"><strong data-start=\"505\" data-end=\"517\">Clásicos</strong> (solo fritos con un toque de canela o azúcar)</p>\r\n</li>\r\n<li data-start=\"566\" data-end=\"594\">\r\n<p data-start=\"568\" data-end=\"594\"><strong data-start=\"568\" data-end=\"592\">Con lechera o cajeta</strong></p>\r\n</li>\r\n<li data-start=\"595\" data-end=\"642\">\r\n<p data-start=\"597\" data-end=\"642\"><strong data-start=\"597\" data-end=\"640\">Con crema o queso rallado estilo casero</strong></p>\r\n</li>\r\n<li data-start=\"643\" data-end=\"707\">\r\n<p data-start=\"645\" data-end=\"707\"><strong data-start=\"645\" data-end=\"681\">Con nuez, granola o coco rallado</strong> <em data-start=\"682\" data-end=\"707\">(opcional como topping)</em></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"709\" data-end=\"712\">\r\n<p data-start=\"714\" data-end=\"822\">✅ Servidos calientitos<br data-start=\"736\" data-end=\"739\">\r\n????️ Postre o guarnición<br data-start=\"762\" data-end=\"765\">\r\n???? Combinan perfecto con arroz, carne, o como snack dulce</p>', 0, 0, 1, '2025-07-02', '2025-07-31 18:01:19'),
(76, 8, 23, 2, 'Galletas', 'galletas', 'galletas.jpg', 'El mito del cafe', 'comida,postres,galletas', '<h2 data-start=\"195\" data-end=\"260\">???? <strong data-start=\"201\" data-end=\"260\">Galletas de Amaranto – Nutritivas, caseras y deliciosas</strong></h2>\r\n<p data-start=\"262\" data-end=\"493\">Nuestras <strong data-start=\"271\" data-end=\"295\">galletas de amaranto</strong> son una opción saludable y deliciosa, elaboradas artesanalmente con ingredientes naturales. Crujientes, llenas de sabor y perfectas para acompañar tu café o como snack en cualquier momento del día.</p>\r\n<p data-start=\"495\" data-end=\"534\">???? <strong data-start=\"498\" data-end=\"534\">Cada paquete incluye 5 galletas.</strong></p>\r\n<hr data-start=\"536\" data-end=\"539\">\r\n<h3 data-start=\"541\" data-end=\"590\">???? <strong data-start=\"548\" data-end=\"590\">Sabores disponibles – $30 por paquete:</strong></h3>\r\n<ul data-start=\"591\" data-end=\"855\">\r\n<li data-start=\"591\" data-end=\"640\">\r\n<p data-start=\"593\" data-end=\"640\"><strong data-start=\"593\" data-end=\"605\">Arándano</strong> – Frutales y ligeramente ácidas.</p>\r\n</li>\r\n<li data-start=\"641\" data-end=\"708\">\r\n<p data-start=\"643\" data-end=\"708\"><strong data-start=\"643\" data-end=\"654\">Chispas</strong> – Con chocolate oscuro, para los amantes del dulce.</p>\r\n</li>\r\n<li data-start=\"709\" data-end=\"747\">\r\n<p data-start=\"711\" data-end=\"747\"><strong data-start=\"711\" data-end=\"719\">Nuez</strong> – Tradicional y crocante.</p>\r\n</li>\r\n<li data-start=\"748\" data-end=\"791\">\r\n<p data-start=\"750\" data-end=\"791\"><strong data-start=\"750\" data-end=\"759\">Avena</strong> – Clásica, suave y saludable.</p>\r\n</li>\r\n<li data-start=\"792\" data-end=\"855\">\r\n<p data-start=\"794\" data-end=\"855\"><strong data-start=\"794\" data-end=\"804\">Espejo</strong> – Cubiertas con chocolate y decorado marmoleado.</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"857\" data-end=\"860\">\r\n<p data-start=\"862\" data-end=\"964\">✅ Hechas con amaranto natural<br data-start=\"891\" data-end=\"894\">\r\n???? Opción rica en fibra y energía<br data-start=\"927\" data-end=\"930\">\r\n♨️ Perfectas para llevar o regalar</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:30:31'),
(77, 9, 24, 1, 'Gorras', 'gorras', 'gorras.jpg', 'Gorras', 'productos,gorras,accesorios', '<h2 data-start=\"178\" data-end=\"224\">???? <strong data-start=\"184\" data-end=\"224\">Gorras – Estilo, comodidad y actitud</strong></h2>\r\n<p data-start=\"226\" data-end=\"458\">Completa tu outfit con nuestras <strong data-start=\"258\" data-end=\"279\">gorras exclusivas</strong>, diseñadas para brindar comodidad, proteger del sol y agregar un toque auténtico a tu look diario. Disponibles en diferentes colores, estilos y materiales para cada personalidad.</p>\r\n<hr data-start=\"460\" data-end=\"463\">\r\n<h3 data-start=\"465\" data-end=\"503\">???? <strong data-start=\"472\" data-end=\"503\">Características destacadas:</strong></h3>\r\n<ul data-start=\"504\" data-end=\"688\">\r\n<li data-start=\"504\" data-end=\"551\">\r\n<p data-start=\"506\" data-end=\"551\">Ajuste <strong data-start=\"513\" data-end=\"525\">snapback</strong> o <strong data-start=\"528\" data-end=\"538\">velcro</strong> (unitalla)</p>\r\n</li>\r\n<li data-start=\"552\" data-end=\"602\">\r\n<p data-start=\"554\" data-end=\"602\">Materiales: <strong data-start=\"566\" data-end=\"600\">algodón, poliéster o mezclilla</strong></p>\r\n</li>\r\n<li data-start=\"603\" data-end=\"643\">\r\n<p data-start=\"605\" data-end=\"643\">Modelos lisos, estampados y bordados</p>\r\n</li>\r\n<li data-start=\"644\" data-end=\"688\">\r\n<p data-start=\"646\" data-end=\"688\">Disponibles en tonos clásicos y modernos</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"690\" data-end=\"693\">\r\n<p data-start=\"695\" data-end=\"766\">✅ Unisex<br data-start=\"703\" data-end=\"706\">\r\n???? Fáciles de lavar<br data-start=\"725\" data-end=\"728\">\r\n☀️ Ideales para uso casual o deportivo</p>', 1, 0, 1, '2025-07-02', '2025-08-06 02:30:39'),
(78, 9, 26, 2, 'Tenis Ck', 'tenis-ck', 'tenis-ck.jpg', 'Tenis calvin klein', 'ropa,tenis,calvin klein', '<h2 data-start=\"185\" data-end=\"260\">???? <strong data-start=\"191\" data-end=\"260\">Tenis Calvin Klein Negros – Estilo urbano con elegancia atemporal</strong></h2>\r\n<p data-start=\"262\" data-end=\"500\">Los <strong data-start=\"266\" data-end=\"303\">tenis Calvin Klein en color negro</strong> combinan a la perfección diseño minimalista, confort y versatilidad. Su estilo limpio y moderno los hace ideales para outfits casuales o semiformal, manteniéndote cómodo y con actitud todo el día.</p>\r\n<hr data-start=\"502\" data-end=\"505\">\r\n<h3 data-start=\"507\" data-end=\"534\">???? <strong data-start=\"514\" data-end=\"534\">Características:</strong></h3>\r\n<ul data-start=\"536\" data-end=\"843\">\r\n<li data-start=\"536\" data-end=\"564\">\r\n<p data-start=\"538\" data-end=\"564\">Color: <strong data-start=\"545\" data-end=\"562\">Negro clásico</strong></p>\r\n</li>\r\n<li data-start=\"565\" data-end=\"621\">\r\n<p data-start=\"567\" data-end=\"621\">Diseño: <strong data-start=\"575\" data-end=\"601\">Minimalista y elegante</strong> con logo discreto</p>\r\n</li>\r\n<li data-start=\"622\" data-end=\"701\">\r\n<p data-start=\"624\" data-end=\"701\">Material: <strong data-start=\"634\" data-end=\"673\">Exterior sintético o textil premium</strong>, con interior acolchonado</p>\r\n</li>\r\n<li data-start=\"702\" data-end=\"748\">\r\n<p data-start=\"704\" data-end=\"748\">Suela: Antiderrapante, ligera y resistente</p>\r\n</li>\r\n<li data-start=\"749\" data-end=\"794\">\r\n<p data-start=\"751\" data-end=\"794\">Ajuste: Con agujetas y lengüeta reforzada</p>\r\n</li>\r\n<li data-start=\"795\" data-end=\"843\">\r\n<p data-start=\"797\" data-end=\"843\">Tallas disponibles: <em data-start=\"817\" data-end=\"843\">[coloca aquí tus tallas]</em></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"845\" data-end=\"848\">\r\n<p data-start=\"850\" data-end=\"932\">✅ Unisex (según modelo)<br data-start=\"873\" data-end=\"876\">\r\n???? Fáciles de limpiar<br data-start=\"897\" data-end=\"900\">\r\n???? Marca original Calvin Klein</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:30:53'),
(79, 9, 24, 1, 'Bolsa Bimba Y Lola', 'bolsa-bimba-y-lola', 'bolsa-bimba-y-lola.jpg', 'Bolsa bimba y lola', 'ropa,bolsas,bimba y lola', '<h2 data-start=\"185\" data-end=\"253\">???? <strong data-start=\"191\" data-end=\"253\">Bolsa Bimba y Lola – Diseño vanguardista con esencia única</strong></h2>\r\n<p data-start=\"255\" data-end=\"490\">La <strong data-start=\"258\" data-end=\"280\">bolsa Bimba y Lola</strong> es el accesorio perfecto para quienes buscan originalidad, estilo y calidad en una sola pieza. Con su diseño contemporáneo y materiales premium, esta bolsa destaca por su elegancia funcional y sello artístico.</p>\r\n<hr data-start=\"492\" data-end=\"495\">\r\n<h3 data-start=\"497\" data-end=\"534\">✨ <strong data-start=\"503\" data-end=\"534\">Características destacadas:</strong></h3>\r\n<ul data-start=\"536\" data-end=\"903\">\r\n<li data-start=\"536\" data-end=\"574\">\r\n<p data-start=\"538\" data-end=\"574\">Marca: <strong data-start=\"545\" data-end=\"572\">Bimba y Lola – Original</strong></p>\r\n</li>\r\n<li data-start=\"575\" data-end=\"624\">\r\n<p data-start=\"577\" data-end=\"624\">Color: <em data-start=\"584\" data-end=\"622\">[Negro / Beige / Color según modelo]</em></p>\r\n</li>\r\n<li data-start=\"625\" data-end=\"685\">\r\n<p data-start=\"627\" data-end=\"685\">Material: <em data-start=\"637\" data-end=\"683\">[Piel sintética / lona / nylon según modelo]</em></p>\r\n</li>\r\n<li data-start=\"686\" data-end=\"750\">\r\n<p data-start=\"688\" data-end=\"750\">Compartimentos: Interior forrado con bolsillos organizadores</p>\r\n</li>\r\n<li data-start=\"751\" data-end=\"801\">\r\n<p data-start=\"753\" data-end=\"801\">Cierre: Cremallera metálica o broche magnético</p>\r\n</li>\r\n<li data-start=\"802\" data-end=\"862\">\r\n<p data-start=\"804\" data-end=\"862\">Tipo de asa: <strong data-start=\"817\" data-end=\"845\">Corta, larga o ajustable</strong> (según modelo)</p>\r\n</li>\r\n<li data-start=\"863\" data-end=\"903\">\r\n<p data-start=\"865\" data-end=\"903\">Uso: <strong data-start=\"870\" data-end=\"901\">Casual, urbano o semiformal</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"905\" data-end=\"908\">\r\n<p data-start=\"910\" data-end=\"1060\">✅ Producto 100% original<br data-start=\"934\" data-end=\"937\">\r\n???? Estilo europeo con toques modernos<br data-start=\"974\" data-end=\"977\">\r\n???? Fácil de limpiar y mantener<br data-start=\"1007\" data-end=\"1010\">\r\n???? Disponible con empaque o sin él <em data-start=\"1045\" data-end=\"1060\">(según venta)</em></p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:30:44'),
(80, 9, 27, 2, 'Cortinas', 'cortinas', 'cortinas.jpg', 'cortinas', 'hogar,cortinas,oficina,articulos,productos', '<h2 data-start=\"190\" data-end=\"266\">???? <strong data-start=\"196\" data-end=\"266\">Cortinas Decorativas – Elegancia y funcionalidad para cada espacio</strong></h2>\r\n<p data-start=\"268\" data-end=\"508\">Renueva tus espacios con nuestras <strong data-start=\"302\" data-end=\"326\">cortinas decorativas</strong>, diseñadas para ofrecer privacidad, control de luz y un toque único de estilo. Disponibles en varios colores, telas y tamaños, son el complemento perfecto para cualquier habitación.</p>\r\n<hr data-start=\"510\" data-end=\"513\">\r\n<h3 data-start=\"515\" data-end=\"553\">???? <strong data-start=\"522\" data-end=\"553\">Características destacadas:</strong></h3>\r\n<ul data-start=\"555\" data-end=\"925\">\r\n<li data-start=\"555\" data-end=\"630\">\r\n<p data-start=\"557\" data-end=\"630\"><strong data-start=\"557\" data-end=\"571\">Materiales</strong>: Lino, poliéster, blackout, semitranslúcidas o tipo velo</p>\r\n</li>\r\n<li data-start=\"631\" data-end=\"714\">\r\n<p data-start=\"633\" data-end=\"714\"><strong data-start=\"633\" data-end=\"644\">Tamaños</strong>: Estándar y personalizables <em data-start=\"673\" data-end=\"712\">(larga, corta, para ventana o puerta)</em></p>\r\n</li>\r\n<li data-start=\"715\" data-end=\"789\">\r\n<p data-start=\"717\" data-end=\"789\"><strong data-start=\"717\" data-end=\"728\">Estilos</strong>: Modernas, clásicas, minimalistas, infantiles y estampadas</p>\r\n</li>\r\n<li data-start=\"790\" data-end=\"855\">\r\n<p data-start=\"792\" data-end=\"855\"><strong data-start=\"792\" data-end=\"804\">Fijación</strong>: Ojillos metálicos, presillas o cinta fruncidora</p>\r\n</li>\r\n<li data-start=\"856\" data-end=\"925\">\r\n<p data-start=\"858\" data-end=\"925\"><strong data-start=\"858\" data-end=\"881\">Fácil mantenimiento</strong>: Lavables a máquina o a mano <em data-start=\"911\" data-end=\"925\">(según tipo)</em></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"927\" data-end=\"930\">\r\n<p data-start=\"932\" data-end=\"1105\">✅ Bloqueo de luz parcial o total (según modelo)<br data-start=\"979\" data-end=\"982\">\r\n???? Algunas incluyen forro térmico y aislante de ruido<br data-start=\"1035\" data-end=\"1038\">\r\n???? Variedad de colores y texturas para combinar con tu decoración</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:30:49'),
(81, 9, 24, 2, 'Mochila De Capibara', 'mochila-de-capibara', 'mochila-de-capibara.jpg', 'mochila de capibara', 'mochila,producto,capibara,accesorios', '<h2 data-start=\"194\" data-end=\"275\">???????? <strong data-start=\"202\" data-end=\"275\">Mochila de Capibara – Ternura y estilo que te acompaña a todas partes</strong></h2>\r\n<p data-start=\"277\" data-end=\"501\">Lleva contigo el encanto de la naturaleza con esta adorable <strong data-start=\"337\" data-end=\"360\">mochila de capibara</strong>. Su diseño único y suave la convierte en el accesorio perfecto para destacar, ya sea en la escuela, salidas casuales o como regalo original.</p>\r\n<hr data-start=\"503\" data-end=\"506\">\r\n<h3 data-start=\"508\" data-end=\"545\">✨ <strong data-start=\"514\" data-end=\"545\">Características destacadas:</strong></h3>\r\n<ul data-start=\"547\" data-end=\"930\">\r\n<li data-start=\"547\" data-end=\"620\">\r\n<p data-start=\"549\" data-end=\"620\"><strong data-start=\"549\" data-end=\"559\">Diseño</strong>: Forma de capibara con detalles bordados y orejitas suaves</p>\r\n</li>\r\n<li data-start=\"621\" data-end=\"691\">\r\n<p data-start=\"623\" data-end=\"691\"><strong data-start=\"623\" data-end=\"633\">Tamaño</strong>: Compacta pero espaciosa <em data-start=\"659\" data-end=\"689\">(ideal para niños y jóvenes)</em></p>\r\n</li>\r\n<li data-start=\"692\" data-end=\"762\">\r\n<p data-start=\"694\" data-end=\"762\"><strong data-start=\"694\" data-end=\"706\">Material</strong>: Felpa de alta calidad, interior forrado y resistente</p>\r\n</li>\r\n<li data-start=\"763\" data-end=\"798\">\r\n<p data-start=\"765\" data-end=\"798\"><strong data-start=\"765\" data-end=\"775\">Cierre</strong>: Cremallera superior</p>\r\n</li>\r\n<li data-start=\"799\" data-end=\"853\">\r\n<p data-start=\"801\" data-end=\"853\"><strong data-start=\"801\" data-end=\"824\">Tirantes ajustables</strong> y asa superior para colgar</p>\r\n</li>\r\n<li data-start=\"854\" data-end=\"930\">\r\n<p data-start=\"856\" data-end=\"930\"><strong data-start=\"856\" data-end=\"879\">Colores disponibles</strong>: Café claro, beige o personalizados (según modelo)</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"932\" data-end=\"935\">\r\n<p data-start=\"937\" data-end=\"1027\">✅ Ultraligera y cómoda<br data-start=\"959\" data-end=\"962\">\r\n???? Ideal como regalo original<br data-start=\"991\" data-end=\"994\">\r\n???? Lavable a mano (modo delicado)</p>', 1, 0, 1, '2025-07-02', '2025-08-06 02:30:57'),
(82, 9, 25, 1, 'Joyeria', 'joyeria', 'joyeria.jpg', 'paquete de collares y pulseras', 'joyeria ,accesorios,pulseras,productos', '<h2 data-start=\"173\" data-end=\"225\">???? <strong data-start=\"179\" data-end=\"225\">Collares – Detalles que iluminan tu estilo</strong></h2>\r\n<p data-start=\"227\" data-end=\"441\">Nuestros <strong data-start=\"236\" data-end=\"248\">collares</strong> están diseñados para resaltar tu personalidad y darle un toque único a cualquier look. Desde piezas sutiles y delicadas hasta diseños llamativos y modernos, tenemos opciones para cada ocasión.</p>\r\n<hr data-start=\"443\" data-end=\"446\">\r\n<h3 data-start=\"448\" data-end=\"485\">✨ <strong data-start=\"454\" data-end=\"485\">Características destacadas:</strong></h3>\r\n<ul data-start=\"487\" data-end=\"845\">\r\n<li data-start=\"487\" data-end=\"564\">\r\n<p data-start=\"489\" data-end=\"564\"><strong data-start=\"489\" data-end=\"503\">Materiales</strong>: Acero inoxidable, baño de oro, plata, fantasía o pedrería</p>\r\n</li>\r\n<li data-start=\"565\" data-end=\"637\">\r\n<p data-start=\"567\" data-end=\"637\"><strong data-start=\"567\" data-end=\"578\">Estilos</strong>: Minimalistas, boho, románticos, vintage, personalizados</p>\r\n</li>\r\n<li data-start=\"638\" data-end=\"718\">\r\n<p data-start=\"640\" data-end=\"718\"><strong data-start=\"640\" data-end=\"662\">Largos disponibles</strong>: Cortos (tipo choker), medianos o largos con colgante</p>\r\n</li>\r\n<li data-start=\"719\" data-end=\"800\">\r\n<p data-start=\"721\" data-end=\"800\"><strong data-start=\"721\" data-end=\"733\">Detalles</strong>: Dije con forma de corazón, luna, iniciales, piedras o cristales</p>\r\n</li>\r\n<li data-start=\"801\" data-end=\"845\">\r\n<p data-start=\"803\" data-end=\"845\"><strong data-start=\"803\" data-end=\"825\">Cierres ajustables</strong> con broche seguro</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"847\" data-end=\"850\">\r\n<p data-start=\"852\" data-end=\"945\">✅ Hipoalergénicos (según modelo)<br data-start=\"884\" data-end=\"887\">\r\n???? Perfectos como regalo<br data-start=\"911\" data-end=\"914\">\r\n???? Fáciles de cuidar y combinar</p>', 1, 0, 1, '2025-07-02', '2025-08-06 04:15:58'),
(83, 9, 25, 2, 'Vapes', 'vapes', 'vapes.jpg', 'vapes con nicotina', 'productos,vapes', '<h2 data-start=\"260\" data-end=\"321\">???? <strong data-start=\"266\" data-end=\"321\">Vapes – Sabor, estilo y tecnología en cada bocanada</strong></h2>\r\n<p data-start=\"323\" data-end=\"518\">Disfruta una experiencia suave y moderna con nuestros <strong data-start=\"377\" data-end=\"386\">vapes</strong>, diseñados para quienes buscan una alternativa al cigarro tradicional o simplemente quieren experimentar nuevos sabores con estilo.</p>\r\n<hr data-start=\"520\" data-end=\"523\">\r\n<h3 data-start=\"525\" data-end=\"563\">???? <strong data-start=\"532\" data-end=\"563\">Características destacadas:</strong></h3>\r\n<ul data-start=\"565\" data-end=\"980\">\r\n<li data-start=\"565\" data-end=\"633\">\r\n<p data-start=\"567\" data-end=\"633\">✅ <strong data-start=\"569\" data-end=\"589\">Listos para usar</strong>: desechables o recargables (según modelo)</p>\r\n</li>\r\n<li data-start=\"634\" data-end=\"718\">\r\n<p data-start=\"636\" data-end=\"718\">????️ <strong data-start=\"640\" data-end=\"663\">Sabores disponibles</strong>: uva, mango, menta, sandía, cola, tabaco suave y más</p>\r\n</li>\r\n<li data-start=\"719\" data-end=\"801\">\r\n<p data-start=\"721\" data-end=\"801\">???? <strong data-start=\"724\" data-end=\"736\">Duración</strong>: hasta <em data-start=\"744\" data-end=\"754\">[número]</em> de caladas por unidad <em data-start=\"777\" data-end=\"799\">(varía según modelo)</em></p>\r\n</li>\r\n<li data-start=\"802\" data-end=\"866\">\r\n<p data-start=\"804\" data-end=\"866\">???? <strong data-start=\"807\" data-end=\"828\">Con o sin recarga</strong>: modelos con batería recargable USB</p>\r\n</li>\r\n<li data-start=\"867\" data-end=\"920\">\r\n<p data-start=\"869\" data-end=\"920\">???? <strong data-start=\"872\" data-end=\"895\">Niveles de nicotina</strong>: 0%, 3%, 5% (opcional)</p>\r\n</li>\r\n<li data-start=\"921\" data-end=\"980\">\r\n<p data-start=\"923\" data-end=\"980\">???? Suaves al inhalar, con vapor denso y aroma agradable</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"982\" data-end=\"985\">\r\n<h3 data-start=\"987\" data-end=\"1018\">???? <strong data-start=\"994\" data-end=\"1018\">Modelos disponibles:</strong></h3>\r\n<ul data-start=\"1019\" data-end=\"1134\">\r\n<li data-start=\"1019\" data-end=\"1044\">\r\n<p data-start=\"1021\" data-end=\"1044\">Desechables compactos</p>\r\n</li>\r\n<li data-start=\"1045\" data-end=\"1070\">\r\n<p data-start=\"1047\" data-end=\"1070\">Pen-style recargables</p>\r\n</li>\r\n<li data-start=\"1071\" data-end=\"1095\">\r\n<p data-start=\"1073\" data-end=\"1095\">Pods intercambiables</p>\r\n</li>\r\n<li data-start=\"1096\" data-end=\"1134\">\r\n<p data-start=\"1098\" data-end=\"1134\">Vapes premium con pantalla digital</p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"1136\" data-end=\"1139\">\r\n<p data-start=\"1141\" data-end=\"1274\">⚠️ <strong data-start=\"1144\" data-end=\"1173\">Solo para mayores de edad</strong><br data-start=\"1173\" data-end=\"1176\">\r\n???? Se entregan sellados y con medidas de seguridad<br data-start=\"1226\" data-end=\"1229\">\r\n???? Diseños discretos, modernos y portátiles</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:31:08'),
(84, 9, 25, 2, 'Fundas', 'fundas', 'fundas.jpg', 'fundas para celular', 'productos,celulares,fundas,iphone', '<h2 data-start=\"173\" data-end=\"244\">???? <strong data-start=\"179\" data-end=\"244\">Fundas de Celular – Protección con estilo para tu dispositivo</strong></h2>\r\n<p data-start=\"246\" data-end=\"466\">Nuestras <strong data-start=\"255\" data-end=\"278\">fundas para celular</strong> combinan diseño, resistencia y funcionalidad. Protege tu smartphone de caídas, rayones y polvo sin sacrificar tu estilo. Disponibles en una gran variedad de colores, materiales y modelos.</p>\r\n<hr data-start=\"468\" data-end=\"471\">\r\n<h3 data-start=\"473\" data-end=\"512\">???? <strong data-start=\"480\" data-end=\"512\">Características principales:</strong></h3>\r\n<ul data-start=\"514\" data-end=\"965\">\r\n<li data-start=\"514\" data-end=\"603\">\r\n<p data-start=\"516\" data-end=\"603\"><strong data-start=\"516\" data-end=\"552\">Compatibles con marcas populares</strong>: iPhone, Samsung, Xiaomi, Motorola, Huawei y más</p>\r\n</li>\r\n<li data-start=\"604\" data-end=\"756\">\r\n<p data-start=\"606\" data-end=\"635\"><strong data-start=\"606\" data-end=\"632\">Materiales disponibles</strong>:</p>\r\n<ul data-start=\"638\" data-end=\"756\">\r\n<li data-start=\"638\" data-end=\"672\">\r\n<p data-start=\"640\" data-end=\"672\">Silicona flexible (antigolpes)</p>\r\n</li>\r\n<li data-start=\"675\" data-end=\"695\">\r\n<p data-start=\"677\" data-end=\"695\">TPU transparente</p>\r\n</li>\r\n<li data-start=\"698\" data-end=\"717\">\r\n<p data-start=\"700\" data-end=\"717\">Acrílico rígido</p>\r\n</li>\r\n<li data-start=\"720\" data-end=\"756\">\r\n<p data-start=\"722\" data-end=\"756\">Cuero sintético (estilo cartera)</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li data-start=\"757\" data-end=\"914\">\r\n<p data-start=\"759\" data-end=\"784\"><strong data-start=\"759\" data-end=\"781\">Modelos con extras</strong>:</p>\r\n<ul data-start=\"787\" data-end=\"914\">\r\n<li data-start=\"787\" data-end=\"823\">\r\n<p data-start=\"789\" data-end=\"823\">Soporte tipo anillo o pop socket</p>\r\n</li>\r\n<li data-start=\"826\" data-end=\"849\">\r\n<p data-start=\"828\" data-end=\"849\">Tarjetero integrado</p>\r\n</li>\r\n<li data-start=\"852\" data-end=\"914\">\r\n<p data-start=\"854\" data-end=\"914\">Con glitter, frases, diseños personalizados o minimalistas</p>\r\n</li>\r\n</ul>\r\n</li>\r\n<li data-start=\"915\" data-end=\"965\">\r\n<p data-start=\"917\" data-end=\"965\"><strong data-start=\"917\" data-end=\"965\">Ajuste perfecto y acceso a botones y puertos</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"967\" data-end=\"970\">\r\n<p data-start=\"972\" data-end=\"1084\">✅ Antideslizantes y ligeras<br data-start=\"999\" data-end=\"1002\">\r\n????️ Protección contra caídas y golpes<br data-start=\"1039\" data-end=\"1042\">\r\n???? Variedad para todos los gustos y edades</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:31:11'),
(85, 9, 25, 2, 'Termos', 'termos', 'termos.jpg', 'termos ilustrados', 'productos,termos', '<h2 data-start=\"191\" data-end=\"263\">☕✨ <strong data-start=\"197\" data-end=\"263\">Termos con Ilustración – Hidratación con estilo y personalidad</strong></h2>\r\n<p data-start=\"265\" data-end=\"468\">Nuestros <strong data-start=\"274\" data-end=\"295\">termos ilustrados</strong> no solo conservan la temperatura de tus bebidas, también reflejan tu estilo único. Cada diseño está pensado para inspirarte, acompañarte y hacerte destacar en el día a día.</p>\r\n<hr data-start=\"470\" data-end=\"473\">\r\n<h3 data-start=\"475\" data-end=\"513\">???? <strong data-start=\"482\" data-end=\"513\">Características destacadas:</strong></h3>\r\n<ul data-start=\"515\" data-end=\"906\">\r\n<li data-start=\"515\" data-end=\"566\">\r\n<p data-start=\"517\" data-end=\"566\"><strong data-start=\"517\" data-end=\"530\">Capacidad</strong>: 500 ml / 750 ml <em data-start=\"548\" data-end=\"564\">(según modelo)</em></p>\r\n</li>\r\n<li data-start=\"567\" data-end=\"618\">\r\n<p data-start=\"569\" data-end=\"618\"><strong data-start=\"569\" data-end=\"583\">Materiales</strong>: Acero inoxidable de doble pared</p>\r\n</li>\r\n<li data-start=\"619\" data-end=\"687\">\r\n<p data-start=\"621\" data-end=\"687\"><strong data-start=\"621\" data-end=\"685\">Mantiene bebidas calientes hasta 12 hrs y frías hasta 24 hrs</strong></p>\r\n</li>\r\n<li data-start=\"688\" data-end=\"796\">\r\n<p data-start=\"690\" data-end=\"796\"><strong data-start=\"690\" data-end=\"708\">Diseños únicos</strong>: Ilustraciones originales, frases motivadoras, arte pop, naturaleza, personajes, etc.</p>\r\n</li>\r\n<li data-start=\"797\" data-end=\"846\">\r\n<p data-start=\"799\" data-end=\"846\"><strong data-start=\"799\" data-end=\"819\">Tapas herméticas</strong> y boquillas antiderrames</p>\r\n</li>\r\n<li data-start=\"847\" data-end=\"906\">\r\n<p data-start=\"849\" data-end=\"906\"><strong data-start=\"849\" data-end=\"906\">Apto para café, té, agua, jugos o bebidas energéticas</strong></p>\r\n</li>\r\n</ul>\r\n<hr data-start=\"908\" data-end=\"911\">\r\n<p data-start=\"913\" data-end=\"1043\">✅ Reutilizables y ecológicos<br data-start=\"941\" data-end=\"944\">\r\n????️ Personalizables (en pedidos especiales)<br data-start=\"987\" data-end=\"990\">\r\n???? Ideal como regalo original o detalle corporativo</p>', 0, 0, 1, '2025-07-02', '2025-08-06 02:31:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sellers`
--

CREATE TABLE `sellers` (
  `id_seller` int(11) NOT NULL,
  `name_seller` varchar(255) NOT NULL,
  `email_seller` varchar(255) DEFAULT NULL,
  `phone_seller` varchar(20) NOT NULL,
  `date_created_seller` date DEFAULT NULL,
  `date_updated_seller` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sellers`
--

INSERT INTO `sellers` (`id_seller`, `name_seller`, `email_seller`, `phone_seller`, `date_created_seller`, `date_updated_seller`) VALUES
(1, 'bray', 'dead1902@gmail.com', '5565422173', '2025-07-31', '2025-08-05 23:35:29'),
(2, 'Francisco', 'editor@ecommerce.com', '5555555555', '2025-07-31', '2025-09-03 17:37:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `slides`
--

CREATE TABLE `slides` (
  `id_slide` int(11) NOT NULL,
  `background_slide` text DEFAULT NULL,
  `direction_slide` text DEFAULT NULL,
  `img_png_slide` text DEFAULT NULL,
  `coord_img_slide` text DEFAULT NULL,
  `text_slide` text DEFAULT NULL,
  `coord_text_slide` text DEFAULT NULL,
  `link_slide` text DEFAULT NULL,
  `text_btn_slide` text DEFAULT NULL,
  `status_slide` int(11) NOT NULL DEFAULT 1,
  `date_created_slide` date DEFAULT NULL,
  `date_updated_slide` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `slides`
--

INSERT INTO `slides` (`id_slide`, `background_slide`, `direction_slide`, `img_png_slide`, `coord_img_slide`, `text_slide`, `coord_text_slide`, `link_slide`, `text_btn_slide`, `status_slide`, `date_created_slide`, `date_updated_slide`) VALUES
(1, 'back_default.jpg', 'opt1', 'calzado.png', 'top:15%; right:10%; width:45%', '[{\"text\":\"Lorem Ipsum\",\"color\":\"#333\"},{\"text\":\"Lorem ipsum dolor sit\",\"color\":\"#777\"},{\"text\":\"Lorem ipsum dolor sit\",\"color\":\"#888\"}]', 'top:20%; left:10%; width:40%', 'http://ecommerce.com/calzado', 'VER PRODUCTO', 1, '2024-05-22', '2024-05-22 19:00:50'),
(2, 'fondo2.jpg', 'opt2', 'iphone.png', 'bottom:0%; left:15%; width:28%', '[{\"text\":\"Lorem Ipsum\",\"color\":\"#ffffff\"},{\"text\":\"Lorem ipsum dolor sit\",\"color\":\"#e8e8e8\"},{\"text\":\"Lorem ipsum dolor sit\",\"color\":\"#d6d6d6\"}]', 'top:20%; right:15%; width:40%', 'http://ecommerce.com/no-found', 'VER PRODUCTO', 1, '2024-05-22', '2024-05-22 19:00:49'),
(4, 'bg.jpg', '', '', '', '', '', '', '', 1, '2024-05-22', '2024-05-22 19:00:48'),
(5, NULL, '', NULL, '', '', '', '', '', 1, '2025-08-16', '2025-08-17 00:54:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socials`
--

CREATE TABLE `socials` (
  `id_social` int(11) NOT NULL,
  `name_social` text DEFAULT NULL,
  `url_social` text DEFAULT NULL,
  `icon_social` text DEFAULT NULL,
  `color_social` text DEFAULT NULL,
  `date_created_social` date DEFAULT NULL,
  `date_updated_social` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `socials`
--

INSERT INTO `socials` (`id_social`, `name_social`, `url_social`, `icon_social`, `color_social`, `date_created_social`, `date_updated_social`) VALUES
(1, 'facebook', 'https://facebook.com', 'fab fa-facebook-f', 'text-white', '2022-09-24', '2024-05-20 22:22:38'),
(2, 'youtube', 'https://youtube.com', 'fab fa-youtube', 'text-white', '2022-09-24', '2022-09-24 18:20:47'),
(3, 'twitter', 'https://twitter.com', 'fab fa-twitter', 'text-white', '2022-09-24', '2022-09-24 18:20:51'),
(4, 'instagram', 'https://instagram.com', 'fab fa-instagram', 'text-white', '2022-09-24', '2022-09-24 18:20:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategories`
--

CREATE TABLE `subcategories` (
  `id_subcategory` int(11) NOT NULL,
  `id_category_subcategory` int(11) NOT NULL DEFAULT 0,
  `name_subcategory` text DEFAULT NULL,
  `url_subcategory` text DEFAULT NULL,
  `image_subcategory` text DEFAULT NULL,
  `description_subcategory` text DEFAULT NULL,
  `keywords_subcategory` text DEFAULT NULL,
  `products_subcategory` int(11) NOT NULL DEFAULT 0,
  `views_subcategory` int(11) NOT NULL DEFAULT 0,
  `status_subcategory` int(11) NOT NULL DEFAULT 1,
  `date_created_subcategory` date DEFAULT NULL,
  `date_updated_subcategory` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `subcategories`
--

INSERT INTO `subcategories` (`id_subcategory`, `id_category_subcategory`, `name_subcategory`, `url_subcategory`, `image_subcategory`, `description_subcategory`, `keywords_subcategory`, `products_subcategory`, `views_subcategory`, `status_subcategory`, `date_created_subcategory`, `date_updated_subcategory`) VALUES
(18, 8, 'Comida Corrida', 'comida-corrida', 'comida-corrida.jpg', 'Disfruta de deliciosas comidas corridas preparadas con ingredientes frescos, balanceados y listos para servir. Ofrecemos menús completos que incluyen sopa, plato fuerte y bebida, ideales para tus días laborales o para quienes desean comer bien sin cocinar. Ordena en línea y recibe comida casera directamente en tu casa u oficina. ¡Calidad, sabor y rapidez en cada pedido!', 'comida,corrida,casera,menu del dia,economica', 5, 0, 1, '2025-06-14', '2025-06-24 02:51:05'),
(19, 8, 'Comida Rapida', 'comida-rapida', 'comida-rapida.jpg', 'Encuentra tus favoritos en nuestra sección de comida rápida: hamburguesas, hot dogs, papas, alitas, pizzas y más. Ideal para saciar el hambre en minutos sin sacrificar el sabor. Ordena en línea y disfruta platillos preparados al instante, con entrega rápida y opciones para todos los gustos. ¡Comida caliente, sabrosa y al alcance de un clic!', 'comida,rapida,hamburguesas,pizza,express', 11, 0, 1, '2025-06-14', '2025-06-24 03:20:15'),
(20, 8, 'Bebidas Calientes', 'bebidas-calientes', 'bebidas-calientes.jpg', 'Disfruta del sabor y la calidez de nuestras bebidas calientes, ideales para cualquier momento del día. Encuentra cafés gourmet, tés naturales, infusiones relajantes, chocolates calientes y más. Productos de calidad, perfectos para el hogar, la oficina o como regalo especial. Compra en línea y recibe tus bebidas favoritas con rapidez y comodidad.', 'bebidas,calientes,cafe,te,chocolate', 3, 0, 1, '2025-06-14', '2025-06-24 03:46:58'),
(21, 8, 'Bebidas Alcoholicas', 'bebidas-alcoholicas', 'bebidas-alcoholicas.jpg', 'Descubre nuestra exclusiva selección de bebidas alcohólicas para todos los gustos y ocasiones. Explora vinos, cervezas artesanales, licores premium, destilados y más, cuidadosamente seleccionados por su calidad y sabor. Compra de forma segura y recibe tus bebidas favoritas directamente en tu hogar, con opciones para reuniones, regalos o consumo personal. ¡Elige, brinda y disfruta!', 'bebidas,alcohol,vino,licores,cerveza', 1, 0, 1, '2025-06-14', '2025-06-24 04:23:07'),
(22, 8, 'Bebidas', 'bebidas', 'bebidas.png', 'Encuentra todo tipo de bebidas en un solo lugar: desde aguas naturales, jugos, refrescos, hasta bebidas energéticas . Perfectas para cualquier ocasión, ya sea para acompañar tus comidas, refrescarte, relajarte o celebrar. Compra en línea bebidas frías , individuales o por paquete, con entrega rápida y segura hasta tu domicilio.', 'bebidas,frescas,jugos,limonadas,naranjadas', 3, 0, 1, '2025-06-14', '2025-07-03 02:09:17'),
(23, 8, 'Postres', 'postres', 'postres.jpg', 'Endulza tus días con nuestra deliciosa variedad de postres para todos los gustos: pasteles, pays, gelatinas, flanes, brownies, galletas, y más. Elaborados con ingredientes frescos y de alta calidad, ideales para compartir en familia, regalar o darte un gusto. Compra postres en línea y recíbelos en casa con toda la frescura y presentación que mereces.', 'postres,dulces,pasteles,gelatinas,pays', 6, 0, 1, '2025-06-14', '2025-07-03 03:53:16'),
(24, 9, 'Accesorios', 'accesorios', 'accesorios.jpg', 'Completa tu estilo y funcionalidad con nuestra amplia colección de accesorios. Encuentra desde gorras, mochilas, relojes, cinturones, lentes, fundas, hasta accesorios tecnológicos y de moda. Diseñados para adaptarse a cada personalidad, ocasión y necesidad. Compra accesorios en línea con envío rápido, pago seguro y variedad para hombre, mujer y niños.', 'accesorios,gorras,relojes,joyeria,lentes', 3, 0, 1, '2025-06-14', '2025-07-03 04:39:13'),
(25, 9, 'Productos', 'productos', 'productos.jpg', 'Explora nuestra amplia gama de productos pensados para cubrir todas tus necesidades en un solo lugar. Desde tecnología, hogar, moda, salud, hasta alimentos y accesorios. Encuentra artículos de calidad, con precios competitivos, envíos rápidos y garantía de satisfacción. Compra en línea de forma segura y recibe tus productos directamente en la puerta de tu hogar.', 'productos', 4, 0, 1, '2025-06-14', '2025-07-03 04:54:04'),
(26, 9, 'Ropa', 'ropa', 'ropa.jpg', 'Descubre nuestra colección de ropa para todas las edades y estilos, desde prendas casuales hasta ropa elegante y deportiva. Encuentra camisetas, pantalones, vestidos, sudaderas, blusas, ropa interior y mucho más, con las últimas tendencias y materiales de calidad. Compra ropa en línea con facilidad, tallas disponibles y envíos rápidos a todo el país.', 'ropa,hombre,mujer,niño,niña', 1, 0, 1, '2025-06-14', '2025-07-03 04:25:09'),
(27, 9, 'Hogar Y Oficina', 'hogar-y-oficina', 'hogar-y-oficina.jpg', 'Descubre nuestra colección de ropa para todas las edades y estilos, desde prendas casuales hasta ropa elegante y deportiva. Encuentra camisetas, pantalones, vestidos, sudaderas, blusas, ropa interior y mucho más, con las últimas tendencias y materiales de calidad. Compra ropa en línea con facilidad, tallas disponibles y envíos rápidos a todo el país.', 'hogar,oficina,articulos,productos', 1, 0, 1, '2025-06-14', '2025-07-03 04:35:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `templates`
--

CREATE TABLE `templates` (
  `id_template` int(11) NOT NULL,
  `logo_template` text DEFAULT NULL,
  `icon_template` text DEFAULT NULL,
  `cover_template` text DEFAULT NULL,
  `title_template` text DEFAULT NULL,
  `description_template` text DEFAULT NULL,
  `keywords_template` text DEFAULT NULL,
  `fonts_template` text DEFAULT NULL,
  `colors_template` text DEFAULT NULL,
  `active_template` text DEFAULT NULL,
  `date_created_template` date DEFAULT NULL,
  `date_updated_template` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `templates`
--

INSERT INTO `templates` (`id_template`, `logo_template`, `icon_template`, `cover_template`, `title_template`, `description_template`, `keywords_template`, `fonts_template`, `colors_template`, `active_template`, `date_created_template`, `date_updated_template`) VALUES
(1, 'logo.png', 'icono.png', 'cover.jpg', 'Sistema Ecommerce', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sollicitudin tempor sem, at rutrum leo aliquet in. Phasellus et gravida magna. ', 'ecommerce,comercio electrónico,moda,sistemas', '{\"fontFamily\":\"%20%3Clink%20rel%3D%22preconnect%22%20href%3D%22https%3A%2F%2Ffonts.googleapis.com%22%3E%0A%20%20%3Clink%20rel%3D%22preconnect%22%20href%3D%22https%3A%2F%2Ffonts.gstatic.com%22%20crossorigin%3E%0A%20%20%3Clink%20href%3D%22https%3A%2F%2Ffonts.googleapis.com%2Fcss2%3Ffamily%3DUbuntu%2BCondensed%26family%3DUbuntu%3Aital%2Cwght%400%2C300%3B0%2C400%3B0%2C500%3B0%2C700%3B1%2C300%3B1%2C400%3B1%2C500%3B1%2C700%26display%3Dswap%22%20rel%3D%22stylesheet%22%3E\",\"fontBody\":\"Ubuntu\",\"fontSlide\":\"Ubuntu Condensed\"}', '[{\"top\":{\"background\":\"black\",\"color\":\"white\"}},{\"template\":\n{\"background\":\"#47BAC1\",\"color\":\"white\"}}]', 'ok', '2022-09-22', '2025-08-16 20:23:39'),
(2, 'logo.png', 'icono.png', 'cover.jpg', 'Sistema Ecommerce', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sollicitudin tempor sem, at rutrum leo aliquet in. Phasellus et gravida magna. ', 'ecommerce,comercio electrónico,moda,sistemas', '{\"fontFamily\":\"%3Clink%20rel%3D%22preconnect%22%20href%3D%22https%3A%2F%2Ffonts.googleapis.com%22%3E%0A%3Clink%20rel%3D%22preconnect%22%20href%3D%22https%3A%2F%2Ffonts.gstatic.com%22%20crossorigin%3E%0A%3Clink%20href%3D%22https%3A%2F%2Ffonts.googleapis.com%2Fcss2%3Ffamily%3DMontserrat%3Awght%40300%3B700%26display%3Dswap%22%20rel%3D%22stylesheet%22%3E\",\"fontBody\":\"Montserrat\",\"fontSlide\":\"Montserrat\"}', '[{\"top\":{\"background\":\"#03f9b6\",\"color\":\"black\"}},{\"template\":{\"background\":\"#c147b5\",\"color\":\"white\"}}]', 'Null', '2022-09-22', '2024-05-20 22:22:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `name_user` text DEFAULT NULL,
  `email_user` text DEFAULT NULL,
  `password_user` text DEFAULT NULL,
  `token_user` text DEFAULT NULL,
  `token_exp_user` text DEFAULT NULL,
  `method_user` text DEFAULT NULL,
  `verification_user` int(11) NOT NULL DEFAULT 0,
  `confirm_user` text DEFAULT NULL,
  `country_user` text DEFAULT NULL,
  `department_user` text DEFAULT NULL,
  `city_user` text DEFAULT NULL,
  `address_user` text DEFAULT NULL,
  `phone_user` text DEFAULT NULL,
  `date_created_user` date DEFAULT NULL,
  `date_updated_user` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id_user`, `name_user`, `email_user`, `password_user`, `token_user`, `token_exp_user`, `method_user`, `verification_user`, `confirm_user`, `country_user`, `department_user`, `city_user`, `address_user`, `phone_user`, `date_created_user`, `date_updated_user`) VALUES
(8, 'Toro Cortes', 'user@ecommerce.com', '$2a$07$azybxcags23425sdg23sdeanQZqjaf6Birm2NvcYTNtJw24CsO5uq', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NTY5MjMyMDIsImV4cCI6MTc1NzAwOTYwMiwiZGF0YSI6eyJpZCI6OCwiZW1haWwiOiJ1c2VyQGVjb21tZXJjZS5jb20ifX0.QUH6u1VX-tcjBZZ9Khm5UTfmb8-3Gn0TuU7d1Lt7l3E', '1757009602', 'directo', 1, '1ryzi790qj3nh42osbcf', 'Mexico', 'Distrito Federal', 'Cdmx', 'nicolas fernandez 12', '52_5565422173', '2025-07-03', '2025-09-03 18:27:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variants`
--

CREATE TABLE `variants` (
  `id_variant` int(11) NOT NULL,
  `id_product_variant` int(11) DEFAULT 0,
  `id_seller_variant` int(11) DEFAULT NULL,
  `type_variant` text DEFAULT NULL,
  `media_variant` text DEFAULT NULL,
  `description_variant` text DEFAULT NULL,
  `cost_variant` double NOT NULL DEFAULT 0,
  `price_variant` double NOT NULL DEFAULT 0,
  `offer_variant` text DEFAULT NULL,
  `end_offer_variant` date DEFAULT NULL,
  `stock_variant` int(11) NOT NULL DEFAULT 0,
  `date_created_variant` date DEFAULT NULL,
  `date_updated_variant` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `variants`
--

INSERT INTO `variants` (`id_variant`, `id_product_variant`, `id_seller_variant`, `type_variant`, `media_variant`, `description_variant`, `cost_variant`, `price_variant`, `offer_variant`, `end_offer_variant`, `stock_variant`, `date_created_variant`, `date_updated_variant`) VALUES
(88, 51, 1, 'gallery', '[\"96868.jpg\"]', 'Menu del dia', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(89, 51, 1, 'gallery', '[\"29578.jpg\"]', 'rojos con huevo', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 00:31:43'),
(90, 51, 2, 'gallery', '[\"15205.jpg\"]', 'mole de olla', 100, 100, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 00:31:48'),
(91, 51, 2, 'gallery', '[\"69258.jpg\"]', 'chile relleno', 100, 100, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(92, 51, 2, 'gallery', '[\"43535.jpg\"]', 'Flautas', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(93, 51, 1, 'gallery', '[\"40358.jpg\"]', 'enchiladas suizas', 100, 100, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(94, 51, 2, 'gallery', '[\"43674.jpg\"]', 'Huevos', 80, 80, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(95, 51, 2, 'gallery', '[\"43826.jpg\"]', 'Pechuga empanizada', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(96, 51, 1, 'gallery', '[\"78827.jpg\"]', 'Pollo con nopales', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(98, 51, 2, 'gallery', '[\"68878.jpg\"]', 'chilaquiles verdes con huevo ', 95, 95, '', '0000-00-00', 10, '2025-06-15', '2025-08-06 03:23:41'),
(99, 52, 1, 'gallery', '[\"64241.jpg\"]', 'Banderilla', 50, 50, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(100, 53, 2, 'gallery', '[\"51799.jpg\"]', 'BBQ', 120, 120, '', '0000-00-00', 120, '2025-06-18', '2025-08-06 03:23:41'),
(101, 53, 2, 'gallery', '[\"66221.jpg\"]', 'Mango habanero', 120, 120, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(102, 53, 2, 'gallery', '[\"32001.jpg\"]', 'infierno', 120, 120, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(103, 53, 1, 'gallery', '[\"90367.jpg\"]', 'Buffalo', 120, 120, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(104, 53, 2, 'gallery', '[\"96192.jpg\"]', 'Tamarindo', 120, 120, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(105, 53, 2, 'gallery', '[\"99013.jpg\"]', 'Lemon', 120, 120, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(107, 54, 1, 'gallery', '[\"53816.jpg\"]', 'hawaiana con papas', 150, 150, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(108, 54, 1, 'gallery', '[\"26510.jpg\"]', 'clasica con papas ', 140, 140, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(109, 54, 2, 'gallery', '[\"60009.jpg\"]', 'clasica', 100, 100, '', '0000-00-00', 10, '2025-06-18', '2025-08-06 03:23:41'),
(111, 55, 2, 'gallery', '[\"36771.jpg\"]', '80', 80, 80, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(112, 56, 2, 'gallery', '[\"86232.jpg\"]', 'chapata Carnes frias', 120, 120, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(113, 56, 1, 'gallery', '[\"32128.jpg\"]', 'Chapata vegana', 120, 120, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(114, 56, 1, 'gallery', '[\"67757.jpg\"]', 'chapata tres quesos', 140, 140, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(115, 57, 1, 'gallery', '[\"79733.jpg\"]', 'Club sandwich', 120, 120, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(116, 58, 1, 'gallery', '[\"58270.jpg\"]', 'costillas de elote', 80, 80, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(117, 59, 2, 'gallery', '[\"29021.jpg\"]', 'cuernito con jamon', 85, 85, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(118, 59, 2, 'gallery', '[\"97463.jpg\"]', 'cuernito con pollo', 100, 100, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(119, 60, 2, 'gallery', '[\"48805.jpg\"]', 'Carne molida con papas y especias', 60, 60, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(120, 60, 1, 'gallery', '[\"39976.jpg\"]', 'Pollo deshebrado con queso', 60, 60, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(121, 60, 2, 'gallery', '[\"41758.jpg\"]', 'Hawaiiana', 60, 60, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(122, 60, 2, 'gallery', '[\"71593.jpg\"]', 'Atún con verduras', 60, 60, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(123, 61, 1, 'gallery', '[\"51699.jpg\"]', 'hot dog clasico', 80, 80, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(124, 61, 2, 'gallery', '[\"76232.jpg\"]', 'hot dog con tocino', 80, 80, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(125, 61, 1, 'gallery', '[\"53700.jpg\"]', 'hot dog vegano', 80, 80, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(126, 62, 1, 'gallery', '[\"21424.jpg\"]', '', 50, 50, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(127, 63, 2, 'gallery', '[\"56145.jpg\"]', 'pambazos', 45, 45, '', '0000-00-00', 10, '2025-06-23', '2025-08-06 03:23:41'),
(128, 64, 2, 'gallery', '[\"34222.jpg\"]', 'americano', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(129, 64, 1, 'gallery', '[\"12153.jpg\"]', 'Mazapán ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(130, 64, 1, 'gallery', '[\"89856.jpg\"]', 'Moka / Moka blanco ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(131, 64, 1, 'gallery', '[\"93913.jpg\"]', 'Chocoavellana ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(132, 64, 2, 'gallery', '[\"65998.jpg\"]', 'Taro ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(133, 64, 2, 'gallery', '[\"98670.jpg\"]', 'Chai negro ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(134, 64, 2, 'gallery', '[\"24721.jpg\"]', 'Capuccino / Latte', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(135, 64, 2, 'gallery', '[\"93931.jpg\"]', 'Horchata caliente ', 55, 55, '', '0000-00-00', 55, '2025-06-23', '2025-08-06 03:23:41'),
(136, 65, 1, 'gallery', '[\"30207.jpg\"]', 'Té de Manzanilla', 30, 30, '', '0000-00-00', 30, '2025-06-23', '2025-08-06 03:23:41'),
(137, 65, 1, 'gallery', '[\"28325.jpg\"]', 'Té de Limón', 30, 30, '', '0000-00-00', 30, '2025-06-23', '2025-08-06 03:23:41'),
(138, 65, 2, 'gallery', '[\"48666.jpg\"]', 'Té Rojo Chai Masala', 30, 30, '', '0000-00-00', 30, '2025-06-23', '2025-08-06 03:23:41'),
(139, 65, 2, 'gallery', '[\"19843.jpg\"]', 'Té Verde ', 30, 30, '', '0000-00-00', 30, '2025-06-23', '2025-08-06 03:23:41'),
(140, 65, 1, 'gallery', '[\"91470.jpg\"]', 'Té Digestión Amigable', 30, 30, '', '0000-00-00', 30, '2025-06-23', '2025-08-06 03:23:41'),
(141, 66, 1, 'gallery', '[\"77891.jpg\"]', 'Mango, Durazno y Papaya', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(142, 66, 2, 'gallery', '[\"12982.jpg\"]', 'Almendra, Arándano y Manzana', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(143, 66, 2, 'gallery', '[\"36753.jpg\"]', 'Moras con Arándano', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(144, 66, 2, 'gallery', '[\"28463.jpg\"]', 'Guayaba, Manzana y Jamaica', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(145, 66, 1, 'gallery', '[\"26171.jpg\"]', 'Fresa, Kiwi y Arándano', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(146, 66, 2, 'gallery', '[\"64598.jpg\"]', 'Frutos del Bosque', 40, 40, '', '0000-00-00', 40, '2025-06-23', '2025-08-06 03:23:41'),
(147, 67, 1, 'gallery', '[\"19186.jpg\"]', 'Mojo jojo', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(148, 67, 2, 'gallery', '[\"68240.jpg\"]', ' Mango jojo', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(149, 67, 2, 'gallery', '[\"38925.jpg\"]', 'Coco jojo', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(150, 67, 1, 'gallery', '[\"28313.jpg\"]', 'Cubaby', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(151, 67, 1, 'gallery', '[\"65025.jpg\"]', 'Baby blue', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(152, 67, 1, 'gallery', '[\"45659.jpg\"]', 'Clericool', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(153, 67, 2, 'gallery', '[\"25509.jpg\"]', 'Piña coolada', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(154, 67, 1, 'gallery', '[\"20331.jpg\"]', 'mojo rojo', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(155, 67, 2, 'gallery', '[\"71465.jpg\"]', 'Monstruosa ', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(156, 67, 2, 'gallery', '[\"44387.jpg\"]', 'Limonchela ', 90, 90, '', '0000-00-00', 90, '2025-06-23', '2025-08-06 03:23:41'),
(157, 68, 1, 'gallery', '[\"37460.jpg\",\"82102.jpg\"]', 'Taro Frío', 70, 70, '', '0000-00-00', 10, '2025-07-02', '2025-08-06 03:23:41'),
(158, 68, 1, 'gallery', '[\"28924.jpg\"]', 'Moka Frío', 70, 70, '', '0000-00-00', 10, '2025-07-02', '2025-08-06 03:23:41'),
(159, 68, 2, 'gallery', '[\"33942.jpg\"]', 'Tisana Fría', 70, 70, '', '0000-00-00', 10, '2025-07-02', '2025-08-06 03:23:41'),
(160, 69, 2, 'gallery', '[\"99599.jpg\"]', 'soda', 70, 70, '', '0000-00-00', 10, '2025-07-02', '2025-08-06 03:23:41'),
(161, 70, 2, 'gallery', '[\"85885.jpg\",\"39013.jpg\"]', 'Chamoyada de Limón', 65, 65, '', '0000-00-00', 65, '2025-07-02', '2025-08-06 03:23:41'),
(162, 70, 2, 'gallery', '[\"12928.jpg\"]', 'Chamoyada de Mandarina', 65, 65, '', '0000-00-00', 65, '2025-07-02', '2025-08-06 03:23:41'),
(163, 70, 1, 'gallery', '[\"22817.jpg\"]', 'Chamoyada de Mango', 65, 65, '', '0000-00-00', 65, '2025-07-02', '2025-08-06 03:23:41'),
(164, 70, 1, 'gallery', '[\"66309.jpg\"]', 'Chamoyada de Horchata', 65, 65, '', '0000-00-00', 65, '2025-07-02', '2025-08-06 03:23:41'),
(165, 70, 2, 'gallery', '[\"12621.jpg\"]', 'Chamoyada de Fresa', 65, 65, '', '0000-00-00', 15, '2025-07-02', '2025-08-06 03:23:41'),
(166, 71, 2, 'gallery', '[\"56273.jpg\"]', 'Piña', 40, 40, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(167, 71, 1, 'gallery', '[\"54881.jpg\"]', 'Fresa ', 40, 40, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(168, 71, 1, 'gallery', '[\"17861.jpg\"]', 'Cajeta', 40, 40, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(169, 71, 2, 'gallery', '[\"28267.jpg\"]', 'Manzana con canela', 40, 40, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(170, 72, 2, 'gallery', '[\"12915.jpg\"]', 'clasicos', 10, 10, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(171, 73, 2, 'gallery', '[\"32119.jpg\"]', 'Miel de maple', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(172, 73, 1, 'gallery', '[\"25835.jpg\"]', 'Nutella o crema de avellanas', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(173, 73, 1, 'gallery', '[\"28432.jpg\"]', 'Lechera (leche condensada)', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(174, 73, 2, 'gallery', '[\"55158.jpg\"]', 'Mermelada (fresa, zarzamora o durazno)', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(175, 73, 2, 'gallery', '[\"90782.jpg\"]', 'Fruta fresca (plátano, fresa o kiwi)', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(176, 73, 2, 'gallery', '[\"30215.jpg\"]', 'Granola, chispas de chocolate o coco rallado', 100, 100, '', '0000-00-00', 100, '2025-07-02', '2025-08-06 03:23:41'),
(177, 74, 2, 'gallery', '[\"41659.jpg\"]', 'Nutella con plátano o fresa', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(178, 74, 2, 'gallery', '[\"61786.jpg\"]', 'Cajeta con nuez', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(179, 74, 1, 'gallery', '[\"93774.jpg\"]', 'Mermelada de frutos rojos con crema batida', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(180, 74, 2, 'gallery', '[\"70521.jpg\"]', 'Lechera con coco rallado', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(181, 74, 2, 'gallery', '[\"56614.jpg\"]', 'Philadelphia con zarzamora', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(182, 74, 1, 'gallery', '[\"20110.jpg\"]', 'Chocolate con chispas y malvaviscos', 95, 95, '', '0000-00-00', 95, '2025-07-02', '2025-08-06 03:23:41'),
(183, 75, 1, 'gallery', '[\"63372.jpg\"]', 'Clásicos ', 80, 80, '', '0000-00-00', 80, '2025-07-02', '2025-08-06 03:23:41'),
(184, 75, 2, 'gallery', '[\"17769.jpg\"]', 'Con lechera o cajeta', 80, 80, '', '0000-00-00', 80, '2025-07-02', '2025-08-06 03:23:41'),
(185, 75, 2, 'gallery', '[\"53614.jpg\"]', 'Con crema o queso rallado estilo casero', 80, 80, '', '0000-00-00', 80, '2025-07-02', '2025-08-06 03:23:41'),
(186, 75, 2, 'gallery', '[\"91152.jpg\"]', 'Con nuez, granola o coco rallado', 80, 80, '', '0000-00-00', 80, '2025-07-02', '2025-08-06 03:23:41'),
(187, 76, 2, 'gallery', '[\"75895.jpg\"]', 'Arándano', 30, 30, '', '0000-00-00', 30, '2025-07-02', '2025-08-06 03:23:41'),
(188, 76, 1, 'gallery', '[\"47592.jpg\"]', 'Chispas', 30, 30, '', '0000-00-00', 30, '2025-07-02', '2025-08-06 03:23:41'),
(189, 76, 1, 'gallery', '[\"66136.jpg\"]', 'Nuez ', 30, 30, '', '0000-00-00', 0, '2025-07-02', '2025-08-06 03:23:41'),
(190, 76, 2, 'gallery', '[\"89361.jpg\"]', 'Avena ', 30, 30, '', '0000-00-00', 30, '2025-07-02', '2025-08-06 03:23:41'),
(191, 76, 1, 'gallery', '[\"37241.jpg\"]', 'Espejo', 30, 30, '', '0000-00-00', 30, '2025-07-02', '2025-08-06 03:23:41'),
(192, 77, 1, 'gallery', '[\"66265.jpg\",\"77630.jpg\"]', 'negra yankees', 500, 500, '', '0000-00-00', 5, '2025-07-02', '2025-08-06 03:23:41'),
(193, 77, 1, 'gallery', '[\"13919.jpg\"]', 'azul los angeles', 500, 500, '', '0000-00-00', 5, '2025-07-02', '2025-08-06 03:23:41'),
(194, 77, 1, 'gallery', '[\"45998.jpg\"]', 'azul monterrey', 500, 500, '', '0000-00-00', 5, '2025-07-02', '2025-08-06 03:23:41'),
(195, 77, 2, 'gallery', '[\"55750.jpg\",\"31218.jpg\"]', 'cafe los angeles', 500, 500, '', '0000-00-00', 5, '2025-07-02', '2025-08-06 03:23:41'),
(196, 78, 1, 'gallery', '[\"47508.jpg\",\"93060.jpg\"]', 'negros ', 1000, 1000, '', '0000-00-00', 1, '2025-07-02', '2025-08-06 03:23:41'),
(197, 79, 2, 'gallery', '[\"47257.jpg\",\"70350.jpg\"]', 'verde agua', 500, 500, '', '0000-00-00', 2, '2025-07-02', '2025-08-06 03:23:41'),
(198, 80, 2, 'gallery', '[\"20018.jpg\",\"48503.jpg\",\"12118.jpg\",\"32060.jpg\"]', 'cortinas', 200, 200, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(199, 81, 1, 'gallery', '[\"61736.jpg\",\"56712.jpg\"]', 'mochila capibara', 150, 150, '', '0000-00-00', 15, '2025-07-02', '2025-08-06 03:23:41'),
(200, 82, 1, 'gallery', '[\"53538.jpg\"]', 'callar y pulsera 1', 250, 250, '', '0000-00-00', 25, '2025-07-02', '2025-08-06 03:23:41'),
(201, 82, 2, 'gallery', '[\"96662.jpg\"]', 'callar y pulsera 2', 250, 250, '', '0000-00-00', 25, '2025-07-02', '2025-08-06 03:23:41'),
(202, 83, 2, 'gallery', '[\"36091.jpg\"]', 'strawberry', 200, 200, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(203, 83, 1, 'gallery', '[\"10259.jpg\"]', 'watermelon', 200, 200, '', '0000-00-00', 10, '2025-07-02', '2025-08-06 03:23:41'),
(204, 83, 1, 'gallery', '[\"59175.jpg\"]', 'cherry lemon', 200, 200, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(205, 83, 2, 'gallery', '[\"55016.jpg\"]', 'strawberry kewi', 200, 200, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(206, 83, 2, 'gallery', '[\"27825.jpg\"]', 'watermelon ice', 200, 200, '', '0000-00-00', 40, '2025-07-02', '2025-08-06 03:23:41'),
(207, 83, 2, 'gallery', '[\"85406.jpg\"]', 'lemon ice', 200, 200, '', '0000-00-00', 20, '2025-07-02', '2025-08-06 03:23:41'),
(208, 84, 2, 'gallery', '[\"37939.jpg\"]', 'iphone 16', 150, 150, '', '0000-00-00', 20, '2025-07-02', '2025-08-06 03:23:41'),
(209, 85, 2, 'gallery', '[\"97347.jpg\"]', 'blanco corazones', 200, 200, '', '0000-00-00', 20, '2025-07-02', '2025-08-06 03:23:41'),
(210, 85, 1, 'gallery', '[\"40338.jpg\",\"13919.jpg\"]', 'blanco perrito', 200, 200, '', '0000-00-00', 20, '2025-07-02', '2025-08-06 03:23:41'),
(211, 85, 2, 'gallery', '[\"63986.jpg\",\"99882.jpg\"]', 'rosa kitty', 200, 200, '', '0000-00-00', 20, '2025-07-02', '2025-08-06 03:23:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `visits`
--

CREATE TABLE `visits` (
  `id_visit` int(11) NOT NULL,
  `ip_visit` text DEFAULT NULL,
  `country_visit` text DEFAULT NULL,
  `region_visit` text DEFAULT NULL,
  `city_visit` text DEFAULT NULL,
  `date_created_visit` date DEFAULT NULL,
  `date_updated_visit` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `visits`
--

INSERT INTO `visits` (`id_visit`, `ip_visit`, `country_visit`, `region_visit`, `city_visit`, `date_created_visit`, `date_updated_visit`) VALUES
(1, '181.132.146.224', 'Colombia', 'Antioquia', 'Envigado', '2024-05-20', '2024-05-27 22:24:07'),
(2, '101.44.176.0', 'Mexico', 'Mexico City', 'Mexico City', '2024-05-27', '2024-05-27 15:45:44'),
(3, '102.177.160.0', 'Ecuador', 'Pichincha', 'Quito', '2024-05-27', '2024-05-27 15:46:08'),
(4, '102.38.204.0', 'Peru', 'Lima Province', 'Lima', '2024-05-27', '2024-05-27 15:46:26'),
(5, '1.178.48.0', 'Argentina', 'Buenos Aires', 'Buenos Aires', '2024-05-27', '2024-05-27 15:46:46'),
(6, '102.217.238.0', 'Colombia', 'Bogota D.C.', 'Bogotá', '2024-05-27', '2024-05-27 15:47:02'),
(7, '102.38.236.0', 'Ecuador', 'Pichincha', 'Quito', '2024-05-27', '2024-05-27 15:47:54'),
(8, '103.14.26.255', 'Mexico', 'Mexico City', 'Mexico City', '2024-05-27', '2024-05-27 15:48:56'),
(9, '104.106.95.255', 'Peru', 'Lima Province', 'Lima', '2024-05-27', '2024-05-27 15:49:28'),
(10, '102.217.237.255', 'Argentina', 'Buenos Aires F.D.', 'Buenos Aires', '2024-05-27', '2024-05-27 15:49:45'),
(11, '103.219.169.255', 'Colombia', 'Bogota D.C.', 'Bogota D.C.', '2024-05-27', '2024-05-27 15:49:56'),
(12, '1.178.255.255', 'Spain', 'Castellon', 'Torreblanca', '2024-05-27', '2024-05-27 15:55:20'),
(13, '181.132.146.224', 'Colombia', 'Antioquia', 'Envigado', '2024-05-27', '2024-05-27 22:24:33'),
(14, '190.144.218.193', 'Colombia', 'Bogota D.C.', 'Bogotá', '2024-05-27', '2024-05-28 00:27:52'),
(15, '40.77.167.73', 'United States', 'Virginia', 'Boydton', '2024-05-27', '2024-05-28 00:43:01'),
(16, '52.167.144.186', 'United States', 'Virginia', 'Boydton', '2024-05-28', '2024-05-28 05:03:56'),
(17, '181.132.146.224', 'Colombia', 'Antioquia', 'Envigado', '2024-05-28', '2024-05-28 14:03:30'),
(18, '', 'Mexico', 'Mexico City', 'Álvaro Obregón', '2025-06-07', '2025-06-08 05:16:05'),
(19, '', 'Mexico', 'Mexico City', 'Álvaro Obregón', '2025-06-14', '2025-06-14 22:58:56');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indices de la tabla `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id_banner`);

--
-- Indices de la tabla `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id_cart`),
  ADD KEY `1` (`id_seller_cart`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id_category`);

--
-- Indices de la tabla `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id_favorite`),
  ADD KEY `id_product_favorite` (`id_product_favorite`),
  ADD KEY `id_user_favorite` (`id_user_favorite`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id_order`),
  ADD KEY `id_variant_order` (`id_variant_order`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id_product`),
  ADD KEY `id_category_product` (`id_category_product`),
  ADD KEY `id_subcategory_product` (`id_subcategory_product`),
  ADD KEY `products_ibfk_3` (`id_seller_product`);

--
-- Indices de la tabla `sellers`
--
ALTER TABLE `sellers`
  ADD PRIMARY KEY (`id_seller`);

--
-- Indices de la tabla `slides`
--
ALTER TABLE `slides`
  ADD PRIMARY KEY (`id_slide`);

--
-- Indices de la tabla `socials`
--
ALTER TABLE `socials`
  ADD PRIMARY KEY (`id_social`);

--
-- Indices de la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id_subcategory`),
  ADD KEY `id_category_subcategory` (`id_category_subcategory`);

--
-- Indices de la tabla `templates`
--
ALTER TABLE `templates`
  ADD PRIMARY KEY (`id_template`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`);

--
-- Indices de la tabla `variants`
--
ALTER TABLE `variants`
  ADD PRIMARY KEY (`id_variant`),
  ADD KEY `id_product_variant` (`id_product_variant`),
  ADD KEY `variants_ibfk_2` (`id_seller_variant`);

--
-- Indices de la tabla `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`id_visit`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `admins`
--
ALTER TABLE `admins`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `banners`
--
ALTER TABLE `banners`
  MODIFY `id_banner` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `carts`
--
ALTER TABLE `carts`
  MODIFY `id_cart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id_category` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id_favorite` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id_order` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id_product` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT de la tabla `sellers`
--
ALTER TABLE `sellers`
  MODIFY `id_seller` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `slides`
--
ALTER TABLE `slides`
  MODIFY `id_slide` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `socials`
--
ALTER TABLE `socials`
  MODIFY `id_social` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id_subcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `templates`
--
ALTER TABLE `templates`
  MODIFY `id_template` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `variants`
--
ALTER TABLE `variants`
  MODIFY `id_variant` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=212;

--
-- AUTO_INCREMENT de la tabla `visits`
--
ALTER TABLE `visits`
  MODIFY `id_visit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `1` FOREIGN KEY (`id_seller_cart`) REFERENCES `sellers` (`id_seller`);

--
-- Filtros para la tabla `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`id_product_favorite`) REFERENCES `products` (`id_product`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`id_user_favorite`) REFERENCES `users` (`id_user`);

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`id_variant_order`) REFERENCES `variants` (`id_variant`);

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`id_category_product`) REFERENCES `categories` (`id_category`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`id_subcategory_product`) REFERENCES `subcategories` (`id_subcategory`),
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`id_seller_product`) REFERENCES `sellers` (`id_seller`);

--
-- Filtros para la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`id_category_subcategory`) REFERENCES `categories` (`id_category`);

--
-- Filtros para la tabla `variants`
--
ALTER TABLE `variants`
  ADD CONSTRAINT `variants_ibfk_1` FOREIGN KEY (`id_product_variant`) REFERENCES `products` (`id_product`),
  ADD CONSTRAINT `variants_ibfk_2` FOREIGN KEY (`id_seller_variant`) REFERENCES `sellers` (`id_seller`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
