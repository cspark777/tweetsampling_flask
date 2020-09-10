from flask import render_template, url_for, flash, request, redirect, Blueprint, jsonify
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

page = Blueprint('page', __name__)
mydb = mysql.connector.connect(
    host=settings.MYSQL_HOST,
    user=settings.MYSQL_USER,
    passwd=settings.MYSQL_PASSWORD,
    database=settings.MYSQL_DATABASE,
    charset = 'utf8'
)

countries = dict(countries_for_language('en'))

def log_message(message):
    #print(message)
    
    hs = open("web_log.txt","a", encoding="utf8")
    hs.write(message + "\n")
    hs.close() 

def init_chart_data(keyword):
    global countries

    chart_data = {}

    #--- for line chart
    line_chart_data = []
    current_time = datetime.datetime.utcnow()
    current_time = current_time.strftime('%Y-%m-%d %H:%M:00')
    
    year1 = current_time[0:4]
    month1 = current_time[5:7]
    day1 = current_time[8:10]
    hour1 = current_time[11:13]
    minutes1 = current_time[14:16]

    current_time = datetime.datetime(int(year1), int(month1), int(day1), int(hour1), int(minutes1), tzinfo=datetime.timezone.utc)
    
    current_time = datetime.datetime(2020, 9, 9, 4, 30, tzinfo=datetime.timezone.utc)
    #print(current_time)
    
    query = ""
    for i in range(20):
        delta = 19 - i
        dt = current_time - datetime.timedelta(minutes=delta)        
        sec = int(dt.timestamp()) * 1000  

        #print(sec)     

        if keyword != "":
            query = query + "(SELECT {} as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='{}' AND created_at < date_sub('{}',INTERVAL {} MINUTE) AND created_at>=date_sub('{}', INTERVAL {} MINUTE))".format(sec, keyword, current_time, delta, current_time, delta+1) + " UNION "
        else:
            query = query + "(SELECT {} as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE created_at < date_sub('{}',INTERVAL {} MINUTE) AND created_at>=date_sub('{}', INTERVAL {} MINUTE))".format(sec, current_time, delta, current_time, delta+1) + " UNION "

    query = query[0:-7]
    #print(query)
    #exit()
    if mydb.is_connected():
        mycursor = mydb.cursor()        
        mycursor.execute(query)
        graph_data = mycursor.fetchall()   
        mycursor.close()  

        for one in graph_data:
            data = {"date":one[0], "negative":int(one[1]), "neutral":int(one[2]), "positive":-int(one[3])}
            line_chart_data.append(data)
    else:
        log_message("--- {} : MySQL error : init line chart data error".format(current_time))
        for i in range(20):
            delta = 19 - i
            dt = current_time - datetime.timedelta(minutes=delta)        
            sec = int(dt.timestamp()) * 1000
            negative = random.randint(1,20)
            neutral = random.randint(50,100)
            positive = random.randint(1,20)
            data = {"date":sec, "negative":negative, "neutral":neutral, "positive":-positive}
            line_chart_data.append(data)

    chart_data["line_chart_data"] = line_chart_data
    
    #--- for pie chart
    dt = current_time         
    sec = int(dt.timestamp()) * 1000
    data = get_pie_chart(sec, keyword)
    chart_data["pie_chart_data"] = data

    #--- for bar chart
    bar_chart_data = get_bar_chart(sec, keyword)
    chart_data["bar_chart_data"] = bar_chart_data

    #--- for world chart
    world_chart_data = get_world_chart(sec, keyword)
    chart_data["world_chart_data"] = world_chart_data

    return chart_data

