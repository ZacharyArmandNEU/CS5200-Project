import pymysql
import sys



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
                return 0
            case _:
                print("Invalid choice")



def flavors_by(cur, base_or_mixin):
    # 'base' or 'mixins'
    if base_or_mixin == 'base':
        try:
            # display all options
            cur.execute("SELECT base_name FROM base;")
            options = [x.get('base_name') for x in cur.fetchall()]
            print("Options: ", ', '.join(options))

            choice = input("Enter search term: ")

            query = f"CALL flavors_by_base('{choice}')"
            cur.execute(query)
            key = 'mixins'
        except pymysql.err.OperationalError:
            print("Base not found")
            return 0
    elif base_or_mixin == 'mixins':
        try:
            # display all options
            cur.execute("SELECT mixin_name FROM mixin;")
            options = [x.get('mixin_name') for x in cur.fetchall()]
            print("Options: ", ', '.join(options))

            choice = input("Enter search term (can enter None for no mixins): ")

            query = f"CALL flavors_by_mixin('{choice}')"
            cur.execute(query)
            key = 'base'
        except pymysql.err.OperationalError:
            print("Mixin not found")
            return 0
    else:
        return 0

    results = cur.fetchall()
    print("Results: ")
    for each in results:
        print(f"Flavor: {each['flavor_name']}, Brand: {each['brand_name']}, {key.capitalize()}: {each[key]}")
    print("")


def rating_search(cur, search_criteria, search_term):

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

    if search_criteria == 'chain_ID':
        query = f"SELECT brand_name FROM chains WHERE chain_ID = {search_term}"
        cur.execute(query)
        filter_term = cur.fetchone()['brand_name']


    query = f"SELECT flavor_name, ice_cream_type, in_stock FROM flavors WHERE {search_criteria} = {search_term};"
    cur.execute(query)

    print(f"All flavors by {filter_term}:")
    results = [x.get('flavor_name') for x in cur.fetchall()]
    # Print each entry on a new line
    print("Flavors: ")
    for each in results:
        print(each)
    print('')


def company_search(cur, search_criteria, search_term):

    query = f"SELECT DISTINCT brand_name FROM flavors JOIN chains ON chains.chain_ID = flavors.chain_ID WHERE {search_criteria} = '{search_term}';"
    cur.execute(query)

    #print(f"All flavors by {filter_term}:")
    results = [x.get('brand_name') for x in cur.fetchall()]
    # Print each entry on a new line
    print(f"Chains carrying {search_term}:")
    for each in results:
        print(each)
    print('')


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

