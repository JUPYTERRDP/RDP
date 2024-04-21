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
    return {
        'username': os.environ.get('USERNAME'),
        'password': os.environ.get('PASSWORD'),
        'CRP': os.environ.get('CRP'),
        'Pin': os.environ.get('PIN'),
        'Autostart': os.environ.get('AUTOSTART', '').lower() == 'true'
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
