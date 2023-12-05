<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CML_Stevedore_Liability.aspx.vb" Inherits="Nexus.PB2_CML_Stevedore_Liability" %>

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
        
        
        window.Colours = {};
        window.Colours.SetTextColour = function(field, colour, condition, elseColour){
        	var element = field.getElement();
        	var update = function(){		
        		var useColour;
        		if (condition == null)
        		{
        			useColour = colour;
        		} else if (condition.getValue() == true) {
        			useColour = colour;
        		} else if (elseColour != null){
        			useColour = elseColour || "inherit";
        		}
        		
        		useColour = window.Colours.stripSingleQuotes(useColour);
        		
        		if (field.setColour){
        			field.setColour(useColour);
        			return;
        		}
        		
        		element.style.color = useColour;
        		// Need to update the fake input too
        		if (window.Formatting){
        			var fake = window.Formatting.getFakeInput(element);
        			if (fake != null)
        				fake.style.color = useColour;
        		}
        	}
        	
        	update();
        	if (condition != null)
        		events.listen(condition, "change", update, false, this);
        };
        window.Colours.SetBackgroundColour = function(field, colour, condition, elseColour){
        
        	
        
        	var element = field.getElement();
        	var update = function(){		
        		var useColour;
        		if (condition == null)
        		{
        			useColour = colour;
        		} else if (condition.getValue() == true) {
        			useColour = colour;
        		} else if (elseColour != null){
        			useColour = elseColour || "inherit";
        		}
        		
        		
        		useColour = window.Colours.stripSingleQuotes(useColour);
        		
        		if (field.setBackgroundColour){
        			field.setBackgroundColour(useColour);
        			return;
        		}
        		
        		element.style.backgroundColor = useColour;
        		// Need to update the fake input too
        		if (window.Formatting){
        			var fake = window.Formatting.getFakeInput(element);
        			if (fake != null)
        				fake.style.backgroundColor = useColour;
        		}
        	}
        	
        	update();
        	if (condition != null)
        		events.listen(condition, "change", update, false, this);
        		
        };
        
        window.Colours.stripSingleQuotes = function(value){
        	if (value.slice(0,1) == "'" && value.slice(-1) == "'")
        		value = value.slice(1, -1);
        	return value;
        };
