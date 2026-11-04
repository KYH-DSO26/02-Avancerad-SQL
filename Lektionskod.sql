USE FailSafeIT;
GO

-- Uppgift 1
-- Den Inre Cirkeln (INNER JOIN) – Skriv en SQL-fråga som listar alla servrar 
-- tillsammans med användarnamnet på den DevSecOps-tekniker som hanterar den (ManagedByUserId).
select Servers.ServerName, Servers.IpAddress, Users.Username
from Servers
inner join Users on Servers.ManagedByUserId = Users.Id;

select s.servername, s.ipaddress, u.username
from Servers s
join Users u on s.ManagedByUserId = u.Id;

-- https://github.com/KYH-DSO26/02-Avancerad-SQL.git

-- Uppgift 2
-- De Herrelösa Maskinerna (LEFT JOIN) – Visa samtliga servrar i systemet. 
-- Om en server saknar en tilldelad tekniker ska fältet för användarnamn visa NULL.
select s.servername, s.ipaddress, u.username
from Servers s
LEFT join Users u on s.ManagedByUserId = u.Id;

-- Uppgift 3
-- De Inaktiva Teknikerna (RIGHT JOIN) – Lista alla användare i systemet och 
-- mappa dem mot de servrar de hanterar. 
-- Användare som inte hanterar någon server ska fortfarande synas i listan.
select s.servername, s.ipaddress, u.username
from Servers s
RIGHT join Users u on s.ManagedByUserId = u.Id;

-- Uppgift 4
-- Den Kompletta Kartläggningen (FULL JOIN) – 
-- Kombinera tabellerna helt så att absolut alla användare och absolut alla servrar visas, 
-- oavsett om de har en koppling till varandra eller inte.
select s.servername, s.ipaddress, u.username
from Servers s
FULL OUTER join Users u on s.ManagedByUserId = u.Id;

-- Uppgift 5
-- Filtrera Aliasing – Skriv om frågan från Uppgift 1 med korta, 
-- tydliga tabell-alias (s för Servers, u för Users) 
-- och filtrera ut så att endast servrar i Environment = 'Production' visas.
select s.servername, s.ipaddress, u.username
from Servers s
join Users u on s.ManagedByUserId = u.Id
where s.Environment = 'Production';

--Uppgift 5
-- Det fysiska låset. Skriv ett DDL-skript som lägger till en FOREIGN KEY-constraint 
-- på kolumnen ManagedByUserId i tabellen Servers så att den pekar på Id i Users. 
-- Sätt regeln till ON DELETE SET NULL.
alter table servers
add constraint FK_Servers_Users_ManagedByUserId
FOREIGN KEY (ManagedByUserId) REFERENCES Users(Id)
ON DELETE SET NULL;
GO


-- Uppgift 6
-- Miljökontrollen. Skriv en query som via en INNER JOIN hämtar användarnamn och servernamn, 
-- men filtrera resultatet så att du endast visar servrar som tillhör 
-- miljöerna 'Production' eller 'Staging'.

select u.username, s.servername
from servers s
inner join users u on s.ManagedByUserId = u.Id
where s.Environment = 'Production' or s.Environment = 'Staging';

select u.username, s.servername
from servers s
inner join users u on s.ManagedByUserId = u.Id
where s.Environment IN ('Production', 'Staging');

-- Uppgift 7
-- Snabba spår i loggen. Skapa ett NONCLUSTERED INDEX på tabellen Servers för
-- kolumnen ManagedByUserId. Skriv en kort kommentar om varför detta är viktigt vid
-- Foreign Key-valideringar.
create nonclustered index IX_Servers_ManagedByUserId
ON Servers(ManagedByUserId);
GO

-- Uppgift 6
-- Detektivarbete i Exekveringsplanen – Aktivera "Actual Execution Plan" i SSMS. 
-- Kör en sökning på en specifik IP-adress: 
-- SELECT * FROM Servers WHERE IpAddress = '10.0.0.15';. 
-- Notera om SQL Server gör en Table Scan eller Index Scan/Seek.
SELECT IpAddress FROM Servers WHERE IpAddress = '10.0.1.20';

create nonclustered index ix_servers_ipaddress
on servers(IpAddress);
GO

