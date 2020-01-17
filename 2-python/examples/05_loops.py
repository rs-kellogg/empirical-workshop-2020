# Now that we have covered data types that can contain many values (lists and
# dictionaries), let's use loops to work with those values efficiently.

# First let's create a list of values.
animals = ['chicken', 'sheep', 'goat', 'llama']

# Now let's say for some reason we want to print out these values in all caps.
# Here is how to do it *without* using a loop:
print(animals[0].upper())
print(animals[1].upper())
print(animals[2].upper())
print(animals[3].upper())

# As you can see, this is pretty ugly because we are repeating ourselves and
# this will be no fun to type if our list had, say, 100 items in it.

# Let's try with a "for" loop:
print('let\'s try with a loop')
for animal in animals:
    print(animal.upper())

# The "for .. in" statement takes each element of a sequence or other "iterable"
# variable, assigns the element temporarily to the name you specify ("animal" in
# this instance), and executes the statements in the indented block.

# When that block is finished executing for a given value of the sequence, the
# next value in the sequence gets assigned to the variable you created and the
# statements in the block are run again, and on and on until the sequence runs
# out of values.

# We can loop over lots of different kinds of things in Python.

# Dictionaries (by key):
animal_names = {'dog': 'Rex', 'rat': 'Willard', 'turtle': 'Leonardo'}
for species in animal_names:
    print("The", species, "is named", animal_names[species])

# Strings (by character):
alpha = "abcdefg"
for letter in alpha:
    print(letter.upper())

# Strings (by words):
lyrics = "I did it my way"
for word in lyrics.split(" "):
    print(word.upper())

# Related to the "for .. in" statement is the "while" statement. while keeps
# executing a block of statements as long as the condition its given is true.

count = 0
while count < 10:
    print(".", end="") # The "end" keyword argument here prevents the print function from emitting a newline character
    count += 1 # Once this value hits 10, the condition "count < 10" becomes false and the while statement stops executing.

# Finally, if you need to stop a for or while loop early, you can use the
# "break" keyword:
import random
while True:
    print("Who knows how many times this will execute?")
    if random.random() > 0.9:
        break
