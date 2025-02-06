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

        create_price_sensor(price_data)
        create_relay_sensor(relay_data)
        create_weather_sensor(weather_data)
    
    except Exception as e:
        print(f"Error parsing message: {e}")


def create_weather_sensor(weather_data):
    weather_entity_id = "weather.forecast"
    url = f"{HOME_ASSISTANT_API}/api/states/{weather_entity_id}"

    payload = {
        "state": weather_data['weatherDataArray'][0]['temperature'],
        "attributes": {
            "friendly_name": "Weather Forecast",
            "temperature_unit": weather_data['temperatureUnit'],
            "postal_code": weather_data['postalCode'],
            "latitude": weather_data['latitude'],
            "longitude": weather_data['longitude'],
            "forecast": weather_data['weatherDataArray']
        }
    }
    send_request(url, payload)

def create_price_sensor(price_data):
    price_entity_id =  "price.forecast"
    url = f"{HOME_ASSISTANT_API}/api/states/{price_entity_id}"
    
    payload = {
        "state": price_data['priceDataArray'][0]['data']['price'],
        "attributes": {
            "friendly_name": "Prices:",
            "price": price_data['priceDataArray'],
            "unit_of_measurement": price_data['priceUnit']
        }
    }
    send_request(url, payload)

def create_relay_sensor(relay_data):

    for relay in relay_data:
        url = f"{HOME_ASSISTANT_API}/api/states/{f"relay.{relay['relay_name']}"}"
        payload = {
            "state": relay,
            "attributes": {
                "friendly_name": relay['relay_name'],
                "relay_mode": relay['mode'],
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