Zachary Armand
CS 5200
Final Project
Instructions for downloading database and running python script.


Required python 3 packages: 
	- pymysql
	- sys
Included files in zip package:
	- ArmandZ.py
	- ArmandZ.sql
	- edit_functions.py
	- home_menu.py
	- search_functions.py
	- view_functions.py

Instructions: 
1) Unpack zip file and download files to chosen directory. Make sure all python files listed above are included. All python files except "ArmandZ.py" are support files. Only "ArmandZ.py" runs the application
2) Open ArmandZ.sql in database client. Run file to import database dump for `new_england_ice_cream` database.
3) Determine local database host, username, and password for use in python script. You can find the host name by running the following command in your SQL client: 
	SHOW VARIABLES WHERE Variable_name = 'hostname';
4) Make sure that python3 instance is installed on your machine with packages listed above installed. Instructions can be found online.
5) Run python file 'ArmandZ.py'. All examples below are using MacOS Terminal commands, but steps should be the same regardless of OS.
	a. Make sure that MySQL database connection containing imported `new_england_ice_cream ` is running.
	b. Make sure that required packages are installed in python.
	c. Open command line/terminal
	d. Change directory to directory containing python file:
		'cd <folder name>'
	e. Run python file. Individual commands may vary based on your installation, such as "python" or "python3", etc.:
		'python ArmandZ.py'
	f. When prompted, enter the correct host, username, and password for your MySQL database connection. 
6) Follow prompts. Application will terminate upon user prompting script to exit.
