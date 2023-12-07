"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Functions for running 'view' choice in main menu
"""

import pymysql


def view_user_rating(cur, user_id):
    """
    Gets and prints all ratings by a user
    :param cur: current pymysql cursor object
    :param user_id: current user ID for session
    :return: None, just prints
    """

    # pre-define values for procedure that won't change
    search_criteria = 'user_ID'
    table = 'ratings'
    # view all ratings by one user
    try:
        query = "CALL ratings_by_table(%s, %s, %s)"
        cur.execute(query, (table, search_criteria, user_id))
    except pymysql.err:
        print("Error occurred Exiting to main menu.")
        return None
    rows = cur.fetchall()
    # print all ratings
    print("Your reviews: ")
    for row in rows:
        for key, value in row.items():
            print(f'{key}: {value}')
        print("")


def view_menu(cur, user_id):
    """
    Gives user choices of functions to run from 'view' menu
    :param cur: current pymysql cursor object
    :param user_id: current user ID for session
    :return: None when user wishes to exit. Repeats until user chooses to exit
    """

    while True:
        # ask user for their choice
        user_choice = input("Enter to view:\n   1 | Avg. reviews by chains\n   2 | Avg. reviews by flavor\n"
                            "   3 | All chains\n   4 | All your reviews\n   5 | Back to menu\n")
        query = None  # query to execute using cursor
        ask = ''  # gets printed to show what user chose to do
        try:
            match user_choice:
                case '1':
                    ask = "Avg. reviews by chains"
                    query = "CALL ratings_by_chain();"
                case '2':
                    ask = "Avg. reviews by flavor"
                    query = "CALL ratings_by_flavor();"
                case '3':
                    ask = "All chains"
                    query = "SELECT brand_name FROM chains;"  # simple SQL query with no user input
                case '4':
                    # no query to execute
                    print("Results: All your reviews")
                    view_user_rating(cur, user_id)
                case '5':
                    # exit to main menu
                    return None
                case _:  # all other input (invalid)
                    print("Invalid choice")
            # run query if applicable
            if query is not None:
                view_executor(cur, query, ask)
        except pymysql.err:
            print("Error occurred Exiting to main menu.")
            return None


def view_executor(cur, query, ask):
    """
    Executes view operation based on given query
    :param cur: current pymysql cursor object
    :param query: query to run with cursor
    :param ask: what query is running (for printing results)
    :return: None, just prints
    """

    # execute query and get results into list
    cur.execute(query)
    results = [x for x in cur.fetchall()]
    # print results
    print(f"Results: {ask}")
    for each in results:
        for key in each.keys():
            print(each[key], end=' ')
        print('')
    print('')
