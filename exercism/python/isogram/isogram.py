def is_isogram(string):
    if not string:
        return True
    string = string.lower()
    for i in range(len(string)):
        if string[i].isalpha() and string[i] in string[i + 1:]:
            return False
    return True