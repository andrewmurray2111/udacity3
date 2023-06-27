# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import datetime


def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return (ts + '\t')

def login(user, password):
    print(timestamp() + 'Starting the browser...')
    options = ChromeOptions()
    options.add_argument('--no-sandbox')
    options.add_argument("--headless")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--remote-debugging-port=9222")
    driver = webdriver.Chrome(options=options)
    print(timestamp() + 'Browser started successfully')
    driver.get('https://www.saucedemo.com/')
    driver.find_element(By.ID, "user-name").send_keys(user)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.ID, "login-button").click()
    product_label = driver.find_element(By.CLASS_NAME, "title").text
    assert "Products" in product_label
    print(timestamp() + 'Logged in with username {:s} and password {:s} successfully.'.format(user, password))
    return driver

def add_cart(driver, count):
    i = 0
    while i < count+1:
        element = "item_" + str(i) + "_title_link"
        driver.find_element(By.ID, element).click()
        driver.find_element(By.CSS_SELECTOR, "button.btn_primary.btn_small.btn_inventory").click()
        product = driver.find_element(By.CLASS_NAME, "inventory_details_name").text
        print(timestamp() + product + " added to cart")
        driver.find_element(By.CSS_SELECTOR, "button.inventory_details_back_button").click()
        i += 1
    print(timestamp() + 'All {:d} items added to shopping cart'.format(count))

def remove_cart(driver, count):
    i = 0
    while i < count+1:
        element = "item_" + str(i) + "_title_link"
        driver.find_element(By.ID, element).click()
        driver.find_element(By.CSS_SELECTOR, "button.btn_secondary.btn_small.btn_inventory").click()
        product = driver.find_element(By.CLASS_NAME, "inventory_details_name").text
        print(timestamp() + product + " removed from cart")
        driver.find_element(By.CSS_SELECTOR, "button.inventory_details_back_button").click()
        i += 1
    print(timestamp() + 'All {:d} items are removed from shopping cart'.format(count))


if __name__ == "__main__":
    driver = login("standard_user", "secret_sauce")
    item_count = len(driver.find_elements(By.CLASS_NAME, "inventory_item_name"))
    add_cart(driver, item_count)
    remove_cart(driver, item_count)
    print(timestamp() + 'Selenium tests complete')