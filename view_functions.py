import pymysql
import sys


def view_menu(cur, user_id):
    while True:
        # ask user for their choice
        user_choice = input("Enter to view:\n   1 All flavors\n   2 Avg. rating by chains\n   3 Avg. rating by flavor\n"
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

