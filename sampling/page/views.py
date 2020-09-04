from flask import render_template, url_for, flash, request, redirect, Blueprint
from flask_login import current_user, login_required

from sampling import db
from sampling.models import Html
from sampling.page.forms import HtmlForm

import random
import string

page = Blueprint('page', __name__)
mydb = mysql.connector.connect(
    host=settings.MYSQL_HOST,
    user=settings.MYSQL_USER,
    passwd=settings.MYSQL_PASSWORD,
    database=settings.MYSQL_DATABASE,
    charset = 'utf8'
)
g_update_interval_time = 10 #10 sec
g_x_axis_count = 180

g_graph1_data = {
                'y_positive': deque(maxlen=g_x_axis_count), 
                'y_negative': deque(maxlen=g_x_axis_count), 
                'y_neutral': deque(maxlen=g_x_axis_count),
                }

def generate_graph1_data():
    global mydb, g_graph1_data, g_update_interval_time
    
    time_now = datetime.utcnow()

    #print(time_now.strftime('%H:%M:%S'))

    time_interval_before = timedelta(hours=0, minutes=0, seconds=g_update_interval_time)

    time_interval = (time_now - time_interval_before).strftime('%Y-%m-%d %H:%M:%S')
    query = "SELECT SUM(IF(polarity=-1, 1, 0)) AS negative, SUM(IF(polarity=0, 1, 0)) AS neutral, SUM(IF(polarity=1, 1, 0)) AS positive FROM {} WHERE created_at >= '{}' ".format(settings.TABLE_NAME, time_interval)

    graph_data = None
    if mydb.is_connected():
        mycursor = mydb.cursor()        
        mycursor.execute(query)
        graph_data = mycursor.fetchall()   
        mycursor.close()   

    if graph_data[0][0] is None:
        graph_data[0] = (random.randint(1,20), random.randint(50,100), random.randint(1,20))

    #print(graph_data)

    t = int(round(time.time() * 1000))

    y_negative = {"t": t, "y": -graph_data[0][0]}
    y_neutral = {"t": t, "y": graph_data[0][1]}
    y_positive = {"t": t, "y": graph_data[0][2]}
    
    g_graph1_data["y_negative"].append(y_negative)    
    g_graph1_data["y_neutral"].append(y_neutral)
    g_graph1_data["y_positive"].append(y_positive)

    Timer(g_update_interval_time, generate_graph1_data).start()

def generate_graph_data():

#generate_graph1_data()

@core.route('/', methods=['GET', 'POST'])
def index():   

    json_obj = {"y_negative": list(g_graph1_data["y_negative"]), "y_neutral": list(g_graph1_data["y_neutral"]), "y_positive": list(g_graph1_data["y_positive"])}

    chart_data = json.dumps(json_obj)

    return render_template('index.html', form=form, chart_data=chart_data)
