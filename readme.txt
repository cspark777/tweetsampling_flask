1: install python libraries
pip3 install -r requirements.txt

2: database migration

flask db upgrade

3: create mysql database named twittersample, sql file is in this project.

4: run scraping module
python3 scraping2.py

5: run server

python3 app.py
