

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
        SET MESSAGE_TEXT = 'Rating for this combindation of userID and flavorID already exist.';
	ELSE
		
		SELECT chain_ID INTO new_brand_ID
		FROM flavors
		WHERE flavor_ID = rating_flav_ID; 


		INSERT INTO ratings 
		VALUES (NULL, rating_date, rating_stars, rating_remarks, rating_flav_ID, new_brand_ID, input_user_id);
	END IF;
END $$
DELIMITER ;


