*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot

*** Variables ***
${next_button}              xpath://button[text()='Next']
${back_button}              xpath://button[text()='Back']
${create_button}            xpath://button[text()='Create']
${success_toast_msg}        xpath://div[@class='chakra-alert__desc css-zycdy9' and text()='The workflow has been created successfully']

*** Keywords ***
press next button
    [Documentation]
    ...     Press Next Button  ...
    wait and click element          ${next_button}          ${SMALL_RETRY_COUNT}

verify if next button is enable
    [Documentation]
    ...     Verify if the Next button is enabled
    wait until element enabled      ${next_button}          ${SMALL_RETRY_COUNT}

verify if next button is disable
    [Documentation]
    ...     Verify if the Next button is disabled
    wait until element disabled    ${next_button}           ${SMALL_RETRY_COUNT}

press back button
    [Documentation]
    ...     Press Back Button  ...
    wait and click element          ${back_button}          ${SMALL_RETRY_COUNT}

verify if back button is enable
    [Documentation]
    ...     Verify if the Back button is enabled
    wait until element enabled      ${back_button}          ${SMALL_RETRY_COUNT}

verify if back button is disable
    [Documentation]
    ...     Verify if the Back button is disabled
    wait until element disabled    ${back_button}           ${SMALL_RETRY_COUNT}

press create button
    [Documentation]
    ...     Press Create Button on Review page  ...
    wait and click element          ${create_button}          ${SMALL_RETRY_COUNT}

verify success toast message
    [Documentation]
    ...     Verify the the toast message appears
    wait until element visible  ${success_toast_msg}    ${SMALL_RETRY_COUNT}
    wait until element invisible  ${success_toast_msg}    ${SMALL_RETRY_COUNT}