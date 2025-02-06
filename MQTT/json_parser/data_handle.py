import os
import requests
from datetime import datetime

from dotenv import load_dotenv

load_dotenv()

HOME_ASSISTANT_API = os.getenv("HOME_ASSISTANT_URL")
HOME_ASSISTANT_TOKEN = os.getenv("HOME_ASSISTANT_TOKEN")


HEADERS = {"Authorization": f"Bearer {HOME_ASSISTANT_TOKEN}",
           "Content-Type": "application/json"}


def parse_data(json_data):
    try:
        weather_data = json_data.get('weatherData', [])
        price_data = json_data.get('priceData', [])
        relay_data = json_data.get('relayData', [])

        price_entity_id =  "price.forecast"
        #create_price_sensor(price_entity_id, price_data)

        relay_entity_id = "relay.data"
        create_relay_sensor(relay_entity_id, relay_data)


        #for price in price_data:
            #print(price)
            #time = price['data']['dateTime']
            #price = price['data']['price']
            #entity_id = f"price.{time.replace(':', '_').replace(' ', '_').replace('/', '_')}"
            #create_price_seonsor(entity_id, price, time)

        #for weather in weather_data:
         #   time = weather['dateTime']
         #   temperature = weather['temperature']

        #    entity_id = f"weather_temperature.{time.replace(':', '_').replace(' ', '_').replace('/', '_')}"
        #    
        # print(entity_id)
        entity_id = "weather.forecast"
        #create_weather_sensor(entity_id, weather_data)
    
    except Exception as e:
        print(f"Error parsing message: {e}")

                          #entity_id, temperature, time
def create_weather_sensor(entity_id, weather_data):
    url = f"{HOME_ASSISTANT_API}/api/states/{entity_id}"

    #iso_dates = [convert_to_iso(weather['dateTime']) for weather in weather_data]
   
    payload = {
        "state": weather_data[0]['temperature'],
        "attributes": {
            "friendly_name": f"Weather Temperature Forecast",
            "unit_of_measurement": "°C",
            "forecast_times": weather_data['dateTime'],
            "forecast_temperatures": [weather['temperature'] for weather in weather_data]
        }
    }
   
   #payload = {
    #    "state": temperature,
    #    "attributes": {
    #        "friendly_name": f"Weather Temperature at {time}",
    #        "temperature": temperature,
    #        "forecast_time": time,
    #        "unit_of_measurement": "°C"
    #    }
    #}

    send_request(url, payload)

def create_price_sensor(entity_id, price_data):
    url = f"{HOME_ASSISTANT_API}/api/states/{entity_id}"
    iso_dates = [convert_to_iso(price['data']['dateTime']) for price in price_data]
    
    payload = {
        "state": price_data[0]['data']['price'],
        "attributes": {
            "friendly_name": "Prices:",
            "price": [price['data']['price'] for price in price_data],
            "time": iso_dates,
            "unit_of_measurement": "€"
        }
    }
    send_request(url, payload)

def create_relay_sensor(entity_id, relay_data):

    #url = f"{HOME_ASSISTANT_API}/api/states/{entity_id}"

    
    print("DO I RUN CREATE RELAY SENSOR")
    for relay in relay_data:
        print(relay)
        url = f"{HOME_ASSISTANT_API}/api/states/{f"relay.{relay['relay_name']}"}"
        payload = {
            "state": relay,
            "attributes": {
                "friendly_name": "isOpen:",
                "mode": relay['mode'],
                "isOpen": relay['isOpen'],
                "price_threshold": relay['price_threshold'],
                "price_multiplier": relay['price_multiplier']
            }
        }
        send_request(url, payload)


def send_request(url, payload):
    print("SENDING DATA")
    response = requests.post(url, json=payload, headers=HEADERS)
    print(response)

def convert_to_iso(date_time_str):
    date_time_obj = datetime.strptime(date_time_str, "%d/%m/%Y %H:%M")
    return date_time_obj.isoformat()