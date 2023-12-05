<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="AAR_Section_C_Business_Interruption.aspx.vb" Inherits="Nexus.PB2_AAR_Section_C_Business_Interruption" %>

<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/BOCoverDates.ascx" TagName="CoverDate" TagPrefix="uc2" %>
<%@ Register Src="~/Controls/SubAgents.ascx" TagName="SubAgents" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/Contacts.ascx" TagName="Contact" TagPrefix="uc5" %>
<%@ Register Src="~/controls/AddressCntrl.ascx" TagName="AddressCntrl" TagPrefix="uc6" %>
<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register Src="~/Controls/StandardWordings.ascx" TagName="SW" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/FindParty.ascx" TagName="FindParty" TagPrefix="NexusControl" %>
<%@ Register Src="~/Controls/VehicleLookup.ascx" TagName="VehicleLookup" TagPrefix="uc8" %> 
<%@ Register Src="~/Controls/Geocoding.ascx" TagName="Geocoding" TagPrefix="uc9" %> 

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
<div class="itl">
    <asp:ScriptManager ID="ScriptManagerMainDetails" runat="server" />
	<script type="text/javascript">
		window['XMLDataSet'] = '<asp:Literal ID="XMLDataSet" runat="server"></asp:Literal>';
		window['TransactionType'] = '<%=GetTransactionType()%>';
		window['PolicyNumber'] = '<%=CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).InsuranceFileRef %>';
		window['CurrencyCode'] = '<%=CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).CurrencyCode %>';
		window['PolicyCurrencyCode'] = '<%=CType(Session.Item(Nexus.Constants.Session.CNParty), NexusProvider.BaseParty).Currency %>';
		window['NoCurrencySymbols'] = true;
		window['ThisOI'] = '<asp:Literal ID="ThisOI" runat="server"></asp:Literal>';
		<% If CType(Session.Item(Nexus.Constants.CNMode), Nexus.Constants.Mode) = Nexus.Constants.Mode.View Or CType(Session.Item(Nexus.Constants.CNMode), Nexus.Constants.Mode) = Nexus.Constants.Mode.Review Then %>
		window["rulesDisabled"] = true;
		<% End If %>
	</script>
	
	<!-- ITL Externals -->
	<script src="<%=ResolveUrl("~/App_Themes/Standard/js/es5-shim.min.js")%>" type="text/javascript"></script>
	<script src="<%=ResolveUrl("~/App_Themes/Standard/js/es6-shim.min.js")%>" type="text/javascript"></script>
    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/closure-v1.5.1.js")%>" type="text/javascript"></script>
    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/buildComponents-v1.5.1.js")%>" type="text/javascript"></script>
    <link href="<%=ResolveUrl("~/App_Themes/Standard/css/closure-v1.5.1.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/App_Themes/Standard/internal-differences.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/App_Themes/Standard/internal-differences-addon-3-to-3.1.css")%>" rel="stylesheet" type="text/css" />
	<!-- /ITL Externals -->
	
	<script type="text/javascript">
		perseus.identifiers.loginName = '<%= Session(Nexus.Constants.CNLoginName).ToString()%>';

		/**
		 * Enables or disables the next button on the current tab.
		 * @param {boolean} value Disable or enable next
		 */
		var enableNext = function(value){
			var btnNext = document.getElementById('ctl00_cntMainBody_btnNext');
			var btnNextTop = document.getElementById('ctl00_cntMainBody_btnNextTop');
			if (value){
				if (btnNext) btnNext.removeAttribute("disabled");
				if (btnNextTop) btnNextTop.removeAttribute("disabled");
			} else {
				if (btnNext) btnNext.setAttribute("disabled", "disabled");
				if (btnNextTop) btnNextTop.setAttribute("disabled", "disabled");
			}
		}
	</script>

	<script type="text/javascript">
		var scrollPositionHandler = {};
		(function(){
		
			var cookies = new goog.net.Cookies(document);
		
			/**
			 * Gets the current page filename.
			 * @return {string}
			 * @private
			 */
			this.getFileName = function(){
				var url = window.location.href;
				return url.slice(url.lastIndexOf("/") + 1);
			};
			
			/**
			 * Get the query data
			 * @return {goog.net.QueryData}
			 * @private
			 */
			this.getQueryData = function(){
				// Check it's retrieving scroll positions for the same policy
				if (cookies.get("lastPolicyNumber") != '<%=CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).InsuranceFileRef %>'){
					cookies.remove("scrollPosTracker");
					cookies.remove("lastPolicyNumber");
					return new goog.Uri.QueryData();
				}
				return this.queryData_ || new goog.Uri.QueryData(cookies.get("scrollPosTracker"));
			};
			
			/**
			 * Update the scroll position cookie record for the current page 
			 * @public
			 */
			this.updateCookieScrollPos = function(){
				var url = this.getFileName();
				var queryData = this.getQueryData();
				var intY = document.getElementById("divMain").scrollTop;
				queryData.set(url, intY);
				cookies.set("scrollPosTracker", queryData.toString());
				cookies.set("lastPolicyNumber", '<%=CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).InsuranceFileRef %>');
			};
			
			/**
			 * Update the scroll position cookie record for the current page 
			 * @public
			 */
			this.clearCookieScrollPos = function(){
				var url = this.getFileName();
				var queryData = this.getQueryData();
				var intY = 0;
				queryData.set(url, intY);
				cookies.set("scrollPosTracker", queryData.toString());
				cookies.set("lastPolicyNumber", '<%=CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).InsuranceFileRef %>');
			};
			
			/**
			 * Set the page scroll position based on data in the cookie.
			 * @public
			 */
			 this.setPageScrollPosition = function(){
				var url = this.getFileName();
				var queryData = this.getQueryData();
				var intY = queryData.get(url);
				if(intY != null)
					document.getElementById("divMain").scrollTop = intY;
			 };
		}).call(scrollPositionHandler);
		
		
		function GetLastDivPosition() {
			scrollPositionHandler.setPageScrollPosition();
		};
		
		function SetDivPosition() {
			scrollPositionHandler.updateCookieScrollPos();
		};
		
		function clearCookieScrollPos() {
			scrollPositionHandler.clearCookieScrollPos();
		};
		
	</script>
	
	
	
    <script type="text/javascript">
        /**
         * @fileoverview
         * GeneralValidation.h
         */ 
        	var GeneralValidationHandler = {};
        
        	GeneralValidationHandler.isDate = function(value, sepVal, dayIdx, monthIdx, yearIdx) {
        		try {
        			//Change the below values to determine which format of date you wish to check. It is set to dd/mm/yyyy by default.
        			var DayIndex = dayIdx !== undefined ? dayIdx : 0; 
        			var MonthIndex = monthIdx !== undefined ? monthIdx : 1;
        			var YearIndex = yearIdx !== undefined ? yearIdx : 2;
        	 
        			value = value.replace(/-/g, "/").replace(/\./g, "/"); 
        			var SplitValue = value.split(sepVal || "/");
        			var OK = true;
        			if (!(SplitValue[DayIndex].length == 1 || SplitValue[DayIndex].length == 2)) {
        				OK = false;
        			}
        			if (OK && !(SplitValue[MonthIndex].length == 1 || SplitValue[MonthIndex].length == 2)) {
        				OK = false;
        			}
        			if (OK && SplitValue[YearIndex].length != 4) {
        				OK = false;
        			}
        			if (OK) {
        				var Day = parseInt(SplitValue[DayIndex], 10);
        				var Month = parseInt(SplitValue[MonthIndex], 10);
        				var Year = parseInt(SplitValue[YearIndex], 10);
        	 
        				if (OK = ((Year > 1900) && (Year < (100 + new Date().getFullYear())))) {
        					if (OK = (Month <= 12 && Month > 0)) {
        
        						var LeapYear = (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0));   
        						
        						if(OK = Day > 0)
        						{
        							if (Month == 2) {  
        								OK = LeapYear ? Day <= 29 : Day <= 28;
        							} 
        							else {
        								if ((Month == 4) || (Month == 6) || (Month == 9) || (Month == 11)) {
        									OK = Day <= 30;
        								}
        								else {
        									OK = Day <= 31;
        								}
        							}
        						}
        					}
        				}
        			}
        			return OK;
        		}
        		catch (e) {
        			return false;
        		}
        	} 
        	
        	GeneralValidationHandler.Validate = function(isOnLoad, args, obj, prop, type){
        		type = type.toLowerCase();
        		var node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "__" + prop);
        		if (node == null){
        			// Try slightly different format with only one underscore
        			node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "_" + prop);
        		}
        
        		if (isOnLoad) {
        			//
        			//	Add a blur event to call validation function
        			if (node != null) {
        				if (node.addEventListener) {
        					node.addEventListener('blur', function() { window['onValidate_' + obj + '__' + prop](null, null, this); } );
        				} else {
        					node.attachEvent('onblur', function() { window['onValidate_' + obj + '__' + prop](null, null, this); } );
        				}
        			}
        		} else {
        			// Ensure the field contents is the correct format on exit from the field
        			var field = Field.getInstance(obj, prop);
        			var errorMessage = null;
        			var isValid = true;
        			
        			if (type == "integer") {
        				var value = field.getValue();
        				
        				if (value != null && value != '') {
        					var regExp = /^-?[0-9]+$/;
        
        					if (regExp.test(value)){
        						if (value <= -1000000000 || value >= 1000000000){
        							errorMessage = "Is out of range";
        							isValid = false;
        						}
        					} else {
        						isValid = false;
        						errorMessage = "Must be numeric";
        					}
        				}
        			}
        
        			if (type == "date") {
        				var date = field.getValue();
        				//if ((date instanceof Date) && window.isNaN(date.getTime())) {
        				///if (date.length > 0 && !GeneralValidationHandler.isDate(date, "/", 0, 1, 2)) {
        				if (! date instanceof Date){
        					isValid = false;
        					errorMessage = "Must be a valid date";
        				}
        			}
        
        			if (type == "currency") {
        				var value = field.getValue();
        				if (value <= -1000000000000000 || value >= 1000000000000000){
        					errorMessage = "Is out of range";
        					isValid = false;
        				}
        			}
        
        			if (type == "percentage") {
        				var value = field.getValue();
        				if (value <= -1000 || value >= 1000){
        					errorMessage = "Is out of range";
        					isValid = false;
        				}
        			}
        			
        			if (type == "text") {
        				var value = field.getValue();
        				if (value.length > 255){
        					errorMessage = "Too many characters";
        					isValid = false;
        				}
        			
        			}
        			
        			if (!isValid) {
        				if (node != null){
        					var lbl = document.getElementById('ctl00_cntMainBody_lbl' + obj + '_' + prop);
        					if (lbl != null) {
        						node.errormessage = lbl.innerHTML + " -- " + errorMessage;
        						if (args && args.IsValid == true){
        							args.IsValid = false;
        						}
        					}
        				}
        			}
        		}
        	}
        /**
         * Set the control width
         */
        window.setControlWidth = function(field, width, obj, prop){
        	
        	// width sanitisation
        	if (typeof width == "string" 
        		&& ((width.slice(0,1) == "'" && width.slice(-1) == "'") || (width.slice(0,1) == "\"" || width.slice(-1) == "\""))){
        		
        		// As there is loads of rules in the spreadsheet in this format correcting this now will throw
        		// all the sizes of fields out of sync to what they were before. So to keep the same
        		// behaviour without erroring will exit out here instead.
        		return;
        		//width = width.slice(1, -1);
        	}
        	if (typeof width == "string"){
        		width = window.parseFloat(width);
        		if (width == NaN)
        			return; // Don't continue
        	}
        	
        	
        	// If the control supports setWidth, use that else fall back on other method
        	// for older controls
        	// TO keep resizing consistent we will hard code a standard width
        	var standardWidth = 165;
        	//if (field.setWidth && field.getWidth){
        	if (field.setWidth){
        		field.setWidth(standardWidth * width);
        	}
        	var sWidthClass ="";
        	var sWidthClass2 ="";
            sWidthClass = "w-25";
        	
        	// Fall back for older fields
            var ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop);
            if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
                ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop + '_' + 'txtPartyName');
            }
        	//var bounds = window.getBounds(ele);
        	var widthPx = Math.round(width * standardWidth);
        	if (width>=1)
        		sWidthClass2 = "col-md-8 col-sm-9";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-7 col-sm-8";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-6 col-sm-7";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-5 col-sm-6";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-4 col-sm-5";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-3 col-sm-4";
        	
        	if (width>=0.2 && width <0.3 )
        		sWidthClass2 ="col-md-2 col-sm-3";
        	if (width=0.1 && width <0.2 )
        		sWidthClass2 ="col-md-1 col-sm-2";
        	
        	
        	if (ele != null)
        	{
        		//ele.style.width = ((widthPx > 790) ? 790 : widthPx) + "px !important";
        		var parentClassName = ele.parentElement.className;
        		//if (parentClassName !="col-md-8 col-sm-9")
        		//{
        			//ele.parentElement.parentElement.className = ele.parentElement.parentElement.className + " " + sWidthClass ;
        		//}
        		//else
        			//ele.parentElement.className = ele.parentElement.className + " " + sWidthClass ;
        		
        		var sblEle = ele.parentElement.parentElement.previousElementSibling;
        		if (parentClassName !="col-md-8 col-sm-9")
        		{
        			ele.parentElement.parentElement.className = sWidthClass2;			
        			if (sblEle != undefined)
        			{				
        				if(sblEle.nodeName == "LABEL")
        			      sblEle.className = sWidthClass2 + " " + "control-label";
        			}
        		}
        		else
        		{
        			ele.parentElement.className = sWidthClass2;
        			if (sblEle != undefined)
        			{				
        				if(sblEle.nodeName == "LABEL")
        			      sblEle.className = sWidthClass2 + " " + "control-label";
        			}
        		}
        		
        		
        		
        		
        	}
        		
        	// Check for text area also
        	var textarea = document.getElementById('ctl00_cntMainBody_' + obj + '_' + prop + '_textarea');
        	//if (textarea != null){
        		//bounds = window.getBounds(textarea);
        	//	textarea.style.width = ((widthPx > 790) ? 790 : widthPx) + "px !important";
        	//}
        	if (textarea != null)
        	{
        		if (parentClassName !="col-md-8 col-sm-9")
        		{
        			textarea.parentElement.className = sWidthClass2 ;
        		}
        		else
        			textarea.parentElement.className = sWidthClass2;
        	}
        	
        };
        
        
        String.prototype.killWhiteSpace = function() {
            return this.replace(/\s/g, '');
        };
        
        String.prototype.reduceWhiteSpace = function() {
            return this.replace(/\s+/g, ' ');
        };
        
        var SetControlProperties = function( field, setControl, strFeaturesOn, strFeaturesOff, paramValidationMessage ){
        
        	var strFeaturesToUse
        
        	if (setControl == true){
        		strFeaturesToUse = strFeaturesOn;
        		
        		// Don't do anything if no features are provided, i.e. empty parameter
        		if (strFeaturesOn == "")
        			return;
        	} else {               
        		strFeaturesToUse = strFeaturesOff;
        	}
        
        
        	// L = Leave the attributes only
        	if (strFeaturesToUse.toLowerCase().indexOf("l") == -1
        		&& strFeaturesToUse.toLowerCase().indexOf("n") == -1) {
        	
        		if (strFeaturesToUse.toLowerCase().indexOf("e") != -1){
        			field.setReadOnly(false);
        		} else {
        			field.setReadOnly(true);
        		};
        		   
        		if (strFeaturesToUse.toLowerCase().indexOf("v") != -1){
        			field.setVisible(true);
        		} else {
        			field.setVisible(false);
        		}   
        		   
        		if (strFeaturesToUse.toLowerCase().indexOf("m") != -1){
        			field.setMandatory(true, paramValidationMessage);
        			if (strFeaturesToUse.indexOf("m") != -1){
        				// If a lower case m, 0 is not valid
        				var exp = new Expression(field.getObjectName() + "." + field.getPropertyName() + " == 0")
        				
        				goog.events.listen(exp, "change", function(){
        					if (exp.getValue() == true){
        						field.setValid(false);
        					} else {
        						field.setValid(true);
        					}
        				}, false, this);
        			}
        		} else {
        			field.setMandatory(false);
        		}   
        		
        		if (strFeaturesToUse.toLowerCase().indexOf("r") != -1){
        			field.setHidden(true);
        		} else {
        			field.setHidden(false);
        		}   
        
        		if (strFeaturesToUse.toLowerCase().indexOf("h") != -1){
        			field.setMandatory(false);
        			field.setVisible(false);
        			field.setReadOnly(true);
        		} 
        
                
        
        
        	}
        };
        
        
        
        var NormaliseCurrencyString = function(theString) {
        	
        	// Force to string
        	theString = "" + theString;
        
            var strValidChars, strNormalised, i, strChar;
        
        	strValidChars  = "0123456789.";
        	strNormalised = "";
        
        	for (var i = 0; i < theString.length; i++){
        		strChar = theString.slice(i, 1);
        		if (strValidChars.indexOf(strChar) != -1){
        			strNormalised += strChar;
        		}
        	}
        
        	if (theString.length == 0)
                strNormalised = "0";
             
        
            return strNormalised; 
        };
        
        /**
         * Get the column total.
         * @param screenObjectStr The screen object name
         * @param strObject The object string of the column to total
         * @param strProperty The property string of the column to total
         */
        var getColumnTotal = function(screenObjectStr, strObject, strProperty, condition){
        
        	var root = new XMLDataSetReader(window.XMLDataSet);
        
        	var childScreenObject = root.getObjects(screenObjectStr)[0];
        	if (childScreenObject == null)
        		return 0;
        	var childObjects = childScreenObject.getObjects(strObject);
        	
        	var total = 0;
        	for (var i = 0; i < childObjects.length; i++){
        		if (condition != null){
        			var conditionExpression = new Expression(condition);
        		} else {
        			total += window.parseFloat(childObjects[i].getPropertyValue(strProperty)) || 0;
        		}
        	};
        	return total;
        };
        /**
         * @fileoverview
         * Set property
         */
        window.setProperty = function(field, value, condition, elseValue, validationMessage){
        		
        		
        	var paramValue = value,
        		paramCondition = condition,
        		paramElseValue = elseValue,
        		paramValidationMessage = validationMessage;
        		
        	paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
        	
        	
        	
        	if (paramValue != ""){
        		var paramValueExpression = new Expression(paramValue);
        	}
        	if (Expression.isValidParameter(paramCondition)){
        		// Check for condition
        		
        		var condition = new Expression(paramCondition);
        		var update = function(){
        			paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
        			var value = condition.getValue();
        			if (value == true){
        				SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
        			} else if (Expression.isValidParameter(paramElseValue)){
        				if (paramElseValue != "U") {
        					SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
        				}
        			} else {
        				// No else value provided
        				// Set field to not visible/ non editable/ non mandatory
        				field.setVisible(false);
        				field.setMandatory(false);
        				field.setReadOnly(true);
        			}
        		};
        		events.listen(condition, "change", update);
        		update();
        	} else {
        		// Set to the value
        		paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
        		SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
        	}
        };
