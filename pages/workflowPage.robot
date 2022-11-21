*** Settings ***
Library     SeleniumLibrary
Library     String
Library     OperatingSystem
Library     Collections
Library     CSVLibrary
Library     DateTime
Resource    common.robot
Resource    config/sys_config.robot
Resource    pages/ocrResultEditorPage_fsh.robot


*** Variables ***
${workflow_name_loc}            xpath://p[@class='chakra-text css-1ikj9zq']
${upload_button}                 xpath://button[text()= 'Upload']

${input_file_field}             xpath://div[@class='css-zr3fpy']/input
${close_dialog_button}          xpath://button[@aria-label='Close popup']
${success_toast_popup}          xpath://div[@class='css-9lauk']/span


${job_checkbox_cell}            xpath://table[@class='chakra-table css-mnprn']/tbody/tr[index]/td[1]/label
${job_name_cell}                xpath://table[@class='chakra-table css-mnprn']/tbody/tr[index]/td[3]
${job_status_cell}              xpath://table[@role='table']/tbody/tr[@role='row'][index]/td[@role='cell'][6]/span/p
${job_download_button}          xpath://table[@role='table']/tbody/tr[@role='row'][index]/td[@role='cell'][7]/div/button[@aria-label='download-file']
${job_delete_button}            xpath://table[@role='table']/tbody/tr[@role='row'][index]/td[@role='cell'][7]/div/button[@aria-label='delete-file']


${download_button}              xpath://button[text()= 'Download']
${bunch_delete_button}          xpath://button[text()= 'Delete']

${toast_popup}                  xpath://div[@class='css-njbp03']/div

${job_del_confirm_msg}          xpath://div[@class='chakra-modal__body css-qlig70']
${job_del_confirm_no_btn}       xpath://button[@class='chakra-button css-h1lfex']
${job_del_confirm_yes_btn}      xpath://button[@class='chakra-button css-1hlj88b']

${page_info_loc}                xpath://div[@id="auth-layout-body"]/div/div/div[3]/div/div[3]

${DELETE_CONFIRM_MSG}               Are you sure you want to delete the selected files?
${BULK_DOWNLOAD_UNSUCCESS_MSG}      One of the selected jobs has not been processed or has encountered an error, please retry later or deselect unfinished job(s) to continue the download
${SINGLE_DELETE_SUCCESS_MSG}        has been deleted successfully
${BULK_DELETE_SUCCESS_MSG}          Selected files has been deleted successfully.
${SINGLE_DELETE_UNSUCCESS_MSG}      An error has occurred when deleting

*** Keywords ***
press upload button
    [Documentation]
    ...     click on Upload button
    wait and click element      ${upload_button}    ${SMALL_RETRY_COUNT}

browse file to upload
    [Documentation]
    ...     click on Browse button
    ...     select a file and upload
    [Arguments]    ${file_name}
    Wait Until Page Contains Element      ${input_file_field}     5s
    ${file_path}=    Catenate    SEPARATOR=     ${EXEC_DIR}${/}data${/}    ${file_name}
    wait and choose file    ${input_file_field}   ${file_path}  ${MEDIUM_RETRY_COUNT}

close the upload dialog
    [Documentation]
    ...     press [x] button to close the dialog for file upload
    wait and click element      ${close_dialog_button}      ${SMALL_RETRY_COUNT}

verify file is uploaded successfully
    [Documentation]
    ...     Verify the toast message
    [Arguments]    ${file_name}
    wait until element visible  ${success_toast_popup}     ${MEDIUM_RETRY_COUNT}
    ${text}=       Catenate     Yah !    ${file_name}     is uploaded.
    Element Text Should Be      ${success_toast_popup}     ${text}
#    wait until element invisible    ${success_toast_popup}     ${MEDIUM_RETRY_COUNT}

