
def view_user_rating(cur, user_id):
    # view all ratings by one user
    query = f"CALL ratings_by_user('{user_id}');"  # already validated that user_id exists in DB
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
                            "   3 | All chains\n   4 | All your reviews\n   5 | Back to menu\n")
        query = None
        ask = ''
        match user_choice:
            case '1':
                ask = "Avg. rating by chains"
                query = "CALL ratings_by_chain();"
            case '2':
                ask = "Avg. rating by flavor"
                query = "CALL ratings_by_flavor();"
            case '3':
                ask = "All chains"
                query = "SELECT brand_name FROM chains;"  # simple SQL query with no user input
            case '4':
                print("Results: All your reviews")
                view_user_rating(cur, user_id)
                return 0
            case '5':
                return None  # effectively exists view menu
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
