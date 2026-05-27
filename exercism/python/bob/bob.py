"""Module providing a function printing python version."""
import sys
def print_python_version():
    """Function printing python version."""
    print(sys.version)

def response(hey_bob):
    """Function returning Bob's response to a given string."""
    if hey_bob.endswith('?') and hey_bob.isupper():
        return "Calm down, I know what I'm doing!"
    if hey_bob.isupper():
        return 'Whoa, chill out!'
    if hey_bob.endswith('?') or hey_bob.endswith('?   '):
        return 'Sure.'
    if hey_bob.strip() == '':
        return 'Fine. Be that way!'
    return 'Whatever.'
