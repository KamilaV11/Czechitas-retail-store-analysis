
import pandas as pd

# nacteni
with open('in/tables/Konkurece_Dracik.csv', encoding='utf-8') as adresy_dirty:
    radky = [radek.split('\n') for radek in adresy_dirty]

# vybrani polozky z radku kteay obsahuje adresu, odstraneni prazdnych znaku okolo
radky_strip = [radek[0].strip() for radek in radky]

# vyfiltrovani polozek, ktere obsahuji \t - jde o adresy
radky_adresa = [radek for radek in radky_strip if '\t' in radek]

# nahrazeni tabu v adrese carkou
adresy_clean = [radek.replace('\t\t\t\t\t\t\t\t\t', ',') for radek in radky_adresa]

# oprava pisek Albert, Stare mesto Uherske Hradiste
adresy_clean_pisek = [item.replace('Písek, Albert', 'Písek - Albert') for item in adresy_clean]
adresy_clean2 = [item.replace('Staré Město, Uherské Hradiště', 'Staré Město - Uherské Hradiště') for item in
                 adresy_clean_pisek]

# vztvoreni list listu
adresy_lists = [radek.split(',') for radek in adresy_clean2]

# vytvoreni tabulky
df = pd.DataFrame(adresy_lists, columns=['Name', 'Street', 'City'])

# import do csv
df.to_csv('out/tables/dracik_clean.csv', index=False)
