*** Settings ***
Library         SeleniumLibrary
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/common.robot
Resource        config/config.robot
Resource        pages/homePage_fsh.robot
Resource        pages/loginPage_fsh.robot
Resource        business_keyword/workflow.robot


Suite Setup    Run Keywords
...     open browser to login page
...     AND     login to webapp     ${USERNAME}     ${PASSWORD}


Test Setup      test setup for detele workflow test cases

Suite Teardown  close browser


*** Variables ***
${WORKFLOW_PIPELINE}        Medical Receipt
${workflow_code}

*** Test Cases ***

Test Cases: Test Delete Workflow Successfully
    [Documentation]
    ...     Delete a workflow successfully
    navigate to all workflows page when there is existing workflow
    ${workflow_name}=   press delete workflow button and verify initial state of confirmation dialog   ${workflow_code}
    enter workflow name into workflow confirmation dialog  ${workflow_name}
    press delete button on confirmation dialog
    verify success delete toast message
    verify workflow is deleted  ${workflow_code}

Test Cases: Test Delete Workflow Unsuccessfully Because Confirming Workflow Name In Wrong Case
    [Documentation]
    ...     Delete a workflow unsuccessfully because entering wrong workflow name into confirmation dialog
    navigate to all workflows page when there is existing workflow
    ${workflow_name}=   press delete workflow button and verify initial state of confirmation dialog   ${workflow_code}
    ${workflow_name}=   Convert To Lower Case       ${workflow_name}        #convert workflow name into lower case
    enter workflow name into workflow confirmation dialog  ${workflow_name}
    press delete button on confirmation dialog
    verify error message on workflow confirmation dialog
    press close button on confirmation dialog
    find workflow         ${workflow_code}

*** Keywords ***
test setup for detele workflow test cases
    [Documentation]
    ...  This contains all setup steps for delete workflow test cases
    navigate to all workflows page when there is existing workflow
    navigate to create workflow page
    ${workflow_code}=   create workflow with default setting        ${WORKFLOW_PIPELINE}
    Set Suite Variable  ${workflow_code}
    navigate to all workflows page when there is existing workflow

