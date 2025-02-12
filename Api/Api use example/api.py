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
        data = get_request(f"{BASE_URL}/api/", headers=HEADERS)
        print(f"message: {data['message']}\n")

def get_states():
    print("/api/states\n")

    data = get_request(f"{BASE_URL}/api/states", headers=HEADERS)
    if data:
        print("Response JSON:")
        for state in data:
            print(f" {state['entity_id']} : {state['state']}")




# test on specific lamps, which are connected
def get_lamp_state():
    print("\n/api/states/light.keittio_1\n")

    data = get_request(f"{BASE_URL}/api/states/light.keittio_1", headers=HEADERS)
    if data:
        for state in data:
            print(state)

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

    data = get_request(f"{BASE_URL}/api/events", headers=HEADERS)
    if data:
        for event in data:
            print(f" {event['event']} : {event['listener_count']}\n")

def get_logs():
    print("\n/api/logbook\n")

    data = get_request(f"{BASE_URL}/api/logbook", headers=HEADERS)

    if data:
        for log in data:
            print(f" {log['name']} : {log['when']}\n")


def get_services():
    print("/api/services")


    data = get_request(f"{BASE_URL}/api/services", headers=HEADERS)

    #print(data)
    if data:
        for service in data:
            print(f"{service['domain']} : {service['services']}\n")


def get_errors():
    print("/api/error_log\n")

    print(get_request(f"{BASE_URL}/api/error_log", headers=HEADERS))

def get_request(url, headers):
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error {e}")

if __name__ == "__main__":
    api_health()
    get_states()
    #get_lamp_state()
    #set_lamp_off()
    #set_lamp_on()
    #get_events()
    #get_logs()
    #get_services()
    #get_errors()