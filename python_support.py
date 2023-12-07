"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Implements main UI operations
"""

import pymysql
import sys
# associated files to support this project
from home_menu import home_screen
from view_functions import view_menu, view_user_rating
from edit_functions import edit_user, edit_rating, submit_rating
from search_functions import search_menu


def main_menu(cur, user_id):
    """
    Runs main menu after successfully logging in
    :param cur: pymysql cursor object
    :param user_id: INT, user id for session
    :return: None, runs until user decides to quit menu
    """

    # print main message
    print("Welcome. Please choose an option.")
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 | explore network\n   2 | submit rating\n   3 | search flavors, companies, "
                            "ratings\n   4 | edit review\n   5 | edit user info\n   6 | quit\n")
        # run corresponding utility
        match user_choice.lower():
            case '1' | 'explore':
                view_menu(cur, user_id)
            case '2' | 'submit rating':
                submit_rating(cur, user_id)
            case '3' | 'search':
                search_menu(cur)
            case '4' | 'edit review':
                edit_rating(cur, user_id)
            case '5' | 'edit user':
                edit_user(cur, user_id)
            case '6' | 'quit':
                print("Exiting application")
                return None  # effectively quits
            case _:  # all other input
                print("Invalid choice")


def main():
    try:
        # use the user provided username and password values to connect to musicarmandz (HW7)
        cnx = pymysql.connect(host='127.0.0.1',
                              user='root',
                              password='root',
                              db='new_england_ice_cream',
                              cursorclass=pymysql.cursors.DictCursor)
    except RuntimeError:
        # if connection fails due to user/pass, print error and exit python program
        print("Incorrect username or password entered. Exiting program.")
        sys.exit()  # terminate program
    except pymysql.err.OperationalError:
        # if connection fails due to connection failure, print error and exit python program
        print("Failed to connect to database. Exiting program.")
        sys.exit()  # terminate program
    # if connection successful, create cursor object
    cur = cnx.cursor()

    # assign current user id to object for later usage
    #current_user_id = home_screen(cur)
    current_user_id = 1

    # run main menu until program quits
    main_menu(cur, current_user_id)

    # Close the connection to the database and end the application program. Commit any changes
    # cnx.commit()
    cur.close()
    cnx.close()


if __name__ == "__main__":
    main()
