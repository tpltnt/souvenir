#!/usr/bin/env python

# render websites as images
# TODO: - autoselect browser
#       - internal sanity checks

import sys
from selenium import webdriver

#browser = webdriver.Chrome(executable_path="/home/user/bin/chrome")
browser = webdriver.Firefox()
browser.get(sys.argv[1])
browser.save_screenshot('screenshot.png')
browser.quit()
