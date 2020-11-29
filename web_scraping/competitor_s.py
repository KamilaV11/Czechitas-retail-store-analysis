import requests
from bs4 import BeautifulSoup

URL = 'https://www.sparkys.cz/prodejny'
page = requests.get(URL)
soup = BeautifulSoup(page.content, 'html.parser')
elems_name = soup.find_all('span', class_='branch_name')
list_names = [elem.text for elem in elems_name]

elems_address = soup.find_all('span', class_='branch_address')
list_address = [elem.text for elem in elems_address]

# uprava list address
list_address = [adresa.replace('Praha 10 Štěrboholy', 'Praha 10 - Štěrboholy') for adresa in list_address]
list_address = [adresa.replace('Nové Město, ', '') for adresa in list_address]
list_address = [adresa.replace('Terminál 1, Prst A', 'Terminál 1 - Prst A') for adresa in list_address]
list_address = [adresa.replace('Terminál 2, Prst C', 'Terminál 2 - Prst C') for adresa in list_address]
list_address = [adresa.replace('Olomouc, Velký Týnec 2', 'Olomouc - Velký Týnec 2') for adresa in list_address]
list_address = [adresa.replace('Bílinská', ' Bílinská 3490/6') for adresa in list_address]

# spojeni jmena a adresy do listu listu
new_lst = [list(x) for x in zip(list_names, list_address)]

# vytvoreni df
import pandas as pd

df = pd.DataFrame(data=new_lst, columns=['Name', 'Address'])

# rozdeleni city a street
df[['City', 'Street']] = df.Address.str.split(",", expand=True, )

df = df[['Name', 'Street', 'City']]

df.to_csv('out/tables/sparkys_clean.csv', index=False)
