import pymysql
import sys

# my files to support this project
from home_menu import home_screen



def main_menu():

    # print main message
    print("Welcome. Please choose an option.")
    user_id = -1
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to view network\n   2 to search network\n"
                            "3 to edit review\n   4 to edit user info\n   5 to quit\n")


        # run view network utility
        if (user_choice == '1') or (user_choice.lower() == "view"):
            user_id = login_user(cur)
        # run searh network utility
        elif (user_choice == '2') or (user_choice.lower() == "search"):
            user_id = register_user(cur)
        # run edit rating utility
        elif (user_choice == '3') or (user_choice.lower() == "edit review"):
            user_id = register_user(cur)
        # run edit user info utility
        elif (user_choice == '4') or (user_choice.lower() == "edit user"):
            user_id = register_user(cur)
        # quit system
        elif (user_choice == '5') or (user_choice.lower() == "quit"):
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
    current_user_id = home_screen(cur)


    main_menu()





    # Close the connection to the database and end the application program.
    cur.close()
    cnx.close()

main()

