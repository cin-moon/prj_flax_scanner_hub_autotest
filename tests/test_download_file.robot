*** Settings ***
Library         SeleniumLibrary
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/common.robot
Resource        config/config.robot
Resource        pages/homePage_fsh.robot
Resource        pages/loginPage_fsh.robot
Resource        pages/workflowPage.robot
Resource        business_keyword/job.robot
Resource        business_keyword/workflow.robot


Suite Setup    Run Keywords
...     open browser to login page
...     AND     login to webapp     ${USERNAME}     ${PASSWORD}

Test Setup    test setup for download ocr result test cases

#Suite Teardown  close browser


*** Variables ***
${WORKFLOW_PIPELINE}            Health Check
${hc_png_file_name}            healthcheck_png_needtoreview.png
${hc_tif_file_name}            healthcheck_tif_needtoreview.tif
${hc_pdf_file_name}            healthcheck_pdf_needtoreview.pdf
${need_to_review_status}       Need to review
@{row_list}=                   1    2





*** Test Cases ***
Test Case: Download OCR result file for single job
    [Documentation]
    ...     Download the OCR Result file for single job
    ...     and verify if file exists in desired location
    ...     and verify CSV content
#    select a workflow from the workflow menu list       Health Check UqReX7wtDkcP
    upload file to workflow and verify status   ${hc_png_file_name}     ${need_to_review_status}
    download OCR result file for single job     1


Test Case: Download OCR result file for multiple jobs
    [Documentation]
    ...     Download the OCR Result file for multiple jobs
    ...     and verify if file exists in desired location
    ...     and verify CSV content
#    select a workflow from the workflow menu list       Health Check tQNkBNznizJb
    upload file to workflow and verify status   ${hc_png_file_name}     ${need_to_review_status}
    upload file to workflow and verify status   ${hc_tif_file_name}     ${need_to_review_status}
    select multiple jobs and press Donwload button   @{row_list}
    verify OCR result file for multiple jobs    @{row_list}


Test Case: Download OCR Result File Unsuccessfully For Multiple Jobs
    [Documentation]
    ...     Download the OCR Result file for multiple jobs which contain Processing/Pending jobs
    ...     and verify error message
    upload file to workflow and verify status   ${hc_png_file_name}     ${need_to_review_status}
    upload file to workflow                     ${hc_pdf_file_name}
    select multiple jobs and press Donwload button   @{row_list}
    verify toast popup when bulk jobs are download unsuccessfully


*** Keywords ***
test setup for download ocr result test cases
    [Documentation]
    ...  This contains all setup steps for downlaod OCR result test cases
    Empty Directory     ${OUTPUT_DIR}
    navigate to all workflows page when there is existing workflow
    navigate to create workflow page
    ${workflow_code}=   create workflow with default setting        ${WORKFLOW_PIPELINE}
    navigate to all workflows page when there is existing workflow
    select workflow to open workflow page       ${workflow_code}

