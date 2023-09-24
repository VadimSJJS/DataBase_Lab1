-- СОЗДАНИЕ БАЗЫ С ПРОВЕРКОЙ
-- База Pharmacy
USE master
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Pharmacy')
BEGIN
    CREATE DATABASE Pharmacy
END

GO
ALTER DATABASE Pharmacy SET RECOVERY SIMPLE
GO

USE [Pharmacy]

-- СОЗДАНИЕ ТАБЛИЦ С ПРОВЕРКОЙ
-- 1) Таблица Producers
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Producers')
BEGIN
	CREATE TABLE [dbo].[Producers](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](100) NOT NULL,
		[Country] [nvarchar](20) NOT NULL,
		CONSTRAINT [PK_Producers] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	    ) ON [PRIMARY]

	
END

-- 2) Таблица Diseases
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Diseases')
BEGIN
	CREATE TABLE [dbo].[Diseases](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[InternationalCode] [int] NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_Diseases] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Diseases]  WITH CHECK ADD  CONSTRAINT [CK_Diseases] CHECK  ((len(CONVERT([nvarchar](6),[InternationalCode]))=(6)))

	ALTER TABLE [dbo].[Diseases] CHECK CONSTRAINT [CK_Diseases]


END

-- 3) Таблица Medicines
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Medicines')
BEGIN
	CREATE TABLE [dbo].[Medicines](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
		[ShortDescription] [nvarchar](200) NOT NULL,
		[ActiveSubstance] [nvarchar](50) NOT NULL,
		[ProducerId] [int] NOT NULL,
		[UnitOfMeasurement] [nvarchar](50) NOT NULL,
		[Count] [int] NOT NULL,
		[StorageLocation] [nvarchar](50) NOT NULL,
	CONSTRAINT [PK_Medicines] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Medicines]  WITH CHECK ADD  CONSTRAINT [FK_Medicines_Producers] FOREIGN KEY([ProducerId])
	REFERENCES [dbo].[Producers] ([Id])

	ALTER TABLE [dbo].[Medicines] CHECK CONSTRAINT [FK_Medicines_Producers]

	ALTER TABLE [dbo].[Medicines]  WITH CHECK ADD  CONSTRAINT [CK_Medicines] CHECK  (([Count]>=(0)))

	ALTER TABLE [dbo].[Medicines] CHECK CONSTRAINT [CK_Medicines]


END

-- 4) Таблица MedicinesForDiseases
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'MedicinesForDiseases')
BEGIN

	CREATE TABLE [dbo].[MedicinesForDiseases](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[MidicinesId] [int] NOT NULL,
		[DiseasesId] [int] NOT NULL,
	CONSTRAINT [PK_MedicinesForDiseases] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[MedicinesForDiseases]  WITH CHECK ADD  CONSTRAINT [FK_MedicinesForDiseases_Medicines] FOREIGN KEY([MidicinesId])
	REFERENCES [dbo].[Medicines] ([Id])

	ALTER TABLE [dbo].[MedicinesForDiseases] CHECK CONSTRAINT [FK_MedicinesForDiseases_Medicines]

	ALTER TABLE [dbo].[MedicinesForDiseases]  WITH CHECK ADD  CONSTRAINT [FK_MedicinesForDiseases_Medicines1] FOREIGN KEY([DiseasesId])
	REFERENCES [dbo].[Diseases] ([Id])

	ALTER TABLE [dbo].[MedicinesForDiseases] CHECK CONSTRAINT [FK_MedicinesForDiseases_Medicines1]


END

-- 5) Таблица Outgoing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Outgoing')
BEGIN
	CREATE TABLE [dbo].[Outgoing](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[MedicineNameId] [int] NOT NULL,
		[ImplementationDate] [date] NOT NULL,
		[Count] [int] NOT NULL,
		[SellingPrice] [float] NOT NULL,
	CONSTRAINT [PK_Outgoing] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Outgoing]  WITH CHECK ADD  CONSTRAINT [FK_Outgoing_Medicines] FOREIGN KEY([MedicineNameId])
	REFERENCES [dbo].[Medicines] ([Id])

	ALTER TABLE [dbo].[Outgoing] CHECK CONSTRAINT [FK_Outgoing_Medicines]

	ALTER TABLE [dbo].[Outgoing]  WITH CHECK ADD  CONSTRAINT [CK_Outgoing] CHECK  (([Count]>=(0)))

	ALTER TABLE [dbo].[Outgoing] CHECK CONSTRAINT [CK_Outgoing]


