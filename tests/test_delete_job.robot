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

Test Setup    test setup for delete job test cases

Suite Teardown  close browser

*** Variables ***
${WORKFLOW_PIPELINE}            Health Check
${hc_png_file_name1}            healthcheck_png_needtoreview.png
${hc_png_file_name2}            healthcheck_pdf_needtoreview.pdf
${hc_png_file_name3}            healthcheck_tif_needtoreview.tif
${need_to_review_status}        Need to review
@{row_list}=                     1       2

*** Test Cases ***
Test Case: Test Delete Job Successfully
    [Documentation]
    ...     Job is deleted successfully when it is not in Processing status
    upload file to workflow and verify status     ${hc_png_file_name1}   ${need_to_review_status}
    delete single job successfully and verify confirmation dialog        1
    press yes button on job delete confirmation dialog
    verify toast popup when job is deleted successfully     ${hc_png_file_name1}
    verify total number of jobs is correct      0

Test Case: Test Delete Job Unsuccessfully
    [Documentation]
    ...     Job is deleted unsuccessfully when it is in Processing status
    upload file to workflow     ${hc_png_file_name2}
    delete single job successfully and verify confirmation dialog        1
    press yes button on job delete confirmation dialog
    verify toast popup when job is deleted unsuccessfully     ${hc_png_file_name2}
    verify total number of jobs is correct      1

Test Case: Delete Multiple Jobs Successfully
    [Documentation]
    ...     Select Multiple Jobs and Delete Successfully
    upload file to workflow and verify status     ${hc_png_file_name1}   ${need_to_review_status}
    upload file to workflow and verify status     ${hc_png_file_name3}   ${need_to_review_status}
    select multiple jobs    @{row_list}
    press delete button for bunch delete
    verify confirmation dialog for bunch delete
    press yes button on job delete confirmation dialog
    verify toast popup when bulk jobs are deleted successfully
    verify total number of jobs is correct      0

Test Case: Delete Multiple Jobs UnSuccessfully
    [Documentation]
    ...     Jobs are deleted unsuccessfully because there are jobs in Processing status
    upload file to workflow and verify status     ${hc_png_file_name1}   ${need_to_review_status}
    upload file to workflow     ${hc_png_file_name2}
    select multiple jobs    @{row_list}
    verify delete button for bunch delete is disabled


*** Keywords ***
test setup for delete job test cases
    [Documentation]
    ...  This contains all setup steps for delete job test cases
    navigate to all workflows page when there is existing workflow
    navigate to create workflow page
    ${workflow_code}=   create workflow with default setting        ${WORKFLOW_PIPELINE}
    navigate to all workflows page when there is existing workflow
    select workflow to open workflow page       ${workflow_code}