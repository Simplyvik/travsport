*** Settings ***
Documentation       Open a browser and search for some pattern before downloading the corresponding pdf

Library             RPA.Browser.Playwright
Library             RPA.HTTP


*** Variables ***
${page}             https://www.travsport.se    # page to open
${text_to_find}     Propositioner september 2023    # text to search for


*** Tasks ***
Open browser and page to find and download document
    New Browser    headless=${False}    # Open a browser
    New Context    acceptDownloads=${True}    # prepare for download
    New Page    ${page}    # open a new page
    Run Keyword And Ignore Error    Click    id=btn-cookie    # dismiss cockie
    Click    "Sport"    # click menu
    Click    "Propositionshäfte"    # click menu
    ${href}=    Find Text On Page    ${text_to_find}    # find text and return href to download
    Download pdf by href    ${href}    # Download href file to output dir
    [Teardown]    Close Browser


*** Keywords ***
Find text on page
    [Arguments]    ${text_to_find}
    TRY
        ${elem}=    Get Element    text=${text_to_find}    # find text and
        ${href}=    Get Property    ${elem}    href    # Get path for href
        RETURN    ${href}
    EXCEPT
        Log    Faild to find text
    END

Download pdf by href
    [Arguments]    ${href}
    TRY
        ${file_to_store}=    Catenate    SEPARATOR=    ${text_to_find}    .pdf
        RPA.http.Download    ${href}    target_file=${OUTPUT_DIR}${/}${file_to_store}    overwrite=True
    EXCEPT
        Log    Failed to download file
    END
