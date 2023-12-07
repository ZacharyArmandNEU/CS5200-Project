/*
Zachary Armand
CS 5200
Final Project
December 7, 2023
Inserts tuples into database for testing
*/

USE new_england_ice_cream;

-- Insert dummy users
INSERT INTO users VALUES (NULL, 'ZacharyArmand', 'armand.z@northeastern.edu', 'Zachary', 'Armand'),
	(NULL, 'Bob123', 'bob.testing@northeastern.edu', 'Bob', 'Testing'),
    (NULL, 'IceCreamFan123', 'anonymousicecream@gmail.com', 'Jim', 'Smith'),
    (NULL, 'Steve111', 'sjg12s@testing.com', 'Steve', 'Gustafson'),
    (NULL, 'JuliannaH', 'Horiuchi.j@northeastern.edu', 'Julianna', 'Horiuchi');

-- Insert chains
INSERT INTO chains VALUES (NULL, 'J.P. Licks'), (NULL, 'Ben and Jerry\'s'), (NULL, 'Cherry Farm'), (NULL, 'Tipping Cow'), (NULL, 'FoMu');

-- Insert bases
INSERT INTO base VALUES ('French Vanilla', 'Uses egg yolks, making it distinct fron Vanilla Bean'), ('Vanilla', 'Standard vanilla, no egg yolk'), ('Chocolate', NULL), ('Strawberry', NULL), ('Pistachio', NULL), ('Maple', NULL), ('Cherry', NULL), ('Mint', NULL);

-- Insert mixins
INSERT INTO mixin VALUES ('Caramel', 'Caramel swirl'), ('Walnuts', 'Chopped walnuts'), ('Chocolate Chip', NULL), ('Cookie Dough', 'Chunks of cookie dough'), ('Cherries', 'Chunks of cherry pieces'), ('Chocolate Chip Cookie', NULL), ('Fluff', 'A fluffy marshmellow swirl');

-- Insert flavors
INSERT INTO flavors VALUES (NULL, 'Vanilla', 'Hard Serve', 1, 1),
	(NULL, 'Chocolate', 'Hard Serve', 1, 1),
    (NULL, 'Chocolate Chip', 'Hard Serve', 1, 1),
    (NULL, 'Vanilla', 'Soft Serve', 1, 1),
    (NULL, 'Maple Walnut', 'Hard Serve', 1, 2),
    (NULL, 'Cherry Garcia', 'Hard Serve', 1, 2),
    (NULL, 'Swirl', 'Soft Serve', 1, 3),
	(NULL, 'Chocolate', 'Soft Serve', 1, 3),
    (NULL, 'Vanilla', 'Hard Serve', 1, 3),
    (NULL, 'Vanilla', 'Soft Serve', 1, 3),
    (NULL, 'Vanilla', 'Hard Serve', 1, 4),
    (NULL, 'Pistachio', 'Gelato', 1, 4),
    (NULL, 'Rich Vanilla', 'Hard Serve', 1, 4),
    (NULL, 'Strawberry', 'Hard Serve', 1, 5),
    (NULL, 'Grasshopper', 'Hard Serve', 0, 5),
    (NULL, 'Phish Food', 'Hard Serve', 1, 2);

-- ratings
CALL insert_rating(1, 4, '2020-12-12', 4, NULL);
CALL insert_rating(1, 1, '2020-12-12', 1, "Not great");
CALL insert_rating(1, 6, '2020-12-12', 3, NULL);

-- many-to-many tables
INSERT INTO flavor_base VALUES
(1, 'Vanilla'),
(2, 'Chocolate'),
(3, 'Vanilla'),
(4, 'Vanilla'),
(5, 'Maple'),
(6, 'Cherry'),
(7, 'Vanilla'),
(7, 'Chocolate'),
(8, 'Chocolate'),
(9, 'Vanilla'),
(10, 'Vanilla'),
(11, 'Vanilla'),
(12, 'Pistachio'),
(13, 'French Vanilla'),
(14, 'Strawberry'),
(15, 'Mint'),
(16, 'Chocolate');

INSERT INTO flavor_mixin VALUES
(3, 'Chocolate Chip'),
(5, 'Walnuts'),
(6, 'Cherries'),
(6, 'Chocolate Chip'),
(15, 'Chocolate Chip Cookie'),
(15, 'Chocolate Chip'),
(16, 'Caramel'),
(16, 'Fluff'),
(16, 'Chocolate Chip');
