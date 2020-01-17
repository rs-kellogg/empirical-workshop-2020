# While a string is a sequence of characters, a list is a sequence that can hold
# any kind of data.

# You can make a list using the list() function and then appending to it.

my_list = list()
my_list.append(1)
my_list.append(2)
my_list.append(3)
my_list.append(4)

print(my_list)

# There is a also a simpler, "literal" syntax for creating lists:

my_list_also = [1, 2, 3]
print(my_list_also)

# We can use the "in" operator to test if a list contains a particular value:

print(1 in my_list) # Will print "True" if 1 is in my_list, "False" otherwise.

# We can ask for the smallest or largest item in a list with the min() and max()
# functions:
print("Largest item in my_list is", max(my_list))

# We can look up individual items in a list (the first item in a list is at
# index 0):
print("The first item in my_list is", my_list[0])
print("The second item in my_list is", my_list[1])

# Use a negative index to start looking from the end (the last item is at index
# -1):
print("The last item in my_list is", my_list[-1])
print("The next-to-last item in my_list is", my_list[-2])

# Lists and other sequence types have lots of other features, as you can
# imagine: sorting, reversing, extending, inserting, etc. You will use lists
# very, very often when programming in Python.