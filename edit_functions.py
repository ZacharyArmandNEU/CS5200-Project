"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Functions for running functions that Update or Delete
"""

import pymysql
from view_functions import view_user_rating  # file included with this project


def edit_user(cur, cnx, user_id):
    """
    Function to edit user information
    :param cnx: pymysql connection
    :param cur: current pymysql cursor object
    :param user_id: current user ID for session
    :return: None, exits function when successful
    """

    # make sure user_id is integer
    user_id = int(user_id)

    try:
        query = f"CALL user_information({user_id});"
        cur.execute(query)
    except pymysql.err.OperationalError:
        print("Passed user does not exist")
        return None  # exit if user doesn't exist
    # print user information for user
    rows = cur.fetchone()
    print("User information")
    # print all information
    for key, value in rows.items():
        print(f'{key}: {value}')
    print('')

    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 | to edit email\n   2 | to edit first name\n"
                            "   3 | to edit last name\n   4 | to return to menu\n")
        # get user input and match choice
        new_email, new_first, new_last = None, None, None
        match user_choice.lower():
            case '1' | 'email':
                new_email = input("Enter new email (spaces will be stripped): ").replace(' ', '')
            case '2' | 'first name':
                new_first = input("Enter new first name: ")
            case '3' | 'last name':
                new_last = input("Enter new last name: ")
            case '4' | 'quit':
                return None
            case _:
                print("Invalid input")

        # validate input
        pass_input_val = False
        for each in [new_email, new_first, new_last]:
            if each is not None:  # meaning, this is the one with input
                if len(each) > 32:
                    print("Input over 32 characters. Please retry.")
                    pass_input_val = False
                elif len(each) == 0 or each.isspace():
                    print("Input is blank. Please retry.")
                    pass_input_val = False
                else:
                    pass_input_val = True
        if pass_input_val:
            try:
                # update user information (procedure deals with NULL values)
                query = "CALL update_user(%s, %s, %s, %s)"
                cur.execute(query, (user_id, new_email, new_first, new_last))
                cnx.commit()
                print("User information updated.")
                return None
            except pymysql.err:
                print("Error occurred Exiting to main menu.")
                return None


def edit_rating(cur, cnx, user_id):
    """
    Function to edit user ratings based on input
    :param cnx: pymysql connection
    :param cur: current pymysql cursor object
    :param user_id: current user ID for session
    :return: None, exits when successful
    """

    # make sure user_id is integer
    user_id = int(user_id)
    # print all ratings by that user
    view_user_rating(cur, user_id)
    # fetch all valid rating IDs from user for data validation
    try:
        query = f"CALL rating_id_user('{user_id}');"
        cur.execute(query)
    except pymysql.err:
        print("Error occurred Exiting to main menu.")
        return None
    valid_ids = [str(x.get("rating_ID")) for x in cur.fetchall()]

    # check first if they have any reviews
    if len(valid_ids) == 0:
        print("You have not left any ratings")
        return None

    # ask which ID to edit
    rate_to_edit = input("Which review ID would you like to edit? ")
    while rate_to_edit not in valid_ids:
        print("Invalid ID")
        rate_to_edit = input("Which review ID would you like to edit? ")

    # ask what aspect of review to edit
    while True:
        # ask user for their choice
        user_choice = input("Enter:\n   1 | edit stars\n   2 | edit remarks\n   3 | delete review\n   "
                            "4 | return to menu\n")
        # get user input
        new_stars, new_remarks, = None, None
        match user_choice.lower():
            case '1' | 'stars':
                new_stars = input("Enter new rating (1-5): ")
                # validate user input
                while new_stars not in ['1', '2', '3', '4', '5']:
                    new_stars = input("Invalid input. Please enter rating between 1 and 5: ")
                break
            case '2' | 'remarks':
                new_remarks = input("Enter new remarks: ")
                break
            case '3' | 'delete':
                try:
                    query = f"CALL delete_rating('{rate_to_edit}')"
                    cur.execute(query)
                    # commit changes to database
                    cnx.commit()
                except pymysql.err:
                    print("Error occurred Exiting to main menu.")
                    return None
                # print success message
                print(f"Review {rate_to_edit} deleted.")
                # deletion successful, exit function
                return None
            case '4' | 'quit':
                return None
            case _:
                print("Invalid input")

    try:
        # update user information (procedure deals with NULL values)
        query = "CALL update_ratings(%s, %s, %s)"
        cur.execute(query, (rate_to_edit, new_stars, new_remarks))
        # commit changes to database
        cnx.commit()
        print("Update successful")
        # exit upon success
        return None
    except pymysql.err:
        print("Error occurred Exiting to main menu.")
        return None


def get_filter_keyword():
    """
    Asks user what they want to filter flavors on
    :return: filter keyword, either 'flavor_name' or 'brand_name'
    """

    while True:
        filter_keyword = input("Enter\n   1 | filter by flavor\n   2 | filter by chain\n")
        # validate user input - don't allow options besides 1 or 2
        if filter_keyword not in ['1', '2']:
            print("Invalid input")
        else:
            # get filter criteria (predefined choices)
            if filter_keyword == '1':
                return 'flavor_name'
            elif filter_keyword == '2':
                return 'brand_name'


def get_filter_criteria(cur, filter_keyword):
    """
    Gets filter criteria from user
    :param cur: current pymysql cursor object
    :param filter_keyword:
    :return: filter_criteria
    """

    # execute query to show available filters
    try:
        query = "CALL filter_from_flavors(%s)"
        cur.execute(query, filter_keyword)
    except pymysql.err:
        print("Error occurred Exiting to main menu.")
        return None
    # get results in a list
    results = [x[filter_keyword] for x in cur.fetchall()]
    print("Filter options: ")
    print(', '.join(map(str, results)))
    # ask for user input
    while True:
        filter_criteria = input("Enter a filter from the above: ")
        # check that user input valid. If not, loop
        if filter_criteria in results:
            return filter_criteria


def ask_for_filter(cur):
    """
    Asks user if they wish to filter flavors.
        Creates query based on y/n response
    :param cur: current pymysql cursor object
    :return: query, string with query to execute to show flavors
    """

    # ask for filter criteria
    while True:
        rating_filter = input("Would you like to filter flavors? (Y/N): ").lower()
        if rating_filter not in ['y', 'n']:
            print("Invalid Input")
        else:
            break

    # get keyword and criteria for filter and construct queries
    if rating_filter == 'y':
        # user wishes to provide filter. Show options
        try:
            filter_keyword = get_filter_keyword()
            filter_criteria = get_filter_criteria(cur, filter_keyword)
            query = f"CALL show_flavors('{filter_keyword}', '{filter_criteria}');"
        except pymysql.err:
            print("Error occurred Exiting to main menu.")
            return None
    else:
        # query with no user input - just selecting all flavors
        query = "SELECT flavor_ID, flavor_name, ice_cream_type, brand_name\
                    FROM flavors \
                    JOIN chains ON flavors.chain_ID = chains.chain_ID;"
    return query


def submit_rating(cur, cnx, user_id):
    """
    Function to allow user to submit a rating of a flavor.
        Allows an option filtering to view rating options
    :param cnx: pymysql connection
    :param cur: current pymysql cursor object
    :param user_id: current user ID for session
    :return:
    """

    # ask user if they want to filter flavors
    query = ask_for_filter(cur)

    while True:
        try:
            cur.execute(query)
        except pymysql.err:
            print("Error occurred Exiting to main menu.")
            return None
        # get results into list and print
        results = [x for x in cur.fetchall()]
        print("All flavors: ")
        for each in results:
            for key in each.keys():
                print(key, ': ', each[key], sep='', end='. ')
            print('')
        print('')
        # ask for flavor_ID
        flavor_to_rate = input("What flavor would you like to rate (enter Flavor ID): ")
        # verify valid flavor ID
        flavor_ids = [str(x['flavor_ID']) for x in results]
        while flavor_to_rate not in flavor_ids:
            # invalid flavor entered. Ask again
            print("Invalid flavor entered")
            flavor_to_rate = input("What flavor would you like to rate (enter Flavor ID): ")
        try:
            # ask for components of rating
            rating_date = input("Enter date of reviews (YYYY-MM-DD): ")
            stars = input("Enter number of stars (1-5): ")
            # check that stars input is valid
            while stars not in ['1', '2', '3', '4', '5']:
                stars = input("Enter number of stars (1-5): ")
            remarks = input("Enter any remarks: ")

            # call procedure insert_rating
            call_insert_rating = "CALL insert_rating(%s, %s, %s, %s, %s)"
            cur.execute(call_insert_rating, (user_id, flavor_to_rate, rating_date, stars, remarks))
            # commit update
            cnx.commit()
            # at this point, success. Exit rating insert
            print("Review successfully submitted. Thanks!")
            return None

        except pymysql.err.OperationalError as error:
            # get specific error code
            error_code, _ = error.args
            if error_code == 1644:
                print('Review for this combination of userID and flavorID already exist.')
            elif error_code == 1411:
                print('Invalid date format. Please use YYYY-MM-DD.')
            else:
                print("An error occurred:", error)
            return -1
