#######################################
# Download Yahoo Finance Summary Pages
#######################################

# libraries used
import time
import requests

# Input file
tickerList = []
with open('clean_tickers.txt', 'r') as f:
	for i in f:
		tickerList.append(i)
		
# Open page and save html		
for tick in tickerList:
    tick = tick.strip()
    page = 'https://finance.yahoo.com/quote/' + str(tick)
    path = str(tick) + '.html'
    time.sleep(3)
    page = requests.get(page)
    with open(path, "wb") as f:
    	f.write(page.content)
    print("At " + time.strftime("%X") + ", we successfully saved " + str(path) + ".")            











