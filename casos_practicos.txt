--- TRABAJANDO CON OBJETOS 
-- Creamos una tabla con un campo tipo json
CREATE TABLE ordenes(
	ID serial NOT NULL PRIMARY KEY,
	info json NOT NULL
);

INSERT INTO ordenes (info)
values 
	(
		'{"cliente": "David Sánchez", "items":{"producto":"Biberón", "cantidad" : "24"}}'	
	),
	(
		'{"cliente": "Ubldo García", "items":{"producto":"Carro de juguete", "cantidad" : "1"}}'	
	),
	(
		'{"cliente": "Catalina Delgado", "items":{"producto":"Libro", "cantidad" : "16"}}'	
	);
	
SELECT * FROM ordenes;

--Extrayendo los datos
SELECT 
	info ->'cliente' AS cliente
FROM ordenes;-- Se lo sigue trayendo en formato Json

SELECT 
	info ->>'cliente' AS cliente
FROM ordenes;-- Se lo sigue trayendo en formato String

SELECT 
	info ->>'cliente' AS cliente
FROM ordenes
WHERE info ->'items' ->>'producto' = 'Biberón';

--- AGREGANDO OBJETOS
SELECT 
	MIN(
		CAST(
			info -> 'items' ->> 'cantidad' AS INTEGER
		)
	)
FROM ordenes;

SELECT 
	MIN(
		CAST(
			info -> 'items' ->> 'cantidad' AS INTEGER
		)
	),
	MAX(
		CAST(
			info -> 'items' ->> 'cantidad' AS INTEGER
		)
	),
	SUM(
		CAST(
			info -> 'items' ->> 'cantidad' AS INTEGER
		)
	),
	AVG(
		CAST(
			info -> 'items' ->> 'cantidad' AS INTEGER
		)
	)
FROM ordenes; -- internamente está haciendo muchos calculos | en caso de qeu tengamos los datos en formatos básicos es mejor trbajar con ellos que con objetos | por otro lado esta es una forma de trabajar con objetos si solo disponemos de ellos.

--- Common table expressions
WITH RECURSIVE tabla_recursiva(n) AS (-- el WITH las define
	VALUES(1)
	UNION 
	SELECT n+1 FROM tabla_recursiva WHERE n < 100
) SELECT SUM(n) FROM tabla_recursiva;