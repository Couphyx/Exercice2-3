import requests
import os

url = os.getenv("DISCORD_WEBHOOK")  # Récupère le webhook depuis le secret

data = {
    "content": "Message envoyé depuis GitHub Actions !",
    "username": "GitHub Actions Bot"
}

response = requests.post(url, json=data)

if response.status_code == 204:
    print("Message envoyé avec succès !")
else:
    print(f"Erreur : {response.status_code}")
