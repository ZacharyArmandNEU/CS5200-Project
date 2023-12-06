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
        match user_choice.lower():
            case '1' | 'explore':
                view_menu(cur, user_id)
            case '2' | 'submit rating':
                submit_rating(cur, user_id)
            case '3' | 'search':
                search_menu(cur, user_id)
            case '4' | 'edit review':
                edit_rating(cur, user_id)
            case '5' | 'edit user':
                edit_user(cur, user_id)
            case '6' | 'quit':
                print("Exiting application")
                sys.exit()
            case _:
                print("Invalid choice")



def search_menu(cur, user_id):

    # print main message
    while True:
        # ask user for their choice
        user_choice = input("Enter to search:\n   1 | flavors by company\n   2 | companies by flavor\n   3 | ratings "
                            "by company\n   4 | ratings by flavor\n   5 | flavors by base\n   6 | flavors by mix in\n "
                            "  7 | quit to menu\n")
        # run search network utility
        match user_choice.lower():
            case '1':
                chain_id = validate_company_choice(cur)
                # searh....
            case '2':
                flavor_name = validate_flavor_choice(cur)
            case '3':
                chain_id = validate_company_choice(cur)
            case '4':
                flavor_name = validate_flavor_choice(cur)
            case '5':
                pass ###############for now.......
            case '6':
                pass  ###############for now.......
            case '7' | 'quit':
                return 0
            case _:
                print("Invalid choice")

def validate_company_choice(cur):

    query = f"SELECT chain_ID, brand_name FROM chains;"
    cur.execute(query)

    results = [x for x in cur.fetchall()]
    chains = [str(x.get('chain_ID')) for x in results]
    formatted_entries = [f"{x.get('brand_name')}: {x.get('chain_ID')}" for x in results]
    # Print each entry on a new line
    print("Brand name: chain_ID")
    for formatted_entry in formatted_entries:
        print(formatted_entry)

    # ask for user input
    while True:
        chain_id = input("Enter a chain_ID from the above: ")
        if chain_id in chains:
            return chain_id


def validate_flavor_choice(cur):

    query = f"SELECT DISTINCT flavor_name FROM flavors;"
    cur.execute(query)

    results = [x.get('flavor_name') for x in cur.fetchall()]
    # Print each entry on a new line
    print("Flavors: ")
    for each in results:
        print(each)

    # ask for user input
    while True:
        flavor_name = input("Enter a flavor from the above: ")
        if flavor_name in results:
            return flavor_name



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

