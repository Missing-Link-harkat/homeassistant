import os
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("HOME_ASSISTANT_URL")
TOKEN = os.getenv("HOME_ASSISTANT_TOKEN")

if not BASE_URL or not TOKEN:
    raise ValueError("ENV VARIABLES NOT PROPERLY SET :(   ")


HEADERS = {"Authorization": f"Bearer {TOKEN}"}


def api_health():
    try:
        response = requests.get(f"{BASE_URL}/api/", headers=HEADERS)

        response.raise_for_status()

        data = response.json()
        print(f"message: {data['message']}\n")
        
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

def get_states():
    print("/api/states\n")
    try:
        response = requests.get(f"{BASE_URL}/api/states", headers=HEADERS)

        response.raise_for_status()

        data = response.json()
        print("Response JSON:")
        for state in data:
            print(f" {state['entity_id']} : {state['state']}")
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")



# test on specific lamps, which are connected
def get_lamp_state():
    print("\n/api/states/light.keittio_1\n")

    try:
        response = requests.get(f"{BASE_URL}/api/states/light.keittio_1", headers=HEADERS)
        response.raise_for_status()
        data = response.json()
        for state in data:
            print(state)
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

def set_lamp_off():
    print("\n/api/lamp/turn_off\n")

    payload = {
        "entity_id" : "light.keittio_1"
    }

    response = requests.post(f"{BASE_URL}/api/services/light/turn_off", headers=HEADERS, json=payload)

    if response.status_code == 200:
        print("Light turned off")
    else:
        print("error")
        print(response.status_code)

def set_lamp_on():
    print("\n/api/lamp/turn_on\n")

    payload = {
        "entity_id" : "light.keittio_1"
    }

    response = requests.post(f"{BASE_URL}/api/services/light/turn_on", headers=HEADERS, json=payload)

    if response.status_code == 200:
        print("Light turned on")
    else:
        print("error")
        print(response.status_code)


def get_events():
    print("/API/EVENTS\n")

    try:
        response = requests.get(f"{BASE_URL}/api/events", headers=HEADERS)

        response.raise_for_status()

        data = response.json()
        for event in data:
            print(f" {event['event']} : {event['listener_count']}\n")
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

def get_logs():
    print("\n/api/logbook\n")

    try:
        response = requests.get(f"{BASE_URL}/api/logbook", headers=HEADERS)

        response.raise_for_status()

        data = response.json()

        for log in data:
            print(f" {log['name']} : {log['when']}\n")
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")


def get_services():
    print("/api/services")

    try:
        response = requests.get(f"{BASE_URL}/api/services", headers=HEADERS)

        response.raise_for_status()

        data = response.json()

        #print(data)
        for service in data:
            print(f"{service['domain']} : {service['services']}\n")
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")


def get_errors():
    print("/api/error_log\n")

    try:
        response = requests.get(f"{BASE_URL}/api/error_log", headers=HEADERS)

        response.raise_for_status()

        print(response.text)
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    #api_health()
    #get_states()
    #get_lamp_state()
    #set_lamp_off()
    #set_lamp_on()
    #get_events()
    #get_logs()
    #get_services()
    #get_errors()