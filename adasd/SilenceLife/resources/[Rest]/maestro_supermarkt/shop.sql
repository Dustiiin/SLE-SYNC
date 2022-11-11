CREATE TABLE maestro_shops (
  id int(11) NOT NULL,
  name varchar(255) DEFAULT NULL,
  display varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  price int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO maestro_shops (id, name, display, type, price) VALUES
(1, 'water', 'Wasser', 'item', 5),
(2, 'bread', 'Brot', 'item', 5);