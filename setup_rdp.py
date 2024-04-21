import os
import subprocess
import json

def main():
    config = load_config()
    username = config.get('username')
    password = config.get('password')
    CRP = config.get('CRP')
    Pin = config.get('Pin')
    Autostart = config.get('Autostart')

    if not (username and password and CRP and Pin and Autostart):
        print("Error: Configuration incomplete.")
        return

    create_user(username, password)
    setup_rdp(username, CRP, Pin, Autostart)

def load_config():
    # You can modify this function to load configuration from a file or prompt the user for input.
    # For simplicity, I'll just prompt the user for input here.
    username = input("Enter username: ")
    password = input("Enter password: ")
    CRP = input("Enter CRP: ")
    Pin = input("Enter Pin: ")
    Autostart = input("Autostart Notebook in RDP? (True/False): ").lower() == 'true'

    return {
        'username': username,
        'password': password,
        'CRP': CRP,
        'Pin': Pin,
        'Autostart': Autostart
    }

def create_user(username, password):
    print("Creating User and Setting it up")
    os.system(f"useradd -m {username}")
    os.system(f"adduser {username} sudo")
    os.system(f"echo '{username}:{password}' | sudo chpasswd")
    os.system("sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd")
    print(f"User created and configured having username `{username}` and password `{password}`")

def setup_rdp(username, CRP, Pin, Autostart):
    # Add your setup code here
    pass

if __name__ == "__main__":
    main()
