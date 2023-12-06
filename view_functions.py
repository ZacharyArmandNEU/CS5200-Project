import pymysql
import sys


def view_user_rating(cur, user_id):
    # view all ratings by one user
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

def view_menu(cur, user_id):
    while True:
        # ask user for their choice
        user_choice = input("Enter to view:\n   1 | Avg. rating by chains\n   2 | Avg. rating by flavor\n"
                            "   3 | All chains\n   4 | All your reviews\n   5 | Back to menu\n   6 | Quit system\n")
        query = None
        match user_choice:
            case '1':
                ask = "Avg. rating by chains"
                query = "SELECT brand_name, AVG(CAST(stars AS float)) AS avg_stars\
                    FROM ratings\
                    JOIN chains ON ratings.brand = chains.chain_ID\
                    GROUP BY brand_name;"
            case '2':
                ask = "Avg. rating by flavor"
                query = "SELECT flavor_name, AVG(CAST(stars AS float)) AS avg_stars\
                    FROM ratings\
                    JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID\
                    GROUP BY flavor_name;"
            case '3':
                ask = "All chains"
                query = "SELECT brand_name FROM chains;"
            case '4':
                print("Results: All your reviews")
                view_user_rating(cur, user_id)
                return 0
            case '5':
                return None  # effectively exists view menu
            case '6':
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

