<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMAMISC_Theft.aspx.vb" Inherits="Nexus.PB2_CMAMISC_Theft" %>

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
         * Set the value of a field. When any of the passed in expressions
         * change the set value is re-evaluated.
         * @param {pb.fields.AbstractBase} field The field
         * @param {Expression} value The value to give the field
         * @param {Expression} opt_condition If specified the value will 
         * only be set when this evaluates to true.
         * @param {Expression} opt_elseValue If specified this is the value
         * that will be set when the condition evaluates to false, if 
         * omitted then no value will be set on condition false.
         */
        window.setValue = function(field, value, opt_condition, opt_elseValue){
        	
        		// Helper class to handle the condition and else logic.
        		var valueWhen = new ValueWhenHelper(value, opt_condition, opt_elseValue);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			var value = valueWhen.valueOf();
        			// null is a valid value
        			if (value === undefined)
        				return;
        			
        			field.setValue(value);
        		}, false, this);
        		update();
        };
        
        
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
function onValidate_THEFT__RISK_ATTACH_DATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "RISK_ATTACH_DATE", "Date");
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
        			field = Field.getInstance("THEFT", "RISK_ATTACH_DATE");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.RISK_ATTACH_DATE");
        			window.setControlWidth(field, "0.3", "THEFT", "RISK_ATTACH_DATE");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_RISK_ATTACH_DATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__RISK_ATTACH_DATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__RISK_ATTACH_DATE_lblFindParty");
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
         * @fileoverview
         * DisablePage
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=THEFT&propertyName=RISK_ATTACH_DATE&name={name}");
        		
        		var disablePage = function(disable){
        			disable = !!disable;
        			for (var type in pb.fields.FieldType){
        				if (! pb.fields.FieldType.hasOwnProperty(type))
        					continue;
        					
        				var type = pb.fields.FieldType[type];
        				var fields = Field.fields[type];
        				for (var key in fields){
        					var field = fields[key];
        
        					if (field.getObjectName() == "THEFT" && field.getPropertyName() == "RISK_ATTACH_DATE")
        						continue // Ignore modifying itself
        
        					//if (field.isReadOnlyForever() == false)
        					if (disable){
        						// Bit hacky but keep a note of fields that have been affected by this
        						// so that we can make this rule function as a toggle
        						if (field.isReadOnly != null)
        							field['disablePageBeforeValue'] = field.isReadOnly()
        						field.makeReadOnlyForever(true);
        					} else {
        						field.makeReadOnlyForever(false);
        						if (field.hasOwnProperty('disablePageBeforeValue')){
        							field.setReadOnly(field['disablePageBeforeValue'])
        							delete field['disablePageBeforeValue']
        						}
        					}
        				}
        			}
        		};
        		
        		var condition = (Expression.isValidParameter("GENERAL.CHECK_THFTCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')")) ? new Expression("GENERAL.CHECK_THFTCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')") : null;
        		if (condition == null){ 
        			disablePage(false);
        		} else {
        			goog.events.listen(condition, "change", function(){
        				disablePage(condition == true);
        			});
        			disablePage(condition == true);
        		}
        	};
        })();
}
function onValidate_THEFT__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "EFFECTIVEDATE", "Date");
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
        			field = Field.getInstance("THEFT", "EFFECTIVEDATE");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.3", "THEFT", "EFFECTIVEDATE");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__EFFECTIVEDATE_lblFindParty");
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
}
function onValidate_THEFT__FLAT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "FLAT_PREM", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("THEFT", "FLAT_PREM");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_FLAT_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__FLAT_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__FLAT_PREM_lblFindParty");
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
}
function onValidate_THEFT__TOTAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "TOTAL_PREM", "Currency");
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
        			field = Field.getInstance("THEFT", "TOTAL_PREM");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.TOTAL_PREM");
        			window.setControlWidth(field, "0.3", "THEFT", "TOTAL_PREM");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_TOTAL_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__TOTAL_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__TOTAL_PREM_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT', 'TOTAL_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=TOTAL_PREM&name={name}");
        		
        		var value = new Expression("THEFT.POST_PREM + THEFT_EXTENSIONS.TOT_POST_PREM + THEFT.TOT_END_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "TOTAL_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,###.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,###.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
}
function onValidate_THEFT__AC_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "AC_FAP", "Percentage");
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
        			var field = Field.getInstance("THEFT", "AC_FAP");
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
}
function onValidate_THEFT__AC_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "AC_MIN", "Currency");
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
        			var field = Field.getInstance("THEFT", "AC_MIN");
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
}
function onValidate_THEFT__EXT_PT_FP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "EXT_PT_FP", "Percentage");
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
        			var field = Field.getInstance("THEFT", "EXT_PT_FP");
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
}
function onValidate_THEFT__EXT_PT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "EXT_PT_MIN", "Currency");
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
        			var field = Field.getInstance("THEFT", "EXT_PT_MIN");
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
}
function onValidate_THEFT__INDCONST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "INDCONST", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "INDCONST");
        		var errorMessage = "Industrial Contruction is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.INDCONST");
        			window.setControlWidth(field, "0.3", "THEFT", "INDCONST");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_INDCONST");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__INDCONST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__INDCONST_lblFindParty");
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "INDCONST");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Group 3 locks on external doors, Hinges protected on doors that open outwards, Flat iron bars fitted to opening sections of windows'"), (Expression.isValidParameter("THEFT.INDCONSTCode = 'A'")) ? new Expression("THEFT.INDCONSTCode = 'A'") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=List&objectName=THEFT&propertyName=INDCONST&name={name}");
        			
        			if (field.setTooltip){
        				field.setTooltip(valueWhen.valueOf());
        				return;
        			}
        			var tooltip = new Tooltip();
        			tooltip.setHtml(valueWhen.valueOf());
        			tooltip.attach(field.getElement());
        			
        		}, false, this);
        		update();
        	}
        	
        	
        		
        })();
        /**
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Group 3 locks on external doors, Hinges protected on doors that open outwards, Flat iron bars fitted to opening sections of windows, Security fencing provided, Approved alarm installation, Strongpoint to be provided for high valued clients'"), (Expression.isValidParameter("THEFT.INDCONSTCode = 'B1'")) ? new Expression("THEFT.INDCONSTCode = 'B1'") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=List&objectName=THEFT&propertyName=INDCONST&name={name}");
        			
        			if (field.setTooltip){
        				field.setTooltip(valueWhen.valueOf());
        				return;
        			}
        			var tooltip = new Tooltip();
        			tooltip.setHtml(valueWhen.valueOf());
        			tooltip.attach(field.getElement());
        			
        		}, false, this);
        		update();
        	}
        	
        	
        		
        })();
        /**
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Group 3 locks on external doors, Hinges protected on doors that open outwards, Flat iron bars fitted to opening sections of windows, Security fencing provided, Approved alarm installation, Strongpoint to be provided for high valued clients'"), (Expression.isValidParameter("THEFT.INDCONSTCode = 'B2'")) ? new Expression("THEFT.INDCONSTCode = 'B2'") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=List&objectName=THEFT&propertyName=INDCONST&name={name}");
        			
        			if (field.setTooltip){
        				field.setTooltip(valueWhen.valueOf());
        				return;
        			}
        			var tooltip = new Tooltip();
        			tooltip.setHtml(valueWhen.valueOf());
        			tooltip.attach(field.getElement());
        			
        		}, false, this);
        		update();
        	}
        	
        	
        		
        })();
        /**
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Group 4 locks on external doors, Hinges protected on doors that open outwards, Flat iron bars fitted to opening sections of windows, Security fencing provided, Security lighting provided, Approved alarm installation, Strongpoint to be provided for high valued clients'"), (Expression.isValidParameter("THEFT.INDCONSTCode = 'C'")) ? new Expression("THEFT.INDCONSTCode = 'C'") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=List&objectName=THEFT&propertyName=INDCONST&name={name}");
        			
        			if (field.setTooltip){
        				field.setTooltip(valueWhen.valueOf());
        				return;
        			}
        			var tooltip = new Tooltip();
        			tooltip.setHtml(valueWhen.valueOf());
        			tooltip.attach(field.getElement());
        			
        		}, false, this);
        		update();
        	}
        	
        	
        		
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "INDCONST");
        		
        		var valueExp = new Expression("THEFT.STDCONST.setByCode(D)");
        		var whenExp = (Expression.isValidParameter("THEFT.INDCONSTCode = 'A'")) ? new Expression("THEFT.INDCONSTCode = 'A'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "INDCONST");
        		
        		var valueExp = new Expression("THEFT.STDCONST.setByCode(E1)");
        		var whenExp = (Expression.isValidParameter("THEFT.INDCONSTCode = 'B1'")) ? new Expression("THEFT.INDCONSTCode = 'B1'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "INDCONST");
        		
        		var valueExp = new Expression("THEFT.STDCONST.setByCode(E2)");
        		var whenExp = (Expression.isValidParameter("THEFT.INDCONSTCode = 'B2'")) ? new Expression("THEFT.INDCONSTCode = 'B2'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "INDCONST");
        		
        		var valueExp = new Expression("THEFT.STDCONST.setByCode(F)");
        		var whenExp = (Expression.isValidParameter("THEFT.INDCONSTCode = 'C'")) ? new Expression("THEFT.INDCONSTCode = 'C'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
}
function onValidate_THEFT__STDCONST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "STDCONST", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "STDCONST");
        		var errorMessage = "Standard Contruction is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.STDCONST");
        			window.setControlWidth(field, "0.3", "THEFT", "STDCONST");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_STDCONST");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__STDCONST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__STDCONST_lblFindParty");
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "STDCONST");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "STDCONST");
        		
        		var valueExp = new Expression("THEFT.INDCONST.setByCode(A)");
        		var whenExp = (Expression.isValidParameter("THEFT.STDCONSTCode = 'D'")) ? new Expression("THEFT.STDCONSTCode = 'D'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "STDCONST");
        		
        		var valueExp = new Expression("THEFT.INDCONST.setByCode(B1)");
        		var whenExp = (Expression.isValidParameter("THEFT.STDCONSTCode = 'E1'")) ? new Expression("THEFT.STDCONSTCode = 'E1'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "STDCONST");
        		
        		var valueExp = new Expression("THEFT.INDCONST.setByCode(B2)");
        		var whenExp = (Expression.isValidParameter("THEFT.STDCONSTCode = 'E2'")) ? new Expression("THEFT.STDCONSTCode = 'E2'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "STDCONST");
        		
        		var valueExp = new Expression("THEFT.INDCONST.setByCode(C)");
        		var whenExp = (Expression.isValidParameter("THEFT.STDCONSTCode = 'F'")) ? new Expression("THEFT.STDCONSTCode = 'F'") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
}
function onValidate_THEFT__AWARRANTY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "AWARRANTY", "RateList");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "AWARRANTY");
        		var errorMessage = "Alarm Warranty is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.AWARRANTY");
        			window.setControlWidth(field, "0.3", "THEFT", "AWARRANTY");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_AWARRANTY");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__AWARRANTY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__AWARRANTY_lblFindParty");
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "AWARRANTY");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview Sets the selected list option by it's code value.
         * SetByCode
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "AWARRANTY");
        		
        		// Field must be a list
        		if (field.getType() != "list")
        			throw "SetByCode used on a non list field.";
        		
        		var valueWhen = new ValueWhenHelper(new Expression("'YES'"), (Expression.isValidParameter("THEFT.AWARRANTYCode = '' or THEFT.AWARRANTYCode = null")) ? new Expression("THEFT.AWARRANTYCode = '' or THEFT.AWARRANTYCode = null") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			field.setByCode(valueWhen.valueOf());
        		}, false, this);
        		update();
        		
        		
        	};
        })();
}
function onValidate_THEFT__THEFT0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "THEFT0_12_MONTHS");
        		var errorMessage = "0-12 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT0_12_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_THEFT__THEFT0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT0_12_AMOUNT", "Currency");
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
        			field = Field.getInstance("THEFT", "THEFT0_12_AMOUNT");
        		}
        		//window.setProperty(field, "V", "THEFT.THEFT0_12_MONTHSCode = 1 OR THEFT.THEFT0_12_MONTHSCode = 2", "VEM", "0-12 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "THEFT.THEFT0_12_MONTHSCode = 1 OR THEFT.THEFT0_12_MONTHSCode = 2",
            paramElseValue = "VEM",
            paramValidationMessage = "0-12 Months Amount is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT0_12_AMOUNT");
        		
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
        
        			var field = Field.getInstance('THEFT', 'THEFT0_12_AMOUNT');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT0_12_AMOUNT");
        		
        		
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=THEFT0_12_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("THEFT.THEFT0_12_MONTHSCode = 1 OR THEFT.THEFT0_12_MONTHSCode = 2")) ? new Expression("THEFT.THEFT0_12_MONTHSCode = 1 OR THEFT.THEFT0_12_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT__THEFT13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "THEFT13_24_MONTHS");
        		var errorMessage = "13-24 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT13_24_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_THEFT__THEFT13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT13_24_AMOUNT", "Currency");
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
        			field = Field.getInstance("THEFT", "THEFT13_24_AMOUNT");
        		}
        		//window.setProperty(field, "V", "THEFT.THEFT13_24_MONTHSCode = 1 OR THEFT.THEFT13_24_MONTHSCode = 2", "VEM", "13-24 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "THEFT.THEFT13_24_MONTHSCode = 1 OR THEFT.THEFT13_24_MONTHSCode = 2",
            paramElseValue = "VEM",
            paramValidationMessage = "13-24 Months Amount is mandatory and an amount must be entered";
            
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT13_24_AMOUNT");
        		
        		
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=THEFT13_24_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("THEFT.THEFT13_24_MONTHSCode = 1 OR THEFT.THEFT13_24_MONTHSCode = 2")) ? new Expression("THEFT.THEFT13_24_MONTHSCode = 1 OR THEFT.THEFT13_24_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT13_24_AMOUNT");
        		
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
        
        			var field = Field.getInstance('THEFT', 'THEFT13_24_AMOUNT');
        			
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
function onValidate_THEFT__THEFT25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "THEFT25_36_MONTHS");
        		var errorMessage = "25-36 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT25_36_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_THEFT__THEFT25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT25_36_AMOUNT", "Currency");
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
        			field = Field.getInstance("THEFT", "THEFT25_36_AMOUNT");
        		}
        		//window.setProperty(field, "V", "THEFT.THEFT25_36_MONTHSCode = 1 OR THEFT.THEFT25_36_MONTHSCode = 2", "VEM", "25-36 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "THEFT.THEFT25_36_MONTHSCode = 1 OR THEFT.THEFT25_36_MONTHSCode = 2",
            paramElseValue = "VEM",
            paramValidationMessage = "25-36 Months Amount is mandatory and an amount must be entered";
            
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT25_36_AMOUNT");
        		
        		
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=THEFT25_36_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("THEFT.THEFT25_36_MONTHSCode = 1 OR THEFT.THEFT25_36_MONTHSCode = 2")) ? new Expression("THEFT.THEFT25_36_MONTHSCode = 1 OR THEFT.THEFT25_36_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "THEFT25_36_AMOUNT");
        		
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
        
        			var field = Field.getInstance('THEFT', 'THEFT25_36_AMOUNT');
        			
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
function onValidate_THEFT__SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "SUMINSURED");
        		var errorMessage = "All Contents Sum Insured is mandatory and an amount must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "SUMINSURED");
        		
        		
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
        
        			var field = Field.getInstance('THEFT', 'SUMINSURED');
        			
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "SUMINSURED");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "SUMINSURED");
        		
        		var valueExp = new Expression("THEFT.POST_PREM.setValue(THEFT.SUMINSURED*THEFT.RATE/100)");
        		var whenExp = (Expression.isValidParameter("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)")) ? new Expression("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
}
function onValidate_THEFT__RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "RATE", "Percentage");
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
        			field = Field.getInstance("THEFT", "RATE");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
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
        
        			var field = Field.getInstance('THEFT', 'RATE');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "RATE");
        		
        		var valueExp = new Expression("THEFT.POST_PREM.setValue(THEFT.SUMINSURED*THEFT.RATE/100)");
        		var whenExp = (Expression.isValidParameter("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)")) ? new Expression("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
}
function onValidate_THEFT__PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "PREM", "Currency");
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
        			field = Field.getInstance("THEFT", "PREM");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT', 'PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=PREM&name={name}");
        		
        		var value = new Expression("THEFT.POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "POST_PREM");
        		var errorMessage = "All Contents Posting Premium is mandatory and an amount must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT', 'POST_PREM');
        			
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT", "POST_PREM");
        		
        		var valueExp = new Expression("THEFT.RATE.setValue(THEFT.POST_PREM/THEFT.SUMINSURED*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)")) ? new Expression("(THEFT.SUMINSURED <> '' AND THEFT.SUMINSURED <> null) and (THEFT.RATE <> '' AND THEFT.RATE <> null)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
}
function onValidate_THEFT__FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "FAP_PERC", "Percentage");
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "FAP_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('THEFT', 'FAP_PERC');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT&propertyName=FAP_PERC&name={name}");
        		
        		var value = new Expression("THEFT.AC_FAP"), 
        			condition = (Expression.isValidParameter("THEFT.FAP_PERC = '' || THEFT.FAP_PERC = null")) ? new Expression("THEFT.FAP_PERC = '' || THEFT.FAP_PERC = null") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("All Contents FAP %  cannot be more than 100%")) ? "All Contents FAP %  cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "THEFT".toUpperCase() + "__" + "FAP_PERC");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "THEFT".toUpperCase() + "_" + "FAP_PERC");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(THEFT.FAP_PERC > 0 && THEFT.FAP_PERC < 101) || (THEFT.FAP_PERC = '' || THEFT.FAP_PERC = null)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_THEFT__MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT", "MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("###,###,###", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###,###,###");
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
        
        			var field = Field.getInstance('THEFT', 'MIN_AMNT');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT&propertyName=MIN_AMNT&name={name}");
        		
        		var value = new Expression("THEFT.AC_MIN"), 
        			condition = (Expression.isValidParameter("THEFT.MIN_AMNT = '' || THEFT.MIN_AMNT = null")) ? new Expression("THEFT.MIN_AMNT = '' || THEFT.MIN_AMNT = null") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__IS_ACPC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "IS_ACPC", "Checkbox");
        })();
}
function onValidate_THEFT_EXTENSIONS__ACPC_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ACPC_LIMIT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_ACPC = 1", "V", "Additional Claims Preparation Costs Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_ACPC = 1",
            paramElseValue = "V",
            paramValidationMessage = "Additional Claims Preparation Costs Limit of Indemnity is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 1")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ACPC_LIMIT');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_LIMIT");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ACPC_POST_PREM.setValue(THEFT_EXTENSIONS.ACPC_LIMIT*THEFT_EXTENSIONS.ACPC_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null and THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null and (THEFT_EXTENSIONS.IS_ACPC == 1)")) ? new Expression("THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null and THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null and (THEFT_EXTENSIONS.IS_ACPC == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ACPC_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ACPC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ACPC_RATE", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_RATE");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_ACPC = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_ACPC = 1",
            paramElseValue = "V",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ACPC_RATE');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_RATE");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ACPC_POST_PREM.setValue(THEFT_EXTENSIONS.ACPC_LIMIT*THEFT_EXTENSIONS.ACPC_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null and THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null and (THEFT_EXTENSIONS.IS_ACPC == 1)")) ? new Expression("THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null and THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null and (THEFT_EXTENSIONS.IS_ACPC == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=ACPC_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ACPC_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ACPC_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ACPC_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ACPC_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.ACPC_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ACPC_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ACPC_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ACPC_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_ACPC = 1", "V", "Additional Claims Preparation Costs is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_ACPC = 1",
            paramElseValue = "V",
            paramValidationMessage = "Additional Claims Preparation Costs is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 1")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ACPC_POST_PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ACPC_POST_PREM");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ACPC_RATE.setValue(THEFT_EXTENSIONS.ACPC_POST_PREM/THEFT_EXTENSIONS.ACPC_LIMIT*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null) and (THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null) and (THEFT_EXTENSIONS.IS_ACPC == 1)")) ? new Expression("(THEFT_EXTENSIONS.ACPC_LIMIT <> '' AND THEFT_EXTENSIONS.ACPC_LIMIT <> null) and (THEFT_EXTENSIONS.ACPC_RATE <> '' AND THEFT_EXTENSIONS.ACPC_RATE <> null) and (THEFT_EXTENSIONS.IS_ACPC == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ACPC_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ACPC = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__IS_ADB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "IS_ADB", "Checkbox");
        })();
}
function onValidate_THEFT_EXTENSIONS__ADB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ADB_LIMIT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ADB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_ADB = 1", "V", "Additional Damage to Building Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_ADB = 1",
            paramElseValue = "V",
            paramValidationMessage = "Additional Damage to Building Limit of Indemnity is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 1")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ADB_LIMIT');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_LIMIT");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ADB_POST_PREM.setValue(THEFT_EXTENSIONS.ADB_LIMIT*THEFT_EXTENSIONS.ADB_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null and THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null and (THEFT_EXTENSIONS.IS_ADB == 1)")) ? new Expression("THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null and THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null and (THEFT_EXTENSIONS.IS_ADB == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ADB_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ADB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ADB_RATE", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ADB_RATE");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_ADB = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_ADB = 1",
            paramElseValue = "V",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ADB_RATE');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_RATE");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ADB_POST_PREM.setValue(THEFT_EXTENSIONS.ADB_LIMIT*THEFT_EXTENSIONS.ADB_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null and THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null and (THEFT_EXTENSIONS.IS_ADB == 1)")) ? new Expression("THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null and THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null and (THEFT_EXTENSIONS.IS_ADB == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=ADB_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ADB_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ADB_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ADB_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ADB_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ADB_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.ADB_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ADB_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__ADB_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "ADB_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "ADB_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_ADB = 1", "V", "Additional Damage to Building Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_ADB = 1",
            paramElseValue = "V",
            paramValidationMessage = "Additional Damage to Building Posting Premium is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 1")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'ADB_POST_PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "ADB_POST_PREM");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.ADB_RATE.setValue(THEFT_EXTENSIONS.ADB_POST_PREM/THEFT_EXTENSIONS.ADB_LIMIT*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null) and (THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null) and (THEFT_EXTENSIONS.IS_ADB == 1)")) ? new Expression("(THEFT_EXTENSIONS.ADB_LIMIT <> '' AND THEFT_EXTENSIONS.ADB_LIMIT <> null) and (THEFT_EXTENSIONS.ADB_RATE <> '' AND THEFT_EXTENSIONS.ADB_RATE <> null) and (THEFT_EXTENSIONS.IS_ADB == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=ADB_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_ADB = 0")) ? new Expression("THEFT_EXTENSIONS.IS_ADB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__IS_LOSS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "IS_LOSS", "Checkbox");
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_LIMIT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_LOSS = 1", "V", "Losses in the Open at the Insured Premises Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_LOSS = 1",
            paramElseValue = "V",
            paramValidationMessage = "Losses in the Open at the Insured Premises Limit of Indemnity is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 1")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_LIMIT');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_LIMIT");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.LOSS_POST_PREM.setValue(THEFT_EXTENSIONS.LOSS_LIMIT*THEFT_EXTENSIONS.LOSS_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null and THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null and (THEFT_EXTENSIONS.IS_LOSS == 1)")) ? new Expression("THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null and THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null and (THEFT_EXTENSIONS.IS_LOSS == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=LOSS_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_RATE", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_RATE");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_LOSS = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_LOSS = 1",
            paramElseValue = "V",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_RATE');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_RATE");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.LOSS_POST_PREM.setValue(THEFT_EXTENSIONS.LOSS_LIMIT*THEFT_EXTENSIONS.LOSS_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null and THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null and (THEFT_EXTENSIONS.IS_LOSS == 1)")) ? new Expression("THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null and THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null and (THEFT_EXTENSIONS.IS_LOSS == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=LOSS_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=LOSS_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.LOSS_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=LOSS_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_LOSS = 1", "V", "Losses in the Open at the Insured Premises Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_LOSS = 1",
            paramElseValue = "V",
            paramValidationMessage = "Losses in the Open at the Insured Premises Posting Premium is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 1")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_POST_PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_POST_PREM");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.LOSS_RATE.setValue(THEFT_EXTENSIONS.LOSS_POST_PREM/THEFT_EXTENSIONS.LOSS_LIMIT*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null) and (THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null) and (THEFT_EXTENSIONS.IS_LOSS == 1)")) ? new Expression("(THEFT_EXTENSIONS.LOSS_LIMIT <> '' AND THEFT_EXTENSIONS.LOSS_LIMIT <> null) and (THEFT_EXTENSIONS.LOSS_RATE <> '' AND THEFT_EXTENSIONS.LOSS_RATE <> null) and (THEFT_EXTENSIONS.IS_LOSS == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=LOSS_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_FAP_PERC", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_FAP_PERC");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_LOSS = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_LOSS = 1",
            paramElseValue = "V",
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_FAP_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_FAP_PERC');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=LOSS_FAP_PERC&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Losses in the Open at the Insured Premises FAP % cannot be more than 100%")) ? "Losses in the Open at the Insured Premises FAP % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "THEFT_EXTENSIONS".toUpperCase() + "__" + "LOSS_FAP_PERC");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "THEFT_EXTENSIONS".toUpperCase() + "_" + "LOSS_FAP_PERC");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(THEFT_EXTENSIONS.LOSS_FAP_PERC < 0 ) || (THEFT_EXTENSIONS.LOSS_FAP_PERC > 100 )");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_THEFT_EXTENSIONS__LOSS_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "LOSS_MIN_AMNT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_LOSS = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_LOSS = 1",
            paramElseValue = "V",
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "LOSS_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'LOSS_MIN_AMNT');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=LOSS_MIN_AMNT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_LOSS = 0")) ? new Expression("THEFT_EXTENSIONS.IS_LOSS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__IS_MD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "IS_MD", "Checkbox");
        })();
}
function onValidate_THEFT_EXTENSIONS__MD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "MD_LIMIT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "MD_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_MD = 1", "V", "Malicious Damage Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_MD = 1",
            paramElseValue = "V",
            paramValidationMessage = "Malicious Damage Limit of Indemnity is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 1")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'MD_LIMIT');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_LIMIT");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.MD_POST_PREM.setValue(THEFT_EXTENSIONS.MD_LIMIT*THEFT_EXTENSIONS.MD_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null and THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null and (THEFT_EXTENSIONS.IS_MD == 1)")) ? new Expression("THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null and THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null and (THEFT_EXTENSIONS.IS_MD == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=MD_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 0")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__MD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "MD_RATE", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "MD_RATE");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_MD = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_MD = 1",
            paramElseValue = "V",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'MD_RATE');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_RATE");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.MD_POST_PREM.setValue(THEFT_EXTENSIONS.MD_LIMIT*THEFT_EXTENSIONS.MD_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null and THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null and (THEFT_EXTENSIONS.IS_MD == 1)")) ? new Expression("THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null and THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null and (THEFT_EXTENSIONS.IS_MD == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=MD_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 0")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__MD_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "MD_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "MD_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'MD_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=MD_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.MD_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=MD_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 0")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__MD_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "MD_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "MD_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_MD = 1", "V", "Malicious Damage Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_MD = 1",
            paramElseValue = "V",
            paramValidationMessage = "Malicious Damage Posting Premium is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 1")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'MD_POST_PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "MD_POST_PREM");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.MD_RATE.setValue(THEFT_EXTENSIONS.MD_POST_PREM/THEFT_EXTENSIONS.MD_LIMIT*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null) and (THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null) and (THEFT_EXTENSIONS.IS_MD == 1)")) ? new Expression("(THEFT_EXTENSIONS.MD_LIMIT <> '' AND THEFT_EXTENSIONS.MD_LIMIT <> null) and (THEFT_EXTENSIONS.MD_RATE <> '' AND THEFT_EXTENSIONS.MD_RATE <> null) and (THEFT_EXTENSIONS.IS_MD == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=MD_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_MD = 0")) ? new Expression("THEFT_EXTENSIONS.IS_MD = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__IS_PETROL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "IS_PETROL", "Checkbox");
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_LIMIT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_PETROL = 1", "V", "Petrol in Underground Tanks Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_PETROL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Petrol in Underground Tanks Limit of Indemnity is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 1")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_LIMIT');
        			
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_LIMIT");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.PETROL_POST_PREM.setValue(THEFT_EXTENSIONS.PETROL_LIMIT*THEFT_EXTENSIONS.PETROL_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null and THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null and (THEFT_EXTENSIONS.IS_PETROL == 1)")) ? new Expression("THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null and THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null and (THEFT_EXTENSIONS.IS_PETROL == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_RATE", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_RATE");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_PETROL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_PETROL = 1",
            paramElseValue = "V",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_RATE');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_RATE");
        		
        		
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
        			return field.setFormatPattern("###.#####%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.#####%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_RATE");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.PETROL_POST_PREM.setValue(THEFT_EXTENSIONS.PETROL_LIMIT*THEFT_EXTENSIONS.PETROL_RATE/100)");
        		var whenExp = (Expression.isValidParameter("THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null and THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null and (THEFT_EXTENSIONS.IS_PETROL == 1)")) ? new Expression("THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null and THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null and (THEFT_EXTENSIONS.IS_PETROL == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=PETROL_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.PETROL_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "THEFT_EXTENSIONS.IS_PETROL = 1", "V", "Petrol in Underground Tanks Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "THEFT_EXTENSIONS.IS_PETROL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Petrol in Underground Tanks Posting Premium is mandatory and an amount must be entered";
            
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
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 1")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 1") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_POST_PREM');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_POST_PREM");
        		
        		var valueExp = new Expression("THEFT_EXTENSIONS.PETROL_RATE.setValue(THEFT_EXTENSIONS.PETROL_POST_PREM/THEFT_EXTENSIONS.PETROL_LIMIT*100)");
        		var whenExp = (Expression.isValidParameter("(THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null) and (THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null) and (THEFT_EXTENSIONS.IS_PETROL == 1)")) ? new Expression("(THEFT_EXTENSIONS.PETROL_LIMIT <> '' AND THEFT_EXTENSIONS.PETROL_LIMIT <> null) and (THEFT_EXTENSIONS.PETROL_RATE <> '' AND THEFT_EXTENSIONS.PETROL_RATE <> null) and (THEFT_EXTENSIONS.IS_PETROL == 1)") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		events.listen(field, "change", function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		}, false, this);
        		
        	
        		
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_FAP_PERC", "Percentage");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_FAP_PERC");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_PETROL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_PETROL = 1",
            paramElseValue = "V",
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_FAP_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_FAP_PERC');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=PETROL_FAP_PERC&name={name}");
        		
        		var value = new Expression("THEFT.EXT_PT_FP"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 1 && (THEFT_EXTENSIONS.PETROL_FAP_PERC = '' || THEFT_EXTENSIONS.PETROL_FAP_PERC = null || THEFT_EXTENSIONS.PETROL_FAP_PERC < THEFT.EXT_PT_FP)")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 1 && (THEFT_EXTENSIONS.PETROL_FAP_PERC = '' || THEFT_EXTENSIONS.PETROL_FAP_PERC = null || THEFT_EXTENSIONS.PETROL_FAP_PERC < THEFT.EXT_PT_FP)") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=THEFT_EXTENSIONS&propertyName=PETROL_FAP_PERC&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Petrol in Underground Tanks FAP %  cannot be more than 100%")) ? "Petrol in Underground Tanks FAP %  cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "THEFT_EXTENSIONS".toUpperCase() + "__" + "PETROL_FAP_PERC");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "THEFT_EXTENSIONS".toUpperCase() + "_" + "PETROL_FAP_PERC");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(THEFT_EXTENSIONS.PETROL_FAP_PERC < 0 ) || (THEFT_EXTENSIONS.PETROL_FAP_PERC > 100 )");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_THEFT_EXTENSIONS__PETROL_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "PETROL_MIN_AMNT", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "THEFT_EXTENSIONS.IS_PETROL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "THEFT_EXTENSIONS.IS_PETROL = 1",
            paramElseValue = "V",
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "PETROL_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'PETROL_MIN_AMNT');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_MIN_AMNT&name={name}");
        		
        		var value = new Expression("THEFT.EXT_PT_MIN"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 1 && (THEFT_EXTENSIONS.PETROL_MIN_AMNT = '' || THEFT_EXTENSIONS.PETROL_MIN_AMNT = null || THEFT_EXTENSIONS.PETROL_MIN_AMNT < THEFT.EXT_PT_MIN)")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 1 && (THEFT_EXTENSIONS.PETROL_MIN_AMNT = '' || THEFT_EXTENSIONS.PETROL_MIN_AMNT = null || THEFT_EXTENSIONS.PETROL_MIN_AMNT < THEFT.EXT_PT_MIN)") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=PETROL_MIN_AMNT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("THEFT_EXTENSIONS.IS_PETROL = 0")) ? new Expression("THEFT_EXTENSIONS.IS_PETROL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__TOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "TOT_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "TOT_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "TOT_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'TOT_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=TOT_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.TOT_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT_EXTENSIONS__TOT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_EXTENSIONS", "TOT_POST_PREM", "Currency");
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
        			field = Field.getInstance("THEFT_EXTENSIONS", "TOT_POST_PREM");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("THEFT_EXTENSIONS", "TOT_POST_PREM");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('THEFT_EXTENSIONS', 'TOT_POST_PREM');
        			
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=THEFT_EXTENSIONS&propertyName=TOT_POST_PREM&name={name}");
        		
        		var value = new Expression("THEFT_EXTENSIONS.ACPC_POST_PREM + THEFT_EXTENSIONS.ADB_POST_PREM + THEFT_EXTENSIONS.LOSS_POST_PREM + THEFT_EXTENSIONS.MD_POST_PREM + THEFT_EXTENSIONS.PETROL_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_THEFT__THEFT_COUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "THEFT_COUNT", "Integer");
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
        			var field = Field.getInstance("THEFT", "THEFT_COUNT");
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
          * @param THEFT The Parent (Root) object name.
          * @param THEFT_CLAUSEPREM.COUNTER_ID The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "THEFT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "THEFT_CLAUSEPREM.COUNTER_ID";
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
        		
        		var field = Field.getInstance("THEFT", "THEFT_COUNT");
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
        			
        			var field = Field.getInstance("THEFT", "THEFT_COUNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_THEFT__TOT_END_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "TOT_END_PREM", "Currency");
        })();
        
         /**
          * @fileoverview GetColumn
          * @param THEFT The Parent (Root) object name.
          * @param THEFT_CLAUSEPREM.PREMIUM The object.property to sum the totals of.
          * @param TOTAL The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "THEFT".toUpperCase().replace(/^\s+|\s+$/g, '');
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
        		
        		var field = Field.getInstance("THEFT", "TOT_END_PREM");
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
        			
        			var field = Field.getInstance("THEFT", "TOT_END_PREM");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("THEFT.TOT_END_PREM");
        			window.setControlWidth(field, "0.3", "THEFT", "TOT_END_PREM");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblTHEFT_TOT_END_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_THEFT__TOT_END_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_THEFT__TOT_END_PREM_lblFindParty");
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
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("THEFT", "TOT_END_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('THEFT', 'TOT_END_PREM');
        			
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
function onValidate_THEFT__MATHEFTEND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT", "MATHEFTEND", "ChildScreen");
        })();
        /**
         * @fileoverview
         * DisableAddWhen, used only on child screen objects.
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT", "MATHEFTEND");
        		var update = function(){
                var links;
        		if (field.getType() == "child_screen"){
        			// Remove the options from the table
        		   links = goog.dom.query("#ctl00_cntMainBody_THEFT__MATHEFTEND table td a");
        				
        		} else {
        		   links = goog.dom.query("a", field.getElement());
        		}		
                var exp = new Expression("GENERAL.CHECK_THFTCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')");
        		goog.array.forEach(links, function(link){	
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				if (link != null && linkCaption.toLowerCase().trim() == 'add')
        		        {
        					if (exp.getValue() == true ){
        				       link.style.display = "none";
        					} else  {
        						link.style.display = "inline-block";
        					}
        		        }		
        		});		
        	};
        	 update();		
        		        goog.events.listen(field, "change", update); 
        	};
        })();
}
function onValidate_THEFT_NOTES__THEFTNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_NOTES", "THEFTNOTE", "ChildScreen");
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
        		var field = Field.getInstance("THEFT_NOTES", "THEFTNOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_THEFT_NOTES__THEFTNOTE table td a");
        				
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
        		var field = Field.getInstance("THEFT_NOTES", "THEFTNOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'THEFT_NOTES' and property 'THEFTNOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_THEFT_NOTES__THEFTNOTE table td a");
        				
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
        /**
         * @fileoverview
         * DisableAddWhen, used only on child screen objects.
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT_NOTES", "THEFTNOTE");
        		var update = function(){
                var links;
        		if (field.getType() == "child_screen"){
        			// Remove the options from the table
        		   links = goog.dom.query("#ctl00_cntMainBody_THEFT_NOTES__THEFTNOTE table td a");
        				
        		} else {
        		   links = goog.dom.query("a", field.getElement());
        		}		
                var exp = new Expression("GENERAL.CHECK_THFTCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')");
        		goog.array.forEach(links, function(link){	
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				if (link != null && linkCaption.toLowerCase().trim() == 'add')
        		        {
        					if (exp.getValue() == true ){
        				       link.style.display = "none";
        					} else  {
        						link.style.display = "inline-block";
        					}
        		        }		
        		});		
        	};
        	 update();		
        		        goog.events.listen(field, "change", update); 
        	};
        })();
}
function onValidate_THEFT_NOTES__THEFTSNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_NOTES", "THEFTSNOTE", "ChildScreen");
        })();
        /**
         * @fileoverview
         * DisableAddWhen, used only on child screen objects.
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("THEFT_NOTES", "THEFTSNOTE");
        		var update = function(){
                var links;
        		if (field.getType() == "child_screen"){
        			// Remove the options from the table
        		   links = goog.dom.query("#ctl00_cntMainBody_THEFT_NOTES__THEFTSNOTE table td a");
        				
        		} else {
        		   links = goog.dom.query("a", field.getElement());
        		}		
                var exp = new Expression("GENERAL.CHECK_THFTCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')");
        		goog.array.forEach(links, function(link){	
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				if (link != null && linkCaption.toLowerCase().trim() == 'add')
        		        {
        					if (exp.getValue() == true ){
        				       link.style.display = "none";
        					} else  {
        						link.style.display = "inline-block";
        					}
        		        }		
        		});		
        	};
        	 update();		
        		        goog.events.listen(field, "change", update); 
        	};
        })();
}
function onValidate_THEFT_NOTES__TFT_NTS_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "THEFT_NOTES", "TFT_NTS_CNT", "Integer");
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
        			var field = Field.getInstance("THEFT_NOTES", "TFT_NTS_CNT");
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
          * @param THEFT_NOTES The Parent (Root) object name.
          * @param THEFT_SCNOTES_DETAILS.DATE_CREATED The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "THEFT_NOTES".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "THEFT_SCNOTES_DETAILS.DATE_CREATED";
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
        		
        		var field = Field.getInstance("THEFT_NOTES", "TFT_NTS_CNT");
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
        			
        			var field = Field.getInstance("THEFT_NOTES", "TFT_NTS_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_THEFT__RISK_ATTACH_DATE(null, null, null, isOnLoad);
    onValidate_THEFT__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_THEFT__FLAT_PREM(null, null, null, isOnLoad);
    onValidate_THEFT__TOTAL_PREM(null, null, null, isOnLoad);
    onValidate_THEFT__AC_FAP(null, null, null, isOnLoad);
    onValidate_THEFT__AC_MIN(null, null, null, isOnLoad);
    onValidate_THEFT__EXT_PT_FP(null, null, null, isOnLoad);
    onValidate_THEFT__EXT_PT_MIN(null, null, null, isOnLoad);
    onValidate_THEFT__INDCONST(null, null, null, isOnLoad);
    onValidate_THEFT__STDCONST(null, null, null, isOnLoad);
    onValidate_THEFT__AWARRANTY(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_THEFT__SUMINSURED(null, null, null, isOnLoad);
    onValidate_THEFT__RATE(null, null, null, isOnLoad);
    onValidate_THEFT__PREM(null, null, null, isOnLoad);
    onValidate_THEFT__POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT__FAP_PERC(null, null, null, isOnLoad);
    onValidate_THEFT__MIN_AMNT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__IS_ACPC(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ACPC_LIMIT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ACPC_RATE(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ACPC_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ACPC_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__IS_ADB(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ADB_LIMIT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ADB_RATE(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ADB_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__ADB_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__IS_LOSS(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_LIMIT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_RATE(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_FAP_PERC(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__LOSS_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__IS_MD(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__MD_LIMIT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__MD_RATE(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__MD_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__MD_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__IS_PETROL(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_LIMIT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_RATE(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_FAP_PERC(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__PETROL_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__TOT_PREM(null, null, null, isOnLoad);
    onValidate_THEFT_EXTENSIONS__TOT_POST_PREM(null, null, null, isOnLoad);
    onValidate_THEFT__THEFT_COUNT(null, null, null, isOnLoad);
    onValidate_THEFT__TOT_END_PREM(null, null, null, isOnLoad);
    onValidate_THEFT__MATHEFTEND(null, null, null, isOnLoad);
    onValidate_THEFT_NOTES__THEFTNOTE(null, null, null, isOnLoad);
    onValidate_THEFT_NOTES__THEFTSNOTE(null, null, null, isOnLoad);
    onValidate_THEFT_NOTES__TFT_NTS_CNT(null, null, null, isOnLoad);
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
<div id="id3db2da738da740389e58753c929bf298" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id5133ba2e36884af9b38ee8e77f146f2e" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading65" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="THEFT" 
		data-property-name="RISK_ATTACH_DATE" 
		id="pb-container-datejquerycompatible-THEFT-RISK_ATTACH_DATE">
		<asp:Label ID="lblTHEFT_RISK_ATTACH_DATE" runat="server" AssociatedControlID="THEFT__RISK_ATTACH_DATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="THEFT__RISK_ATTACH_DATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calTHEFT__RISK_ATTACH_DATE" runat="server" LinkedControl="THEFT__RISK_ATTACH_DATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valTHEFT_RISK_ATTACH_DATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_THEFT__RISK_ATTACH_DATE" 
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
		data-object-name="THEFT" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-THEFT-EFFECTIVEDATE">
		<asp:Label ID="lblTHEFT_EFFECTIVEDATE" runat="server" AssociatedControlID="THEFT__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="THEFT__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calTHEFT__EFFECTIVEDATE" runat="server" LinkedControl="THEFT__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valTHEFT_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_THEFT__EFFECTIVEDATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTHEFT_FLAT_PREM" for="ctl00_cntMainBody_THEFT__FLAT_PREM" class="col-md-4 col-sm-3 control-label">
		Flat Premium</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT" 
		data-property-name="FLAT_PREM" 
		id="pb-container-checkbox-THEFT-FLAT_PREM">	
		
		<asp:TextBox ID="THEFT__FLAT_PREM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_FLAT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Flat Premium"
			ClientValidationFunction="onValidate_THEFT__FLAT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="TOTAL_PREM" 
		id="pb-container-currency-THEFT-TOTAL_PREM">
		<asp:Label ID="lblTHEFT_TOTAL_PREM" runat="server" AssociatedControlID="THEFT__TOTAL_PREM" 
			Text="Total Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__TOTAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_TOTAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Premium"
			ClientValidationFunction="onValidate_THEFT__TOTAL_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT" 
		data-property-name="AC_FAP" 
		id="pb-container-percentage-THEFT-AC_FAP">
		<asp:Label ID="lblTHEFT_AC_FAP" runat="server" AssociatedControlID="THEFT__AC_FAP" 
			Text="All Contents FAP %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT__AC_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_AC_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for All Contents FAP %"
			ClientValidationFunction="onValidate_THEFT__AC_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="AC_MIN" 
		id="pb-container-currency-THEFT-AC_MIN">
		<asp:Label ID="lblTHEFT_AC_MIN" runat="server" AssociatedControlID="THEFT__AC_MIN" 
			Text="Major Limit Min Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__AC_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_AC_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Major Limit Min Amount"
			ClientValidationFunction="onValidate_THEFT__AC_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT" 
		data-property-name="EXT_PT_FP" 
		id="pb-container-percentage-THEFT-EXT_PT_FP">
		<asp:Label ID="lblTHEFT_EXT_PT_FP" runat="server" AssociatedControlID="THEFT__EXT_PT_FP" 
			Text="Extension - Petrol Tanks FAP %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT__EXT_PT_FP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXT_PT_FP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Extension - Petrol Tanks FAP %"
			ClientValidationFunction="onValidate_THEFT__EXT_PT_FP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="EXT_PT_MIN" 
		id="pb-container-currency-THEFT-EXT_PT_MIN">
		<asp:Label ID="lblTHEFT_EXT_PT_MIN" runat="server" AssociatedControlID="THEFT__EXT_PT_MIN" 
			Text="Extension - Petrol Tanks Min Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__EXT_PT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXT_PT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Extension - Petrol Tanks Min Amount"
			ClientValidationFunction="onValidate_THEFT__EXT_PT_MIN" 
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
		if ($("#id5133ba2e36884af9b38ee8e77f146f2e div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id5133ba2e36884af9b38ee8e77f146f2e div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id5133ba2e36884af9b38ee8e77f146f2e div ul li").each(function(){		  
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
			$("#id5133ba2e36884af9b38ee8e77f146f2e div ul li").each(function(){		  
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
		styleString += "#id5133ba2e36884af9b38ee8e77f146f2e label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id5133ba2e36884af9b38ee8e77f146f2e label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id5133ba2e36884af9b38ee8e77f146f2e label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id5133ba2e36884af9b38ee8e77f146f2e label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id5133ba2e36884af9b38ee8e77f146f2e input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id5133ba2e36884af9b38ee8e77f146f2e input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id5133ba2e36884af9b38ee8e77f146f2e input{text-align:left;}"; break;
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
<div id="idcbb853d0d40f4301ad572f08ac1849c8" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading66" runat="server" Text="Malicious Damage Following Theft" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="INDCONST" 
		id="pb-container-list-THEFT-INDCONST">
		<asp:Label ID="lblTHEFT_INDCONST" runat="server" AssociatedControlID="THEFT__INDCONST" 
			Text="Industrial Construction" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__INDCONST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_INDCONST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__INDCONST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_INDCONST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Industrial Construction"
			ClientValidationFunction="onValidate_THEFT__INDCONST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="STDCONST" 
		id="pb-container-list-THEFT-STDCONST">
		<asp:Label ID="lblTHEFT_STDCONST" runat="server" AssociatedControlID="THEFT__STDCONST" 
			Text="Standard Construction" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__STDCONST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_STDCONST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__STDCONST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_STDCONST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Standard Construction"
			ClientValidationFunction="onValidate_THEFT__STDCONST" 
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
		
		data-object-name="THEFT" 
		data-property-name="INDCONSTCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-THEFT-INDCONSTCode">

		
		
			
		
				<asp:HiddenField ID="THEFT__INDCONSTCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="THEFT" 
		data-property-name="STDCONSTCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-THEFT-STDCONSTCode">

		
		
			
		
				<asp:HiddenField ID="THEFT__STDCONSTCode" runat="server" />

		

		
	
		
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
		if ($("#idcbb853d0d40f4301ad572f08ac1849c8 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idcbb853d0d40f4301ad572f08ac1849c8 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idcbb853d0d40f4301ad572f08ac1849c8 div ul li").each(function(){		  
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
			$("#idcbb853d0d40f4301ad572f08ac1849c8 div ul li").each(function(){		  
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
		styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idcbb853d0d40f4301ad572f08ac1849c8 input{text-align:left;}"; break;
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
<div id="id200b8e2f268743998d4f4c92c52f6590" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading67" runat="server" Text="Theft" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="AWARRANTY" 
		id="pb-container-list-THEFT-AWARRANTY">
		<asp:Label ID="lblTHEFT_AWARRANTY" runat="server" AssociatedControlID="THEFT__AWARRANTY" 
			Text="Alarm Warranty" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__AWARRANTY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="YESNO" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__AWARRANTY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_AWARRANTY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Alarm Warranty"
			ClientValidationFunction="onValidate_THEFT__AWARRANTY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
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
		if ($("#id200b8e2f268743998d4f4c92c52f6590 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id200b8e2f268743998d4f4c92c52f6590 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id200b8e2f268743998d4f4c92c52f6590 div ul li").each(function(){		  
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
			$("#id200b8e2f268743998d4f4c92c52f6590 div ul li").each(function(){		  
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
		styleString += "#id200b8e2f268743998d4f4c92c52f6590 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id200b8e2f268743998d4f4c92c52f6590 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id200b8e2f268743998d4f4c92c52f6590 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id200b8e2f268743998d4f4c92c52f6590 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id200b8e2f268743998d4f4c92c52f6590 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id200b8e2f268743998d4f4c92c52f6590 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id200b8e2f268743998d4f4c92c52f6590 input{text-align:left;}"; break;
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
<div id="id337a341b7d1c43bfaefcf2404c04a257" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading68" runat="server" Text="Past Claims Count" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="10:15:15:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label91">
		<span class="label" id="label91"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label92">
		<span class="label" id="label92">0-12 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label93">
		<span class="label" id="label93">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label94">
		<span class="label" id="label94">13-24 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label95">
		<span class="label" id="label95">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label96">
		<span class="label" id="label96">25-36 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label97">
		<span class="label" id="label97">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label98">
		<span class="label" id="label98">Theft</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="THEFT0_12_MONTHS" 
		id="pb-container-list-THEFT-THEFT0_12_MONTHS">
		<asp:Label ID="lblTHEFT_THEFT0_12_MONTHS" runat="server" AssociatedControlID="THEFT__THEFT0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__THEFT0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__THEFT0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_THEFT0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT0_12_MONTHS"
			ClientValidationFunction="onValidate_THEFT__THEFT0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="THEFT0_12_AMOUNT" 
		id="pb-container-currency-THEFT-THEFT0_12_AMOUNT">
		<asp:Label ID="lblTHEFT_THEFT0_12_AMOUNT" runat="server" AssociatedControlID="THEFT__THEFT0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__THEFT0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_THEFT0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT0_12_AMOUNT"
			ClientValidationFunction="onValidate_THEFT__THEFT0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="THEFT13_24_MONTHS" 
		id="pb-container-list-THEFT-THEFT13_24_MONTHS">
		<asp:Label ID="lblTHEFT_THEFT13_24_MONTHS" runat="server" AssociatedControlID="THEFT__THEFT13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__THEFT13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__THEFT13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_THEFT13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT13_24_MONTHS"
			ClientValidationFunction="onValidate_THEFT__THEFT13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="THEFT13_24_AMOUNT" 
		id="pb-container-currency-THEFT-THEFT13_24_AMOUNT">
		<asp:Label ID="lblTHEFT_THEFT13_24_AMOUNT" runat="server" AssociatedControlID="THEFT__THEFT13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__THEFT13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_THEFT13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT13_24_AMOUNT"
			ClientValidationFunction="onValidate_THEFT__THEFT13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="THEFT" 
		data-property-name="THEFT25_36_MONTHS" 
		id="pb-container-list-THEFT-THEFT25_36_MONTHS">
		<asp:Label ID="lblTHEFT_THEFT25_36_MONTHS" runat="server" AssociatedControlID="THEFT__THEFT25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="THEFT__THEFT25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_THEFT__THEFT25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valTHEFT_THEFT25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT25_36_MONTHS"
			ClientValidationFunction="onValidate_THEFT__THEFT25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="THEFT25_36_AMOUNT" 
		id="pb-container-currency-THEFT-THEFT25_36_AMOUNT">
		<asp:Label ID="lblTHEFT_THEFT25_36_AMOUNT" runat="server" AssociatedControlID="THEFT__THEFT25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__THEFT25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_THEFT25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT25_36_AMOUNT"
			ClientValidationFunction="onValidate_THEFT__THEFT25_36_AMOUNT" 
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
		
		data-object-name="THEFT" 
		data-property-name="THEFT0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-THEFT-THEFT0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="THEFT__THEFT0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="THEFT" 
		data-property-name="THEFT13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-THEFT-THEFT13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="THEFT__THEFT13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="THEFT" 
		data-property-name="THEFT25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-THEFT-THEFT25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="THEFT__THEFT25_36_MONTHSCode" runat="server" />

		

		
	
		
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
		if ($("#id337a341b7d1c43bfaefcf2404c04a257 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id337a341b7d1c43bfaefcf2404c04a257 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id337a341b7d1c43bfaefcf2404c04a257 div ul li").each(function(){		  
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
			$("#id337a341b7d1c43bfaefcf2404c04a257 div ul li").each(function(){		  
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
		styleString += "#id337a341b7d1c43bfaefcf2404c04a257 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id337a341b7d1c43bfaefcf2404c04a257 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id337a341b7d1c43bfaefcf2404c04a257 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id337a341b7d1c43bfaefcf2404c04a257 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id337a341b7d1c43bfaefcf2404c04a257 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id337a341b7d1c43bfaefcf2404c04a257 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id337a341b7d1c43bfaefcf2404c04a257 input{text-align:left;}"; break;
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
<div id="id50213236a9c5417d87bdcd76616b64cd" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading69" runat="server" Text="All Contents" /></legend>
				
				
				<div data-column-count="8" data-column-ratio="5:30:15:10:10:10:10:10" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label99">
		<span class="label" id="label99"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label100">
		<span class="label" id="label100"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label101">
		<span class="label" id="label101">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label102">
		<span class="label" id="label102">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label103">
		<span class="label" id="label103">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label104">
		<span class="label" id="label104">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label105">
		<span class="label" id="label105">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label106">
		<span class="label" id="label106">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label107">
		<span class="label" id="label107"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label108">
		<span class="label" id="label108"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="SUMINSURED" 
		id="pb-container-currency-THEFT-SUMINSURED">
		<asp:Label ID="lblTHEFT_SUMINSURED" runat="server" AssociatedControlID="THEFT__SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.SUMINSURED"
			ClientValidationFunction="onValidate_THEFT__SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT" 
		data-property-name="RATE" 
		id="pb-container-percentage-THEFT-RATE">
		<asp:Label ID="lblTHEFT_RATE" runat="server" AssociatedControlID="THEFT__RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT__RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.RATE"
			ClientValidationFunction="onValidate_THEFT__RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="PREM" 
		id="pb-container-currency-THEFT-PREM">
		<asp:Label ID="lblTHEFT_PREM" runat="server" AssociatedControlID="THEFT__PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.PREM"
			ClientValidationFunction="onValidate_THEFT__PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-THEFT-POST_PREM">
		<asp:Label ID="lblTHEFT_POST_PREM" runat="server" AssociatedControlID="THEFT__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.POST_PREM"
			ClientValidationFunction="onValidate_THEFT__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT" 
		data-property-name="FAP_PERC" 
		id="pb-container-percentage-THEFT-FAP_PERC">
		<asp:Label ID="lblTHEFT_FAP_PERC" runat="server" AssociatedControlID="THEFT__FAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT__FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.FAP_PERC"
			ClientValidationFunction="onValidate_THEFT__FAP_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="MIN_AMNT" 
		id="pb-container-currency-THEFT-MIN_AMNT">
		<asp:Label ID="lblTHEFT_MIN_AMNT" runat="server" AssociatedControlID="THEFT__MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.MIN_AMNT"
			ClientValidationFunction="onValidate_THEFT__MIN_AMNT" 
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
		if ($("#id50213236a9c5417d87bdcd76616b64cd div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id50213236a9c5417d87bdcd76616b64cd div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id50213236a9c5417d87bdcd76616b64cd div ul li").each(function(){		  
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
			$("#id50213236a9c5417d87bdcd76616b64cd div ul li").each(function(){		  
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
		styleString += "#id50213236a9c5417d87bdcd76616b64cd label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id50213236a9c5417d87bdcd76616b64cd label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id50213236a9c5417d87bdcd76616b64cd label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id50213236a9c5417d87bdcd76616b64cd label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id50213236a9c5417d87bdcd76616b64cd input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id50213236a9c5417d87bdcd76616b64cd input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id50213236a9c5417d87bdcd76616b64cd input{text-align:left;}"; break;
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
<div id="id7be93c42b4b5434b93daa856243dbd5c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading70" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="8" data-column-ratio="5:30:15:10:10:10:10:10" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label109">
		<span class="label" id="label109"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label110">
		<span class="label" id="label110"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label111">
		<span class="label" id="label111">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label112">
		<span class="label" id="label112">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label113">
		<span class="label" id="label113">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label114">
		<span class="label" id="label114">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label115">
		<span class="label" id="label115">FAP%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label116">
		<span class="label" id="label116">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTHEFT_EXTENSIONS_IS_ACPC" for="ctl00_cntMainBody_THEFT_EXTENSIONS__IS_ACPC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="IS_ACPC" 
		id="pb-container-checkbox-THEFT_EXTENSIONS-IS_ACPC">	
		
		<asp:TextBox ID="THEFT_EXTENSIONS__IS_ACPC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_IS_ACPC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.IS_ACPC"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__IS_ACPC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label117">
		<span class="label" id="label117">Additional Claims Preparation Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ACPC_LIMIT" 
		id="pb-container-currency-THEFT_EXTENSIONS-ACPC_LIMIT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ACPC_LIMIT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ACPC_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ACPC_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ACPC_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ACPC_LIMIT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ACPC_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ACPC_RATE" 
		id="pb-container-percentage-THEFT_EXTENSIONS-ACPC_RATE">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ACPC_RATE" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ACPC_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__ACPC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ACPC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ACPC_RATE"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ACPC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ACPC_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-ACPC_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ACPC_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ACPC_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ACPC_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ACPC_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ACPC_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ACPC_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ACPC_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-ACPC_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ACPC_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ACPC_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ACPC_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ACPC_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ACPC_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ACPC_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label118">
		<span class="label" id="label118"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label119">
		<span class="label" id="label119"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTHEFT_EXTENSIONS_IS_ADB" for="ctl00_cntMainBody_THEFT_EXTENSIONS__IS_ADB" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="IS_ADB" 
		id="pb-container-checkbox-THEFT_EXTENSIONS-IS_ADB">	
		
		<asp:TextBox ID="THEFT_EXTENSIONS__IS_ADB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_IS_ADB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.IS_ADB"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__IS_ADB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label120">
		<span class="label" id="label120">Additional Damage to Building</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ADB_LIMIT" 
		id="pb-container-currency-THEFT_EXTENSIONS-ADB_LIMIT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ADB_LIMIT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ADB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ADB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ADB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ADB_LIMIT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ADB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ADB_RATE" 
		id="pb-container-percentage-THEFT_EXTENSIONS-ADB_RATE">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ADB_RATE" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ADB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__ADB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ADB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ADB_RATE"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ADB_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ADB_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-ADB_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ADB_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ADB_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ADB_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ADB_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ADB_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ADB_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="ADB_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-ADB_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_ADB_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__ADB_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__ADB_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_ADB_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.ADB_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__ADB_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label121">
		<span class="label" id="label121"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label122">
		<span class="label" id="label122"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTHEFT_EXTENSIONS_IS_LOSS" for="ctl00_cntMainBody_THEFT_EXTENSIONS__IS_LOSS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="IS_LOSS" 
		id="pb-container-checkbox-THEFT_EXTENSIONS-IS_LOSS">	
		
		<asp:TextBox ID="THEFT_EXTENSIONS__IS_LOSS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_IS_LOSS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.IS_LOSS"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__IS_LOSS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label123">
		<span class="label" id="label123">Losses in the Open at the Insured Premises</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_LIMIT" 
		id="pb-container-currency-THEFT_EXTENSIONS-LOSS_LIMIT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_LIMIT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_LIMIT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_RATE" 
		id="pb-container-percentage-THEFT_EXTENSIONS-LOSS_RATE">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_RATE" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_RATE"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-LOSS_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-LOSS_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_FAP_PERC" 
		id="pb-container-percentage-THEFT_EXTENSIONS-LOSS_FAP_PERC">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_FAP_PERC" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_FAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_FAP_PERC"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_FAP_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="LOSS_MIN_AMNT" 
		id="pb-container-currency-THEFT_EXTENSIONS-LOSS_MIN_AMNT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_LOSS_MIN_AMNT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__LOSS_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__LOSS_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_LOSS_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.LOSS_MIN_AMNT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__LOSS_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblTHEFT_EXTENSIONS_IS_MD" for="ctl00_cntMainBody_THEFT_EXTENSIONS__IS_MD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="IS_MD" 
		id="pb-container-checkbox-THEFT_EXTENSIONS-IS_MD">	
		
		<asp:TextBox ID="THEFT_EXTENSIONS__IS_MD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_IS_MD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.IS_MD"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__IS_MD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label124">
		<span class="label" id="label124">Malicious Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="MD_LIMIT" 
		id="pb-container-currency-THEFT_EXTENSIONS-MD_LIMIT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_MD_LIMIT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__MD_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__MD_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_MD_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.MD_LIMIT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__MD_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="MD_RATE" 
		id="pb-container-percentage-THEFT_EXTENSIONS-MD_RATE">
		<asp:Label ID="lblTHEFT_EXTENSIONS_MD_RATE" runat="server" AssociatedControlID="THEFT_EXTENSIONS__MD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__MD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_MD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.MD_RATE"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__MD_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="MD_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-MD_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_MD_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__MD_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__MD_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_MD_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.MD_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__MD_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="MD_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-MD_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_MD_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__MD_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__MD_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_MD_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.MD_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__MD_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label125">
		<span class="label" id="label125"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label126">
		<span class="label" id="label126"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTHEFT_EXTENSIONS_IS_PETROL" for="ctl00_cntMainBody_THEFT_EXTENSIONS__IS_PETROL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="IS_PETROL" 
		id="pb-container-checkbox-THEFT_EXTENSIONS-IS_PETROL">	
		
		<asp:TextBox ID="THEFT_EXTENSIONS__IS_PETROL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_IS_PETROL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.IS_PETROL"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__IS_PETROL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label127">
		<span class="label" id="label127">Petrol in Underground Tanks</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_LIMIT" 
		id="pb-container-currency-THEFT_EXTENSIONS-PETROL_LIMIT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_LIMIT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_LIMIT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_RATE" 
		id="pb-container-percentage-THEFT_EXTENSIONS-PETROL_RATE">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_RATE" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_RATE"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-PETROL_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-PETROL_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_FAP_PERC" 
		id="pb-container-percentage-THEFT_EXTENSIONS-PETROL_FAP_PERC">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_FAP_PERC" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_FAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_FAP_PERC"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_FAP_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="PETROL_MIN_AMNT" 
		id="pb-container-currency-THEFT_EXTENSIONS-PETROL_MIN_AMNT">
		<asp:Label ID="lblTHEFT_EXTENSIONS_PETROL_MIN_AMNT" runat="server" AssociatedControlID="THEFT_EXTENSIONS__PETROL_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__PETROL_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_PETROL_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.PETROL_MIN_AMNT"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__PETROL_MIN_AMNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label128">
		<span class="label" id="label128"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label129">
		<span class="label" id="label129">Total</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label130">
		<span class="label" id="label130"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label131">
		<span class="label" id="label131"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="TOT_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-TOT_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_TOT_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__TOT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__TOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_TOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.TOT_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__TOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT_EXTENSIONS" 
		data-property-name="TOT_POST_PREM" 
		id="pb-container-currency-THEFT_EXTENSIONS-TOT_POST_PREM">
		<asp:Label ID="lblTHEFT_EXTENSIONS_TOT_POST_PREM" runat="server" AssociatedControlID="THEFT_EXTENSIONS__TOT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT_EXTENSIONS__TOT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_EXTENSIONS_TOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_EXTENSIONS.TOT_POST_PREM"
			ClientValidationFunction="onValidate_THEFT_EXTENSIONS__TOT_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label132">
		<span class="label" id="label132"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label133">
		<span class="label" id="label133"></span>
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
		if ($("#id7be93c42b4b5434b93daa856243dbd5c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id7be93c42b4b5434b93daa856243dbd5c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id7be93c42b4b5434b93daa856243dbd5c div ul li").each(function(){		  
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
			$("#id7be93c42b4b5434b93daa856243dbd5c div ul li").each(function(){		  
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
		styleString += "#id7be93c42b4b5434b93daa856243dbd5c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id7be93c42b4b5434b93daa856243dbd5c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7be93c42b4b5434b93daa856243dbd5c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7be93c42b4b5434b93daa856243dbd5c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id7be93c42b4b5434b93daa856243dbd5c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7be93c42b4b5434b93daa856243dbd5c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7be93c42b4b5434b93daa856243dbd5c input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading71" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblTHEFT_THEFT_CLAUSES" runat="server" AssociatedControlID="THEFT__THEFT_CLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="THEFT__THEFT_CLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="THEFT" 
		data-property-name="THEFT_COUNT" 
		id="pb-container-integer-THEFT-THEFT_COUNT">
		<asp:Label ID="lblTHEFT_THEFT_COUNT" runat="server" AssociatedControlID="THEFT__THEFT_COUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="THEFT__THEFT_COUNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valTHEFT_THEFT_COUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT.THEFT_COUNT"
			ClientValidationFunction="onValidate_THEFT__THEFT_COUNT" 
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
<div id="id81b860b1ce96423b85e850c4b4c7d574" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading72" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="THEFT" 
		data-property-name="TOT_END_PREM" 
		id="pb-container-currency-THEFT-TOT_END_PREM">
		<asp:Label ID="lblTHEFT_TOT_END_PREM" runat="server" AssociatedControlID="THEFT__TOT_END_PREM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="THEFT__TOT_END_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTHEFT_TOT_END_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_THEFT__TOT_END_PREM" 
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
		if ($("#id81b860b1ce96423b85e850c4b4c7d574 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id81b860b1ce96423b85e850c4b4c7d574 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id81b860b1ce96423b85e850c4b4c7d574 div ul li").each(function(){		  
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
			$("#id81b860b1ce96423b85e850c4b4c7d574 div ul li").each(function(){		  
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
		styleString += "#id81b860b1ce96423b85e850c4b4c7d574 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id81b860b1ce96423b85e850c4b4c7d574 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id81b860b1ce96423b85e850c4b4c7d574 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id81b860b1ce96423b85e850c4b4c7d574 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id81b860b1ce96423b85e850c4b4c7d574 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id81b860b1ce96423b85e850c4b4c7d574 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id81b860b1ce96423b85e850c4b4c7d574 input{text-align:left;}"; break;
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
<div id="id26a87fff7fb44ae3a97d006ed9fc752c" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading73" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_THEFT__MATHEFTEND"
		data-field-type="Child" 
		data-object-name="THEFT" 
		data-property-name="MATHEFTEND" 
		id="pb-container-childscreen-THEFT-MATHEFTEND">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="THEFT__THEFT_CLAUSEPREM" runat="server" ScreenCode="MATHEFTEND" AutoGenerateColumns="false"
							GridLines="None" ChildPage="MATHEFTEND/MATHEFTEND_Endorsement_Premium.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valTHEFT_MATHEFTEND" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for THEFT.MATHEFTEND"
						ClientValidationFunction="onValidate_THEFT__MATHEFTEND" 
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
		if ($("#id26a87fff7fb44ae3a97d006ed9fc752c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id26a87fff7fb44ae3a97d006ed9fc752c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id26a87fff7fb44ae3a97d006ed9fc752c div ul li").each(function(){		  
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
			$("#id26a87fff7fb44ae3a97d006ed9fc752c div ul li").each(function(){		  
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
		styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id26a87fff7fb44ae3a97d006ed9fc752c input{text-align:left;}"; break;
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
<div id="id7357c4cb1899444aa32a9b1431a65839" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading74" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_THEFT_NOTES__THEFTNOTE"
		data-field-type="Child" 
		data-object-name="THEFT_NOTES" 
		data-property-name="THEFTNOTE" 
		id="pb-container-childscreen-THEFT_NOTES-THEFTNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="THEFT_NOTES__THEFT_CNOTES_DETAILS" runat="server" ScreenCode="THEFTNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="THEFTNOTE/THEFTNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valTHEFT_NOTES_THEFTNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for THEFT_NOTES.THEFTNOTE"
						ClientValidationFunction="onValidate_THEFT_NOTES__THEFTNOTE" 
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
		if ($("#id7357c4cb1899444aa32a9b1431a65839 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id7357c4cb1899444aa32a9b1431a65839 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id7357c4cb1899444aa32a9b1431a65839 div ul li").each(function(){		  
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
			$("#id7357c4cb1899444aa32a9b1431a65839 div ul li").each(function(){		  
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
		styleString += "#id7357c4cb1899444aa32a9b1431a65839 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id7357c4cb1899444aa32a9b1431a65839 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7357c4cb1899444aa32a9b1431a65839 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7357c4cb1899444aa32a9b1431a65839 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id7357c4cb1899444aa32a9b1431a65839 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7357c4cb1899444aa32a9b1431a65839 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7357c4cb1899444aa32a9b1431a65839 input{text-align:left;}"; break;
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
<div id="idbd40678f07694dae89b9d53e5cf2a9fc" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading75" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_THEFT_NOTES__THEFTSNOTE"
		data-field-type="Child" 
		data-object-name="THEFT_NOTES" 
		data-property-name="THEFTSNOTE" 
		id="pb-container-childscreen-THEFT_NOTES-THEFTSNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="THEFT_NOTES__THEFT_SCNOTES_DETAILS" runat="server" ScreenCode="THEFTSNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="THEFTSNOTE/THEFTSNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valTHEFT_NOTES_THEFTSNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for THEFT_NOTES.THEFTSNOTE"
						ClientValidationFunction="onValidate_THEFT_NOTES__THEFTSNOTE" 
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
		data-object-name="THEFT_NOTES" 
		data-property-name="TFT_NTS_CNT" 
		id="pb-container-integer-THEFT_NOTES-TFT_NTS_CNT">
		<asp:Label ID="lblTHEFT_NOTES_TFT_NTS_CNT" runat="server" AssociatedControlID="THEFT_NOTES__TFT_NTS_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="THEFT_NOTES__TFT_NTS_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valTHEFT_NOTES_TFT_NTS_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for THEFT_NOTES.TFT_NTS_CNT"
			ClientValidationFunction="onValidate_THEFT_NOTES__TFT_NTS_CNT" 
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
		if ($("#idbd40678f07694dae89b9d53e5cf2a9fc div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idbd40678f07694dae89b9d53e5cf2a9fc div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idbd40678f07694dae89b9d53e5cf2a9fc div ul li").each(function(){		  
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
			$("#idbd40678f07694dae89b9d53e5cf2a9fc div ul li").each(function(){		  
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
		styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbd40678f07694dae89b9d53e5cf2a9fc input{text-align:left;}"; break;
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