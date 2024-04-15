################################################################################## 
#----------------------------- CONSULTAS ----------------------------------------#
##################################################################################

1-	Muestre el nombre del empleado que realizo más de dos ventas a un mismo cliente. 
Así mismo muestre el nombre del cliente. 
--- (Tablas utilizadas: empleado, venta_cliente, cliente).

SELECT E.NOMBRE || ' ' || E.APELLIDO1 || ' ' || E.APELLIDO2 AS NOMBRE_EMPLEADO,
       C.NOMBRE || ' ' || C.APELLIDO1 || ' ' || C.APELLIDO2 AS NOMBRE_CLIENTE
FROM EMPLEADO E
INNER JOIN VENTA_CLIENTE V 
ON E.ID_EMPLEADO = V.ID_EMPLEADO
INNER JOIN CLIENTE C 
ON V.ID_CLIENTE = C.ID_CLIENTE
GROUP BY E.ID_EMPLEADO, C.ID_CLIENTE, E.NOMBRE, E.APELLIDO1, E.APELLIDO2, C.NOMBRE, C.APELLIDO1, C.APELLIDO2
HAVING COUNT(V.ID_VENTA) > 2;




2- Cuente la cantidad de empleados que trabajan medio tiempo y vendieron productos. 
Así mismo, muestre el nombre del producto y la cantidad.  
--- (Tablas utilizados: empleado, venta_cliente, producto)


SELECT COUNT(DISTINCT E.ID_EMPLEADO) AS CANTIDAD_EMPLEADOS, P.NOMBRE AS NOMBRE_PRODUCTO, SUM(V.CANTIDAD) AS CANTIDAD_VENDIDA
FROM EMPLEADO E
INNER JOIN VENTA_CLIENTE V 
ON E.ID_EMPLEADO = V.ID_EMPLEADO
INNER JOIN PRODUCTO P
ON V.ID_PRODUCTO = P.ID_PRODUCTO
WHERE E.JORNADA = 'MEDIO TIEMPO'
GROUP BY P.NOMBRE;


                                 
                                     
3- Muestre el cliente que tiene mas de 3 facturas en donde su estado es cancelado y fue pagada en el año 2024
--- (Tablas utilizadas: empleado, factura_cliente, pago_cliente, venta_cliente)

SELECT C.NOMBRE || ' ' || C.APELLIDO1 || ' ' || C.APELLIDO2 AS NOMBRE_CLIENTE
FROM CLIENTE C
INNER JOIN VENTA_CLIENTE V ON C.ID_CLIENTE = V.ID_CLIENTE
INNER JOIN FACTURA_CLIENTE F ON V.ID_VENTA = F.ID_VENTA
INNER JOIN PAGO_CLIENTE P ON F.NUMERO_FACTURA = P.NUMERO_FACTURA
WHERE F.ESTADO = 'CANCELADO' AND EXTRACT(YEAR FROM P.FECHA_PAGO) = 2024
GROUP BY C.ID_CLIENTE, C.NOMBRE, C.APELLIDO1, C.APELLIDO2
HAVING COUNT(DISTINCT F.NUMERO_FACTURA) > 3;

                                   

4- Muestre el nombre y tamaño de los productos que tienen una cantidad en stock menor a 5;
el nombre completo y teléfono del proveedor de dichos productos.
--- (Tablas utilizadas: producto, inventario,proveedor).

SELECT P.NOMBRE NOMBRE_PRODUCTO, P.TAMANNO TAMAÑO, PR.NOMBRE || ' ' || PR.APELLIDO1 || ' ' || PR.APELLIDO2 NOMBRE_PROVEEDOR, 
       PR.NUMERO_TELEFONO
FROM PRODUCTO P
INNER JOIN INVENTARIO I
ON P.ID_PRODUCTO = I.ID_PRODUCTO
INNER JOIN PROVEEDOR PR
ON P.ID_PROVEEDOR = PR.ID_PROVEEDOR
WHERE I.CANTIDAD_STOCK <5;

                                    
5- Muestre las empresas a la que su proveedor se le ha realizado pedidos y que 
su monto total es igual o mayor a 100.000 colones. Así mismo, muestre las cantidades
de pedido y el monto total. 
---(Tablas utilizadas: proveedor, pedido_proveedor y pago_proveedor).

SELECT P.EMPRESA,
       COUNT(PP.ID_PEDIDO) AS CANTIDAD_PEDIDOS,
       SUM(PG.MONTO_TOTAL) AS MONTO_TOTAL
FROM PROVEEDOR P
INNER JOIN PEDIDO_PROVEEDOR PP 
ON P.ID_PROVEEDOR = PP.ID_PROVEEDOR
INNER JOIN PAGO_PROVEEDOR PG 
ON PP.ID_PEDIDO = PG.ID_PEDIDO
GROUP BY P.EMPRESA
HAVING SUM(PG.MONTO_TOTAL) >= 100000
ORDER BY COUNT(PP.ID_PEDIDO) DESC


                                  
6- Muestre los nombres de los clientes que tienen facturas pendientes de pago y 
los productos comprados inician con la letra M.
--- (Tablas utilizadas: factura_cliente, cliente, venta_cliente, producto).

