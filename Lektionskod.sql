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

