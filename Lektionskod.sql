USE FailSafeIT;
GO

select Servers.ServerName, Servers.IpAddress, Users.Username
from Servers
inner join Users on Servers.ManagedByUserId = Users.Id;

select s.servername, s.ipaddress, u.username
from Servers s
join Users u on s.ManagedByUserId = u.Id;