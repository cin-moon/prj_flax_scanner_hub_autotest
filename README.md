# Ninja FE Automation Test
[![CircleCI](https://circleci.com/gh/Cinnamon/ninja-fe-auto-test.svg?style=shield&circle-token=d69c9bdbaab2d501cedb8dcdd1371039d345eb22)](https://circleci.com/gh/Cinnamon/ninja-fe-auto-test)

🤖 This repo automates regression test for Ninja FE.
- Language: Python
- Core Framework: Robot Framework
- UI Interactions: Page Object Module

# Deployment
- Make sure you have python installed on your machine by typing in console "python --version", if not, install it.
- Clone the repository to any local path.
- Enter the command in cmd being located in the folder path
```
        install -r requirements.txt
```

> Note: This has been created using Python environment in order to have all dependencies in the same folder 
> rather than taking the packages for the global Python configuration. 
> If you wish to clone without the env folder you have to download the following python packages 
> by running the following pip commands:
```
        pip install selenium 
	pip install robotframework 
	pip install robotframework-dependencylibrary
	pip install robotframework-seleniumlibrary
	pip install webdriver-manager
     	pip install robotframework-jsonlibrary
	pip install robotframework-requests
	pip install robotframework-jsonschemalibrary
```
# How To Run
1. Input your project information to config.robot file if needed 
2. Create `output` dir if needed
3. Enter the command in cmd being located in the project folder path
- All variables in config.robot file can be added as optional parameters
    - BROWSER (support Chrome, Firefox)
    - BASE_URL
    - USERNAME
    - PASSWORD
    - FILE_NAME
    - KEYS_LIST
    - KEYS_LENGTH
```
# To run with custom BASE_URL
    python -m robot --variable BASE_URL:https://abc.com tests 
    
# To run a test file
    python -m robot tests/test_authen.robot    
    
# To get test result/log in a folder
    python -m robot -d outdir tests
```
#  Structure 
```
├─config
│  └─config.robot
│  └─sys_config.robot
├─data
│  └─a.pdf
├─pages
│  └─common.robot
│  └─changepwPage.robot
│  └─editPage.robot
│  └─homePage.robot
│  └─loginPage.robot
│  └─userPage.robot
├─resources
│  └─driversync.py
├─tests
   └─test_authen.robot
   └─test_single_job.robot
   └─test_user.robot
```
