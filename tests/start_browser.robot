*** Settings ***
Resource        pages/common.robot
Resource        pages/loginPage_fsh.robot


*** Test Cases ***
Test Case: Start Browser
    open browser to login page
    login to webapp     ${USERNAME}     ${PASSWORD}