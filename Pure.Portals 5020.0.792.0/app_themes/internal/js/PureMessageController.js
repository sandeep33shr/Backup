var paramMessage, paramPureMode, paramPureRef, paramPureOrginatingSource, paramLandingPagePath;
var dialogClaimVersionConfirm = false;
var claimNumber = '';

function ReceiveMessageFromE5(message, pureMode, pureRef, pureOrginatingSource, landingPagePath) {   
    var queryString = "";
        var alertMessage = "User must finish original transaction before a new version is created";
        try {
            var messageId = message.MessageId;
            var originatingSource = message.OriginatingSource.toUpperCase();
            var operation = message.Operation.toUpperCase();
            var indexClaimCompletePage = window.location.pathname.toLowerCase().search("/claims/complete.aspx");

            if (typeof message.Data.Mode != "undefined") {
                if (typeof message.Data.Mode == "") {
                    return false;
                }                
                var mode = message.Data.Mode.toUpperCase();
                if (operation == "WORKITEMOPENED" || operation == "WORKITEMTASKPRESCRIBED") {
                    //debugger;
                    paramMessage = message;
                    paramPureMode = pureMode;
                    paramPureRef = pureRef;
                    paramPureOrginatingSource = pureOrginatingSource;
                    paramLandingPagePath = landingPagePath;                   

                    //Get E5 Opening mode from Mode Type
                    var openingModeE5 = "VIEW";
                    if (mode == "CLAIMMAINTAIN" || mode == "CLIENTEDIT" || mode == "QUOTEEDIT" || mode == "POLICYMTA" || mode == "POLICYCAN" || mode == "POLICYREINS" || mode == "POLICYREN" || mode == "POLICYLAPSE") {
                        openingModeE5 = "EDIT"
                    }
                    else if (mode == "CLAIMPAYMENT") {
                        openingModeE5 = "PAY"
                    }
                    else if (mode == "CLAIMVIEW" || mode == "POLICYVIEW") {
                        openingModeE5 = "VIEW"
                    }
                    else if (mode == "CLIENTNEW" || mode == "POLICYNEW" || mode == "CLAIMOPEN") {
                        openingModeE5 = "NEW"
                    }

                    if (pureOrginatingSource == "CLAIM" && pureRef != '-1' && typeof message.Data.ClaimNumber != "undefined") {
                        claimNumber = message.Data.ClaimNumber;
                        if (pureRef == claimNumber) {
                            if (pureMode == "VIEW" && openingModeE5 == "VIEW")
                                return false;
                            else
                                alertMessage = 'Original transaction incomplete. User must finish original transaction before a new version is created for claim number ' + pureRef + '.Do you wish to Continue Transaction or Start New Transaction?'
                        }
                        else
                            alertMessage = 'User must finish the current Pure transaction for claim ' + pureRef + ' before different claim can be accessed';

                    }

                    //To handle different opening mode in E5 and Pure.
                    if (pureMode == "VIEW") {
                        if (openingModeE5 == "VIEW" || openingModeE5 == "EDIT" || openingModeE5 == "PAY" || openingModeE5 == "NEW") {
                            // Open E5 task or create new version                   
                        }
                    }
                    else if (pureMode == "EDIT" && indexClaimCompletePage == "-1") {
                        if (openingModeE5 == "VIEW") {
                            return false; // Not create new version from E5 when pure in Edit Mode
                        }
                        if ( openingModeE5 == "EDIT" || openingModeE5 == "NEW" || openingModeE5 == "PAY") {
                            // Show confirm dialog box on same claim editng
                            if (pureRef == claimNumber) {
                                if (!dialogClaimVersionConfirm) {
                                    if (!ClaimVersionConfirmation(alertMessage))
                                        dialogClaimVersionConfirm = true;
                                    return false;
                                }
                                else {
                                    dialogClaimVersionConfirm = false;
                                }
                            }
                            else {
                                alert(alertMessage); // Show error message
                                return false; // stay in existing edit mode
                            }
                        }
                    }
                    else if (pureMode == "PAY" && indexClaimCompletePage == "-1") {
                        if (openingModeE5 == "VIEW" || openingModeE5 == "NEW") {
                            // Show confirm dialog box on same claim editng
                            return false; // Not create new version from E5 when pure in Pay Mode
                        }
                        else if (openingModeE5 == "EDIT") {
                            // Show confirm dialog box on same claim editng
                            if (pureRef == claimNumber) {
                                if (!dialogClaimVersionConfirm) {
                                    if (!ClaimVersionConfirmation(alertMessage))
                                        dialogClaimVersionConfirm = true;
                                    return false;
                                }
                                else {
                                    dialogClaimVersionConfirm = false;
                                }
                            }
                            else {
                                alert(alertMessage); // Show error message
                                return false; // No new version
                            }
                        }
                        else if (openingModeE5 == "PAY") {
                            // Show confirm dialog box on same claim editng
                            if (pureRef == claimNumber) {
                                if (!dialogClaimVersionConfirm) {
                                    if (!ClaimVersionConfirmation(alertMessage))
                                        dialogClaimVersionConfirm = true;
                                    return false;
                                }
                                else {
                                    dialogClaimVersionConfirm = false;
                                }
                            }
                            else {
                                alert(alertMessage); // Show error message
                                return false; // No new version
                            }
                        }
                    }

                    // Build querstring from E5 data Mode                                
                    queryString = 'messageId=' + messageId + '&originatingSource=' + originatingSource + '&operation=' + operation + '&mode=' + mode;

                    if (mode == "CLAIMOPEN") {
                        var claimDate = message.Message.Data.ClaimDate;
                        var policyNumber = message.Data.PolicyNumber;
                        queryString = queryString + '&policyNumber=' + policyNumber + '&claimDate=' + claimDate;
                    }
                    else if (mode == "CLAIMMAINTAIN" || mode == "CLAIMVIEW" || mode == "CLAIMPAYMENT") {
                        claimNumber = message.Data.ClaimNumber;
                        queryString = queryString + '&claimNumber=' + claimNumber;
                    }
                    else if (mode == "QUOTEEDIT") {
                        var clientCode = message.Data.ClientCode;
                        var policyNumber = message.Data.PolicyNumber;
                        queryString = queryString + '&policyNumber=' + policyNumber + '&clientCode=' + clientCode;
                    }
                    else if (mode == "POLICYNEW") {
                        var clientCode = message.Data.ClientCode;
                        queryString = queryString + '&clientCode=' + clientCode;
                    }
                    else if (mode == "POLICYMTA" || mode == "POLICYCAN" || mode == "POLICYREINS" || mode == "POLICYLAPSE" || mode == "POLICYREN") {
                        var policyNumber = message.Data.PolicyNumber;
                        queryString = queryString + '&policyNumber=' + policyNumber + '&clientCode=' + clientCode;
                    }

                    else if (mode == "CLIENTNEW") {
                        var partyType = message.Data.PartyType;
                        queryString = queryString + '&partyType=' + partyType;
                    }
                    else if (mode == "CLIENTEDIT") {
                        var clientCode = message.Data.ClientCode;
                        queryString = queryString + '&clientCode=' + clientCode;
                    }
                    else {
                        queryString = "";
                    }

                }
            }
        }
        catch (err) {
            alert("POST_DATA_ERROR");
        }
    return queryString;
}

