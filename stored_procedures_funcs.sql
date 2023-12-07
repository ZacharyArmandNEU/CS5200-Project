

-- register user
DROP PROCEDURE IF EXISTS create_user;
DELIMITER $$
CREATE PROCEDURE create_user( 
    IN user_name_input VARCHAR(20),
    IN email_input VARCHAR(32),
    IN first_name_input VARCHAR(32),
    IN last_name_input VARCHAR(32)	
) 
BEGIN
	-- Hold results of existence test
    DECLARE user_exists INT;
    -- Check if username already exists
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_name = user_name_input;
    IF user_exists = 0 THEN
        -- If not already existing, insert new user into table
        INSERT INTO users VALUES (NULL, user_name_input, email_input, first_name_input, last_name_input);
	ELSE
		-- If user already exists, raise error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passed username already exists.';
    END IF;
END $$
DELIMITER ;


-- check if username and email combo exist
DROP FUNCTION IF EXISTS check_user_exist;
DELIMITER $$
CREATE FUNCTION check_user_exist(user_name_input VARCHAR(20), email_input VARCHAR(32))
RETURNS INT
CONTAINS SQL
DETERMINISTIC
BEGIN
	DECLARE return_user_ID INT;
	IF EXISTS(SELECT user_ID FROM users where user_name = user_name_input AND email = email_input) THEN
		BEGIN
			SELECT user_ID 
            INTO return_user_ID 
            FROM users 
            WHERE user_name = user_name_input AND email = email_input;
			RETURN return_user_ID;
        END;
	END IF;
END $$ 
DELIMITER ;


-- checks if username already exists\
-- 1 if already exists, -1 otherwise
DROP FUNCTION IF EXISTS checker_user_taken;
DELIMITER $$
CREATE FUNCTION checker_user_taken(user_name_input VARCHAR(20))
RETURNS INT 
CONTAINS SQL
DETERMINISTIC
BEGIN
	DECLARE return_user_exist INT;
	IF EXISTS(SELECT user_ID FROM users where user_name = user_name_input) THEN
		SELECT 1 INTO return_user_exist;
	ELSE
		SELECT -1 INTO return_user_exist;
	END IF;
    RETURN return_user_exist;
END $$ 

DELIMITER ;


-- Update user information
DROP PROCEDURE IF EXISTS update_user;
DELIMITER $$
CREATE PROCEDURE update_user(
	IN intput_user_ID INT,
    IN new_email VARCHAR(32),
    IN new_first VARCHAR(32),
    IN new_last VARCHAR(32)
)
BEGIN
    -- Update email if new_email is not NULL
    IF new_email IS NOT NULL THEN
        UPDATE users SET email = new_email WHERE intput_user_ID = user_ID;
    END IF;
    -- Update first name if new_first is not NULL
    IF new_first IS NOT NULL THEN
        UPDATE users SET first_name = new_first WHERE intput_user_ID = user_ID;
    END IF;
    -- Update last name if new_last is not NULL
    IF new_last IS NOT NULL THEN
        UPDATE users SET last_name = new_last WHERE intput_user_ID = user_ID;
    END IF;
END $$
DELIMITER ;





-- Update rating for user
DROP PROCEDURE IF EXISTS update_ratings;
DELIMITER $$
CREATE PROCEDURE update_ratings(
	IN intput_user_ID INT,
    IN new_stars INT,
    IN new_remarks TEXT
)
BEGIN
    -- Update stars if new_stars is not NULL
    IF new_stars IS NOT NULL THEN
        UPDATE ratings SET stars = new_stars WHERE intput_user_ID = user_ID;
    END IF;
    -- Update remarks if new_remarks is not NULL
    IF new_remarks IS NOT NULL THEN
        UPDATE ratings SET remarks = new_remarks WHERE intput_user_ID = user_ID;
    END IF;
END $$
DELIMITER ;





-- Insert new rating
-- Works in conjunction with trigger "chain_update_after_rating"
DROP PROCEDURE IF EXISTS insert_rating;
DELIMITER $$
CREATE PROCEDURE insert_rating( 
    IN input_user_id INT,
    IN rating_flav_ID INT,
    IN rating_date DATE,
    IN rating_stars INT,
    IN rating_remarks TEXT
) 
BEGIN
	
    DECLARE new_brand_ID INT;
    
	-- validate that combination of userID, flavorID doesn't already exist
    IF EXISTS(SELECT user_ID, flavor_ID FROM ratings where user_ID = input_user_id AND flavor_ID = rating_flav_ID) THEN
		SIGNAL SQLSTATE '23000'
        SET MESSAGE_TEXT = 'Rating for this combination of userID and flavorID already exist.';
	ELSE
		
		SELECT chain_ID INTO new_brand_ID
		FROM flavors
		WHERE flavor_ID = rating_flav_ID; 

		INSERT INTO ratings 
		VALUES (NULL, rating_date, rating_stars, rating_remarks, rating_flav_ID, new_brand_ID, input_user_id);
	END IF;
END $$
DELIMITER ;




-- search for flavors by mixin
-- accepts a mixin name as input
-- also accepts 'None' as an input
DROP PROCEDURE IF EXISTS flavors_by_mixin;

