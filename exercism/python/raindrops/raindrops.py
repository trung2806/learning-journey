"""Module providing a function printing python version."""
import sys
def print_python_version():
    """Function printing python version."""
    print(sys.version)
    
def convert(number):
    """Convert number to string following raindrops rules."""
    if number % 3 == 0 and number % 5 == 0 and number % 7 == 0:
        return "PlingPlangPlong"
    if number % 3 == 0 and number % 5 == 0:
        return "PlingPlang"
    if number % 3 == 0 and number % 7 == 0:
        return "PlingPlong"
    if number % 5 == 0 and number % 7 == 0:
        return "PlangPlong"
    if number % 3 == 0:
        return "Pling"
    if number % 5 == 0:
        return "Plang"
    if number % 7 == 0:
        return "Plong"
    return str(number)
