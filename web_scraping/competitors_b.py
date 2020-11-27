
import requests
from bs4 import BeautifulSoup
import pandas as pd

URL = 'https://www.bambule.cz/prodejny'
URL_BAMBULE = 'https://www.bambule.cz'
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

job_elems = soup.find_all('div', class_='prodejna-list-item')
list_url_shops = [URL_BAMBULE+ elem.find('a')['href'] for elem in job_elems]

list_shops = []
for url_shop in list_url_shops:
    page = requests.get(url_shop)
    soup = BeautifulSoup(page.content, 'html.parser')
    shop = soup.find('p', class_ = 'prodejna-adresa')
    adresa_name = shop.find('span', class_='prodejna-adresa-name').text
    adresa_ulice = shop.find('span', class_='prodejna-adresa-ulice').text
    adresa_mesto = shop.find('span', class_='prodejna-adresa-mesto').text
    adresa_psc = shop.find('span', class_='prodejna-adresa-psc').text
    list_shop = [adresa_name, adresa_ulice, adresa_mesto, adresa_psc]
    print(list_shop)
    list_shops.append(list_shop)


df = pd.DataFrame(data = list_shops, columns = ['Name', 'Street', 'City', 'ZIP'])

df.to_csv('out/tables/bambule_clean.csv', index=False)
