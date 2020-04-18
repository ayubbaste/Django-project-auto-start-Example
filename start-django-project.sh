#!/bin/sh

# In order to make this script a Terminal command (os x Catalina),
# you need to add an alias to the . ~/.zshrc file.
# alias start-project="source ~/way/to/path/.start-django-project.sh"

start-django-project() {
	# Request all necessary information
	echo 'Destination full path: '
	read destination
	echo 'Project name: '
	read project_name
	echo 'SuperUser Email: '
	read email
	echo 'SuperUser Username: '
	read username
	echo 'SuperUser Password: '
	read password

	# Go to destination folder
	cd $destination

	# Create new project folder
	mkdir $project_name
	echo $project_name folder created

	# Go to main project folder
	cd $project_name

	# Virtual inviroment "env"
	virtualenv env
	echo Virtual environment env created

	# Activate virtual inviroment
	. ./env/bin/activate
	echo Virtual environment is activated
	
	# Install Django
	pip install django
	echo Django installed

	# Install iPython
	pip install ipython
	echo iPython installed

	# Start new Django project
	django-admin startproject project
	echo Django project started

	# Go to Django project folder
	cd project

	# Create SQL data base
	python manage.py migrate
	echo Django Data Base created

	# Create Django super user
	echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('"$username"', '"$email"', '"$password"')" | python manage.py shell
	echo Django Super User created

	# Deactivate virtual inviroment
	deactivate

	# Open new Terminal tab
	# Open project folder in Sublime text editor
	# Launch web browser with development server adress.
	# Close Terminal tab
	osascript -e "
		tell application \"Terminal\"
		set currentTab to do script \"open -a 'Sublime Text' $destination/$project_name\"
		do script \"open '/Applications/Firefox.app' --args 'http://127.0.0.1:8000/'\" in currentTab
		delay 5
		close first window
	end tell"

	# Go to main project folder
	cd $destination/$project_name/

	# Activate virtual inviroment
	. ./env/bin/activate

	# Go to Django project folder
	cd project

	# Run development server
	python manage.py runserver
}
start-django-project