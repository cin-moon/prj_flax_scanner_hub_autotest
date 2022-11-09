*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    common.robot
Resource    config/sys_config.robot

*** Variables ***
${basic_info_edit_btn}                  xpath://div[@class='css-1p9p4ub']/div[2]/button
${pipeline_fields_edit_btn}             xpath://div[@class='css-1p9p4ub']/div[5]/button
${permission_edit_btn}                  xpath://div[@class='css-1p9p4ub']/div[7]/button

${workflow_name_value_display}          xpath://div[@class='css-1p9p4ub']/div[1]/div[2]
${workflow_desc_value_display}          xpath://div[@class='css-1p9p4ub']/div[1]/div[6]

${workflow_pipeline_name_display}       xpath://div[@class='css-1p9p4ub']/div[3]/div[2]

${workflow_name_txtbox}                 xpath://div[@class='css-1p9p4ub']/div[1]/div[2]/input
${description_txtbox}                   xpath://div[@class='css-1p9p4ub']/div[1]/div[6]/textarea
${basic_info_save_btn}                  xpath://div[@class='css-1p9p4ub']/div[2]/button[2]

${pipeline_btn}                         xpath://div[@class='css-kf8if4' and text()='name']
${pipeline_save_btn}                    xpath://div[@class='css-1p9p4ub']/div[5]/button[2]
${selected_pipeline_btn}                xpath://div[@class='chakra-stack css-1eii47k']/div/div[2]
${confirmation_dialog}                  xpath://section[@class='chakra-modal__content css-hxtskf']/div/p
${confirm_yes_button}                   xpath://section[@class='chakra-modal__content css-hxtskf']/footer/button[2]
${confirm_no_button}                    xpath://section[@class='chakra-modal__content css-hxtskf']/footer/button[1]
${top_output_field_checkbox}            xpath://tr[@class='css-1vg6q84']/th[1]/label/span
${output_field_checkbox}                xpath://span[@class='chakra-checkbox__control css-xxkadm']
${confirmation_msg}                     Changing the AI pipeline will reset the analytics of this workflow. Do you wish to continue?

${success_toast_message}                xpath://li[@class='chakra-toast']/div/div/div/div
${edit_wf_loading_icon}                 xpath://div[@class='css-1jua4v1']/div[2]/span

${basic_info_success_message}           Success to update detail
${pipeline_success_message}             Success to update executor



*** Keywords ***
check if edit workflow page is opened
    [Documentation]
    ...     check if Edit page for workflow is opened
    wait until element visible    ${workflow_name_value_display}    ${MEDIUM_RETRY_COUNT}

open editor section for basic information
    [Documentation]
    ...     press Edit button on Basic Information section
    wait and click element          ${basic_info_edit_btn}      ${SMALL_RETRY_COUNT}
    wait until element visible      ${workflow_name_txtbox}     ${SMALL_RETRY_COUNT}

open editor section for pipeline and output field
    [Documentation]
    ...     press Edit button on AI pipeline and fields section
    wait and click element          ${pipeline_fields_edit_btn}      ${SMALL_RETRY_COUNT}
    wait until element invisible      ${edit_wf_loading_icon}     ${SMALL_RETRY_COUNT}

edit workflow name
    [Documentation]
    ...     edit the workflow name
    [Arguments]    ${new_workflow_name}
    wait and input text         ${workflow_name_txtbox}      ${new_workflow_name}       ${SMALL_RETRY_COUNT}
    Sleep      1s
    wait and click element      ${basic_info_save_btn}       ${SMALL_RETRY_COUNT}
    verify success toast message as workflow is update successfully     ${basic_info_success_message}
    wait until element visible      ${workflow_name_value_display}     ${SMALL_RETRY_COUNT}

verify workflow name after update
    [Arguments]    ${new_workflow_name}
    ${value}=       Get Text        ${workflow_name_value_display}
    Should Be Equal As Strings    ${value}    ${new_workflow_name}

edit workflow description
    [Documentation]
    ...     edit the workflow description
    [Arguments]    ${new_workflow_desc}
    wait and input text         ${description_txtbox}      ${new_workflow_desc}       ${SMALL_RETRY_COUNT}
    Sleep      1s
    wait and click element      ${basic_info_save_btn}       ${SMALL_RETRY_COUNT}
    verify success toast message as workflow is update successfully     ${basic_info_success_message}
    wait until element visible      ${workflow_name_value_display}     ${SMALL_RETRY_COUNT}

