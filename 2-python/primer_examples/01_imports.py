# Python comes with a standard library full of incredibly useful packages.
# "Standard library" means any installation of Python is guaranteed to have
# these packages. You can read about them here:
# https://docs.python.org/3/library/index.html

# In order to use a package in the standard library, you need to "import" it
# into your script.
import datetime
print("Today is", datetime.date.today())
print("Date/time is", datetime.datetime.now())

import math
print("The square root of 11 is", math.sqrt(11))

# Packages are arranged in a hierarchical namespace, where packages contain
# "modules", and modules can contain other modules, or functions, or classes, or
# variables. The math package for example just contains a bunch of functions,
# while the os package contains many useful modules for things like directory
# path manipulation or accessing environment variables.

# We can import individual items from a package without importing the whole
# package:
from math import log, cos
print("cos(log(10)) =", cos(log(10)))

# We can import everything in a package into the local namespace with "from <package_name> import *"
from statistics import *

# The statistics package includes many functions, including for example stdev(),
# which we have now imported because of the "import *":
data = [1.5, 2.5, 2.5, 2.75, 3.25, 4.75]
print(stdev(data))

# In general, "from <package> import *" is a bad idea, as something in the
# package may have the same name as something you've already defined in your
# script, and the import will "clobber" your local value. It also makes debugging
# much more difficult. Be explicit about what you want to import.

# The os package is very useful for accessing environment variables:
import os
print("The value of the PATH environment variable is", os.getenv("PATH"))

# one very useful package is http.server, which you can use to run a local web
# server! Very handy for browsing documentation, building a web app, or even if
# you want to allow other computers on the same network as you to download files
# from your computer.