function onValidate_SECTIONC__ATTACHMENTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "ATTACHMENTDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONC", "ATTACHMENTDATE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONC_ATTACHMENTDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONC__ATTACHMENTDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONC__ATTACHMENTDATE_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("SECTIONC.ATTACHMENTDATE");
        			window.setControlWidth(field, "0.7", "SECTIONC", "ATTACHMENTDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONC__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONC", "EFFECTIVEDATE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONC_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONC__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONC__EFFECTIVEDATE_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("SECTIONC.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.7", "SECTIONC", "EFFECTIVEDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONC__INDEM_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "INDEM_PER", "List");
        })();
}
function onValidate_SECTIONC__IS_GP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_GP", "Checkbox");
        })();
}
function onValidate_SECTIONC__GP_COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GP_COVER", "List");
        })();
}
function onValidate_SECTIONC__GP_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GP_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__GP_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GP_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__GP_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GP_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC__IS_GRENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_GRENT", "Checkbox");
        })();
}
function onValidate_SECTIONC__GRENT_COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GRENT_COVER", "List");
        })();
}
function onValidate_SECTIONC__GRENT_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GRENT_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__GRENT_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GRENT_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__GRENT_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GRENT_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC__IS_GREV(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_GREV", "Checkbox");
        })();
}
function onValidate_SECTIONC__GREV_COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GREV_COVER", "List");
        })();
}
function onValidate_SECTIONC__GREV_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GREV_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__GREV_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GREV_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__GREV_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "GREV_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC__IS_SC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_SC", "Checkbox");
        })();
}
function onValidate_SECTIONC__SC_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "SC_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__SC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "SC_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__SC_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "SC_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC__IS_ICOW(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_ICOW", "Checkbox");
        })();
}
function onValidate_SECTIONC__IS_PD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_PD", "Checkbox");
        })();
}
function onValidate_SECTIONC__PD_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "PD_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__PD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "PD_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__PD_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "PD_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC__IS_ENG(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "IS_ENG", "Checkbox");
        })();
}
function onValidate_SECTIONC__ENG_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "ENG_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONC__ENG_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "ENG_RATE", "Percentage");
        })();
}
function onValidate_SECTIONC__ENG_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "ENG_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_AICOW(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_AICOW", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__AICOW_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "AICOW_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_ICOW(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_ICOW", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__ICOW_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "ICOW_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_AR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_AR", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__AR_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "AR_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_RRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_RRE", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__RRE_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "RRE_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_FAP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__FAP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "FAP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_STS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_STS", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__STS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "STS_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_CCS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_CCS", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__CCS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "CCS_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DCSP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DCSP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__DCSP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "DCSP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DCUN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DCUN", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__DCUN_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "DCUN_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DSP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DSP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__SP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "SP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DUN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DUN", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__UN_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "UN_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_POA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_POA", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__POA_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "POA_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_RBTD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_RBTD", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__RBTD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "RBTD_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_AIRP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_AIRP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__AIRP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "AIRP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DPW(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DPW", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__DPW_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "DPW_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_CAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_CAP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__CAP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "CAP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_CF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_CF", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__CF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "CF_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_SILO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_SILO", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__SILO_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "SILO_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_PU(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_PU", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__PU_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "PU_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_MDC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_MDC", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__MDC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "MDC_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_AAC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_AAC", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__AAC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "AAC_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_FEL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_FEL", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__FEL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "FEL_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DVS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DVS", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__DVS_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "DVS_LOI", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_HIP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_HIP", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__HIP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "HIP_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_PRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_PRE", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__PRE_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "PRE_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_TA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_TA", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__TA_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "TA_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_ROY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_ROY", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__ROY_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "ROY_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_TPITS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_TPITS", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__TPITS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "TPITS_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__IS_DUS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "IS_DUS", "Checkbox");
        })();
}
function onValidate_SECTIONC_EXT__DUS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "DUS_LOL", "Currency");
        })();
}
function onValidate_SECTIONC_EXT__OTHERBIEXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "OTHERBIEXT", "ChildScreen");
        })();
}
function onValidate_SECTIONC_EXT__OTHERBIEXT_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "OTHERBIEXT_CNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC_EXT", "OTHERBIEXT_CNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC_EXT The Parent (Root) object name.
          * @param OTH_BI_EXT.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC_EXT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_BI_EXT.DESCRIP";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC_EXT", "OTHERBIEXT_CNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC_EXT", "OTHERBIEXT_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC_EXT__EXTSPDC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "EXTSPDC", "ChildScreen");
        })();
}
function onValidate_SECTIONC_EXT__EXTSPDC_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "EXTSPDC_CNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC_EXT", "EXTSPDC_CNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC_EXT The Parent (Root) object name.
          * @param SPEC_CUST.NAME The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC_EXT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SPEC_CUST.NAME";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC_EXT", "EXTSPDC_CNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC_EXT", "EXTSPDC_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC_EXT__EXTSPDS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "EXTSPDS", "ChildScreen");
        })();
}
function onValidate_SECTIONC_EXT__EXTSPDS_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_EXT", "EXTSPDS_CNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC_EXT", "EXTSPDS_CNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC_EXT The Parent (Root) object name.
          * @param SPEC_SUPP.NAME The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC_EXT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SPEC_SUPP.NAME";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC_EXT", "EXTSPDS_CNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC_EXT", "EXTSPDS_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC_DED__IS_FAPCWPD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_FAPCWPD", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__FAPCWPD_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "FAPCWPD_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__FAPCWPD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "FAPCWPD_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__FAPCWPD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "FAPCWPD_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CSPEC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CSPEC", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CSPECD_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECD_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CSPECD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECD_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CSPECD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECD_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CUSPD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CUSPD", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CUSPD_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUSPD_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CUSPD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUSPD_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CUSPD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUSPD_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CSPECDD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CSPECDD", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CSPECDD_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECDD_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CSPECDD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECDD_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CSPECDD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CSPECDD_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CUNSPECDD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CUNSPECDD", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CUNSPECDD_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUNSPECDD_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CUNSPECDD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUNSPECDD_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CUNSPECDD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CUNSPECDD_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CPOACC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CPOACC", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CPOACC_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPOACC_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CPOACC_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPOACC_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CPOACC_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPOACC_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CAO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CAO", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CAO_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CAO_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CAO_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CAO_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CAO_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CAO_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__IS_CPUT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "IS_CPUT", "Checkbox");
        })();
}
function onValidate_SECTIONC_DED__CPUT_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPUT_PERC", "Percentage");
        })();
}
function onValidate_SECTIONC_DED__CPUT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPUT_MIN", "Currency");
        })();
}
function onValidate_SECTIONC_DED__CPUT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "CPUT_MAX", "Currency");
        })();
}
function onValidate_SECTIONC_DED__OTHBIDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "OTHBIDED", "ChildScreen");
        })();
}
function onValidate_SECTIONC_DED__OTHBIDED_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC_DED", "OTHBIDED_CNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC_DED", "OTHBIDED_CNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC_DED The Parent (Root) object name.
          * @param OTH_BI_DED.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC_DED".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_BI_DED.DESCRIP";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC_DED", "OTHBIDED_CNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC_DED", "OTHBIDED_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC__SECTIONC_COUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "SECTIONC_COUNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC", "SECTIONC_COUNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC The Parent (Root) object name.
          * @param SECTIONC_CLAUSEPREM.COUNTER_ID The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONC_CLAUSEPREM.COUNTER_ID";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC", "SECTIONC_COUNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC", "SECTIONC_COUNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC__ENDORSE_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "ENDORSE_PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("SECTIONC", "ENDORSE_PREMIUM");
        		}
        		//window.setProperty(field, "V", "{1}", "{2}", "{3}");
        
            var paramValue = "V",
            paramCondition = "{1}",
            paramElseValue = "{2}",
            paramValidationMessage = "{3}";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
              events.listen(condition, "change", update);
              update();
            } else {
              // Set to the value
              paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
              SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
            }
        
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.3");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONC_ENDORSE_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONC__ENDORSE_PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONC__ENDORSE_PREMIUM_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("SECTIONC.ENDORSE_PREMIUM");
        			window.setControlWidth(field, "1", "SECTIONC", "ENDORSE_PREMIUM");
        		})();
        	}
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC The Parent (Root) object name.
          * @param SECTIONC_CLAUSEPREM.PREMIUM The object.property to sum the totals of.
          * @param TOTAL The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONC_CLAUSEPREM.PREMIUM";
        		//count, average, total, min, max
        		var type = "TOTAL".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC", "ENDORSE_PREMIUM");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("TOTAL".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC", "ENDORSE_PREMIUM");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONC__BIENDP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "BIENDP", "ChildScreen");
        })();
}
function onValidate_SECTIONC__BINOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "BINOTE", "ChildScreen");
        })();
        /**
         * @fileoverview Renames the matching links found within an element.
         * @param 0 {Expression} Optional when condition, hide is only applied when this is true. If omitted all links are hid.
         * @param 1 {Array} Optional array of captions that specify the same caption as the links to be hidden, this is not case sensitive.
         * HideTableLinks
         */
        (function(){
        	//
        	if (isOnLoad) {	
        		
        		var whenCondition = Expression.isValidParameter("GENERAL.TRANSACTION_TYPE =='NB' ||GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC' || GENERAL.TRANSACTION_TYPE =='REN'") ? (new Expression("GENERAL.TRANSACTION_TYPE =='NB' ||GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC' || GENERAL.TRANSACTION_TYPE =='REN'")) : null;
        		var oldLinkCaption = "Edit".toLowerCase();
        		var newLinkCaption = "View";
        		var field = Field.getInstance("SECTIONC", "BINOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONC__BINOTE table td a");
        				
        			} else {
        				links = goog.dom.query("a", field.getElement());
        			}
        		
        			var renameWhen = (whenCondition == null) ? true : whenCondition.valueOf();
        			
        			
        			goog.array.forEach(links, function(link){
        				
        				if (!renameWhen) return;
        				
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				// Trim
        				linkCaption = linkCaption.replace(/^\s+|\s+$/g, '');
        				
        				if (linkCaption.toLowerCase() == oldLinkCaption) {
        					$(link).text(newLinkCaption);
        				}
        			});
        		};
        		update();
        		if (whenCondition) goog.events.listen(whenCondition, "change", update);
        		goog.events.listen(field, "change", update);
        	}
        })();
        /**
         * @fileoverview Hides all the links found within an element.
         * @param 0 {Expression} Optional when condition, hide is only applied when this is true. If omitted all links are hid.
         * @param 1 {Array} Optional array of captions that specify the same caption as the links to be hidden, this is not case sensitive.
         * HideTableLinks
         */
        (function(){
        	//
        	if (isOnLoad) {	
        		
        		var whenCondition = Expression.isValidParameter("GENERAL.TRANSACTION_TYPE =='NB' ||GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC' || GENERAL.TRANSACTION_TYPE =='REN'") ? (new Expression("GENERAL.TRANSACTION_TYPE =='NB' ||GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC' || GENERAL.TRANSACTION_TYPE =='REN'")) : null;
        		var validLinkCaptions = "Delete";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("SECTIONC", "BINOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'SECTIONC' and property 'BINOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONC__BINOTE table td a");
        				
        			} else {
        				links = goog.dom.query("a", field.getElement());
        			}
        		
        			var hideWhen = (whenCondition == null) ? true : whenCondition.valueOf();
        			
        			
        			goog.array.forEach(links, function(link){
        			
        				// Show all links
        				link.style.display = "inline";
        				
        				if (!hideWhen) return;
        				
        				if (validLinkCaptions == null){
        					link.style.display = "none";
        					return;
        				}
        				
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				// Trim
        				linkCaption = linkCaption.replace(/^\s+|\s+$/g, '');
        				if (goog.array.some(validLinkCaptions, function(validLinkCaption){
        					return ((validLinkCaption + "").toLowerCase() == linkCaption.toLowerCase());
        				})){
        					link.style.display = "none";
        				}
        				
        			});
        		};
        		update();
        		if (whenCondition) goog.events.listen(whenCondition, "change", update);
        		goog.events.listen(field, "change", update);
        	}
        })();
}
function onValidate_SECTIONC__BISNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "BISNOTE", "ChildScreen");
        })();
}
function onValidate_SECTIONC__BISNOTE_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONC", "BISNOTE_CNT", "Integer");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("SECTIONC", "BISNOTE_CNT");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONC The Parent (Root) object name.
          * @param SECCS_DETAILS.DATE_CREATED The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONC".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECCS_DETAILS.DATE_CREATED";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("{3}")) ? ("{3}") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("SECTIONC", "BISNOTE_CNT");
        		try {
        
        			var getCurrentNode2 = function (xmldata, optParentObject) {
        				if (window["ThisOI"] == null) return null;
        				
        				var nodes = xmlData.selectNodes(".//*[@OI=\"" + window["ThisOI"] + "\"]"),
        				node = nodes[nodes.length - 1] || null;
        				
        				// Check that ThisOI matches the object we expect.  Parent screens can have multiple OIs.
        				if (optParentObject && node){
        					if (node.node.nodeName.toUpperCase() != optParentObject) {
        						nodes = xmlData.selectNodes("//" + optParentObject);
        						node = nodes[nodes.length - 1] || null;
        					}
        				}
        				
        				return node || xmlData;
        			};
        			
        			var xmlData = pb.xml.Document.loadXml(window.XMLDataSet);
        			var screenObjectNode = getCurrentNode2(xmlData, screenObjectStr);
        			/*var uc = xmlData.getCurrentNode();
        			if (uc == xmlData){
        				// We are at the top level as there is no UC node specified
        				// This means we should get the first element that matches the child screen
        				// object name. There should only be one.
        				var childScreenObjectsArray = xmlData.selectNodes("//" + screenObjectStr);
        				if (childScreenObjectsArray.length > 1){
        					if (console && console.warn){
        						//console.warn(); 
        						throw "Ambiguous xml data set while looking for " + screenObjectStr + ".";
        					}
        				}
        				screenObjectNode = childScreenObjectsArray[0];
        			} else if (uc != null && uc.node.nodeName.toUpperCase() == screenObjectStr){
        				screenObjectNode = uc;
        			}*/
        	
        			var total = 0, count = 0, min = null, max = null, average = null;
        			if (screenObjectNode){
        				
        				var objects = screenObjectNode.selectNodes(strObject);
        				goog.array.forEach(objects, function(obj){
        					//return obj.getAttribute(strProperty);
        					
        					// Check that condition is true, if it is not then do not include this obj.
        					// First override the parser so identifiers relate to this obj.
        					var evaluator = new perseus.Evaluator(condition, {
        						// Provide a context and override the getIdentifier method
        						getIdentifier: function(token){
        							var value = token.valueOf();
        							if (value.indexOf(".") != -1) {
        								var parts = value.split(".");
        								if (parts[0].toUpperCase() == strObject.toUpperCase())
        									return obj.getAttribute(parts[1].toUpperCase());
        							}
        							// Use the original get identifier function
        							return perseus.Evaluator.prototype.getIdentifier.call(this, token);
        						}
        					});
        					var result = evaluator.valueOf();
        					
        					if (! result) return;
        					
        					
        					var originalValue = obj.getAttribute(strProperty);
        					var value = window.parseFloat(originalValue);
        					
        					if (!window.isNaN(value)){
        						total += value;
        					} else {
        						value = originalValue;
        					}
        					count += 1;
        					if (min == null) min = value;
        					if (max == null) max = value;
        					if (value < min) min = value;
        					if (value > max) max = value;
        				});
        			} else {
        				if (console && console.warn){
        					console.warn("Possible incorrect child screen object name used in GetColumn rule.");
        				}
        			}
        			if (count != 0) {
        				average = total / count;
        			}
        			
        			var fieldValue;
        			switch ("COUNT".toUpperCase()){
        				case "COUNT": fieldValue = count; break;
        				case "AVERAGE": fieldValue = average; break;
        				case "MIN": fieldValue = min; break;
        				case "MAX": fieldValue = max; break;
        				case "TOTAL": 
        				default: fieldValue = total; break;
        			}
        			field.setValue(fieldValue);
        		} catch (e){
        			// Most likely we hit a parse error due to using an expression
        			// in an old format that's not supported by the latest parser.
        			// Therefore use the old method.
        			var exp;
        			if (type == "COUNT"){
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #TOTAL (" + condition + ") ? (1)");
        			} else {
        				exp = new Expression(screenObjectStr + "[" + strObject + "] #" + type + " (" + condition + ") ? (" + strObject + "." + strProperty + ")");
        			}
        			
        			var field = Field.getInstance("SECTIONC", "BISNOTE_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_SECTIONC__ATTACHMENTDATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__INDEM_PER(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_GP(null, null, null, isOnLoad);
    onValidate_SECTIONC__GP_COVER(null, null, null, isOnLoad);
    onValidate_SECTIONC__GP_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__GP_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__GP_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_GRENT(null, null, null, isOnLoad);
    onValidate_SECTIONC__GRENT_COVER(null, null, null, isOnLoad);
    onValidate_SECTIONC__GRENT_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__GRENT_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__GRENT_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_GREV(null, null, null, isOnLoad);
    onValidate_SECTIONC__GREV_COVER(null, null, null, isOnLoad);
    onValidate_SECTIONC__GREV_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__GREV_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__GREV_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_SC(null, null, null, isOnLoad);
    onValidate_SECTIONC__SC_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__SC_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__SC_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_ICOW(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_PD(null, null, null, isOnLoad);
    onValidate_SECTIONC__PD_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__PD_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__PD_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__IS_ENG(null, null, null, isOnLoad);
    onValidate_SECTIONC__ENG_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONC__ENG_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONC__ENG_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_AICOW(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__AICOW_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_ICOW(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__ICOW_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_AR(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__AR_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_RRE(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__RRE_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_FAP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__FAP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_STS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__STS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_CCS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__CCS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DCSP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__DCSP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DCUN(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__DCUN_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DSP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__SP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DUN(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__UN_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_POA(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__POA_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_RBTD(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__RBTD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_AIRP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__AIRP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DPW(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__DPW_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_CAP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__CAP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_CF(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__CF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_SILO(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__SILO_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_PU(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__PU_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_MDC(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__MDC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_AAC(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__AAC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_FEL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__FEL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DVS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__DVS_LOI(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_HIP(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__HIP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_PRE(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__PRE_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_TA(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__TA_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_ROY(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__ROY_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_TPITS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__TPITS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__IS_DUS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__DUS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__OTHERBIEXT(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__OTHERBIEXT_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__EXTSPDC(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__EXTSPDC_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__EXTSPDS(null, null, null, isOnLoad);
    onValidate_SECTIONC_EXT__EXTSPDS_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_FAPCWPD(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__FAPCWPD_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__FAPCWPD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__FAPCWPD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CSPEC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECD_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CUSPD(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUSPD_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUSPD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUSPD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CSPECDD(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECDD_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECDD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CSPECDD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CUNSPECDD(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUNSPECDD_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUNSPECDD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CUNSPECDD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CPOACC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPOACC_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPOACC_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPOACC_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CAO(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CAO_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CAO_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CAO_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__IS_CPUT(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPUT_PERC(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPUT_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__CPUT_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__OTHBIDED(null, null, null, isOnLoad);
    onValidate_SECTIONC_DED__OTHBIDED_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONC__SECTIONC_COUNT(null, null, null, isOnLoad);
    onValidate_SECTIONC__ENDORSE_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONC__BIENDP(null, null, null, isOnLoad);
    onValidate_SECTIONC__BINOTE(null, null, null, isOnLoad);
    onValidate_SECTIONC__BISNOTE(null, null, null, isOnLoad);
    onValidate_SECTIONC__BISNOTE_CNT(null, null, null, isOnLoad);
}
</script>


	
	

        <div id="divMain" onscroll="SetDivPosition()">
           <uc3:ProgressBar ID="ucProgressBar" runat="server" />
            <div class="card">
                <nexus:TabIndex ID="ctrlTabIndex" runat="server" CssClass="TabContainer" TabContainerClass="page-progress"
                    ActiveTabClass="ActiveTab" DisabledClass="DisabledTab" Scrollable="false" />
					<!-- Duplicate buttons -->
					<div class='card-footer clearfix'>
                        <asp:Button ID="refreshCVTop" runat="server" SkinID="buttonSecondary" Style="display: none" />
						<asp:Button ID="btnBackTop" runat="server" Text="Back" OnClick="BackButton" CausesValidation="false" OnClientClick="clearCookieScrollPos()"
                            SkinID="buttonSecondary" />
						<asp:Button ID="btnNextTop" runat="server" Text="Next" OnClick="NextButton" OnClientClick="clearCookieScrollPos()"
                            SkinID="buttonPrimary" disabled="disabled" />	
                        <asp:Button ID="btnFinishTop" runat="server" Text="Finish" OnClick="FinishButton" SkinID="buttonPrimary" OnClientClick="clearCookieScrollPos()"
                            OnPreRender="PreRenderFinish" />
						
					</div>
                    <div class="card-body clearfix">
                  			<div id="inner_content" class="">
								<!-- GeneralLayoutContainer -->
<div id="id1e2b094fb26041aeaad3aab20508521c" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id0c6ee155a06e4dc1b8be36479d4ebb89" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading86" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="SECTIONC" 
		data-property-name="ATTACHMENTDATE" 
		id="pb-container-datejquerycompatible-SECTIONC-ATTACHMENTDATE">
		<asp:Label ID="lblSECTIONC_ATTACHMENTDATE" runat="server" AssociatedControlID="SECTIONC__ATTACHMENTDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONC__ATTACHMENTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONC__ATTACHMENTDATE" runat="server" LinkedControl="SECTIONC__ATTACHMENTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONC_ATTACHMENTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_SECTIONC__ATTACHMENTDATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="SECTIONC" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-SECTIONC-EFFECTIVEDATE">
		<asp:Label ID="lblSECTIONC_EFFECTIVEDATE" runat="server" AssociatedControlID="SECTIONC__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONC__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONC__EFFECTIVEDATE" runat="server" LinkedControl="SECTIONC__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONC_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_SECTIONC__EFFECTIVEDATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id0c6ee155a06e4dc1b8be36479d4ebb89 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id0c6ee155a06e4dc1b8be36479d4ebb89 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id0c6ee155a06e4dc1b8be36479d4ebb89 div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id0c6ee155a06e4dc1b8be36479d4ebb89 div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0c6ee155a06e4dc1b8be36479d4ebb89 input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idcf91c8eec26a4d199590e23e6b7a428a" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading87" runat="server" Text="Risk Data " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="SECTIONC" 
		data-property-name="INDEM_PER" 
		id="pb-container-list-SECTIONC-INDEM_PER">
		<asp:Label ID="lblSECTIONC_INDEM_PER" runat="server" AssociatedControlID="SECTIONC__INDEM_PER" 
			Text="Indemnity Period" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="SECTIONC__INDEM_PER" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_AAR_IND" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_SECTIONC__INDEM_PER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valSECTIONC_INDEM_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Indemnity Period"
			ClientValidationFunction="onValidate_SECTIONC__INDEM_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONC" 
		data-property-name="INDEM_PERCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-SECTIONC-INDEM_PERCode">

		
		
			
		
				<asp:HiddenField ID="SECTIONC__INDEM_PERCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idcf91c8eec26a4d199590e23e6b7a428a div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idcf91c8eec26a4d199590e23e6b7a428a div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idcf91c8eec26a4d199590e23e6b7a428a div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idcf91c8eec26a4d199590e23e6b7a428a div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#idcf91c8eec26a4d199590e23e6b7a428a label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idcf91c8eec26a4d199590e23e6b7a428a label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idcf91c8eec26a4d199590e23e6b7a428a label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idcf91c8eec26a4d199590e23e6b7a428a label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idcf91c8eec26a4d199590e23e6b7a428a input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idcf91c8eec26a4d199590e23e6b7a428a input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idcf91c8eec26a4d199590e23e6b7a428a input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idacef6eb4f1744b0baf52861e8770daba" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading88" runat="server" Text="Basis Of Settlement " /></legend>
				
				
				<div data-column-count="6" data-column-ratio="5:15:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label338">
		<span class="label" id="label338"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label339">
		<span class="label" id="label339"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label340">
		<span class="label" id="label340">Type of Cover</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label341">
		<span class="label" id="label341">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label342">
		<span class="label" id="label342">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label343">
		<span class="label" id="label343">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_GP" for="ctl00_cntMainBody_SECTIONC__IS_GP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_GP" 
		id="pb-container-checkbox-SECTIONC-IS_GP">	
		
		<asp:TextBox ID="SECTIONC__IS_GP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_GP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_GP"
			ClientValidationFunction="onValidate_SECTIONC__IS_GP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label344">
		<span class="label" id="label344">Gross Profit  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="SECTIONC" 
		data-property-name="GP_COVER" 
		id="pb-container-list-SECTIONC-GP_COVER">
		<asp:Label ID="lblSECTIONC_GP_COVER" runat="server" AssociatedControlID="SECTIONC__GP_COVER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="SECTIONC__GP_COVER" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_AAR_COVER" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_SECTIONC__GP_COVER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valSECTIONC_GP_COVER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GP_COVER"
			ClientValidationFunction="onValidate_SECTIONC__GP_COVER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GP_SUMINSURED" 
		id="pb-container-currency-SECTIONC-GP_SUMINSURED">
		<asp:Label ID="lblSECTIONC_GP_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__GP_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GP_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GP_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GP_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__GP_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="GP_RATE" 
		id="pb-container-percentage-SECTIONC-GP_RATE">
		<asp:Label ID="lblSECTIONC_GP_RATE" runat="server" AssociatedControlID="SECTIONC__GP_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__GP_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_GP_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GP_RATE"
			ClientValidationFunction="onValidate_SECTIONC__GP_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GP_PREMIUM" 
		id="pb-container-currency-SECTIONC-GP_PREMIUM">
		<asp:Label ID="lblSECTIONC_GP_PREMIUM" runat="server" AssociatedControlID="SECTIONC__GP_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GP_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GP_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GP_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__GP_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_GRENT" for="ctl00_cntMainBody_SECTIONC__IS_GRENT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_GRENT" 
		id="pb-container-checkbox-SECTIONC-IS_GRENT">	
		
		<asp:TextBox ID="SECTIONC__IS_GRENT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_GRENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_GRENT"
			ClientValidationFunction="onValidate_SECTIONC__IS_GRENT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label345">
		<span class="label" id="label345">Gross Rentals  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="SECTIONC" 
		data-property-name="GRENT_COVER" 
		id="pb-container-list-SECTIONC-GRENT_COVER">
		<asp:Label ID="lblSECTIONC_GRENT_COVER" runat="server" AssociatedControlID="SECTIONC__GRENT_COVER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="SECTIONC__GRENT_COVER" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_AAR_COVER" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_SECTIONC__GRENT_COVER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valSECTIONC_GRENT_COVER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GRENT_COVER"
			ClientValidationFunction="onValidate_SECTIONC__GRENT_COVER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GRENT_SUMINSURED" 
		id="pb-container-currency-SECTIONC-GRENT_SUMINSURED">
		<asp:Label ID="lblSECTIONC_GRENT_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__GRENT_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GRENT_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GRENT_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GRENT_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__GRENT_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="GRENT_RATE" 
		id="pb-container-percentage-SECTIONC-GRENT_RATE">
		<asp:Label ID="lblSECTIONC_GRENT_RATE" runat="server" AssociatedControlID="SECTIONC__GRENT_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__GRENT_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_GRENT_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GRENT_RATE"
			ClientValidationFunction="onValidate_SECTIONC__GRENT_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GRENT_PREMIUM" 
		id="pb-container-currency-SECTIONC-GRENT_PREMIUM">
		<asp:Label ID="lblSECTIONC_GRENT_PREMIUM" runat="server" AssociatedControlID="SECTIONC__GRENT_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GRENT_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GRENT_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GRENT_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__GRENT_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_GREV" for="ctl00_cntMainBody_SECTIONC__IS_GREV" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_GREV" 
		id="pb-container-checkbox-SECTIONC-IS_GREV">	
		
		<asp:TextBox ID="SECTIONC__IS_GREV" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_GREV" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_GREV"
			ClientValidationFunction="onValidate_SECTIONC__IS_GREV" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label346">
		<span class="label" id="label346">Gross Revenue  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="SECTIONC" 
		data-property-name="GREV_COVER" 
		id="pb-container-list-SECTIONC-GREV_COVER">
		<asp:Label ID="lblSECTIONC_GREV_COVER" runat="server" AssociatedControlID="SECTIONC__GREV_COVER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="SECTIONC__GREV_COVER" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_AAR_COVER" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_SECTIONC__GREV_COVER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valSECTIONC_GREV_COVER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GREV_COVER"
			ClientValidationFunction="onValidate_SECTIONC__GREV_COVER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GREV_SUMINSURED" 
		id="pb-container-currency-SECTIONC-GREV_SUMINSURED">
		<asp:Label ID="lblSECTIONC_GREV_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__GREV_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GREV_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GREV_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GREV_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__GREV_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="GREV_RATE" 
		id="pb-container-percentage-SECTIONC-GREV_RATE">
		<asp:Label ID="lblSECTIONC_GREV_RATE" runat="server" AssociatedControlID="SECTIONC__GREV_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__GREV_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_GREV_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GREV_RATE"
			ClientValidationFunction="onValidate_SECTIONC__GREV_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="GREV_PREMIUM" 
		id="pb-container-currency-SECTIONC-GREV_PREMIUM">
		<asp:Label ID="lblSECTIONC_GREV_PREMIUM" runat="server" AssociatedControlID="SECTIONC__GREV_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__GREV_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_GREV_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.GREV_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__GREV_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_SC" for="ctl00_cntMainBody_SECTIONC__IS_SC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_SC" 
		id="pb-container-checkbox-SECTIONC-IS_SC">	
		
		<asp:TextBox ID="SECTIONC__IS_SC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_SC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_SC"
			ClientValidationFunction="onValidate_SECTIONC__IS_SC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label347">
		<span class="label" id="label347">Standing Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label348">
		<span class="label" id="label348"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="SC_SUMINSURED" 
		id="pb-container-currency-SECTIONC-SC_SUMINSURED">
		<asp:Label ID="lblSECTIONC_SC_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__SC_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__SC_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_SC_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.SC_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__SC_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="SC_RATE" 
		id="pb-container-percentage-SECTIONC-SC_RATE">
		<asp:Label ID="lblSECTIONC_SC_RATE" runat="server" AssociatedControlID="SECTIONC__SC_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__SC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_SC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.SC_RATE"
			ClientValidationFunction="onValidate_SECTIONC__SC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="SC_PREMIUM" 
		id="pb-container-currency-SECTIONC-SC_PREMIUM">
		<asp:Label ID="lblSECTIONC_SC_PREMIUM" runat="server" AssociatedControlID="SECTIONC__SC_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__SC_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_SC_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.SC_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__SC_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_ICOW" for="ctl00_cntMainBody_SECTIONC__IS_ICOW" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_ICOW" 
		id="pb-container-checkbox-SECTIONC-IS_ICOW">	
		
		<asp:TextBox ID="SECTIONC__IS_ICOW" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_ICOW" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_ICOW"
			ClientValidationFunction="onValidate_SECTIONC__IS_ICOW" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label349">
		<span class="label" id="label349">Increase Cost of Working</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label350">
		<span class="label" id="label350"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label351">
		<span class="label" id="label351"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label352">
		<span class="label" id="label352"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label353">
		<span class="label" id="label353"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_PD" for="ctl00_cntMainBody_SECTIONC__IS_PD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_PD" 
		id="pb-container-checkbox-SECTIONC-IS_PD">	
		
		<asp:TextBox ID="SECTIONC__IS_PD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_PD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_PD"
			ClientValidationFunction="onValidate_SECTIONC__IS_PD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label354">
		<span class="label" id="label354">Property Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label355">
		<span class="label" id="label355"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="PD_SUMINSURED" 
		id="pb-container-currency-SECTIONC-PD_SUMINSURED">
		<asp:Label ID="lblSECTIONC_PD_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__PD_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__PD_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_PD_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.PD_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__PD_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="PD_RATE" 
		id="pb-container-percentage-SECTIONC-PD_RATE">
		<asp:Label ID="lblSECTIONC_PD_RATE" runat="server" AssociatedControlID="SECTIONC__PD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__PD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_PD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.PD_RATE"
			ClientValidationFunction="onValidate_SECTIONC__PD_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="PD_PREMIUM" 
		id="pb-container-currency-SECTIONC-PD_PREMIUM">
		<asp:Label ID="lblSECTIONC_PD_PREMIUM" runat="server" AssociatedControlID="SECTIONC__PD_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__PD_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_PD_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.PD_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__PD_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_IS_ENG" for="ctl00_cntMainBody_SECTIONC__IS_ENG" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC" 
		data-property-name="IS_ENG" 
		id="pb-container-checkbox-SECTIONC-IS_ENG">	
		
		<asp:TextBox ID="SECTIONC__IS_ENG" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_IS_ENG" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.IS_ENG"
			ClientValidationFunction="onValidate_SECTIONC__IS_ENG" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label356">
		<span class="label" id="label356">Engineering</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label357">
		<span class="label" id="label357"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="ENG_SUMINSURED" 
		id="pb-container-currency-SECTIONC-ENG_SUMINSURED">
		<asp:Label ID="lblSECTIONC_ENG_SUMINSURED" runat="server" AssociatedControlID="SECTIONC__ENG_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__ENG_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_ENG_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.ENG_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONC__ENG_SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC" 
		data-property-name="ENG_RATE" 
		id="pb-container-percentage-SECTIONC-ENG_RATE">
		<asp:Label ID="lblSECTIONC_ENG_RATE" runat="server" AssociatedControlID="SECTIONC__ENG_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC__ENG_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_ENG_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.ENG_RATE"
			ClientValidationFunction="onValidate_SECTIONC__ENG_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="ENG_PREMIUM" 
		id="pb-container-currency-SECTIONC-ENG_PREMIUM">
		<asp:Label ID="lblSECTIONC_ENG_PREMIUM" runat="server" AssociatedControlID="SECTIONC__ENG_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__ENG_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_ENG_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.ENG_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONC__ENG_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONC" 
		data-property-name="GP_COVERCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-SECTIONC-GP_COVERCode">

		
		
			
		
				<asp:HiddenField ID="SECTIONC__GP_COVERCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONC" 
		data-property-name="GRENT_COVERCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-SECTIONC-GRENT_COVERCode">

		
		
			
		
				<asp:HiddenField ID="SECTIONC__GRENT_COVERCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONC" 
		data-property-name="GREV_COVERCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-SECTIONC-GREV_COVERCode">

		
		
			
		
				<asp:HiddenField ID="SECTIONC__GREV_COVERCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idacef6eb4f1744b0baf52861e8770daba div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idacef6eb4f1744b0baf52861e8770daba div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idacef6eb4f1744b0baf52861e8770daba div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idacef6eb4f1744b0baf52861e8770daba div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#idacef6eb4f1744b0baf52861e8770daba label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idacef6eb4f1744b0baf52861e8770daba label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idacef6eb4f1744b0baf52861e8770daba label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idacef6eb4f1744b0baf52861e8770daba label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idacef6eb4f1744b0baf52861e8770daba input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idacef6eb4f1744b0baf52861e8770daba input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idacef6eb4f1744b0baf52861e8770daba input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id95766dfc290840f7bb9e6a7aaafb01db" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading89" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="6" data-column-ratio="5:15:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label358">
		<span class="label" id="label358"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label359">
		<span class="label" id="label359"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label360">
		<span class="label" id="label360">Limit of Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label361">
		<span class="label" id="label361"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label362">
		<span class="label" id="label362"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label363">
		<span class="label" id="label363"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_AICOW" for="ctl00_cntMainBody_SECTIONC_EXT__IS_AICOW" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_AICOW" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_AICOW">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_AICOW" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_AICOW" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_AICOW"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_AICOW" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label364">
		<span class="label" id="label364">Additional Increase in Cost of Working</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="AICOW_LOL" 
		id="pb-container-currency-SECTIONC_EXT-AICOW_LOL">
		<asp:Label ID="lblSECTIONC_EXT_AICOW_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__AICOW_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__AICOW_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_AICOW_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.AICOW_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__AICOW_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label365">
		<span class="label" id="label365"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label366">
		<span class="label" id="label366"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label367">
		<span class="label" id="label367"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_ICOW" for="ctl00_cntMainBody_SECTIONC_EXT__IS_ICOW" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_ICOW" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_ICOW">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_ICOW" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_ICOW" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_ICOW"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_ICOW" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label368">
		<span class="label" id="label368">Increase Cost of Working (Non-Income Generating Locations) </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="ICOW_LOL" 
		id="pb-container-currency-SECTIONC_EXT-ICOW_LOL">
		<asp:Label ID="lblSECTIONC_EXT_ICOW_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__ICOW_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__ICOW_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_ICOW_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.ICOW_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__ICOW_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label369">
		<span class="label" id="label369"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label370">
		<span class="label" id="label370"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label371">
		<span class="label" id="label371"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_AR" for="ctl00_cntMainBody_SECTIONC_EXT__IS_AR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_AR" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_AR">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_AR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_AR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_AR"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_AR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label372">
		<span class="label" id="label372">Accounts Receivable</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="AR_LOL" 
		id="pb-container-currency-SECTIONC_EXT-AR_LOL">
		<asp:Label ID="lblSECTIONC_EXT_AR_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__AR_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__AR_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_AR_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.AR_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__AR_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label373">
		<span class="label" id="label373"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label374">
		<span class="label" id="label374"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label375">
		<span class="label" id="label375"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_RRE" for="ctl00_cntMainBody_SECTIONC_EXT__IS_RRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_RRE" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_RRE">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_RRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_RRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_RRE"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_RRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label376">
		<span class="label" id="label376">Research Re-Establishment Expenditure</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="RRE_LOL" 
		id="pb-container-currency-SECTIONC_EXT-RRE_LOL">
		<asp:Label ID="lblSECTIONC_EXT_RRE_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__RRE_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__RRE_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_RRE_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.RRE_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__RRE_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label377">
		<span class="label" id="label377"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label378">
		<span class="label" id="label378"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label379">
		<span class="label" id="label379"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_FAP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_FAP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_FAP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_FAP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_FAP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_FAP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label380">
		<span class="label" id="label380">Fines and Penalties</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="FAP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-FAP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_FAP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__FAP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__FAP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_FAP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.FAP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__FAP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label381">
		<span class="label" id="label381"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label382">
		<span class="label" id="label382"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label383">
		<span class="label" id="label383"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label384">
		<span class="label" id="label384"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label385">
		<span class="label" id="label385">Extended Premises as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label386">
		<span class="label" id="label386"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label387">
		<span class="label" id="label387"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label388">
		<span class="label" id="label388"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label389">
		<span class="label" id="label389"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_STS" for="ctl00_cntMainBody_SECTIONC_EXT__IS_STS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_STS" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_STS">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_STS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_STS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_STS"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_STS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label390">
		<span class="label" id="label390">Storage Sites</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="STS_LOL" 
		id="pb-container-currency-SECTIONC_EXT-STS_LOL">
		<asp:Label ID="lblSECTIONC_EXT_STS_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__STS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__STS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_STS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.STS_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__STS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label391">
		<span class="label" id="label391"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label392">
		<span class="label" id="label392"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label393">
		<span class="label" id="label393"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_CCS" for="ctl00_cntMainBody_SECTIONC_EXT__IS_CCS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_CCS" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_CCS">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_CCS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_CCS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_CCS"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_CCS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label394">
		<span class="label" id="label394">Contract Sites</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="CCS_LOL" 
		id="pb-container-currency-SECTIONC_EXT-CCS_LOL">
		<asp:Label ID="lblSECTIONC_EXT_CCS_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__CCS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__CCS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_CCS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.CCS_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__CCS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label395">
		<span class="label" id="label395"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label396">
		<span class="label" id="label396"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label397">
		<span class="label" id="label397"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label398">
		<span class="label" id="label398"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label399">
		<span class="label" id="label399">Direct Customers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label400">
		<span class="label" id="label400"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label401">
		<span class="label" id="label401"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label402">
		<span class="label" id="label402"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label403">
		<span class="label" id="label403"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DCSP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DCSP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DCSP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DCSP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DCSP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DCSP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DCSP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DCSP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label404">
		<span class="label" id="label404">Specified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="DCSP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-DCSP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_DCSP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__DCSP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__DCSP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_DCSP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.DCSP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__DCSP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label405">
		<span class="label" id="label405"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label406">
		<span class="label" id="label406"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label407">
		<span class="label" id="label407"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DCUN" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DCUN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DCUN" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DCUN">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DCUN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DCUN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DCUN"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DCUN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label408">
		<span class="label" id="label408">Unspecified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="DCUN_LOL" 
		id="pb-container-currency-SECTIONC_EXT-DCUN_LOL">
		<asp:Label ID="lblSECTIONC_EXT_DCUN_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__DCUN_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__DCUN_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_DCUN_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.DCUN_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__DCUN_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label409">
		<span class="label" id="label409"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label410">
		<span class="label" id="label410"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label411">
		<span class="label" id="label411"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label412">
		<span class="label" id="label412"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label413">
		<span class="label" id="label413">Direct Suppliers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label414">
		<span class="label" id="label414"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label415">
		<span class="label" id="label415"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label416">
		<span class="label" id="label416"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label417">
		<span class="label" id="label417"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DSP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DSP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DSP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DSP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DSP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DSP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DSP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DSP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label418">
		<span class="label" id="label418">Specified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="SP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-SP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_SP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__SP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__SP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_SP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.SP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__SP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label419">
		<span class="label" id="label419"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label420">
		<span class="label" id="label420"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label421">
		<span class="label" id="label421"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DUN" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DUN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DUN" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DUN">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DUN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DUN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DUN"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DUN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label422">
		<span class="label" id="label422">Unspecified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="UN_LOL" 
		id="pb-container-currency-SECTIONC_EXT-UN_LOL">
		<asp:Label ID="lblSECTIONC_EXT_UN_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__UN_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__UN_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_UN_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.UN_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__UN_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label423">
		<span class="label" id="label423"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label424">
		<span class="label" id="label424"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label425">
		<span class="label" id="label425"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_POA" for="ctl00_cntMainBody_SECTIONC_EXT__IS_POA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_POA" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_POA">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_POA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_POA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_POA"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_POA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label426">
		<span class="label" id="label426">Prevention of Access</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="POA_LOL" 
		id="pb-container-currency-SECTIONC_EXT-POA_LOL">
		<asp:Label ID="lblSECTIONC_EXT_POA_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__POA_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__POA_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_POA_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.POA_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__POA_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label427">
		<span class="label" id="label427"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label428">
		<span class="label" id="label428"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label429">
		<span class="label" id="label429"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label430">
		<span class="label" id="label430"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label431">
		<span class="label" id="label431">All Other</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label432">
		<span class="label" id="label432"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label433">
		<span class="label" id="label433"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label434">
		<span class="label" id="label434"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label435">
		<span class="label" id="label435"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_RBTD" for="ctl00_cntMainBody_SECTIONC_EXT__IS_RBTD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_RBTD" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_RBTD">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_RBTD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_RBTD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_RBTD"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_RBTD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label436">
		<span class="label" id="label436">roads, bridges, tunnels, dams</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="RBTD_LOL" 
		id="pb-container-currency-SECTIONC_EXT-RBTD_LOL">
		<asp:Label ID="lblSECTIONC_EXT_RBTD_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__RBTD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__RBTD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_RBTD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.RBTD_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__RBTD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label437">
		<span class="label" id="label437"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label438">
		<span class="label" id="label438"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label439">
		<span class="label" id="label439"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_AIRP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_AIRP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_AIRP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_AIRP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_AIRP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_AIRP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_AIRP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_AIRP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label440">
		<span class="label" id="label440">airports, runways or airport control towers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="AIRP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-AIRP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_AIRP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__AIRP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__AIRP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_AIRP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.AIRP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__AIRP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label441">
		<span class="label" id="label441"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label442">
		<span class="label" id="label442"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label443">
		<span class="label" id="label443"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DPW" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DPW" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DPW" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DPW">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DPW" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DPW" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DPW"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DPW" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label444">
		<span class="label" id="label444">docks, piers, wharves, harbours or dockyards (including equipment) </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="DPW_LOL" 
		id="pb-container-currency-SECTIONC_EXT-DPW_LOL">
		<asp:Label ID="lblSECTIONC_EXT_DPW_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__DPW_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__DPW_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_DPW_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.DPW_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__DPW_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label445">
		<span class="label" id="label445"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label446">
		<span class="label" id="label446"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label447">
		<span class="label" id="label447"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_CAP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_CAP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_CAP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_CAP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_CAP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_CAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_CAP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_CAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label448">
		<span class="label" id="label448">canals, aqueducts, pipelines</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="CAP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-CAP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_CAP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__CAP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__CAP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_CAP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.CAP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__CAP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label449">
		<span class="label" id="label449"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label450">
		<span class="label" id="label450"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label451">
		<span class="label" id="label451"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_CF" for="ctl00_cntMainBody_SECTIONC_EXT__IS_CF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_CF" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_CF">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_CF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_CF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_CF"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_CF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label452">
		<span class="label" id="label452">cargo or freight loading and unloading facilities</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="CF_LOL" 
		id="pb-container-currency-SECTIONC_EXT-CF_LOL">
		<asp:Label ID="lblSECTIONC_EXT_CF_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__CF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__CF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_CF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.CF_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__CF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label453">
		<span class="label" id="label453"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label454">
		<span class="label" id="label454"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label455">
		<span class="label" id="label455"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_SILO" for="ctl00_cntMainBody_SECTIONC_EXT__IS_SILO" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_SILO" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_SILO">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_SILO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_SILO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_SILO"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_SILO" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label456">
		<span class="label" id="label456">silos including equipment and conveyor belt lines for transporting raw materials on and off the premises over land</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="SILO_LOL" 
		id="pb-container-currency-SECTIONC_EXT-SILO_LOL">
		<asp:Label ID="lblSECTIONC_EXT_SILO_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__SILO_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__SILO_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_SILO_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.SILO_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__SILO_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label457">
		<span class="label" id="label457"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label458">
		<span class="label" id="label458"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label459">
		<span class="label" id="label459"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_PU" for="ctl00_cntMainBody_SECTIONC_EXT__IS_PU" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_PU" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_PU">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_PU" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_PU" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_PU"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_PU" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label460">
		<span class="label" id="label460">Public Utilities</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="PU_LOL" 
		id="pb-container-currency-SECTIONC_EXT-PU_LOL">
		<asp:Label ID="lblSECTIONC_EXT_PU_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__PU_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__PU_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_PU_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.PU_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__PU_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label461">
		<span class="label" id="label461"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label462">
		<span class="label" id="label462"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label463">
		<span class="label" id="label463"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_MDC" for="ctl00_cntMainBody_SECTIONC_EXT__IS_MDC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_MDC" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_MDC">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_MDC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_MDC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_MDC"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_MDC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label464">
		<span class="label" id="label464">Maximum Demand Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="MDC_LOL" 
		id="pb-container-currency-SECTIONC_EXT-MDC_LOL">
		<asp:Label ID="lblSECTIONC_EXT_MDC_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__MDC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__MDC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_MDC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.MDC_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__MDC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label465">
		<span class="label" id="label465"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label466">
		<span class="label" id="label466"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label467">
		<span class="label" id="label467"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_AAC" for="ctl00_cntMainBody_SECTIONC_EXT__IS_AAC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_AAC" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_AAC">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_AAC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_AAC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_AAC"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_AAC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label468">
		<span class="label" id="label468">Acts of Authorities Closure</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="AAC_LOL" 
		id="pb-container-currency-SECTIONC_EXT-AAC_LOL">
		<asp:Label ID="lblSECTIONC_EXT_AAC_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__AAC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__AAC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_AAC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.AAC_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__AAC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label469">
		<span class="label" id="label469"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label470">
		<span class="label" id="label470"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label471">
		<span class="label" id="label471"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_FEL" for="ctl00_cntMainBody_SECTIONC_EXT__IS_FEL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_FEL" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_FEL">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_FEL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_FEL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_FEL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_FEL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label472">
		<span class="label" id="label472">Forward Exchange Losses</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="FEL_LOL" 
		id="pb-container-currency-SECTIONC_EXT-FEL_LOL">
		<asp:Label ID="lblSECTIONC_EXT_FEL_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__FEL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__FEL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_FEL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.FEL_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__FEL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label473">
		<span class="label" id="label473"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label474">
		<span class="label" id="label474"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label475">
		<span class="label" id="label475"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DVS" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DVS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DVS" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DVS">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DVS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DVS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DVS"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DVS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label476">
		<span class="label" id="label476">Diminution in Value of Stock</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="DVS_LOI" 
		id="pb-container-currency-SECTIONC_EXT-DVS_LOI">
		<asp:Label ID="lblSECTIONC_EXT_DVS_LOI" runat="server" AssociatedControlID="SECTIONC_EXT__DVS_LOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__DVS_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_DVS_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.DVS_LOI"
			ClientValidationFunction="onValidate_SECTIONC_EXT__DVS_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label477">
		<span class="label" id="label477"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label478">
		<span class="label" id="label478"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label479">
		<span class="label" id="label479"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_HIP" for="ctl00_cntMainBody_SECTIONC_EXT__IS_HIP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_HIP" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_HIP">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_HIP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_HIP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_HIP"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_HIP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label480">
		<span class="label" id="label480">Hired-In Plant</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="HIP_LOL" 
		id="pb-container-currency-SECTIONC_EXT-HIP_LOL">
		<asp:Label ID="lblSECTIONC_EXT_HIP_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__HIP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__HIP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_HIP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.HIP_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__HIP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label481">
		<span class="label" id="label481"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label482">
		<span class="label" id="label482"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label483">
		<span class="label" id="label483"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_PRE" for="ctl00_cntMainBody_SECTIONC_EXT__IS_PRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_PRE" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_PRE">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_PRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_PRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_PRE"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_PRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label484">
		<span class="label" id="label484">Public Relations Expenses</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="PRE_LOL" 
		id="pb-container-currency-SECTIONC_EXT-PRE_LOL">
		<asp:Label ID="lblSECTIONC_EXT_PRE_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__PRE_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__PRE_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_PRE_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.PRE_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__PRE_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label485">
		<span class="label" id="label485"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label486">
		<span class="label" id="label486"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label487">
		<span class="label" id="label487"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_TA" for="ctl00_cntMainBody_SECTIONC_EXT__IS_TA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_TA" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_TA">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_TA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_TA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_TA"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_TA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label488">
		<span class="label" id="label488">Tax Allowance</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="TA_LOL" 
		id="pb-container-currency-SECTIONC_EXT-TA_LOL">
		<asp:Label ID="lblSECTIONC_EXT_TA_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__TA_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__TA_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_TA_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.TA_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__TA_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label489">
		<span class="label" id="label489"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label490">
		<span class="label" id="label490"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label491">
		<span class="label" id="label491"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_ROY" for="ctl00_cntMainBody_SECTIONC_EXT__IS_ROY" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_ROY" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_ROY">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_ROY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_ROY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_ROY"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_ROY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label492">
		<span class="label" id="label492">Royalties</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="ROY_LOL" 
		id="pb-container-currency-SECTIONC_EXT-ROY_LOL">
		<asp:Label ID="lblSECTIONC_EXT_ROY_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__ROY_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__ROY_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_ROY_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.ROY_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__ROY_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label493">
		<span class="label" id="label493"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label494">
		<span class="label" id="label494"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label495">
		<span class="label" id="label495"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_TPITS" for="ctl00_cntMainBody_SECTIONC_EXT__IS_TPITS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_TPITS" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_TPITS">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_TPITS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_TPITS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_TPITS"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_TPITS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label496">
		<span class="label" id="label496">Third Party I.T. Services</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="TPITS_LOL" 
		id="pb-container-currency-SECTIONC_EXT-TPITS_LOL">
		<asp:Label ID="lblSECTIONC_EXT_TPITS_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__TPITS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__TPITS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_TPITS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.TPITS_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__TPITS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label497">
		<span class="label" id="label497"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label498">
		<span class="label" id="label498"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label499">
		<span class="label" id="label499"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_EXT_IS_DUS" for="ctl00_cntMainBody_SECTIONC_EXT__IS_DUS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="IS_DUS" 
		id="pb-container-checkbox-SECTIONC_EXT-IS_DUS">	
		
		<asp:TextBox ID="SECTIONC_EXT__IS_DUS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_EXT_IS_DUS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.IS_DUS"
			ClientValidationFunction="onValidate_SECTIONC_EXT__IS_DUS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label500">
		<span class="label" id="label500">Depreciation of Undamaged Stock</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="DUS_LOL" 
		id="pb-container-currency-SECTIONC_EXT-DUS_LOL">
		<asp:Label ID="lblSECTIONC_EXT_DUS_LOL" runat="server" AssociatedControlID="SECTIONC_EXT__DUS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_EXT__DUS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_EXT_DUS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.DUS_LOL"
			ClientValidationFunction="onValidate_SECTIONC_EXT__DUS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label501">
		<span class="label" id="label501"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label502">
		<span class="label" id="label502"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label503">
		<span class="label" id="label503"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id95766dfc290840f7bb9e6a7aaafb01db div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id95766dfc290840f7bb9e6a7aaafb01db div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id95766dfc290840f7bb9e6a7aaafb01db div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id95766dfc290840f7bb9e6a7aaafb01db div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#id95766dfc290840f7bb9e6a7aaafb01db label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id95766dfc290840f7bb9e6a7aaafb01db label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id95766dfc290840f7bb9e6a7aaafb01db label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id95766dfc290840f7bb9e6a7aaafb01db label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id95766dfc290840f7bb9e6a7aaafb01db input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id95766dfc290840f7bb9e6a7aaafb01db input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id95766dfc290840f7bb9e6a7aaafb01db input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="Other Business Interruption Extensions" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading90" runat="server" Text="Other Business Interruption Extensions" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC_EXT__OTHERBIEXT"
		data-field-type="Child" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="OTHERBIEXT" 
		id="pb-container-childscreen-SECTIONC_EXT-OTHERBIEXT">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC_EXT__OTH_BI_EXT" runat="server" ScreenCode="OTHERBIEXT" AutoGenerateColumns="false"
							GridLines="None" ChildPage="OTHERBIEXT/OTHERBIEXT_Other_Business_Interruption_Extensions.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="DESCRIP" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Limit of Liability" DataField="LOL" DataFormatString="{0:N}"/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_EXT_OTHERBIEXT" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC_EXT.OTHERBIEXT"
						ClientValidationFunction="onValidate_SECTIONC_EXT__OTHERBIEXT" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="OTHERBIEXT_CNT" 
		id="pb-container-integer-SECTIONC_EXT-OTHERBIEXT_CNT">
		<asp:Label ID="lblSECTIONC_EXT_OTHERBIEXT_CNT" runat="server" AssociatedControlID="SECTIONC_EXT__OTHERBIEXT_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC_EXT__OTHERBIEXT_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_EXT_OTHERBIEXT_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.OTHERBIEXT_CNT"
			ClientValidationFunction="onValidate_SECTIONC_EXT__OTHERBIEXT_CNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#Other Business Interruption Extensions div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Other Business Interruption Extensions div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Other Business Interruption Extensions div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#Other Business Interruption Extensions div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#Other Business Interruption Extensions label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Other Business Interruption Extensions label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Business Interruption Extensions label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Business Interruption Extensions label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Other Business Interruption Extensions input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Business Interruption Extensions input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Business Interruption Extensions input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id915844318ac44575a5a8269ecea602fa" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading91" runat="server" Text="Specified Direct Customers" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC_EXT__EXTSPDC"
		data-field-type="Child" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="EXTSPDC" 
		id="pb-container-childscreen-SECTIONC_EXT-EXTSPDC">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC_EXT__SPEC_CUST" runat="server" ScreenCode="EXTSPDC" AutoGenerateColumns="false"
							GridLines="None" ChildPage="EXTSPDC/EXTSPDC_Specified_Direct_Customers.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Name" DataField="NAME" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Percentage" DataField="PERC" DataFormatString="{0:0}%"/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_EXT_EXTSPDC" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC_EXT.EXTSPDC"
						ClientValidationFunction="onValidate_SECTIONC_EXT__EXTSPDC" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="EXTSPDC_CNT" 
		id="pb-container-integer-SECTIONC_EXT-EXTSPDC_CNT">
		<asp:Label ID="lblSECTIONC_EXT_EXTSPDC_CNT" runat="server" AssociatedControlID="SECTIONC_EXT__EXTSPDC_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC_EXT__EXTSPDC_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_EXT_EXTSPDC_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.EXTSPDC_CNT"
			ClientValidationFunction="onValidate_SECTIONC_EXT__EXTSPDC_CNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id915844318ac44575a5a8269ecea602fa div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id915844318ac44575a5a8269ecea602fa div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id915844318ac44575a5a8269ecea602fa div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id915844318ac44575a5a8269ecea602fa div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#id915844318ac44575a5a8269ecea602fa label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id915844318ac44575a5a8269ecea602fa label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id915844318ac44575a5a8269ecea602fa label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id915844318ac44575a5a8269ecea602fa label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id915844318ac44575a5a8269ecea602fa input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id915844318ac44575a5a8269ecea602fa input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id915844318ac44575a5a8269ecea602fa input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idd4a33bf5d82443b491ed64a1962836dd" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading92" runat="server" Text="Specified Direct Suppliers" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC_EXT__EXTSPDS"
		data-field-type="Child" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="EXTSPDS" 
		id="pb-container-childscreen-SECTIONC_EXT-EXTSPDS">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC_EXT__SPEC_SUPP" runat="server" ScreenCode="EXTSPDS" AutoGenerateColumns="false"
							GridLines="None" ChildPage="EXTSPDS/EXTSPDS_Specified_Direct_Suppliers.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Name" DataField="NAME" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Percentage" DataField="PERC" DataFormatString="{0:0}%"/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_EXT_EXTSPDS" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC_EXT.EXTSPDS"
						ClientValidationFunction="onValidate_SECTIONC_EXT__EXTSPDS" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC_EXT" 
		data-property-name="EXTSPDS_CNT" 
		id="pb-container-integer-SECTIONC_EXT-EXTSPDS_CNT">
		<asp:Label ID="lblSECTIONC_EXT_EXTSPDS_CNT" runat="server" AssociatedControlID="SECTIONC_EXT__EXTSPDS_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC_EXT__EXTSPDS_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_EXT_EXTSPDS_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_EXT.EXTSPDS_CNT"
			ClientValidationFunction="onValidate_SECTIONC_EXT__EXTSPDS_CNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idd4a33bf5d82443b491ed64a1962836dd div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idd4a33bf5d82443b491ed64a1962836dd div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idd4a33bf5d82443b491ed64a1962836dd div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idd4a33bf5d82443b491ed64a1962836dd div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#idd4a33bf5d82443b491ed64a1962836dd label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idd4a33bf5d82443b491ed64a1962836dd label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd4a33bf5d82443b491ed64a1962836dd label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd4a33bf5d82443b491ed64a1962836dd label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idd4a33bf5d82443b491ed64a1962836dd input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd4a33bf5d82443b491ed64a1962836dd input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd4a33bf5d82443b491ed64a1962836dd input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idd6fe862804984054b82f682ef64cb3ed" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading93" runat="server" Text="Deductibles " /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label504">
		<span class="label" id="label504"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label505">
		<span class="label" id="label505"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label506">
		<span class="label" id="label506">Ded %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label507">
		<span class="label" id="label507">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label508">
		<span class="label" id="label508">Maximum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_FAPCWPD" for="ctl00_cntMainBody_SECTIONC_DED__IS_FAPCWPD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_FAPCWPD" 
		id="pb-container-checkbox-SECTIONC_DED-IS_FAPCWPD">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_FAPCWPD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_FAPCWPD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_FAPCWPD"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_FAPCWPD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label509">
		<span class="label" id="label509">Fire and Allied Perils  (Combined with Property Damage)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="FAPCWPD_PERC" 
		id="pb-container-percentage-SECTIONC_DED-FAPCWPD_PERC">
		<asp:Label ID="lblSECTIONC_DED_FAPCWPD_PERC" runat="server" AssociatedControlID="SECTIONC_DED__FAPCWPD_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__FAPCWPD_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_FAPCWPD_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.FAPCWPD_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__FAPCWPD_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="FAPCWPD_MIN" 
		id="pb-container-currency-SECTIONC_DED-FAPCWPD_MIN">
		<asp:Label ID="lblSECTIONC_DED_FAPCWPD_MIN" runat="server" AssociatedControlID="SECTIONC_DED__FAPCWPD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__FAPCWPD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_FAPCWPD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.FAPCWPD_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__FAPCWPD_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="FAPCWPD_MAX" 
		id="pb-container-currency-SECTIONC_DED-FAPCWPD_MAX">
		<asp:Label ID="lblSECTIONC_DED_FAPCWPD_MAX" runat="server" AssociatedControlID="SECTIONC_DED__FAPCWPD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__FAPCWPD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_FAPCWPD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.FAPCWPD_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__FAPCWPD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label510">
		<span class="label" id="label510">Extended Premises as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label511">
		<span class="label" id="label511"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label512">
		<span class="label" id="label512"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label513">
		<span class="label" id="label513"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label514">
		<span class="label" id="label514"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label515">
		<span class="label" id="label515">Direct Customers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label516">
		<span class="label" id="label516"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label517">
		<span class="label" id="label517"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label518">
		<span class="label" id="label518"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label519">
		<span class="label" id="label519"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CSPEC" for="ctl00_cntMainBody_SECTIONC_DED__IS_CSPEC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CSPEC" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CSPEC">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CSPEC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CSPEC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CSPEC"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CSPEC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label520">
		<span class="label" id="label520">Specified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECD_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CSPECD_PERC">
		<asp:Label ID="lblSECTIONC_DED_CSPECD_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CSPECD_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CSPECD_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECD_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECD_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECD_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECD_MIN" 
		id="pb-container-currency-SECTIONC_DED-CSPECD_MIN">
		<asp:Label ID="lblSECTIONC_DED_CSPECD_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CSPECD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CSPECD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECD_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECD_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECD_MAX" 
		id="pb-container-currency-SECTIONC_DED-CSPECD_MAX">
		<asp:Label ID="lblSECTIONC_DED_CSPECD_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CSPECD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CSPECD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECD_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CUSPD" for="ctl00_cntMainBody_SECTIONC_DED__IS_CUSPD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CUSPD" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CUSPD">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CUSPD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CUSPD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CUSPD"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CUSPD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label521">
		<span class="label" id="label521">Unspecified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUSPD_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CUSPD_PERC">
		<asp:Label ID="lblSECTIONC_DED_CUSPD_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CUSPD_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CUSPD_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUSPD_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUSPD_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUSPD_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUSPD_MIN" 
		id="pb-container-currency-SECTIONC_DED-CUSPD_MIN">
		<asp:Label ID="lblSECTIONC_DED_CUSPD_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CUSPD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CUSPD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUSPD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUSPD_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUSPD_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUSPD_MAX" 
		id="pb-container-currency-SECTIONC_DED-CUSPD_MAX">
		<asp:Label ID="lblSECTIONC_DED_CUSPD_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CUSPD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CUSPD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUSPD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUSPD_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUSPD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label522">
		<span class="label" id="label522">Direct Suppliers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label523">
		<span class="label" id="label523"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label524">
		<span class="label" id="label524"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label525">
		<span class="label" id="label525"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label526">
		<span class="label" id="label526"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CSPECDD" for="ctl00_cntMainBody_SECTIONC_DED__IS_CSPECDD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CSPECDD" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CSPECDD">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CSPECDD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CSPECDD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CSPECDD"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CSPECDD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label527">
		<span class="label" id="label527">Specified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECDD_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CSPECDD_PERC">
		<asp:Label ID="lblSECTIONC_DED_CSPECDD_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CSPECDD_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CSPECDD_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECDD_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECDD_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECDD_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECDD_MIN" 
		id="pb-container-currency-SECTIONC_DED-CSPECDD_MIN">
		<asp:Label ID="lblSECTIONC_DED_CSPECDD_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CSPECDD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CSPECDD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECDD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECDD_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECDD_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CSPECDD_MAX" 
		id="pb-container-currency-SECTIONC_DED-CSPECDD_MAX">
		<asp:Label ID="lblSECTIONC_DED_CSPECDD_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CSPECDD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CSPECDD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CSPECDD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CSPECDD_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CSPECDD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CUNSPECDD" for="ctl00_cntMainBody_SECTIONC_DED__IS_CUNSPECDD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CUNSPECDD" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CUNSPECDD">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CUNSPECDD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CUNSPECDD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CUNSPECDD"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CUNSPECDD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label528">
		<span class="label" id="label528">Unspecified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUNSPECDD_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CUNSPECDD_PERC">
		<asp:Label ID="lblSECTIONC_DED_CUNSPECDD_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CUNSPECDD_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CUNSPECDD_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUNSPECDD_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUNSPECDD_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUNSPECDD_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUNSPECDD_MIN" 
		id="pb-container-currency-SECTIONC_DED-CUNSPECDD_MIN">
		<asp:Label ID="lblSECTIONC_DED_CUNSPECDD_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CUNSPECDD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CUNSPECDD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUNSPECDD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUNSPECDD_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUNSPECDD_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CUNSPECDD_MAX" 
		id="pb-container-currency-SECTIONC_DED-CUNSPECDD_MAX">
		<asp:Label ID="lblSECTIONC_DED_CUNSPECDD_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CUNSPECDD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CUNSPECDD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CUNSPECDD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CUNSPECDD_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CUNSPECDD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CPOACC" for="ctl00_cntMainBody_SECTIONC_DED__IS_CPOACC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CPOACC" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CPOACC">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CPOACC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CPOACC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CPOACC"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CPOACC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label529">
		<span class="label" id="label529">Prevention of Access</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPOACC_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CPOACC_PERC">
		<asp:Label ID="lblSECTIONC_DED_CPOACC_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CPOACC_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CPOACC_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPOACC_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPOACC_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPOACC_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPOACC_MIN" 
		id="pb-container-currency-SECTIONC_DED-CPOACC_MIN">
		<asp:Label ID="lblSECTIONC_DED_CPOACC_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CPOACC_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CPOACC_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPOACC_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPOACC_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPOACC_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPOACC_MAX" 
		id="pb-container-currency-SECTIONC_DED-CPOACC_MAX">
		<asp:Label ID="lblSECTIONC_DED_CPOACC_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CPOACC_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CPOACC_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPOACC_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPOACC_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPOACC_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CAO" for="ctl00_cntMainBody_SECTIONC_DED__IS_CAO" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CAO" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CAO">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CAO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CAO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CAO"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CAO" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label530">
		<span class="label" id="label530">All Other</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CAO_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CAO_PERC">
		<asp:Label ID="lblSECTIONC_DED_CAO_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CAO_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CAO_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CAO_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CAO_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CAO_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CAO_MIN" 
		id="pb-container-currency-SECTIONC_DED-CAO_MIN">
		<asp:Label ID="lblSECTIONC_DED_CAO_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CAO_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CAO_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CAO_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CAO_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CAO_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CAO_MAX" 
		id="pb-container-currency-SECTIONC_DED-CAO_MAX">
		<asp:Label ID="lblSECTIONC_DED_CAO_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CAO_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CAO_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CAO_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CAO_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CAO_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label531">
		<span class="label" id="label531">Extended Damage as follows</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label532">
		<span class="label" id="label532"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label533">
		<span class="label" id="label533"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label534">
		<span class="label" id="label534"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label535">
		<span class="label" id="label535"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONC_DED_IS_CPUT" for="ctl00_cntMainBody_SECTIONC_DED__IS_CPUT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONC_DED" 
		data-property-name="IS_CPUT" 
		id="pb-container-checkbox-SECTIONC_DED-IS_CPUT">	
		
		<asp:TextBox ID="SECTIONC_DED__IS_CPUT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONC_DED_IS_CPUT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.IS_CPUT"
			ClientValidationFunction="onValidate_SECTIONC_DED__IS_CPUT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label536">
		<span class="label" id="label536">Public Utilities</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPUT_PERC" 
		id="pb-container-percentage-SECTIONC_DED-CPUT_PERC">
		<asp:Label ID="lblSECTIONC_DED_CPUT_PERC" runat="server" AssociatedControlID="SECTIONC_DED__CPUT_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONC_DED__CPUT_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPUT_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPUT_PERC"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPUT_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPUT_MIN" 
		id="pb-container-currency-SECTIONC_DED-CPUT_MIN">
		<asp:Label ID="lblSECTIONC_DED_CPUT_MIN" runat="server" AssociatedControlID="SECTIONC_DED__CPUT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CPUT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPUT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPUT_MIN"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPUT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC_DED" 
		data-property-name="CPUT_MAX" 
		id="pb-container-currency-SECTIONC_DED-CPUT_MAX">
		<asp:Label ID="lblSECTIONC_DED_CPUT_MAX" runat="server" AssociatedControlID="SECTIONC_DED__CPUT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC_DED__CPUT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_DED_CPUT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.CPUT_MAX"
			ClientValidationFunction="onValidate_SECTIONC_DED__CPUT_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idd6fe862804984054b82f682ef64cb3ed div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idd6fe862804984054b82f682ef64cb3ed div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idd6fe862804984054b82f682ef64cb3ed div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idd6fe862804984054b82f682ef64cb3ed div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#idd6fe862804984054b82f682ef64cb3ed label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idd6fe862804984054b82f682ef64cb3ed label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd6fe862804984054b82f682ef64cb3ed label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd6fe862804984054b82f682ef64cb3ed label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idd6fe862804984054b82f682ef64cb3ed input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd6fe862804984054b82f682ef64cb3ed input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd6fe862804984054b82f682ef64cb3ed input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id176b71c171c84f4fb6f2a627d5450dea" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading94" runat="server" Text="Other Business Interruption Deductibles" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC_DED__OTHBIDED"
		data-field-type="Child" 
		data-object-name="SECTIONC_DED" 
		data-property-name="OTHBIDED" 
		id="pb-container-childscreen-SECTIONC_DED-OTHBIDED">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC_DED__OTH_BI_DED" runat="server" ScreenCode="OTHBIDED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="OTHBIDED/OTHBIDED_Other_Business_Interruption_Deductibles.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="DESCRIP" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Ded %" DataField="DED_PERC" DataFormatString="{0:0}%"/>
<Nexus:RiskAttribute HeaderText="Minimum Amount" DataField="DED_MIN" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Maximum Amount" DataField="DED_MAX" DataFormatString="{0:N}"/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_DED_OTHBIDED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC_DED.OTHBIDED"
						ClientValidationFunction="onValidate_SECTIONC_DED__OTHBIDED" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC_DED" 
		data-property-name="OTHBIDED_CNT" 
		id="pb-container-integer-SECTIONC_DED-OTHBIDED_CNT">
		<asp:Label ID="lblSECTIONC_DED_OTHBIDED_CNT" runat="server" AssociatedControlID="SECTIONC_DED__OTHBIDED_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC_DED__OTHBIDED_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_DED_OTHBIDED_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC_DED.OTHBIDED_CNT"
			ClientValidationFunction="onValidate_SECTIONC_DED__OTHBIDED_CNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id176b71c171c84f4fb6f2a627d5450dea div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id176b71c171c84f4fb6f2a627d5450dea div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id176b71c171c84f4fb6f2a627d5450dea div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id176b71c171c84f4fb6f2a627d5450dea div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#id176b71c171c84f4fb6f2a627d5450dea label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id176b71c171c84f4fb6f2a627d5450dea label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id176b71c171c84f4fb6f2a627d5450dea label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id176b71c171c84f4fb6f2a627d5450dea label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id176b71c171c84f4fb6f2a627d5450dea input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id176b71c171c84f4fb6f2a627d5450dea input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id176b71c171c84f4fb6f2a627d5450dea input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmClauses" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading95" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblSECTIONC_SECTIONC_CLAUSES" runat="server" AssociatedControlID="SECTIONC__SECTIONC_CLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="SECTIONC__SECTIONC_CLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC" 
		data-property-name="SECTIONC_COUNT" 
		id="pb-container-integer-SECTIONC-SECTIONC_COUNT">
		<asp:Label ID="lblSECTIONC_SECTIONC_COUNT" runat="server" AssociatedControlID="SECTIONC__SECTIONC_COUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC__SECTIONC_COUNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_SECTIONC_COUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.SECTIONC_COUNT"
			ClientValidationFunction="onValidate_SECTIONC__SECTIONC_COUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONC" 
		data-property-name="ENDORSE_PREMIUM" 
		id="pb-container-currency-SECTIONC-ENDORSE_PREMIUM">
		<asp:Label ID="lblSECTIONC_ENDORSE_PREMIUM" runat="server" AssociatedControlID="SECTIONC__ENDORSE_PREMIUM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONC__ENDORSE_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONC_ENDORSE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_SECTIONC__ENDORSE_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC__BIENDP"
		data-field-type="Child" 
		data-object-name="SECTIONC" 
		data-property-name="BIENDP" 
		id="pb-container-childscreen-SECTIONC-BIENDP">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC__SECTIONC_CLAUSEPREM" runat="server" ScreenCode="BIENDP" AutoGenerateColumns="false"
							GridLines="None" ChildPage="BIENDP/BIENDP_Endorsement_Premium.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Endorsement" DataField="ENDORSE_CAP" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Premium" DataField="PREMIUM" DataFormatString="{0:N}"/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_BIENDP" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC.BIENDP"
						ClientValidationFunction="onValidate_SECTIONC__BIENDP" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#frmClauses div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmClauses div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmClauses div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#frmClauses div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#frmClauses label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmClauses label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmClauses label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmClauses label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmClauses input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmClauses input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmClauses input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="ida7c7fffad12140508be4fd768cc68c2c" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading96" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC__BINOTE"
		data-field-type="Child" 
		data-object-name="SECTIONC" 
		data-property-name="BINOTE" 
		id="pb-container-childscreen-SECTIONC-BINOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC__SECC_DETAILS" runat="server" ScreenCode="BINOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="BINOTE/BINOTE_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="DATE_CREATED" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="CREATED_BY" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="COVER_TYPE" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="NOTE_DESCRIPTION" DataFormatString=""/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_BINOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC.BINOTE"
						ClientValidationFunction="onValidate_SECTIONC__BINOTE" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#ida7c7fffad12140508be4fd768cc68c2c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ida7c7fffad12140508be4fd768cc68c2c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ida7c7fffad12140508be4fd768cc68c2c div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#ida7c7fffad12140508be4fd768cc68c2c div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#ida7c7fffad12140508be4fd768cc68c2c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ida7c7fffad12140508be4fd768cc68c2c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida7c7fffad12140508be4fd768cc68c2c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida7c7fffad12140508be4fd768cc68c2c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ida7c7fffad12140508be4fd768cc68c2c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida7c7fffad12140508be4fd768cc68c2c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida7c7fffad12140508be4fd768cc68c2c input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idd87a3c0499354ad3b68e528726ed894e" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading97" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONC__BISNOTE"
		data-field-type="Child" 
		data-object-name="SECTIONC" 
		data-property-name="BISNOTE" 
		id="pb-container-childscreen-SECTIONC-BISNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONC__SECCS_DETAILS" runat="server" ScreenCode="BISNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="BISNOTE/BISNOTE_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="DATE_CREATED" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="CREATED_BY" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="COVER_TYPE" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="NOTE_DESCRIPTION" DataFormatString=""/>

										<%--
										<Nexus:RiskAttribute HeaderText="Vehicle Make" DataField="VEHICLE_MAKE" FilterByControl="txtVehicleMake" />
										<Nexus:RiskAttribute HeaderText="On Date" DataField="ON_DATE" DataFormatString="{0:d}" />
						<Nexus:GISLookupField HeaderText="Cover Type" ListType="UserDefined" ListCode="FLEETCOVER" DataField="CoverType" DataItemValue="key" />
										--%>
							</columns>
						</nexus:ItemGrid>
						<%--<NexusProvider:LookupList ID="Vehicle_Type" runat="server" CssClass="field-medium"
							ListType="UserDefined" ListCode="FLEETTYPE" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />
						<NexusProvider:LookupList ID="CoverType" runat="server" CssClass="field-medium" ListType="UserDefined"
							ListCode="FLEETCOVER" ParentLookupListID="" DataItemValue="Description" DataItemText="Key"
							Visible="false" DefaultText="(Please Select)" />--%>
					</div>
				
					<asp:CustomValidator ID="valSECTIONC_BISNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONC.BISNOTE"
						ClientValidationFunction="onValidate_SECTIONC__BISNOTE" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONC" 
		data-property-name="BISNOTE_CNT" 
		id="pb-container-integer-SECTIONC-BISNOTE_CNT">
		<asp:Label ID="lblSECTIONC_BISNOTE_CNT" runat="server" AssociatedControlID="SECTIONC__BISNOTE_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONC__BISNOTE_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONC_BISNOTE_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONC.BISNOTE_CNT"
			ClientValidationFunction="onValidate_SECTIONC__BISNOTE_CNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idd87a3c0499354ad3b68e528726ed894e div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idd87a3c0499354ad3b68e528726ed894e div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idd87a3c0499354ad3b68e528726ed894e div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idd87a3c0499354ad3b68e528726ed894e div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#idd87a3c0499354ad3b68e528726ed894e label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idd87a3c0499354ad3b68e528726ed894e label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd87a3c0499354ad3b68e528726ed894e label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd87a3c0499354ad3b68e528726ed894e label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idd87a3c0499354ad3b68e528726ed894e input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd87a3c0499354ad3b68e528726ed894e input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd87a3c0499354ad3b68e528726ed894e input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
				
         
		
</div>


<!-- /GeneralLayoutContainer -->
							</div>
						                     
                    </div>
				    <div class='card-footer clearfix'>
                        <asp:Button ID="refreshCV" runat="server" SkinID="buttonSecondary" Style="display: none" />
						<% 	
							' TODO: Set this condition to hide the button on the first page
							Dim firstPage As Boolean = True
						
							If firstPage %>
                        <asp:Button ID="btnBack" runat="server" Text="Back" OnClick="BackButton" CausesValidation="false" OnClientClick="clearCookieScrollPos()"
                            SkinID="buttonSecondary" />
						<% End If %>
						<asp:Button ID="btnNext" runat="server" Text="Next" OnClick="NextButton" OnClientClick="clearCookieScrollPos()"
                            SkinID="buttonPrimary" disabled="disabled" />
                        <asp:Button ID="btnFinish" runat="server" Text="Finish" OnClick="FinishButton" SkinID="buttonPrimary" OnClientClick="clearCookieScrollPos()"
                            OnPreRender="PreRenderFinish" />
						
					</div>
             </div>
			<asp:ValidationSummary ID="validationSummeryBox" runat="server" DisplayMode="BulletList" HeaderText="Correct the below given errors" EnableClientScript="true" CssClass="validation-summary" />
        </div>
  
</div>
</asp:Content>