*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot
Resource    pages/workflowPage.robot

*** Variables ***
${header}               xpath://div[@class='chakra-stack css-84zodg']
${key}                  xpath://p[@class='chakra-text css-1c4hg7f']
${value}                xpath://input[@placeholder='Input the value']
${close_button}         xpath://button[@aria-label='exit']

*** Keywords ***
check if editor page is opened
    [Documentation]
    ...     check if the header of editor page is visible
    wait until element visible      ${header}   ${SMALL_RETRY_COUNT}

get the ocr key list
    [Documentation]
    ...     get the list of OCR key
    ${key_list}=    wait and get elements text list     ${key}      ${SMALL_RETRY_COUNT}

    [Return]    ${key_list}

get the ocr value list
    [Documentation]
    ...     get the list of OCR values
    ${value_list}=    wait and get elements value list     ${value}      ${SMALL_RETRY_COUNT}

    [Return]    ${value_list}

close editor page
    [Documentation]
    ...   Close the editor page
    wait and click element      ${close_button}     ${SMALL_RETRY_COUNT}
    check if workflow page is opened
