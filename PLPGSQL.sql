-- Procedures 
CREATE OR REPLACE PROCEDURE test_drpcreate_procedure()-- Crear o remplazar
LANGUAGE SQL 
AS $$
	DROP TABLE IF EXISTS aaa;
	CREATE TABLE aaa (bbb char (5) CONSTRAINT firstkey PRIMARY KEY); 
$$;

CALL test_drpcreate_procedure();--Cualuier cosa que quieras utomatizar la puedes encapsular en un procedimiento

-- Functions
CREATE OR REPLACE FUNCTION test_drpcreate_function()
RETURNS VOID -- Tenemos que declara que regresa
LANGUAGE plpgsql
AS $$
BEGIN
	DROP TABLE IF EXISTS aaa;
	CREATE TABLE  aaa (bbb char(5) CONSTRAINT firstkey PRIMARY KEY, ccc char(5));
	DROP TABLE IF EXISTS aaab;
	CREATE TABLE aaab (bbba char(5) CONSTRAINT secondkey PRIMARY KEY, ccca char(5)); 
END
$$;

SELECT test_drpcreate_function();


CREATE OR REPLACE FUNCTION count_total_movies()
RETURNS int
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN COUNT(*) FROM peliculas;
END 
$$;

SELECT count_total_movies();

-- Orienta a ser un trigger
CREATE OR REPLACE FUNCTION duplicate_records()
RETURNS trigger --apara que haga algo depués
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO aaab(bbba, ccca)
	VALUES(NEW.bbb, NEW.ccc); 
	RETURN NEW;
END 
$$;

--Crando el dispararador 
CREATE TRIGGER aaa_changes
	BEFORE INSERT 
	ON aaa
	FOR EACH ROW 
	EXECUTE PROCEDURE duplicate_records();
	
INSERT INTO aaa (bbb, ccc)
VALUES ('abcde','efghi');

SELECT * FROM public.aaa;
SELECT * FROM public.aaab;

CREATE OR REPLACE FUNCTION movies_stats()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE--Declarando variables
	total_rated_r REAL := 0.0;
	total_larger_thank_100 REAL := 0.0;
	total_published_2006 REAL := 0.0;
	average_duration REAL := 0.0;
	average_rental_price REAL := 0.0;
BEGIN 
	total_rated_r := COUNT(*) FROM peliculas WHERE clasificacion = 'R';
	total_larger_thank_100 := COUNT(*) FROM peliculas WHERE duracion > 100;
	total_published_2006 := COUNT(*) FROM peliculas WHERE anio_publicacion = 2006;
	average_duration := AVG(duracion) FROM peliculas;
	average_rental_price := AVG(precio_renta) FROM peliculas;
	
	TRUNCATE TABLE peliculas_estadisticas;--El trucate nos sirve para borrar lo que habia en la tabla, si habia algo antes y para guarda nuevos datos
	
	INSERT INTO peliculas_estadisticas(tipo_estadistica, total)
	VALUES 
		('Películas con clasificacion R',total_rated_r),
		('Películas de más de 100 minutos',total_larger_thank_100),
		('Películas publicadas en 2006',total_published_2006),
		('Promedio de duración en minutos', average_duration),
		('Precio promedio de renta',average_rental_price);
END 
$$;

SELECT * from public.peliculas_estadisticas;
SELECT movies_stats();


---PL/pgSQL

CREATE FUNCTION pgmax (a integer, b integer)
RETURNS integer
AS $$
BEGIN
   IF a > b THEN
       RETURN a;
   ELSE
       RETURN b;
   END IF;
END
$$ LANGUAGE plpgsql;


--- PL/Python


CREATE FUNCTION pymax (a integer, b integer)
RETURNS integer
AS $$
   if a > b:
       return a
   return b
$$ LANGUAGE plpythonu;

CREATE EXTENSION plpythonu;
SELECT pgmax(200,9);



CREATE TYPE humor AS ENUM ('trsite', 'normal', 'feliz');-- Esto es case-sensitive

CREATE TABLE persona_prueba(
	nombre text,
	humor_actual humor -- El tipo de datos es "humor"
);

INSERT INTO persona_prueba VALUES ('Pablo', 'feliz');
INSERT INTO persona_prueba VALUES ('Fer', 'Feliz');-- incorrecto, te lanza un error

SELECT * FROM persona_prueba;