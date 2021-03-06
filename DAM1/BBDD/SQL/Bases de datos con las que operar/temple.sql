USE [master]
GO
/****** Object:  Database [temple]    Script Date: 05/06/2018 19:36:51 ******/
CREATE DATABASE [temple]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'temple', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\temple.mdf' , SIZE = 3328KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'temple_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\temple_log.LDF' , SIZE = 3520KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [temple] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [temple].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [temple] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [temple] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [temple] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [temple] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [temple] SET ARITHABORT OFF 
GO
ALTER DATABASE [temple] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [temple] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [temple] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [temple] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [temple] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [temple] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [temple] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [temple] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [temple] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [temple] SET  DISABLE_BROKER 
GO
ALTER DATABASE [temple] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [temple] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [temple] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [temple] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [temple] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [temple] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [temple] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [temple] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [temple] SET  MULTI_USER 
GO
ALTER DATABASE [temple] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [temple] SET DB_CHAINING OFF 
GO
ALTER DATABASE [temple] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [temple] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [temple] SET DELAYED_DURABILITY = DISABLED 
GO
USE [temple]
GO
/****** Object:  User [laly_casillas\laly]    Script Date: 05/06/2018 19:36:51 ******/
CREATE USER [laly_casillas\laly] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [265]    Script Date: 05/06/2018 19:36:51 ******/
CREATE USER [265] FOR LOGIN [265] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [261]    Script Date: 05/06/2018 19:36:51 ******/
CREATE USER [261] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [260]    Script Date: 05/06/2018 19:36:51 ******/
CREATE USER [260] FOR LOGIN [260] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [111]    Script Date: 05/06/2018 19:36:51 ******/
CREATE USER [111] FOR LOGIN [111] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [laly_casillas\laly]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [laly_casillas\laly]
GO
ALTER ROLE [db_datareader] ADD MEMBER [261]
GO
/****** Object:  UserDefinedFunction [dbo].[empleado_dept]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[empleado_dept] (@departamento int) returns numeric (6,2) as
begin
declare @resul numeric(6,2)
if exists (select nombre
           from temple
           where NUMDE=@departamento)
 set @resul=(select MAX(salario)
             from temple
             where NUMDE=@departamento)
 else
 begin 
 --set @resul=CAST(@resul as int)--no hace falta
 set @resul=-1
 --returs @resul -- es return solamente devuelve valor en caso de error 
 end --te faltaba este end, tienes que cerrar 2
 return @resul --el return tiene que ser la última instruccion de la funcion
 end 
 -- se prodria haber evitado en begin...end poniendo solamente return -1, sin asignar a la variable
 
 
GO
/****** Object:  UserDefinedFunction [dbo].[fn_edad_empleado]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_edad_empleado](@numemp char(3))
	returns int
as
	begin
		declare @retorno int
		if(@numemp not in (select NUMEM
							from vejercicio1))
			set @retorno = 0
		else
			set @retorno = 1
		return @retorno
	end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ejercicio1]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_ejercicio1](@numemp char(3))
	returns varchar(150)
as
	begin
		declare @retorno varchar(150)

		if(dbo.fn_validar_empleado(@numemp) = 0)
			set @retorno = 'No existe el empleado ' + @numemp
		else if(dbo.fn_edad_empleado(@numemp) = 0)
			set @retorno = 'El empleado ' + @numemp + ' no es mayor de 65 años'
		else if(dbo.fn_fecha_valida(getdate()) = 0)
			set @retorno = 'La fecha actual no está entre 1/12/' + cast(year(getdate()) as varchar(4)) + ' y 21/12/' + cast(year(getdate()) as varchar(4))
		else
			set @retorno = (select nombre
							from vejercicio1
							where NUMEM = @numemp) + ' del departamento ' + (select dnombre
																				from vejercicio1
																				where NUMEM = @numemp) + ' está invitado, a una fiesta, el ' + (select fecha
																																				from vejercicio1
																																				where NUMEM = @numemp) + ' y recibirá un regalo de y ' + (select invitaciones
																																																		from vejercicio1
																																																		where NUMEM = @numemp) + ' invitaciones'
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_fecha_valida]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_fecha_valida](@fecha date)
	returns int
as
	begin
		declare @retorno int
		if (@fecha between cast('1/12/' + cast(year(getdate()) as varchar(4)) as date) and cast('21/12/' + cast(year(getdate()) as varchar(4)) as date))
			set @retorno = 1
		else
			set @retorno = 0
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_validar_empleado]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_validar_empleado](@numemp char(3))
	returns int
as
	begin
		declare @retorno int

		if(@numemp not in (select NUMEM
							from TEMPLE
							where NUMEM = @numemp))
			set @retorno = 0
		else
			set @retorno = 1
		return @retorno
	end

GO
/****** Object:  UserDefinedFunction [dbo].[juan]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[juan] (@apellidoEmpleado varchar(40)) --cambio el nombre pora  borrar después
returns varchar(40)

begin
declare @jefe varchar(40)
select @jefe=nombre
from temple
where NOMBRE=@apellidoEmpleado --CON esto lo único que haces es comprobar si el empleado existe

if @apellidoEmpleado is null set @jefe='no existe el empleado'
if @apellidoEmpleado is null set @jefe='no tiene jefe'
--este if, machaca el valor del otro, si el empleado no existe te dirá que no tiene jefe

return @jefe -- comento esto para que devuelva algo@jefe
end


--select dbo.juan('fierro, claudi0')


--asignas el valor de salida al parámetro de entrada, y por tanto la funcion este valor no lo modifica.
--por otra parte para sacar el jefe, que es lo que se pide, tendrías que haber ido a la tabla tdepto.
GO
/****** Object:  UserDefinedFunction [dbo].[maximo]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [dbo].[maximo](@departamento varchar(15))returns float as
begin
declare @retorno float
if exists(select * from tdepto where dnombre=@departamento)
   set @retorno=(select  isnull(MAX(salario),0) 
                 from temple 
                 where NUMDE in (select numde 
                                 from tdepto
                                 where dnombre=@departamento))
   else set @retorno=-1
return @retorno
end

--select top 1 dbo.maximo('personal') from temple

GO
/****** Object:  Table [dbo].[TCENTRO]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TCENTRO](
	[NUMCE] [numeric](2, 0) NOT NULL,
	[NOMBREC] [varchar](20) NOT NULL,
	[SEÑAS] [varchar](20) NULL,
 CONSTRAINT [pk_numce] PRIMARY KEY CLUSTERED 
(
	[NUMCE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TDEPTO]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TDEPTO](
	[NUMDE] [numeric](3, 0) NOT NULL,
	[NUMCE] [numeric](2, 0) NOT NULL,
	[DIREC] [char](3) NULL,
	[TDIR] [char](1) NULL,
	[PRESU] [numeric](9, 2) NULL,
	[DEPDE] [numeric](3, 0) NULL,
	[DNOMBRE] [varchar](20) NULL,
 CONSTRAINT [pk_numde] PRIMARY KEY CLUSTERED 
(
	[NUMDE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TEMPLE]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TEMPLE](
	[NUMEM] [char](3) NOT NULL,
	[NUMDE] [numeric](3, 0) NOT NULL,
	[EXTEL] [numeric](3, 0) NULL,
	[FECHA_NAC] [smalldatetime] NULL,
	[FECHA_ALT] [smalldatetime] NULL DEFAULT (CONVERT([smalldatetime],(((datename(day,getdate())+'/')+datename(month,getdate()))+'/')+datename(year,getdate()),0)),
	[SALARIO] [numeric](6, 2) NULL,
	[COMISION] [numeric](6, 2) NULL,
	[NUMHI] [numeric](2, 0) NOT NULL,
	[NOMBRE] [varchar](20) NULL,
 CONSTRAINT [pk_numem] PRIMARY KEY CLUSTERED 
(
	[NUMEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[maxsala]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[maxsala](@nomdep varchar(10)) returns table
as
return (select max(salario) as [maximo salario]
        from temple t, TDEPTO d 
        where d.dnombre=@nomdep and t.NUMDE=d.NUMDE)

GO
/****** Object:  View [dbo].[mas_personal]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[mas_personal] as
select dnombre, isnull(count(*),0) n_empleados
from temple e right join TDEPTO d on e.numde=d.numde
group by dnombre

/*create view max_personal
as select dnombre, (select ISNULL(count(*),0) from temple e  where e.NUMDE=t.numde) n_empleados
from TDEPTO t*/


