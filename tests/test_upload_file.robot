*** Settings ***
Library         SeleniumLibrary
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/common.robot
Resource        config/config.robot
Resource        pages/loginPage_fsh.robot
Resource        business_keyword/job.robot
Resource        business_keyword/workflow.robot


Suite Setup    Run Keywords
...     open browser to login page
...     AND     login to webapp     ${USERNAME}     ${PASSWORD}

Test Setup    test setup for upload test cases

#Suite Teardown  close browser


*** Variables ***
${WORKFLOW_PIPELINE}           Medical Expense
${png_file_name}            healthcheck_png_needtoreview.png
${tif_file_name}            healthcheck_tif_needtoreview.tif
${pdf_file_name}            healthcheck_pdf_needtoreview.pdf
${need_to_review_status}       Need to review



*** Test Cases ***
Test Case: Upload PNG File Successfully
    [Documentation]
    ...     Upload PNG file and verify job status
    Upload file to workflow and verify status     ${png_file_name}   ${need_to_review_status}

Test Case: Upload TIF File Successfully
    [Documentation]
    ...     Upload TIF file and verify job status
    Upload file to workflow and verify status     ${tif_file_name}    ${need_to_review_status}

Test Case: Upload PDF File Successfully
    [Documentation]
    ...     Upload  file and verify job status
    Upload file to workflow and verify status     ${pdf_file_name}    ${need_to_review_status}

*** Keywords ***
test setup for upload test cases
    [Documentation]
    ...  This contains all setup steps for upload file test cases
    navigate to all workflows page when there is existing workflow
    navigate to create workflow page
    ${hc_workflow_code}=   create workflow with default setting        ${WORKFLOW_PIPELINE}
    navigate to all workflows page when there is existing workflow
    select workflow to open workflow page       ${hc_workflow_code}

