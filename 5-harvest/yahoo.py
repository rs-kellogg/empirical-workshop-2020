################################################
# Download Yahoo Finance Summary Pages
################################################

# libraries used
import requests 
import re 
import time


##############################
# Open 8K List and Save it
##############################

# create empty lists to store data
tickerList = []

with open('tickers.txt', 'r') as f:
	for i in f:
		tickerList.append(i)
		
print(len(tickerList))


##############################
# Downloading Pages
##############################

for tick in tickerList:
    tick = tick.strip()
    print(tick)
    page = 'https://finance.yahoo.com/quote/' + str(tick) + '?p=' + str(tick)
    print(page)
    path = str(tick) + '.html'
    print(path)
    time.sleep(3)
    page = requests.get(page)
    with open(path, "wb") as f:
    	f.write(page.content)
    print("At " + time.strftime("%X") + ", we successfully saved " + str(path) + ".")
            











