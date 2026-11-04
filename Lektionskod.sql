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