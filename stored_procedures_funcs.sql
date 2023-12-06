

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



