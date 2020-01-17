# So far all of the code we have written has executed in a straight line from
# the beginning of the file to the end, one line after another.

# This is useful and straightforward, but it doesn't let us reuse any of the
# code from earlier in the file. That's where functions come in.

# A function is a chunk of executable code with a name and an optional list of
# arguments. We create functions with the keyword "def".

def my_first_function():
    print("Hello from my_first_function!")

# Now that we have created it, let's call it:
my_first_function()

# Functions can also take arguments:
def say_hello(name):
    print("Hello", name)

say_hello("Fresh Prince")
say_hello("DJ Jazzy Jeff")

# Let's say we have a list of people we want to say hello to, we can call our
# function from a loop!
cavs = ['Lebron', 'Kyrie', 'Kevin', 'JR', 'Shump']
for player in cavs:
    say_hello(player)

# Functions can return a value using the "return" keyword.
def capitalize(word):
    return word.upper()

my_variable = capitalize("bing bong") # returns "BING BONG" to my_variable
print(my_variable)

# Functions are actually variables like any other, meaning they can be passed as
# arguments to other functions!
def do_something_then_print(func, val):
    new_value = func(val) # calling the function that was passed in as an argument and capturing its return value.
    print(new_value)

do_something_then_print(capitalize, "hello world") # prints "HELLO WORLD"

# Functions have access to variables defined in the same file but outside the function
# as long as the variables are defined before the function call:

def print_champs():
    print("The", nba_champs, "are NBA champs!")

nba_champs = "Cavs"

print_champs()

# BUT! Variables created inside a function are not visible outside the function.
def make_a_variable():
    hidden_variable = "peek a boo!"

try:
    print(hidden_variable)
except NameError:
    print("hidden_variable doesn't exist here!")
