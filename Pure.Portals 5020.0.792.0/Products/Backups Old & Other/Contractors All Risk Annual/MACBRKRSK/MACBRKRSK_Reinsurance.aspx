<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MACBRKRSK_Reinsurance.aspx.vb" Inherits="Nexus.PB2_MACBRKRSK_Reinsurance" %>

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
function onValidate_RISK_REINSURER__IS_MACHINERY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_MACHINERY", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=MACHINERY_SUMINSURED&name={name}");
        		
        		var value = new Expression("RISK_DETAILS.MACHINERY_TOTAL_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=MACHINERY_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=MACHINERY_AMOUNT&name={name}");
        		
        		var value = new Expression("RISK_REINSURER.MACHINERY_EML * RISK_REINSURER.MACHINERY_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_LOSS_GROSS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_LOSS_GROSS", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__LOSS_GROSS_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "LOSS_GROSS_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "LOSS_GROSS_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_LOSS_GROSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_LOSS_GROSS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=LOSS_GROSS_SUMINSURED&name={name}");
        		
        		var value = new Expression("RISK_DETAILS.ANNUAL_GROSS_PROFIT"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__LOSS_GROSS_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "LOSS_GROSS_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "LOSS_GROSS_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_LOSS_GROSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_LOSS_GROSS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=LOSS_GROSS_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__LOSS_GROSS_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "LOSS_GROSS_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "LOSS_GROSS_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_LOSS_GROSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_LOSS_GROSS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=LOSS_GROSS_AMOUNT&name={name}");
        		
        		var value = new Expression("RISK_REINSURER.LOSS_GROSS_EML * RISK_REINSURER.LOSS_GROSS_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__LOSS_GROSS_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "LOSS_GROSS_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "LOSS_GROSS_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_LOSS_GROSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_LOSS_GROSS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PREP_COST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_MACHINERY_BREAKDOWN_PREP_COST", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED&name={name}");
        		
        		var value = new Expression("RISK_EXTENSIONS.SUMINSURED - RISK_EXTENSIONS.OTHER_EXTENSIONS_TOTAL_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_PREP_COST_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_PREP_COST_AMOUNT&name={name}");
        		
        		var value = new Expression("RISK_REINSURER.MACHINERY_BREAKDOWN_COST_WORK_EML * RISK_REINSURER.MACHINERY_BREAKDOWN_COST_WORK_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PREP_COST == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_MACHINEYR_BREAKDOWN_DETER_STOCK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_MACHINEYR_BREAKDOWN_DETER_STOCK", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_DETER_STOCK_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINEYR_BREAKDOWN_DETER_STOCK == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PROF_FEES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_MACHINERY_BREAKDOWN_PROF_FEES", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_PROF_FEES_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_EXTENSIONS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_MACHINERY_BREAKDOWN_EXTENSIONS", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=MACHINERY_BREAKDOWN_EXTENSIONS_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_MACHINERY_BREAKDOWN_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_CONS_LOSS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_CONS_LOSS", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__CONS_LOSS_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONS_LOSS_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONS_LOSS_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONS_LOSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONS_LOSS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONS_LOSS_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONS_LOSS_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "CONS_LOSS_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONS_LOSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONS_LOSS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=CONS_LOSS_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__CONS_LOSS_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONS_LOSS_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONS_LOSS_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONS_LOSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONS_LOSS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONS_LOSS_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONS_LOSS_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "CONS_LOSS_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONS_LOSS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONS_LOSS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_CONSE_LOSS_PROF_FEES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_CONSE_LOSS_PROF_FEES", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_LOSS_PROF_FEES_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_LOSS_PROF_FEES_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_LOSS_PROF_FEES_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_LOSS_PROF_FEES_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=CONSE_LOSS_PROF_FEES_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_LOSS_PROF_FEES_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_LOSS_PROF_FEES_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_LOSS_PROF_FEES_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_LOSS_PROF_FEES_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_LOSS_PROF_FEES == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_CONSE_OTHER_EXTENSIONS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_CONSE_OTHER_EXTENSIONS", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_SUMINSURED", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_EML", "Percentage");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_EML");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1",
            paramElseValue = "R",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=RISK_REINSURER&propertyName=CONSE_OTHER_EXTENSIONS_EML&name={name}");
        		
        		var value = new Expression("100"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_AMOUNT", "Currency");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_MOTIVATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_MOTIVATION", "Text");
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
        			field = Field.getInstance("RISK_REINSURER", "CONSE_OTHER_EXTENSIONS_MOTIVATION");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_CONSE_OTHER_EXTENSIONS == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__IS_TOTAL_RI_EXPOSURE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "IS_TOTAL_RI_EXPOSURE", "Checkbox");
        })();
}
function onValidate_RISK_REINSURER__TOTAL_RI_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "TOTAL_RI_SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=TOTAL_RI_SUMINSURED&name={name}");
        		
        		var value = new Expression("RISK_REINSURER.MACHINERY_SUMINSURED + RISK_REINSURER.LOSS_GROSS_SUMINSURED + RISK_REINSURER.MACHINERY_BREAKDOWN_COST_WORK_SUMINSURED + RISK_REINSURER.MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED + RISK_REINSURER.MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED + RISK_REINSURER.MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED + RISK_REINSURER.MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
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
        			field = Field.getInstance("RISK_REINSURER", "TOTAL_RI_SUMINSURED");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_TOTAL_RI_EXPOSURE == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_TOTAL_RI_EXPOSURE == 1",
            paramElseValue = "R",
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
}
function onValidate_RISK_REINSURER__TOTAL_RI_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_REINSURER", "TOTAL_RI_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=RISK_REINSURER&propertyName=TOTAL_RI_AMOUNT&name={name}");
        		
        		var value = new Expression("RISK_REINSURER.MACHINERY_AMOUNT + RISK_REINSURER.LOSS_GROSS_AMOUNT + RISK_REINSURER.MACHINERY_BREAKDOWN_COST_WORK_AMOUNT + RISK_REINSURER.MACHINERY_BREAKDOWN_PREP_COST_AMOUNT + RISK_REINSURER.MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT + RISK_REINSURER.MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT + RISK_REINSURER.MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
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
        			field = Field.getInstance("RISK_REINSURER", "TOTAL_RI_AMOUNT");
        		}
        		//window.setProperty(field, "V", "RISK_REINSURER.IS_TOTAL_RI_EXPOSURE == 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "RISK_REINSURER.IS_TOTAL_RI_EXPOSURE == 1",
            paramElseValue = "R",
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
}
function DoLogic(isOnLoad) {
    onValidate_RISK_REINSURER__IS_MACHINERY(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_LOSS_GROSS(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__LOSS_GROSS_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__LOSS_GROSS_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__LOSS_GROSS_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__LOSS_GROSS_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PREP_COST(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_MACHINEYR_BREAKDOWN_DETER_STOCK(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PROF_FEES(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_EXTENSIONS(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_CONS_LOSS(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONS_LOSS_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONS_LOSS_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONS_LOSS_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONS_LOSS_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_CONSE_LOSS_PROF_FEES(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_CONSE_OTHER_EXTENSIONS(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_EML(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_AMOUNT(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_MOTIVATION(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__IS_TOTAL_RI_EXPOSURE(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__TOTAL_RI_SUMINSURED(null, null, null, isOnLoad);
    onValidate_RISK_REINSURER__TOTAL_RI_AMOUNT(null, null, null, isOnLoad);
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
<div id="id5ef67d76eb4c48d1aaf0fea0d886261e" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmRI" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading32" runat="server" Text="Reinsurance" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_MACHINERY" for="ctl00_cntMainBody_RISK_REINSURER__IS_MACHINERY" class="col-md-4 col-sm-3 control-label">
		Machinery Breakdown</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_MACHINERY" 
		id="pb-container-checkbox-RISK_REINSURER-IS_MACHINERY">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_MACHINERY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_MACHINERY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Machinery Breakdown"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_MACHINERY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label11">
		<span class="label" id="label11"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_EML" 
		id="pb-container-percentage-RISK_REINSURER-MACHINERY_EML">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_EML" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__MACHINERY_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-MACHINERY_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__MACHINERY_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_LOSS_GROSS" for="ctl00_cntMainBody_RISK_REINSURER__IS_LOSS_GROSS" class="col-md-4 col-sm-3 control-label">
		Cons Loss Gross Profit/Revenue</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_LOSS_GROSS" 
		id="pb-container-checkbox-RISK_REINSURER-IS_LOSS_GROSS">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_LOSS_GROSS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_LOSS_GROSS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cons Loss Gross Profit/Revenue"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_LOSS_GROSS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label12">
		<span class="label" id="label12"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="LOSS_GROSS_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-LOSS_GROSS_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_LOSS_GROSS_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__LOSS_GROSS_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__LOSS_GROSS_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_LOSS_GROSS_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__LOSS_GROSS_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="LOSS_GROSS_EML" 
		id="pb-container-percentage-RISK_REINSURER-LOSS_GROSS_EML">
		<asp:Label ID="lblRISK_REINSURER_LOSS_GROSS_EML" runat="server" AssociatedControlID="RISK_REINSURER__LOSS_GROSS_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__LOSS_GROSS_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_LOSS_GROSS_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__LOSS_GROSS_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="LOSS_GROSS_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-LOSS_GROSS_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_LOSS_GROSS_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__LOSS_GROSS_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__LOSS_GROSS_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_LOSS_GROSS_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__LOSS_GROSS_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="LOSS_GROSS_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-LOSS_GROSS_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_LOSS_GROSS_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__LOSS_GROSS_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__LOSS_GROSS_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_LOSS_GROSS_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__LOSS_GROSS_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
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
		if ($("#frmRI div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmRI div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmRI div ul li").each(function(){		  
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
			$("#frmRI div ul li").each(function(){		  
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
		styleString += "#frmRI label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmRI label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmRI label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmRI label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmRI input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmRI input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmRI input{text-align:left;}"; break;
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
<div id="frmMachinery" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading33" runat="server" Text="Reinsurance - Machinery Breakdown" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_MACHINERY_BREAKDOWN_PREP_COST" for="ctl00_cntMainBody_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PREP_COST" class="col-md-4 col-sm-3 control-label">
		Claim Preparation Cost</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_MACHINERY_BREAKDOWN_PREP_COST" 
		id="pb-container-checkbox-RISK_REINSURER-IS_MACHINERY_BREAKDOWN_PREP_COST">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PREP_COST" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_MACHINERY_BREAKDOWN_PREP_COST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Claim Preparation Cost"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PREP_COST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label13">
		<span class="label" id="label13"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PREP_COST_EML" 
		id="pb-container-percentage-RISK_REINSURER-MACHINERY_BREAKDOWN_PREP_COST_EML">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_EML" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_PREP_COST_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PREP_COST_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_MACHINEYR_BREAKDOWN_DETER_STOCK" for="ctl00_cntMainBody_RISK_REINSURER__IS_MACHINEYR_BREAKDOWN_DETER_STOCK" class="col-md-4 col-sm-3 control-label">
		Deterioration of Stock</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_MACHINEYR_BREAKDOWN_DETER_STOCK" 
		id="pb-container-checkbox-RISK_REINSURER-IS_MACHINEYR_BREAKDOWN_DETER_STOCK">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_MACHINEYR_BREAKDOWN_DETER_STOCK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_MACHINEYR_BREAKDOWN_DETER_STOCK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Deterioration of Stock"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_MACHINEYR_BREAKDOWN_DETER_STOCK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label14">
		<span class="label" id="label14"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_DETER_STOCK_EML" 
		id="pb-container-percentage-RISK_REINSURER-MACHINERY_BREAKDOWN_DETER_STOCK_EML">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_EML" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_DETER_STOCK_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_MACHINERY_BREAKDOWN_PROF_FEES" for="ctl00_cntMainBody_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PROF_FEES" class="col-md-4 col-sm-3 control-label">
		Professional Fees</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_MACHINERY_BREAKDOWN_PROF_FEES" 
		id="pb-container-checkbox-RISK_REINSURER-IS_MACHINERY_BREAKDOWN_PROF_FEES">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PROF_FEES" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_MACHINERY_BREAKDOWN_PROF_FEES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Professional Fees"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_PROF_FEES" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label15">
		<span class="label" id="label15"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PROF_FEES_EML" 
		id="pb-container-percentage-RISK_REINSURER-MACHINERY_BREAKDOWN_PROF_FEES_EML">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_EML" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_PROF_FEES_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_MACHINERY_BREAKDOWN_EXTENSIONS" for="ctl00_cntMainBody_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_EXTENSIONS" class="col-md-4 col-sm-3 control-label">
		Other Extensions</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_MACHINERY_BREAKDOWN_EXTENSIONS" 
		id="pb-container-checkbox-RISK_REINSURER-IS_MACHINERY_BREAKDOWN_EXTENSIONS">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_MACHINERY_BREAKDOWN_EXTENSIONS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_MACHINERY_BREAKDOWN_EXTENSIONS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Other Extensions"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_MACHINERY_BREAKDOWN_EXTENSIONS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label16">
		<span class="label" id="label16"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_EXTENSIONS_EML" 
		id="pb-container-percentage-RISK_REINSURER-MACHINERY_BREAKDOWN_EXTENSIONS_EML">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_EML" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__MACHINERY_BREAKDOWN_EXTENSIONS_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
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
		if ($("#frmMachinery div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmMachinery div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmMachinery div ul li").each(function(){		  
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
			$("#frmMachinery div ul li").each(function(){		  
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
		styleString += "#frmMachinery label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmMachinery label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMachinery label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMachinery label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmMachinery input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMachinery input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMachinery input{text-align:left;}"; break;
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
<div id="frmEndorsement" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading34" runat="server" Text="Reinsurance - Consequential Loss" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_CONS_LOSS" for="ctl00_cntMainBody_RISK_REINSURER__IS_CONS_LOSS" class="col-md-4 col-sm-3 control-label">
		Claim Preparation Cost</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_CONS_LOSS" 
		id="pb-container-checkbox-RISK_REINSURER-IS_CONS_LOSS">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_CONS_LOSS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_CONS_LOSS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Claim Preparation Cost"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_CONS_LOSS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label17">
		<span class="label" id="label17"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="CONS_LOSS_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-CONS_LOSS_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_CONS_LOSS_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__CONS_LOSS_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONS_LOSS_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONS_LOSS_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONS_LOSS_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONS_LOSS_EML" 
		id="pb-container-percentage-RISK_REINSURER-CONS_LOSS_EML">
		<asp:Label ID="lblRISK_REINSURER_CONS_LOSS_EML" runat="server" AssociatedControlID="RISK_REINSURER__CONS_LOSS_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__CONS_LOSS_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONS_LOSS_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONS_LOSS_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONS_LOSS_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-CONS_LOSS_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_CONS_LOSS_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__CONS_LOSS_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONS_LOSS_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONS_LOSS_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONS_LOSS_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="CONS_LOSS_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-CONS_LOSS_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_CONS_LOSS_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__CONS_LOSS_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__CONS_LOSS_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_CONS_LOSS_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__CONS_LOSS_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_CONSE_LOSS_PROF_FEES" for="ctl00_cntMainBody_RISK_REINSURER__IS_CONSE_LOSS_PROF_FEES" class="col-md-4 col-sm-3 control-label">
		Professional Fees</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_CONSE_LOSS_PROF_FEES" 
		id="pb-container-checkbox-RISK_REINSURER-IS_CONSE_LOSS_PROF_FEES">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_CONSE_LOSS_PROF_FEES" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_CONSE_LOSS_PROF_FEES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Professional Fees"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_CONSE_LOSS_PROF_FEES" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label18">
		<span class="label" id="label18"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_LOSS_PROF_FEES_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-CONSE_LOSS_PROF_FEES_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_CONSE_LOSS_PROF_FEES_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_LOSS_PROF_FEES_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_LOSS_PROF_FEES_EML" 
		id="pb-container-percentage-RISK_REINSURER-CONSE_LOSS_PROF_FEES_EML">
		<asp:Label ID="lblRISK_REINSURER_CONSE_LOSS_PROF_FEES_EML" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_LOSS_PROF_FEES_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_LOSS_PROF_FEES_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-CONSE_LOSS_PROF_FEES_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_CONSE_LOSS_PROF_FEES_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_LOSS_PROF_FEES_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_LOSS_PROF_FEES_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-CONSE_LOSS_PROF_FEES_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_CONSE_LOSS_PROF_FEES_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__CONSE_LOSS_PROF_FEES_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_CONSE_LOSS_PROF_FEES_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_LOSS_PROF_FEES_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_CONSE_OTHER_EXTENSIONS" for="ctl00_cntMainBody_RISK_REINSURER__IS_CONSE_OTHER_EXTENSIONS" class="col-md-4 col-sm-3 control-label">
		Other Extensions</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_CONSE_OTHER_EXTENSIONS" 
		id="pb-container-checkbox-RISK_REINSURER-IS_CONSE_OTHER_EXTENSIONS">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_CONSE_OTHER_EXTENSIONS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_CONSE_OTHER_EXTENSIONS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Other Extensions"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_CONSE_OTHER_EXTENSIONS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label19">
		<span class="label" id="label19"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_OTHER_EXTENSIONS_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-CONSE_OTHER_EXTENSIONS_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_CONSE_OTHER_EXTENSIONS_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_OTHER_EXTENSIONS_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_OTHER_EXTENSIONS_EML" 
		id="pb-container-percentage-RISK_REINSURER-CONSE_OTHER_EXTENSIONS_EML">
		<asp:Label ID="lblRISK_REINSURER_CONSE_OTHER_EXTENSIONS_EML" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_EML" 
			Text="EML %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_OTHER_EXTENSIONS_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EML %"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_EML" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_OTHER_EXTENSIONS_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-CONSE_OTHER_EXTENSIONS_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_CONSE_OTHER_EXTENSIONS_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_CONSE_OTHER_EXTENSIONS_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_REINSURER" 
		data-property-name="CONSE_OTHER_EXTENSIONS_MOTIVATION" 
		 
		
		 
		id="pb-container-text-RISK_REINSURER-CONSE_OTHER_EXTENSIONS_MOTIVATION">

		
		<asp:Label ID="lblRISK_REINSURER_CONSE_OTHER_EXTENSIONS_MOTIVATION" runat="server" AssociatedControlID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_MOTIVATION" 
			Text="Motivation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_REINSURER__CONSE_OTHER_EXTENSIONS_MOTIVATION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_REINSURER_CONSE_OTHER_EXTENSIONS_MOTIVATION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motivation"
					ClientValidationFunction="onValidate_RISK_REINSURER__CONSE_OTHER_EXTENSIONS_MOTIVATION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_REINSURER_IS_TOTAL_RI_EXPOSURE" for="ctl00_cntMainBody_RISK_REINSURER__IS_TOTAL_RI_EXPOSURE" class="col-md-4 col-sm-3 control-label">
		Total RI Exposure</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_REINSURER" 
		data-property-name="IS_TOTAL_RI_EXPOSURE" 
		id="pb-container-checkbox-RISK_REINSURER-IS_TOTAL_RI_EXPOSURE">	
		
		<asp:TextBox ID="RISK_REINSURER__IS_TOTAL_RI_EXPOSURE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_REINSURER_IS_TOTAL_RI_EXPOSURE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total RI Exposure"
			ClientValidationFunction="onValidate_RISK_REINSURER__IS_TOTAL_RI_EXPOSURE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label20">
		<span class="label" id="label20"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RISK_REINSURER" 
		data-property-name="TOTAL_RI_SUMINSURED" 
		id="pb-container-currency-RISK_REINSURER-TOTAL_RI_SUMINSURED">
		<asp:Label ID="lblRISK_REINSURER_TOTAL_RI_SUMINSURED" runat="server" AssociatedControlID="RISK_REINSURER__TOTAL_RI_SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__TOTAL_RI_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_TOTAL_RI_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_RISK_REINSURER__TOTAL_RI_SUMINSURED" 
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
		data-object-name="RISK_REINSURER" 
		data-property-name="TOTAL_RI_AMOUNT" 
		id="pb-container-currency-RISK_REINSURER-TOTAL_RI_AMOUNT">
		<asp:Label ID="lblRISK_REINSURER_TOTAL_RI_AMOUNT" runat="server" AssociatedControlID="RISK_REINSURER__TOTAL_RI_AMOUNT" 
			Text="Amount to Post to RI" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RISK_REINSURER__TOTAL_RI_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRISK_REINSURER_TOTAL_RI_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount to Post to RI"
			ClientValidationFunction="onValidate_RISK_REINSURER__TOTAL_RI_AMOUNT" 
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
		if ($("#frmEndorsement div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmEndorsement div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmEndorsement div ul li").each(function(){		  
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
			$("#frmEndorsement div ul li").each(function(){		  
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
		styleString += "#frmEndorsement label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmEndorsement label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmEndorsement label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmEndorsement label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmEndorsement input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmEndorsement input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmEndorsement input{text-align:left;}"; break;
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