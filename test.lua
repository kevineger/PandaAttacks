local typoDetection = require("typo_detection")

print("Checking for Typos")
print(typoDetection.isTypo("asdfghjkl", "asdfghaaa", 3))