with open("/Users/dord3/Documents/projects/devtest/logs/logd.log") as file:
    data = file.read()
occurrences = data.count("2")
print(occurrences)