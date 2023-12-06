import pymysql
from view_functions import view_user_rating


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



def edit_rating(cur, user_id):
    # make sure user_id is integer
    user_id = int(user_id)

    # print all ratings by that user
    view_user_rating(cur, user_id)

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


def get_filter_keyword():

    # validate user input
    while True:
        filter_keyword = input("Enter\n   1 | filter by flavor\n   2 | filter by chain\n")
        if filter_keyword not in ['1', '2']:
            print("Invalid input")
        else:
            # get filter criteria
            if filter_keyword == '1':
                return 'flavor_name'
            elif filter_keyword == '2':
                return 'brand_name'


def get_filter_criteria(cur, filter_keyword):

    query = f"SELECT DISTINCT {filter_keyword}\
        FROM flavors \
        JOIN chains ON flavors.chain_ID = chains.chain_ID ORDER BY {filter_keyword};"
    cur.execute(query)
    results = [x[filter_keyword] for x in cur.fetchall()]
    print("Filter options: ")
    print(', '.join(map(str, results)))

    # ask for user input
    while True:
        filter_criteria = input("Enter a filter from the above: ")
        if filter_criteria in results:
            return filter_criteria


def submit_rating(cur, user_id):

    # ask for filter criteria
    while True:
        rating_filter = input("Would you like to filter ratings? (Y/N): ").lower()
        if rating_filter not in ['y', 'n']:
            print("Invalid Input")
        else:
            break

    # get keyword and criteria for filter
    if rating_filter == 'y':
        filter_keyword = get_filter_keyword()
        filter_criteria = get_filter_criteria(cur, filter_keyword)
        query_clause = f" HAVING {filter_keyword} = '{filter_criteria}' "
    else:
        query_clause = ''

    while True:
        # show flavors and companies
        query = "SELECT flavor_ID, flavor_name, ice_cream_type, brand_name\
            FROM flavors \
            JOIN chains ON flavors.chain_ID = chains.chain_ID" + \
            query_clause + ";"
        print(query)
        cur.execute(query)
        results = [x for x in cur.fetchall()]
        print("All flavors: ")
        for each in results:
            for key in each.keys():
                print(key, ': ', each[key], sep='', end='. ')
            print('')
        print('')

        flavor_to_rate = input("What flavor would you like to rate (enter Flavor ID): ")
        # ask for flavor_ID

        # verify valid flavor ID
        cur.execute("SELECT flavor_ID FROM flavors;")
        flavor_IDs = [str(x.get("flavor_ID")) for x in cur.fetchall()]
        while flavor_to_rate not in flavor_IDs:
            print("Invalid flavor entered")
            flavor_to_rate = input("What flavor would you like to rate (enter Flavor ID): ")

        try:
            # ask for components of rating
            rating_date = input("Enter date of rating (YYYY-MM-DD): ")
            stars = input("Enter number of stars (1-5): ")
            # check that stars input is valid
            while stars not in ['1', '2', '3', '4', '5']:
                stars = input("Enter number of stars (1-5): ")
            remarks = input("Enter any remarks: ")

            # Call procedure insert_rating
            call_insert_rating = f"CALL insert_rating('{user_id}', '{flavor_to_rate}', '{rating_date}', '{stars}', '{remarks}');"
            cur.execute(call_insert_rating)
            # at this point, success. Exit rating insert
            print("Rating successfully submitted. Thanks!")
            return None
        except pymysql.err.OperationalError:
            print("Rating for this combination of userID and flavorID already exist")
            return -1

        # submit another?
        while True:
            more_rating = input("Would you like to enter another rating (Y/N): ").lower()
            if more_rating == 'y':
                break
            elif more_rating == 'n':
                return 0
            else:
                print("Invalid Input")

