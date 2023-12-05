import sys
import pymysql


def register_user(cur):
    """
    Creates user in database table `users`.
    param cur: current pymysql cursor object
    :return: user_id, user ID for successfully created user in database.
    """

    try:
        # get user choices for creating account
        user_name_input = input("Enter a username: ").replace(" ", "")  # strip whitespace from username
        user_input_email = input("Enter an email: ")
        user_input_firstname = input("Enter a first name: ")
        user_input_lastname = input("Enter a last name: ")
        # format user input for passing to create user function
        pass_user_input = f"'{user_name_input}', '{user_input_email}', '{user_input_firstname}', '{user_input_lastname}'"
        call_create_user = "CALL create_user(" + pass_user_input + ");"
        # Call the procedure.
        cur.execute(call_create_user)

        # after call, this means successful. Print input and return user ID
        cur.execute(f"SELECT user_ID FROM users WHERE user_name = '{user_name_input}';")
        row = cur.fetchone()
        user_id = row['user_ID']
        print(f"Successfully registered with username '{user_name_input}' and email '{user_input_email}'")
        return user_id

    except pymysql.err.OperationalError:
        # error - username already exists. Recall home screen
        print("Error: Passed username already exists")
        return -1
    except pymysql.err.DataError:
        # error - username already exists. Recall home screen
        print("Error: Passed data too long")
        return -1


def login_user(cur):
    try:
        # ask for username and email
        user_name = input("Enter user name: ")
        user_email = input("Enter email: ")
        # Call procedure check_user_exists
        call_check_user = f"SELECT check_user_exist('{user_name}', '{user_email}');"
        cur.execute(call_check_user)
        # Extract user ID from results
        tup = cur.fetchone()
        user_id = tup[f"check_user_exist('{user_name}', '{user_email}')"]
        # at this point, successfully found user. Return user id
        return user_id
    except pymysql.err.OperationalError:
        print("Passed username or password does not exist")
        return -1
    except pymysql.err.DataError:
        # error - username already exists. Recall home screen
        print("Error: Passed data too long")
        return -1


def home_screen(cur):
    # print greeting message
    print("Welcome to New England Ice Cream Network!")
    user_id = -1
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to log in\n   2 to register\n   3 to quit\n")
        # log in user
        if (user_choice == '1') or (user_choice.lower() == "log in"):
            user_id = login_user(cur)
        # register and log in user
        elif (user_choice == '2') or (user_choice.lower() == "register"):
            user_id = register_user(cur)
        elif (user_choice == '3') or (user_choice.lower() == "quit"):
            print("Exiting application")
            sys.exit()
        else:
            print("Invalid choice")

        # Check if we can return user_ID
        if user_id != -1:
            print("Login successful.")
            return user_id
