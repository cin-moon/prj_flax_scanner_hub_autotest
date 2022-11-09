import os

from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager


def get_chromedriver():
    path = os.getcwd()
    driver_path = ChromeDriverManager(path=path).install()
    print(driver_path)
    return driver_path


def get_ffdriver():
    path = os.getcwd()
    driver_path = GeckoDriverManager(path=path).install()
    print(driver_path)
    return driver_path