verify uploaded file information
    [Documentation]
    ...     Verify if the workflow name, workflow description and workflow code are correct
    [Arguments]    ${row_index}   ${file_name}
    ${job_name_cell}=     Replace String    ${job_name_cell}      index       ${row_index}
    wait until element visible  ${job_name_cell}    ${MEDIUM_RETRY_COUNT}
    Element Should Contain      ${job_name_cell}      ${file_name}

get job status
    [Documentation]
    ...     Get the job status based on the row index of job on job table
    [Arguments]    ${row_index}
    ${job_status_cell}=     Replace String    ${job_status_cell}      index       ${row_index}
    wait until element visible  ${job_status_cell}    ${MEDIUM_RETRY_COUNT}
    ${status}=  Get Text        ${job_status_cell}
    [Return]    ${status}

verify job status
    [Documentation]
    ...     Get the final status of job processed by AI and verify if it is expected status
    [Arguments]    ${row_index}     ${expected_status}
    ${status}=                      get job status     ${row_index}
    ${job_download_button}=        Replace String      ${job_download_button}      index       ${row_index}

    WHILE   '${status}'=='PENDING'
        wait until element disabled     ${job_download_button}  ${SMALL_RETRY_COUNT}
        Sleep    5s
        Reload Page
        ${status}=  get job status     ${row_index}
    END
    WHILE   '${status}'=='PROCESSING'
        wait until element disabled     ${job_download_button}  ${SMALL_RETRY_COUNT}
        Sleep    5s
        Reload Page
        ${status}=  get job status     ${row_index}
    END
    Should Be Equal As Strings  ${status}   ${expected_status}  ignore_case=True

download OCR result file for single job
    [Documentation]
    ...     Download the OCR Result file for single job
    ...     and verify if file exists in desired location
    ...     and verify CSV file content
    [Arguments]    ${row_index}
    ${workflow_name}=         Get Text      ${workflow_name_loc}
    @{status_list}=           Create List     NEED TO REVIEW       DONE
    ${job_download_button}=        Replace String    ${job_download_button}      index       ${row_index}
    ${job_name_cell}=              Replace String    ${job_name_cell}            index       ${row_index}
    ${job_status_cell}=            Replace String    ${job_status_cell}            index       ${row_index}

    wait until element visible      ${job_name_cell}   ${SMALL_RETRY_COUNT}
    ${job_name}=                   Get Text    ${job_name_cell}
    ${job_status}=                  Get Text        ${job_status_cell}

    #Verify if the job is in Need to Review or Done status
    Should Contain                  ${job_status}   @{status_list}

    #Verify if Download button is enabled
    wait until element enabled      ${job_download_button}     ${SMALL_RETRY_COUNT}

    #Click Download button
    wait and click element          ${job_download_button}     ${SMALL_RETRY_COUNT}

    #verify popup message
    ${expected_msg}=                Catenate    Downloading     ${job_name}
    verify toast popup on workflow page         ${expected_msg}

    #verify if number of file in exported folder
    ${file}=    download should be done

    #verify file name
    ${name}=            Remove String Using Regexp  ${job_name}     \.(...)$
    ${file_name}=       Catenate     SEPARATOR=_    ${workflow_name}    ${name}
    ${file_name}=       Catenate     SEPARATOR=     ${file_name}        .csv
    File Should Exist   ${OUTPUT_DIR}${/}${file_name}

    #Get key list and value list in OCR Editor
    open editor page    ${row_index}
    ${key_list}=        get the ocr key list
    ${value_list}=       get the ocr value list
    close editor page
    verify csv file content     ${file}     ${key_list}     ${value_list}   1

verify csv file content
    [Documentation]
    ...     Verify if the CSV file content is matching with the key list and value list in OCR Result Editor
    [Arguments]    ${file}      ${key_list}     ${value_list}     ${csv_row}=default 1
    ${lines}=    Read Csv File To List  ${file}
    ${csv_key_list}=         Get From List   ${lines}    0
    ${csv_value_list}=       Get From List   ${lines}    ${csv_row}
    Lists Should Be Equal    ${csv_key_list}         ${key_list}
    Lists Should Be Equal    ${csv_value_list}       ${value_list}