SELECT DISTINCT C.NOMBRE || ' ' || C.APELLIDO1 || ' ' || C.APELLIDO2 AS NOMBRE_CLIENTE
FROM CLIENTE C
INNER JOIN FACTURA_CLIENTE F 
ON C.ID_CLIENTE = F.ID_CLIENTE
INNER JOIN VENTA_CLIENTE V 
ON F.ID_VENTA = V.ID_VENTA
INNER JOIN PRODUCTO P 
ON V.ID_PRODUCTO = P.ID_PRODUCTO
WHERE upper (F.ESTADO) = 'PENDIENTE' AND upper(P.NOMBRE) LIKE 'M%';

                                   
                                    
7- Detalle el desglose de los ventas a clientes. Muestre el codigo del cliente, codigo del producto, nombre del producto, 
cantidad y monto total. 
---(Tablas utilizadas: cliente, venta_cliente, producto) 

SELECT C.ID_CLIENTE, P.ID_PRODUCTO,P.NOMBRE, V.CANTIDAD,(P.PRECIO * V.CANTIDAD) TOTAL
FROM CLIENTE C
INNER JOIN VENTA_CLIENTE V
ON C.ID_CLIENTE = V.ID_CLIENTE
INNER JOIN PRODUCTO P
ON V.ID_PRODUCTO = P.ID_PRODUCTO

                                   
                                   
8- Muestre el nombre del proveedor y las fechas de pedido, que se compraron más de 10 unidades de 
un mismo producto y que su estado de pago está aplicado. 
---(Tablas utilizadas: proveedor, pedido_proveedor, pago_proveedor)


SELECT PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2, PP.FECHA_PEDIDO
FROM PROVEEDOR PR
JOIN PEDIDO_PROVEEDOR PP 
ON PR.ID_PROVEEDOR = PP.ID_PROVEEDOR
JOIN PAGO_PROVEEDOR PA 
ON PP.ID_PEDIDO = PA.ID_PEDIDO
WHERE PP.CANTIDAD > 10 AND PA.ESTADO= 'CANCELADO';

                             
                                      
9- Muestre el nombre del producto que más se vendió y su cantidad en stock.
---(Tablas utilizadas: producto, venta_cliente, inventario)

SELECT NOMBRE, CANTIDAD_STOCK
FROM (
    SELECT P.NOMBRE, I.CANTIDAD_STOCK, RANK() OVER (ORDER BY VC.CANTIDAD DESC) AS RANKING 
    ---  asigna un número de rango a cada fila, de acuerdo a la cantidad vendida.
    FROM PRODUCTO P
    INNER JOIN VENTA_CLIENTE VC 
    ON P.ID_PRODUCTO = VC.ID_PRODUCTO
    INNER JOIN INVENTARIO I 
    ON P.ID_PRODUCTO = I.ID_PRODUCTO
)
WHERE RANKING = 1;



10- Muestre el nombre de los proveedores, el pedido asociado y la fecha, que este pendiente de pago.
---(Tablas utilizadas: proveedor, pedido_proveedor, pago_proveedor).

SELECT PR.NOMBRE AS NOMBRE_PROVEEDOR, PP.ID_PEDIDO, PP.FECHA_PEDIDO
FROM PROVEEDOR PR
INNER JOIN PEDIDO_PROVEEDOR PP 
ON PR.ID_PROVEEDOR = PP.ID_PROVEEDOR
LEFT JOIN PAGO_PROVEEDOR PA 
ON PP.ID_PEDIDO = PA.ID_PEDIDO
WHERE PA.ESTADO <> 'CANCELADO' OR PA.ESTADO IS NULL; --- <> diferente

                                
                                     
11- Muestre el nombre de los productos que no se vendieron, su cantidad de entrada y salida.
---(Tabla utilizadas: producto, venta_cliente, inventario)

SELECT P.NOMBRE, I.CANTIDAD_ENTRADA, I.CANTIDAD_SALIDA
FROM PRODUCTO P
JOIN INVENTARIO I 
ON P.ID_PRODUCTO = I.ID_PRODUCTO
LEFT JOIN VENTA_CLIENTE VC 
ON P.ID_PRODUCTO = VC.ID_PRODUCTO
WHERE VC.ID_VENTA IS NULL; 
                                     


12- Detalle el desglose de los pedido proveedores. Muestre el codigo del proveedor, codigo del producto, nombre del producto, 
cantidad,precio unitario y monto total. 
---(Tablas utilizadas: pedido_proveedor, producto, proveedor).


SELECT PP.ID_PROVEEDOR, P.ID_PRODUCTO, 
P.NOMBRE AS NOMBRE_PRODUCTO, PP.CANTIDAD, PP.PRECIO_UNITARIO, PP.CANTIDAD * PP.PRECIO_UNITARIO AS MONTO_TOTAL
FROM PEDIDO_PROVEEDOR PP
INNER JOIN PRODUCTO P 
ON PP.ID_PRODUCTO = P.ID_PRODUCTO
INNER JOIN PROVEEDOR PR 
ON PP.ID_PROVEEDOR = PR.ID_PROVEEDOR;

COMMIT;