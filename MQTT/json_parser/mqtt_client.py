import os
import json
import requests
import signal
import sys
import paho.mqtt.client as mqtt

from data_handle import parse_data

from dotenv import load_dotenv

load_dotenv()

MQTT_BROKER = os.getenv("MQTT_BROKER")
MQTT_TOPIC = os.getenv("MQTT_TOPIC")
HOME_ASSISTANT_API = os.getenv("HOME_ASSISTANT_URL")
HOME_ASSISTANT_TOKEN = os.getenv("HOME_ASSISTANT_TOKEN")

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

def on_disconnect(client, userdata, rc, properties, reason_string):
    client_disconnecting = userdata.get('client_disconnecting', False)

    if client_disconnecting:
        print("Disconnected gracefully by client request.")
    else:
        print(f"Disconnected with return code {rc} and reason: {reason_string}")
        if rc != 0:
            print("Attempting to reconnect...")


# Make sure the client disconnects properly
def graceful_shutdown(signal, frame):
    print("\nShutting down gracefully")
    
    client_data = mqttc.user_data_get()
    client_data['client_disconnecting'] = True
    mqttc.user_data_set(client_data)

    mqttc.disconnect()
    sys.exit(0)

# Application terminate signal
signal.signal(signal.SIGINT, graceful_shutdown)

# MQTT client settings
mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message
mqttc.on_subscribe = on_subscribe
mqttc.on_unsubscribe = on_unsubscribe
mqttc.on_disconnect = on_disconnect

mqttc.reconnect_delay_set(min_delay=1, max_delay=120) 
mqttc.user_data_set({'client_disconnecting': False})

# Handle initial connection failure
try:
    mqttc.connect(MQTT_BROKER)
except Exception as e:
    print("Initial connection failed... retrying")


mqttc.loop_forever()