GO
/****** Object:  View [dbo].[mas_pesonal]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[mas_pesonal] as
select dnombre, isnull(count(*),0) n_empleados
from temple e right join TDEPTO d on e.numde=d.numde
group by dnombre
GO
/****** Object:  View [dbo].[max_personal]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*create view mas_personal as
select dnombre, isnull(count(*),0) n_empleados
from temple e right join TDEPTO d on e.numde=d.numde
group by dnombre*/

create view [dbo].[max_personal]
as select dnombre, (select ISNULL(count(*),0) from temple e  where e.NUMDE=t.numde) n_empleados
from TDEPTO t




/*select dnombre
from mas_personal
where n_empleados=(select MAX(n_empleados)
                   from mas_personal)*/
GO
/****** Object:  View [dbo].[numero_empleados]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[numero_empleados] as
select dnombre,(select COUNT(numem) from temple where d.numde=NUMDE) empleados
from tdepto d
GO
/****** Object:  View [dbo].[v10]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v10] as
select convert(char(10), dateadd(dd, 180, dateadd(yy, (cast(convert(char(10), getdate(),112) as int) - (convert(char(10), fecha_alt,112))) / 10000, fecha_alt)),103) vencimiento, nombre
from temple t
where nombre = 'muñoz, azucena' and (user = cast(numem as char(3)) or user = (select cast(direc as char(3))
																				from tdepto
																				where t.numde = numde) or user in (select cast(numem as char(3))
																													from temple
																													where numde in (select numde
																																	from tdepto
																																	where dnombre='personal')))
GO
/****** Object:  View [dbo].[v11]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v11] as
select numde, avg(year(getdate()) - year(fecha_alt)) media
from temple t
where fecha_alt < '31/12/' + cast(year(getdate()) - 1 as char(4)) and numde in (110,111)
group by numde
having (user in (select cast(direc as char(3))
				from tdepto
				where depde is null or t.numde=numde))
GO
/****** Object:  View [dbo].[v12]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v12] as
select dnombre, count(numem) num_empl, sum(salario) salario, sum(comision) comisiones, sum(numhi) hijos
from temple te right join tdepto td on te.numde=td.numde
where tdir='f'
group by dnombre
having user = (select cast(direc as char(10))
				from tdepto
				where depde is null)
GO
/****** Object:  View [dbo].[v13]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v13] as
select *
from temple t
where year(fecha_alt) >= 1988 and (user in (select cast(direc as char(3))
											from tdepto
											where depde is null or numde = t.numde))
GO
/****** Object:  View [dbo].[v17]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v17] as
select NUMHI, cast(round(sum(salario)/sum(numhi),2) as numeric(7,2)) MediaS, cast(round(sum(SALARIO + isnull(COMISION,0))/sum(numhi),2) as numeric(7,2)) Mediasalarialcomi
from temple t
where numhi > 0 and user in (select cast(direc as char(3))
				from tdepto
				where depde is null or numde = t.numde)
group by numhi
GO
/****** Object:  View [dbo].[v3]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v3] as
select *
from temple
where year(getdate()) - year(fecha_nac) = 65
and (user in (select cast(direc as char(3))
				from tdepto
				where dnombre = 'personal'))
GO
/****** Object:  View [dbo].[v4]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v4] as
select *
from temple
where year(getdate()) - year(fecha_nac)=65
and (user = (select cast(numem as char(3))
				from temple
				where numde in (select numde
								from tdepto
								where dnombre='personal')) or user ='dbo')
GO
/****** Object:  View [dbo].[v5]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v5] as
select *
from temple e
where user in (select cast(direc as char(3))
				from tdepto
				where numde = e.numde)
GO
/****** Object:  View [dbo].[v6]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE view [dbo].[v6] as
 select 'DEPARTAMENTO DE ' + dnombre departamento
 from tdepto
 where presu > 30000 and user in (select cast(direc as char(3))
									from tdepto
									where depde is null)
GO
/****** Object:  View [dbo].[v7]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v7] as
select numem, nombre, salario+isnull(comision,0) salario
from temple e
where salario > (select min(salario)+1800
					from temple)
 and user = (select cast(direc as char(3))
				from tdepto
				where numde = e.numde)
GO
/****** Object:  View [dbo].[v8]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v8] as
 select nombre, (cast (convert(char(10), getdate(),112) as int) - convert(char(10), fecha_nac, 112)) / 10000 edad_entrada
 from temple
 where numde in (111,112) and user in (select cast(numem as char(3))
										from temple
										where numde in (111,112))
GO
/****** Object:  View [dbo].[v9]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v9] as
select nombre, convert(char(10),
getdate() + 2, 103) boda, convert(char(10),getdate() + 22,103) vuelta,
cast(((cast(convert(char(10), getdate(),112) as int) - (convert(char(10), fecha_alt, 112))) / 10000) * salario * 0.01 as numeric(5,2)) regalo
from temple e
where nombre in ('fierro, claudia', 'torres, horacio')
and (user in (select cast(numem as char(3))
				from temple
				where nombre in ('fierro, claudia', 'torres, horacio')
				or user in (select cast(direc as char(3))
							from tdepto
							where depde is null or numde=e.numde)))
GO
/****** Object:  View [dbo].[vejercicio1]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vejercicio1] as
	select numem, nombre, DNOMBRE, '2' "invitaciones", year(getdate()) - year(fecha_nac) "edad", cast(datename(dw, '22/12/' + cast(year(getdate()) as varchar(4))) as nvarchar(10)) + ' 22/12/' + cast(year(getdate()) as varchar(4)) "fecha"
	from temple t inner join tdepto td on t.NUMDE = td.NUMDE
	where year(getdate()) - year(fecha_nac) > 65

GO
/****** Object:  View [dbo].[vista3]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vista3] as
select nombre,numhi+2 invitaciones, numhi regalos, 
datename(dw,'5/1/'+DATENAME(yy,getdate()))+' '+'5/1/'+DATENAME(yy,getdate()) fecha
from temple t
where NOMBRE between 'a' and 'm' and numhi!=0  and (USER=cast(numem as char(3)))
union

select nombre,numhi+2 invitaciones, numhi regalos, datename(dw,'6/1/'+DATENAME(yy,getdate()))+' '+'6/1/'+DATENAME(yy,getdate()) fecha
from temple t
where NOMBRE between 'm' and 'z' and numhi!=0 and NOMBRE like 'z%' and (USER=cast(numem as char(3)))

GO
/****** Object:  View [dbo].[vista4]    Script Date: 05/06/2018 19:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vista4] as
select nombre,numhi+2 invitaciones, numhi regalos, datename(dw,'5/1/'+DATENAME(yy,getdate()))+' '+'5/1/'+DATENAME(yy,getdate()) fecha
from temple t
where NOMBRE between 'a' and 'm' and (USER=cast(numem as char(3)))
union

select nombre,numhi+2 invitaciones, numhi regalos, datename(dw,'6/1/'+DATENAME(yy,getdate()))+' '+'6/1/'+DATENAME(yy,getdate()) fecha
from temple t
where NOMBRE between 'm' and 'z' or NOMBRE like 'z%' and (USER=cast(numem as char(3)))
GO
ALTER TABLE [dbo].[TDEPTO]  WITH CHECK ADD  CONSTRAINT [fk_depde] FOREIGN KEY([DEPDE])
REFERENCES [dbo].[TDEPTO] ([NUMDE])
GO
ALTER TABLE [dbo].[TDEPTO] CHECK CONSTRAINT [fk_depde]
GO
ALTER TABLE [dbo].[TDEPTO]  WITH CHECK ADD  CONSTRAINT [fk_direc] FOREIGN KEY([DIREC])
REFERENCES [dbo].[TEMPLE] ([NUMEM])
GO
ALTER TABLE [dbo].[TDEPTO] CHECK CONSTRAINT [fk_direc]
GO
ALTER TABLE [dbo].[TDEPTO]  WITH CHECK ADD  CONSTRAINT [fk_numce] FOREIGN KEY([NUMCE])
REFERENCES [dbo].[TCENTRO] ([NUMCE])
GO
ALTER TABLE [dbo].[TDEPTO] CHECK CONSTRAINT [fk_numce]
GO
ALTER TABLE [dbo].[TEMPLE]  WITH CHECK ADD  CONSTRAINT [fk_numde] FOREIGN KEY([NUMDE])
REFERENCES [dbo].[TDEPTO] ([NUMDE])
GO
ALTER TABLE [dbo].[TEMPLE] CHECK CONSTRAINT [fk_numde]
GO
ALTER TABLE [dbo].[TDEPTO]  WITH CHECK ADD  CONSTRAINT [ck1_tdir] CHECK  (([tdir]='p' OR [tdir]='f'))
GO
ALTER TABLE [dbo].[TDEPTO] CHECK CONSTRAINT [ck1_tdir]
GO
/****** Object:  StoredProcedure [dbo].[empleado_max_gana]    Script Date: 05/06/2018 19:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[empleado_max_gana](@departamento varchar(15)) as
declare @maximo float
set @maximo=dbo.maximo(@departamento)

if @maximo=-1 select 'el departamento no existe'
   else 
   begin
	    
        select nombre
        from temple right join TDEPTO on temple.NUMDE=tdepto.numde
        where SALARIO = @maximo or SALARIO is null and DNOMBRE=@departamento
        end
GO
/****** Object:  StoredProcedure [dbo].[empleado_maxdept]    Script Date: 05/06/2018 19:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[empleado_maxdept] (@departamento numeric(3)) as
if exists (select nombre
           from temple
           where SALARIO = (select MAX(salario)
                            from temple
                            where NUMDE=@departamento))
 select nombre
           from temple
           where SALARIO = (select MAX(salario)
                            from temple
                            where NUMDE=@departamento)
 
 else
 begin
 declare @mensaje char(5)
 set @mensaje='error'
 --return @mensaje NO HAY RETURN EN LOS PROCEDIMIENTOS
 Select @mensaje --esta es la forma de mostrar el error, se podría quitar la variable y mostrar el literal
 end
-- exec empleado_maxdept 100
 
GO
/****** Object:  StoredProcedure [dbo].[pa_ext_telef]    Script Date: 05/06/2018 19:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pa_ext_telef]
		@apellido varchar(20),
		@extel numeric(3,0) out,
		@dnombre varchar(20) out
   as
		if ((select nombre from temple where nombre like '%' + @apellido + '%') is null)
			begin
				print 'No existe ese apellido en la base de datos'
				return 1
			end
		else
			begin
				select @extel = t.EXTEL, @dnombre = d.DNOMBRE
				from temple t inner join tdepto d on t.NUMDE = d.NUMDE
				where t.NOMBRE like '%' + @apellido + '%'
			end
GO
/****** Object:  StoredProcedure [dbo].[pa_presupuesto_total]    Script Date: 05/06/2018 19:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pa_presupuesto_total]
		@codCentro numeric(2,0),
		@nomDept varchar(20) = '%'
   as
		select sum(PRESU) "PRESUPUESTO"
		from TDEPTO
		where tdir != 'F' and numce = @codCentro and dnombre like '%' + @nomDept + '%'

GO
/****** Object:  StoredProcedure [dbo].[pa_suma_salarios]    Script Date: 05/06/2018 19:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   CREATE proc [dbo].[pa_suma_salarios]
		@nomdept varchar(20),
		@sumSalario numeric(6,2) output
   as
		set @sumSalario = (select sum(SALARIO)
							from TEMPLE
							where NUMDE in (select NUMDE
											from TDEPTO
											where DNOMBRE like '%' + @nomdept + '%'))
		if(@sumSalario is null)
			print 'La suma de los salarios es nula'


GO
USE [master]
GO
ALTER DATABASE [temple] SET  READ_WRITE 
GO
