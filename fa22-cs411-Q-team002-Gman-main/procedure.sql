CREATE PROCEDURE countAirline()
    BEGIN
        DECLARE done INT default 0;
        DECLARE currAirline VARCHAR(50);
        DECLARE airlineCur CURSOR FOR SELECT DISTINCT Airline_ID FROM Airline WHERE Active = 'Y';
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

        DROP TABLE IF EXISTS airlineRouteCount;

        CREATE TABLE airlineRouteCount (
            airLineName VARCHAR(50),
            numRoutes INT
        );

        DROP TABLE IF EXISTS airlineApCount;

        CREATE TABLE airlineApCount (
            airLineName VARCHAR(50),
            numAirports INT
        );


        OPEN airlineCur;

        REPEAT
            FETCH airlineCur INTO currAirline;
            INSERT INTO airlineRouteCount
            (SELECT a.Name, Count(*) FROM Route r JOIN Airline a ON r.Airline_ID = a.Airline_ID WHERE r.Airline_ID=currAirline GROUP BY r.Airline_ID);
            INSERT INTO airlineApCount
            (SELECT a.Name, Count(DISTINCT Source_Airport_ID) FROM Route r JOIN Airline a ON r.Airline_ID = a.Airline_ID WHERE r.Airline_ID=currAirline GROUP BY r.Airline_ID); 
        UNTIL done
        END REPEAT;

        CLOSE airlineCur;    

    END;//