DELIMITER $$
CREATE PROCEDURE flavors_by_mixin(in_mixin_name VARCHAR(64))
BEGIN
	IF (in_mixin_name = 'None') OR (in_mixin_name IS NULL) THEN 
		SELECT 
			flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(flavor_base.base_name SEPARATOR ', ') AS base
		FROM flavor_mixin
		RIGHT JOIN flavors ON flavor_mixin.flavor_ID = flavors.flavor_ID
		LEFT JOIN flavor_base ON flavors.flavor_ID = flavor_base.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		WHERE flavor_mixin.mixin_name IS NULL
		GROUP BY flavors.flavor_ID, chains.brand_name;
    ELSEIF NOT EXISTS(SELECT mixin_name FROM mixin WHERE mixin_name = in_mixin_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mixin not found';
    ELSE
		SELECT flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(flavor_base.base_name SEPARATOR ', ') AS base
		FROM flavor_mixin
		JOIN mixin ON flavor_mixin.mixin_name = mixin.mixin_name
		JOIN flavors ON flavor_mixin.flavor_ID = flavors.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		LEFT JOIN flavor_base ON flavor_mixin.flavor_ID = flavor_base.flavor_ID
		WHERE flavor_mixin.mixin_name = in_mixin_name -- input here
		GROUP BY flavor_name, chains.brand_name
		ORDER BY chains.brand_name;  
	END IF;    
END $$
DELIMITER ;


-- Searches for flavors by base
-- Every flavor has a base, so no need to test for NULL input
DROP PROCEDURE IF EXISTS flavors_by_base;

DELIMITER $$
CREATE PROCEDURE flavors_by_base(IN in_base_name VARCHAR(64))
BEGIN
    
    IF NOT EXISTS(SELECT base_name FROM base WHERE base_name = in_base_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Base not found';
    ELSE
		SELECT flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(IFNULL(flavor_mixin.mixin_name, "None") SEPARATOR ', ') AS mixins
		FROM flavor_base
		JOIN base ON flavor_base.base_name = base.base_name
		JOIN flavors ON flavor_base.flavor_ID = flavors.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		LEFT JOIN flavor_mixin ON flavor_base.flavor_ID = flavor_mixin.flavor_ID
		WHERE flavor_base.base_name = in_base_name -- input here
		GROUP BY flavor_name, chains.brand_name
		ORDER BY chains.brand_name;    
	END IF;    
END $$
DELIMITER ;



-- VIEW ALL RATINGS BY ONE USER
DROP PROCEDURE IF EXISTS ratings_by_user;

DELIMITER $$ 
CREATE PROCEDURE ratings_by_user(IN in_user_id INT)
BEGIN
		IF (SELECT user_name FROM users WHERE user_ID = in_user_id) IS NULL THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'User does not exist';
		ELSE
			SELECT 
				rating_ID, 
				rating_date, 
				stars, remarks, 
				flavor_name, 
				brand_name
			FROM ratings
			JOIN chains ON chains.chain_ID = ratings.brand
			JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID WHERE user_ID = in_user_id;
		END IF;
END $$
DELIMITER ;






-- VIEW AVG RATINGS BY FLAVOR
DROP PROCEDURE IF EXISTS ratings_by_flavor;

DELIMITER $$ 
CREATE PROCEDURE ratings_by_flavor()
BEGIN
	SELECT 
		flavor_name, 
		AVG(CAST(stars AS float)) AS avg_stars
	FROM ratings
	JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID
	GROUP BY flavor_name;
END $$
DELIMITER ;


-- VIEW AVG RATINGS BY chain
DROP PROCEDURE IF EXISTS ratings_by_chain;

DELIMITER $$ 
CREATE PROCEDURE ratings_by_chain()
BEGIN
	SELECT 
		brand_name, 
		AVG(CAST(stars AS float)) AS avg_stars
	FROM ratings
	JOIN chains ON ratings.brand = chains.chain_ID
	GROUP BY brand_name;
END $$
DELIMITER ;


-- Get user info
DROP PROCEDURE IF EXISTS user_information;
DELIMITER $$ 
CREATE PROCEDURE user_information(IN user_name_input INT)
BEGIN

	IF NOT EXISTS(SELECT user_name FROM users WHERE user_ID = user_name_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User does not exist';
	ELSE
		SELECT * FROM users WHERE user_ID = user_name_input;
	END IF;
END $$
DELIMITER ;


-- Gets rating IDs for user
DROP PROCEDURE IF EXISTS rating_id_user;
DELIMITER $$ 
CREATE PROCEDURE rating_id_user(IN user_id_input INT)
BEGIN

	IF NOT EXISTS(SELECT user_name FROM users WHERE user_ID = user_id_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User does not exist';
	ELSE
		SELECT rating_ID FROM ratings WHERE user_ID = user_id_input;
	END IF;
END $$
DELIMITER ;



-- Gets rating IDs for user
DROP PROCEDURE IF EXISTS delete_rating;
DELIMITER $$ 
CREATE PROCEDURE delete_rating(IN rating_id_input INT)
BEGIN

	IF NOT EXISTS(SELECT rating_ID FROM ratings WHERE rating_ID = rating_id_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Rating does not exist';
	ELSE
		DELETE FROM ratings WHERE rating_ID = rating_id_input;
	END IF;
END $$
DELIMITER ;




-- shows all flavors
-- built in optional filter - HAVING keyword = criteria;
DROP PROCEDURE IF EXISTS show_flavors;
DELIMITER $$ 
CREATE PROCEDURE delete_rating(IN optiona_filter TEXT)
BEGIN

	IF NOT EXISTS(SELECT rating_ID FROM ratings WHERE rating_ID = rating_id_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Rating does not exist';
	ELSE
		DELETE FROM ratings WHERE rating_ID = rating_id_input;
	END IF;
END $$
DELIMITER ;
 	





SELECT flavor_ID, flavor_name, ice_cream_type, brand_name
FROM flavors 
JOIN chains ON flavors.chain_ID = chains.chain_ID  ;





