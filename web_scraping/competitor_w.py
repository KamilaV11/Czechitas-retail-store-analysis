import requests
from bs4 import BeautifulSoup
import pandas as pd

URL = 'https://www.wikyhracky.cz/seznam-prodejen/'
URL_wiky = 'https://www.wikyhracky.cz/'

page = requests.get(URL)
soup = BeautifulSoup(page.content, 'html.parser')

job_elems = soup.find_all('h5', class_='head')
list_url_shops = [elem.find('a')['href'] for elem in job_elems]

pobocky = []

for url in list_url_shops:
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    shop = soup.find('div', class_='col-xs-12 col-lg-6')
    adresa = shop.find('p').text
    adresa = adresa.replace('59401', '594 01')
    adresa = adresa.split('\n')[1].strip()
    adresa = adresa.split(',')
    ulice = adresa[0]
    mesto_psc = adresa[1].strip().split(' ', 2)
    mesto = mesto_psc[2]
    psc = mesto_psc[0] + ' ' + mesto_psc[1]
    shop = soup.find('div', class_='content-row')
    nazev = shop.find('h1').text
    list_pobocka = [nazev, ulice, mesto, psc]
    pobocky.append(list_pobocka)

    # dataframe

df = pd.DataFrame(data=pobocky, columns=['Name', 'Street', 'City', 'ZIP'])

df.to_csv('out/tables/wiky_clean.csv', index=False)
