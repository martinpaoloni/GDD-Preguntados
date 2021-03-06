
-- CREACION DE SCHEMA
-- Comprueba si no existe ninguno, sino existe lo crea.
USE GESTION

GO

SET DATEFORMAT dmy

GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'PARCIAL')
BEGIN
	EXEC ('CREATE SCHEMA PARCIAL AUTHORIZATION dbo')
END

-- FIN CREACION DE SCHEMA

--borrado de tablas--

IF OBJECT_ID('PARCIAL.Logs', 'U') IS NOT NULL
DROP TABLE PARCIAL.Logs

IF OBJECT_ID('PARCIAL.RelacionPaisPregunta', 'U') IS NOT NULL
DROP TABLE PARCIAL.RelacionPaisPregunta

IF OBJECT_ID('PARCIAL.Respuestas', 'U') IS NOT NULL
DROP TABLE PARCIAL.Respuestas

IF OBJECT_ID('PARCIAL.Preguntas', 'U') IS NOT NULL
DROP TABLE PARCIAL.Preguntas

IF OBJECT_ID('PARCIAL.Competiciones', 'U') IS NOT NULL
DROP TABLE PARCIAL.Competiciones

IF OBJECT_ID('PARCIAL.Jugadores', 'U') IS NOT NULL
DROP TABLE PARCIAL.Jugadores

IF OBJECT_ID('PARCIAL.Niveles', 'U') IS NOT NULL
DROP TABLE PARCIAL.Niveles

IF OBJECT_ID('PARCIAL.Paises', 'U') IS NOT NULL
DROP TABLE PARCIAL.Paises

IF OBJECT_ID('PARCIAL.Categoria', 'U') IS NOT NULL
DROP TABLE PARCIAL.Categoria

--BORRADO DE PROCEDIMIENTOS

