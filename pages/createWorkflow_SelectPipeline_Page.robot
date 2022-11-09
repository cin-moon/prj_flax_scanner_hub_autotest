*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot


*** Variables ***
${pipeline_button}          xpath://div[@class='css-kf8if4' and text()='name']

*** Keywords ***
select pipeline
    [Documentation]
    ...     select the desired pipeline
    [Arguments]    ${pipeline_name}
    ${locator}=  	Replace String	   ${pipeline_button}   name      ${pipeline_name}
    wait and click element       ${locator}        ${SMALL_RETRY_COUNT}




