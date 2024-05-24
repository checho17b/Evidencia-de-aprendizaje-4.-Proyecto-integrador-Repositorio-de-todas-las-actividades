USE jardineria

	/*CODIGO VALIDA Y BORRA TABLA TEMPORAL VENTAS*/

	DROP TABLE IF EXISTS VENTAS

	/*CONSULTA CREA TABLA VENTAS*/

	SELECT p.ID_pedido AS VentasID, p.fecha_pedido AS FECHA, c.ID_cliente AS ClienteID, c.nombre_cliente, 
	e.ID_oficina AS OficinaID, O.Descripcion AS Oficina, dp.ID_producto AS ProductoID, pro.nombre
	INTO VENTAS
	FROM pedido p
	INNER JOIN cliente c ON p.ID_cliente = c.ID_cliente
	INNER JOIN oficina O ON O.ID_oficina = C.ID_cliente
	INNER JOIN empleado e ON c.ID_empleado_rep_ventas = e.ID_empleado
	INNER JOIN detalle_pedido dp ON p.ID_pedido = dp.ID_pedido
	INNER JOIN producto PRO ON CAST(DP.ID_producto AS varchar) = dp.ID_producto
	ORDER BY FECHA

	/*CONSULTA CREA TABLA TIEMPO*/

	SELECT  P.ID_cliente,C.nombre_cliente, YEAR(fecha_pedido) AS AÑO
	, MONTH(fecha_pedido) AS MES,DAY(fecha_pedido) AS DIA
	FROM pedido P
	JOIN VENTAS V ON V.ClienteID = P.ID_cliente
	JOIN cliente C ON C.ID_cliente = V.ClienteID
	ORDER BY AÑO, DIA DESC

	/*CONSULTA CREA TABLA CLIENTE*/

	SELECT DISTINCT C.nombre_cliente,c.telefono, C.pais,C.region, C.ciudad, c.codigo_postal
	FROM cliente C
	ORDER BY nombre_cliente, pais

	/*CONSULTA CREA TABLA PRODUCTO*/

	SELECT p.ID_producto AS 'orden id', ped.fecha_pedido AS 'date_orden', p.nombre AS 'nombre_producto', p.Categoria AS 'categoria', p.descripcion AS 'descripcion'
	FROM pedido ped
	JOIN detalle_pedido dp ON ped.ID_pedido = dp.ID_pedido
	JOIN producto p ON dp.ID_producto = p.ID_producto

	/*CONSULTA CREA TABLA OFICINA*/

	SELECT ID_oficina,Descripcion,ciudad,pais,region,codigo_postal,telefono,linea_direccion1
	FROM oficina