IF OBJECT_ID('PARCIAL.cargar_jugador', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_jugador

IF OBJECT_ID('PARCIAL.cargar_pais', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_pais

IF OBJECT_ID('PARCIAL.cargar_preguntas', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_preguntas

IF OBJECT_ID('PARCIAL.cargar_categorias', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_categorias

IF OBJECT_ID('PARCIAL.cargar_niveles', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_niveles

IF OBJECT_ID('PARCIAL.cargar_competiciones', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_competiciones

IF OBJECT_ID('PARCIAL.cargar_respuestas', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_respuestas

IF OBJECT_ID('PARCIAL.cargar_respuesta2', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_respuesta2

IF OBJECT_ID('PARCIAL.cargar_relpaispreg', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_relpaispreg

IF OBJECT_ID('PARCIAL.cargar_logs', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.cargar_logs

IF OBJECT_ID('PARCIAL.recalcular_porcentajes', 'P') IS NOT NULL
DROP PROCEDURE PARCIAL.recalcular_porcentajes

IF OBJECT_ID ('PARCIAL.actualizarPorcentajes', 'TR') IS NOT NULL
   DROP TRIGGER PARCIAL.actualizarPorcentajes;
GO

--creacion de tablas

create table PARCIAL.Paises
(
	IdPais numeric(18,0) IDENTITY (1,1),
	Detalle nvarchar(45)
	PRIMARY KEY (IdPais)
	)


CREATE TABLE PARCIAL.Jugadores
(
	IdJugador numeric(18,0) IDENTITY(1,1),
	Nombre nvarchar(45) ,
	Pais numeric(18,0),
	Nick nvarchar(45),
	TotalJugados numeric(18,0),
	TotalGanados numeric (18,0),
	FechaAlta date
	PRIMARY KEY (IdJugador),
	FOREIGN KEY (Pais) REFERENCES PARCIAL.Paises(IdPais),
	CONSTRAINT ct_Unique_Nombre Unique(Nombre)
)

CREATE TABLE PARCIAL.Categoria
(
	IdCategoria numeric (18,0) IDENTITY (1,1),
	Detalle nvarchar(45)
	PRIMARY KEY (IdCategoria),
	)
	
create table PARCIAL.Niveles
(
	IdNivel numeric (18,0) IDENTITY (1,1),
	Detalle nvarchar(45),
	PRIMARY KEY (IdNivel),
	)
	
create table PARCIAL.Preguntas
(
	IdPregunta numeric (18,0) IDENTITY (1,1),
	Detalle nvarchar(55),
	Categoria numeric (18,0),
	Nivel numeric (18,0),
	FechaInicio date,
	FechaFin date,
	PRIMARY KEY (IdPregunta),
	FOREIGN KEY (Nivel) REFERENCES PARCIAL.Niveles(IdNivel),
	FOREIGN KEY (Categoria) REFERENCES PARCIAL.Categoria(IdCategoria),
	)
	
create table PARCIAL.Respuestas
(
	IdRespuesta numeric (18,0) IDENTITY (1,1),
	Pregunta numeric (18,0),
	Letra nvarchar(1),
	Detalle nvarchar(45),
	esCorrecta nvarchar(1),
	porcentaje numeric (3,0),
	PRIMARY KEY (IdRespuesta),
	FOREIGN KEY (Pregunta) REFERENCES PARCIAL.Preguntas(IdPregunta),
	CONSTRAINT chk_esCorrecta CHECK (esCorrecta IN ('S', 'N')),
	CONSTRAINT chk_Letra CHECK (Letra IN ('A', 'B', 'C', 'D')),
	CONSTRAINT chk_porcentaje CHECK (porcentaje between 0 and 100)
	)
	
create table PARCIAL.RelacionPaisPregunta
(
	IdPais numeric (18,0),
	IdPregunta numeric (18,0),
	FOREIGN KEY (IdPais) REFERENCES PARCIAL.Paises(IdPais),
	FOREIGN KEY (IdPregunta) REFERENCES PARCIAL.Preguntas(IdPregunta),
	)
	
create table PARCIAL.Competiciones
(
	IdCompeticion numeric (18,0) IDENTITY (1,1),
	Jugador1 numeric(18,0),
	Jugador2 numeric(18,0),
	Jugador3 numeric(18,0),
	Jugador4 numeric(18,0),
	Jugador5 numeric(18,0),
	Ganador numeric (1,0),
	PRIMARY KEY (IdCompeticion),
	FOREIGN KEY (Jugador1) REFERENCES PARCIAL.Jugadores(IdJugador),
	FOREIGN KEY (Jugador2) REFERENCES PARCIAL.Jugadores(IdJugador),
	FOREIGN KEY (Jugador3) REFERENCES PARCIAL.Jugadores(IdJugador),
	FOREIGN KEY (Jugador4) REFERENCES PARCIAL.Jugadores(IdJugador),
	FOREIGN KEY (Jugador5) REFERENCES PARCIAL.Jugadores(IdJugador),
	CONSTRAINT chk_Ganador CHECK (Ganador between 0 and 5)
	)
	

	
create table PARCIAL.Logs
(
	IdLog numeric (18,0) IDENTITY (1,1),
	Pregunta numeric (18,0),
	Respuesta numeric (18,0),
	Jugador numeric (18,0),
	Competicion numeric (18,0),
	FechaHora date
	PRIMARY KEY (IdLog),
	FOREIGN KEY (Pregunta) REFERENCES PARCIAL.Preguntas(IdPregunta),
	FOREIGN KEY (Respuesta) REFERENCES PARCIAL.Respuestas(IdRespuesta),
	FOREIGN KEY (Jugador) REFERENCES PARCIAL.Jugadores(IdJugador),
	FOREIGN KEY (Competicion) REFERENCES PARCIAL.Competiciones(IdCompeticion),
	)
	
--FIN DE CREACION DE TABLAS--

-- CREACION DE PROCEDIMIENTOS--

--prodedimientos para cargar datos

GO

CREATE PROCEDURE PARCIAL.cargar_jugador
	@Nombre nvarchar(45),
	@Pais nvarchar (45),
	@Nick nvarchar(45),	
	@FechaAlta date
	
AS BEGIN
	INSERT INTO PARCIAL.Jugadores
		(Nombre,Pais, Nick,TotalGanados,TotalJugados,FechaAlta)
	VALUES
		(@Nombre, @Pais, @Nick,0,0, @FechaAlta)
	END
GO

CREATE PROCEDURE PARCIAL.cargar_pais
@Detalle nvarchar(45)
AS BEGIN
	INSERT INTO PARCIAL.Paises
		(Detalle)
	VALUES
		(@Detalle)
END
GO

create procedure PARCIAL.cargar_categorias
@Detalle nvarchar(45)
as begin
		insert into PARCIAL.Categoria
		(Detalle)
		values
		(@Detalle)
end
go
	
create procedure PARCIAL.cargar_niveles
@Detalle nvarchar(45)
as begin
		insert into PARCIAL.Niveles
		(Detalle)
		values 
		(@Detalle)
end
 go
	
create procedure PARCIAL.cargar_competiciones
@Jugador1 numeric (18,0),
@Jugador2 numeric (18,0),
@Jugador3 numeric (18,0),
@Jugador4 numeric (18,0),
@Jugador5 numeric (18,0),
@Ganador numeric (1,0)
as begin
		insert into PARCIAL.Competiciones
		(Jugador1, Jugador2, Jugador3, Jugador4, Jugador5, Ganador)
		values
		(@Jugador1, @Jugador2, @Jugador3, @Jugador4, @Jugador5, @Ganador)
	end
	go

create procedure PARCIAL.cargar_respuestas
@Pregunta numeric (18,0),
@Letra nvarchar(1),
@Detalle nvarchar (45),
@esCorrecta nvarchar(1)
as begin 
	insert into PARCIAL.Respuestas
	(Pregunta, Letra, Detalle, esCorrecta , porcentaje)
	values
	(@Pregunta, @Letra, @Detalle, @esCorrecta, null)
end
go
	
create procedure PARCIAL.cargar_relpaispreg
@IdPais numeric (18,0),
@IdPregunta numeric (18,0)
as begin
	insert into PARCIAL.RelacionPaisPregunta
	(IdPais, IdPregunta)	
	values
	(@IdPais, @IdPregunta)
	end
go

create procedure PARCIAL.cargar_logs
@Jugador numeric (18,0),
@Competicion numeric (18,0),
@FechaHota date,
@Ganador nvarchar(1)
as 
	declare @Pais numeric (18,0)
	declare @Pregunta numeric (18,0)		
	declare @Respuesta numeric (18,0)
	Set @Pais = (select pais from PARCIAL.Jugadores where IdJugador = @Jugador)
	
	Set @Pregunta = (Select top 1 P.IdPregunta from
PARCIAL.Preguntas P
INNER JOIN PARCIAL.RelacionPaisPregunta R
ON P.IdPregunta = R.IdPregunta and P.FechaInicio is not NUll and FechaFin is null
Where R.IdPais = 1 or P.IdPregunta in (5,10,15,20,25) order by newid())
	Set @Respuesta = (select top 1 * from (select IdRespuesta from PARCIAL.Respuestas where Pregunta = @Pregunta and esCorrecta = @Ganador)as Id Order BY NEWID())
	begin
		insert into PARCIAL.Logs
		(Pregunta, Respuesta, Jugador, Competicion, FechaHora)
		values
		(@Pregunta, @Respuesta, @Jugador, @Competicion, @FechaHota)
	end
	
GO

 

  
 CREATE PROCEDURE PARCIAL.cargar_preguntas
	@Detalle nvarchar(55),
	@Categoria numeric (18,0),
	@Nivel numeric(18,0),
	@FechaInicio date
		
AS
BEGIN
	INSERT INTO PARCIAL.Preguntas
		(Detalle,Categoria,Nivel,FechaInicio,FechaFin)
	VALUES
		(@Detalle, @Categoria, @Nivel, @FechaInicio, NULL)
END
GO

CREATE PROCEDURE PARCIAL.recalcular_porcentajes
  @idPregunta numeric(18,0)
AS
BEGIN
  declare @idRespuestaA numeric(18,0), @idRespuestaB numeric(18,0), @idRespuestaC numeric(18,0), @idRespuestaD numeric(18,0),
    @countA int, @countB int, @countC int, @countD int, @countTotal int;
  select @idRespuestaA = idRespuesta from PARCIAL.respuestas where pregunta = @idPregunta and letra = 'A';
  select @idRespuestaB = idRespuesta from PARCIAL.respuestas where pregunta = @idPregunta and letra = 'B';
  select @idRespuestaC = idRespuesta from PARCIAL.respuestas where pregunta = @idPregunta and letra = 'C';
  select @idRespuestaD = idRespuesta from PARCIAL.respuestas where pregunta = @idPregunta and letra = 'D';
  select @countA = count(*) from PARCIAL.logs where pregunta = @idPregunta and respuesta = @idRespuestaA;
  select @countB = count(*) from PARCIAL.logs where pregunta = @idPregunta and respuesta = @idRespuestaB;
  select @countC = count(*) from PARCIAL.logs where pregunta = @idPregunta and respuesta = @idRespuestaC;
  select @countD = count(*) from PARCIAL.logs where pregunta = @idPregunta and respuesta = @idRespuestaD;
  set @countTotal = @countA + @countB + @countC + @countD;
  update PARCIAL.respuestas set porcentaje = round((cast(@countA as float)/ cast(@countTotal as float) * cast(100 as float)), 0) where idRespuesta = @idRespuestaA;
  update PARCIAL.respuestas set porcentaje = round((cast(@countB as float) / cast(@countTotal as float) * cast(100 as float)), 0) where idRespuesta = @idRespuestaB;
  update PARCIAL.respuestas set porcentaje = round((cast(@countC as float) / cast(@countTotal as float) * cast(100 as float)), 0) where idRespuesta = @idRespuestaC;
  update PARCIAL.respuestas set porcentaje = round((cast(@countD as float) / cast(@countTotal as float) * cast(100 as float)), 0) where idRespuesta = @idRespuestaD;
END
go

-- triggers


CREATE TRIGGER actualizarPartidasGanadas
ON PARCIAL.Competiciones
AFTER INSERT
AS
Declare @IdGanador numeric(18,0)
Declare @NumeroGanador numeric(18,0)
Declare @CantidadJugadores numeric(18,0)

Set @CantidadJugadores = 0
IF (select Jugador1 from inserted) IS NOT NULL
	Set @CantidadJugadores = @CantidadJugadores +1
IF (select Jugador2 from inserted) IS NOT NULL
	Set @CantidadJugadores = @CantidadJugadores +1
IF (select Jugador3 from inserted) IS NOT NULL
	Set @CantidadJugadores = @CantidadJugadores +1
IF (select Jugador4 from inserted) IS NOT NULL
	Set @CantidadJugadores = @CantidadJugadores +1
IF (select Jugador5 from inserted) IS NOT NULL
	Set @CantidadJugadores = @CantidadJugadores +1	

Set @NumeroGanador = (select Ganador from inserted)
Set @IdGanador = CASE @NumeroGanador
			WHEN 1 THEN (select Jugador1 from inserted)
			WHEN 2 THEN (select Jugador2 from inserted)
			WHEN 3 THEN (select Jugador3 from inserted)
			WHEN 4 THEN (select Jugador4 from inserted)
			WHEN 5 THEN (select Jugador5 from inserted)
			END
IF @CantidadJugadores > 1
	BEGIN			
		
		UPDATE Parcial.Jugadores
		SET TotalGanados = TotalGanados+1
		WHERE IdJugador = @IdGanador
		
	END


GO

CREATE TRIGGER actualizarPartidasJugadas
ON PARCIAL.Competiciones
AFTER INSERT
AS

Declare @IdJugador1 numeric(18,0)
Declare @IdJugador2 numeric(18,0)
Declare @IdJugador3 numeric(18,0)
Declare @IdJugador4 numeric(18,0)
Declare @IdJugador5 numeric(18,0)


Set  @IdJugador1 = (select Jugador1 from inserted)
Set  @IdJugador2 = (select Jugador2 from inserted)
Set  @IdJugador3 = (select Jugador3 from inserted)
Set  @IdJugador4 = (select Jugador4 from inserted)
Set  @IdJugador5 = (select Jugador5 from inserted)

IF @IdJugador1 IS NOT Null
	BEGIN
		UPDATE Parcial.Jugadores
		SET TotalJugados = TotalJugados+1
		WHERE IdJugador = @IdJugador1
	END
IF @IdJugador2 IS NOT Null
	BEGIN
		UPDATE Parcial.Jugadores
		SET TotalJugados = TotalJugados+1
		WHERE IdJugador = @IdJugador2
	END
	
IF @IdJugador3 IS NOT Null
	BEGIN
		UPDATE Parcial.Jugadores
		SET TotalJugados = TotalJugados+1
		WHERE IdJugador = @IdJugador3
	END
IF @IdJugador4 IS NOT Null
	BEGIN
		UPDATE Parcial.Jugadores
		SET TotalJugados = TotalJugados+1
		WHERE IdJugador = @IdJugador4
	END
IF @IdJugador5 IS NOT Null
	BEGIN
		UPDATE Parcial.Jugadores
		SET TotalJugados = TotalJugados+1
		WHERE IdJugador = @IdJugador5
	END

GO

CREATE TRIGGER actualizarPorcentajes
  on PARCIAL.logs
  AFTER INSERT
AS
BEGIN
  declare @idPregunta numeric(18,0), @idRespuesta numeric(18,0);
  -- busco todas respuestas para pregunta del inserted y recalculo porcentajes
  select @idPregunta = pregunta from inserted;
  exec PARCIAL.recalcular_porcentajes @idPregunta
END
go

--CARGA DE DATOS

-- TABLA DE PAISES
 exec PARCIAL.cargar_pais 'Argentina'	--1
 exec PARCIAL.cargar_pais 'Brasil'		--2
 exec PARCIAL.cargar_pais 'Alemania'	--3
 exec PARCIAL.cargar_pais 'Chile'		--4
 
 
 --TABLA DE JUGADORES
 -- nombre / pais / nick / fecha alta
 exec PARCIAL.cargar_jugador 'Mariano', 4, 'Fasrumaar', '02-02-1994'
 exec PARCIAL.cargar_jugador 'Pablo', 4, 'Valrock','15-06-2000'
 exec PARCIAL.cargar_jugador 'Osvaldo', 2, 'Oss','07-08-2013'
 exec PARCIAL.cargar_jugador 'Roman', 4, 'PepitoVeraz', '22-04-1999'
 exec PARCIAL.cargar_jugador 'Maggie', 1, 'Raenys', '07-11-2012'
 exec PARCIAL.cargar_jugador 'Erwin', 3, 'Charlyzzz', '14-02-1990'
 exec PARCIAL.cargar_jugador 'Diego', 1, 'Baxter', '26-03-1925'
 
 
 -- TABLA DE CATEGORIAS
 
 exec PARCIAL.cargar_categorias 'Cultura General'
 exec PARCIAL.cargar_categorias 'Hardware'
 exec PARCIAL.cargar_categorias 'Historia'
 exec PARCIAL.cargar_categorias 'Arte'
 exec PARCIAL.cargar_categorias 'Geografia'
 
 --TABLA DE NIVELES
 
 exec PARCIAL.cargar_niveles '1'
 exec PARCIAL.cargar_niveles '2'
 exec PARCIAL.cargar_niveles '3'
 exec PARCIAL.cargar_niveles '4'
 exec PARCIAL.cargar_niveles '5'
 
 --TABLA DE PREGUNTAS
 -- pregunta / categoria / nivel / fecha inicio
exec PARCIAL.cargar_preguntas 'Marca del mejor Fernet1?',1,1,'23-02-2014'
exec PARCIAL.cargar_preguntas 'Marca del mejor Fernet2?',1,2,'13-06-2014'
exec PARCIAL.cargar_preguntas 'Marca del mejor Fernet3?',1,3,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Marca del mejor Fernet4?',1,4,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Marca del mejor Fernet5?',1,5,'30-05-2014'

exec PARCIAL.cargar_preguntas 'Cual es de las siguientes es ensambladora de NVIDIA1?',2,1,'23-02-2014' -- 6
exec PARCIAL.cargar_preguntas 'Cual es de las siguientes es ensambladora de NVIDIA2?',2,2,null
exec PARCIAL.cargar_preguntas 'Cual es de las siguientes es ensambladora de NVIDIA3?',2,3,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Cual es de las siguientes es ensambladora de NVIDIA4?',2,4,null
exec PARCIAL.cargar_preguntas 'Cual es de las siguientes es ensambladora de NVIDIA5?',2,5,'30-05-2014'
 
exec PARCIAL.cargar_preguntas 'Nombre de la campa�a contra los indios1',3,1,'23-02-2014'
exec PARCIAL.cargar_preguntas 'Nombre de la campa�a contra los indios2',3,2,'13-06-2014'
exec PARCIAL.cargar_preguntas 'Nombre de la campa�a contra los indios3',3,3,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Nombre de la campa�a contra los indios4',3,4,null
exec PARCIAL.cargar_preguntas 'Nombre de la campa�a contra los indios5',3,5,'30-05-2014'

exec PARCIAL.cargar_preguntas 'Que tiene el David en la mano1?',4,1,'23-02-2014' -- 16
exec PARCIAL.cargar_preguntas 'Que tiene el David en la mano2?',4,2,'13-06-2014'
exec PARCIAL.cargar_preguntas 'Que tiene el David en la mano3?',4,3,null
exec PARCIAL.cargar_preguntas 'Que tiene el David en la mano4?',4,4,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Que tiene el David en la mano5?',4,5,'30-05-2014'
 
exec PARCIAL.cargar_preguntas 'Cual es la capital de Argentina1?',5,1,'23-02-2014'
exec PARCIAL.cargar_preguntas 'Cual es la capital de Argentina2?',5,2,'13-06-2014'
exec PARCIAL.cargar_preguntas 'Cual es la capital de Argentina3?',5,3,'08-09-2014'
exec PARCIAL.cargar_preguntas 'Cual es la capital de Argentina4?',5,4,null
exec PARCIAL.cargar_preguntas 'Cual es la capital de Argentina5?',5,5,'30-05-2014' -- 25

go
Update PARCIAL.Preguntas
SET FechaFin = (convert(date,'31-05-2014',103))
where IdPregunta = 25
go

go
Update PARCIAL.Preguntas
SET FechaFin = (convert(date,'23-03-2014',103))
where IdPregunta = 6
go

go
Update PARCIAL.Preguntas
SET FechaFin = (convert(date,'15-06-2014',103))
where IdPregunta = 16
go

 
 --TABLA DE RESPUESTAS
 ----------Respuestas Categoria 1
  
 -- pregunta / letra / detalle / es correcta
 exec PARCIAL.cargar_respuestas 1, 'A', 'Branca', 'S'
 exec PARCIAL.cargar_respuestas 1, 'B', 'Vittone', 'N'
 exec PARCIAL.cargar_respuestas 1, 'C', 'Random', 'N'
 exec PARCIAL.cargar_respuestas 1, 'D', 'Random2', 'N'
 
 
 exec PARCIAL.cargar_respuestas 2, 'D', 'Branca', 'S'
 exec PARCIAL.cargar_respuestas 2, 'A', 'Vittone', 'N'
 exec PARCIAL.cargar_respuestas 2, 'B', 'Random', 'N'
 exec PARCIAL.cargar_respuestas 2, 'C', 'Random2', 'N'

 
 exec PARCIAL.cargar_respuestas 3, 'C', 'Branca', 'S'
 exec PARCIAL.cargar_respuestas 3, 'D', 'Vittone', 'N'
 exec PARCIAL.cargar_respuestas 3, 'A', 'Random', 'N'
 exec PARCIAL.cargar_respuestas 3, 'B', 'Random2', 'N'
 
 
 exec PARCIAL.cargar_respuestas 4, 'B', 'Branca', 'S'
 exec PARCIAL.cargar_respuestas 4, 'C', 'Vittone', 'N'
 exec PARCIAL.cargar_respuestas 4, 'D', 'Random', 'N'
 exec PARCIAL.cargar_respuestas 4, 'A', 'Random2', 'N'
 
 
 exec PARCIAL.cargar_respuestas 5, 'A', 'Branca', 'S'
 exec PARCIAL.cargar_respuestas 5, 'B', 'Vittone', 'N'
 exec PARCIAL.cargar_respuestas 5, 'C', 'Random', 'N'
 exec PARCIAL.cargar_respuestas 5, 'D', 'Random2', 'N'
 
----------Respuestas Categoria 2

 exec PARCIAL.cargar_respuestas 6, 'A', 'MSI', 'S'
 exec PARCIAL.cargar_respuestas 6, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 6, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 6, 'D', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 7, 'D', 'MSI', 'S'
 exec PARCIAL.cargar_respuestas 7, 'A', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 7, 'B', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 7, 'C', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 8, 'C', 'MSI', 'S'
 exec PARCIAL.cargar_respuestas 8, 'D', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 8, 'A', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 8, 'B', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 9, 'B', 'MSI', 'S'
 exec PARCIAL.cargar_respuestas 9, 'C', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 9, 'D', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 9, 'A', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 10, 'A', 'MSI', 'S'
 exec PARCIAL.cargar_respuestas 10, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 10, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 10, 'D', 'Random3', 'N' 
 
 ----------Respuestas Categoria 3

 exec PARCIAL.cargar_respuestas 11, 'A', 'Campa�a del Desierto', 'S'
 exec PARCIAL.cargar_respuestas 11, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 11, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 11, 'D', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 12, 'D', 'Campa�a del Desierto', 'S'
 exec PARCIAL.cargar_respuestas 12, 'A', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 12, 'B', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 12, 'C', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 13, 'C', 'Campa�a del Desierto', 'S'
 exec PARCIAL.cargar_respuestas 13, 'D', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 13, 'A', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 13, 'B', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 14, 'B', 'Campa�a del Desierto', 'S'
 exec PARCIAL.cargar_respuestas 14, 'C', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 14, 'D', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 14, 'A', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 15, 'A', 'Campa�a del Desierto', 'S'
 exec PARCIAL.cargar_respuestas 15, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 15, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 15, 'D', 'Random3', 'N' 
 
  ----------Respuestas Categoria 4

 exec PARCIAL.cargar_respuestas 16, 'A', 'Una gomera', 'S'
 exec PARCIAL.cargar_respuestas 16, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 16, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 16, 'D', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 17, 'D', 'Una gomera', 'S'
 exec PARCIAL.cargar_respuestas 17, 'A', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 17, 'B', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 17, 'C', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 18, 'C', 'Una gomera', 'S'
 exec PARCIAL.cargar_respuestas 18, 'D', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 18, 'A', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 18, 'B', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 19, 'B', 'Una gomera', 'S'
 exec PARCIAL.cargar_respuestas 19, 'C', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 19, 'D', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 19, 'A', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 20, 'A', 'Una gomera', 'S'
 exec PARCIAL.cargar_respuestas 20, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 20, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 20, 'D', 'Random3', 'N'


  ----------Respuestas Categoria 5

 exec PARCIAL.cargar_respuestas 21, 'A', 'Buenos Aires', 'S'
 exec PARCIAL.cargar_respuestas 21, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 21, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 21, 'D', 'Random3', 'N' 
  
 exec PARCIAL.cargar_respuestas 22, 'D', 'Buenos Aires', 'S'
 exec PARCIAL.cargar_respuestas 22, 'A', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 22, 'B', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 22, 'C', 'Random3', 'N' 
  
 exec PARCIAL.cargar_respuestas 23, 'C', 'Buenos Aires', 'S'
 exec PARCIAL.cargar_respuestas 23, 'D', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 23, 'A', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 23, 'B', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 24, 'B', 'Buenos Aires', 'S'
 exec PARCIAL.cargar_respuestas 24, 'C', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 24, 'D', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 24, 'A', 'Random3', 'N' 
 
 exec PARCIAL.cargar_respuestas 25, 'A', 'Buenos Aires', 'S'
 exec PARCIAL.cargar_respuestas 25, 'B', 'Random1', 'N'
 exec PARCIAL.cargar_respuestas 25, 'C', 'Random2', 'N'
 exec PARCIAL.cargar_respuestas 25, 'D', 'Random3', 'N' 
 

--tabla relacion pais pregunta
--Argentina
-- id pais / id pregunta
exec PARCIAL.cargar_relpaispreg  1,1
exec PARCIAL.cargar_relpaispreg  1,6
exec PARCIAL.cargar_relpaispreg  1,11
exec PARCIAL.cargar_relpaispreg  1,16
exec PARCIAL.cargar_relpaispreg  1,21

--Brasil
exec PARCIAL.cargar_relpaispreg  2,2
exec PARCIAL.cargar_relpaispreg  2,7
exec PARCIAL.cargar_relpaispreg  2,12
exec PARCIAL.cargar_relpaispreg  2,17
exec PARCIAL.cargar_relpaispreg  2,22

--Alemania
exec PARCIAL.cargar_relpaispreg  3,3
exec PARCIAL.cargar_relpaispreg  3,8
exec PARCIAL.cargar_relpaispreg  3,13
exec PARCIAL.cargar_relpaispreg  3,18
exec PARCIAL.cargar_relpaispreg  3,23

--Chile
exec PARCIAL.cargar_relpaispreg  4,4
exec PARCIAL.cargar_relpaispreg  4,9
exec PARCIAL.cargar_relpaispreg  4,14
exec PARCIAL.cargar_relpaispreg  4,19
exec PARCIAL.cargar_relpaispreg  4,24
--Las preguntas nivel 5 son para cualquier pa�s (pregunta 5,10,15,20,25)


-- Competiciones
-- jugador 1 / jugador 2 / jugador 3 / jugador 4 / juador 5 / ganador
exec PARCIAL.cargar_competiciones 1,2,Null,Null,Null,1	
exec PARCIAL.cargar_competiciones 1,4,5,Null,Null,3		
exec PARCIAL.cargar_competiciones 2,3,6,Null,Null,2		
exec PARCIAL.cargar_competiciones 3,4,5,6,7,4			
exec PARCIAL.cargar_competiciones 2,4,5,6,Null,3				
exec PARCIAL.cargar_competiciones 5,Null,Null,Null,Null,1		
exec PARCIAL.cargar_competiciones 1,2,5,6,7,5
exec PARCIAL.cargar_competiciones 2,3,4,Null,Null,2			
exec PARCIAL.cargar_competiciones 3,4,Null,Null,Null,1			
exec PARCIAL.cargar_competiciones 4,5,Null,Null,Null,2		
exec PARCIAL.cargar_competiciones 5,6,Null,Null,Null,2
exec PARCIAL.cargar_competiciones 5,Null,Null,Null,Null,1		--
exec PARCIAL.cargar_competiciones 1,2,3,4,6,3	
exec PARCIAL.cargar_competiciones 2,3,4,5,6,2


-- cargar logs
--Competicion 1 Mariano Pablo
-- jugador / competicion / fecha hora / ganador
exec PARCIAL.cargar_logs 1,1,'20-05-2015','S'
exec PARCIAL.cargar_logs 2,1,'21-05-2015','N'

--Competicion 2 Mariano Roman Maggie
exec PARCIAL.cargar_logs 1,2,'17-03-2015','N'
exec PARCIAL.cargar_logs 4,2,'18-03-2015','N'
exec PARCIAL.cargar_logs 5,2,'19-03-2015','S'

--Competicion 3 Pablo Osvaldo Erwin
exec PARCIAL.cargar_logs 2,3,'19-04-2015','N'
exec PARCIAL.cargar_logs 3,3,'19-04-2015','S'
exec PARCIAL.cargar_logs 6,3,'18-04-2015','N'

--Competicion 4 Osvaldo Roman Maggie Erwin Diego
exec PARCIAL.cargar_logs 3,4,'02-01-2015','N'
exec PARCIAL.cargar_logs 4,4,'02-01-2015','N'
exec PARCIAL.cargar_logs 5,4,'02-01-2015','N'
exec PARCIAL.cargar_logs 6,4,'02-01-2015','S'
exec PARCIAL.cargar_logs 7,4,'02-01-2015','N'

--Competicion 5 Pablo Roman Maggie Erwin
exec PARCIAL.cargar_logs 2,5,'19-03-2015','N'
exec PARCIAL.cargar_logs 4,5,'19-03-2015','N'
exec PARCIAL.cargar_logs 5,5,'19-03-2015','S'
exec PARCIAL.cargar_logs 6,5,'19-03-2015','N'

--Competicion 6
exec PARCIAL.cargar_logs 5,6,'19-03-2015','S'

--Competicion 7
exec PARCIAL.cargar_logs 1,7,'03-05-2015','N'
exec PARCIAL.cargar_logs 2,7,'03-05-2015','N'
exec PARCIAL.cargar_logs 5,7,'02-05-2015','N'
exec PARCIAL.cargar_logs 6,7,'05-05-2015','N'
exec PARCIAL.cargar_logs 7,7,'03-05-2015','S'

--Competicion 8
exec PARCIAL.cargar_logs 2,8,'15-02-2015','N'
exec PARCIAL.cargar_logs 3,8,'14-02-2015','S'
exec PARCIAL.cargar_logs 4,8,'14-02-2015','N'

--Competicion 9
exec PARCIAL.cargar_logs 3,9,'19-06-2015','S'
exec PARCIAL.cargar_logs 4,9,'21-06-2015','N'

--Competicion 10
exec PARCIAL.cargar_logs 4,10,'19-01-2015','N'
exec PARCIAL.cargar_logs 5,10,'19-01-2015','S'

--Competicion 11
exec PARCIAL.cargar_logs 5,11,'17-02-2015','N'
exec PARCIAL.cargar_logs 6,11,'17-02-2015','S'

--Competicion 12
exec PARCIAL.cargar_logs 5,12,'19-06-2015','S'

--Competicion 13
exec PARCIAL.cargar_logs 1,13,'19-06-2015','N'
exec PARCIAL.cargar_logs 2,13,'19-06-2015','N'
exec PARCIAL.cargar_logs 3,13,'19-06-2015','S'
exec PARCIAL.cargar_logs 4,13,'22-06-2015','N'
exec PARCIAL.cargar_logs 6,13,'19-06-2015','N'

--Competicion 14
exec PARCIAL.cargar_logs 2,14,'22-05-2015','N'
exec PARCIAL.cargar_logs 3,14,'17-05-2015','S'
exec PARCIAL.cargar_logs 4,14,'12-05-2015','N'
exec PARCIAL.cargar_logs 5,14,'19-05-2015','N'
exec PARCIAL.cargar_logs 6,14,'23-05-2015','N'


 