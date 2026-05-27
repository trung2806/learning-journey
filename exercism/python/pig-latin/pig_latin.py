def translate(text):
    if not text:
        return ""
    
    words = text.split()
    translated_words = []
    
    for word in words:
        word_lower = word.lower()
        translated_words.append(translate_word(word_lower))
    
    return " ".join(translated_words)


def translate_word(word):
    # Rule 1: Words beginning with vowels
    if word[0] in "aeiou":
        return word + "ay"
    
    # Rule 2: Words beginning with "xr" or "yt"
    if word[:2] in ["xr", "yt"]:
        return word + "ay"
    
    # Rule 3: Words beginning with consonants
    # Find where the consonant cluster ends
    consonant_cluster_length = 0
    
    for i, letter in enumerate(word):
        if letter in "aeiou":
            # Special case: "u" after "q" is not a vowel
            if letter == "u" and i > 0 and word[i-1] == "q":
                consonant_cluster_length += 1
            else:
                # Vowel found - cluster ends here
                break
        elif letter == "y":
            # "y" is a vowel if it's not at the start of the word
            if i > 0:
                break
            else:
                # "y" at start is consonant
                consonant_cluster_length += 1
        else:
            # Regular consonant
            consonant_cluster_length += 1
    
    # Move consonant cluster to end and add "ay"
    return word[consonant_cluster_length:] + word[:consonant_cluster_length] + "ay"
