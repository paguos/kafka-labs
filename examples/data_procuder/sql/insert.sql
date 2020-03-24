DECLARE @cnt INT = 0;

PRINT 'Inserting ...';

WHILE @cnt < 1000
BEGIN
    INSERT INTO kafka.dbo.ship (ship, port)
    VALUES
      ('first',   'port_of_first')
    , ('second',  'port_of_second')
    , ('third',   'port_of_third')
  ;
  INSERT INTO kafka.dbo.train (train, station)
  VALUES
      ('first',   'station_of_first')
    , ('second',  'station_of_second')
    , ('third',   'station_of_third')
  ;
  SET @cnt = @cnt + 1;
END;

PRINT 'Inserting ... done!';
GO