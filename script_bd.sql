📌 BASE DE DATOS: bar_league
usuarios
Campo	Tipo	Descripción
id_usuario	INT	PK, AUTO_INCREMENT
codigo	VARCHAR	Código único del usuario
nombre	VARCHAR	Nombre completo
contraseña	VARCHAR	Contraseña hasheada o simple
tipo_usuario	VARCHAR	admin, mesero, etc.
________________________________________
productos
Campo	Tipo	Descripción
id_producto	INT	PK, AUTO_INCREMENT
codigo	VARCHAR	Código del producto
nombre	VARCHAR	Nombre del producto (ej. hamburguesa)
descripcion	TEXT	Opcional
valor_unitario	DECIMAL	Precio
________________________________________
pedidos
Campo	Tipo	Descripción
id_pedido	INT	PK, AUTO_INCREMENT
fecha	DATETIME	Fecha y hora del pedido
id_usuario	INT	FK → usuarios(id_usuario)
estado	VARCHAR	pendiente, servido, pagado
________________________________________
detalle_pedido (detalle del pedido)
Campo	Tipo	Descripción
id_detalle	INT	PK, AUTO_INCREMENT
id_pedido	INT	FK → pedidos(id_pedido)
id_producto	INT	FK → productos(id_producto)
cantidad	INT	Cantidad del producto
subtotal	DECIMAL	cantidad × valor_unitario
________________________________________
ventas
Campo	Tipo	Descripción
id_venta	INT	PK, AUTO_INCREMENT
id_pedido	INT	FK → pedidos(id_pedido)
total_venta	DECIMAL	Total del pedido (sumatoria de subtotales)
fecha_venta	DATETIME	Fecha de registro de la venta
________________________________________

--datos de prueba si quieres:
INSERT INTO usuarios (codigo, nombre, contrasena, tipo_usuario) VALUES
('admin001', 'Administrador General', 'admin123', 'admin');