function onValidate_STEVEDORE__SLLOI(source, args, sender, isOnLoad) {
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
        			field = Field.getInstance("STEVEDORE", "SLLOI");
        		}
        		//window.setProperty(field, "VE", "{1}", "{2}", "{3}");
        
            var paramValue = "VE",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLLOI");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLLOI');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLLOI_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLLOI");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLLOI");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLLOI');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLLOI", "Currency");
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
        			field = Field.getInstance("STEVEDORE", "SLLOI");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLLOI");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLLOI');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLLOI_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLLOI");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLLOI");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("STEVEDORE", "SLLOI");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLLOI');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
}
function onValidate_STEVEDORE__SLPB(source, args, sender, isOnLoad) {
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
        			field = Field.getInstance("STEVEDORE", "SLPB");
        		}
        		//window.setProperty(field, "VE", "{1}", "{2}", "{3}");
        
            var paramValue = "VE",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLPB");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLPB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLPB_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLPB");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLPB");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLPB');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLPB", "Currency");
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
        			field = Field.getInstance("STEVEDORE", "SLPB");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLPB");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLPB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLPB_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLPB");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLPB");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("STEVEDORE", "SLPB");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLPB');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
}
function onValidate_STEVEDORE__SLBV(source, args, sender, isOnLoad) {
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
        			field = Field.getInstance("STEVEDORE", "SLBV");
        		}
        		//window.setProperty(field, "VE", "{1}", "{2}", "{3}");
        
            var paramValue = "VE",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLBV");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLBV');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLBV_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLBV");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLBV");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLBV');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLBV", "Currency");
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
        			field = Field.getInstance("STEVEDORE", "SLBV");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLBV");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLBV');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLBV_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLBV");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLBV");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("STEVEDORE", "SLBV");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLBV');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
}
function onValidate_STEVEDORE__SLR(source, args, sender, isOnLoad) {
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
        			field = Field.getInstance("STEVEDORE", "SLR");
        		}
        		//window.setProperty(field, "VE", "{1}", "{2}", "{3}");
        
            var paramValue = "VE",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLR");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLR_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLR");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLR");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLR');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLR", "Percentage");
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
        			field = Field.getInstance("STEVEDORE", "SLR");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLR");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLR_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLR");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLR");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("STEVEDORE", "SLR");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLR');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
}
function onValidate_STEVEDORE__SLP(source, args, sender, isOnLoad) {
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
        			field = Field.getInstance("STEVEDORE", "SLP");
        		}
        		//window.setProperty(field, "VE", "{1}", "{2}", "{3}");
        
            var paramValue = "VE",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLP");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLP');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLP_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLP");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLP");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLP');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLP", "Currency");
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
        			field = Field.getInstance("STEVEDORE", "SLP");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
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
        
        			var width = window.parseFloat("1.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSTEVEDORE_SLP");
        			    var ele = document.getElementById('ctl00_cntMainBody_STEVEDORE__SLP');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_STEVEDORE__SLP_lblFindParty");
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
              var field = Field.getInstance("STEVEDORE.SLP");
        			window.setControlWidth(field, "1.8", "STEVEDORE", "SLP");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("STEVEDORE", "SLP");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('STEVEDORE', 'SLP');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
}
function onValidate_STEVEDORE__SLEXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLEXT", "ChildScreen");
        })();
}
function onValidate_STEVEDORE__SLDEDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "STEVEDORE", "SLDEDED", "ChildScreen");
        })();
}
function onValidate_SL_REFERRAL_CLAUSES__TOT_END_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SL_REFERRAL_CLAUSES", "TOT_END_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SL_REFERRAL_CLAUSES", "TOT_END_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblSL_REFERRAL_CLAUSES_TOT_END_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_SL_REFERRAL_CLAUSES__TOT_END_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SL_REFERRAL_CLAUSES__TOT_END_PREM_lblFindParty");
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
              var field = Field.getInstance("SL_REFERRAL_CLAUSES.TOT_END_PREM");
        			window.setControlWidth(field, "0.3", "SL_REFERRAL_CLAUSES", "TOT_END_PREM");
        		})();
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("SL_REFERRAL_CLAUSES", "TOT_END_PREM");
        		
        		
        		if (field.setFormatPattern 
        			// For now only use this on text fields as we do not want to override working behaviour of 
        			// integer, currency and percentage fields.
        			&& (field.getType() == "text" 
        				// Date fields implement setFormatPattern
        				|| field.getType() == "datejquerycompatible"))	{
        			var optionalInputPatterns = Expression.isValidParameter("{1}") ? "{1}" : undefined;
        			if (optionalInputPatterns && "{1}".slice(0,1) == "["){
        				// If input patterns is an expression array
        				optionalInputPatterns = (new Expression("{1}")).valueOf();
        			}
        			return field.setFormatPattern("##,###,###,###", optionalInputPatterns);
        		}
        		
        		// Below are other methods for compatibility
        		
        		if (! window.Formatting)
        			return;
        			
        			
        		var formatter;
        		if (field.getFormatterInput){
        			// This method was added in so we can use with the specific 
        			// currency format input.
        			formatter = window.Formatting.getInstance(field.getFormatterInput());
        		} else if (field.getInput){
        			// This method was added in so we can still use this rule
        			// with the new field components.
        			formatter = window.Formatting.getInstance(field.getInput());
        		} else {
        			formatter = window.Formatting.getInstance(field.getElement());
        		}
        		if (formatter != null){
        			formatter.setCustomFormatPattern("##,###,###,###");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('SL_REFERRAL_CLAUSES', 'TOT_END_PREM');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("Right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("Right".toLowerCase()){
        				case "right": textAlign = "right";break;
        				case "centre":
        				case "center":
        				case "middle": textAlign = "center";break;
        				case "left": 
        				default: textAlign = "left";break;
        			}
        			
        			field.getInput().style.textAlign = textAlign;
        			// Quick workaround until field exposes a method to get
        			// the display input or to set the alignment.
        			if (field.displayInput){
        				field.displayInput.style.textAlign = textAlign;
        			}
        			
        		}, 4);
        	}
        })();
        
         /**
          * @fileoverview GetColumn
          * @param THEFT_REFERRAL_CLAUSES The Parent (Root) object name.
          * @param THEFT_CLAUSEPREM.PREMIUM The object.property to sum the totals of.
          * @param TOTAL The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "THEFT_REFERRAL_CLAUSES".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "THEFT_CLAUSEPREM.PREMIUM";
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
        		
        		var field = Field.getInstance("SL_REFERRAL_CLAUSES", "TOT_END_PREM");
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
        			
        			var field = Field.getInstance("SL_REFERRAL_CLAUSES", "TOT_END_PREM");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SL_REFERRAL_SLAUSES__SLEND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SL_REFERRAL_SLAUSES", "SLEND", "ChildScreen");
        })();
}
function onValidate_SL_NOTES__SLNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SL_NOTES", "SLNOTE", "ChildScreen");
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
        		var field = Field.getInstance("SL_NOTES", "SLNOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SL_NOTES__SLNOTE table td a");
        				
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
        		var field = Field.getInstance("SL_NOTES", "SLNOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'SL_NOTES' and property 'SLNOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SL_NOTES__SLNOTE table td a");
        				
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
function onValidate_SL_NOTES__SLPNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SL_NOTES", "SLPNOTE", "ChildScreen");
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
        		var field = Field.getInstance("SL_NOTES", "SLPNOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SL_NOTES__SLPNOTE table td a");
        				
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
        		var field = Field.getInstance("SL_NOTES", "SLPNOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'SL_NOTES' and property 'SLPNOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SL_NOTES__SLPNOTE table td a");
        				
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
function onValidate_SLEMPDE__BASE_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SLEMPDE", "BASE_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SLEMPDE", "BASE_PREM");
        	field.setReadOnly(true);
        })();
}
function onValidate_SLEMPDE__EXT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SLEMPDE", "EXT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SLEMPDE", "EXT_PREM");
        	field.setReadOnly(true);
        })();
}
function onValidate_SLEMPDE__END_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SLEMPDE", "END_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SLEMPDE", "END_PREM");
        	field.setReadOnly(true);
        })();
}
function onValidate_SLEMPDE__TOT_RISK_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SLEMPDE", "TOT_RISK_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SLEMPDE", "TOT_RISK_PREM");
        	field.setReadOnly(true);
        })();
}
function DoLogic(isOnLoad) {
    onValidate_STEVEDORE__SLLOI(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLPB(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLBV(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLR(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLP(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLEXT(null, null, null, isOnLoad);
    onValidate_STEVEDORE__SLDEDED(null, null, null, isOnLoad);
    onValidate_SL_REFERRAL_CLAUSES__TOT_END_PREM(null, null, null, isOnLoad);
    onValidate_SL_REFERRAL_SLAUSES__SLEND(null, null, null, isOnLoad);
    onValidate_SL_NOTES__SLNOTE(null, null, null, isOnLoad);
    onValidate_SL_NOTES__SLPNOTE(null, null, null, isOnLoad);
    onValidate_SLEMPDE__BASE_PREM(null, null, null, isOnLoad);
    onValidate_SLEMPDE__EXT_PREM(null, null, null, isOnLoad);
    onValidate_SLEMPDE__END_PREM(null, null, null, isOnLoad);
    onValidate_SLEMPDE__TOT_RISK_PREM(null, null, null, isOnLoad);
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
<div id="id58f6aa18cc7e45afb604b482b98f7acf" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idf0a00e771b7841fc9c26c8f5eadaf731" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading134" runat="server" Text="Premium Computation Details" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="20:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label31">
		<span class="label" id="label31">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label32">
		<span class="label" id="label32">Premium Basis</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label33">
		<span class="label" id="label33">Base Value</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label34">
		<span class="label" id="label34">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label35">
		<span class="label" id="label35">Premium  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="STEVEDORE" 
		data-property-name="SLLOI" 
		id="pb-container-currency-STEVEDORE-SLLOI">
		<asp:Label ID="lblSTEVEDORE_SLLOI" runat="server" AssociatedControlID="STEVEDORE__SLLOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="STEVEDORE__SLLOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSTEVEDORE_SLLOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for STEVEDORE.SLLOI"
			ClientValidationFunction="onValidate_STEVEDORE__SLLOI" 
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
		data-object-name="STEVEDORE" 
		data-property-name="SLPB" 
		id="pb-container-currency-STEVEDORE-SLPB">
		<asp:Label ID="lblSTEVEDORE_SLPB" runat="server" AssociatedControlID="STEVEDORE__SLPB" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="STEVEDORE__SLPB" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSTEVEDORE_SLPB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for STEVEDORE.SLPB"
			ClientValidationFunction="onValidate_STEVEDORE__SLPB" 
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
		data-object-name="STEVEDORE" 
		data-property-name="SLBV" 
		id="pb-container-currency-STEVEDORE-SLBV">
		<asp:Label ID="lblSTEVEDORE_SLBV" runat="server" AssociatedControlID="STEVEDORE__SLBV" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="STEVEDORE__SLBV" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSTEVEDORE_SLBV" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for STEVEDORE.SLBV"
			ClientValidationFunction="onValidate_STEVEDORE__SLBV" 
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
		data-object-name="STEVEDORE" 
		data-property-name="SLR" 
		id="pb-container-percentage-STEVEDORE-SLR">
		<asp:Label ID="lblSTEVEDORE_SLR" runat="server" AssociatedControlID="STEVEDORE__SLR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="STEVEDORE__SLR" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSTEVEDORE_SLR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for STEVEDORE.SLR"
			ClientValidationFunction="onValidate_STEVEDORE__SLR" 
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
		data-object-name="STEVEDORE" 
		data-property-name="SLP" 
		id="pb-container-currency-STEVEDORE-SLP">
		<asp:Label ID="lblSTEVEDORE_SLP" runat="server" AssociatedControlID="STEVEDORE__SLP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="STEVEDORE__SLP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSTEVEDORE_SLP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for STEVEDORE.SLP"
			ClientValidationFunction="onValidate_STEVEDORE__SLP" 
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
		if ($("#idf0a00e771b7841fc9c26c8f5eadaf731 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf0a00e771b7841fc9c26c8f5eadaf731 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf0a00e771b7841fc9c26c8f5eadaf731 div ul li").each(function(){		  
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
			$("#idf0a00e771b7841fc9c26c8f5eadaf731 div ul li").each(function(){		  
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
		styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf0a00e771b7841fc9c26c8f5eadaf731 input{text-align:left;}"; break;
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
<div id="id8948059c1daa4f4699cb14a869ec1f2b" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading135" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_STEVEDORE__SLEXT"
		data-field-type="Child" 
		data-object-name="STEVEDORE" 
		data-property-name="SLEXT" 
		id="pb-container-childscreen-STEVEDORE-SLEXT">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="STEVEDORE__SLEXT" runat="server" ScreenCode="SLEXT" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SLEXT/SLEXT_Extensions.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="SLDES" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Limit Of Indemnity" DataField="SLLOI" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Rate" DataField="SLR" DataFormatString="{0:0}%"/>
<Nexus:RiskAttribute HeaderText="Premium" DataField="SLP" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valSTEVEDORE_SLEXT" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for STEVEDORE.SLEXT"
						ClientValidationFunction="onValidate_STEVEDORE__SLEXT" 
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
		if ($("#id8948059c1daa4f4699cb14a869ec1f2b div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id8948059c1daa4f4699cb14a869ec1f2b div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id8948059c1daa4f4699cb14a869ec1f2b div ul li").each(function(){		  
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
			$("#id8948059c1daa4f4699cb14a869ec1f2b div ul li").each(function(){		  
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
		styleString += "#id8948059c1daa4f4699cb14a869ec1f2b label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id8948059c1daa4f4699cb14a869ec1f2b label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8948059c1daa4f4699cb14a869ec1f2b label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8948059c1daa4f4699cb14a869ec1f2b label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id8948059c1daa4f4699cb14a869ec1f2b input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8948059c1daa4f4699cb14a869ec1f2b input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8948059c1daa4f4699cb14a869ec1f2b input{text-align:left;}"; break;
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
<div id="idf906d14a23c34276a792eb4bd4fd87f3" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading136" runat="server" Text="Deductibles" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_STEVEDORE__SLDEDED"
		data-field-type="Child" 
		data-object-name="STEVEDORE" 
		data-property-name="SLDEDED" 
		id="pb-container-childscreen-STEVEDORE-SLDEDED">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="STEVEDORE__SLDEDUCT" runat="server" ScreenCode="SLDEDED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SLDEDED/SLDEDED_Deductibles.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="SLDDES" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Deductible %" DataField="SLP" DataFormatString="{0:0}%"/>
<Nexus:RiskAttribute HeaderText="Deductible Min Amount" DataField="SLMIN" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Deductible Max Amount" DataField="SLMAX" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Basis of Deductible" DataField="SLBOE" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valSTEVEDORE_SLDEDED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for STEVEDORE.SLDEDED"
						ClientValidationFunction="onValidate_STEVEDORE__SLDEDED" 
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
		if ($("#idf906d14a23c34276a792eb4bd4fd87f3 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf906d14a23c34276a792eb4bd4fd87f3 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf906d14a23c34276a792eb4bd4fd87f3 div ul li").each(function(){		  
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
			$("#idf906d14a23c34276a792eb4bd4fd87f3 div ul li").each(function(){		  
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
		styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf906d14a23c34276a792eb4bd4fd87f3 input{text-align:left;}"; break;
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
<div id="frmPRLauses" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading137" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblSL_REFERRAL_CLAUSES_REFERRAL_PRLAUSES" runat="server" AssociatedControlID="SL_REFERRAL_CLAUSES__REFERRAL_PRLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="SL_REFERRAL_CLAUSES__REFERRAL_PRLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
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
		if ($("#frmPRLauses div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmPRLauses div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmPRLauses div ul li").each(function(){		  
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
			$("#frmPRLauses div ul li").each(function(){		  
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
		styleString += "#frmPRLauses label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmPRLauses label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPRLauses label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPRLauses label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmPRLauses input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPRLauses input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPRLauses input{text-align:left;}"; break;
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
<div id="id949d20fd512048faa4230f3942ac7323" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading138" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SL_REFERRAL_CLAUSES" 
		data-property-name="TOT_END_PREM" 
		id="pb-container-currency-SL_REFERRAL_CLAUSES-TOT_END_PREM">
		<asp:Label ID="lblSL_REFERRAL_CLAUSES_TOT_END_PREM" runat="server" AssociatedControlID="SL_REFERRAL_CLAUSES__TOT_END_PREM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SL_REFERRAL_CLAUSES__TOT_END_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSL_REFERRAL_CLAUSES_TOT_END_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_SL_REFERRAL_CLAUSES__TOT_END_PREM" 
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
		if ($("#id949d20fd512048faa4230f3942ac7323 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id949d20fd512048faa4230f3942ac7323 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id949d20fd512048faa4230f3942ac7323 div ul li").each(function(){		  
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
			$("#id949d20fd512048faa4230f3942ac7323 div ul li").each(function(){		  
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
		styleString += "#id949d20fd512048faa4230f3942ac7323 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id949d20fd512048faa4230f3942ac7323 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id949d20fd512048faa4230f3942ac7323 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id949d20fd512048faa4230f3942ac7323 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id949d20fd512048faa4230f3942ac7323 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id949d20fd512048faa4230f3942ac7323 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id949d20fd512048faa4230f3942ac7323 input{text-align:left;}"; break;
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
<div id="iddfb2ca9c355d4d75bb0b4e02ac70e225" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading139" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SL_REFERRAL_SLAUSES__SLEND"
		data-field-type="Child" 
		data-object-name="SL_REFERRAL_SLAUSES" 
		data-property-name="SLEND" 
		id="pb-container-childscreen-SL_REFERRAL_SLAUSES-SLEND">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SL_REFERRAL_SLAUSES__SL_CLAUSEPREM" runat="server" ScreenCode="SLEND" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SLEND/SLEND_Endorsement_Premium.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSL_REFERRAL_SLAUSES_SLEND" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SL_REFERRAL_SLAUSES.SLEND"
						ClientValidationFunction="onValidate_SL_REFERRAL_SLAUSES__SLEND" 
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
		if ($("#iddfb2ca9c355d4d75bb0b4e02ac70e225 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#iddfb2ca9c355d4d75bb0b4e02ac70e225 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#iddfb2ca9c355d4d75bb0b4e02ac70e225 div ul li").each(function(){		  
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
			$("#iddfb2ca9c355d4d75bb0b4e02ac70e225 div ul li").each(function(){		  
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
		styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#iddfb2ca9c355d4d75bb0b4e02ac70e225 input{text-align:left;}"; break;
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
<div id="id73b3c5e5176f48129449cc448309b95c" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading140" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SL_NOTES__SLNOTE"
		data-field-type="Child" 
		data-object-name="SL_NOTES" 
		data-property-name="SLNOTE" 
		id="pb-container-childscreen-SL_NOTES-SLNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SL_NOTES__SL_NNOTES_DETAILS" runat="server" ScreenCode="SLNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SLNOTE/SLNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSL_NOTES_SLNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SL_NOTES.SLNOTE"
						ClientValidationFunction="onValidate_SL_NOTES__SLNOTE" 
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
		if ($("#id73b3c5e5176f48129449cc448309b95c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id73b3c5e5176f48129449cc448309b95c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id73b3c5e5176f48129449cc448309b95c div ul li").each(function(){		  
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
			$("#id73b3c5e5176f48129449cc448309b95c div ul li").each(function(){		  
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
		styleString += "#id73b3c5e5176f48129449cc448309b95c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id73b3c5e5176f48129449cc448309b95c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id73b3c5e5176f48129449cc448309b95c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id73b3c5e5176f48129449cc448309b95c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id73b3c5e5176f48129449cc448309b95c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id73b3c5e5176f48129449cc448309b95c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id73b3c5e5176f48129449cc448309b95c input{text-align:left;}"; break;
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
<div id="idf4def13f379041c2877499a4c737bee6" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading141" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SL_NOTES__SLPNOTE"
		data-field-type="Child" 
		data-object-name="SL_NOTES" 
		data-property-name="SLPNOTE" 
		id="pb-container-childscreen-SL_NOTES-SLPNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SL_NOTES__SL_PNOTES_DETAILS" runat="server" ScreenCode="SLPNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SLPNOTE/SLPNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSL_NOTES_SLPNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SL_NOTES.SLPNOTE"
						ClientValidationFunction="onValidate_SL_NOTES__SLPNOTE" 
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
		if ($("#idf4def13f379041c2877499a4c737bee6 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf4def13f379041c2877499a4c737bee6 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf4def13f379041c2877499a4c737bee6 div ul li").each(function(){		  
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
			$("#idf4def13f379041c2877499a4c737bee6 div ul li").each(function(){		  
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
		styleString += "#idf4def13f379041c2877499a4c737bee6 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf4def13f379041c2877499a4c737bee6 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf4def13f379041c2877499a4c737bee6 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf4def13f379041c2877499a4c737bee6 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf4def13f379041c2877499a4c737bee6 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf4def13f379041c2877499a4c737bee6 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf4def13f379041c2877499a4c737bee6 input{text-align:left;}"; break;
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
<div id="idbc21d68bbee94cbbb4e10ecbfb64918d" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading142" runat="server" Text="Premium Breakdown" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SLEMPDE" 
		data-property-name="BASE_PREM" 
		id="pb-container-currency-SLEMPDE-BASE_PREM">
		<asp:Label ID="lblSLEMPDE_BASE_PREM" runat="server" AssociatedControlID="SLEMPDE__BASE_PREM" 
			Text="Base Cover Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SLEMPDE__BASE_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSLEMPDE_BASE_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Base Cover Premium"
			ClientValidationFunction="onValidate_SLEMPDE__BASE_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SLEMPDE" 
		data-property-name="EXT_PREM" 
		id="pb-container-currency-SLEMPDE-EXT_PREM">
		<asp:Label ID="lblSLEMPDE_EXT_PREM" runat="server" AssociatedControlID="SLEMPDE__EXT_PREM" 
			Text="Extension Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SLEMPDE__EXT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSLEMPDE_EXT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Extension Premium"
			ClientValidationFunction="onValidate_SLEMPDE__EXT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SLEMPDE" 
		data-property-name="END_PREM" 
		id="pb-container-currency-SLEMPDE-END_PREM">
		<asp:Label ID="lblSLEMPDE_END_PREM" runat="server" AssociatedControlID="SLEMPDE__END_PREM" 
			Text="Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SLEMPDE__END_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSLEMPDE_END_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Endorsement Premium"
			ClientValidationFunction="onValidate_SLEMPDE__END_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SLEMPDE" 
		data-property-name="TOT_RISK_PREM" 
		id="pb-container-currency-SLEMPDE-TOT_RISK_PREM">
		<asp:Label ID="lblSLEMPDE_TOT_RISK_PREM" runat="server" AssociatedControlID="SLEMPDE__TOT_RISK_PREM" 
			Text="Total Risk Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SLEMPDE__TOT_RISK_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSLEMPDE_TOT_RISK_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Risk Premium"
			ClientValidationFunction="onValidate_SLEMPDE__TOT_RISK_PREM" 
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
		if ($("#idbc21d68bbee94cbbb4e10ecbfb64918d div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idbc21d68bbee94cbbb4e10ecbfb64918d div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idbc21d68bbee94cbbb4e10ecbfb64918d div ul li").each(function(){		  
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
			$("#idbc21d68bbee94cbbb4e10ecbfb64918d div ul li").each(function(){		  
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
		styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbc21d68bbee94cbbb4e10ecbfb64918d input{text-align:left;}"; break;
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