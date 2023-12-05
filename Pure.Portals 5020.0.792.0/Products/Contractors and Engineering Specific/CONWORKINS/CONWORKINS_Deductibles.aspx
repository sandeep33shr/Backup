<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CONWORKINS_Deductibles.aspx.vb" Inherits="Nexus.PB2_CONWORKINS_Deductibles" %>

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
function onValidate_CW_RISK__DEDE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CW_RISK", "DEDE", "ChildScreen");
        })();
}
function onValidate_NB_DEDUCT__IS_MAJOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_MAJOR", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__MAJOR_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MAJOR_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "MAJOR_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MAJOR == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "MAJOR_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MAJOR_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=MAJOR_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 0")) ? new Expression("NB_DEDUCT.IS_MAJOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Major Perils Deductible % cannot be more than 100%")) ? "Major Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "MAJOR_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "MAJOR_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.MAJOR_DED == '' OR NB_DEDUCT.MAJOR_DED == null) OR ((NB_DEDUCT.MAJOR_DED > 0 AND NB_DEDUCT.MAJOR_DED <= 100) AND (NB_DEDUCT.MAJOR_DED <> '' AND NB_DEDUCT.MAJOR_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__MAJOR_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MAJOR_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MAJOR_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MAJOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MAJOR_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MAJOR_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 0")) ? new Expression("NB_DEDUCT.IS_MAJOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__MAJOR_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MAJOR_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MAJOR_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MAJOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MAJOR_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MAJOR_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 0")) ? new Expression("NB_DEDUCT.IS_MAJOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Major Perils Maximum Amount must be greater than the Minimum Amount")) ? "Major Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "MAJOR_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "MAJOR_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.MAJOR_MAX = '' OR NB_DEDUCT.MAJOR_MAX = null) || (NB_DEDUCT.MAJOR_MAX > NB_DEDUCT.MAJOR_MIN && (NB_DEDUCT.MAJOR_MIN <> '' OR NB_DEDUCT.MAJOR_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__MAJOR_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MAJOR_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MAJOR_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MAJOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MAJOR_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MAJOR_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 0")) ? new Expression("NB_DEDUCT.IS_MAJOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__MAJOR_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MAJOR_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "MAJOR_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_MAJOR == 1 AND (NB_DEDUCT.MAJOR_DED <> '' AND NB_DEDUCT.MAJOR_DED <> null)", "V", "Major Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_MAJOR == 1 AND (NB_DEDUCT.MAJOR_DED <> '' AND NB_DEDUCT.MAJOR_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Major Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "MAJOR_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 1 AND (NB_DEDUCT.MAJOR_DED <> '' AND NB_DEDUCT.MAJOR_DED <> null)")) ? new Expression("NB_DEDUCT.IS_MAJOR == 1 AND (NB_DEDUCT.MAJOR_DED <> '' AND NB_DEDUCT.MAJOR_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=MAJOR_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MAJOR == 0")) ? new Expression("NB_DEDUCT.IS_MAJOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_MINOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_MINOR", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__MINOR_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MINOR_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "MINOR_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MINOR == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "MINOR_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MINOR_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=MINOR_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 0")) ? new Expression("NB_DEDUCT.IS_MINOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Minor Perils Deductible % cannot be more than 100%")) ? "Minor Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "MINOR_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "MINOR_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.MINOR_DED == '' OR NB_DEDUCT.MINOR_DED == null) OR (NB_DEDUCT.MINOR_DED > 0 AND NB_DEDUCT.MINOR_DED <= 100 AND (NB_DEDUCT.MINOR_DED <> '' AND NB_DEDUCT.MINOR_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__MINOR_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MINOR_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MINOR_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MINOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MINOR_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MINOR_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 0")) ? new Expression("NB_DEDUCT.IS_MINOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__MINOR_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MINOR_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MINOR_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MINOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MINOR_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MINOR_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 0")) ? new Expression("NB_DEDUCT.IS_MINOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Minor Perils Maximum Amount must be greater than the Minimum Amount")) ? "Minor Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "MINOR_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "MINOR_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.MINOR_MAX = '' OR NB_DEDUCT.MINOR_MAX = null) || (NB_DEDUCT.MINOR_MAX > NB_DEDUCT.MINOR_MIN && (NB_DEDUCT.MINOR_MIN <> '' OR NB_DEDUCT.MINOR_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__MINOR_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MINOR_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "MINOR_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_MINOR == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'MINOR_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=MINOR_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 0")) ? new Expression("NB_DEDUCT.IS_MINOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__MINOR_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "MINOR_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "MINOR_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_MINOR == 1 AND (NB_DEDUCT.MINOR_DED <> '' AND NB_DEDUCT.MINOR_DED <> null)", "V", "Minor Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_MINOR == 1 AND (NB_DEDUCT.MINOR_DED <> '' AND NB_DEDUCT.MINOR_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Minor Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "MINOR_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 1 AND (NB_DEDUCT.MINOR_DED <> '' AND NB_DEDUCT.MINOR_DED <> null)")) ? new Expression("NB_DEDUCT.IS_MINOR == 1 AND (NB_DEDUCT.MINOR_DED <> '' AND NB_DEDUCT.MINOR_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=MINOR_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_MINOR == 0")) ? new Expression("NB_DEDUCT.IS_MINOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_THEFT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_THEFT", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__THEFT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "THEFT_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "THEFT_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_THEFT == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "THEFT_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'THEFT_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=THEFT_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 0")) ? new Expression("NB_DEDUCT.IS_THEFT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Theft, Malicious Damage Deductible % cannot be more than 100%")) ? "Theft, Malicious Damage Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "THEFT_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "THEFT_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.THEFT_DED == '' OR NB_DEDUCT.THEFT_DED == null) OR (NB_DEDUCT.THEFT_DED > 0 AND NB_DEDUCT.THEFT_DED <= 100 AND (NB_DEDUCT.THEFT_DED <> '' AND NB_DEDUCT.THEFT_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__THEFT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "THEFT_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "THEFT_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_THEFT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'THEFT_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=THEFT_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 0")) ? new Expression("NB_DEDUCT.IS_THEFT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__THEFT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "THEFT_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "THEFT_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_THEFT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'THEFT_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=THEFT_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 0")) ? new Expression("NB_DEDUCT.IS_THEFT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Theft, Malicious Damage Maximum Amount must be greater than the Minimum Amount")) ? "Theft, Malicious Damage Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "THEFT_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "THEFT_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.THEFT_MAX = '' OR NB_DEDUCT.THEFT_MAX = null) || (NB_DEDUCT.THEFT_MAX > NB_DEDUCT.THEFT_MIN && (NB_DEDUCT.THEFT_MIN <> '' OR NB_DEDUCT.THEFT_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__THEFT_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "THEFT_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "THEFT_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_THEFT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'THEFT_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=THEFT_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 0")) ? new Expression("NB_DEDUCT.IS_THEFT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__THEFT_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "THEFT_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "THEFT_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_THEFT == 1 AND (NB_DEDUCT.THEFT_DED <> '' AND NB_DEDUCT.THEFT_DED <> null)", "V", "Theft, Malicious Damage Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_THEFT == 1 AND (NB_DEDUCT.THEFT_DED <> '' AND NB_DEDUCT.THEFT_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Theft, Malicious Damage Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "THEFT_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 1 AND (NB_DEDUCT.THEFT_DED <> '' AND NB_DEDUCT.THEFT_DED <> null)")) ? new Expression("NB_DEDUCT.IS_THEFT == 1 AND (NB_DEDUCT.THEFT_DED <> '' AND NB_DEDUCT.THEFT_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=THEFT_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_THEFT == 0")) ? new Expression("NB_DEDUCT.IS_THEFT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_TRANSIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_TRANSIT", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__TRANSIT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "TRANSIT_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "TRANSIT_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_TRANSIT == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "TRANSIT_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'TRANSIT_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=TRANSIT_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 0")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Transit Deductible % cannot be more than 100%")) ? "Transit Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "TRANSIT_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "TRANSIT_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.TRANSIT_DED == '' OR NB_DEDUCT.TRANSIT_DED == null) OR (NB_DEDUCT.TRANSIT_DED > 0 AND NB_DEDUCT.TRANSIT_DED <= 100 AND (NB_DEDUCT.TRANSIT_DED <> '' AND NB_DEDUCT.TRANSIT_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__TRANSIT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "TRANSIT_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "TRANSIT_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_TRANSIT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'TRANSIT_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=TRANSIT_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 0")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__TRANSIT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "TRANSIT_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "TRANSIT_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_TRANSIT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'TRANSIT_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=TRANSIT_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 0")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Transit Maximum Amount must be greater than the Minimum Amount")) ? "Transit Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "TRANSIT_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "TRANSIT_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.TRANSIT_MAX = '' OR NB_DEDUCT.TRANSIT_MAX = null) || (NB_DEDUCT.TRANSIT_MAX > NB_DEDUCT.TRANSIT_MIN && (NB_DEDUCT.TRANSIT_MIN <> '' OR NB_DEDUCT.TRANSIT_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__TRANSIT_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "TRANSIT_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "TRANSIT_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_TRANSIT == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'TRANSIT_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=TRANSIT_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 0")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__TRANSIT_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "TRANSIT_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "TRANSIT_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_TRANSIT == 1 AND (NB_DEDUCT.TRANSIT_DED <> '' AND NB_DEDUCT.TRANSIT_DED <> null)", "V", "Transit Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_TRANSIT == 1 AND (NB_DEDUCT.TRANSIT_DED <> '' AND NB_DEDUCT.TRANSIT_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Transit Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "TRANSIT_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 1 AND (NB_DEDUCT.TRANSIT_DED <> '' AND NB_DEDUCT.TRANSIT_DED <> null)")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 1 AND (NB_DEDUCT.TRANSIT_DED <> '' AND NB_DEDUCT.TRANSIT_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=TRANSIT_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_TRANSIT == 0")) ? new Expression("NB_DEDUCT.IS_TRANSIT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_SURRP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_SURRP", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__SURRP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "SURRP_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "SURRP_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_SURRP == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "SURRP_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'SURRP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=SURRP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 0")) ? new Expression("NB_DEDUCT.IS_SURRP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Surrounding Property Deductible % cannot be more than 100%")) ? "Surrounding Property Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "SURRP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "SURRP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.SURRP_DED == '' OR NB_DEDUCT.SURRP_DED == null) OR (NB_DEDUCT.SURRP_DED > 0 AND NB_DEDUCT.SURRP_DED <= 100 AND (NB_DEDUCT.SURRP_DED <> '' AND NB_DEDUCT.SURRP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__SURRP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "SURRP_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "SURRP_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_SURRP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'SURRP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=SURRP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 0")) ? new Expression("NB_DEDUCT.IS_SURRP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__SURRP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "SURRP_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "SURRP_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_SURRP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'SURRP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=SURRP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 0")) ? new Expression("NB_DEDUCT.IS_SURRP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Surrounding Property Maximum Amount must be greater than the Minimum Amount")) ? "Surrounding Property Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "SURRP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "SURRP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.SURRP_MAX = '' OR NB_DEDUCT.SURRP_MAX = null) || (NB_DEDUCT.SURRP_MAX > NB_DEDUCT.SURRP_MIN && (NB_DEDUCT.SURRP_MIN <> '' OR NB_DEDUCT.SURRP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__SURRP_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "SURRP_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "SURRP_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_SURRP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'SURRP_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=SURRP_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 0")) ? new Expression("NB_DEDUCT.IS_SURRP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__SURRP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "SURRP_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "SURRP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_SURRP == 1 AND (NB_DEDUCT.SURRP_DED <> '' AND NB_DEDUCT.SURRP_DED <> null)", "V", "Surrounding Property Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_SURRP == 1 AND (NB_DEDUCT.SURRP_DED <> '' AND NB_DEDUCT.SURRP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Surrounding Property Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "SURRP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 1 AND (NB_DEDUCT.SURRP_DED <> '' AND NB_DEDUCT.SURRP_DED <> null)")) ? new Expression("NB_DEDUCT.IS_SURRP == 1 AND (NB_DEDUCT.SURRP_DED <> '' AND NB_DEDUCT.SURRP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=SURRP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_SURRP == 0")) ? new Expression("NB_DEDUCT.IS_SURRP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_FIREP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_FIREP", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__FIREP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "FIREP_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "FIREP_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_FIREP == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "FIREP_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'FIREP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=FIREP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 0")) ? new Expression("NB_DEDUCT.IS_FIREP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Fire Perils Deductible % cannot be more than 100%")) ? "Fire Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "FIREP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "FIREP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.FIREP_DED == '' OR NB_DEDUCT.FIREP_DED == null) OR (NB_DEDUCT.FIREP_DED > 0 AND NB_DEDUCT.FIREP_DED <= 100 AND (NB_DEDUCT.FIREP_DED <> '' AND NB_DEDUCT.FIREP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__FIREP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "FIREP_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "FIREP_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_FIREP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'FIREP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=FIREP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 0")) ? new Expression("NB_DEDUCT.IS_FIREP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__FIREP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "FIREP_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "FIREP_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_FIREP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'FIREP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=FIREP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 0")) ? new Expression("NB_DEDUCT.IS_FIREP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Fire Perils Maximum Amount must be greater than the Minimum Amount")) ? "Fire Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "FIREP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "FIREP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.FIREP_MAX = '' OR NB_DEDUCT.FIREP_MAX = null) || (NB_DEDUCT.FIREP_MAX > NB_DEDUCT.FIREP_MIN && (NB_DEDUCT.FIREP_MIN <> '' OR NB_DEDUCT.FIREP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__FIREP_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "FIREP_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "FIREP_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_FIREP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'FIREP_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=FIREP_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 0")) ? new Expression("NB_DEDUCT.IS_FIREP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__FIREP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "FIREP_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "FIREP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_FIREP == 1 AND (NB_DEDUCT.FIREP_DED <> '' AND NB_DEDUCT.FIREP_DED <> null)", "V", "Fire Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_FIREP == 1 AND (NB_DEDUCT.FIREP_DED <> '' AND NB_DEDUCT.FIREP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Fire Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "FIREP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 1 AND (NB_DEDUCT.FIREP_DED <> '' AND NB_DEDUCT.FIREP_DED <> null)")) ? new Expression("NB_DEDUCT.IS_FIREP == 1 AND (NB_DEDUCT.FIREP_DED <> '' AND NB_DEDUCT.FIREP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=FIREP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_FIREP == 0")) ? new Expression("NB_DEDUCT.IS_FIREP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__IS_ALLP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "IS_ALLP", "Checkbox");
        })();
}
function onValidate_NB_DEDUCT__ALLP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "ALLP_DED", "Percentage");
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
        			field = Field.getInstance("NB_DEDUCT", "ALLP_DED");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_ALLP == 1",
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
        		var field = Field.getInstance("NB_DEDUCT", "ALLP_DED");
        		
        		
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'ALLP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=NB_DEDUCT&propertyName=ALLP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 0")) ? new Expression("NB_DEDUCT.IS_ALLP == 0") : null, 
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
        			var message = (Expression.isValidParameter("All Perils Deductible % cannot be more than 100%")) ? "All Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "ALLP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "ALLP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.ALLP_DED == '' OR NB_DEDUCT.ALLP_DED == null) OR (NB_DEDUCT.ALLP_DED > 0 AND NB_DEDUCT.ALLP_DED <= 100 AND (NB_DEDUCT.ALLP_DED <> '' AND NB_DEDUCT.ALLP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__ALLP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "ALLP_MIN", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "ALLP_MIN");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_ALLP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'ALLP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=ALLP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 0")) ? new Expression("NB_DEDUCT.IS_ALLP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__ALLP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "ALLP_MAX", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "ALLP_MAX");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_ALLP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'ALLP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=ALLP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 0")) ? new Expression("NB_DEDUCT.IS_ALLP == 0") : null, 
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
        			var message = (Expression.isValidParameter("All Perils Maximum Amount must be greater than the Minimum Amount")) ? "All Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "__" + "ALLP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "NB_DEDUCT".toUpperCase() + "_" + "ALLP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(NB_DEDUCT.ALLP_MAX = '' OR NB_DEDUCT.ALLP_MAX = null) || (NB_DEDUCT.ALLP_MAX > NB_DEDUCT.ALLP_MIN && (NB_DEDUCT.ALLP_MIN <> '' OR NB_DEDUCT.ALLP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_NB_DEDUCT__ALLP_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "ALLP_EVENT", "Currency");
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
        			field = Field.getInstance("NB_DEDUCT", "ALLP_EVENT");
        		}
        		//window.setProperty(field, "VE", "NB_DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "NB_DEDUCT.IS_ALLP == 1",
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
        
        			var field = Field.getInstance('NB_DEDUCT', 'ALLP_EVENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=NB_DEDUCT&propertyName=ALLP_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 0")) ? new Expression("NB_DEDUCT.IS_ALLP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__ALLP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "ALLP_BASIS", "List");
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
        			field = Field.getInstance("NB_DEDUCT", "ALLP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "NB_DEDUCT.IS_ALLP == 1 AND (NB_DEDUCT.ALLP_DED <> '' AND NB_DEDUCT.ALLP_DED <> null)", "V", "All Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "NB_DEDUCT.IS_ALLP == 1 AND (NB_DEDUCT.ALLP_DED <> '' AND NB_DEDUCT.ALLP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "All Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("NB_DEDUCT", "ALLP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 1 AND (NB_DEDUCT.ALLP_DED <> '' AND NB_DEDUCT.ALLP_DED <> null)")) ? new Expression("NB_DEDUCT.IS_ALLP == 1 AND (NB_DEDUCT.ALLP_DED <> '' AND NB_DEDUCT.ALLP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=NB_DEDUCT&propertyName=ALLP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("NB_DEDUCT.IS_ALLP == 0")) ? new Expression("NB_DEDUCT.IS_ALLP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_NB_DEDUCT__NONDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NB_DEDUCT", "NONDED", "ChildScreen");
        })();
}
function onValidate_DEDUCT__IS_MAJOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_MAJOR", "Checkbox");
        })();
}
function onValidate_DEDUCT__MAJOR_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MAJOR_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "MAJOR_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MAJOR == 1",
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
        		var field = Field.getInstance("DEDUCT", "MAJOR_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'MAJOR_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=MAJOR_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MAJOR == 0")) ? new Expression("DEDUCT.IS_MAJOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Major Perils Deductible % cannot be more than 100%")) ? "Major Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "MAJOR_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "MAJOR_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.MAJOR_DED == '' OR DEDUCT.MAJOR_DED == null) OR (DEDUCT.MAJOR_DED > 0 AND DEDUCT.MAJOR_DED <= 100 AND (DEDUCT.MAJOR_DED <> '' AND DEDUCT.MAJOR_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__MAJOR_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MAJOR_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "MAJOR_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MAJOR == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'MAJOR_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=MAJOR_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MAJOR == 0")) ? new Expression("DEDUCT.IS_MAJOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__MAJOR_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MAJOR_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "MAJOR_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MAJOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MAJOR == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'MAJOR_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=MAJOR_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MAJOR == 0")) ? new Expression("DEDUCT.IS_MAJOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Major Perils Maximum Amount must be greater than the Minimum Amount")) ? "Major Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "MAJOR_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "MAJOR_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.MAJOR_MAX = '' OR DEDUCT.MAJOR_MAX = null) || (DEDUCT.MAJOR_MAX > DEDUCT.MAJOR_MIN && (DEDUCT.MAJOR_MIN <> '' OR DEDUCT.MAJOR_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__MAJOR_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MAJOR_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "MAJOR_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_MAJOR == 1 AND (DEDUCT.MAJOR_DED <> '' AND DEDUCT.MAJOR_DED <> null)", "V", "Major Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_MAJOR == 1 AND (DEDUCT.MAJOR_DED <> '' AND DEDUCT.MAJOR_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Major Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "MAJOR_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_MAJOR == 1 AND (DEDUCT.MAJOR_DED <> '' AND DEDUCT.MAJOR_DED <> null)")) ? new Expression("DEDUCT.IS_MAJOR == 1 AND (DEDUCT.MAJOR_DED <> '' AND DEDUCT.MAJOR_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=MAJOR_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MAJOR == 0")) ? new Expression("DEDUCT.IS_MAJOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_MINOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_MINOR", "Checkbox");
        })();
}
function onValidate_DEDUCT__MINOR_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MINOR_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "MINOR_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MINOR == 1",
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
        		var field = Field.getInstance("DEDUCT", "MINOR_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'MINOR_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=MINOR_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MINOR == 0")) ? new Expression("DEDUCT.IS_MINOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Minor Perils Deductible % cannot be more than 100%")) ? "Minor Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "MINOR_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "MINOR_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.MINOR_DED == '' OR DEDUCT.MINOR_DED == null) OR (DEDUCT.MINOR_DED > 0 AND DEDUCT.MINOR_DED <= 100 AND (DEDUCT.MINOR_DED <> '' AND DEDUCT.MINOR_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__MINOR_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MINOR_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "MINOR_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MINOR == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'MINOR_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=MINOR_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MINOR == 0")) ? new Expression("DEDUCT.IS_MINOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__MINOR_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MINOR_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "MINOR_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_MINOR == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_MINOR == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'MINOR_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=MINOR_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MINOR == 0")) ? new Expression("DEDUCT.IS_MINOR == 0") : null, 
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
        			var message = (Expression.isValidParameter("Minor Perils Maximum Amount must be greater than the Minimum Amount")) ? "Minor Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "MINOR_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "MINOR_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.MINOR_MAX = '' OR DEDUCT.MINOR_MAX = null) || (DEDUCT.MINOR_MAX > DEDUCT.MINOR_MIN && (DEDUCT.MINOR_MIN <> '' OR DEDUCT.MINOR_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__MINOR_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "MINOR_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "MINOR_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_MINOR == 1 AND (DEDUCT.MINOR_DED <> '' AND DEDUCT.MINOR_DED <> null)", "V", "Minor Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_MINOR == 1 AND (DEDUCT.MINOR_DED <> '' AND DEDUCT.MINOR_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Minor Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "MINOR_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_MINOR == 1 AND (DEDUCT.MINOR_DED <> '' AND DEDUCT.MINOR_DED <> null)")) ? new Expression("DEDUCT.IS_MINOR == 1 AND (DEDUCT.MINOR_DED <> '' AND DEDUCT.MINOR_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=MINOR_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_MINOR == 0")) ? new Expression("DEDUCT.IS_MINOR == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_THEFT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_THEFT", "Checkbox");
        })();
}
function onValidate_DEDUCT__THEFT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "THEFT_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "THEFT_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_THEFT == 1",
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
        		var field = Field.getInstance("DEDUCT", "THEFT_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'THEFT_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=THEFT_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_THEFT == 0")) ? new Expression("DEDUCT.IS_THEFT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Theft, Malicious Damage Deductible % cannot be more than 100%")) ? "Theft, Malicious Damage Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "THEFT_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "THEFT_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.THEFT_DED == '' OR DEDUCT.THEFT_DED == null) OR (DEDUCT.THEFT_DED > 0 AND DEDUCT.THEFT_DED <= 100 AND (DEDUCT.THEFT_DED <> '' AND DEDUCT.THEFT_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__THEFT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "THEFT_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "THEFT_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_THEFT == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'THEFT_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=THEFT_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_THEFT == 0")) ? new Expression("DEDUCT.IS_THEFT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__THEFT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "THEFT_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "THEFT_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_THEFT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_THEFT == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'THEFT_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=THEFT_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_THEFT == 0")) ? new Expression("DEDUCT.IS_THEFT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Theft, Malicious Damage Maximum Amount must be greater than the Minimum Amount")) ? "Theft, Malicious Damage Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "THEFT_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "THEFT_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.THEFT_MAX = '' OR DEDUCT.THEFT_MAX = null) || (DEDUCT.THEFT_MAX > DEDUCT.THEFT_MIN && (DEDUCT.THEFT_MIN <> '' OR DEDUCT.THEFT_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__THEFT_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "THEFT_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "THEFT_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_THEFT == 1 AND (DEDUCT.THEFT_DED <> '' AND DEDUCT.THEFT_DED <> null)", "V", "Theft, Malicious Damage Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_THEFT == 1 AND (DEDUCT.THEFT_DED <> '' AND DEDUCT.THEFT_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Theft, Malicious Damage Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "THEFT_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_THEFT == 1 AND (DEDUCT.THEFT_DED <> '' AND DEDUCT.THEFT_DED <> null)")) ? new Expression("DEDUCT.IS_THEFT == 1 AND (DEDUCT.THEFT_DED <> '' AND DEDUCT.THEFT_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=THEFT_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_THEFT == 0")) ? new Expression("DEDUCT.IS_THEFT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_TRANSIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_TRANSIT", "Checkbox");
        })();
}
function onValidate_DEDUCT__TRANSIT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "TRANSIT_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "TRANSIT_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_TRANSIT == 1",
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
        		var field = Field.getInstance("DEDUCT", "TRANSIT_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'TRANSIT_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=TRANSIT_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_TRANSIT == 0")) ? new Expression("DEDUCT.IS_TRANSIT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Transit Deductible % cannot be more than 100%")) ? "Transit Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "TRANSIT_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "TRANSIT_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.TRANSIT_DED == '' OR DEDUCT.TRANSIT_DED == null) OR (DEDUCT.TRANSIT_DED > 0 AND DEDUCT.TRANSIT_DED <= 100 AND (DEDUCT.TRANSIT_DED <> '' AND DEDUCT.TRANSIT_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__TRANSIT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "TRANSIT_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "TRANSIT_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_TRANSIT == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'TRANSIT_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=TRANSIT_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_TRANSIT == 0")) ? new Expression("DEDUCT.IS_TRANSIT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__TRANSIT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "TRANSIT_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "TRANSIT_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_TRANSIT == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_TRANSIT == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'TRANSIT_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=TRANSIT_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_TRANSIT == 0")) ? new Expression("DEDUCT.IS_TRANSIT == 0") : null, 
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
        			var message = (Expression.isValidParameter("Transit Maximum Amount must be greater than the Minimum Amount")) ? "Transit Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "TRANSIT_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "TRANSIT_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.TRANSIT_MAX = '' OR DEDUCT.TRANSIT_MAX = null) || (DEDUCT.TRANSIT_MAX > DEDUCT.TRANSIT_MIN && (DEDUCT.TRANSIT_MIN <> '' OR DEDUCT.TRANSIT_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__TRANSIT_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "TRANSIT_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "TRANSIT_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_TRANSIT == 1 AND (DEDUCT.TRANSIT_DED <> '' AND DEDUCT.TRANSIT_DED <> null)", "V", "Transit Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_TRANSIT == 1 AND (DEDUCT.TRANSIT_DED <> '' AND DEDUCT.TRANSIT_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Transit Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "TRANSIT_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_TRANSIT == 1 AND (DEDUCT.TRANSIT_DED <> '' AND DEDUCT.TRANSIT_DED <> null)")) ? new Expression("DEDUCT.IS_TRANSIT == 1 AND (DEDUCT.TRANSIT_DED <> '' AND DEDUCT.TRANSIT_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=TRANSIT_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_TRANSIT == 0")) ? new Expression("DEDUCT.IS_TRANSIT == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_SURRP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_SURRP", "Checkbox");
        })();
}
function onValidate_DEDUCT__SURRP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "SURRP_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "SURRP_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_SURRP == 1",
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
        		var field = Field.getInstance("DEDUCT", "SURRP_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'SURRP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=SURRP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_SURRP == 0")) ? new Expression("DEDUCT.IS_SURRP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Surrounding Property Deductible % cannot be more than 100%")) ? "Surrounding Property Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "SURRP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "SURRP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.SURRP_DED == '' OR DEDUCT.SURRP_DED == null) OR (DEDUCT.SURRP_DED > 0 AND DEDUCT.SURRP_DED <= 100 AND (DEDUCT.SURRP_DED <> '' AND DEDUCT.SURRP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__SURRP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "SURRP_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "SURRP_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_SURRP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'SURRP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=SURRP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_SURRP == 0")) ? new Expression("DEDUCT.IS_SURRP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__SURRP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "SURRP_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "SURRP_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_SURRP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_SURRP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'SURRP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=SURRP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_SURRP == 0")) ? new Expression("DEDUCT.IS_SURRP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Surrounding Property Maximum Amount must be greater than the Minimum Amount")) ? "Surrounding Property Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "SURRP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "SURRP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.SURRP_MAX = '' OR DEDUCT.SURRP_MAX = null) || (DEDUCT.SURRP_MAX > DEDUCT.SURRP_MIN && (DEDUCT.SURRP_MIN <> '' OR DEDUCT.SURRP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__SURRP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "SURRP_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "SURRP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_SURRP == 1 AND (DEDUCT.SURRP_DED <> '' AND DEDUCT.SURRP_DED <> null)", "V", "Surrounding Property Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_SURRP == 1 AND (DEDUCT.SURRP_DED <> '' AND DEDUCT.SURRP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Surrounding Property Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "SURRP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_SURRP == 1 AND (DEDUCT.SURRP_DED <> '' AND DEDUCT.SURRP_DED <> null)")) ? new Expression("DEDUCT.IS_SURRP == 1 AND (DEDUCT.SURRP_DED <> '' AND DEDUCT.SURRP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=SURRP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_SURRP == 0")) ? new Expression("DEDUCT.IS_SURRP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_FIREP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_FIREP", "Checkbox");
        })();
}
function onValidate_DEDUCT__FIREP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "FIREP_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "FIREP_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_FIREP == 1",
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
        		var field = Field.getInstance("DEDUCT", "FIREP_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'FIREP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=FIREP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_FIREP == 0")) ? new Expression("DEDUCT.IS_FIREP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Fire Perils Deductible % cannot be more than 100%")) ? "Fire Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "FIREP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "FIREP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.FIREP_DED == '' OR DEDUCT.FIREP_DED == null) OR (DEDUCT.FIREP_DED > 0 AND DEDUCT.FIREP_DED <= 100 AND (DEDUCT.FIREP_DED <> '' AND DEDUCT.FIREP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__FIREP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "FIREP_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "FIREP_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_FIREP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'FIREP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=FIREP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_FIREP == 0")) ? new Expression("DEDUCT.IS_FIREP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__FIREP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "FIREP_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "FIREP_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_FIREP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_FIREP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'FIREP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=FIREP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_FIREP == 0")) ? new Expression("DEDUCT.IS_FIREP == 0") : null, 
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
        			var message = (Expression.isValidParameter("Fire Perils Maximum Amount must be greater than the Minimum Amount")) ? "Fire Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "FIREP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "FIREP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.FIREP_MAX = '' OR DEDUCT.FIREP_MAX = null) || (DEDUCT.FIREP_MAX > DEDUCT.FIREP_MIN && (DEDUCT.FIREP_MIN <> '' OR DEDUCT.FIREP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__FIREP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "FIREP_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "FIREP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_FIREP == 1 AND (DEDUCT.FIREP_DED <> '' AND DEDUCT.FIREP_DED <> null)", "V", "Fire Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_FIREP == 1 AND (DEDUCT.FIREP_DED <> '' AND DEDUCT.FIREP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "Fire Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "FIREP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_FIREP == 1 AND (DEDUCT.FIREP_DED <> '' AND DEDUCT.FIREP_DED <> null)")) ? new Expression("DEDUCT.IS_FIREP == 1 AND (DEDUCT.FIREP_DED <> '' AND DEDUCT.FIREP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=FIREP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_FIREP == 0")) ? new Expression("DEDUCT.IS_FIREP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__IS_ALLP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "IS_ALLP", "Checkbox");
        })();
}
function onValidate_DEDUCT__ALLP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "ALLP_DED", "Percentage");
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
        			field = Field.getInstance("DEDUCT", "ALLP_DED");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_ALLP == 1",
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
        		var field = Field.getInstance("DEDUCT", "ALLP_DED");
        		
        		
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
        
        			var field = Field.getInstance('DEDUCT', 'ALLP_DED');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=DEDUCT&propertyName=ALLP_DED&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_ALLP == 0")) ? new Expression("DEDUCT.IS_ALLP == 0") : null, 
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
        			var message = (Expression.isValidParameter("All Perils Deductible % cannot be more than 100%")) ? "All Perils Deductible % cannot be more than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "ALLP_DED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "ALLP_DED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.ALLP_DED == '' OR DEDUCT.ALLP_DED == null) OR (DEDUCT.ALLP_DED > 0 AND DEDUCT.ALLP_DED <= 100 AND (DEDUCT.ALLP_DED <> '' AND DEDUCT.ALLP_DED <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__ALLP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "ALLP_MIN", "Currency");
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
        			field = Field.getInstance("DEDUCT", "ALLP_MIN");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_ALLP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'ALLP_MIN');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=ALLP_MIN&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_ALLP == 0")) ? new Expression("DEDUCT.IS_ALLP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__ALLP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "ALLP_MAX", "Currency");
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
        			field = Field.getInstance("DEDUCT", "ALLP_MAX");
        		}
        		//window.setProperty(field, "VE", "DEDUCT.IS_ALLP == 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "DEDUCT.IS_ALLP == 1",
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
        
        			var field = Field.getInstance('DEDUCT', 'ALLP_MAX');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=DEDUCT&propertyName=ALLP_MAX&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_ALLP == 0")) ? new Expression("DEDUCT.IS_ALLP == 0") : null, 
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
        			var message = (Expression.isValidParameter("All Perils Maximum Amount must be greater than the Minimum Amount")) ? "All Perils Maximum Amount must be greater than the Minimum Amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "__" + "ALLP_MAX");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "DEDUCT".toUpperCase() + "_" + "ALLP_MAX");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(DEDUCT.ALLP_MAX = '' OR DEDUCT.ALLP_MAX = null) || (DEDUCT.ALLP_MAX > DEDUCT.ALLP_MIN && (DEDUCT.ALLP_MIN <> '' OR DEDUCT.ALLP_MIN <> null))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_DEDUCT__ALLP_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "ALLP_BASIS", "List");
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
        			field = Field.getInstance("DEDUCT", "ALLP_BASIS");
        		}
        		//window.setProperty(field, "VEM", "DEDUCT.IS_ALLP == 1 AND (DEDUCT.ALLP_DED <> '' AND DEDUCT.ALLP_DED <> null)", "V", "All Perils Basis of Deductible is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "DEDUCT.IS_ALLP == 1 AND (DEDUCT.ALLP_DED <> '' AND DEDUCT.ALLP_DED <> null)",
            paramElseValue = "V",
            paramValidationMessage = "All Perils Basis of Deductible is mandatory and an option must be selected";
            
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
        		var field = Field.getInstance("DEDUCT", "ALLP_BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("DEDUCT.IS_ALLP == 1 AND (DEDUCT.ALLP_DED <> '' AND DEDUCT.ALLP_DED <> null)")) ? new Expression("DEDUCT.IS_ALLP == 1 AND (DEDUCT.ALLP_DED <> '' AND DEDUCT.ALLP_DED <> null)") : null;
        		var elseColour = (Expression.isValidParameter("#00000000")) ? "#00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=DEDUCT&propertyName=ALLP_BASIS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("DEDUCT.IS_ALLP == 0")) ? new Expression("DEDUCT.IS_ALLP == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_DEDUCT__CBA_ADED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "CBA_ADED", "ChildScreen");
        })();
}
function onValidate_DEDUCT__CBA_ADED_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DEDUCT", "CBA_ADED_CNT", "Integer");
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
        			var field = Field.getInstance("DEDUCT", "CBA_ADED_CNT");
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
          * @param DEDUCT The Parent (Root) object name.
          * @param ADDDEDUC.DESCRIPTION The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "DEDUCT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "ADDDEDUC.DESCRIPTION";
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
        		
        		var field = Field.getInstance("DEDUCT", "CBA_ADED_CNT");
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
        			
        			var field = Field.getInstance("DEDUCT", "CBA_ADED_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_CW_RISK__IS_SPECIFIC_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CW_RISK", "IS_SPECIFIC_DED", "TempCheckbox");
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
        			var field = Field.getInstance("CW_RISK", "IS_SPECIFIC_DED");
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=CW_RISK&propertyName=IS_SPECIFIC_DED&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("GENERAL.PRODCODE = 'CBA'")) ? new Expression("GENERAL.PRODCODE = 'CBA'") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param CBARiskDets The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBARiskDets', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBARiskDets', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBACVals The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBACVals', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBACVals', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBAALOP The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBAALOP', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBAALOP', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBAALOPChild The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBAALOPChild', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBAALOPChild', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBADeduct The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBADeduct', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBADeduct', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBAAddDed The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBAAddDed', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBAAddDed', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CBARI The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_SPECIFIC_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CBARI', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CBARI', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_SPECIFIC_DED"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_CW_RISK__IS_ANNUAL_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CW_RISK", "IS_ANNUAL_DED", "TempCheckbox");
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
        			var field = Field.getInstance("CW_RISK", "IS_ANNUAL_DED");
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=CW_RISK&propertyName=IS_ANNUAL_DED&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("GENERAL.PRODCODE <> 'CBA'")) ? new Expression("GENERAL.PRODCODE <> 'CBA'") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmBusClass The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmBusClass', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmBusClass', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCALimits The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCALimits', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCALimits', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCAPremDets The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCAPremDets', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCAPremDets', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCAPremDets2 The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCAPremDets2', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCAPremDets2', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCADepPrem The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCADepPrem', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCADepPrem', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCADed The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCADed', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCADed', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param addDedNonBandDed The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('addDedNonBandDed', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('addDedNonBandDed', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
        /** 
         * ToggleContainer
         * @param CCANBD The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CW_RISK","IS_ANNUAL_DED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('CCANBD', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('CCANBD', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CW_RISK", "IS_ANNUAL_DED"), "change", update);
        		update();
        	}
        
        })();
}
function DoLogic(isOnLoad) {
    onValidate_CW_RISK__DEDE(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_MAJOR(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MAJOR_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MAJOR_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MAJOR_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MAJOR_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MAJOR_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_MINOR(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MINOR_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MINOR_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MINOR_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MINOR_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__MINOR_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_THEFT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__THEFT_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__THEFT_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__THEFT_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__THEFT_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__THEFT_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_TRANSIT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__TRANSIT_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__TRANSIT_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__TRANSIT_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__TRANSIT_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__TRANSIT_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_SURRP(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__SURRP_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__SURRP_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__SURRP_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__SURRP_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__SURRP_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_FIREP(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__FIREP_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__FIREP_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__FIREP_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__FIREP_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__FIREP_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__IS_ALLP(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__ALLP_DED(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__ALLP_MIN(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__ALLP_MAX(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__ALLP_EVENT(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__ALLP_BASIS(null, null, null, isOnLoad);
    onValidate_NB_DEDUCT__NONDED(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_MAJOR(null, null, null, isOnLoad);
    onValidate_DEDUCT__MAJOR_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__MAJOR_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__MAJOR_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__MAJOR_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_MINOR(null, null, null, isOnLoad);
    onValidate_DEDUCT__MINOR_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__MINOR_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__MINOR_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__MINOR_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_THEFT(null, null, null, isOnLoad);
    onValidate_DEDUCT__THEFT_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__THEFT_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__THEFT_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__THEFT_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_TRANSIT(null, null, null, isOnLoad);
    onValidate_DEDUCT__TRANSIT_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__TRANSIT_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__TRANSIT_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__TRANSIT_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_SURRP(null, null, null, isOnLoad);
    onValidate_DEDUCT__SURRP_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__SURRP_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__SURRP_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__SURRP_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_FIREP(null, null, null, isOnLoad);
    onValidate_DEDUCT__FIREP_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__FIREP_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__FIREP_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__FIREP_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__IS_ALLP(null, null, null, isOnLoad);
    onValidate_DEDUCT__ALLP_DED(null, null, null, isOnLoad);
    onValidate_DEDUCT__ALLP_MIN(null, null, null, isOnLoad);
    onValidate_DEDUCT__ALLP_MAX(null, null, null, isOnLoad);
    onValidate_DEDUCT__ALLP_BASIS(null, null, null, isOnLoad);
    onValidate_DEDUCT__CBA_ADED(null, null, null, isOnLoad);
    onValidate_DEDUCT__CBA_ADED_CNT(null, null, null, isOnLoad);
    onValidate_CW_RISK__IS_SPECIFIC_DED(null, null, null, isOnLoad);
    onValidate_CW_RISK__IS_ANNUAL_DED(null, null, null, isOnLoad);
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
<div id="ida6c6d5d0287a45bd82061ca0790aff91" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="CCADed" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading55" runat="server" Text="Value Band Deductibles" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_CW_RISK__DEDE"
		data-field-type="Child" 
		data-object-name="CW_RISK" 
		data-property-name="DEDE" 
		id="pb-container-childscreen-CW_RISK-DEDE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="CW_RISK__DEDUCT_CHILD" runat="server" ScreenCode="DEDE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="DEDE/DEDE_Contract_Value_Bands_Deductibles.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Contract Exceeding" DataField="CONT_EXCEE" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Contract Not Exceeding" DataField="CONT_NOT_EX" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valCW_RISK_DEDE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for CW_RISK.DEDE"
						ClientValidationFunction="onValidate_CW_RISK__DEDE" 
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
		if ($("#CCADed div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#CCADed div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#CCADed div ul li").each(function(){		  
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
			$("#CCADed div ul li").each(function(){		  
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
		styleString += "#CCADed label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#CCADed label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CCADed label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CCADed label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#CCADed input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CCADed input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CCADed input{text-align:left;}"; break;
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
<div id="CCANBD" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading56" runat="server" Text="Non Band Deductibles" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="5:20:15:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label70">
		<span class="label" id="label70"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label71">
		<span class="label" id="label71"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label72">
		<span class="label" id="label72">Deductible%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label73">
		<span class="label" id="label73">Minimum  Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label74">
		<span class="label" id="label74">Maximum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label75">
		<span class="label" id="label75">Max Per Event/Occ</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label76">
		<span class="label" id="label76">Basis of Deductible </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_MAJOR" for="ctl00_cntMainBody_NB_DEDUCT__IS_MAJOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_MAJOR" 
		id="pb-container-checkbox-NB_DEDUCT-IS_MAJOR">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_MAJOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_MAJOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_MAJOR"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_MAJOR" 
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
	<span id="pb-container-label-label77">
		<span class="label" id="label77">Major Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_DED" 
		id="pb-container-percentage-NB_DEDUCT-MAJOR_DED">
		<asp:Label ID="lblNB_DEDUCT_MAJOR_DED" runat="server" AssociatedControlID="NB_DEDUCT__MAJOR_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__MAJOR_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MAJOR_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MAJOR_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__MAJOR_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_MIN" 
		id="pb-container-currency-NB_DEDUCT-MAJOR_MIN">
		<asp:Label ID="lblNB_DEDUCT_MAJOR_MIN" runat="server" AssociatedControlID="NB_DEDUCT__MAJOR_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MAJOR_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MAJOR_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MAJOR_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__MAJOR_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_MAX" 
		id="pb-container-currency-NB_DEDUCT-MAJOR_MAX">
		<asp:Label ID="lblNB_DEDUCT_MAJOR_MAX" runat="server" AssociatedControlID="NB_DEDUCT__MAJOR_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MAJOR_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MAJOR_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MAJOR_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__MAJOR_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_EVENT" 
		id="pb-container-currency-NB_DEDUCT-MAJOR_EVENT">
		<asp:Label ID="lblNB_DEDUCT_MAJOR_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__MAJOR_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MAJOR_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MAJOR_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MAJOR_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__MAJOR_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_BASIS" 
		id="pb-container-list-NB_DEDUCT-MAJOR_BASIS">
		<asp:Label ID="lblNB_DEDUCT_MAJOR_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__MAJOR_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__MAJOR_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__MAJOR_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_MAJOR_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MAJOR_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__MAJOR_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_MINOR" for="ctl00_cntMainBody_NB_DEDUCT__IS_MINOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_MINOR" 
		id="pb-container-checkbox-NB_DEDUCT-IS_MINOR">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_MINOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_MINOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_MINOR"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_MINOR" 
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
	<span id="pb-container-label-label78">
		<span class="label" id="label78">Minor Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_DED" 
		id="pb-container-percentage-NB_DEDUCT-MINOR_DED">
		<asp:Label ID="lblNB_DEDUCT_MINOR_DED" runat="server" AssociatedControlID="NB_DEDUCT__MINOR_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__MINOR_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MINOR_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MINOR_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__MINOR_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_MIN" 
		id="pb-container-currency-NB_DEDUCT-MINOR_MIN">
		<asp:Label ID="lblNB_DEDUCT_MINOR_MIN" runat="server" AssociatedControlID="NB_DEDUCT__MINOR_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MINOR_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MINOR_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MINOR_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__MINOR_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_MAX" 
		id="pb-container-currency-NB_DEDUCT-MINOR_MAX">
		<asp:Label ID="lblNB_DEDUCT_MINOR_MAX" runat="server" AssociatedControlID="NB_DEDUCT__MINOR_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MINOR_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MINOR_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MINOR_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__MINOR_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_EVENT" 
		id="pb-container-currency-NB_DEDUCT-MINOR_EVENT">
		<asp:Label ID="lblNB_DEDUCT_MINOR_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__MINOR_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__MINOR_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_MINOR_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MINOR_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__MINOR_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_BASIS" 
		id="pb-container-list-NB_DEDUCT-MINOR_BASIS">
		<asp:Label ID="lblNB_DEDUCT_MINOR_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__MINOR_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__MINOR_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__MINOR_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_MINOR_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.MINOR_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__MINOR_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_THEFT" for="ctl00_cntMainBody_NB_DEDUCT__IS_THEFT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_THEFT" 
		id="pb-container-checkbox-NB_DEDUCT-IS_THEFT">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_THEFT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_THEFT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_THEFT"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_THEFT" 
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
	<span id="pb-container-label-label79">
		<span class="label" id="label79">Theft, Malicious Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_DED" 
		id="pb-container-percentage-NB_DEDUCT-THEFT_DED">
		<asp:Label ID="lblNB_DEDUCT_THEFT_DED" runat="server" AssociatedControlID="NB_DEDUCT__THEFT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__THEFT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_THEFT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.THEFT_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__THEFT_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_MIN" 
		id="pb-container-currency-NB_DEDUCT-THEFT_MIN">
		<asp:Label ID="lblNB_DEDUCT_THEFT_MIN" runat="server" AssociatedControlID="NB_DEDUCT__THEFT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__THEFT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_THEFT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.THEFT_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__THEFT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_MAX" 
		id="pb-container-currency-NB_DEDUCT-THEFT_MAX">
		<asp:Label ID="lblNB_DEDUCT_THEFT_MAX" runat="server" AssociatedControlID="NB_DEDUCT__THEFT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__THEFT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_THEFT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.THEFT_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__THEFT_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_EVENT" 
		id="pb-container-currency-NB_DEDUCT-THEFT_EVENT">
		<asp:Label ID="lblNB_DEDUCT_THEFT_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__THEFT_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__THEFT_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_THEFT_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.THEFT_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__THEFT_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_BASIS" 
		id="pb-container-list-NB_DEDUCT-THEFT_BASIS">
		<asp:Label ID="lblNB_DEDUCT_THEFT_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__THEFT_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__THEFT_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__THEFT_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_THEFT_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.THEFT_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__THEFT_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_TRANSIT" for="ctl00_cntMainBody_NB_DEDUCT__IS_TRANSIT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_TRANSIT" 
		id="pb-container-checkbox-NB_DEDUCT-IS_TRANSIT">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_TRANSIT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_TRANSIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_TRANSIT"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_TRANSIT" 
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
	<span id="pb-container-label-label80">
		<span class="label" id="label80">Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_DED" 
		id="pb-container-percentage-NB_DEDUCT-TRANSIT_DED">
		<asp:Label ID="lblNB_DEDUCT_TRANSIT_DED" runat="server" AssociatedControlID="NB_DEDUCT__TRANSIT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__TRANSIT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_TRANSIT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.TRANSIT_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__TRANSIT_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_MIN" 
		id="pb-container-currency-NB_DEDUCT-TRANSIT_MIN">
		<asp:Label ID="lblNB_DEDUCT_TRANSIT_MIN" runat="server" AssociatedControlID="NB_DEDUCT__TRANSIT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__TRANSIT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_TRANSIT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.TRANSIT_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__TRANSIT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_MAX" 
		id="pb-container-currency-NB_DEDUCT-TRANSIT_MAX">
		<asp:Label ID="lblNB_DEDUCT_TRANSIT_MAX" runat="server" AssociatedControlID="NB_DEDUCT__TRANSIT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__TRANSIT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_TRANSIT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.TRANSIT_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__TRANSIT_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_EVENT" 
		id="pb-container-currency-NB_DEDUCT-TRANSIT_EVENT">
		<asp:Label ID="lblNB_DEDUCT_TRANSIT_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__TRANSIT_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__TRANSIT_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_TRANSIT_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.TRANSIT_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__TRANSIT_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_BASIS" 
		id="pb-container-list-NB_DEDUCT-TRANSIT_BASIS">
		<asp:Label ID="lblNB_DEDUCT_TRANSIT_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__TRANSIT_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__TRANSIT_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__TRANSIT_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_TRANSIT_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.TRANSIT_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__TRANSIT_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_SURRP" for="ctl00_cntMainBody_NB_DEDUCT__IS_SURRP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_SURRP" 
		id="pb-container-checkbox-NB_DEDUCT-IS_SURRP">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_SURRP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_SURRP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_SURRP"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_SURRP" 
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
	<span id="pb-container-label-label81">
		<span class="label" id="label81">Surrounding Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_DED" 
		id="pb-container-percentage-NB_DEDUCT-SURRP_DED">
		<asp:Label ID="lblNB_DEDUCT_SURRP_DED" runat="server" AssociatedControlID="NB_DEDUCT__SURRP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__SURRP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_SURRP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.SURRP_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__SURRP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_MIN" 
		id="pb-container-currency-NB_DEDUCT-SURRP_MIN">
		<asp:Label ID="lblNB_DEDUCT_SURRP_MIN" runat="server" AssociatedControlID="NB_DEDUCT__SURRP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__SURRP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_SURRP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.SURRP_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__SURRP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_MAX" 
		id="pb-container-currency-NB_DEDUCT-SURRP_MAX">
		<asp:Label ID="lblNB_DEDUCT_SURRP_MAX" runat="server" AssociatedControlID="NB_DEDUCT__SURRP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__SURRP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_SURRP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.SURRP_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__SURRP_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_EVENT" 
		id="pb-container-currency-NB_DEDUCT-SURRP_EVENT">
		<asp:Label ID="lblNB_DEDUCT_SURRP_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__SURRP_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__SURRP_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_SURRP_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.SURRP_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__SURRP_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_BASIS" 
		id="pb-container-list-NB_DEDUCT-SURRP_BASIS">
		<asp:Label ID="lblNB_DEDUCT_SURRP_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__SURRP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__SURRP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__SURRP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_SURRP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.SURRP_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__SURRP_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_FIREP" for="ctl00_cntMainBody_NB_DEDUCT__IS_FIREP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_FIREP" 
		id="pb-container-checkbox-NB_DEDUCT-IS_FIREP">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_FIREP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_FIREP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_FIREP"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_FIREP" 
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
	<span id="pb-container-label-label82">
		<span class="label" id="label82">Fire Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_DED" 
		id="pb-container-percentage-NB_DEDUCT-FIREP_DED">
		<asp:Label ID="lblNB_DEDUCT_FIREP_DED" runat="server" AssociatedControlID="NB_DEDUCT__FIREP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__FIREP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_FIREP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.FIREP_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__FIREP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_MIN" 
		id="pb-container-currency-NB_DEDUCT-FIREP_MIN">
		<asp:Label ID="lblNB_DEDUCT_FIREP_MIN" runat="server" AssociatedControlID="NB_DEDUCT__FIREP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__FIREP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_FIREP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.FIREP_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__FIREP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_MAX" 
		id="pb-container-currency-NB_DEDUCT-FIREP_MAX">
		<asp:Label ID="lblNB_DEDUCT_FIREP_MAX" runat="server" AssociatedControlID="NB_DEDUCT__FIREP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__FIREP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_FIREP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.FIREP_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__FIREP_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_EVENT" 
		id="pb-container-currency-NB_DEDUCT-FIREP_EVENT">
		<asp:Label ID="lblNB_DEDUCT_FIREP_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__FIREP_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__FIREP_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_FIREP_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.FIREP_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__FIREP_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_BASIS" 
		id="pb-container-list-NB_DEDUCT-FIREP_BASIS">
		<asp:Label ID="lblNB_DEDUCT_FIREP_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__FIREP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__FIREP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__FIREP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_FIREP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.FIREP_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__FIREP_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblNB_DEDUCT_IS_ALLP" for="ctl00_cntMainBody_NB_DEDUCT__IS_ALLP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="NB_DEDUCT" 
		data-property-name="IS_ALLP" 
		id="pb-container-checkbox-NB_DEDUCT-IS_ALLP">	
		
		<asp:TextBox ID="NB_DEDUCT__IS_ALLP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valNB_DEDUCT_IS_ALLP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.IS_ALLP"
			ClientValidationFunction="onValidate_NB_DEDUCT__IS_ALLP" 
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
	<span id="pb-container-label-label83">
		<span class="label" id="label83">All Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_DED" 
		id="pb-container-percentage-NB_DEDUCT-ALLP_DED">
		<asp:Label ID="lblNB_DEDUCT_ALLP_DED" runat="server" AssociatedControlID="NB_DEDUCT__ALLP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="NB_DEDUCT__ALLP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valNB_DEDUCT_ALLP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.ALLP_DED"
			ClientValidationFunction="onValidate_NB_DEDUCT__ALLP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_MIN" 
		id="pb-container-currency-NB_DEDUCT-ALLP_MIN">
		<asp:Label ID="lblNB_DEDUCT_ALLP_MIN" runat="server" AssociatedControlID="NB_DEDUCT__ALLP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__ALLP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_ALLP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.ALLP_MIN"
			ClientValidationFunction="onValidate_NB_DEDUCT__ALLP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_MAX" 
		id="pb-container-currency-NB_DEDUCT-ALLP_MAX">
		<asp:Label ID="lblNB_DEDUCT_ALLP_MAX" runat="server" AssociatedControlID="NB_DEDUCT__ALLP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__ALLP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_ALLP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.ALLP_MAX"
			ClientValidationFunction="onValidate_NB_DEDUCT__ALLP_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_EVENT" 
		id="pb-container-currency-NB_DEDUCT-ALLP_EVENT">
		<asp:Label ID="lblNB_DEDUCT_ALLP_EVENT" runat="server" AssociatedControlID="NB_DEDUCT__ALLP_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="NB_DEDUCT__ALLP_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valNB_DEDUCT_ALLP_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.ALLP_EVENT"
			ClientValidationFunction="onValidate_NB_DEDUCT__ALLP_EVENT" 
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
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_BASIS" 
		id="pb-container-list-NB_DEDUCT-ALLP_BASIS">
		<asp:Label ID="lblNB_DEDUCT_ALLP_BASIS" runat="server" AssociatedControlID="NB_DEDUCT__ALLP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="NB_DEDUCT__ALLP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_NB_DEDUCT__ALLP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valNB_DEDUCT_ALLP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NB_DEDUCT.ALLP_BASIS"
			ClientValidationFunction="onValidate_NB_DEDUCT__ALLP_BASIS" 
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
		
		data-object-name="NB_DEDUCT" 
		data-property-name="MAJOR_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-MAJOR_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__MAJOR_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="MINOR_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-MINOR_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__MINOR_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="THEFT_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-THEFT_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__THEFT_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="TRANSIT_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-TRANSIT_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__TRANSIT_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="SURRP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-SURRP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__SURRP_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="FIREP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-FIREP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__FIREP_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="NB_DEDUCT" 
		data-property-name="ALLP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-NB_DEDUCT-ALLP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="NB_DEDUCT__ALLP_BASISCode" runat="server" />

		

		
	
		
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
		if ($("#CCANBD div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#CCANBD div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#CCANBD div ul li").each(function(){		  
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
			$("#CCANBD div ul li").each(function(){		  
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
		styleString += "#CCANBD label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#CCANBD label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CCANBD label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CCANBD label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#CCANBD input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CCANBD input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CCANBD input{text-align:left;}"; break;
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
<div id="addDedNonBandDed" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading57" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_NB_DEDUCT__NONDED"
		data-field-type="Child" 
		data-object-name="NB_DEDUCT" 
		data-property-name="NONDED" 
		id="pb-container-childscreen-NB_DEDUCT-NONDED">
		
		    <legend>Additional Non Band Deductibles</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="NB_DEDUCT__NOND" runat="server" ScreenCode="NONDED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="NONDED/NONDED_Additional_Non_Band_Deductible.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="DESCRIPTION" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Deductible %" DataField="DED" DataFormatString="{0:0}%"/>
<Nexus:RiskAttribute HeaderText="Minimum Amount" DataField="MIN" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Maximum Amount" DataField="MAX" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Max Per Event/Occurrence" DataField="EVENT" DataFormatString="{0:N}"/>
<Nexus:GISLookupField HeaderText="Basis of deductible" ListType="PMLookup" ListCode="UDL_CW_BASISDED" DataField="BASIS" DataItemValue="key" />

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
				
					<asp:CustomValidator ID="valNB_DEDUCT_NONDED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Additional Non Band Deductibles"
						ClientValidationFunction="onValidate_NB_DEDUCT__NONDED" 
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
		if ($("#addDedNonBandDed div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#addDedNonBandDed div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#addDedNonBandDed div ul li").each(function(){		  
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
			$("#addDedNonBandDed div ul li").each(function(){		  
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
		styleString += "#addDedNonBandDed label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#addDedNonBandDed label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#addDedNonBandDed label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#addDedNonBandDed label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#addDedNonBandDed input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#addDedNonBandDed input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#addDedNonBandDed input{text-align:left;}"; break;
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
<div id="CBADeduct" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading58" runat="server" Text="Deductibles" /></legend>
				
				
				<div data-column-count="6" data-column-ratio="5:35:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label84">
		<span class="label" id="label84"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label85">
		<span class="label" id="label85"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label86">
		<span class="label" id="label86">Deductible%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label87">
		<span class="label" id="label87">Minimum  Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label88">
		<span class="label" id="label88">Maximum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label89">
		<span class="label" id="label89">Basis of Deductible </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_MAJOR" for="ctl00_cntMainBody_DEDUCT__IS_MAJOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_MAJOR" 
		id="pb-container-checkbox-DEDUCT-IS_MAJOR">	
		
		<asp:TextBox ID="DEDUCT__IS_MAJOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_MAJOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_MAJOR"
			ClientValidationFunction="onValidate_DEDUCT__IS_MAJOR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label90">
		<span class="label" id="label90">Major Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="MAJOR_DED" 
		id="pb-container-percentage-DEDUCT-MAJOR_DED">
		<asp:Label ID="lblDEDUCT_MAJOR_DED" runat="server" AssociatedControlID="DEDUCT__MAJOR_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__MAJOR_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_MAJOR_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MAJOR_DED"
			ClientValidationFunction="onValidate_DEDUCT__MAJOR_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="MAJOR_MIN" 
		id="pb-container-currency-DEDUCT-MAJOR_MIN">
		<asp:Label ID="lblDEDUCT_MAJOR_MIN" runat="server" AssociatedControlID="DEDUCT__MAJOR_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__MAJOR_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_MAJOR_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MAJOR_MIN"
			ClientValidationFunction="onValidate_DEDUCT__MAJOR_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="MAJOR_MAX" 
		id="pb-container-currency-DEDUCT-MAJOR_MAX">
		<asp:Label ID="lblDEDUCT_MAJOR_MAX" runat="server" AssociatedControlID="DEDUCT__MAJOR_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__MAJOR_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_MAJOR_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MAJOR_MAX"
			ClientValidationFunction="onValidate_DEDUCT__MAJOR_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="MAJOR_BASIS" 
		id="pb-container-list-DEDUCT-MAJOR_BASIS">
		<asp:Label ID="lblDEDUCT_MAJOR_BASIS" runat="server" AssociatedControlID="DEDUCT__MAJOR_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__MAJOR_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__MAJOR_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_MAJOR_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MAJOR_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__MAJOR_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_MINOR" for="ctl00_cntMainBody_DEDUCT__IS_MINOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_MINOR" 
		id="pb-container-checkbox-DEDUCT-IS_MINOR">	
		
		<asp:TextBox ID="DEDUCT__IS_MINOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_MINOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_MINOR"
			ClientValidationFunction="onValidate_DEDUCT__IS_MINOR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label91">
		<span class="label" id="label91">Minor Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="MINOR_DED" 
		id="pb-container-percentage-DEDUCT-MINOR_DED">
		<asp:Label ID="lblDEDUCT_MINOR_DED" runat="server" AssociatedControlID="DEDUCT__MINOR_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__MINOR_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_MINOR_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MINOR_DED"
			ClientValidationFunction="onValidate_DEDUCT__MINOR_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="MINOR_MIN" 
		id="pb-container-currency-DEDUCT-MINOR_MIN">
		<asp:Label ID="lblDEDUCT_MINOR_MIN" runat="server" AssociatedControlID="DEDUCT__MINOR_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__MINOR_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_MINOR_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MINOR_MIN"
			ClientValidationFunction="onValidate_DEDUCT__MINOR_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="MINOR_MAX" 
		id="pb-container-currency-DEDUCT-MINOR_MAX">
		<asp:Label ID="lblDEDUCT_MINOR_MAX" runat="server" AssociatedControlID="DEDUCT__MINOR_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__MINOR_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_MINOR_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MINOR_MAX"
			ClientValidationFunction="onValidate_DEDUCT__MINOR_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="MINOR_BASIS" 
		id="pb-container-list-DEDUCT-MINOR_BASIS">
		<asp:Label ID="lblDEDUCT_MINOR_BASIS" runat="server" AssociatedControlID="DEDUCT__MINOR_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__MINOR_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__MINOR_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_MINOR_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.MINOR_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__MINOR_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_THEFT" for="ctl00_cntMainBody_DEDUCT__IS_THEFT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_THEFT" 
		id="pb-container-checkbox-DEDUCT-IS_THEFT">	
		
		<asp:TextBox ID="DEDUCT__IS_THEFT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_THEFT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_THEFT"
			ClientValidationFunction="onValidate_DEDUCT__IS_THEFT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label92">
		<span class="label" id="label92">Theft, Malicious Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="THEFT_DED" 
		id="pb-container-percentage-DEDUCT-THEFT_DED">
		<asp:Label ID="lblDEDUCT_THEFT_DED" runat="server" AssociatedControlID="DEDUCT__THEFT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__THEFT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_THEFT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.THEFT_DED"
			ClientValidationFunction="onValidate_DEDUCT__THEFT_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="THEFT_MIN" 
		id="pb-container-currency-DEDUCT-THEFT_MIN">
		<asp:Label ID="lblDEDUCT_THEFT_MIN" runat="server" AssociatedControlID="DEDUCT__THEFT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__THEFT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_THEFT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.THEFT_MIN"
			ClientValidationFunction="onValidate_DEDUCT__THEFT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="THEFT_MAX" 
		id="pb-container-currency-DEDUCT-THEFT_MAX">
		<asp:Label ID="lblDEDUCT_THEFT_MAX" runat="server" AssociatedControlID="DEDUCT__THEFT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__THEFT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_THEFT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.THEFT_MAX"
			ClientValidationFunction="onValidate_DEDUCT__THEFT_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="THEFT_BASIS" 
		id="pb-container-list-DEDUCT-THEFT_BASIS">
		<asp:Label ID="lblDEDUCT_THEFT_BASIS" runat="server" AssociatedControlID="DEDUCT__THEFT_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__THEFT_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__THEFT_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_THEFT_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.THEFT_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__THEFT_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_TRANSIT" for="ctl00_cntMainBody_DEDUCT__IS_TRANSIT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_TRANSIT" 
		id="pb-container-checkbox-DEDUCT-IS_TRANSIT">	
		
		<asp:TextBox ID="DEDUCT__IS_TRANSIT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_TRANSIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_TRANSIT"
			ClientValidationFunction="onValidate_DEDUCT__IS_TRANSIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label93">
		<span class="label" id="label93">Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="TRANSIT_DED" 
		id="pb-container-percentage-DEDUCT-TRANSIT_DED">
		<asp:Label ID="lblDEDUCT_TRANSIT_DED" runat="server" AssociatedControlID="DEDUCT__TRANSIT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__TRANSIT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_TRANSIT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.TRANSIT_DED"
			ClientValidationFunction="onValidate_DEDUCT__TRANSIT_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="TRANSIT_MIN" 
		id="pb-container-currency-DEDUCT-TRANSIT_MIN">
		<asp:Label ID="lblDEDUCT_TRANSIT_MIN" runat="server" AssociatedControlID="DEDUCT__TRANSIT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__TRANSIT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_TRANSIT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.TRANSIT_MIN"
			ClientValidationFunction="onValidate_DEDUCT__TRANSIT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="TRANSIT_MAX" 
		id="pb-container-currency-DEDUCT-TRANSIT_MAX">
		<asp:Label ID="lblDEDUCT_TRANSIT_MAX" runat="server" AssociatedControlID="DEDUCT__TRANSIT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__TRANSIT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_TRANSIT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.TRANSIT_MAX"
			ClientValidationFunction="onValidate_DEDUCT__TRANSIT_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="TRANSIT_BASIS" 
		id="pb-container-list-DEDUCT-TRANSIT_BASIS">
		<asp:Label ID="lblDEDUCT_TRANSIT_BASIS" runat="server" AssociatedControlID="DEDUCT__TRANSIT_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__TRANSIT_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__TRANSIT_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_TRANSIT_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.TRANSIT_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__TRANSIT_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_SURRP" for="ctl00_cntMainBody_DEDUCT__IS_SURRP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_SURRP" 
		id="pb-container-checkbox-DEDUCT-IS_SURRP">	
		
		<asp:TextBox ID="DEDUCT__IS_SURRP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_SURRP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_SURRP"
			ClientValidationFunction="onValidate_DEDUCT__IS_SURRP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label94">
		<span class="label" id="label94">Surrounding Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="SURRP_DED" 
		id="pb-container-percentage-DEDUCT-SURRP_DED">
		<asp:Label ID="lblDEDUCT_SURRP_DED" runat="server" AssociatedControlID="DEDUCT__SURRP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__SURRP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_SURRP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.SURRP_DED"
			ClientValidationFunction="onValidate_DEDUCT__SURRP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="SURRP_MIN" 
		id="pb-container-currency-DEDUCT-SURRP_MIN">
		<asp:Label ID="lblDEDUCT_SURRP_MIN" runat="server" AssociatedControlID="DEDUCT__SURRP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__SURRP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_SURRP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.SURRP_MIN"
			ClientValidationFunction="onValidate_DEDUCT__SURRP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="SURRP_MAX" 
		id="pb-container-currency-DEDUCT-SURRP_MAX">
		<asp:Label ID="lblDEDUCT_SURRP_MAX" runat="server" AssociatedControlID="DEDUCT__SURRP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__SURRP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_SURRP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.SURRP_MAX"
			ClientValidationFunction="onValidate_DEDUCT__SURRP_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="SURRP_BASIS" 
		id="pb-container-list-DEDUCT-SURRP_BASIS">
		<asp:Label ID="lblDEDUCT_SURRP_BASIS" runat="server" AssociatedControlID="DEDUCT__SURRP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__SURRP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__SURRP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_SURRP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.SURRP_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__SURRP_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_FIREP" for="ctl00_cntMainBody_DEDUCT__IS_FIREP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_FIREP" 
		id="pb-container-checkbox-DEDUCT-IS_FIREP">	
		
		<asp:TextBox ID="DEDUCT__IS_FIREP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_FIREP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_FIREP"
			ClientValidationFunction="onValidate_DEDUCT__IS_FIREP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label95">
		<span class="label" id="label95">Fire Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="FIREP_DED" 
		id="pb-container-percentage-DEDUCT-FIREP_DED">
		<asp:Label ID="lblDEDUCT_FIREP_DED" runat="server" AssociatedControlID="DEDUCT__FIREP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__FIREP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_FIREP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.FIREP_DED"
			ClientValidationFunction="onValidate_DEDUCT__FIREP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="FIREP_MIN" 
		id="pb-container-currency-DEDUCT-FIREP_MIN">
		<asp:Label ID="lblDEDUCT_FIREP_MIN" runat="server" AssociatedControlID="DEDUCT__FIREP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__FIREP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_FIREP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.FIREP_MIN"
			ClientValidationFunction="onValidate_DEDUCT__FIREP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="FIREP_MAX" 
		id="pb-container-currency-DEDUCT-FIREP_MAX">
		<asp:Label ID="lblDEDUCT_FIREP_MAX" runat="server" AssociatedControlID="DEDUCT__FIREP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__FIREP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_FIREP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.FIREP_MAX"
			ClientValidationFunction="onValidate_DEDUCT__FIREP_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="FIREP_BASIS" 
		id="pb-container-list-DEDUCT-FIREP_BASIS">
		<asp:Label ID="lblDEDUCT_FIREP_BASIS" runat="server" AssociatedControlID="DEDUCT__FIREP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__FIREP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__FIREP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_FIREP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.FIREP_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__FIREP_BASIS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblDEDUCT_IS_ALLP" for="ctl00_cntMainBody_DEDUCT__IS_ALLP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="DEDUCT" 
		data-property-name="IS_ALLP" 
		id="pb-container-checkbox-DEDUCT-IS_ALLP">	
		
		<asp:TextBox ID="DEDUCT__IS_ALLP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valDEDUCT_IS_ALLP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.IS_ALLP"
			ClientValidationFunction="onValidate_DEDUCT__IS_ALLP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:35%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label96">
		<span class="label" id="label96">All Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="DEDUCT" 
		data-property-name="ALLP_DED" 
		id="pb-container-percentage-DEDUCT-ALLP_DED">
		<asp:Label ID="lblDEDUCT_ALLP_DED" runat="server" AssociatedControlID="DEDUCT__ALLP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="DEDUCT__ALLP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valDEDUCT_ALLP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.ALLP_DED"
			ClientValidationFunction="onValidate_DEDUCT__ALLP_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="ALLP_MIN" 
		id="pb-container-currency-DEDUCT-ALLP_MIN">
		<asp:Label ID="lblDEDUCT_ALLP_MIN" runat="server" AssociatedControlID="DEDUCT__ALLP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__ALLP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_ALLP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.ALLP_MIN"
			ClientValidationFunction="onValidate_DEDUCT__ALLP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="DEDUCT" 
		data-property-name="ALLP_MAX" 
		id="pb-container-currency-DEDUCT-ALLP_MAX">
		<asp:Label ID="lblDEDUCT_ALLP_MAX" runat="server" AssociatedControlID="DEDUCT__ALLP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="DEDUCT__ALLP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valDEDUCT_ALLP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.ALLP_MAX"
			ClientValidationFunction="onValidate_DEDUCT__ALLP_MAX" 
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
		data-object-name="DEDUCT" 
		data-property-name="ALLP_BASIS" 
		id="pb-container-list-DEDUCT-ALLP_BASIS">
		<asp:Label ID="lblDEDUCT_ALLP_BASIS" runat="server" AssociatedControlID="DEDUCT__ALLP_BASIS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="DEDUCT__ALLP_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CW_BASISDED" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_DEDUCT__ALLP_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valDEDUCT_ALLP_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.ALLP_BASIS"
			ClientValidationFunction="onValidate_DEDUCT__ALLP_BASIS" 
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
		
		data-object-name="DEDUCT" 
		data-property-name="MAJOR_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-MAJOR_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__MAJOR_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="MINOR_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-MINOR_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__MINOR_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="THEFT_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-THEFT_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__THEFT_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="TRANSIT_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-TRANSIT_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__TRANSIT_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="SURRP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-SURRP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__SURRP_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="FIREP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-FIREP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__FIREP_BASISCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DEDUCT" 
		data-property-name="ALLP_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-DEDUCT-ALLP_BASISCode">

		
		
			
		
				<asp:HiddenField ID="DEDUCT__ALLP_BASISCode" runat="server" />

		

		
	
		
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
		if ($("#CBADeduct div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#CBADeduct div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#CBADeduct div ul li").each(function(){		  
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
			$("#CBADeduct div ul li").each(function(){		  
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
		styleString += "#CBADeduct label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#CBADeduct label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CBADeduct label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CBADeduct label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#CBADeduct input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CBADeduct input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CBADeduct input{text-align:left;}"; break;
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
<div id="CBAAddDed" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading59" runat="server" Text="Additional Deductibles" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_DEDUCT__CBA_ADED"
		data-field-type="Child" 
		data-object-name="DEDUCT" 
		data-property-name="CBA_ADED" 
		id="pb-container-childscreen-DEDUCT-CBA_ADED">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="DEDUCT__ADDDEDUC" runat="server" ScreenCode="CBA_ADED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="CBA_ADED/CBA_ADED_Additional_Deductibles.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="DESCRIPTION" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Deductible %" DataField="DED" DataFormatString="{0:0}%"/>
<Nexus:RiskAttribute HeaderText="Minimum Amount" DataField="MIN" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Maximum Amount" DataField="MAX" DataFormatString="{0:N}"/>
<Nexus:GISLookupField HeaderText="Basis of deductible" ListType="PMLookup" ListCode="UDL_CW_BASISDED" DataField="BASIS" DataItemValue="key" />

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
				
					<asp:CustomValidator ID="valDEDUCT_CBA_ADED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for DEDUCT.CBA_ADED"
						ClientValidationFunction="onValidate_DEDUCT__CBA_ADED" 
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
		data-object-name="DEDUCT" 
		data-property-name="CBA_ADED_CNT" 
		id="pb-container-integer-DEDUCT-CBA_ADED_CNT">
		<asp:Label ID="lblDEDUCT_CBA_ADED_CNT" runat="server" AssociatedControlID="DEDUCT__CBA_ADED_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="DEDUCT__CBA_ADED_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valDEDUCT_CBA_ADED_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for DEDUCT.CBA_ADED_CNT"
			ClientValidationFunction="onValidate_DEDUCT__CBA_ADED_CNT" 
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
		if ($("#CBAAddDed div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#CBAAddDed div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#CBAAddDed div ul li").each(function(){		  
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
			$("#CBAAddDed div ul li").each(function(){		  
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
		styleString += "#CBAAddDed label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#CBAAddDed label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CBAAddDed label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CBAAddDed label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#CBAAddDed input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#CBAAddDed input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#CBAAddDed input{text-align:left;}"; break;
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
<div id="id4c72ce16e0b94bfc9c52e889276a5f51" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading60" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="CW_RISK" 
		data-property-name="IS_SPECIFIC_DED" 
		id="pb-container-checkbox-CW_RISK-IS_SPECIFIC_DED"
	>
		<label id="ctl00_cntMainBody_lblCW_RISK_IS_SPECIFIC_DED" for="ctl00_cntMainBody_CW_RISK_IS_SPECIFIC_DED_select">Product Toggle</label>
		<input id="ctl00_cntMainBody_CW_RISK_IS_SPECIFIC_DED" class="field-medium hidden" />
			<asp:CustomValidator ID="valCW_RISK_IS_SPECIFIC_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Product Toggle"
			ClientValidationFunction="onValidate_CW_RISK__IS_SPECIFIC_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>

	
<!-- /TempCheckbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="CW_RISK" 
		data-property-name="IS_ANNUAL_DED" 
		id="pb-container-checkbox-CW_RISK-IS_ANNUAL_DED"
	>
		<label id="ctl00_cntMainBody_lblCW_RISK_IS_ANNUAL_DED" for="ctl00_cntMainBody_CW_RISK_IS_ANNUAL_DED_select">Product Toggle</label>
		<input id="ctl00_cntMainBody_CW_RISK_IS_ANNUAL_DED" class="field-medium hidden" />
			<asp:CustomValidator ID="valCW_RISK_IS_ANNUAL_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Product Toggle"
			ClientValidationFunction="onValidate_CW_RISK__IS_ANNUAL_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>

	
<!-- /TempCheckbox -->
								
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
		if ($("#id4c72ce16e0b94bfc9c52e889276a5f51 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4c72ce16e0b94bfc9c52e889276a5f51 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4c72ce16e0b94bfc9c52e889276a5f51 div ul li").each(function(){		  
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
			$("#id4c72ce16e0b94bfc9c52e889276a5f51 div ul li").each(function(){		  
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
		styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c72ce16e0b94bfc9c52e889276a5f51 input{text-align:left;}"; break;
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