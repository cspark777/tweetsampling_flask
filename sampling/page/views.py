from flask import render_template, url_for, flash, request, send_file, redirect, Blueprint, jsonify
from flask_login import current_user, login_required

import mysql.connector

import random
import string
import os, sys
from collections import deque
import settings

import calendar
from datetime import timezone 
import datetime
import time
import json
from country_list import countries_for_language

basedir = os.path.abspath(os.path.dirname(__file__))
page = Blueprint('page', __name__)

countries = dict(countries_for_language('en'))

def get_db():
    mydb = mysql.connector.connect(
        host=settings.MYSQL_HOST,
        user=settings.MYSQL_USER,
        passwd=settings.MYSQL_PASSWORD,
        database=settings.MYSQL_DATABASE,
        charset = 'utf8'
    )
    return mydb


def log_message(message):
    print(message)
    '''
    hs = open("web_log.txt","a", encoding="utf8")
    hs.write(message + "\n")
    hs.close() 
    '''

def init_chart_data(keyword):
    global countries

    chart_data = {}
    current_time = datetime.datetime.utcnow()
    current_time_str = current_time.strftime('%Y-%m-%d %H:%M:00')
    
    year1 = current_time_str[0:4]
    month1 = current_time_str[5:7]
    day1 = current_time_str[8:10]
    hour1 = current_time_str[11:13]
    minutes1 = current_time_str[14:16]

    current_time = datetime.datetime(int(year1), int(month1), int(day1), int(hour1), int(minutes1), tzinfo=datetime.timezone.utc)
    
    #current_time = datetime.datetime(2020, 9, 9, 4, 30, tzinfo=datetime.timezone.utc)
    current_time_str = current_time.strftime('%Y-%m-%d %H:%M:00')

    sec = int(current_time.timestamp()) * 1000  
    #print(current_time)

    line_chart_data = []
    pie_chart_data = {}
    bar_chart_data = []
    world_chart_data = []

    data = {}
    try:
        mydb = get_db()
        mycursor = mydb.cursor()    
        
        if keyword == "":
            keyword = "covid-19"
        mycursor.callproc("get_init_chart_data",(keyword, current_time_str, sec, 1, 3))  
        
        result = mycursor.stored_results()
        
        #--- for line chart          
        re = next(result)        
        graph_data=re.fetchall()                          
        
        for one in graph_data:
            data = {"date":one[0], "negative":int(one[1]), "neutral":int(one[2]), "positive":-int(one[3])}
            line_chart_data.append(data)   

        #--- for pie chart
        data["positive"] = -data["positive"]
        pie_chart_data = data

        #--- for bar chart
        re = next(result)
        graph_data = re.fetchall()   
            
        for one in graph_data:
            data = {"country": countries[one[0].upper()], "value":one[1]} 
            bar_chart_data.append(data)
        #--- for world chart
        re = next(result)
        graph_data = re.fetchall()               
        for one in graph_data:
            data = {"id": one[0], "value":one[1]} 
            world_chart_data.append(data)        
    except:
        log_message("--- {} : MySQL error : init chart data error".format(current_time))
        #--- line chart
        for i in range(60):
            delta = 59 - i
            dt = current_time - datetime.timedelta(minutes=delta)        
            sec = int(dt.timestamp()) * 1000
            negative = random.randint(1,20)
            neutral = random.randint(50,100)
            positive = random.randint(1,20)
            data = {"date":sec, "negative":negative, "neutral":neutral, "positive":-positive}
            line_chart_data.append(data)        
    
        #--- for pie chart
        data["positive"] = -data["positive"]
        pie_chart_data = data

        #--- for bar chart        
        country_list = ['us', 've', 'ph', 'mx', 'ca', 'id', 'in', 'au', 'br', 'co']
        for i in range(10):
            data = {"country": countries[country_list[i].upper()], "value":random.randint(1,100)}
            bar_chart_data.append(data)
    
        chart_data["bar_chart_data"] = bar_chart_data

        #--- for world chart        
        country_list = ['US', 'VE', 'PH', 'MX', 'CA', 'ID', 'IN', 'AU', 'BR', 'CO']
        for i in range(10):
            data = {"id": country_list[i].upper(), "value":random.randint(1,100)}
            world_chart_data.append(data)
    
    mycursor.close()
    mydb.close()

    chart_data["line_chart_data"] = line_chart_data
    chart_data["pie_chart_data"] = pie_chart_data
    chart_data["bar_chart_data"] = bar_chart_data
    chart_data["world_chart_data"] = world_chart_data

    return chart_data

