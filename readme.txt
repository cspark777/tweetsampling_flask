1: install python libraries
pip3 install -r requirements.txt

2: database migration

flask db upgrade

3: create mysql database named twittersample, sql file is in this project.

4: run scraping module
python3 scraping2.py

5: run server

python3 app.py

6: project file structure
config.py - there are twitter credential informations like token so on.
settings.py - there are mysql access information
scraping2.py - it is tweet scraping backend module.
sampling/ - there are website files.
sampling/models.py - it is for user management, and it is not used now, because there is no user feature in this project now.
sampling/page/view.py - it is main work file for website, there are functions to process webpage urls.
sampling/static - there are css, font, images and js for the website
sampling/templates - there are website page htmls.
