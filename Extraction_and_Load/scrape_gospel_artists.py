""" Scrapes gospel_artist from ceenaija.com and uploads it to a csv file to be used as search term in my "pipeline.py" """
# CeeNaija is a gospel music download blog that is dedicated to providing the best and latest gospel music from Nigeria and around the world.
# We believe in the power of music to uplift the soul and bring people closer to God, 
# and we are committed to making that power available to as many people as possible
import requests
import csv
import time
from bs4 import BeautifulSoup

BASE_URL = "https://www.ceenaija.com/artists/"
HEADERS = {
    "User-Agent": "Mozilla/5.0"
}
results, seen = [], set()

page = 1

while True:
   
    url = BASE_URL if page == 1 else f"{BASE_URL}page/{page}/"
    response = requests.get(url,headers=HEADERS, timeout=30)
    if response.status_code != 200:
        print(f"Error: {response.status_code}")
        break
    soup = BeautifulSoup(response.text,"html.parser")
    found = 0
    for h3 in soup.select("h3 a[href*='/artists/']"):
        href = h3["href"]
        if href.rstrip("/") == BASE_URL.rstrip("/") or href in seen:
            continue
        seen.add(href)
        results.append({"name": h3.get_text(strip=True),"url":href})
        found += 1
    if found == 0:
        break
    page += 1
    time.sleep(1)
    
print(f"Success! Scraped {len(results)} gospel artists")
    
with open("gospel_artists.csv","w",newline="", encoding="utf-8-sig") as file:
    writer = csv.DictWriter(file, fieldnames=["name","url"])
    writer.writerows(results)
print(f"Completed!!! loaded {len(results)} into 'gospel_artists.csv'")