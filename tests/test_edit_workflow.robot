*** Settings ***
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/common.robot
Resource        config/config.robot
Resource        pages/homePage_fsh.robot
Resource        pages/allWorkflowPage_fsh.robot
Resource        pages/loginPage_fsh.robot
Resource        pages/editWorkflow.robot
Resource        business_keyword/workflow.robot

Suite Setup    Run Keywords
...     open browser to login page
...     AND     login to webapp     ${USERNAME}     ${PASSWORD}

Test Setup     test setup for edit workflow test cases


#Suite Teardown      close browser


*** Variables ***
${WORKFLOW_PIPELINE}                    Medical Receipt
${new_workflow_desc}                    Description is updated by automation test
${new_pipeline}                         Health Check
@{output_field_id_list}=                alt             cardiogram
${workflow_code}

*** Test Cases ***
Test Case: Edit Workflow Basic Information
    [Documentation]
    ...     Edit workflow name and workflow description
    open edit workflow page     ${workflow_code}
    open editor section for basic information
    ${WORKFLOW_NAME}=               Generate Random String      12      [LETTERS][NUMBERS]
    ${WORKFLOW_NAME}=               Catenate    ${WORKFLOW_PIPELINE}    ${WORKFLOW_NAME}
    edit workflow name      ${WORKFLOW_NAME}
    verify workflow name after update       ${WORKFLOW_NAME}
    open editor section for basic information
    edit workflow description   ${new_workflow_desc}
    verify workflow description after update    ${new_workflow_desc}

Test Case: Edit Workflow Pipeline And Not Confirm Pipeline Change
    [Documentation]
    ...     Edit workflow pipeline
    open edit workflow page     ${workflow_code}
    Sleep   2s
    open editor section for pipeline and output field
    Sleep    2s
    edit workflow pipeline and not confirm changes      ${new_pipeline}
    verify workflow pipeline after update   ${WORKFLOW_PIPELINE}

Test Case: Edit Workflow Pipeline And Confirm Pipeline Change
    [Documentation]
    ...     Edit workflow pipeline
    open edit workflow page     ${workflow_code}
    Sleep   2s
    open editor section for pipeline and output field
    Sleep    2s
    edit workflow pipeline and confirm changes      ${new_pipeline}
    verify workflow pipeline after update   ${new_pipeline}

#Test Case: Edit Workflow Output field selection
#    [Documentation]
#    ...     Edit Workflow Output field selection
#    open edit workflow page     ${workflow_code}
#    Sleep   2s
#    open editor section for pipeline and output field
#    Sleep    2s
#    select output fields      @{output_field_id_list}

*** Keywords ***
test setup for edit workflow test cases
    [Documentation]
    ...  This contains all setup steps for upload file test cases
    navigate to all workflows page when there is existing workflow
    navigate to create workflow page
    ${workflow_code}=   create workflow with default setting        ${WORKFLOW_PIPELINE}
    Set Suite Variable          ${workflow_code}