END

-- 6) Таблица Incoming
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Incoming')
BEGIN
	CREATE TABLE [dbo].[Incoming](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[MedicineNameId] [int] NOT NULL,
		[ArrivalDate] [date] NOT NULL,
		[Count] [int] NOT NULL,
		[Provider] [nvarchar](50) NOT NULL,
		[Price] [money] NOT NULL,
	 CONSTRAINT [PK_Incoming] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Incoming]  WITH CHECK ADD  CONSTRAINT [FK_Incoming_Incoming] FOREIGN KEY([MedicineNameId])
	REFERENCES [dbo].[Medicines] ([Id])

	ALTER TABLE [dbo].[Incoming] CHECK CONSTRAINT [FK_Incoming_Incoming]

	ALTER TABLE [dbo].[Incoming]  WITH CHECK ADD  CONSTRAINT [CK_Incoming] CHECK  (([Count]>=(0)))

	ALTER TABLE [dbo].[Incoming] CHECK CONSTRAINT [CK_Incoming]

	ALTER TABLE [dbo].[Incoming]  WITH CHECK ADD  CONSTRAINT [CK_Incoming_1] CHECK  (([Price]>(0)))

	ALTER TABLE [dbo].[Incoming] CHECK CONSTRAINT [CK_Incoming_1]


END

-- АВТОЗАПОЛНЕНИЕ ТАБЛИЦ
-- Автозаполнение таблицы "Producers" на 50 записей
DECLARE @CounterProducers INT
SET @CounterProducers = 1

WHILE @CounterProducers <= 50
BEGIN
	INSERT INTO [dbo].[Producers] ([Name], [Country])
	VALUES ('Производитель ' + CAST(@CounterProducers AS NVARCHAR(5)), 'Страна ' + CAST(@CounterProducers AS NVARCHAR(5)))

	SET @CounterProducers = @CounterProducers + 1
END

-- Автозаполнение таблицы "Diseases" на 50 записей
DECLARE @CounterDiseases INT
SET @CounterDiseases = 1

WHILE @CounterDiseases <= 50
BEGIN
	INSERT INTO [dbo].[Diseases] ([InternationalCode], [Name])
	VALUES (100000 + @CounterDiseases, 'Болезнь ' + CAST(@CounterDiseases AS NVARCHAR(5)))

	SET @CounterDiseases = @CounterDiseases + 1
END

-- Автозаполнение таблицы "Medicines" на 2000 записей
DECLARE @CounterMedicines INT
SET @CounterMedicines = 1

WHILE @CounterMedicines <= 2000
BEGIN
	INSERT INTO [dbo].[Medicines] ([Name], [ShortDescription], [ActiveSubstance], [ProducerId], [UnitOfMeasurement], [Count], [StorageLocation])
	VALUES ('Лекарство ' + CAST(@CounterMedicines AS NVARCHAR(5)), 'Описание ' + CAST(@CounterMedicines AS NVARCHAR(5)), 'Активное вещество ' + CAST(@CounterMedicines AS NVARCHAR(5)), @CounterMedicines, 'Единица измерения ' + CAST(@CounterMedicines AS NVARCHAR(5)), 100, 'Место хранения ' + CAST(@CounterMedicines AS NVARCHAR(5)))

	SET @CounterMedicines = @CounterMedicines + 1
END

-- Автозаполнение таблицы "MedicinesForDiseases" на 2000 записей
DECLARE @CounterMedicinesForDiseases INT
SET @CounterMedicinesForDiseases = 1

WHILE @CounterMedicinesForDiseases <= 2000
BEGIN
	INSERT INTO [dbo].[MedicinesForDiseases] ([MidicinesId], [DiseasesId])
	VALUES (@CounterMedicinesForDiseases, @CounterMedicinesForDiseases)

	SET @CounterMedicinesForDiseases = @CounterMedicinesForDiseases + 1
END

-- Автозаполнение таблицы "Outgoing" на 50 записей
DECLARE @CounterOutgoing INT
SET @CounterOutgoing = 1

