
#######################################################################################
#--------------------------- MODIFICACIONES ------------------------------------------#
#######################################################################################

1- Actualización de inventario, se vendió 40 unidades del producto semilla de girasol (id =8).

UPDATE INVENTARIO
SET CANTIDAD_SALIDA = 140, CANTIDAD_STOCK = 10, FECHA_ACTUAlIZACION = DATE'2024-03-28'
WHERE ID_PRODUCTO = 8;

2- Se realizo cambio en la jornada laboral a la empleada Ana Castro Pérez (id=1).

UPDATE EMPLEADO
SET JORNADA = 'MEDIO TIEMPO'
WHERE ID_EMPLEADO = 1;

3- La clienta Sofía Chavarría Solís realizó el pago su factura pendiente #6; por lo que, 
se cambio su estado a cancelado y se registra en la tabla pago_cliente.

UPDATE FACTURA_CLIENTE
SET ESTADO = 'CANCELADO'
WHERE NUMERO_FACTURA =6; 

INSERT INTO PAGO_CLIENTE(ID_PAGO,NUMERO_FACTURA,METODO_PAGO,FECHA_PAGO)VALUES
(6,6,'EFECTIVO',DATE '2024-03-28');


4- Un cliente nos informa que realizo cambio de número de teléfono.

UPDATE CLIENTE
SET NUMERO_TELEFONO = '88729011'
WHERE ID_CLIENTE =2; 

5 - Se selecciona a un empleado que cumpla con ciertas condiciones, para promoverlo de puesto 
y aumentarle un 25% su salario.

UPDATE EMPLEADO
SET SALARIO = SALARIO * 1.25, PUESTO = 'GERENTE'
WHERE JORNADA = 'MEDIO TIEMPO' AND NOMBRE LIKE 'L%';


6 - Se procede a despedir a un empleado, debido a que no realizó niguna venta.

DELETE FROM EMPLEADO
WHERE ID_EMPLEADO IN (
    SELECT E.ID_EMPLEADO
    FROM EMPLEADO E
    LEFT JOIN VENTA_CLIENTE VC 
    ON E.ID_EMPLEADO = VC.ID_EMPLEADO
    WHERE VC.ID_VENTA IS NULL 
    AND E.NOMBRE LIKE '%S'
);

7 - Se elimina la empresa relacionada a un proveedor, dado que el mismo muy pronto empieza a laborar con otra, 
se debe dejar el espacio para completarlo una vez el mismo nos informe.

UPDATE PROVEEDOR
SET EMPRESA = NULL
WHERE EMPRESA = 'VITAPET'


8 - Debido a que el proveedor Alex Villegas incumplió con un requisito que se propuso desde un principio 
llegamos a al acuerdo de no seguir realizándole pedidos; entonces procedemos a eliminarlos de nuestro registro.
Además,otro de nuestros proveedores, nos suministrará los productos.  

--- Modificación del proveedor en el producto. 
UPDATE PRODUCTO
SET ID_PROVEEDOR = 10
WHERE ID_PRODUCTO = 7;


--- Eliminación del proveedor. 
DELETE PROVEEDOR
WHERE ID_PROVEEDOR IN (7);


9 - Hubo un aumento en el precio de algunos productos; por lo que se procede a actualizarlos.

UPDATE PRODUCTO 
SET PRECIO = 3000
WHERE ID_PRODUCTO = 9


10- Se procedio a eliminar a un cliente porque nunca realizo una compra, ademas se mudo a otro pais.

DELETE CLIENTE
WHERE ID_CLIENTE IN (9);

--SE HACE UNA  CONFIRMACÓN DEL PROYECTO.
COMMIT;
