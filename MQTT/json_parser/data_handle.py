import os
import requests

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

        for price in price_data:
            print(price)
            time = price['data']['dateTime']
            price = price['data']['price']
            entity_id = f"price.{time.replace(':', '_').replace(' ', '_').replace('/', '_')}"
            create_price_seonsor(entity_id, price, time)

        for weather in weather_data:
            time = weather['dateTime']
            temperature = weather['temperature']

            entity_id = f"weather_temperature.{time.replace(':', '_').replace(' ', '_').replace('/', '_')}"
            print(entity_id)
            create_weather_sensor(entity_id, temperature, time)
    
    except Exception as e:
        print(f"Error parsing message: {e}")


def create_weather_sensor(entity_id, temperature, time):
    url = f"{HOME_ASSISTANT_API}/api/states/{entity_id}"
    print(entity_id)
    payload = {
        "state": temperature,
        "attributes": {
            "friendly_name": f"Weather Temperature at {time}",
            "temperature": temperature,
            "forecast_time": time,
            "unit_of_measurement": "°C"
        }
    }
    send_request(url, payload)

def create_price_seonsor(entity_id, price, time):
    url = f"{HOME_ASSISTANT_API}/api/states/{entity_id}"
    payload = {
        "state": price,
        "attributes": {
            "friendly_name": time,
            "price": price,
            "time": time,
            "unit_of_measurement": "€"
        }
    }
    send_request(url, payload)

def send_request(url, payload):
    print("SENDING DATA")
    response = requests.post(url, json=payload, headers=HEADERS)
    print(response)