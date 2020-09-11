import tweepy, json
from tweepy.api import API
from textblob import TextBlob
import re

import config # Import api/access_token keys from credentials.py
import settings # Import related setting constants from settings.py 

from geopy.geocoders import Nominatim
from functools import partial

import mysql.connector
from datetime import timezone 
import datetime
import time


# Twitter API needs to be validated
auth  = tweepy.OAuthHandler(config.API_KEY, config.API_SECRET_KEY)
auth.set_access_token(config.ACCESS_TOKEN, config.ACCESS_TOKEN_SECRET)
api = tweepy.API(auth)

mydb = mysql.connector.connect(
    host=settings.MYSQL_HOST,
    user=settings.MYSQL_USER,
    passwd=settings.MYSQL_PASSWORD,
    database=settings.MYSQL_DATABASE,
    charset = 'utf8'
)

def log_message(message):
    print(message)
    
    hs = open("log.txt","a", encoding="utf8")
    hs.write(message + "\n")
    hs.close() 
    

def load_address_final_word_and_country_code(db):
    address_country_code = {}
    query = "SELECT * FROM address_country_code"

    if db.is_connected():
        mycursor = db.cursor()        
        mycursor.execute(query)
        address_data = mycursor.fetchall()   
        for address in address_data:
            address_country_code[address[1]] = address[2]   

        mycursor.close()  
    
    return address_country_code


def save_address_final_word_and_country_code(db, address_country_code):
    if db.is_connected():
        try:
            query = "DELETE FROM address_country_code"
            mycursor = db.cursor()        
            mycursor.execute(query)
            db.commit()
            mycursor.close()   
            
            mycursor = db.cursor()        
            query = "INSERT INTO address_country_code(address_final_word, country_code) VALUES "

            for address in address_country_code.keys():
                query = query + "('" + address + "', '" + address_country_code[address] + "'),"
            query = query[0:-1]
            mycursor.execute(query)
            db.commit()
            mycursor.close()
        except:
            log_message("--- MySQL save_address error=> " + query)


gb_insert_arr = []

def insert_tweet(db, keyword, tweet_id, username, polarity, location, country_code, created_at):
    global gb_insert_arr

    tmp = {"keyword": keyword, "tweet_id": tweet_id, "username": username, "polarity": polarity, "location": location, "country_code": country_code, "created_at": created_at}

    gb_insert_arr.append(tmp)

    if len(gb_insert_arr) > 100:
        query = "INSERT INTO tweets(keyword, tweet_id, username, polarity, location, country_code, created_at) VALUES "

        for r in gb_insert_arr:
            query = query + "('{}', '{}', '{}', '{}', '{}', '{}', '{}'),".format(r["keyword"], r["tweet_id"], r["username"], r["polarity"], r["location"], r["country_code"], r["created_at"])

        query = query[0:-1]        

        if db.is_connected():        
            try:
                mycursor = db.cursor()                        
                mycursor.execute(query)
                db.commit()
                mycursor.close()

                gb_insert_arr.clear()

            except Exception as error:
                log_message("--- MySQL insert_tweet error=>{}, sql=>{} ".format(str(error), query))


address_final_words = load_address_final_word_and_country_code(mydb)
init_address_final_words_len = len(address_final_words)

dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=3)
start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0] 

while(True):    
    today = start_time.split(" ")[0]
    f = open("tweet_key.txt", "r")
    search_words = f.read()

    len_address_final_words = len(address_final_words)

    if len_address_final_words > init_address_final_words_len:
        save_address_final_word_and_country_code(mydb, address_final_words)
        init_address_final_words_len = len_address_final_words

    log_message("=== while start => start_time:{}, today:{}, search_word:{}, len_address_final_word:{}".format(start_time, today, search_words, len_address_final_words))

    tweet_pages = tweepy.Cursor(api.search, q=search_words, since=today, tweet_mode='extended', count=100).pages()
    
    cc = 0
    cc_location = 0
    cc_coordinate = 0
    cc_place = 0

    first_time = ""

    is_process = True
    try:
        for page in tweet_pages:            
            log_message("--- New Page")
            for tweet in page:
                created_at = str(tweet.created_at)

                if first_time == "":
                    first_time = created_at

                if created_at < start_time:                
                    log_message("--- meet start time => start_time:{}, first_time:{}".format(start_time, first_time))
                    start_time = first_time
                    time.sleep(150)
                    is_process = False
                    break


                retweeted = tweet.retweeted
                if retweeted:
                    continue

                cc = cc + 1
                id_str = tweet.id_str
                username = tweet.user.screen_name
                text = tweet.full_text
                sentiment = TextBlob(text).sentiment
                polarity = sentiment.polarity
                subjectivity = sentiment.subjectivity
                if polarity < 0:
                    polarity = -1
                elif polarity > 0:
                    polarity = 1
                else:
                    polarity = 0

                
                lang = tweet.lang
                location = tweet.user.location
                coordinates = tweet.coordinates
                place = tweet.place


                lo = ""
                if location: 
                    cc_location = cc_location + 1
                    lo = location
                    try:
                        lo_words = lo.split(" ")
                        lo_words_len = len(lo_words)
                        final_word = lo_words[lo_words_len-1]
                        final_word = final_word.replace("'", "\\'")

                        if final_word in address_final_words.keys():
                            country_code = address_final_words[final_word]
                        else:

                            geolocator = Nominatim(user_agent="aaa")
                            geocode = geolocator.geocode(lo, addressdetails=True)
                            address = geocode.raw['address']
                            if address == None:
                                print("failed: ", lo)
                                continue
                            else:
                                country_code = address.get('country_code', '')
                                #print("-----", final_word, country_code)
                                address_final_words[final_word] = country_code 

                    except:
                        continue
                elif coordinates:
                    cc_coordinate = cc_coordinate + 1
                    lo = coordinates
                    continue
                elif place:
                    cc_place = cc_place + 1
                    lo = place.full_name
                    country_code = place.country_code
                else:
                    continue

                #log_message("--- tweet=>created_at:{}, tweet_id:{}, username:{}, cc:{}, lo:{}".format(created_at, id_str, username, country_code, lo))  

                lo = lo.replace("'", "\\'")  

                insert_tweet(mydb, search_words, id_str, username, polarity, lo, country_code, created_at)

                f = open("tweet_key.txt", "r")
                search_words1 = f.read()       
                if search_words != search_words1:
                    dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=5)
                    start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0]
                    log_message("--- Keyword changed, new key:{}".format(search_words1)) 
                    is_process = False
                    break            

            if is_process == False:
                break
            #print(time, username, lo, lang)
              
    except tweepy.TweepError as e:  
        log_message("--- tweepy error : " + e.reason)        
        time.sleep(900)
        dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=5)
        start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0]
        
    except StopIteration: #stop iteration when last tweet is reached
        log_message("--- end iterator =>start_time:{}, first_time:{}".format(start_time, first_time))
        start_time = first_time
        time.sleep(150)
        
        

