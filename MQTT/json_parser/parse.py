import os
import json
import paho.mqtt.client as paho
import random

from dotenv import load_dotenv

load_dotenv()


MQTT_BROKER = os.getenv("MQTT_BROKER")
MQTT_TOPIC = os.getenv("MQTT_TOPIC")
HOME_ASSISTANT_API = os.getenv("HOME_ASSISTANT_URL")
HOME_ASSISTANT_TOKEN = os.getenv("HOME_ASSISTANT_TOKEN")
client_id = f'publish-{random.randint(0, 1000)}'



def on_connect(client, userdata, flags, rc):
    print('CONNACK received with code %d.' % (rc))

client = paho.Client()
client.on_connect = on_connect
client.connect('broker.mqttdashboard.com', 1883)









