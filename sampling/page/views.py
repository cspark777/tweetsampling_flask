from flask import render_template, url_for, flash, request, redirect, Blueprint, jsonify
from flask_login import current_user, login_required

import mysql.connector

import random
import string
import os, sys
from collections import deque
import settings
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

def init_chart_data():
    global countries

    chart_data = {}

    #--- for line chart
    line_chart_data = []
    current_time = datetime.datetime.utcnow()

    for i in range(60):
        delta = 59 - i
        dt = current_time - datetime.timedelta(minutes=delta)
        calc_time = dt.strftime('%Y-%m-%d %H:%M:00')

        ti = time.strptime(calc_time, "%Y-%m-%d %H:%M:00")
                
        sec = int(time.mktime(ti)) * 1000

        negative = random.randint(1,20)
        neutral = random.randint(50,100)
        positive = random.randint(1,20)

        data = {"date":sec, "negative":negative, "neutral":neutral, "positive":-positive}
        line_chart_data.append(data)

    chart_data["line_chart_data"] = line_chart_data
    
    #--- for pie chart
    dt = current_time
    calc_time = dt.strftime('%Y-%m-%d %H:%M:00')

    ti = time.strptime(calc_time, "%Y-%m-%d %H:%M:00")                
    sec = int(time.mktime(ti)) * 1000
    negative = random.randint(1,20)
    neutral = random.randint(50,100)
    positive = random.randint(1,20)

    data = {"date":sec, "negative":negative, "neutral":neutral, "positive":positive}
    chart_data["pie_chart_data"] = data

    #--- for bar chart
    bar_chart_data = []
    dt = current_time
    calc_time = dt.strftime('%Y-%m-%d %H:%M:00')

    country_list = ['us', 've', 'ph', 'mx', 'ca', 'id', 'in', 'au', 'br', 'co']
    for i in range(10):
        data = {"country": countries[country_list[i].upper()], "value":random.randint(1,100)}
        bar_chart_data.append(data)
    chart_data["bar_chart_data"] = bar_chart_data


    return chart_data

def get_line_chart(next_time):    
    next_time_obj = datetime.datetime.fromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")
    
    negative = random.randint(1,20)
    neutral = random.randint(50,100)
    positive = random.randint(1,20)

    data = {"date":next_time, "negative":negative, "neutral":neutral, "positive":-positive}
    return data

def get_pie_chart(next_time):
    next_time_obj = datetime.datetime.fromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")
    
    negative = random.randint(1,20)
    neutral = random.randint(50,100)
    positive = random.randint(1,20)

    data = {"date":next_time, "negative":negative, "neutral":neutral, "positive":positive}
    return data

def get_bar_chart(next_time):
    bar_chart_data = []
    next_time_obj = datetime.datetime.fromtimestamp(next_time/1000.0)
    next_time_str = next_time_obj.strftime("%Y-%m-%d %H:%M:00")

    country_list = ['us', 've', 'ph', 'mx', 'ca', 'id', 'in', 'au', 'br', 'co']
    for i in range(10):
        data = {"country": countries[country_list[i].upper()], "value":random.randint(1,100)}
        bar_chart_data.append(data)
    
    return bar_chart_data


def get_chart(next_time):
    chart_data = {}

    line_chart_data = get_line_chart(next_time)
    chart_data["line_chart_data"] = line_chart_data

    pie_chart_data = get_pie_chart(next_time)
    chart_data["pie_chart_data"] = pie_chart_data

    bar_chart_data = get_bar_chart(next_time)
    chart_data["bar_chart_data"] = bar_chart_data

    return chart_data
    
    
@page.route('/', methods=['GET', 'POST'])
def index():  

    chart_data = init_chart_data()
    chart_data = json.dumps(chart_data) 

    return render_template('index.html', chart_data=chart_data)

@page.route('/chart_data', methods=['POST'])
def chart_data():
    next_time = request.form.get("next_time")
    json_obj = get_chart(int(next_time))
    return jsonify(json_obj)
