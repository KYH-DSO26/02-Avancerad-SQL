execute as user = 'FailSafeApp';

select Username, Email from Users;

EXEC usp_RegisterServer 'Stage-SQL-03', '10.0.0.7', 'Staging', 2

REVERT