WHILE @CounterOutgoing <= 50
BEGIN
	INSERT INTO [dbo].[Outgoing] ([MedicineNameId], [ImplementationDate], [Count], [SellingPrice])
	VALUES (@CounterOutgoing, GETDATE(), 10, 100.0)

	SET @CounterOutgoing = @CounterOutgoing + 1
END

-- Автозаполнение таблицы "Incoming" на 50 записей
DECLARE @CounterIncoming INT
SET @CounterIncoming = 1

WHILE @CounterIncoming <= 50
BEGIN
	INSERT INTO [dbo].[Incoming] ([MedicineNameId], [ArrivalDate], [Count], [Provider], [Price])
	VALUES (@CounterIncoming, GETDATE(), 10, 'Поставщик ' + CAST(@CounterIncoming AS NVARCHAR(5)), 50.0)

	SET @CounterIncoming = @CounterIncoming + 1
END

-- Создаем новое представление
GO
CREATE VIEW IncomingDetails AS
SELECT 
    I.Id AS IncomingId,
    M.Name AS MedicineName,
    P.Name AS ProducerName,
    I.ArrivalDate,
    I.Count AS IncomingCount,
    I.Provider,
    I.Price
FROM Incoming AS I
INNER JOIN Medicines AS M ON I.MedicineNameId = M.Id
LEFT JOIN Producers AS P ON M.ProducerId = P.Id;


GO
-- Создаем новое представление
CREATE VIEW MedicineDetails AS
SELECT 
    M.Id AS MedicineId,
    M.Name AS MedicineName,
    M.ShortDescription AS MedicineDescription,
    M.ActiveSubstance,
    M.UnitOfMeasurement,
    M.Count AS MedicineCount,
    M.StorageLocation,
    P.Id AS ProducerId,
    P.Name AS ProducerName,
    P.Country AS ProducerCountry,
    D.Id AS DiseaseId,
    D.Name AS DiseaseName
FROM Medicines AS M
LEFT JOIN Producers AS P ON M.ProducerId = P.Id
LEFT JOIN MedicinesForDiseases AS MD ON M.Id = MD.MidicinesId
LEFT JOIN Diseases AS D ON MD.DiseasesId = D.Id;

GO
-- Создаем новое представление
CREATE VIEW OutgoingDetails AS
SELECT 
    O.Id AS OutgoingId,
    M.Name AS MedicineName,
    P.Name AS ProducerName,
    O.ImplementationDate,
    O.Count AS OutgoingCount,
    O.SellingPrice
FROM Outgoing AS O
INNER JOIN Medicines AS M ON O.MedicineNameId = M.Id
LEFT JOIN Producers AS P ON M.ProducerId = P.Id;


-- Создание хранимых процедур
-- Хранимая процедура для вставки данных в таблицу Medicines:
GO
	CREATE PROCEDURE InsertMedicine
		@Name NVARCHAR(50),
		@ShortDescription NVARCHAR(200),
		@ActiveSubstance NVARCHAR(50),
		@ProducerId INT,
		@UnitOfMeasurement NVARCHAR(50),
		@Count INT,
		@StorageLocation NVARCHAR(50)
	AS
	BEGIN
		INSERT INTO Medicines (Name, ShortDescription, ActiveSubstance, ProducerId, UnitOfMeasurement, Count, StorageLocation)
		VALUES (@Name, @ShortDescription, @ActiveSubstance, @ProducerId, @UnitOfMeasurement, @Count, @StorageLocation)
	END

-- Хранимая процедура для обновления данных в таблице Producers:
GO
	CREATE PROCEDURE UpdateProducer
		@Id INT,
		@Name NVARCHAR(100),
		@Country NVARCHAR(20)
	AS
	BEGIN
		UPDATE Producers
		SET Name = @Name, Country = @Country
		WHERE Id = @Id
	END

-- Хранимая процедура для вставки данных в таблицу Incoming:
GO
	CREATE PROCEDURE InsertIncoming
		@MedicineNameId INT,
		@ArrivalDate DATE,
		@Count INT,
		@Provider NVARCHAR(50),
		@Price MONEY
	AS
	BEGIN
		INSERT INTO Incoming (MedicineNameId, ArrivalDate, Count, Provider, Price)
		VALUES (@MedicineNameId, @ArrivalDate, @Count, @Provider, @Price)
	END
