USE teste;
CREATE TABLE carros( id INT NOT NULL,
               make VARCHAR(50),
               wheel_base DECIMAL(6,2),
               length DECIMAL(6,2),
               PRIMARY KEY(id));


SELECT * FROM dbo.carros;