function ClaimVersionConfirmation(dialogText) {
    if (!dialogClaimVersionConfirm) {
        $('body').append("<div id='e5dialog-confirm' title='Confirm'><p style='text-align:justify;'>" + dialogText + "</p></div>");
        $('#e5dialog-confirm').dialog
                ({
                    modal: true,
                    resizable: false,
                    closeOnEscape: false,
                    width: '350px',
                    minHeight: 120,
                    maxHeight: 200,
                    draggable: true,
                    close: function (event, ui) { $('body').find('#e5dialog-confirm').remove(); dialogClaimVersionConfirm = false; },
                    buttons:
                    {
                        'Continue Transaction': function () {
                            $(this).dialog('close');
                            dialogClaimVersionConfirm = false;

                        },
                        'Start New Transaction': function () {
                            $(this).dialog('close');
                            dialogClaimVersionConfirm = true;
                            var querystring = ReceiveMessageFromE5(paramMessage, paramPureMode, paramPureRef, paramPureOrginatingSource, paramLandingPagePath);
                            if (querystring.length > 0) {
                                window.location = paramLandingPagePath + querystring;
                                return true;
                            }
                        }
                    }
                });

    }
    
     return dialogClaimVersionConfirm;
 }
 
function createMessageData(orignatingSource, pureKey, mode) {
    if (orignatingSource == "PARTY") {
        return {
            PartyNumber: pureKey         
        };

    }
    else if (orignatingSource == "POLICY") {
        return {
            PolicyNumber: pureKey           
        };
    }
    else if (orignatingSource == "CLAIM") {
        return {
            ClaimNumber: pureKey           
        };
    }
    else {
        return "POST_DATA_ERROR";
    }
}

function postDataract(postData) {
    //  debugger;
    $.pm({
        target: window.parent,
        type: "dataract-message", // Do Not Change Message Type; It Must Be "dataract-message"
        data: postData,
        url: document.referrer,
        success: function(returnedData) {

        },
        error: function(response) {
            alert("Error Message: " + response.errormessage + " Error Code: " + response.errorCode);
        }
    });
};