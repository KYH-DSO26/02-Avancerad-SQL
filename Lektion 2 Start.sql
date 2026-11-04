/* ============================================================================
   FAILSAFE IT - INFRASTRUKTUR- OCH BEHÖRIGHETSREGISTER
   STARTSKRIPT FÖR LEKTION 2: Relationsdjup, Indexering & SQLi-försvar
   ============================================================================ */

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'FailSafeIT')
BEGIN
    ALTER DATABASE FailSafeIT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FailSafeIT;
END
GO

CREATE DATABASE FailSafeIT;
GO

USE FailSafeIT;
GO

-- SKAPA TABELLER
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) UNIQUE NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Servers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ServerName NVARCHAR(100) NOT NULL,
    IpAddress VARCHAR(50) NULL,
    Environment NVARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1,
    ManagedByUserId INT NULL
);
GO

-- POPULERA PREPARERAD DATA (Innehåller medvetna relationella glapp för JOIN-övningarna)
INSERT INTO Users (Username, Email, Role) VALUES
('alice_adm', 'alice@failsafe.it', 'Administrator'),
('bob_dev', 'bob@failsafe.it', 'Developer'),
('charlie_sec', 'charlie@failsafe.it', 'SecOps'),
('dana_auditor', 'dana@failsafe.it', 'Auditor'),
('elena_ghost', 'elena.unassigned@failsafe.it', 'Developer'); -- Användare utan server (För LEFT JOIN)
GO

INSERT INTO Servers (ServerName, IpAddress, Environment, IsActive, ManagedByUserId) VALUES
('fw-core-prod-01', '10.0.1.1', 'Production', 1, 3),   
('web-frontend-prod-01', '10.0.1.10', 'Production', 1, 1), 
('db-cluster-prod-01', '10.0.1.20', 'Production', 1, 1),   
('api-gateway-stage', '10.0.2.10', 'Staging', 1, 2),     
('build-agent-dev-01', '192.168.1.50', 'Development', 1, 2), 
('lonely-wild-prod', '10.0.99.99', 'Production', 1, NULL), -- Herrelös server (För RIGHT JOIN)
('zombie-dev-02', '192.168.1.99', 'Development', 0, NULL); -- Herrelös server (För RIGHT JOIN)
GO

PRINT 'FailSafeIT-databasen är skapad och preparerad för Lektion 2!';