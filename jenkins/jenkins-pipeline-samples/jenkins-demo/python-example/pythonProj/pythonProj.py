#!/usr/bin/python
import sys


# Function definition is here
def printme( str ):
    # This prints a passed string into this function
    print (str)
    return;

# Now you can call printme function
printme("Hello from Python Project");
printme('The parameterized output is %s \n The project url is %s \n the current build id is %s' % (str(sys.argv[1]), str(sys.argv[2]), str(sys.argv[3])))

