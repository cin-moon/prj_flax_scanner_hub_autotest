*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    OperatingSystem
Library    resources/driversync.py
Resource   config/sys_config.robot
Resource   config/config.robot

*** Variables ***




*** Keywords ***
open browser to login page
    [Documentation]
	...  Open the browser and navigates to the web url  ...
    ${driver_chrome}=    Get Chromedriver
    ${chrome_prefs}=     Create Dictionary    download.default_directory=${OUTPUT_DIR}
    ${browser}=     Convert To Lower Case  ${BROWSER}
    IF   '${browser}' == 'chrome'
        Open Browser     ${BASE_URL}    chrome    executable_path=${driver_chrome}     options=add_experimental_option("prefs",${chrome_prefs})
#    ELSE IF   '${browser}' == 'firefox'
#        ${driver_firefox}=   Get Ffdriver
#        Set Suite Variable   ${firefox_prefs}     set_preference("browser.download.folderList", 2);set_preference("browser.download.dir", r"${OUTPUT_DIR}");set_preference("browser.download.manager.showWhenStarting", False)
#        Open Browser     ${BASE_URL}    firefox   executable_path=${driver_firefox}    ff_profile_dir=${firefox_prefs}
    ELSE
        Open Browser     ${BASE_URL}    chrome    executable_path=${driver_chrome}     options=add_experimental_option("prefs",${chrome_prefs})
    END
    Maximize Browser Window
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}

close browser
    [Documentation]
	...  Close all browsers  ...
    Run Keyword And Ignore Error    Empty Directory   ${OUTPUT_DIR}
    Close All Browsers
    Log To Console  Test Completed

wait and reload current page
    [Documentation]
    ...  Delay 5s then reload current page  ...
    Sleep  5s
    Reload Page

wait and input text
    [Documentation]
	...  Input text into a text box  ...
    [Arguments]    ${locator}         ${txt_value}      ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Enabled    ${locator}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Input Text    ${locator}    ${txt_value}

wait and click element
    [Documentation]
	...  Click on a given clickable element  ...
    [Arguments]    ${locator}   ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Enabled    ${locator}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Click Element  ${locator}

wait and select value
    [Documentation]
	...  Select from a list by label  ...
    [Arguments]    ${locator}         ${value}      ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}     Select From List By Label         ${locator}    ${value}

wait and choose file
    [Documentation]
	...  Choose file to upload  ...
    [Arguments]     ${locator}         ${file}       ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}     Wait Until Page Contains Element     ${locator}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}     Choose File     ${locator}           ${file}

wait until element visible
    [Documentation]
	...  Verify that the element should be visible  ...
    [Arguments]    ${locator}      ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Visible    ${locator}

wait until element invisible
    [Documentation]
	...  Verify that the element should not be visible  ...
    [Arguments]    ${locator}       ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Not Visible   ${locator}

wait and validate element text
    [Documentation]
    ...  Validate element text  ...
    [Arguments]     ${locator}     ${txt_value}     ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}    ${RETRY_DELAY}     Wait Until Page Contains Element    ${locator}
    ${value}=    Get Element Attribute    ${locator}   value
    Should Be Equal As Strings     ${value}         ${txt_value}

wait and get elements count
    [Documentation]
    ...  Get the total of elements  ...
    [Arguments]    ${locators}      ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Visible      ${locators}
    ${count}=    Get Element Count    ${locators}
    [Return]   ${count}

wait and get elements text list
    [Documentation]
    ...  Get all elements text as a list  ...
    [Arguments]         ${locators}     ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Visible      ${locators}
    @{locators}=    Get WebElements    ${locators}
    ${results}=    Create List
    FOR   ${locator}   IN    @{locators}
        ${text}=    Get Text    ${locator}
        Append To List    ${results}    ${text}
    END
    [Return]    ${results}

wait and input text to elements
    [Documentation]
    ...  Input same text to list of elements ...
    [Arguments]         ${locators}    ${txt_value}     ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Page Contains Element     ${locators}
    @{locators}=    Get Webelements    ${locators}
    FOR  ${locator}   IN    @{locators}
        Press Keys      ${locator}      CTRL+a+BACKSPACE
        wait and input text      ${locator}      ${txt_value}   ${retryScale}
    END

wait and validate elements text
    [Documentation]
    ...  Validate elements has same text value...
    [Arguments]         ${locators}    ${txt_value}     ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}     Wait Until Page Contains Element     ${locators}
    @{locators}=    Get Webelements    ${locators}
    FOR  ${locator}   IN    @{locators}
        wait and validate element text     ${locator}      ${txt_value}     ${retryScale}
    END

download should be done
    [Documentation]
    ...  Verify that the directory has only one folder and it is not a temp file and returns path to the file ...
    [Arguments]    ${directory}=${OUTPUT_DIR}
    ${files} =    List Files In Directory    ${directory}
    Length Should Be    ${files}    1
    Should Not Match Regexp    ${files[0]}    (?i).*\\.tmp
    Should Not Match Regexp    ${files[0]}    (?i).*\\.crdownload
    ${file}    Join Path    ${directory}    ${files[0]}
    Log    File was successfully downloaded to ${file}
    [Return]    ${file}

wait until element enabled
    [Documentation]
	...  Verify that the element should be enabled  ...
    [Arguments]    ${locator}      ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Element Should Be Enabled   ${locator}

wait until element disabled
    [Documentation]
	...  Verify that the element should be disabled  ...
    [Arguments]    ${locator}      ${retryScale}
     Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Element Should Be Disabled    ${locator}

wait and get elements value list
    [Documentation]
    ...  Get all elements value as a list  ...
    [Arguments]         ${locators}     ${retryScale}
    Wait Until Keyword Succeeds    ${retryScale}     ${RETRY_DELAY}    Wait Until Element Is Visible      ${locators}
    @{locators}=    Get Webelements    ${locators}
    ${results}=    Create List
    FOR   ${locator}   IN    @{locators}
        ${text}=    Get Value    ${locator}
        Append To List    ${results}    ${text}
    END
    [Return]    ${results}






