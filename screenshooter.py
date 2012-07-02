#!/usr/bin/env python
from selenium import webdriver

#browser = webdriver.Chrome(executable_path="/home/user/bin/chrome")
browser = webdriver.Firefox()
browser.get('http://www.uni-leipzig.de/')
browser.save_screenshot('screenshot.png')
browser.quit()
