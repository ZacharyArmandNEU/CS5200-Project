import pymysql
import sys

# my files to support this project
from home_menu import home_screen



def main_menu(cur, user_id):

    # print main message
    print("Welcome. Please choose an option.")
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to view network\n   2 to search network\n"
                            "   3 to edit review\n   4 to edit user info\n   5 to quit\n")

        # run view network utility
        if (user_choice == '1') or (user_choice.lower() == "view"):
            view_menu(cur, user_id)
        # run searh network utility
        elif (user_choice == '2') or (user_choice.lower() == "search"):
            user_id = register_user(cur)
        # run edit rating utility
        elif (user_choice == '3') or (user_choice.lower() == "edit review"):
            rating_update(cur, user_id)
        # run edit user info utility
        elif (user_choice == '4') or (user_choice.lower() == "edit user"):
            edit_user(cur, user_id)
        # quit system
        elif (user_choice == '5') or (user_choice.lower() == "quit"):
            print("Exiting application")
            sys.exit()
        else:
            print("Invalid choice")




def view_menu(cur, user_id):
    while True:
        # ask user for their choice
        user_choice = input("Enter to view:\n   1 All flavors\n   2 Avg. rating by chains\n   3 Avg. rating by flavor"
                            "4 Chains\n   5 Flavors by ingredient\n   6 Back to menu\n   7 Quit system\n")
        query = None
        match user_choice:
            case '1':
                ask = "All flavors"
                query = "SELECT flavor_name, ice_cream_type, brand_name\
                    FROM flavors \
                    JOIN chains ON flavors.chain_ID = chains.chain_ID ORDER BY brand_name;"
            case '2':
                ask = "Avg. rating by chains"
                query = "SELECT brand_name, AVG(CAST(stars AS float)) AS avg_stars\
                    FROM ratings\
                    JOIN chains ON ratings.brand = chains.chain_ID\
                    GROUP BY brand_name;"
            case '3':
                ask = "Avg. rating by flavor"
                query = "SELECT flavor_name, AVG(CAST(stars AS float)) AS avg_stars\
                    FROM ratings\
                    JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID\
                    GROUP BY flavor_name;"
            case '4':
                ask = "Chains"
                query = "SELECT brand_name FROM chains;"
            case '5':
                ask = "Flavors by ingredient"
                query = None ###########FIX THIS EVECNTUALLTY
            case '6':
                return None  # effectively exists view menu
            case '7':
                print("Exiting application")
                sys.exit()
            case _:
                print("Invalid choice")
        if query is not None:
            view_executor(cur, query, ask)

def view_executor(cur, query, ask):
    cur.execute(query)
    results = [x for x in cur.fetchall()]
    print(f"Results: {ask}")
    for each in results:
        for key in each.keys():
            print(each[key], end=' ')
        print('')
    print('')



def edit_user(cur, user_id):

    # make sure user_id is integer
    user_id = int(user_id)

    # print user information for user
    query = "SELECT * FROM users WHERE user_ID = user_id;"
    cur.execute(query)
    rows = cur.fetchone()
    print("User information")
    for key, value in rows.items():
        print(f'{key}: {value}')
    print('')

    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to edit email\n   2 to edit first name\n"
                            "   3 to edit last name\n   4 to return to menu\n")
        # get user input
        new_email, new_first, new_last = None, None, None
        match user_choice.lower():
            case '1' | 'email':
                new_email = input("Enter new email: ")
            case '2' | 'first name':
                new_first = input("Enter new first name: ")
            case '3' | 'last name':
                new_last = input("Enter new last name: ")
            case '4' | 'quit':
                return 0

        # update user information (procedure deals with NULL values)
        query = "CALL update_user(%s, %s, %s, %s)"
        cur.execute(query, (user_id, new_email, new_first, new_last))
        return 0




def rating_update(cur, user_id):
    # make sure user_id is integer
    user_id = int(user_id)

    # print ratings for user
    query = f"SELECT rating_ID, rating_date, stars, remarks, flavor_name, brand_name\
        FROM ratings\
        JOIN chains ON chains.chain_ID = ratings.brand\
        JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID WHERE user_ID = {user_id};"
    cur.execute(query)
    rows = cur.fetchall()
    print("Your ratings: ")
    for row in rows:
        for key, value in row.items():
            print(f'{key}: {value}')
        print("")

    # fetch all valid rating IDs from user for data validation
    query = f"SELECT rating_ID FROM ratings WHERE user_ID = {user_id};"
    cur.execute(query)
    valid_IDs = [str(x.get("rating_ID")) for x in cur.fetchall()]

    # check first if they have any reviews
    if len(valid_IDs) == 0:
        print("You have not left any ratings")
        return 0

    # ask which ID to edit
    rate_to_edit = input("Which review ID would you like to edit? ")
    while rate_to_edit not in valid_IDs:
        print("Invalid ID")
        rate_to_edit = input("Which review ID would you like to edit? ")

    # ask what aspect of review to edit
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 to edit stars\n   2 to edit remarks\n   3 to return to menu\n")
        # get user input
        new_stars, new_remarks, = None, None
        match user_choice.lower():
            case '1' | 'stars':
                new_stars = input("Enter new rating (1-5): ")
            case '2' | 'remarks':
                new_remarks = input("Enter new remarks: ")
            case '3' | 'quit':
                return 0

        # update user information (procedure deals with NULL values)
        query = "CALL update_ratings(%s, %s, %s)"
        cur.execute(query, (user_id, new_stars, new_remarks))
        return 0


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