open editor page
    [Documentation]
    ...     Click on job to open Editor page
    [Arguments]    ${row_index}
    @{status_list}=           Create List     NEED TO REVIEW       DONE
    ${job_name_cell}=              Replace String    ${job_name_cell}            index       ${row_index}
    ${job_status_cell}=            Replace String    ${job_status_cell}            index       ${row_index}
    ${job_status}=                  Get Text        ${job_status_cell}

    #Verify if the job is in Need to Review or Done status
    Should Contain                  ${job_status}   @{status_list}

    #Click on job name
    wait and click element          ${job_name_cell}     ${SMALL_RETRY_COUNT}

    #verify if the editor page is opened
    check if editor page is opened

check if workflow page is opened
    [Documentation]
    ...     Check if the Workflow page is opened.
    Wait Until Element Visible    ${upload_button}      ${SMALL_RETRY_COUNT}

verify OCR result file for multiple jobs
    [Documentation]
    ...     Download the OCR Result file for multiple jobs
    ...     and verify if file exists in desired location
    ...     and verify CSV file content
    [Arguments]    @{row_list}
    ${workflow_name}=         Get Text      ${workflow_name_loc}

    #verify if number of file in exported folder
    ${date}=    Get Current Date        result_format=%Y%m%d%H%M%S
    Sleep   2s
    ${file}=    download should be done

    #verify file name
    ${file_name}=       Catenate     SEPARATOR=_    ${workflow_name}    ${date}
    ${file_name}=       Catenate     SEPARATOR=     ${file_name}        .csv
    File Should Exist   ${OUTPUT_DIR}${/}${file_name}

    #Get key list and value list in OCR Editor
    ${csv_row}=       Set Variable    1
    FOR     ${row_index}   IN  @{row_list}
        ${job_name_cell}=               Replace String    ${job_name_cell}            index       ${row_index}
        wait until element visible      ${job_name_cell}   ${SMALL_RETRY_COUNT}
        ${job_name}=                    Get Text    ${job_name_cell}
        open editor page    ${row_index}
        ${key_list}=        get the ocr key list
        ${value_list}=       get the ocr value list
        close editor page
        ${list1}=  Create List    filename
        ${list2}=  Create List    ${job_name}
        ${new_key_list}=    Combine Lists    ${list1}   ${key_list}
        ${new_value_list}=  Combine Lists    ${list2}   ${value_list}
        verify csv file content     ${file}     ${new_key_list}     ${new_value_list}    ${csv_row}
        ${csv_row}=   Set Variable    ${csv_row}+1
    END

select multiple jobs and press Donwload button
    [Arguments]    @{row_list}
    select multiple jobs   @{row_list}

    #verify if Download button exists and enabled
    wait until element enabled      ${download_button}   ${SMALL_RETRY_COUNT}
    wait and click element          ${download_button}   ${SMALL_RETRY_COUNT}

delete single job successfully and verify confirmation dialog
    [Arguments]    ${row_index}
    ${workflow_name}=         Get Text      ${workflow_name_loc}
    ${job_delete_button}=          Replace String    ${job_delete_button}     index       ${row_index}
    ${job_name_cell}=              Replace String    ${job_name_cell}         index       ${row_index}
    ${job_status_cell}=            Replace String    ${job_status_cell}       index       ${row_index}

    wait until element visible      ${job_name_cell}   ${SMALL_RETRY_COUNT}
    ${job_name}=                    Get Text    ${job_name_cell}
    ${job_status}=                  Get Text        ${job_status_cell}

    #Verify if Delete button is enabled
    wait until element enabled      ${job_delete_button}     ${SMALL_RETRY_COUNT}

    #Click Delete button
    wait and click element          ${job_delete_button}     ${SMALL_RETRY_COUNT}

    #Verify popup dialog
    verify confirmation dialog for single delete    ${job_name}