verify workflow description after update
    [Arguments]    ${new_workflow_desc}
    ${value}=       Get Text        ${workflow_desc_value_display}
    Should Be Equal As Strings    ${value}    ${new_workflow_desc}

edit workflow pipeline and confirm changes
    [Documentation]
    ...     select another pipeline
    ...     on confirmation dialog, press Yes
    [Arguments]    ${new_pipeline}
    #get current pipeline name
    ${current_pipeline}=    Get Text    ${selected_pipeline_btn}

    #select new pipeline
    ${pipeline_btn}=  	Replace String	   ${pipeline_btn}   name      ${new_pipeline}
    wait and click element      ${pipeline_btn}         ${SMALL_RETRY_COUNT}

    #if new pipeline is different with current pipeline, check confirmation dialog
    ${result}=  Run Keyword And Return Status    Should Be Equal As Strings     ${current_pipeline}     ${new_pipeline}
    IF  ${result}==False
        wait until element visible          ${confirmation_dialog}          ${SMALL_RETRY_COUNT}
        ${text}=    Get Text                ${confirmation_dialog}
        Should Be Equal As Strings          ${text}                         ${confirmation_msg}
        #press Yes button
        wait and click element              ${confirm_yes_button}           ${SMALL_RETRY_COUNT}
        wait until element invisible        ${confirmation_dialog}          ${SMALL_RETRY_COUNT}
    END
    wait and click element          ${pipeline_save_btn}        ${SMALL_RETRY_COUNT}
    verify success toast message as workflow is update successfully     ${pipeline_success_message}
    wait until element visible      ${workflow_pipeline_name_display}     ${SMALL_RETRY_COUNT}
    Sleep    1s

edit workflow pipeline and not confirm changes
    [Documentation]
    ...     select another pipeline
    ...     on confirmation dialog, press No
    [Arguments]    ${new_pipeline}
    #get current pipeline name
    ${current_pipeline}=    Get Text    ${selected_pipeline_btn}

    #select new pipeline
    ${pipeline_btn}=  	Replace String	   ${pipeline_btn}   name      ${new_pipeline}
    wait and click element      ${pipeline_btn}         ${SMALL_RETRY_COUNT}

    #if new pipeline is different with current pipeline, check confirmation dialog
    ${result}=  Run Keyword And Return Status    Should Be Equal As Strings     ${current_pipeline}     ${new_pipeline}
    IF  ${result}==False
        wait until element visible          ${confirmation_dialog}          ${SMALL_RETRY_COUNT}
        ${text}=    Get Text                ${confirmation_dialog}
        Should Be Equal As Strings          ${text}                         ${confirmation_msg}
        #press No button
        wait and click element              ${confirm_no_button}           ${SMALL_RETRY_COUNT}
        wait until element invisible        ${confirmation_dialog}          ${SMALL_RETRY_COUNT}
    END
    wait and click element          ${pipeline_save_btn}        ${SMALL_RETRY_COUNT}
    wait until element visible      ${workflow_pipeline_name_display}     ${SMALL_RETRY_COUNT}
    Sleep    1s

verify workflow pipeline after update
    [Arguments]    ${expected_pipline}
    ${value}=       Get Text        ${workflow_pipeline_name_display}
    Should Be Equal As Strings    ${value}    ${expected_pipline}


verify success toast message as workflow is update successfully
    [Documentation]
    ...     Verify the toast message
    [Arguments]    ${expect_message}
    wait until element visible  ${success_toast_message}     ${MEDIUM_RETRY_COUNT}
    Element Text Should Be      ${success_toast_message}       ${expect_message}
    wait until element invisible    ${success_toast_message}     ${MEDIUM_RETRY_COUNT}



select output fields
    [Documentation]
    ...     Select the output fields based on output fields' id
    [Arguments]    @{output_field_id_list}
    wait and click element              ${top_output_field_checkbox}           ${SMALL_RETRY_COUNT}
    FOR    ${id}    IN      ${output_field_id_list}
    ${count}=       Get Element Count       ${output_field_checkbox}
