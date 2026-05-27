"""Module providing a function printing python version."""
import sys
def print_python_version():
    print(sys.version)

def is_armstrong_number(number):
    """Determine if a number is an Armstrong number."""
    if number < 0:
        return False
    digits = [int(each_number) for each_number in str(number)]
    num_digits = len(digits)
    armstrong_sum = sum(each_number ** num_digits for each_number in digits)
    if armstrong_sum == number:
        return True
    return False
