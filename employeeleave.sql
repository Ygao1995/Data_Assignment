CREATE PROCEDURE `employeeLeave` (IN ID int)
BEGIN
	ALTER TABLE employees
	ADD Active boolean default True;
    

	UPDATE employees
	SET
		Active = False,
		employeeNumber = reportsTo
	WHERE employeeNumber = ID;
END
