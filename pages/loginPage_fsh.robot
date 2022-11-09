*** Settings ***
Library     SeleniumLibrary
Resource    ../config/sys_config.robot
Resource    common.robot
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot

*** Variables ***
${username_textbox}    name:email
${password_textbox}    name:password
${login_button}        xpath://button[@type="submit"]


*** Keywords ***
login to webapp
    [Documentation]
    ...  Input username and password to login form ...
    ...  Click login button ...
    [Arguments]  ${username}    ${password}
    wait and input text       ${username_textbox}     ${username}       ${SMALL_RETRY_COUNT}
    wait and input text       ${password_textbox}     ${password}       ${SMALL_RETRY_COUNT}
    wait and click element    ${login_button}         ${SMALL_RETRY_COUNT}