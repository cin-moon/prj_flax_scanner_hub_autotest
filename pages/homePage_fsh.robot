*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot
Resource    pages/allWorkflowPage_fsh.robot
Resource    pages/workflowPage.robot

*** Variables ***
${home_button}                  xpath://img[@alt='Logo']
${workflow_button}              xpath://div[text()='Workflow']

${view_all_workflow_button}     xpath://button[text()='View all Workflows']
${workflow_menu_item}           xpath://div[@class='css-zvlevn' and text()='name']
${workflow_menu_first_item}     xpath:(//div[@class='css-5yno0c'])[1]
${workflow_dropdown_list}       id:stack-workflow

*** Keywords ***
navigate to all workflows page when there is existing workflow
    [Documentation]
    ...     Click Workflow button then click View All Workflow  ...
    wait and click element      ${workflow_button}              ${MEDIUM_RETRY_COUNT}
#    wait until element visible  ${workflow_menu_first_item}     ${SMALL_RETRY_COUNT}
    wait and click element      ${view_all_workflow_button}     ${SMALL_RETRY_COUNT}
    check if all workflows page is opened

verify if workflow is displayed in workflow dropdown list
    [Documentation]
    ...     Open Workflow dropdown list and verify if the desired workflow is listed  ...
    [Arguments]    ${workflow_name}
    wait and click element      ${workflow_button}              ${MEDIUM_RETRY_COUNT}
    wait until element visible  ${workflow_dropdown_list}       ${SMALL_RETRY_COUNT}
    ${locator}=     Replace String      ${workflow_menu_item}    name   ${workflow_name}
    Page Should Contain Element     ${locator}

select a workflow from the workflow menu list
    [Documentation]
    ...     Open Workflow dropdown list, scroll to to desired workflow and select it  ...
    [Arguments]    ${workflow_name}
    wait and click element      ${workflow_button}              ${MEDIUM_RETRY_COUNT}
    wait until element visible  ${view_all_workflow_button}     ${SMALL_RETRY_COUNT}
    ${locator}=     Replace String      ${workflow_menu_item}    name   ${workflow_name}
    Scroll Element Into View        ${locator}
    wait and click element          ${locator}      ${SMALL_RETRY_COUNT}
    check if workflow page is opened

return to home page
    [Documentation]
    ...     Press on Cinnamon AI icon to return to home page  ...
    wait and click element      ${home_button}                ${MEDIUM_RETRY_COUNT}















