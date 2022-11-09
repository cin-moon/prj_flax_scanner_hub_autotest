*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot
Resource    pages/editWorkflow.robot

*** Variables ***
${add_new_worfklow_button}          id:add-new-workflow-btn

${workflow_name_location}           xpath://tbody[@role='rowgroup']/tr[index]/td[1]
${workflow_code_location}           xpath://tbody[@role='rowgroup']/tr[index]/td[2]
${workflow_desc_location}           xpath://tbody[@role='rowgroup']/tr[index]/td[3]
${workflow_edit_button}             xpath://tbody[@role='rowgroup']/tr[index]/td[4]/div/button[@title='Edit']
${workflow_delete_button}           xpath://tbody[@role='rowgroup']/tr[index]/td[4]/div/button[@title='Delete']

${next_page_button}                 xpath:(//button[@class='chakra-button css-13tiee3'])[2]
${previous_page_button}             xpath:(//button[@class='chakra-button css-13tiee3'])[1]
${paging_dropdown_button}           xpath://select[@class='chakra-select css-i01oeo']
${paging_option}                    xpath://select[@class='chakra-select css-i01oeo']/option[@value='this']

${workflow_table}                   xpath://tbody[@role='rowgroup']/tr
${all_wf_loading_icon}              xpath://span[@class='Loader_container__L10I9']

${confirmation_dialog_header}       xpath://header[@class='chakra-modal__header css-1r0vkau']/p
${confirmation_dialog_msg_line1}    xpath://section[@class='chakra-modal__content css-hxtskf']/div/p[1]
${confirmation_dialog_msg_line2}    xpath://section[@class='chakra-modal__content css-hxtskf']/div/p[2]
${workflow_name_input_txtobx}       xpath://section[@class='chakra-modal__content css-hxtskf']/div/div/input
${confirmation_delete_btn}          xpath://button[@class='chakra-button css-dxmwj9' and text()='Delete']
${confirmation_cancel_btn}          xpath://button[@class='chakra-button css-19gj0hv' and text()='Cancel']
${confirmation_close_btn}           xpath://button[@class='chakra-modal__close-btn css-1mtyfbb']
${success_wf_delete_toast_msg}      xpath://div[@class='chakra-alert__desc css-zycdy9']
${error_wf_delete_msg_location}     xpath://section[@class='chakra-modal__content css-hxtskf']/div/p[3]

${EXPECTED_DIALOG_HEADER}           Delete workflow confirmation
${EXPECTED_1st_LINE_MSG}            Are you sure you want to delete
${EXPECTED_2nd_LINE_MSG}            Please enter the correct name of the workflow to delete.
${EXPECTED_SUCCESS_DELETE_MSG}      The workflow has been deleted successfully
${EXPECTED_ERROR_DELETE_MSG}        Please enter the correct name of the workflow to delete.


*** Keywords ***
navigate to create workflow page
    [Documentation]
    ...     click Add New Workflow button to open Create Workflow page ...
    wait and click element      ${add_new_worfklow_button}      ${SMALL_RETRY_COUNT}
#    Sleep    2s
    check if create workflow page opens

verify workflow information
    [Documentation]
    ...     Verify if the workflow name, workflow description and workflow code are correct
    [Arguments]    ${row}   ${workflow_name}     ${workflow_code}        ${workflow_desc}
    ${workflow_name_location}=     Replace String    ${workflow_name_location}     index   ${row}
    ${workflow_code_location}=     Replace String    ${workflow_code_location}     index   ${row}
    ${workflow_desc_location}=     Replace String    ${workflow_desc_location}     index   ${row}
    Wait Until Element Visible    ${workflow_name_location}     ${LARGE_RETRY_COUNT}
    Sleep   1s
    Element Should Contain      ${workflow_name_location}      ${workflow_name}
    Element Should Contain      ${workflow_code_location}      ${workflow_code}
    Element Should Contain      ${workflow_desc_location}      ${workflow_desc}

choose number of items per page
    [Documentation]
    ...     Open the paging drop down list and select the desired number of items per page.
    [Arguments]    ${item_per_page_number}
    Wait Until Page Contains Element        ${paging_dropdown_button}
    Select From List By Value               ${paging_dropdown_button}   ${item_per_page_number}
#    Sleep    4s
    Wait Until Element Invisible        ${all_wf_loading_icon}      ${LARGE_RETRY_COUNT}


move to the last page
    [Documentation]
    ...     Click on Next page button until reaching the last page
    ${enabled_status} =  Run Keyword And Return Status    Element Should Be Enabled  ${next_page_button}
    WHILE    ${enabled_status}
    wait and click element         ${next_page_button}      ${SMALL_RETRY_COUNT}
    Wait Until Element Invisible        ${all_wf_loading_icon}      ${LARGE_RETRY_COUNT}
    ${enabled_status} =  Run Keyword And Return Status    Element Should Be Enabled  ${next_page_button}
    END

find workflow
    [Documentation]
    ...     Find the desired workflow based on workflow code and return its row index.
    ...     If not find any matching, return failure.
    [Arguments]    ${workflow_code}
    choose number of items per page     100

    #loop through all pages
    ${last_page_flag}=      Set Variable    ${True}
    WHILE    ${last_page_flag}
        ${row_count}=   Get Element Count       ${workflow_table}
        ${row_count}=   Set Variable    ${row_count} + 1
        ${result}=    Set Variable    ${False}
        FOR     ${row}      IN RANGE    1   ${row_count}
#            ${string}=  Catenate    SEPARATOR=      xpath://tbody[@role='rowgroup']/tr[     ${row}      ]/td[2]/div/p
            ${workflow_code_cell}=  Set Variable    ${workflow_code_location}
            ${row}=     Convert To String    ${row}
            ${workflow_code_cell}=  Replace String    ${workflow_code_cell}     index         ${row}
            ${actual_workflow_code}=   Get Text    ${workflow_code_cell}
            ${result}=  Run Keyword And Return Status    Should Be Equal As Strings  ${actual_workflow_code}   ${workflow_code}     ignore_case=True    strip_spaces=True   collapse_spaces=True
            IF    ${result}
                BREAK
            END
        END
        #break the loop if workflow is found
        ${last_page_flag}=      Run Keyword And Return Status    Element Should Be Enabled  ${next_page_button}
        IF    ${last_page_flag}
            wait and click element      ${next_page_button}        ${SMALL_RETRY_COUNT}
            check if all workflows page is opened
        END
        IF    ${result}
            BREAK
        END
    END

    #return row index if workflow is found
    IF    ${result}
        RETURN      ${row}
    ELSE
        ${message}=     Catenate    Cannot find the workflow with workflow code     ${workflow_code}
        Fail    ${message}
    END


check if all workflows page is opened
    [Documentation]
    ...     Check if the All Workflow pages is opened
    wait until element invisible    ${all_wf_loading_icon}          ${SMALL_RETRY_COUNT}
    Wait Until Element Visible      ${add_new_worfklow_button}      ${SMALL_RETRY_COUNT}

open edit workflow page
    [Documentation]
    ...     Find workflow based on workflow code and open edit page for workflow
    [Arguments]    ${workflow_code}
    ${row}=   find workflow   ${workflow_code}
    ${row}=     Convert To String    ${row}
    ${workflow_edit_button}=     Replace String    ${workflow_edit_button}     index   ${row}

    Scroll Element Into View    ${workflow_edit_button}
    wait and click element       ${workflow_edit_button}       ${SMALL_RETRY_COUNT}
    check if edit workflow page is opened

press delete workflow button and verify initial state of confirmation dialog
    [Documentation]
    ...     Press Delete Workflow button and verify if the confirmation dialog opens.
    [Arguments]    ${workflow_code}
    ${row}=   find workflow   ${workflow_code}
    ${row}=     Convert To String    ${row}
    ${workflow_delete_button}=     Replace String    ${workflow_delete_button}     index   ${row}
    ${workflow_name_location}=     Replace String    ${workflow_name_location}     index   ${row}
    ${workflow_name}=   Get Text    ${workflow_name_location}

    Scroll Element Into View    ${workflow_delete_button}
    wait and click element       ${workflow_delete_button}       ${SMALL_RETRY_COUNT}
    check if workflow deleting confirmation dialog opens
    verify the initial state of workflow deleting confirmation dialog   ${workflow_name}
    RETURN  ${workflow_name}


check if workflow deleting confirmation dialog opens
    [Documentation]
    ...     Check if the delete workflow deleting confirmation dialog opens
    wait until element visible     ${confirmation_dialog_header}    ${SMALL_RETRY_COUNT}
    ${header}=  Get Text    ${confirmation_dialog_header}
    Should Be Equal As Strings    ${header}     ${EXPECTED_DIALOG_HEADER}

verify the initial state of workflow deleting confirmation dialog
    [Documentation]
    ...     Verify the confirmation message and the default state of confirmation textbox.
    [Arguments]    ${workflow_name}
    #Verify the confirmation message
    ${first_line_msg}=                  Get Text        ${confirmation_dialog_msg_line1}
    ${expected_first_line_msg}=         Catenate        ${EXPECTED_1st_LINE_MSG}    ${workflow_name}
    ${expected_first_line_msg}=         Catenate        SEPARATOR=      ${expected_first_line_msg}  ?
    ${second_line_msg}=     Get Text        ${confirmation_dialog_msg_line2}
    Should Be Equal As Strings    ${first_line_msg}         ${expected_first_line_msg}
    Should Be Equal As Strings    ${second_line_msg}        ${EXPECTED_2nd_LINE_MSG}

    #Verify the placeholder of the textbox and its default value
    ${placeholder}=     Get Element Attribute       ${workflow_name_input_txtobx}         placeholder
    Should Be Equal As Strings    ${placeholder}        ${workflow_name}
    Textfield Value Should Be   ${workflow_name_input_txtobx}       ${EMPTY}

enter workflow name into workflow confirmation dialog
    [Documentation]
    ...     Enter the workflow name into the workflow confirmation dialog
    [Arguments]    ${entered_workflow_name}
    wait and input text     ${workflow_name_input_txtobx}   ${entered_workflow_name}    ${SMALL_RETRY_COUNT}

press delete button on confirmation dialog
    [Documentation]
    ...     Press Delete Button On Confirmation Dialog
    wait and click element              ${confirmation_delete_btn}              ${SMALL_RETRY_COUNT}
#    wait until element invisible        ${confirmation_dialog_header}           ${SMALL_RETRY_COUNT}

press close button on confirmation dialog
    wait and click element              ${confirmation_close_btn}               ${SMALL_RETRY_COUNT}
    wait until element invisible        ${confirmation_dialog_header}           ${SMALL_RETRY_COUNT}


verify workflow is deleted
    [Documentation]
    ...     Verify if workflow is deleted
    [Arguments]    ${workflow_code}
    ${message}=     Catenate    Cannot find the workflow with workflow code     ${workflow_code}
    Run Keyword And Expect Error        ${message}      find workflow   ${workflow_code}

verify success delete toast message
    [Documentation]
    ...     Verify the toast message when workflow is deleted successfully
    wait until element visible      ${success_wf_delete_toast_msg}      ${SMALL_RETRY_COUNT}
    ${message}=     Get Text    ${success_wf_delete_toast_msg}
    Should Be Equal As Strings      ${message}        ${EXPECTED_SUCCESS_DELETE_MSG}
    wait until element invisible      ${success_wf_delete_toast_msg}      ${SMALL_RETRY_COUNT}

verify error message on workflow confirmation dialog
    [Documentation]
    ...     Verify the error message displays if wrong workflow name is entered into confirmation dialog.
    wait until element visible      ${error_wf_delete_msg_location}      ${SMALL_RETRY_COUNT}
    ${message}=     Get Text        ${error_wf_delete_msg_location}
    Should Be Equal As Strings      ${message}      ${EXPECTED_ERROR_DELETE_MSG}

select workflow to open workflow page
    [Arguments]    ${workflow_code}
    ${row}=     Find Workflow       ${workflow_code}
    ${row}=     Convert To String    ${row}
    ${workflow_name_location}=      Replace String      ${workflow_name_location}   index       ${row}
    Scroll Element Into View    ${workflow_name_location}
    wait and click element      ${workflow_name_location}       ${SMALL_RETRY_COUNT}
    check if workflow page is opened









