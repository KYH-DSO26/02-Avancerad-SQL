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