-- Uppgift 9
-- Penetrationstestet. Kör din applikation från Uppgift 8. Mata in payloaden
-- hacker@failsafe.it' OR '1'='1 och verifiera att din kod släpper igenom SQL-injektionen
-- och dumpar tabellens innehåll.
SELECT Id, Username, Email FROM Users WHERE Email = 'hacker@failsafe.it' OR '1'='1'
GO


-- Uppgift 11
-- Inkapsling via DDL. Skapa en Stored Procedure i SQL Server som heter usp_RegisterServer. 
-- Den ska ta emot parametrar för servernamn, IP-adress, miljö och hanterande användar-ID, 
-- och utföra en INSERT INTO.
create procedure usp_RegisterServer
	@ServerName NVARCHAR(100),
	@IpAddress VARCHAR(50),
	@Environment NVARCHAR(50),
    @ManagedByUserId INT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Servers (ServerName, IpAddress, Environment, ManagedByUserId)
	VALUES (@ServerName, @IpAddress, @Environment, @ManagedByUserId);
END;
GO

-- Kör en procedure: kort format
EXECUTE usp_RegisterServer 'WEB-PROD-01', '10.0.3.30', 'Production', 4;
GO

-- Kör en procedure: långt format. Mycket tydligare och lättare att underhålla
EXEC usp_RegisterServer
	@ServerName = 'Web-Prod-02',
	@Environment = 'Stage',
	@IpAddress = '10.0.3.31',
    @ManagedByUserId = 2;
GO

-- Ny Uppgift 12: Transaktionssäker insättning.
-- Uppdatera din Stored Procedure sp_RegisterServer från Uppgift 11. 
-- Lägg till felhantering med TRY...CATCH. 
-- Om insättningen misslyckas (t.ex. på grund av att ett Foreign Key-villkor bryts), 
-- ska ändringarna rullas tillbaka med ROLLBACK TRANSACTION och ett eget felmeddelande 
-- ska kastas med RAISERROR eller THROW.
ALTER procedure usp_RegisterServer
	@ServerName NVARCHAR(100),
	@IpAddress VARCHAR(50),
	@Environment NVARCHAR(50),
    @ManagedByUserId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

			INSERT INTO Servers (ServerName, IpAddress, Environment, ManagedByUserId)
			VALUES (@ServerName, @IpAddress, @Environment, @ManagedByUserId);
			 COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		-- Om något går fel så rulla tillbaka allt vi har gjort
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Kasta ett tydligt felmeddelande
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		THROW 50001, @ErrorMessage, 1;
	END CATCH
END;
GO

EXECUTE usp_RegisterServer 'WEB-PROD-03', '10.0.3.33', 'Production', 99;
GO

-- Ny Uppgift 13: Maskering av känsliga uppgifter.
-- Användardata som e-postadresser är känsliga uppgifter enligt GDPR. 
-- Skriv ett DDL-skript som lägger till en DYNAMIC DATA MASKING-funktion på kolumnen Email 
-- i tabellen Users, så att endast första bokstaven och domänen visas 
-- (t.ex. hXXXXX@failsafe.it) för obehöriga användare.
ALTER TABLE Users
	ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()');
GO
select * from Users



execute as user='FailSafeApp';
select * from users;

select * from servers;
REVERT
GO

-- Uppgift 14
-- Principen om minsta behörighet (Least Privilege). 
-- Skriv ett DDL-skript i SSMS som skapar en ny SQL-inloggning och 
-- databasanvändare vid namn FailsafeApp. Blockera användaren från direktåtkomst 
-- till tabellerna med DENY SELECT, INSERT ON Users och DENY SELECT, INSERT ON Servers.

-- Skapa inloggning på servernivå:
create login FailSafeApp with password='hemligt';
-- Skapa användaren
create user FailSafeApp for login FailSafeApp;

DENY SELECT, INSERT ON Users To FailSafeApp;
DENY SELECT, INSERT ON Servers To FailSafeApp;

GO

-- Uppgift 15
-- Skölden aktiveras. Ge din nya användare FailsafeApp exekveringsrättigheter (GRANT EXECUTE) 
-- på din Stored Procedure från Uppgift 11. 
-- Verifiera i SSMS att användaren kan köra proceduren men stoppas vid direkta SELECT-frågor.
GRANT EXECUTE ON usp_RegisterServer TO FailSafeApp;
-- För a´tt testa maskning ger vi läsrättigheter till Users
grant select on Users to FailSafeApp;
GO