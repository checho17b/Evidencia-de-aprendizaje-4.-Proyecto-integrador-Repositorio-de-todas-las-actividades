USE jardineria

/*Manejo de ROLLBACK ante fallos*/
BEGIN TRY
	BEGIN TRAN
	
		/*CODIGO VALIDA Y BORRA TABLA TEMPORAL VENTAS*/
	DROP TABLE IF EXISTS VENTAS

	/*CONSULTA CREA TABLA VENTAS TEMPORAL*/

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VENTAS') AND type in (N'U'))
	BEGIN
		SELECT DISTINCT p.ID_pedido AS VentasID, p.fecha_pedido AS FECHA, c.ID_cliente AS ClienteID, c.nombre_cliente, 
		e.ID_oficina AS OficinaID, O.Descripcion AS Oficina,dp.ID_producto AS ProductoID, pro.nombre
		INTO VENTAS
		FROM pedido p
		INNER JOIN cliente c ON p.ID_cliente = c.ID_cliente
		INNER JOIN oficina O ON O.ID_oficina = C.ID_cliente
		INNER JOIN empleado e ON c.ID_empleado_rep_ventas = e.ID_empleado
		INNER JOIN detalle_pedido dp ON p.ID_pedido = dp.ID_pedido
		INNER JOIN producto PRO ON CAST(DP.ID_producto AS varchar) = dp.ID_producto
		ORDER BY FECHA
	END

	
		/*CONSULTA CREA TABLA TIEMPO*/
	-- Paso 1: Seleccionar los datos en una tabla temporal


	SELECT DISTINCT 
		P.ID_cliente, 
		C.nombre_cliente, 
		YEAR(fecha_pedido) AS AÑO,
		MONTH(fecha_pedido) AS MES,
		DAY(fecha_pedido) AS DIA
	INTO #TempTIEMPO
	FROM pedido P
	JOIN VENTAS V ON V.ClienteID = P.ID_cliente
	JOIN cliente C ON C.ID_cliente = V.ClienteID;

	-- Paso 2: Crear la tabla final TIEMPO con la columna ID_tiempo como IDENTITY
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VENTAS') AND type in (N'U'))
	CREATE TABLE TIEMPO (
		ID_tiempo INT IDENTITY(1,1) PRIMARY KEY,
		ID_cliente INT,
		nombre_cliente NVARCHAR(255),
		AÑO INT,
		MES INT,
		DIA INT
	);

		-- Paso 3: Insertar los datos de la tabla temporal en la tabla final TIEMPO
		INSERT INTO TIEMPO (ID_cliente, nombre_cliente, AÑO, MES, DIA)
		SELECT ID_cliente, nombre_cliente, AÑO, MES, DIA
		FROM #TempTIEMPO
		ORDER BY AÑO, DIA DESC;

		-- Paso 4: Eliminar la tabla temporal
		DROP TABLE #TempTIEMPO;


			SELECT DISTINCT 
		P.ID_cliente, 
		C.nombre_cliente, 
		T.ID_tiempo,
		YEAR(P.fecha_pedido) AS AÑO,
		MONTH(P.fecha_pedido) AS MES,
		DAY(P.fecha_pedido) AS DIA
	FROM pedido P
	JOIN VENTAS V ON V.ClienteID = P.ID_cliente
	JOIN cliente C ON C.ID_cliente = V.ClienteID
	JOIN TIEMPO T ON T.ID_cliente = P.ID_cliente
		AND T.nombre_cliente = C.nombre_cliente
		AND T.AÑO = YEAR(P.fecha_pedido)
		AND T.MES = MONTH(P.fecha_pedido)
		AND T.DIA = DAY(P.fecha_pedido)
	ORDER BY AÑO, DIA DESC;

	
		SELECT * FROM TIEMPO

	DROP TABLE IF EXISTS VENTAS

		SELECT DISTINCT p.ID_pedido AS VentasID, p.fecha_pedido AS FECHA, c.ID_cliente AS ClienteID, c.nombre_cliente, 
		e.ID_oficina AS OficinaID, O.Descripcion AS Oficina,T.ID_cliente AS ID_TIEMPO, dp.ID_producto AS ProductoID, pro.nombre
		INTO VENTAS
		FROM pedido p
		INNER JOIN cliente c ON p.ID_cliente = c.ID_cliente
		INNER JOIN oficina O ON O.ID_oficina = C.ID_cliente
		INNER JOIN empleado e ON c.ID_empleado_rep_ventas = e.ID_empleado
		INNER JOIN detalle_pedido dp ON p.ID_pedido = dp.ID_pedido
		INNER JOIN producto PRO ON CAST(DP.ID_producto AS varchar) = dp.ID_producto
		INNER JOIN TIEMPO t on t.[ID_cliente] = c.ID_cliente
		ORDER BY FECHA

		SELECT * FROM VENTAS
	/*CONSULTA CREA TABLA CLIENTE*/


	

	
	SELECT DISTINCT C.nombre_cliente,c.telefono, C.pais,C.region, C.ciudad, c.codigo_postal
	FROM cliente C
	ORDER BY nombre_cliente, pais

	/*CONSULTA CREA TABLA PRODUCTO*/
	SELECT 
		p.ID_producto AS 'orden id',
		p.nombre AS 'nombre_producto',
		c.Desc_Categoria AS 'categoria',
		p.descripcion AS 'descripcion'
	FROM 
		producto p
	JOIN 
		Categoria_producto c ON p.Categoria = c.Desc_Categoria

	

	/*CONSULTA CREA TABLA OFICINA*/
	--Esta esta super bien.
	SELECT ID_oficina,
		Descripcion,
		ciudad,
		pais,
		region,
		codigo_postal,
		telefono,
		linea_direccion1
	FROM oficina

	

   COMMIT TRAN
END TRY
BEGIN CATCH
    -- Captura y muestra el error
    SELECT ERROR_MESSAGE() AS ErrorMessage, 
           ERROR_NUMBER() AS ErrorNumber, 
           ERROR_SEVERITY() AS ErrorSeverity, 
           ERROR_STATE() AS ErrorState, 
           ERROR_LINE() AS ErrorLine, 
           ERROR_PROCEDURE() AS ErrorProcedure;
END CATCH;

  
 
 	