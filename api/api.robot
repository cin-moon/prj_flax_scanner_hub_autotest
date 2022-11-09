*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary
Library     Collections
Library     String
Resource    ../config/config.robot

*** Variables ***
${GLOBAL_SESSION}       global_session

*** Keywords ***
create test session
    [Documentation]
    ...  Create common session ...
    ${GLOBAL_SESSION}=  Set Variable  global_session
    Set Test Variable  ${GLOBAL_SESSION}
    Create Session     ${GLOBAL_SESSION}  ${BASE_URL}   verify=true

delete test sessions
    Delete All Sessions

request authen header
    [Documentation]
    ...  Request bear authentication header ...
    Create Session     ${GLOBAL_SESSION}  ${BASE_URL}   verify=true
    ${payload}=        Create Dictionary  username  ${USERNAME}     password    ${PASSWORD}
    ${resp}=           POST On Session    ${GLOBAL_SESSION}   ${TOKEN_PATH}   data=${payload}
    Should Be Equal As Strings      ${resp.status_code}     200
    ${accessToken}=    Evaluate     $resp.json().get("access_token")
    ${bear_token}=     Create Dictionary    Authorization=Bearer ${accessToken}
    [Return]    ${bear_token}

verify that status code should be
    [Documentation]
    ...  Compare response status code of request and expectation ...
    [Arguments]    ${resp}   ${status_code}
    ${code}=  Convert To String    ${resp.status_code}
    Should Be Equal    ${code}     ${status_code}

verify that resp body should contain
    [Documentation]
    ...  Verify response body...
    [Arguments]    ${resp}   ${content}
    ${response_body}=  Convert To String   ${resp.content}
    Should Contain     ${response_body}    ${content}


