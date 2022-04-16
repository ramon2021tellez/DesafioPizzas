\c daniela
--Paso 1 crear base de datos pizzeria
CREATE DATABASE pizzeria;
--Paso 2 conexion a base de datos creada
\c pizzeria
--Paso 3 crear tabla pizzas y ventas
--crear table pizzas
CREATE TABLE pizzas(
    id INT ,
    stock INT CHECK (stock >= 0.00),
    costo DECIMAL ,
    nombre VARCHAR(25),
    PRIMARY KEY(id)
);
--crear tabla ventas 
CREATE TABLE ventas(
    cliente VARCHAR(20),
    fecha DATE,
    monto DECIMAL,
    pizza INT,
    FOREIGN KEY (pizza) REFERENCES pizzas(id)
);
--Paso 4 agregar registro a tabla pizzas
INSERT INTO pizzas (id , stock , costo , nombre)
VALUES (1,0,12000,'Uhala');
--Paso 5 probar primera transaccion ingresando nueva pizza
BEGIN;
INSERT INTO pizzas (id , stock , costo , nombre)
VALUES (2,2,15000,'Jamon a todo dar');
COMMIT;
--Paso 6 transaccion registra venta con la pizza con stock 0
--intenta actualizar stock restandole 1
--BEGIN;
--INSERT INTO ventas (cliente, fecha , monto , pizza)
--VALUES ('Dexter Gonzalez', '2020-02-02', 12000, 1);
--UPDATE pizzas SET stock = stock -1 WHERE id = 1;
--COMMIT;
--devuelve error el nuevo registro para la relacion pizzas
--viola la restriccion check y stock
--Paso 7 realizar venta 2 pizzas pero solo una tiene stock
BEGIN;
INSERT INTO ventas(cliente, fecha, monto , pizza)
VALUES ('Juan Bravo' , '2020-02-02', 15000 , 2);
UPDATE pizzas SET stock = stock - 1 WHERE id = 2;
SAVEPOINT checkpoint;
INSERT INTO ventas (clientes,fecha, monto , pizza)
VALUES ('Utomio Ramirez','2020-02-02',12000,1);
UPDATE pizzas SET stock = stock - 1 WHERE id = 1;
-- recibimos un error por intentar rebajar en stock 0
ROLLBACK TO checkpoint;
-- Paso 8 pizzeria no le va bien y quiere un respaldo
--pg_dump -U postgres pizzeria > pizzeria.sql
SELECT * FROM ventas;
SELECT * FROM pizzas; 