def get_chart(next_time, keyword):
    chart_data = {}

    next_time_obj = datetime.datetime.utcfromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")

    line_chart_data = {}
    pie_chart_data = {}
    bar_chart_data = []
    world_chart_data = []

    try:
        mydb = get_db()
        mycursor = mydb.cursor()    
        
        if keyword == "":
            keyword = "covid-19"
        mycursor.callproc("get_realtime_chart_data",(keyword, next_time_str, 1, 3))  
        
        result = mycursor.stored_results()
        
        #--- for line chart          
        re = next(result)

        graph_data=re.fetchone()                          

        line_chart_data = {"date":next_time, "negative":int(graph_data[0]), "neutral":int(graph_data[1]), "positive":-int(graph_data[2])}  

        #--- for pie chart        
        pie_chart_data = {"date":next_time, "negative":int(graph_data[0]), "neutral":int(graph_data[1]), "positive":int(graph_data[2])}

        #--- for bar chart
        re = next(result)        
        graph_data = re.fetchall()   
        
        for one in graph_data:
            data = {"country": countries[one[0].upper()], "value":one[1]} 
            bar_chart_data.append(data)
        #--- for world chart
        re = next(result)        
        graph_data = re.fetchall()               

        for one in graph_data:
            data = {"id": one[0], "value":one[1]} 
            world_chart_data.append(data)
        
    except Exception as error:
        log_message("--- {} : MySQL error : realtime chart data error msg: {}".format(next_time_str, str(error)))
        negative = random.randint(1,20)
        neutral = random.randint(50,100)
        positive = random.randint(1,20)
        #--- for line chart
        line_chart_data = {"date":next_time, "negative":negative, "neutral":neutral, "positive":-positive}
        #--- for pie chart
        pie_chart_data = {"date":next_time, "negative":negative, "neutral":neutral, "positive":positive}
        #--- for bar chart
        country_list = ['us', 've', 'ph', 'mx', 'ca', 'id', 'in', 'au', 'br', 'co']
        for i in range(10):
            data = {"country": countries[country_list[i].upper()], "value":random.randint(1,100)}
            bar_chart_data.append(data)
        #--- for world chart
        country_list = ['US', 'VE', 'PH', 'MX', 'CA', 'ID', 'IN', 'AU', 'BR', 'CO']
        for i in range(10):
            data = {"id": country_list[i].upper(), "value":random.randint(1,100)}
            world_chart_data.append(data)
    mycursor.close()
    mydb.close()

    
    chart_data["line_chart_data"] = line_chart_data
    chart_data["pie_chart_data"] = pie_chart_data
    chart_data["bar_chart_data"] = bar_chart_data
    chart_data["world_chart_data"] = world_chart_data

    return chart_data
    
    
@page.route('/', methods=['GET', 'POST'])
def index():  
    f = open("tweet_key.txt", "r")
    search_words = f.read()

    chart_data = init_chart_data(search_words)
    chart_data = json.dumps(chart_data) 

    return render_template('index.html', chart_data=chart_data, keyword=search_words)

@page.route('/chart_data', methods=['POST'])
def chart_data():
    f = open("tweet_key.txt", "r")
    search_words = f.read()

    next_time = request.form.get("next_time")
    json_obj = get_chart(int(next_time), search_words)
    return jsonify(json_obj)

@page.route('/keyword', methods=['POST'])
def keyword():
    keyword = request.form.get("keyword")
    if keyword != "":
        f = open("tweet_key.txt", "w")
        f.write(keyword)
    return redirect("/", code=302)

@page.route("/downloadcsv")
def downloadcsv():    
    f = open("tweet_key.txt", "r")
    search_words = f.read()

    mydb = get_db()
    mycursor = mydb.cursor()  
    query = "SELECT * FROM tweets WHERE keyword='{}' ORDER BY created_at DESC LIMIT 0, 1000".format(search_words) 
    mycursor.execute(query)  
    csv_data = mycursor.fetchall()
    


    csv_header = 'keyword, tweet_id, username, polarity, subjectivity, location, country_code, created_at, full_text, cleaned_text, hash_tags, favorite_count, retweet_count, lang, user_mentions\n'

    file = open(basedir + "/data.csv", "w", encoding="utf8")
    file.write(csv_header)
    for row in csv_data:
        #print(row)
        csv_row = '{},{},{},{},{},"{}",{},{},"{}","{}","{}",{},{},{},{}'.format(row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], row[13], row[14], row[15])
        csv_row = csv_row.replace("\n", "") + "\n"

        file.write(csv_row)
    file.close()
    mycursor.close()
    mydb.close()  
    return send_file(basedir + '/data.csv',
                     mimetype='text/csv',
                     attachment_filename='data.csv',
                     as_attachment=True)
