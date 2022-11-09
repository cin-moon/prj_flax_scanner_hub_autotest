*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot
Resource    pages/createWorkflow_common.robot

*** Variables ***
${workflow_name_textbox}             xpath://input[@placeholder='Enter name...']
${workflow_code_textbox}             xpath://input[@placeholder='Enter code...']
${workflow_description_textbox}      xpath://textarea[@placeholder='Enter description...']
${workflow_code_error_message}      xpath://p[contains(text(),'message')]


*** Keywords ***
check if create workflow page opens
    Wait Until Element Visible    ${workflow_name_textbox}      ${SMALL_RETRY_COUNT}

input name for new workflow
    [Documentation]
    ...     Input value into Workflow Name textbox ...
    [Arguments]    ${workflow_name}
    wait and input text         ${workflow_name_textbox}            ${workflow_name}                ${SMALL_RETRY_COUNT}

input code for new workflow
    [Documentation]
    ...     Input value into Workflow Code textbox ...
    [Arguments]    ${workflow_code}
    wait and input text         ${workflow_code_textbox}            ${workflow_code}                ${SMALL_RETRY_COUNT}

input description for new workflow
    [Documentation]
    ...     Input value into Workflow Description textbox ...
    [Arguments]    ${workflow_description}
    wait and input text         ${workflow_description_textbox}     ${workflow_description}         ${SMALL_RETRY_COUNT}

verify if error message for workflow code appears
    [Documentation]
    ...     Verify if the error message for error code appears
    [Arguments]    ${message}
    ${locator}=  	Replace String	   ${workflow_code_error_message}   message      ${message}
    wait until element visible         ${locator}        ${SMALL_RETRY_COUNT}

verify if error message for workflow code disappears
    [Documentation]
    ...     Verify if the error message for error code disappears
    [Arguments]    ${message}
    ${locator}=  	Replace String	   ${workflow_code_error_message}   message      ${message}
    wait until element invisible       ${locator}        ${SMALL_RETRY_COUNT}

clear all entered value for basic information
    [Documentation]
    ...     Clear all enteref value for workflow name, workflow code, workflow description
    Clear Element Text      ${workflow_name_textbox}
    Clear Element Text      ${workflow_code_textbox}
    Clear Element Text      ${workflow_description_textbox}

input workflow basic information
    [Documentation]
    ...     Enter valid value for Workflow name, Workflow Code, Workflow Description
    ...     Verify that Next button is enabled
    ...     Press Next Button
    [Arguments]    ${workflow_name}     ${workflow_code}        ${workflow_description}
    input name for new workflow             ${workflow_name}
    input code for new workflow             ${workflow_code}
    input description for new workflow      ${workflow_description}
    verify if next button is enable
    press next button


