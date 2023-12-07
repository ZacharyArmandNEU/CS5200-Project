"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Functions for running menus before and after logging in
"""

import pymysql
# associated files to support this project
from view_functions import view_menu
from edit_functions import edit_user, edit_rating, submit_rating
from search_functions import search_menu


def register_user(cnx):
    """
    Creates user in database table `users`
    :param cnx: current pymysql connection
    :return: user_id, user ID for successfully created user in database.
    """

    # create cursor
    cur = cnx.cursor()

    try:
        # all queries inside loop contained within this try-except
        while True:
            # get user choices for creating account - strip whitespace
            user_name_input = input("Enter a username (spaces will be removed): ").replace(" ", "")
            while len(user_name_input) == 0:
                # meaning, blank input
                user_name_input = input("Blank input. Enter a username: ").replace(' ', '')
            # Call procedure check_user_exists
            call_check_user = f"SELECT checker_user_taken('{user_name_input}');"
            cur.execute(call_check_user)
            # get response from calling username checker
            user_check = next(iter(cur.fetchone().values()), None)
            # if fails, repeat loop
            if user_check == 1:
                print("Error: Passed username already exists")
            # else, allow user to create account with given username
            elif user_check == -1:  # username doesn't exist
                # ask for other info to create account
                user_input_email = input("Enter an email (spaces will be removed): ").replace(' ', '')
                # check if user entered blank email
                while len(user_input_email) == 0:
                    # meaning, blank input
                    user_input_email = input("Blank input. Enter an email: ").replace(' ', '')
                # first name and last name can be blank
                user_input_firstname = input("Enter a first name: ")
                user_input_lastname = input("Enter a last name: ")
                # format user input for passing to create user function
                pass_user_input = f"'{user_name_input}', '{user_input_email}'," \
                                  f" '{user_input_firstname}', '{user_input_lastname}'"
                call_create_user = "CALL create_user(" + pass_user_input + ");"
                # call the procedure.
                cur.execute(call_create_user)
                # commit changes
                cnx.commit()

                # get new userID for later use
                query = f"SELECT check_user_exist('{user_name_input}', '{user_input_email}');"
                cur.execute(query)
                user_id = next(iter(cur.fetchone().values()), -1)
                # print success message and account information
                print(f"Successfully registered with username '{user_name_input}' and email '{user_input_email}'")
                return user_id
    except pymysql.err.OperationalError:
        # error - username already exists. Recall home screen
        print("Error: Invalid input")
        return -1
    except pymysql.err.DataError:
        # error - username already exists. Recall home screen
        print("Error: Passed data too long")
        return -1


def login_user(cur):
    """
    Logs user in, that is, gets user id based on username and email
    :param cur: pymysql cursor object
    :return: user_id (INT), user ID for session
        Returns -1 if login failed
    """
    try:
        # ask for username and email
        user_name = input("Enter user name: ")
        user_email = input("Enter email: ")
        # Call procedure check_user_exists
        call_check_user = f"SELECT check_user_exist(%s, %s);"
        cur.execute(call_check_user, (user_name, user_email))
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


def home_screen(cnx):
    """
    Displays home screen options
    :param cur: pymysql cursor object
    :return: user_id if login is successful, None if user chooses to exit program
    """
    # print greeting message
    print("Welcome to New England Ice Cream Network!")
    # exit loop value - will take valid user_id once complete
    user_id = -1
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to log in\n   2 to register\n   3 to quit\n")
        # log in user
        if (user_choice == '1') or (user_choice.lower() == "log in"):
            cur = cnx.cursor()
            user_id = login_user(cur)
        # register and log in user
        elif (user_choice == '2') or (user_choice.lower() == "register"):
            user_id = register_user(cnx)
        elif (user_choice == '3') or (user_choice.lower() == "quit"):
            print("Exiting application")
            return None
        else:
            print("Invalid choice")

        # Check if function can return user_ID
        if user_id != -1:
            print("Login successful.")
            return user_id


def main_menu(cnx, user_id):
    """
    Runs main menu after successfully logging in
    :param cnx: pymysql connection
    :param user_id: INT, user id for session
    :return: None, runs until user decides to quit menu
    """

    # print main message
    print("Welcome. Please choose an option.")
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 | explore network\n   2 | submit review\n   3 | search flavors, companies, "
                            "reviews\n   4 | edit review\n   5 | edit user info\n   6 | quit\n")
        # create cursor
        cur = cnx.cursor()
        # run corresponding utility
        match user_choice.lower():
            case '1' | 'explore':
                view_menu(cur, user_id)
            case '2' | 'submit review':
                submit_rating(cur, cnx, user_id)
            case '3' | 'search':
                search_menu(cur)
            case '4' | 'edit review':
                edit_rating(cur, cnx, user_id)
            case '5' | 'edit user':
                edit_user(cur, cnx, user_id)
            case '6' | 'quit':
                print("Exiting application")
                cur.close()
                return None  # effectively quits
            case _:  # all other input
                print("Invalid choice")
