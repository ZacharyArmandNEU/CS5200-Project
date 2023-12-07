"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Implements main UI operations
"""

import pymysql
import sys
from home_menu import home_screen, main_menu  # file included with this project


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


    # assign current user id to object for later usage
    current_user_id = home_screen(cnx)

    # run main menu until program quits
    if current_user_id is not None:
        main_menu(cnx, current_user_id)

    # Close the connection to the database and end the application program. Commit any changes
    cnx.commit()
    cnx.close()
    sys.exit()


if __name__ == "__main__":
    main()
