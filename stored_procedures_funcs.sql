


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

