<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="AAR_Section_B_Engineering.aspx.vb" Inherits="Nexus.PB2_AAR_Section_B_Engineering" %>

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
function onValidate_SECTIONB__ATTACHMENTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ATTACHMENTDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONB", "ATTACHMENTDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONB_ATTACHMENTDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONB__ATTACHMENTDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONB__ATTACHMENTDATE_lblFindParty");
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
              var field = Field.getInstance("SECTIONB.ATTACHMENTDATE");
        			window.setControlWidth(field, "0.7", "SECTIONB", "ATTACHMENTDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONB__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONB", "EFFECTIVEDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONB_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONB__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONB__EFFECTIVEDATE_lblFindParty");
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
              var field = Field.getInstance("SECTIONB.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.7", "SECTIONB", "EFFECTIVEDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONB__IS_MB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "IS_MB", "Checkbox");
        })();
}
function onValidate_SECTIONB__MB_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "MB_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONB__MB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "MB_RATE", "Percentage");
        })();
}
function onValidate_SECTIONB__MB_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "MB_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONB__IS_EE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "IS_EE", "Checkbox");
        })();
}
function onValidate_SECTIONB__EE_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "EE_SUMINSURED", "Currency");
        })();
}
function onValidate_SECTIONB__EE_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "EE_RATE", "Percentage");
        })();
}
function onValidate_SECTIONB__EE_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "EE_PREMIUM", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_OM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_OM", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__OM_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "OM_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_FB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_FB", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__FB_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "FB_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_CC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_CC", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__CC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "CC_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_EC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_EC", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__EC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "EC_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_SP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_SP", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__SP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "SP_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_PF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_PF", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__PF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "PF_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_UE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_UE", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__UE_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "UE_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_ILH(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_ILH", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__ILH_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "ILH_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_LOC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_LOC", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__LOC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "LOC_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_RD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_RD", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__RD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "RD_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_INC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_INC", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__INC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "INC_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_TRP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_TRP", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__TRP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "TRP_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_SPD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_SPD", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__SPD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "SPD_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_PSF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_PSF", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__PSF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "PSF_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_DRP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_DRP", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__DRP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "DRP_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__IS_SMG(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "IS_SMG", "Checkbox");
        })();
}
function onValidate_SECTIONB_EXT__SMG_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "SMG_LOL", "Currency");
        })();
}
function onValidate_SECTIONB_EXT__ENGOTEXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "ENGOTEXT", "ChildScreen");
        })();
}
function onValidate_SECTIONB_EXT__ENGOTEXT_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_EXT", "ENGOTEXT_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONB_EXT", "ENGOTEXT_CNT");
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
          * @param SECTIONB_EXT The Parent (Root) object name.
          * @param OTH_ENG_EXT.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONB_EXT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_ENG_EXT.DESCRIP";
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
        		
        		var field = Field.getInstance("SECTIONB_EXT", "ENGOTEXT_CNT");
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
        			
        			var field = Field.getInstance("SECTIONB_EXT", "ENGOTEXT_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONB_DED__IS_MB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "IS_MB", "Checkbox");
        })();
}
function onValidate_SECTIONB_DED__MB_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "MB_DED", "Percentage");
        })();
}
function onValidate_SECTIONB_DED__MB_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "MB_MIN", "Currency");
        })();
}
function onValidate_SECTIONB_DED__MB_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "MB_MAX", "Currency");
        })();
}
function onValidate_SECTIONB_DED__IS_BBI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "IS_BBI", "Checkbox");
        })();
}
function onValidate_SECTIONB_DED__BBI_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "BBI_DED", "Percentage");
        })();
}
function onValidate_SECTIONB_DED__BBI_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "BBI_MIN", "Currency");
        })();
}
function onValidate_SECTIONB_DED__BBI_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "BBI_MAX", "Currency");
        })();
}
function onValidate_SECTIONB_DED__IS_PORT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "IS_PORT", "Checkbox");
        })();
}
function onValidate_SECTIONB_DED__PORT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "PORT_DED", "Percentage");
        })();
}
function onValidate_SECTIONB_DED__PORT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "PORT_MIN", "Currency");
        })();
}
function onValidate_SECTIONB_DED__PORT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "PORT_MAX", "Currency");
        })();
}
function onValidate_SECTIONB_DED__ENGOTPDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "ENGOTPDED", "ChildScreen");
        })();
}
function onValidate_SECTIONB_DED__ENGOTPDED_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB_DED", "ENGOTPDED_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONB_DED", "ENGOTPDED_CNT");
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
          * @param SECTIONB_DED The Parent (Root) object name.
          * @param OTH_ENG_DED.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONB_DED".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_ENG_DED.DESCRIP";
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
        		
        		var field = Field.getInstance("SECTIONB_DED", "ENGOTPDED_CNT");
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
        			
        			var field = Field.getInstance("SECTIONB_DED", "ENGOTPDED_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONB__SECTIONB_COUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "SECTIONB_COUNT", "Integer");
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
        			var field = Field.getInstance("SECTIONB", "SECTIONB_COUNT");
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
          * @param SECTIONB The Parent (Root) object name.
          * @param SECTIONB_CLAUSEPREM.COUNTER_ID The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONB".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONB_CLAUSEPREM.COUNTER_ID";
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
        		
        		var field = Field.getInstance("SECTIONB", "SECTIONB_COUNT");
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
        			
        			var field = Field.getInstance("SECTIONB", "SECTIONB_COUNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONB__ENDORSE_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ENDORSE_PREMIUM", "Currency");
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
        			field = Field.getInstance("SECTIONB", "ENDORSE_PREMIUM");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONB_ENDORSE_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONB__ENDORSE_PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONB__ENDORSE_PREMIUM_lblFindParty");
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
              var field = Field.getInstance("SECTIONB.ENDORSE_PREMIUM");
        			window.setControlWidth(field, "1", "SECTIONB", "ENDORSE_PREMIUM");
        		})();
        	}
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONB The Parent (Root) object name.
          * @param SECTIONB_CLAUSEPREM.PREMIUM The object.property to sum the totals of.
          * @param TOTAL The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONB".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONB_CLAUSEPREM.PREMIUM";
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
        		
        		var field = Field.getInstance("SECTIONB", "ENDORSE_PREMIUM");
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
        			
        			var field = Field.getInstance("SECTIONB", "ENDORSE_PREMIUM");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONB__ENGPEND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ENGPEND", "ChildScreen");
        })();
}
function onValidate_SECTIONB__ENGNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ENGNOTE", "ChildScreen");
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
        		var field = Field.getInstance("SECTIONB", "ENGNOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONB__ENGNOTE table td a");
        				
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
        		var field = Field.getInstance("SECTIONB", "ENGNOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'SECTIONB' and property 'ENGNOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONB__ENGNOTE table td a");
        				
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
function onValidate_SECTIONB__ENGSNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ENGSNOTE", "ChildScreen");
        })();
}
function onValidate_SECTIONB__ENGSNOTE_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONB", "ENGSNOTE_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONB", "ENGSNOTE_CNT");
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
          * @param SECTIONB The Parent (Root) object name.
          * @param SECBS_DETAILS.DATE_CREATED The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONB".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECBS_DETAILS.DATE_CREATED";
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
        		
        		var field = Field.getInstance("SECTIONB", "ENGSNOTE_CNT");
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
        			
        			var field = Field.getInstance("SECTIONB", "ENGSNOTE_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_SECTIONB__ATTACHMENTDATE(null, null, null, isOnLoad);
    onValidate_SECTIONB__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_SECTIONB__IS_MB(null, null, null, isOnLoad);
    onValidate_SECTIONB__MB_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONB__MB_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONB__MB_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONB__IS_EE(null, null, null, isOnLoad);
    onValidate_SECTIONB__EE_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONB__EE_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONB__EE_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_OM(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__OM_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_FB(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__FB_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_CC(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__CC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_EC(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__EC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_SP(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__SP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_PF(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__PF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_UE(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__UE_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_ILH(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__ILH_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_LOC(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__LOC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_RD(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__RD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_INC(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__INC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_TRP(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__TRP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_SPD(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__SPD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_PSF(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__PSF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_DRP(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__DRP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__IS_SMG(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__SMG_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__ENGOTEXT(null, null, null, isOnLoad);
    onValidate_SECTIONB_EXT__ENGOTEXT_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__IS_MB(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__MB_DED(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__MB_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__MB_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__IS_BBI(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__BBI_DED(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__BBI_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__BBI_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__IS_PORT(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__PORT_DED(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__PORT_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__PORT_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__ENGOTPDED(null, null, null, isOnLoad);
    onValidate_SECTIONB_DED__ENGOTPDED_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONB__SECTIONB_COUNT(null, null, null, isOnLoad);
    onValidate_SECTIONB__ENDORSE_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONB__ENGPEND(null, null, null, isOnLoad);
    onValidate_SECTIONB__ENGNOTE(null, null, null, isOnLoad);
    onValidate_SECTIONB__ENGSNOTE(null, null, null, isOnLoad);
    onValidate_SECTIONB__ENGSNOTE_CNT(null, null, null, isOnLoad);
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
<div id="id759fffb181a34c85a8e50a78f653e368" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id6c9e05a69ae042c6a82a1608dab13f9e" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading62" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="SECTIONB" 
		data-property-name="ATTACHMENTDATE" 
		id="pb-container-datejquerycompatible-SECTIONB-ATTACHMENTDATE">
		<asp:Label ID="lblSECTIONB_ATTACHMENTDATE" runat="server" AssociatedControlID="SECTIONB__ATTACHMENTDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONB__ATTACHMENTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONB__ATTACHMENTDATE" runat="server" LinkedControl="SECTIONB__ATTACHMENTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONB_ATTACHMENTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_SECTIONB__ATTACHMENTDATE" 
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
		data-object-name="SECTIONB" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-SECTIONB-EFFECTIVEDATE">
		<asp:Label ID="lblSECTIONB_EFFECTIVEDATE" runat="server" AssociatedControlID="SECTIONB__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONB__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONB__EFFECTIVEDATE" runat="server" LinkedControl="SECTIONB__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONB_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_SECTIONB__EFFECTIVEDATE" 
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
		if ($("#id6c9e05a69ae042c6a82a1608dab13f9e div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id6c9e05a69ae042c6a82a1608dab13f9e div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id6c9e05a69ae042c6a82a1608dab13f9e div ul li").each(function(){		  
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
			$("#id6c9e05a69ae042c6a82a1608dab13f9e div ul li").each(function(){		  
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
		styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6c9e05a69ae042c6a82a1608dab13f9e input{text-align:left;}"; break;
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
<div id="ide656b089870d4967b7ecf16652d77e0b" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading63" runat="server" Text="Risk Data " /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label244">
		<span class="label" id="label244"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label245">
		<span class="label" id="label245"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label246">
		<span class="label" id="label246">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label247">
		<span class="label" id="label247">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label248">
		<span class="label" id="label248">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_IS_MB" for="ctl00_cntMainBody_SECTIONB__IS_MB" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB" 
		data-property-name="IS_MB" 
		id="pb-container-checkbox-SECTIONB-IS_MB">	
		
		<asp:TextBox ID="SECTIONB__IS_MB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_IS_MB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.IS_MB"
			ClientValidationFunction="onValidate_SECTIONB__IS_MB" 
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
	<span id="pb-container-label-label249">
		<span class="label" id="label249">Machinery Breakdown as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label250">
		<span class="label" id="label250"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label251">
		<span class="label" id="label251"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label252">
		<span class="label" id="label252"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label253">
		<span class="label" id="label253"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label254">
		<span class="label" id="label254">Mechanical Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB" 
		data-property-name="MB_SUMINSURED" 
		id="pb-container-currency-SECTIONB-MB_SUMINSURED">
		<asp:Label ID="lblSECTIONB_MB_SUMINSURED" runat="server" AssociatedControlID="SECTIONB__MB_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB__MB_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_MB_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.MB_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONB__MB_SUMINSURED" 
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
		data-object-name="SECTIONB" 
		data-property-name="MB_RATE" 
		id="pb-container-percentage-SECTIONB-MB_RATE">
		<asp:Label ID="lblSECTIONB_MB_RATE" runat="server" AssociatedControlID="SECTIONB__MB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONB__MB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONB_MB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.MB_RATE"
			ClientValidationFunction="onValidate_SECTIONB__MB_RATE" 
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
		data-object-name="SECTIONB" 
		data-property-name="MB_PREMIUM" 
		id="pb-container-currency-SECTIONB-MB_PREMIUM">
		<asp:Label ID="lblSECTIONB_MB_PREMIUM" runat="server" AssociatedControlID="SECTIONB__MB_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB__MB_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_MB_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.MB_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONB__MB_PREMIUM" 
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
<label id="ctl00_cntMainBody_lblSECTIONB_IS_EE" for="ctl00_cntMainBody_SECTIONB__IS_EE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB" 
		data-property-name="IS_EE" 
		id="pb-container-checkbox-SECTIONB-IS_EE">	
		
		<asp:TextBox ID="SECTIONB__IS_EE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_IS_EE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.IS_EE"
			ClientValidationFunction="onValidate_SECTIONB__IS_EE" 
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
	<span id="pb-container-label-label255">
		<span class="label" id="label255">Electronic Equipment as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label256">
		<span class="label" id="label256"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label257">
		<span class="label" id="label257"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label258">
		<span class="label" id="label258"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label259">
		<span class="label" id="label259"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label260">
		<span class="label" id="label260">Electrical and Mechanical Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB" 
		data-property-name="EE_SUMINSURED" 
		id="pb-container-currency-SECTIONB-EE_SUMINSURED">
		<asp:Label ID="lblSECTIONB_EE_SUMINSURED" runat="server" AssociatedControlID="SECTIONB__EE_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB__EE_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EE_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.EE_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONB__EE_SUMINSURED" 
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
		data-object-name="SECTIONB" 
		data-property-name="EE_RATE" 
		id="pb-container-percentage-SECTIONB-EE_RATE">
		<asp:Label ID="lblSECTIONB_EE_RATE" runat="server" AssociatedControlID="SECTIONB__EE_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONB__EE_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONB_EE_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.EE_RATE"
			ClientValidationFunction="onValidate_SECTIONB__EE_RATE" 
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
		data-object-name="SECTIONB" 
		data-property-name="EE_PREMIUM" 
		id="pb-container-currency-SECTIONB-EE_PREMIUM">
		<asp:Label ID="lblSECTIONB_EE_PREMIUM" runat="server" AssociatedControlID="SECTIONB__EE_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB__EE_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.EE_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONB__EE_PREMIUM" 
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
		if ($("#ide656b089870d4967b7ecf16652d77e0b div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ide656b089870d4967b7ecf16652d77e0b div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ide656b089870d4967b7ecf16652d77e0b div ul li").each(function(){		  
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
			$("#ide656b089870d4967b7ecf16652d77e0b div ul li").each(function(){		  
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
		styleString += "#ide656b089870d4967b7ecf16652d77e0b label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ide656b089870d4967b7ecf16652d77e0b label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ide656b089870d4967b7ecf16652d77e0b label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ide656b089870d4967b7ecf16652d77e0b label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ide656b089870d4967b7ecf16652d77e0b input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ide656b089870d4967b7ecf16652d77e0b input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ide656b089870d4967b7ecf16652d77e0b input{text-align:left;}"; break;
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
<div id="id1089a2bf7f644d02ac7d370c227e7888" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading64" runat="server" Text="Extensions " /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label261">
		<span class="label" id="label261"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label262">
		<span class="label" id="label262"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label263">
		<span class="label" id="label263">Limit of Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label264">
		<span class="label" id="label264"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label265">
		<span class="label" id="label265"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_OM" for="ctl00_cntMainBody_SECTIONB_EXT__IS_OM" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_OM" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_OM">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_OM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_OM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_OM"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_OM" 
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
	<span id="pb-container-label-label266">
		<span class="label" id="label266">Operational Media</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="OM_LOL" 
		id="pb-container-currency-SECTIONB_EXT-OM_LOL">
		<asp:Label ID="lblSECTIONB_EXT_OM_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__OM_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__OM_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_OM_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.OM_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__OM_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label267">
		<span class="label" id="label267"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label268">
		<span class="label" id="label268"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_FB" for="ctl00_cntMainBody_SECTIONB_EXT__IS_FB" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_FB" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_FB">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_FB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_FB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_FB"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_FB" 
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
	<span id="pb-container-label-label269">
		<span class="label" id="label269">Foundations and Brickwork</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="FB_LOL" 
		id="pb-container-currency-SECTIONB_EXT-FB_LOL">
		<asp:Label ID="lblSECTIONB_EXT_FB_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__FB_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__FB_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_FB_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.FB_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__FB_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label270">
		<span class="label" id="label270"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label271">
		<span class="label" id="label271"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_CC" for="ctl00_cntMainBody_SECTIONB_EXT__IS_CC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_CC" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_CC">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_CC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_CC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_CC"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_CC" 
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
	<span id="pb-container-label-label272">
		<span class="label" id="label272">Clearance Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="CC_LOL" 
		id="pb-container-currency-SECTIONB_EXT-CC_LOL">
		<asp:Label ID="lblSECTIONB_EXT_CC_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__CC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__CC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_CC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.CC_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__CC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label273">
		<span class="label" id="label273"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label274">
		<span class="label" id="label274"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_EC" for="ctl00_cntMainBody_SECTIONB_EXT__IS_EC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_EC" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_EC">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_EC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_EC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_EC"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_EC" 
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
	<span id="pb-container-label-label275">
		<span class="label" id="label275">Expediting Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="EC_LOL" 
		id="pb-container-currency-SECTIONB_EXT-EC_LOL">
		<asp:Label ID="lblSECTIONB_EXT_EC_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__EC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__EC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_EC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.EC_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__EC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label276">
		<span class="label" id="label276"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label277">
		<span class="label" id="label277"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_SP" for="ctl00_cntMainBody_SECTIONB_EXT__IS_SP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_SP" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_SP">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_SP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_SP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_SP"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_SP" 
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
	<span id="pb-container-label-label278">
		<span class="label" id="label278">Spoilage of Product</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="SP_LOL" 
		id="pb-container-currency-SECTIONB_EXT-SP_LOL">
		<asp:Label ID="lblSECTIONB_EXT_SP_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__SP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__SP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_SP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.SP_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__SP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label279">
		<span class="label" id="label279"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label280">
		<span class="label" id="label280"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_PF" for="ctl00_cntMainBody_SECTIONB_EXT__IS_PF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_PF" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_PF">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_PF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_PF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_PF"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_PF" 
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
	<span id="pb-container-label-label281">
		<span class="label" id="label281">Professional Fees</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="PF_LOL" 
		id="pb-container-currency-SECTIONB_EXT-PF_LOL">
		<asp:Label ID="lblSECTIONB_EXT_PF_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__PF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__PF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_PF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.PF_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__PF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label282">
		<span class="label" id="label282"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label283">
		<span class="label" id="label283"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_UE" for="ctl00_cntMainBody_SECTIONB_EXT__IS_UE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_UE" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_UE">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_UE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_UE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_UE"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_UE" 
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
	<span id="pb-container-label-label284">
		<span class="label" id="label284">Undamaged Equipment</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="UE_LOL" 
		id="pb-container-currency-SECTIONB_EXT-UE_LOL">
		<asp:Label ID="lblSECTIONB_EXT_UE_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__UE_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__UE_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_UE_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.UE_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__UE_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label285">
		<span class="label" id="label285"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label286">
		<span class="label" id="label286"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_ILH" for="ctl00_cntMainBody_SECTIONB_EXT__IS_ILH" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_ILH" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_ILH">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_ILH" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_ILH" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_ILH"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_ILH" 
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
	<span id="pb-container-label-label287">
		<span class="label" id="label287">Increased Leasing / Hire Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="ILH_LOL" 
		id="pb-container-currency-SECTIONB_EXT-ILH_LOL">
		<asp:Label ID="lblSECTIONB_EXT_ILH_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__ILH_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__ILH_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_ILH_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.ILH_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__ILH_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label288">
		<span class="label" id="label288"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label289">
		<span class="label" id="label289"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_LOC" for="ctl00_cntMainBody_SECTIONB_EXT__IS_LOC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_LOC" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_LOC">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_LOC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_LOC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_LOC"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_LOC" 
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
	<span id="pb-container-label-label290">
		<span class="label" id="label290">Loss of Contents of Tanks / Storage Vessels</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="LOC_LOL" 
		id="pb-container-currency-SECTIONB_EXT-LOC_LOL">
		<asp:Label ID="lblSECTIONB_EXT_LOC_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__LOC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__LOC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_LOC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.LOC_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__LOC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label291">
		<span class="label" id="label291"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label292">
		<span class="label" id="label292"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_RD" for="ctl00_cntMainBody_SECTIONB_EXT__IS_RD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_RD" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_RD">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_RD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_RD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_RD"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_RD" 
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
	<span id="pb-container-label-label293">
		<span class="label" id="label293">Reconstitution of Data</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="RD_LOL" 
		id="pb-container-currency-SECTIONB_EXT-RD_LOL">
		<asp:Label ID="lblSECTIONB_EXT_RD_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__RD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__RD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_RD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.RD_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__RD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label294">
		<span class="label" id="label294"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label295">
		<span class="label" id="label295"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_INC" for="ctl00_cntMainBody_SECTIONB_EXT__IS_INC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_INC" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_INC">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_INC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_INC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_INC"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_INC" 
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
	<span id="pb-container-label-label296">
		<span class="label" id="label296">Incompatibility</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="INC_LOL" 
		id="pb-container-currency-SECTIONB_EXT-INC_LOL">
		<asp:Label ID="lblSECTIONB_EXT_INC_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__INC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__INC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_INC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.INC_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__INC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label297">
		<span class="label" id="label297"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label298">
		<span class="label" id="label298"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_TRP" for="ctl00_cntMainBody_SECTIONB_EXT__IS_TRP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_TRP" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_TRP">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_TRP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_TRP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_TRP"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_TRP" 
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
	<span id="pb-container-label-label299">
		<span class="label" id="label299">Temporary Replacement Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="TRP_LOL" 
		id="pb-container-currency-SECTIONB_EXT-TRP_LOL">
		<asp:Label ID="lblSECTIONB_EXT_TRP_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__TRP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__TRP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_TRP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.TRP_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__TRP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label300">
		<span class="label" id="label300"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label301">
		<span class="label" id="label301"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_SPD" for="ctl00_cntMainBody_SECTIONB_EXT__IS_SPD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_SPD" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_SPD">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_SPD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_SPD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_SPD"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_SPD" 
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
	<span id="pb-container-label-label302">
		<span class="label" id="label302">Surrounding Property Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="SPD_LOL" 
		id="pb-container-currency-SECTIONB_EXT-SPD_LOL">
		<asp:Label ID="lblSECTIONB_EXT_SPD_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__SPD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__SPD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_SPD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.SPD_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__SPD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label303">
		<span class="label" id="label303"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label304">
		<span class="label" id="label304"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_PSF" for="ctl00_cntMainBody_SECTIONB_EXT__IS_PSF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_PSF" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_PSF">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_PSF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_PSF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_PSF"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_PSF" 
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
	<span id="pb-container-label-label305">
		<span class="label" id="label305">Plans Scrutiny Fees</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="PSF_LOL" 
		id="pb-container-currency-SECTIONB_EXT-PSF_LOL">
		<asp:Label ID="lblSECTIONB_EXT_PSF_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__PSF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__PSF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_PSF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.PSF_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__PSF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label306">
		<span class="label" id="label306"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label307">
		<span class="label" id="label307"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_DRP" for="ctl00_cntMainBody_SECTIONB_EXT__IS_DRP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_DRP" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_DRP">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_DRP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_DRP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_DRP"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_DRP" 
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
	<span id="pb-container-label-label308">
		<span class="label" id="label308">Deterioration of Refrigerated Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="DRP_LOL" 
		id="pb-container-currency-SECTIONB_EXT-DRP_LOL">
		<asp:Label ID="lblSECTIONB_EXT_DRP_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__DRP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__DRP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_DRP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.DRP_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__DRP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label309">
		<span class="label" id="label309"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label310">
		<span class="label" id="label310"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_EXT_IS_SMG" for="ctl00_cntMainBody_SECTIONB_EXT__IS_SMG" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="IS_SMG" 
		id="pb-container-checkbox-SECTIONB_EXT-IS_SMG">	
		
		<asp:TextBox ID="SECTIONB_EXT__IS_SMG" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_EXT_IS_SMG" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.IS_SMG"
			ClientValidationFunction="onValidate_SECTIONB_EXT__IS_SMG" 
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
	<span id="pb-container-label-label311">
		<span class="label" id="label311">Supplier's or Manufacturers' Guarantee or Warranty</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="SMG_LOL" 
		id="pb-container-currency-SECTIONB_EXT-SMG_LOL">
		<asp:Label ID="lblSECTIONB_EXT_SMG_LOL" runat="server" AssociatedControlID="SECTIONB_EXT__SMG_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_EXT__SMG_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_EXT_SMG_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.SMG_LOL"
			ClientValidationFunction="onValidate_SECTIONB_EXT__SMG_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label312">
		<span class="label" id="label312"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label313">
		<span class="label" id="label313"></span>
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
		if ($("#id1089a2bf7f644d02ac7d370c227e7888 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id1089a2bf7f644d02ac7d370c227e7888 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id1089a2bf7f644d02ac7d370c227e7888 div ul li").each(function(){		  
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
			$("#id1089a2bf7f644d02ac7d370c227e7888 div ul li").each(function(){		  
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
		styleString += "#id1089a2bf7f644d02ac7d370c227e7888 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id1089a2bf7f644d02ac7d370c227e7888 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id1089a2bf7f644d02ac7d370c227e7888 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id1089a2bf7f644d02ac7d370c227e7888 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id1089a2bf7f644d02ac7d370c227e7888 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id1089a2bf7f644d02ac7d370c227e7888 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id1089a2bf7f644d02ac7d370c227e7888 input{text-align:left;}"; break;
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
<div id="Other Extensions" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading65" runat="server" Text="Other Extensions" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONB_EXT__ENGOTEXT"
		data-field-type="Child" 
		data-object-name="SECTIONB_EXT" 
		data-property-name="ENGOTEXT" 
		id="pb-container-childscreen-SECTIONB_EXT-ENGOTEXT">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONB_EXT__OTH_ENG_EXT" runat="server" ScreenCode="ENGOTEXT" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ENGOTEXT/ENGOTEXT_Other_Engineering_Extensions.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONB_EXT_ENGOTEXT" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONB_EXT.ENGOTEXT"
						ClientValidationFunction="onValidate_SECTIONB_EXT__ENGOTEXT" 
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
		data-object-name="SECTIONB_EXT" 
		data-property-name="ENGOTEXT_CNT" 
		id="pb-container-integer-SECTIONB_EXT-ENGOTEXT_CNT">
		<asp:Label ID="lblSECTIONB_EXT_ENGOTEXT_CNT" runat="server" AssociatedControlID="SECTIONB_EXT__ENGOTEXT_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONB_EXT__ENGOTEXT_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONB_EXT_ENGOTEXT_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_EXT.ENGOTEXT_CNT"
			ClientValidationFunction="onValidate_SECTIONB_EXT__ENGOTEXT_CNT" 
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
		if ($("#Other Extensions div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Other Extensions div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Other Extensions div ul li").each(function(){		  
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
			$("#Other Extensions div ul li").each(function(){		  
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
		styleString += "#Other Extensions label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Other Extensions label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Extensions label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Extensions label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Other Extensions input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Extensions input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Extensions input{text-align:left;}"; break;
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
<div id="id60d3365e8d3a43ccbff27c30cc334116" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading66" runat="server" Text="Engineering Deductibles " /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label314">
		<span class="label" id="label314"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label315">
		<span class="label" id="label315"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label316">
		<span class="label" id="label316">Ded %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label317">
		<span class="label" id="label317">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label318">
		<span class="label" id="label318">Maximum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label319">
		<span class="label" id="label319"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label320">
		<span class="label" id="label320">Machinery Breakdown as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label321">
		<span class="label" id="label321"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label322">
		<span class="label" id="label322"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label323">
		<span class="label" id="label323"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label324">
		<span class="label" id="label324"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_DED_IS_MB" for="ctl00_cntMainBody_SECTIONB_DED__IS_MB" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_DED" 
		data-property-name="IS_MB" 
		id="pb-container-checkbox-SECTIONB_DED-IS_MB">	
		
		<asp:TextBox ID="SECTIONB_DED__IS_MB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_DED_IS_MB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.IS_MB"
			ClientValidationFunction="onValidate_SECTIONB_DED__IS_MB" 
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
	<span id="pb-container-label-label325">
		<span class="label" id="label325">Mechanical Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONB_DED" 
		data-property-name="MB_DED" 
		id="pb-container-percentage-SECTIONB_DED-MB_DED">
		<asp:Label ID="lblSECTIONB_DED_MB_DED" runat="server" AssociatedControlID="SECTIONB_DED__MB_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONB_DED__MB_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONB_DED_MB_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.MB_DED"
			ClientValidationFunction="onValidate_SECTIONB_DED__MB_DED" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="MB_MIN" 
		id="pb-container-currency-SECTIONB_DED-MB_MIN">
		<asp:Label ID="lblSECTIONB_DED_MB_MIN" runat="server" AssociatedControlID="SECTIONB_DED__MB_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__MB_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_MB_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.MB_MIN"
			ClientValidationFunction="onValidate_SECTIONB_DED__MB_MIN" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="MB_MAX" 
		id="pb-container-currency-SECTIONB_DED-MB_MAX">
		<asp:Label ID="lblSECTIONB_DED_MB_MAX" runat="server" AssociatedControlID="SECTIONB_DED__MB_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__MB_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_MB_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.MB_MAX"
			ClientValidationFunction="onValidate_SECTIONB_DED__MB_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label326">
		<span class="label" id="label326"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label327">
		<span class="label" id="label327">Electronic Equipment as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label328">
		<span class="label" id="label328"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label329">
		<span class="label" id="label329"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label330">
		<span class="label" id="label330"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label331">
		<span class="label" id="label331"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label332">
		<span class="label" id="label332">Electrical and Mechanical Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label333">
		<span class="label" id="label333"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label334">
		<span class="label" id="label334"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label335">
		<span class="label" id="label335"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONB_DED_IS_BBI" for="ctl00_cntMainBody_SECTIONB_DED__IS_BBI" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_DED" 
		data-property-name="IS_BBI" 
		id="pb-container-checkbox-SECTIONB_DED-IS_BBI">	
		
		<asp:TextBox ID="SECTIONB_DED__IS_BBI" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_DED_IS_BBI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.IS_BBI"
			ClientValidationFunction="onValidate_SECTIONB_DED__IS_BBI" 
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
	<span id="pb-container-label-label336">
		<span class="label" id="label336">Basic (combined with Business Interruption)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONB_DED" 
		data-property-name="BBI_DED" 
		id="pb-container-percentage-SECTIONB_DED-BBI_DED">
		<asp:Label ID="lblSECTIONB_DED_BBI_DED" runat="server" AssociatedControlID="SECTIONB_DED__BBI_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONB_DED__BBI_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONB_DED_BBI_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.BBI_DED"
			ClientValidationFunction="onValidate_SECTIONB_DED__BBI_DED" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="BBI_MIN" 
		id="pb-container-currency-SECTIONB_DED-BBI_MIN">
		<asp:Label ID="lblSECTIONB_DED_BBI_MIN" runat="server" AssociatedControlID="SECTIONB_DED__BBI_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__BBI_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_BBI_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.BBI_MIN"
			ClientValidationFunction="onValidate_SECTIONB_DED__BBI_MIN" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="BBI_MAX" 
		id="pb-container-currency-SECTIONB_DED-BBI_MAX">
		<asp:Label ID="lblSECTIONB_DED_BBI_MAX" runat="server" AssociatedControlID="SECTIONB_DED__BBI_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__BBI_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_BBI_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.BBI_MAX"
			ClientValidationFunction="onValidate_SECTIONB_DED__BBI_MAX" 
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
<label id="ctl00_cntMainBody_lblSECTIONB_DED_IS_PORT" for="ctl00_cntMainBody_SECTIONB_DED__IS_PORT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONB_DED" 
		data-property-name="IS_PORT" 
		id="pb-container-checkbox-SECTIONB_DED-IS_PORT">	
		
		<asp:TextBox ID="SECTIONB_DED__IS_PORT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONB_DED_IS_PORT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.IS_PORT"
			ClientValidationFunction="onValidate_SECTIONB_DED__IS_PORT" 
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
	<span id="pb-container-label-label337">
		<span class="label" id="label337">Portable</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONB_DED" 
		data-property-name="PORT_DED" 
		id="pb-container-percentage-SECTIONB_DED-PORT_DED">
		<asp:Label ID="lblSECTIONB_DED_PORT_DED" runat="server" AssociatedControlID="SECTIONB_DED__PORT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONB_DED__PORT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONB_DED_PORT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.PORT_DED"
			ClientValidationFunction="onValidate_SECTIONB_DED__PORT_DED" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="PORT_MIN" 
		id="pb-container-currency-SECTIONB_DED-PORT_MIN">
		<asp:Label ID="lblSECTIONB_DED_PORT_MIN" runat="server" AssociatedControlID="SECTIONB_DED__PORT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__PORT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_PORT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.PORT_MIN"
			ClientValidationFunction="onValidate_SECTIONB_DED__PORT_MIN" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="PORT_MAX" 
		id="pb-container-currency-SECTIONB_DED-PORT_MAX">
		<asp:Label ID="lblSECTIONB_DED_PORT_MAX" runat="server" AssociatedControlID="SECTIONB_DED__PORT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB_DED__PORT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_DED_PORT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.PORT_MAX"
			ClientValidationFunction="onValidate_SECTIONB_DED__PORT_MAX" 
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
		if ($("#id60d3365e8d3a43ccbff27c30cc334116 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id60d3365e8d3a43ccbff27c30cc334116 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id60d3365e8d3a43ccbff27c30cc334116 div ul li").each(function(){		  
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
			$("#id60d3365e8d3a43ccbff27c30cc334116 div ul li").each(function(){		  
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
		styleString += "#id60d3365e8d3a43ccbff27c30cc334116 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id60d3365e8d3a43ccbff27c30cc334116 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id60d3365e8d3a43ccbff27c30cc334116 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id60d3365e8d3a43ccbff27c30cc334116 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id60d3365e8d3a43ccbff27c30cc334116 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id60d3365e8d3a43ccbff27c30cc334116 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id60d3365e8d3a43ccbff27c30cc334116 input{text-align:left;}"; break;
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
<div id="idf9e456bfccfb4d288825d1d8275eeb2f" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading67" runat="server" Text="Other Engineering Deductibles" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONB_DED__ENGOTPDED"
		data-field-type="Child" 
		data-object-name="SECTIONB_DED" 
		data-property-name="ENGOTPDED" 
		id="pb-container-childscreen-SECTIONB_DED-ENGOTPDED">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONB_DED__OTH_ENG_DED" runat="server" ScreenCode="ENGOTPDED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ENGOTPDED/ENGOTPDED_Other_Engineering_Deductibles.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONB_DED_ENGOTPDED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONB_DED.ENGOTPDED"
						ClientValidationFunction="onValidate_SECTIONB_DED__ENGOTPDED" 
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
		data-object-name="SECTIONB_DED" 
		data-property-name="ENGOTPDED_CNT" 
		id="pb-container-integer-SECTIONB_DED-ENGOTPDED_CNT">
		<asp:Label ID="lblSECTIONB_DED_ENGOTPDED_CNT" runat="server" AssociatedControlID="SECTIONB_DED__ENGOTPDED_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONB_DED__ENGOTPDED_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONB_DED_ENGOTPDED_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB_DED.ENGOTPDED_CNT"
			ClientValidationFunction="onValidate_SECTIONB_DED__ENGOTPDED_CNT" 
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
		if ($("#idf9e456bfccfb4d288825d1d8275eeb2f div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf9e456bfccfb4d288825d1d8275eeb2f div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf9e456bfccfb4d288825d1d8275eeb2f div ul li").each(function(){		  
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
			$("#idf9e456bfccfb4d288825d1d8275eeb2f div ul li").each(function(){		  
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
		styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf9e456bfccfb4d288825d1d8275eeb2f input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading68" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblSECTIONB_SECTIONB_CLAUSES" runat="server" AssociatedControlID="SECTIONB__SECTIONB_CLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="SECTIONB__SECTIONB_CLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONB" 
		data-property-name="SECTIONB_COUNT" 
		id="pb-container-integer-SECTIONB-SECTIONB_COUNT">
		<asp:Label ID="lblSECTIONB_SECTIONB_COUNT" runat="server" AssociatedControlID="SECTIONB__SECTIONB_COUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONB__SECTIONB_COUNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONB_SECTIONB_COUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.SECTIONB_COUNT"
			ClientValidationFunction="onValidate_SECTIONB__SECTIONB_COUNT" 
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
		data-object-name="SECTIONB" 
		data-property-name="ENDORSE_PREMIUM" 
		id="pb-container-currency-SECTIONB-ENDORSE_PREMIUM">
		<asp:Label ID="lblSECTIONB_ENDORSE_PREMIUM" runat="server" AssociatedControlID="SECTIONB__ENDORSE_PREMIUM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONB__ENDORSE_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONB_ENDORSE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_SECTIONB__ENDORSE_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONB__ENGPEND"
		data-field-type="Child" 
		data-object-name="SECTIONB" 
		data-property-name="ENGPEND" 
		id="pb-container-childscreen-SECTIONB-ENGPEND">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONB__SECTIONB_CLAUSEPREM" runat="server" ScreenCode="ENGPEND" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ENGPEND/ENGPEND_Endorsement_Premium.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONB_ENGPEND" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONB.ENGPEND"
						ClientValidationFunction="onValidate_SECTIONB__ENGPEND" 
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
<div id="id4be404fc3f1143b98bab5f4255897861" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading69" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONB__ENGNOTE"
		data-field-type="Child" 
		data-object-name="SECTIONB" 
		data-property-name="ENGNOTE" 
		id="pb-container-childscreen-SECTIONB-ENGNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONB__SECB_DETAILS" runat="server" ScreenCode="ENGNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ENGNOTE/ENGNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONB_ENGNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONB.ENGNOTE"
						ClientValidationFunction="onValidate_SECTIONB__ENGNOTE" 
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
		if ($("#id4be404fc3f1143b98bab5f4255897861 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4be404fc3f1143b98bab5f4255897861 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4be404fc3f1143b98bab5f4255897861 div ul li").each(function(){		  
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
			$("#id4be404fc3f1143b98bab5f4255897861 div ul li").each(function(){		  
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
		styleString += "#id4be404fc3f1143b98bab5f4255897861 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4be404fc3f1143b98bab5f4255897861 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4be404fc3f1143b98bab5f4255897861 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4be404fc3f1143b98bab5f4255897861 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4be404fc3f1143b98bab5f4255897861 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4be404fc3f1143b98bab5f4255897861 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4be404fc3f1143b98bab5f4255897861 input{text-align:left;}"; break;
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
<div id="id2c9b3f56ed364010b90794a9710d7727" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading70" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONB__ENGSNOTE"
		data-field-type="Child" 
		data-object-name="SECTIONB" 
		data-property-name="ENGSNOTE" 
		id="pb-container-childscreen-SECTIONB-ENGSNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONB__SECBS_DETAILS" runat="server" ScreenCode="ENGSNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ENGSNOTE/ENGSNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONB_ENGSNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONB.ENGSNOTE"
						ClientValidationFunction="onValidate_SECTIONB__ENGSNOTE" 
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
		data-object-name="SECTIONB" 
		data-property-name="ENGSNOTE_CNT" 
		id="pb-container-integer-SECTIONB-ENGSNOTE_CNT">
		<asp:Label ID="lblSECTIONB_ENGSNOTE_CNT" runat="server" AssociatedControlID="SECTIONB__ENGSNOTE_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONB__ENGSNOTE_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONB_ENGSNOTE_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONB.ENGSNOTE_CNT"
			ClientValidationFunction="onValidate_SECTIONB__ENGSNOTE_CNT" 
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
		if ($("#id2c9b3f56ed364010b90794a9710d7727 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id2c9b3f56ed364010b90794a9710d7727 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id2c9b3f56ed364010b90794a9710d7727 div ul li").each(function(){		  
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
			$("#id2c9b3f56ed364010b90794a9710d7727 div ul li").each(function(){		  
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
		styleString += "#id2c9b3f56ed364010b90794a9710d7727 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id2c9b3f56ed364010b90794a9710d7727 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2c9b3f56ed364010b90794a9710d7727 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2c9b3f56ed364010b90794a9710d7727 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id2c9b3f56ed364010b90794a9710d7727 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2c9b3f56ed364010b90794a9710d7727 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2c9b3f56ed364010b90794a9710d7727 input{text-align:left;}"; break;
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