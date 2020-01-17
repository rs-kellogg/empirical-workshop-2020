# Computer programs are usually not very useful without some kind of interaction
# with the outside world. Sometimes that interaction comes directly from a user,
# but more often it means loading and working with data from outside sources.

# The simplest and easiest kind of data to work with is accessing files on the
# same computer as your script. Python has a built-in way to open files, the
# open() function.

# open() returns a "file object", which is basically a thing that knows how to
# read and write the file whose name you pass into the open() function.

# The first argument to open() is the path to the file to open, and the second
# argument is the "mode": 'r' for read-only, 'w' to write to a file (deleting
# its contents first!), or 'a' to append to the end of an existing file.


# Path to input file
infile = 'clean_tickers.txt'

f = open(infile, 'r')


# we now have a file object with the name "f". File objects have a "read()"
# method that will return the entire contents of the file, and a "readline()"
# method that will return one line at a time from the file.

# This will print out the first line of the file:
print(f.readline())

# This will print out the second line in the file:
print(f.readline())

# Be sure to close the file when you are done:
f.close()

# You can leave out the call to close() if you open the file using Python's
# "with" keyword, which will automatically close the file for you at the end of
# the block that follows it:
with open(infile, 'r') as f:
    # Inside this block, we have access to the file object "f".
    
    # File objects can be looped over, and each iteration of the loop will
    # return the next line in the file (just like calling "readline()" a bunch
    # of times, as above)
    line_count = 0
    for line in f:
        # add code to print each line here
        line_count += 1

    print("There are", line_count, "lines/tickers in the file.")

    # The file will be automatically closed for us at the end of this block.

# Text can also be written to file:
with open('ticker_summary.txt, 'w): as f:
    summary_text="There are"+str(line_count)+"lines/tickers in the file."
    f.write(summary_text)
