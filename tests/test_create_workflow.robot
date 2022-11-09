*** Settings ***
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/common.robot
Resource        config/config.robot
Resource        pages/homePage_fsh.robot
Resource        pages/allWorkflowPage_fsh.robot
Resource        pages/loginPage_fsh.robot
Resource        business_keyword/workflow.robot

Suite Setup    Run Keywords
...     open browser to login page
...     AND     login to webapp     ${USERNAME}     ${PASSWORD}

Test Setup     Run Keywords
...     navigate to all workflows page when there is existing workflow
...     AND     navigate to create workflow page

Test Teardown   return to home page

#Suite Teardown      close browser


*** Variables ***
${medical_receipt_pipeline_name}    Medical Receipt
${health_check_pipeline_name}       Health Check
${medical_expense_pipeline_name}    Medical Expense


*** Test Cases ***
Test Case: Creat Workflow with Medical Receipt Pipeline Using Default Setting
    [Documentation]
    ...     Create workflow with Medical Receipt Pipeline using default setting.
    create workflow with default setting      ${medical_receipt_pipeline_name}

Test Case: Creat Workflow with Medical Expense Pipeline Using Default Setting
    [Documentation]
    ...     Create workflow with Medical Expense Pipeline using default setting.
    create workflow with default setting      ${medical_expense_pipeline_name}

Test Case: Creat Workflow with Health Check Pipeline Using Default Setting
    [Documentation]
    ...     Create workflow with Health Check Pipeline using default setting.
    create workflow with default setting      ${health_check_pipeline_name}