press yes button on job delete confirmation dialog
    wait and click element              ${job_del_confirm_yes_btn}       ${SMALL_RETRY_COUNT}
    wait until element invisible        ${job_del_confirm_msg}          ${SMALL_RETRY_COUNT}


verify toast popup on workflow page
    [Arguments]    ${expected_msg}
    wait until element visible      ${toast_popup}         ${SMALL_RETRY_COUNT}
    ${actual_msg}=                  Get Text    ${toast_popup}
    Should Be Equal As Strings      ${actual_msg}   ${expected_msg}
    wait until element invisible    ${toast_popup}         ${SMALL_RETRY_COUNT}

verify toast popup when job is deleted successfully
    [Arguments]    ${job_name}
    ${expected_msg}=                Catenate        ${job_name}         ${SINGLE_DELETE_SUCCESS_MSG}
    verify toast popup on workflow page   ${expected_msg}

verify toast popup when bulk jobs are deleted successfully
    ${expected_msg}=        Set Variable        ${BULK_DELETE_SUCCESS_MSG}
    verify toast popup on workflow page   ${expected_msg}

verify toast popup when job is deleted unsuccessfully
    [Arguments]    ${job_name}
    ${expected_msg}=                Catenate        ${SINGLE_DELETE_UNSUCCESS_MSG}      ${job_name}
    verify toast popup on workflow page   ${expected_msg}

verify toast popup when bulk jobs are download unsuccessfully
    [Arguments]
    ${expected_msg}=        Set Variable        ${BULK_DOWNLOAD_UNSUCCESS_MSG}
    verify toast popup on workflow page   ${expected_msg}

verify total number of jobs is correct
    [Documentation]
    ...     Verify that the total number of job decrease 1 after deleting
    [Arguments]    ${expected_number}
    ${string}=       Get Text    ${page_info_loc}
    @{after_del_total_job}=         Split String      ${string}
    ${after_del_total_job}=         Set Variable    ${after_del_total_job}[2]
    ${after_del_total_job}=         Convert To Integer    ${after_del_total_job}
    Should Be Equal As Integers         ${expected_number}             ${after_del_total_job}

select multiple jobs
    [Arguments]    @{row_list}
    Sort List       ${row_list}
    FOR     ${row_index}    IN      @{row_list}
        ${job_checkbox}=    Set Variable    ${job_checkbox_cell}
        ${job_checkbox}=    Replace String    ${job_checkbox}             index       ${row_index}
        Wait Until Page Contains Element        ${job_checkbox}
        Scroll Element Into View                ${job_checkbox}
        Sleep   1s
        wait and click element                  ${job_checkbox}     ${SMALL_RETRY_COUNT}
    END

press delete button for bunch delete
    [Arguments]
    #verify if Delete button exists and enabled
    wait until element enabled      ${bunch_delete_button}   ${SMALL_RETRY_COUNT}
    wait and click element          ${bunch_delete_button}   ${SMALL_RETRY_COUNT}

verify confirmation dialog for single delete
    [Arguments]    ${job_name}
    wait until element visible      ${job_del_confirm_msg}         ${SMALL_RETRY_COUNT}
    ${actual_msg}=                  Get Text    ${job_del_confirm_msg}
    ${expected_msg}=                Replace String    ${DELETE_CONFIRM_MSG}     the selected files       ${job_name}
    Should Be Equal As Strings      ${actual_msg}   ${expected_msg}

verify confirmation dialog for bunch delete
    wait until element visible      ${job_del_confirm_msg}         ${SMALL_RETRY_COUNT}
    ${actual_msg}=                  Get Text    ${job_del_confirm_msg}
    Should Be Equal As Strings      ${actual_msg}   ${DELETE_CONFIRM_MSG}

verify delete button for bunch delete is disabled
    wait until element disabled      ${bunch_delete_button}   ${SMALL_RETRY_COUNT}



