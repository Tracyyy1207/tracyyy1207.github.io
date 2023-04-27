delimiter //
CREATE TRIGGER check_country
BEFORE INSERT 
    ON Airline FOR EACH ROW

BEGIN
    IF NEW.Country NOT IN (SELECT Name FROM Country) THEN 
        SET NEW.Country = NULL;
    END IF;
END;//
delimiter ;