def get_line_chart(next_time, keyword):    
    next_time_obj = datetime.datetime.utcfromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")
    #print(next_time_str)
    
    if keyword == "":
        query = "(SELECT {} as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE created_at < date_sub('{}',INTERVAL {} MINUTE) AND created_at>=date_sub('{}', INTERVAL {} MINUTE))".format(next_time, next_time_str, 0, next_time_str, 1)
    else:
        query = "(SELECT {} as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='{}' AND created_at < date_sub('{}',INTERVAL {} MINUTE) AND created_at>=date_sub('{}', INTERVAL {} MINUTE))".format(next_time, keyword, next_time_str, 0, next_time_str, 1)

    if mydb.is_connected():
        mycursor = mydb.cursor()        
        mycursor.execute(query)
        graph_data = mycursor.fetchone()   
        mycursor.close() 

        data = {"date":next_time, "negative":int(graph_data[1]), "neutral":int(graph_data[2]), "positive":-int(graph_data[3])}
    else:
        log_message("--- {} : MySQL error : init line chart data error".format(next_time_str))
        negative = random.randint(1,20)
        neutral = random.randint(50,100)
        positive = random.randint(1,20)
        data = {"date":next_time, "negative":negative, "neutral":neutral, "positive":-positive}
    return data

def get_pie_chart(next_time, keyword):
    return get_line_chart(next_time, keyword)

def get_bar_chart(next_time, keyword):
    next_time_obj = datetime.datetime.utcfromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")

    bar_chart_data = []    
    if keyword != "":
        query = "SELECT country_code, COUNT(tweet_id) cc FROM tweets WHERE keyword='{}' AND created_at < '{}' AND created_at>=date_sub('{}', INTERVAL 1 MINUTE) GROUP BY country_code ORDER BY cc DESC LIMIT 0, 10".format(keyword, next_time_str, next_time_str)
    else:
        query = "SELECT country_code, COUNT(tweet_id) cc FROM tweets WHERE created_at < '{}' AND created_at>=date_sub('{}', INTERVAL 1 MINUTE) GROUP BY country_code ORDER BY cc DESC LIMIT 0, 10".format(keyword, next_time_str, next_time_str)

    if mydb.is_connected():
        mycursor = mydb.cursor()        
        mycursor.execute(query)
        graph_data = mycursor.fetchall()   
        mycursor.close() 
        for one in graph_data:
            data = {"country": one[0], "value":one[1]} 
            bar_chart_data.append(data)
    else:
        log_message("--- {} : MySQL error : Get bar chart data error".format(next_time_str))
        country_list = ['us', 've', 'ph', 'mx', 'ca', 'id', 'in', 'au', 'br', 'co']
        for i in range(10):
            data = {"country": countries[country_list[i].upper()], "value":random.randint(1,100)}
            bar_chart_data.append(data)
        
    return bar_chart_data

def get_world_chart(next_time, keyword):
    next_time_obj = datetime.datetime.utcfromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")

    world_chart_data = []    
    if keyword != "":
        query = "SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets WHERE keyword='{}' AND created_at<'{}' GROUP BY country_code ORDER BY cc".format(keyword, next_time_str)
    else:
        query = "SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets AND created_at<'{}' GROUP BY country_code ORDER BY cc".format(next_time_str)

    #print(query)

    if mydb.is_connected():
        mycursor = mydb.cursor()        
        mycursor.execute(query)
        graph_data = mycursor.fetchall()   
        mycursor.close() 
        for one in graph_data:
            data = {"id": one[0], "value":one[1]} 
            world_chart_data.append(data)
    else:
        log_message("--- {} : MySQL error : Get world chart data error".format(next_time_str))
        country_list = ['US', 'VE', 'PH', 'MX', 'CA', 'ID', 'IN', 'AU', 'BR', 'CO']
        for i in range(10):
            data = {"id": countries[country_list[i].upper()], "value":random.randint(1,100)}
            world_chart_data.append(data)
        
    return world_chart_data


def get_chart(next_time, keyword):
    chart_data = {}

    line_chart_data = get_line_chart(next_time, keyword)
    chart_data["line_chart_data"] = line_chart_data

    pie_chart_data = get_pie_chart(next_time, keyword)
    chart_data["pie_chart_data"] = pie_chart_data

    bar_chart_data = get_bar_chart(next_time, keyword)
    chart_data["bar_chart_data"] = bar_chart_data

    world_chart_data = get_world_chart(next_time, keyword)
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
