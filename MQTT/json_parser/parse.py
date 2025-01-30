import os
import json
import paho.mqtt.client as mqtt
import requests

from dotenv import load_dotenv

load_dotenv()


MQTT_BROKER = os.getenv("MQTT_BROKER")
MQTT_TOPIC = os.getenv("MQTT_TOPIC")
HOME_ASSISTANT_API = os.getenv("HOME_ASSISTANT_URL")
HOME_ASSISTANT_TOKEN = os.getenv("HOME_ASSISTANT_TOKEN")

HEADERS = {"Authorization": f"Bearer {HOME_ASSISTANT_TOKEN}",
           "Content-Type": "application/json"}

def on_subscribe(client, userdata, mid, reason_code_list, properties):
    if reason_code_list[0].is_failure:
        print(f"Broker rejected you subscription: {reason_code_list[0]}")
    else:
        print(f"Broker granted the following QoS: {reason_code_list[0].value}")

def on_unsubscribe(client, userdata, mid, reason_code_list, properties):
    if len(reason_code_list) == 0 or not reason_code_list[0].is_failure:
        print("unsubscribe succeeded (if SUBACK is received in MQTTv3 it success)")
    else:
        print(f"Broker replied with failure: {reason_code_list[0]}")
    client.disconnect()



def on_message(client, userdata, message):
    print(message.payload)
    try:
        payload = message.payload.decode('utf-8').strip()



        json_data = json.loads(payload)
        parse_data(json_data)

    except json.JSONDecodeError as e:
        print("Error decoding JSON")
    except Exception as e:
        print("Error occuredc")


def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}. loop_forever() will retry connection")
    else:
        # we should always subscribe from on_connect callback to be sure
        # our subscribed is persisted across reconnections.
        client.subscribe(MQTT_TOPIC)


def parse_data(json_data):
    try:
        weather_data = json_data.get('weatherData', [])
        print("WEATHER DATA\n")
        print(weather_data)
        price_data = json_data.get('priceData', [])

        for weather in weather_data:
            time = weather['dateTime']
            temperature = weather['temperature']

            entity_id = f"weather_temperature_{time.replace(':', '_').replace(' ', '_')}"
            create_weather_sensor(entity_id, temperature, time)

    except Exception as e:
        print(f"Error parsing message: {e}")


def create_weather_sensor(entity_id, temperature, time):
    url = f"{HOME_ASSISTANT_API}/api/states/sensor.{entity_id}"

    payload = {
        "state": temperature,
        "attributes": {
            "friendly_name": f"Weather Temperature at {time}",
            "temperature": temperature,
            "forecast_time": time,
            "unit_of_measurement": "°C"
        }
    }
    payload_json = json.dumps(payload)

    response = requests.post(url, headers=HEADERS)
    print(response)



mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message
mqttc.on_subscribe = on_subscribe
mqttc.on_unsubscribe = on_unsubscribe

mqttc.user_data_set([])
mqttc.connect(MQTT_BROKER)
mqttc.loop_forever()



