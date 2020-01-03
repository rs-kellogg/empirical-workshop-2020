import time
import random

# Set seed for random number generator
random.seed(a=5911575)

# Path to input file
infile = 'clean_tickers.txt'

with open(infile) as ticks:
     tick = ticks.readline()
     tick = tick.replace('\n', '')

     while tick:
          url =  "https://finance.yahoo.com/quote/" + tick
          url += "/sustainability"
          print (url, "started at" , time.ctime())
          rand = random.randint(4,12)
          time.sleep(rand)

          




