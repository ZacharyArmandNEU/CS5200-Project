import pymysql
import sys

# my files to support this project
from home_menu import home_screen
from view_functions import view_menu, view_user_rating
from edit_functions import edit_user, edit_rating, submit_rating


def main_menu(cur, user_id):

    # print main message
    print("Welcome. Please choose an option.")
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 | explore network\n   2 | submit rating\n   3 | search flavors, companies, ratings\n"
                            "   4 | edit review\n   5 | edit user info\n   6 | quit\n")

        # run view network utility
        if (user_choice == '1') or (user_choice.lower() == "view"):
            view_menu(cur, user_id)
        # run rating utility
        elif (user_choice == '2') or (user_choice.lower() == "submit rating"):
            submit_rating(cur, user_id)
        # run searh network utility
        elif (user_choice == '3') or (user_choice.lower() == "search"):
            user_id = register_user(cur)
        # run edit rating utility
        elif (user_choice == '4') or (user_choice.lower() == "edit review"):
            edit_rating(cur, user_id)
        # run edit user info utility
        elif (user_choice == '5') or (user_choice.lower() == "edit user"):
            edit_user(cur, user_id)
        # quit system
        elif (user_choice == '6') or (user_choice.lower() == "quit"):
            print("Exiting application")
            sys.exit()
        else:
            print("Invalid choice")






def main():
    try:
        # Use the user provided username and password values to connect to musicarmandz (HW7)
        cnx = pymysql.connect(host='127.0.0.1',
                              user='root',
                              password='root',
                              db='new_england_ice_cream',
                              cursorclass=pymysql.cursors.DictCursor)
    except RuntimeError:
        # If connection fails due to user/pass, print error and exit python program
        print("Incorrect username or password entered. Exiting program.")
        sys.exit()  # terminate program
    except pymysql.err.OperationalError:
        # If connection fails due to connection failure, print error and exit python program
        print("Failed to connect to database. Exiting program.")
        sys.exit()  # terminate program
    # If connection successful, create cursor object
    cur = cnx.cursor()


    # assign current user id to object for later usage
    #current_user_id = home_screen(cur)

    user_id = 1
    main_menu(cur, user_id)





    # Close the connection to the database and end the application program.
    #cnx.commit()
    cur.close()
    cnx.close()

main()

