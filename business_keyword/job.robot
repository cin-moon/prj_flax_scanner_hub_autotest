*** Settings ***
Library         SeleniumLibrary
Library         String
Library         DependencyLibrary
Library         OperatingSystem
Resource        pages/workflowPage.robot

*** Keywords ***
upload file to workflow and verify status
    [Documentation]
    ...  Upload a file to workflow and verify status
    [Arguments]    ${file_name}   ${expected_status}
    upload file to workflow     ${file_name}
    verify job status  1   ${expected_status}

upload file to workflow
    [Arguments]    ${file_name}
    press upload button
    browse file to upload   ${file_name}
    verify file is uploaded successfully    ${file_name}
    close the upload dialog
    verify uploaded file information    1     ${file_name}