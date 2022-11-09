*** Settings ***
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/homePage_fsh.robot
Resource        pages/allWorkflowPage_fsh.robot
Resource        pages/createWorkflow_BasicInfor_Page.robot
Resource        pages/createWorkflow_common.robot
Resource        pages/createWorkflow_SelectPipeline_Page.robot

*** Variables ***
${WORKFLOW_DESCRIPTION}             This is workflow created by automation test


*** Keywords ***
create workflow with default setting
    [Documentation]
    ...     Create workflow of desired pipeline successfully
    [Arguments]    ${pipeline_name}
    ${WORKFLOW_NAME}=               Generate Random String      12      [LETTERS][NUMBERS]
    ${WORKFLOW_NAME}=               Catenate    ${pipeline_name}    ${WORKFLOW_NAME}
    ${WORKFLOW_CODE}=               Generate Random String      8       [LETTERS][NUMBERS]
    input workflow basic information    ${WORKFLOW_NAME}     ${WORKFLOW_CODE}        ${WORKFLOW_DESCRIPTION}
    select pipeline     ${pipeline_name}
    press next button       #press Next to move to Output Field configuration page
    press next button       #press Next to move to Permission configuration page
    press next button       #press Next to move to Review page
    press create button     #press Create button on Review page to create workflow
    verify success toast message
    choose number of items per page     100
    move to the last page   #move to the last page of the All Workflow page
    verify workflow information     last()  ${WORKFLOW_NAME}    ${WORKFLOW_CODE}    ${WORKFLOW_DESCRIPTION}
    verify if workflow is displayed in workflow dropdown list   ${WORKFLOW_NAME}

    RETURN      ${WORKFLOW_CODE}