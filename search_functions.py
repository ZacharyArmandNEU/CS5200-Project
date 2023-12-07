"""
Zachary Armand
CS 5200
Final Project
December 7, 2023
Functions for running 'search' choice in main menu
"""

import pymysql


def search_menu(cur):
    """
    Displays search menu and runs function based on user input
    :param cur: current pymysql cursor object
    :return: None, runs functions until user quits
    """

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
                flavor_search(cur, 'chain_ID', chain_id)
            case '2':
                flavor_name = validate_flavor_choice(cur)
                company_search(cur, 'flavor_name', flavor_name)
            case '3':
                chain_id = validate_company_choice(cur)
                rating_search(cur, 'chain_ID', chain_id)
            case '4':
                flavor_name = validate_flavor_choice(cur)
                rating_search(cur, 'flavor_name', flavor_name)
            case '5':
                flavors_by(cur, 'base')
            case '6':
                flavors_by(cur, 'mixins')
            case '7' | 'quit':
                return None
            case _:  # invalid input
                print("Invalid choice")


def flavors_by(cur, base_or_mixin):
    """
    Searches for flavors by some criteria
    :param cur: current pymysql cursor object
    :param base_or_mixin: whether to search by flavor or mixin
    :return: None
    """

    # 'base' or 'mixins'
    if base_or_mixin == 'base':
        try:
            # display all options
            cur.execute("SELECT base_name FROM base;")  # no user input
            options = [x.get('base_name') for x in cur.fetchall()]
            print("Options: ", ', '.join(options))
            # ask user for search term
            choice = input("Enter search term: ")
            # execute query
            query = f"CALL flavors_by_base('{choice}')"
            cur.execute(query)
            key = 'mixins'
        except pymysql.err.OperationalError:
            print("Base not found")
            return None
    elif base_or_mixin == 'mixins':
        try:
            # display all options
            cur.execute("SELECT mixin_name FROM mixin;")
            options = [x.get('mixin_name') for x in cur.fetchall()]
            print("Options: ", ', '.join(options))
            # ask user for search term
            choice = input("Enter search term (can enter None for no mixins): ")
            # execute query
            query = f"CALL flavors_by_mixin('{choice}')"
            cur.execute(query)
            key = 'base'
        except pymysql.err.OperationalError:
            print("Mixin not found")
            return None
    else:
        return None
    # get and print all results
    results = cur.fetchall()
    print("Results: ")
    for each in results:
        print(f"Flavor: {each['flavor_name']}, Brand: {each['brand_name']}, {key.capitalize()}: {each[key]}")
    print("")


def rating_search(cur, search_criteria, search_term):
    """
    Search for ratings by criteria and terms
    :param cur: current pymysql cursor object
    :param search_criteria: search field to use
    :param search_term: search term to use for field
    :return: None, just prints
    """

    if search_criteria == 'chain_ID':
        query = f"SELECT brand_name FROM chains WHERE chain_ID = {search_term}"
        cur.execute(query)
        table = 'chains'
        filter_term = cur.fetchone()['brand_name']

    else:
        table = 'flavors'
        filter_term = search_term

    query = f"SELECT rating_ID, rating_date, stars, remarks, flavor_name, brand_name\
        FROM ratings\
        JOIN chains ON chains.chain_ID = ratings.brand\
        JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID \
        WHERE {table}.{search_criteria} = '{search_term}';"
    cur.execute(query)

    print(f"All ratings for {filter_term}:")

    rows = cur.fetchall()
    for row in rows:
        for key, value in row.items():
            print(f'{key}: {value}')
        print("")


def flavor_search(cur, search_criteria, search_term):
    """
    Search for flavors by criteria and terms
    :param cur: current pymysql cursor object
    :param search_criteria: search field to use
    :param search_term: search term to use for field
    :return: None, just prints
    """

    if search_criteria == 'chain_ID':
        query = f"SELECT brand_name FROM chains WHERE chain_ID = {search_term}"
        cur.execute(query)
        filter_term = cur.fetchone()['brand_name']

    query = f"SELECT flavor_name, ice_cream_type FROM flavors WHERE {search_criteria} = {search_term};"
    cur.execute(query)

    print(f"All flavors by {filter_term}:")
    results = [x.get('flavor_name') for x in cur.fetchall()]
    # Print each entry on a new line
    print("Flavors: ")
    for each in results:
        print(each)
    print('')


def company_search(cur, search_criteria, search_term):
    """
    Searches for company by criteria
    :param cur: current pymysql cursor object
    :param search_criteria: search field to use
    :param search_term: search term to use for field
    :return: None, just prints
    """

    query = "CALL show_brands(%s, %s);"
    cur.execute(query, (search_criteria, search_term))

    # print(f"All flavors by {filter_term}:")
    results = [x.get('brand_name') for x in cur.fetchall()]
    # Print each entry on a new line
    print(f"Chains carrying {search_term}:")
    for each in results:
        print(each)
    print('')


def validate_company_choice(cur):
    """
    Gets chain_id from user after displaying all choices
    :param cur: current pymysql cursor object
    :return: chain_id (INT)
    """

    # select all chain_ids and brand names
    query = f"SELECT chain_ID, brand_name FROM chains;"  # no user input
    cur.execute(query)
    # get results into printable format
    results = [x for x in cur.fetchall()]
    chains = [str(x.get('chain_ID')) for x in results]
    formatted_entries = [f"{x.get('brand_name')}: {x.get('chain_ID')}" for x in results]
    # print each entry on a new line
    print("Brand name: chain_ID")
    for formatted_entry in formatted_entries:
        print(formatted_entry)
    # ask for user input
    while True:
        chain_id = input("Enter a chain_ID from the above: ")
        if chain_id in chains:
            return chain_id


def validate_flavor_choice(cur):
    """
    Ask user to input flavor name from all in database
    :param cur: current pymysql cursor object
    :return: flavor_name (STR)
    """

    # select all distinct flavor names
    query = f"SELECT DISTINCT flavor_name FROM flavors;"  # no user input
    cur.execute(query)
    # get results into list
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
