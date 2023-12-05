<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MOTSPEC_Extensions.aspx.vb" Inherits="Nexus.PB2_MOTSPEC_Extensions" %>

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
		
		function SetVehicleDetails(response) {
			var Data = response.split(";");
			console.log(Data);
			Field.getInstance('RISK_DETAILS','MM_CODE').setValue(Data[0]);
			Field.getInstance('RISK_DETAILS','VEHICLE_MAKE').setValue(Data[1]);
			Field.getInstance('RISK_DETAILS','VEHICLE_MODEL').setValue(Data[2]);
			Field.getInstance('RISK_DETAILS','MAKEMODEL').setValue(Data[3]);
			if (Data[4] != -1){
                Field.getInstance('RISK_DETAILS', 'YEAR_MAN').setValue(Data[4]);
			}
            Field.getInstance('RISK_DETAILS','NO_SEATS').setValue(Data[5]);			
			Field.getInstance('RISK_DETAILS','BODTYPECODE').setValue(Data[6]);
			Field.getInstance('RISK_DETAILS','CC').setValue(Data[7]);
			Field.getInstance('RISK_DETAILS','GVM').setValue(Data[8]);
			Field.getInstance('RISK_DETAILS','POWER_WEIGHT_RATIO').setValue(Data[9]);
			Field.getInstance('RISK_DETAILS','TYPEVEHICLECODE').setValue(Data[10]);
			Field.getInstance('RISK_DETAILS','VehicleValue').setValue(Data[11]);

			__doPostBack('', '')
		}

		function SetCTDetails(response) {
			var Data = response.split(";");
			Field.getInstance('RISK_DETAILS','MM_CODE').setValue(Data[0]);
			Field.getInstance('RISK_DETAILS','MAKEMODEL').setValue(Data[1]);
			Field.getInstance('RISK_DETAILS','VEHICLE_MAKE').setValue(Data[1]);

			__doPostBack('', '')
		}
		
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
function onValidate_MS_EXTENSIONS__LOSS_KEYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_KEYS_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.LOSS_KEYS = 1", "V", "Loss of Keys Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.LOSS_KEYS = 1",
            paramElseValue = "V",
            paramValidationMessage = "Loss of Keys Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_KEYS_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 1")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.LOSS_KEYS_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.LOSS_KEYS_LIMIT = '' OR MS_EXTENSIONS.LOSS_KEYS_LIMIT = null) and MS_EXTENSIONS.LOSS_KEYS = 1")) ? new Expression("(MS_EXTENSIONS.LOSS_KEYS_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.LOSS_KEYS_LIMIT = '' OR MS_EXTENSIONS.LOSS_KEYS_LIMIT = null) and MS_EXTENSIONS.LOSS_KEYS = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 0")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_KEYS_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.LOSS_KEYS_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_KEYS_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 0")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_KEYS_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.LOSS_KEYS = 1", "V", "Loss of Keys Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.LOSS_KEYS = 1",
            paramElseValue = "V",
            paramValidationMessage = "Loss of Keys Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_KEYS_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 1")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 0")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_KEYS_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.LOSS_KEYS = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.LOSS_KEYS = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_KEYS_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 0")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_KEYS_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_KEYS_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.LOSS_KEYS = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.LOSS_KEYS = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_KEYS_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_KEYS_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_KEYS_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_KEYS = 0")) ? new Expression("MS_EXTENSIONS.LOSS_KEYS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CAR_HIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_HIRE", "Checkbox");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE");
        		}
        		//window.setProperty(field, "VE", "MS.COVERTYPECode = 1 AND (MS.TYPEMSCode = 3 OR MS.TYPEMSCode = 5)", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS.COVERTYPECode = 1 AND (MS.TYPEMSCode = 3 OR MS.TYPEMSCode = 5)",
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
}
function onValidate_MS_EXTENSIONS__CAR_HIRE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_HIRE_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.CAR_HIRE = 1", "V", "Vehicle Hire Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.CAR_HIRE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Vehicle Hire Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CAR_HIRE_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 1")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CAR_HIRE_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 0")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CAR_HIRE_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_HIRE_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CAR_HIRE_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.CAR_HIRE_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CAR_HIRE_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CAR_HIRE_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 0")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CAR_HIRE_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_HIRE_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.CAR_HIRE = 1", "V", "Vehicle Hire Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.CAR_HIRE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Vehicle Hire Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CAR_HIRE_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 1")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CAR_HIRE_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 0")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CAR_HIRE_DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_HIRE_DAYS", "List");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_DAYS");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.CAR_HIRE = 1", "V", "Vehicle Hire No of Days is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.CAR_HIRE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Vehicle Hire No of Days is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CAR_HIRE_DAYS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 1")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 1") : null;
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
        		var field = Field.getWithQuery("type=List&objectName=MS_EXTENSIONS&propertyName=CAR_HIRE_DAYS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CAR_HIRE = 0")) ? new Expression("MS_EXTENSIONS.CAR_HIRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_USE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_USE", "Checkbox");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE");
        		}
        		//window.setProperty(field, "VE", "MS.COVERTYPECode = 1 AND (MS.TYPEMSCode = 1 OR MS.TYPEMSCode = 2 OR MS.TYPEMSCode = 6)", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS.COVERTYPECode = 1 AND (MS.TYPEMSCode = 1 OR MS.TYPEMSCode = 2 OR MS.TYPEMSCode = 6)",
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
}
function onValidate_MS_EXTENSIONS__LOSS_USE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_USE_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.LOSS_USE = 1", "V", "Loss of Use Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.LOSS_USE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Loss of Use Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_USE_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 1")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_USE_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 0")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_USE_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_USE_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_USE_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.LOSS_USE_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_USE_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_USE_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 0")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_USE_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_USE_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.LOSS_USE = 1", "V", "Loss of Use Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.LOSS_USE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Loss of Use Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'LOSS_USE_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 1")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=LOSS_USE_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 0")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_USE_DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_USE_DAYS", "Integer");
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
        			field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_DAYS");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.LOSS_USE = 1", "V", "Loss of UseNo of Days is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.LOSS_USE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Loss of UseNo of Days is mandatory and an amount must be entered";
            
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Loss of Use No of Days cannot be more than 30")) ? "Loss of Use No of Days cannot be more than 30" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MS_EXTENSIONS".toUpperCase() + "__" + "LOSS_USE_DAYS");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MS_EXTENSIONS".toUpperCase() + "_" + "LOSS_USE_DAYS");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MS_EXTENSIONS.LOSS_USE_DAYS < 31 AND MS_EXTENSIONS.LOSS_USE_DAYS >= 0");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "LOSS_USE_DAYS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 1")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 1") : null;
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
        		var field = Field.getWithQuery("type=Integer&objectName=MS_EXTENSIONS&propertyName=LOSS_USE_DAYS&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.LOSS_USE = 0")) ? new Expression("MS_EXTENSIONS.LOSS_USE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.CRED_SHOR = 1", "V", "Credit Shortfall Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.CRED_SHOR = 1",
            paramElseValue = "V",
            paramValidationMessage = "Credit Shortfall Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CRED_SHOR_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 1")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.CRED_SHOR_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.CRED_SHOR_LIMIT = '' OR MS_EXTENSIONS.CRED_SHOR_LIMIT = null) and MS_EXTENSIONS.CRED_SHOR = 1")) ? new Expression("(MS_EXTENSIONS.CRED_SHOR_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.CRED_SHOR_LIMIT = '' OR MS_EXTENSIONS.CRED_SHOR_LIMIT = null) and MS_EXTENSIONS.CRED_SHOR = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 0")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.CRED_SHOR_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CRED_SHOR_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 0")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.CRED_SHOR = 1", "V", "Credit Shortfall Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.CRED_SHOR = 1",
            paramElseValue = "V",
            paramValidationMessage = "Credit Shortfall Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CRED_SHOR_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 1")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 0")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.CRED_SHOR = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.CRED_SHOR = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CRED_SHOR_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.CRED_SHOR_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 0")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__CRED_SHOR_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CRED_SHOR_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.CRED_SHOR = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.CRED_SHOR = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "CRED_SHOR_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'CRED_SHOR_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.CRED_SHOR_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=CRED_SHOR_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.CRED_SHOR = 0")) ? new Expression("MS_EXTENSIONS.CRED_SHOR = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=DEP_PRO&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.DEP_PRO = 1", "V", "Deposit Protector Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.DEP_PRO = 1",
            paramElseValue = "V",
            paramValidationMessage = "Deposit Protector Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'DEP_PRO_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 1")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.DEP_PRO_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.DEP_PRO_LIMIT = '' OR MS_EXTENSIONS.DEP_PRO_LIMIT = null) and MS_EXTENSIONS.DEP_PRO = 1")) ? new Expression("(MS_EXTENSIONS.DEP_PRO_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.DEP_PRO_LIMIT = '' OR MS_EXTENSIONS.DEP_PRO_LIMIT = null) and MS_EXTENSIONS.DEP_PRO = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 0")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.DEP_PRO_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'DEP_PRO_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 0")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.DEP_PRO = 1", "V", "Deposit Protector Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.DEP_PRO = 1",
            paramElseValue = "V",
            paramValidationMessage = "Deposit Protector Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'DEP_PRO_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 1")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 0")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.DEP_PRO = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.DEP_PRO = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'DEP_PRO_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.DEP_PRO_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 0")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DEP_PRO_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DEP_PRO_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.DEP_PRO = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.DEP_PRO = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "DEP_PRO_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'DEP_PRO_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.DEP_PRO_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=DEP_PRO_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.DEP_PRO = 0")) ? new Expression("MS_EXTENSIONS.DEP_PRO = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_EXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_EXT", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_NON_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_NON_LOI", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_NON_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_NON_PREM", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_NON_POSTPRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_NON_POSTPRE", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_NON_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_NON_FAP", "Percentage");
        })();
}
function onValidate_MS_EXTENSIONS__DRIVER_NON_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "DRIVER_NON_MIN", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT_LOI", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT_PREM", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT_POSTPRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT_POSTPRE", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT_FAP", "Percentage");
        })();
}
function onValidate_MS_EXTENSIONS__FIRE_EXT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "FIRE_EXT_MIN", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TRAIL_COM = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TRAIL_COM = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TRAIL_COM_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 1")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.TRAIL_COM_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TRAIL_COM_LIMIT = '' OR MS_EXTENSIONS.TRAIL_COM_LIMIT = null) and MS_EXTENSIONS.TRAIL_COM = 1")) ? new Expression("(MS_EXTENSIONS.TRAIL_COM_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TRAIL_COM_LIMIT = '' OR MS_EXTENSIONS.TRAIL_COM_LIMIT = null) and MS_EXTENSIONS.TRAIL_COM = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 0")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM_PREM", "Currency");
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.TRAIL_COM_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TRAIL_COM_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 0")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TRAIL_COM = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TRAIL_COM = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TRAIL_COM_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 1")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 0")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TRAIL_COM = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TRAIL_COM = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TRAIL_COM_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.TRAIL_COM_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 0")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TRAIL_COM_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TRAIL_COM_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TRAIL_COM = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TRAIL_COM = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TRAIL_COM_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TRAIL_COM_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.TRAIL_COM_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TRAIL_COM_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TRAIL_COM = 0")) ? new Expression("MS_EXTENSIONS.TRAIL_COM = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.WIND_EX_RED = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.WIND_EX_RED = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WIND_EX_RED_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 1")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.WIND_EX_RED_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.WIND_EX_RED_LIMIT = '' OR MS_EXTENSIONS.WIND_EX_RED_LIMIT = null) and MS_EXTENSIONS.WIND_EX_RED = 1")) ? new Expression("(MS_EXTENSIONS.WIND_EX_RED_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.WIND_EX_RED_LIMIT = '' OR MS_EXTENSIONS.WIND_EX_RED_LIMIT = null) and MS_EXTENSIONS.WIND_EX_RED = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 0")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.WIND_EX_RED_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WIND_EX_RED_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 0")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.WIND_EX_RED = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.WIND_EX_RED = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WIND_EX_RED_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 1")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 0")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.WIND_EX_RED = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.WIND_EX_RED = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WIND_EX_RED_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 0")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WIND_EX_RED_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WIND_EX_RED_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.WIND_EX_RED = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.WIND_EX_RED = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WIND_EX_RED_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WIND_EX_RED_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WIND_EX_RED_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WIND_EX_RED = 0")) ? new Expression("MS_EXTENSIONS.WIND_EX_RED = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=POL_SPIL&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.POL_SPIL = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.POL_SPIL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'POL_SPIL_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 1")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.POL_SPIL_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.POL_SPIL_LIMIT = '' OR MS_EXTENSIONS.POL_SPIL_LIMIT = null) and MS_EXTENSIONS.POL_SPIL = 1")) ? new Expression("(MS_EXTENSIONS.POL_SPIL_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.POL_SPIL_LIMIT = '' OR MS_EXTENSIONS.POL_SPIL_LIMIT = null) and MS_EXTENSIONS.POL_SPIL = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 0")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.POL_SPIL_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'POL_SPIL_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 0")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.POL_SPIL = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.POL_SPIL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'POL_SPIL_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 1")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 0")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.POL_SPIL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.POL_SPIL = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'POL_SPIL_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.POL_SPIL_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 0")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__POL_SPIL_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "POL_SPIL_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.POL_SPIL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.POL_SPIL = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "POL_SPIL_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'POL_SPIL_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.POL_SPIL_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=POL_SPIL_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.POL_SPIL = 0")) ? new Expression("MS_EXTENSIONS.POL_SPIL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=REC&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REC_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.REC = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.REC = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REC_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 1")) ? new Expression("MS_EXTENSIONS.REC = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.REC_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.REC_LIMIT = '' OR MS_EXTENSIONS.REC_LIMIT = null) and MS_EXTENSIONS.REC = 1")) ? new Expression("(MS_EXTENSIONS.REC_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.REC_LIMIT = '' OR MS_EXTENSIONS.REC_LIMIT = null) and MS_EXTENSIONS.REC = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 0")) ? new Expression("MS_EXTENSIONS.REC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "REC_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.REC_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REC_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 0")) ? new Expression("MS_EXTENSIONS.REC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REC_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.REC = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.REC = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REC_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 1")) ? new Expression("MS_EXTENSIONS.REC = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 0")) ? new Expression("MS_EXTENSIONS.REC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REC_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.REC = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.REC = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REC_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=REC_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.REC_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=REC_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 0")) ? new Expression("MS_EXTENSIONS.REC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REC_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REC_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REC_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.REC = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.REC = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REC_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REC_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.REC_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REC_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REC = 0")) ? new Expression("MS_EXTENSIONS.REC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=REP&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REP_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP_LOI", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__REP_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP_PREM", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__REP_POSTPRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP_POSTPRE", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__REP_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP_FAP", "Percentage");
        })();
}
function onValidate_MS_EXTENSIONS__REP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REP_MIN", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=REPSAL&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REPSAL_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.REPSAL = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.REPSAL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REPSAL_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 1")) ? new Expression("MS_EXTENSIONS.REPSAL = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.REPSAL_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.REPSAL_LIMIT = '' OR MS_EXTENSIONS.REPSAL_LIMIT = null) and MS_EXTENSIONS.REPSAL = 1")) ? new Expression("(MS_EXTENSIONS.REPSAL_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.REPSAL_LIMIT = '' OR MS_EXTENSIONS.REPSAL_LIMIT = null) and MS_EXTENSIONS.REPSAL = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 0")) ? new Expression("MS_EXTENSIONS.REPSAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.REPSAL_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REPSAL_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 0")) ? new Expression("MS_EXTENSIONS.REPSAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REPSAL_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.REPSAL = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.REPSAL = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REPSAL_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 1")) ? new Expression("MS_EXTENSIONS.REPSAL = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 0")) ? new Expression("MS_EXTENSIONS.REPSAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REPSAL_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.REPSAL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.REPSAL = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REPSAL_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=REPSAL_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.REPSAL_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=REPSAL_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 0")) ? new Expression("MS_EXTENSIONS.REPSAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__REPSAL_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "REPSAL_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "REPSAL_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.REPSAL = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.REPSAL = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "REPSAL_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'REPSAL_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.REPSAL_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=REPSAL_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.REPSAL = 0")) ? new Expression("MS_EXTENSIONS.REPSAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MS_EXTENSIONS&propertyName=THPAEXRE&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("MS.COVERTYPECode = 1")) ? new Expression("MS.COVERTYPECode = 1") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.THPAEXRE = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.THPAEXRE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'THPAEXRE_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 1")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.THPAEXRE_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.THPAEXRE_LIMIT = '' OR MS_EXTENSIONS.THPAEXRE_LIMIT = null) and MS_EXTENSIONS.THPAEXRE = 1")) ? new Expression("(MS_EXTENSIONS.THPAEXRE_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.THPAEXRE_LIMIT = '' OR MS_EXTENSIONS.THPAEXRE_LIMIT = null) and MS_EXTENSIONS.THPAEXRE = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 0")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.THPAEXRE_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'THPAEXRE_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 0")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.THPAEXRE = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.THPAEXRE = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'THPAEXRE_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 1")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 0")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.THPAEXRE = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.THPAEXRE = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'THPAEXRE_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.THPAEXRE_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 0")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__THPAEXRE_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "THPAEXRE_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.THPAEXRE = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.THPAEXRE = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "THPAEXRE_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'THPAEXRE_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.THPAEXRE_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=THPAEXRE_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.THPAEXRE = 0")) ? new Expression("MS_EXTENSIONS.THPAEXRE = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__label98(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "label98", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__TOT_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOT_LIMIT", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__TOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOT_PREM", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__TOT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOT_POST_PREM", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__TOT_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOT_FAP_PER", "Percentage");
        })();
}
function onValidate_MS_EXTENSIONS__TOT_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOT_MIN_AMT", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__label101(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "label101", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__TOTLTHIJER_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTLTHIJER_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TOTLTHIJER = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TOTLTHIJER = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTLTHIJER_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 1")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.TOTLTHIJER_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TOTLTHIJER_LIMIT = '' OR MS_EXTENSIONS.TOTLTHIJER_LIMIT = null) and MS_EXTENSIONS.TOTLTHIJER = 1")) ? new Expression("(MS_EXTENSIONS.TOTLTHIJER_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TOTLTHIJER_LIMIT = '' OR MS_EXTENSIONS.TOTLTHIJER_LIMIT = null) and MS_EXTENSIONS.TOTLTHIJER = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 0")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTLTHIJER_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTLTHIJER_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.TOTLTHIJER_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTLTHIJER_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 0")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTLTHIJER_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTLTHIJER_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TOTLTHIJER = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TOTLTHIJER = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTLTHIJER_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 1")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 0")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTLTHIJER_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTLTHIJER_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TOTLTHIJER = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TOTLTHIJER = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTLTHIJER_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 0")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTLTHIJER_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTLTHIJER_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TOTLTHIJER = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TOTLTHIJER = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTLTHIJER_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTLTHIJER_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTLTHIJER_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTLTHIJER = 0")) ? new Expression("MS_EXTENSIONS.TOTLTHIJER = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__label104(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "label104", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__TOTCFMB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTCFMB_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TOTCFMB = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TOTCFMB = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTCFMB_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 1")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.TOTCFMB_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TOTCFMB_LIMIT = '' OR MS_EXTENSIONS.TOTCFMB_LIMIT = null) and MS_EXTENSIONS.TOTCFMB = 1")) ? new Expression("(MS_EXTENSIONS.TOTCFMB_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.TOTCFMB_LIMIT = '' OR MS_EXTENSIONS.TOTCFMB_LIMIT = null) and MS_EXTENSIONS.TOTCFMB = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 0")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTCFMB_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTCFMB_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.TOTCFMB_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTCFMB_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 0")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTCFMB_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTCFMB_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.TOTCFMB = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.TOTCFMB = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTCFMB_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 1")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 0")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTCFMB_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTCFMB_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TOTCFMB = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TOTCFMB = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTCFMB_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.TOTCFMB_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB = 0")) ? new Expression("MS_EXTENSIONS.TOTCFMB = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__TOTCFMB_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTCFMB_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.TOTCFMB = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.TOTCFMB = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "TOTCFMB_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTCFMB_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTCFMB_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.TOTCFMB_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.TOTCFMB_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__label107(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "label107", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__EXT_TERT_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TERT_LIMIT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.EXT_TERT = 1", "V", "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.EXT_TERT = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Limit of Indemnity is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'EXT_TERT_LIMIT');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_LIMIT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 1")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_LIMIT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_LOI"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.EXT_TERT_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.EXT_TERT_LIMIT = '' OR MS_EXTENSIONS.EXT_TERT_LIMIT = null) and MS_EXTENSIONS.EXT_TERT = 1")) ? new Expression("(MS_EXTENSIONS.EXT_TERT_LIMIT < GENERAL.EXT_LK_LOI or MS_EXTENSIONS.EXT_TERT_LIMIT = '' OR MS_EXTENSIONS.EXT_TERT_LIMIT = null) and MS_EXTENSIONS.EXT_TERT = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_LIMIT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 0")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__EXT_TERT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TERT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.EXT_TERT_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'EXT_TERT_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 0")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__EXT_TERT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TERT_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.EXT_TERT = 1", "V", "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.EXT_TERT = 1",
            paramElseValue = "V",
            paramValidationMessage = "Driver Non-Motor Liability Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'EXT_TERT_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 1")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 0")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__EXT_TERT_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TERT_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_FAP_PER");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.EXT_TERT = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.EXT_TERT = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'EXT_TERT_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_FAP"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT_FAP_PER < GENERAL.EXT_LK_FAP")) ? new Expression("MS_EXTENSIONS.EXT_TERT_FAP_PER < GENERAL.EXT_LK_FAP") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 0")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__EXT_TERT_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TERT_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.EXT_TERT = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.EXT_TERT = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "EXT_TERT_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'EXT_TERT_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_MIN_AMT&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_LK_MIN"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT_MIN_AMT < GENERAL.EXT_LK_MIN")) ? new Expression("MS_EXTENSIONS.EXT_TERT_MIN_AMT < GENERAL.EXT_LK_MIN") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=EXT_TERT_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.EXT_TERT = 0")) ? new Expression("MS_EXTENSIONS.EXT_TERT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__RIOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "RIOT", "Checkbox");
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
        			field = Field.getInstance("MS_EXTENSIONS", "RIOT");
        		}
        		//window.setProperty(field, "V", "MS.COVERTYPECode = 2", "VE", "{3}");
        
            var paramValue = "V",
            paramCondition = "MS.COVERTYPECode = 2",
            paramElseValue = "VE",
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
function onValidate_MS_EXTENSIONS__RIOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "RIOT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "RIOT_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MS_EXTENSIONS", "RIOT_PREM");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=RIOT_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.RIOT_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'RIOT_PREM');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=RIOT_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.RIOT = 0")) ? new Expression("MS_EXTENSIONS.RIOT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__RIOT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "RIOT_POST_PREM", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "RIOT_POST_PREM");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.RIOT = 1", "V", "Riot & Strike Posting Premium is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.RIOT = 1",
            paramElseValue = "V",
            paramValidationMessage = "Riot & Strike Posting Premium is mandatory and an amount must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "RIOT_POST_PREM");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'RIOT_POST_PREM');
        			
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
        		var field = Field.getInstance("MS_EXTENSIONS", "RIOT_POST_PREM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("MS_EXTENSIONS.RIOT = 1")) ? new Expression("MS_EXTENSIONS.RIOT = 1") : null;
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=RIOT_POST_PREM&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.RIOT = 0")) ? new Expression("MS_EXTENSIONS.RIOT = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WINDSCREEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WINDSCREEN", "Checkbox");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WINDSCREEN");
        		}
        		//window.setProperty(field, "VE", "MS.COVERTYPECode = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS.COVERTYPECode = 1",
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
}
function onValidate_MS_EXTENSIONS__WINDSCREEN_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WINDSCREEN_FAP_PER", "Percentage");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WINDSCREEN_FAP_PER");
        		}
        		//window.setProperty(field, "VEM", "MS_EXTENSIONS.WINDSCREEN = 1", "V", "Windscreen FAP% is mandatory and a percentage must be entered");
        
            var paramValue = "VEM",
            paramCondition = "MS_EXTENSIONS.WINDSCREEN = 1",
            paramElseValue = "V",
            paramValidationMessage = "Windscreen FAP% is mandatory and a percentage must be entered";
            
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WINDSCREEN_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WINDSCREEN_FAP_PER');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=WINDSCREEN_FAP_PER&name={name}");
        		
        		var value = new Expression("GENERAL.EXT_WS_FAP"), 
        			condition = (Expression.isValidParameter("(MS_EXTENSIONS.WINDSCREEN_FAP_PER < GENERAL.EXT_WS_FAP OR MS_EXTENSIONS.WINDSCREEN_FAP_PER = '' OR MS_EXTENSIONS.WINDSCREEN_FAP_PER = null) and MS_EXTENSIONS.WINDSCREEN = 1")) ? new Expression("(MS_EXTENSIONS.WINDSCREEN_FAP_PER < GENERAL.EXT_WS_FAP OR MS_EXTENSIONS.WINDSCREEN_FAP_PER = '' OR MS_EXTENSIONS.WINDSCREEN_FAP_PER = null) and MS_EXTENSIONS.WINDSCREEN = 1") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=MS_EXTENSIONS&propertyName=WINDSCREEN_FAP_PER&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WINDSCREEN = 0")) ? new Expression("MS_EXTENSIONS.WINDSCREEN = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__WINDSCREEN_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "WINDSCREEN_MIN_AMT", "Currency");
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
        			field = Field.getInstance("MS_EXTENSIONS", "WINDSCREEN_MIN_AMT");
        		}
        		//window.setProperty(field, "VE", "MS_EXTENSIONS.WINDSCREEN = 1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MS_EXTENSIONS.WINDSCREEN = 1",
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
        		var field = Field.getInstance("MS_EXTENSIONS", "WINDSCREEN_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'WINDSCREEN_MIN_AMT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=WINDSCREEN_MIN_AMT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MS_EXTENSIONS.WINDSCREEN = 0")) ? new Expression("MS_EXTENSIONS.WINDSCREEN = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MS_EXTENSIONS__IS_NASRIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "IS_NASRIA", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__IS_NASRIALOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "IS_NASRIALOI", "Currency");
        })();
}
function onValidate_MS_EXTENSIONS__ROAD_ASSIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "ROAD_ASSIST", "Checkbox");
        })();
}
function onValidate_MS_EXTENSIONS__TOTAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTAL_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "TOTAL_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTAL_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.EXT_TERITORY_PREM + MS_EXTENSIONS.LOSS_KEYS_PREM + MS_EXTENSIONS.RIOT_PREM + MS_EXTENSIONS.WRECKAGE_PREM + MS_EXTENSIONS.EXCESS_PREM + MS_EXTENSIONS.CAR_HIRE_PREM + MS_EXTENSIONS.LOSS_USE_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTAL_PREM');
        			
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
function onValidate_MS_EXTENSIONS__TOTAL_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "TOTAL_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("MS_EXTENSIONS", "TOTAL_POST_PREM");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MS_EXTENSIONS&propertyName=TOTAL_POST_PREM&name={name}");
        		
        		var value = new Expression("MS_EXTENSIONS.EXT_TERITORY_POST_PREM + MS_EXTENSIONS.LOSS_KEYS_POST_PREM + MS_EXTENSIONS.RIOT_POST_PREM + MS_EXTENSIONS.WRECKAGE_POST_PREM + MS_EXTENSIONS.EXCESS_POST_PREM + MS_EXTENSIONS.CAR_HIRE_POST_PREM + MS_EXTENSIONS.LOSS_USE_POST_PREM"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MS_EXTENSIONS', 'TOTAL_POST_PREM');
        			
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
function onValidate_MS_EXTENSIONS__EXT_TER_DES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "EXT_TER_DES", "Comment");
        })();
}
function onValidate_MS_EXTENSIONS__LOSS_DES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "LOSS_DES", "Comment");
        })();
}
function onValidate_MS_EXTENSIONS__CAR_CAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "CAR_CAT", "Text");
        })();
}
function onValidate_MS_EXTENSIONS__NAS_CAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MS_EXTENSIONS", "NAS_CAT", "Text");
        })();
}
function DoLogic(isOnLoad) {
    onValidate_MS_EXTENSIONS__LOSS_KEYS(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_KEYS_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_KEYS_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_KEYS_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_KEYS_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_KEYS_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_HIRE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_HIRE_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_HIRE_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_HIRE_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_HIRE_DAYS(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_USE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_USE_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_USE_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_USE_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_USE_DAYS(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CRED_SHOR_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DEP_PRO_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_EXT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_NON_LOI(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_NON_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_NON_POSTPRE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_NON_FAP(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__DRIVER_NON_MIN(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT_LOI(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT_POSTPRE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT_FAP(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__FIRE_EXT_MIN(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TRAIL_COM_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WIND_EX_RED_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__POL_SPIL_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REC_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP_LOI(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP_POSTPRE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP_FAP(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REP_MIN(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__REPSAL_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__THPAEXRE_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__label98(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOT_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOT_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOT_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOT_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOT_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__label101(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTLTHIJER_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTLTHIJER_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTLTHIJER_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTLTHIJER_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTLTHIJER_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__label104(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTCFMB_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTCFMB_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTCFMB_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTCFMB_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTCFMB_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__label107(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TERT_LIMIT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TERT_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TERT_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TERT_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TERT_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__RIOT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__RIOT_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__RIOT_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WINDSCREEN(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WINDSCREEN_FAP_PER(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__WINDSCREEN_MIN_AMT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__IS_NASRIA(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__IS_NASRIALOI(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__ROAD_ASSIST(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTAL_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__TOTAL_POST_PREM(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__EXT_TER_DES(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__LOSS_DES(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__CAR_CAT(null, null, null, isOnLoad);
    onValidate_MS_EXTENSIONS__NAS_CAT(null, null, null, isOnLoad);
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
<div id="idb42bfca1326446d384a27ed00f3a0c55" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id8ea66969f4bd46dfaa06cc68355e6145" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading36" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="8" data-column-ratio="9:13:13:13:13:13:13:13" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label60">
		<span class="label" id="label60"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label61">
		<span class="label" id="label61"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label62">
		<span class="label" id="label62">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label63">
		<span class="label" id="label63">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label64">
		<span class="label" id="label64">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label65">
		<span class="label" id="label65">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label66">
		<span class="label" id="label66">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label67">
		<span class="label" id="label67">Number of Weeks/Number of Days </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_LOSS_KEYS" for="ctl00_cntMainBody_MS_EXTENSIONS__LOSS_KEYS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS" 
		id="pb-container-checkbox-MS_EXTENSIONS-LOSS_KEYS">	
		
		<asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label68">
		<span class="label" id="label68">Loss of Keys </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_KEYS_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_KEYS_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_KEYS_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_KEYS_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_KEYS_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_KEYS_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_KEYS_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_KEYS_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_KEYS_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-LOSS_KEYS_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_KEYS_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_KEYS_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_KEYS_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_KEYS_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_KEYS_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_KEYS_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_KEYS_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_KEYS_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_KEYS_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_KEYS_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label69">
		<span class="label" id="label69"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_CAR_HIRE" for="ctl00_cntMainBody_MS_EXTENSIONS__CAR_HIRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_HIRE" 
		id="pb-container-checkbox-MS_EXTENSIONS-CAR_HIRE">	
		
		<asp:TextBox ID="MS_EXTENSIONS__CAR_HIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_HIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_HIRE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_HIRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label70">
		<span class="label" id="label70">Car Hire </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_HIRE_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-CAR_HIRE_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_CAR_HIRE_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__CAR_HIRE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CAR_HIRE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_HIRE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_HIRE_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_HIRE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_HIRE_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-CAR_HIRE_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_CAR_HIRE_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__CAR_HIRE_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CAR_HIRE_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_HIRE_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_HIRE_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_HIRE_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_HIRE_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-CAR_HIRE_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_CAR_HIRE_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__CAR_HIRE_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CAR_HIRE_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_HIRE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_HIRE_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_HIRE_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label71">
		<span class="label" id="label71"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label72">
		<span class="label" id="label72"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_HIRE_DAYS" 
		id="pb-container-list-MS_EXTENSIONS-CAR_HIRE_DAYS">
		<asp:Label ID="lblMS_EXTENSIONS_CAR_HIRE_DAYS" runat="server" AssociatedControlID="MS_EXTENSIONS__CAR_HIRE_DAYS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MS_EXTENSIONS__CAR_HIRE_DAYS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_NO_DAYS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MS_EXTENSIONS__CAR_HIRE_DAYS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_HIRE_DAYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_HIRE_DAYS"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_HIRE_DAYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_LOSS_USE" for="ctl00_cntMainBody_MS_EXTENSIONS__LOSS_USE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_USE" 
		id="pb-container-checkbox-MS_EXTENSIONS-LOSS_USE">	
		
		<asp:TextBox ID="MS_EXTENSIONS__LOSS_USE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_USE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_USE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_USE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label73">
		<span class="label" id="label73">Loss of Use/Downtime </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_USE_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_USE_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_USE_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_USE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_USE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_USE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_USE_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_USE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_USE_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_USE_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_USE_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_USE_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_USE_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_USE_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_USE_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_USE_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_USE_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-LOSS_USE_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_USE_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_USE_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__LOSS_USE_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_USE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_USE_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_USE_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label74">
		<span class="label" id="label74"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label75">
		<span class="label" id="label75"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_USE_DAYS" 
		id="pb-container-integer-MS_EXTENSIONS-LOSS_USE_DAYS">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_USE_DAYS" runat="server" AssociatedControlID="MS_EXTENSIONS__LOSS_USE_DAYS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MS_EXTENSIONS__LOSS_USE_DAYS" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_USE_DAYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_USE_DAYS"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_USE_DAYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_CRED_SHOR" for="ctl00_cntMainBody_MS_EXTENSIONS__CRED_SHOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR" 
		id="pb-container-checkbox-MS_EXTENSIONS-CRED_SHOR">	
		
		<asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label76">
		<span class="label" id="label76">Credit Shortfall </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-CRED_SHOR_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_CRED_SHOR_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__CRED_SHOR_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-CRED_SHOR_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_CRED_SHOR_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__CRED_SHOR_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-CRED_SHOR_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_CRED_SHOR_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__CRED_SHOR_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-CRED_SHOR_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_CRED_SHOR_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__CRED_SHOR_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CRED_SHOR_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-CRED_SHOR_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_CRED_SHOR_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__CRED_SHOR_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__CRED_SHOR_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_CRED_SHOR_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.CRED_SHOR_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__CRED_SHOR_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label77">
		<span class="label" id="label77"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_DEP_PRO" for="ctl00_cntMainBody_MS_EXTENSIONS__DEP_PRO" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO" 
		id="pb-container-checkbox-MS_EXTENSIONS-DEP_PRO">	
		
		<asp:TextBox ID="MS_EXTENSIONS__DEP_PRO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label78">
		<span class="label" id="label78">Deposit Protector </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-DEP_PRO_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_DEP_PRO_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__DEP_PRO_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DEP_PRO_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-DEP_PRO_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_DEP_PRO_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__DEP_PRO_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DEP_PRO_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-DEP_PRO_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_DEP_PRO_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__DEP_PRO_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DEP_PRO_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-DEP_PRO_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_DEP_PRO_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__DEP_PRO_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__DEP_PRO_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DEP_PRO_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-DEP_PRO_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_DEP_PRO_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__DEP_PRO_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DEP_PRO_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DEP_PRO_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DEP_PRO_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DEP_PRO_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label79">
		<span class="label" id="label79"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_DRIVER_EXT" for="ctl00_cntMainBody_MS_EXTENSIONS__DRIVER_EXT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_EXT" 
		id="pb-container-checkbox-MS_EXTENSIONS-DRIVER_EXT">	
		
		<asp:TextBox ID="MS_EXTENSIONS__DRIVER_EXT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_EXT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_EXT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_EXT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label80">
		<span class="label" id="label80">Driver Non-Motor Liability </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_NON_LOI" 
		id="pb-container-currency-MS_EXTENSIONS-DRIVER_NON_LOI">
		<asp:Label ID="lblMS_EXTENSIONS_DRIVER_NON_LOI" runat="server" AssociatedControlID="MS_EXTENSIONS__DRIVER_NON_LOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DRIVER_NON_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_NON_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_NON_LOI"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_NON_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_NON_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-DRIVER_NON_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_DRIVER_NON_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__DRIVER_NON_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DRIVER_NON_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_NON_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_NON_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_NON_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_NON_POSTPRE" 
		id="pb-container-currency-MS_EXTENSIONS-DRIVER_NON_POSTPRE">
		<asp:Label ID="lblMS_EXTENSIONS_DRIVER_NON_POSTPRE" runat="server" AssociatedControlID="MS_EXTENSIONS__DRIVER_NON_POSTPRE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DRIVER_NON_POSTPRE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_NON_POSTPRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_NON_POSTPRE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_NON_POSTPRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_NON_FAP" 
		id="pb-container-percentage-MS_EXTENSIONS-DRIVER_NON_FAP">
		<asp:Label ID="lblMS_EXTENSIONS_DRIVER_NON_FAP" runat="server" AssociatedControlID="MS_EXTENSIONS__DRIVER_NON_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__DRIVER_NON_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_NON_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_NON_FAP"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_NON_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="DRIVER_NON_MIN" 
		id="pb-container-currency-MS_EXTENSIONS-DRIVER_NON_MIN">
		<asp:Label ID="lblMS_EXTENSIONS_DRIVER_NON_MIN" runat="server" AssociatedControlID="MS_EXTENSIONS__DRIVER_NON_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__DRIVER_NON_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_DRIVER_NON_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.DRIVER_NON_MIN"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__DRIVER_NON_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label81">
		<span class="label" id="label81"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_FIRE_EXT" for="ctl00_cntMainBody_MS_EXTENSIONS__FIRE_EXT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT" 
		id="pb-container-checkbox-MS_EXTENSIONS-FIRE_EXT">	
		
		<asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label82">
		<span class="label" id="label82">Fire Extinguishing Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT_LOI" 
		id="pb-container-currency-MS_EXTENSIONS-FIRE_EXT_LOI">
		<asp:Label ID="lblMS_EXTENSIONS_FIRE_EXT_LOI" runat="server" AssociatedControlID="MS_EXTENSIONS__FIRE_EXT_LOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT_LOI"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-FIRE_EXT_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_FIRE_EXT_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__FIRE_EXT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT_POSTPRE" 
		id="pb-container-currency-MS_EXTENSIONS-FIRE_EXT_POSTPRE">
		<asp:Label ID="lblMS_EXTENSIONS_FIRE_EXT_POSTPRE" runat="server" AssociatedControlID="MS_EXTENSIONS__FIRE_EXT_POSTPRE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT_POSTPRE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT_POSTPRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT_POSTPRE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT_POSTPRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT_FAP" 
		id="pb-container-percentage-MS_EXTENSIONS-FIRE_EXT_FAP">
		<asp:Label ID="lblMS_EXTENSIONS_FIRE_EXT_FAP" runat="server" AssociatedControlID="MS_EXTENSIONS__FIRE_EXT_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT_FAP"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="FIRE_EXT_MIN" 
		id="pb-container-currency-MS_EXTENSIONS-FIRE_EXT_MIN">
		<asp:Label ID="lblMS_EXTENSIONS_FIRE_EXT_MIN" runat="server" AssociatedControlID="MS_EXTENSIONS__FIRE_EXT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__FIRE_EXT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_FIRE_EXT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.FIRE_EXT_MIN"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__FIRE_EXT_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label83">
		<span class="label" id="label83"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_TRAIL_COM" for="ctl00_cntMainBody_MS_EXTENSIONS__TRAIL_COM" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM" 
		id="pb-container-checkbox-MS_EXTENSIONS-TRAIL_COM">	
		
		<asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label84">
		<span class="label" id="label84">Trailer Combination</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-TRAIL_COM_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_TRAIL_COM_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__TRAIL_COM_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TRAIL_COM_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TRAIL_COM_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TRAIL_COM_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TRAIL_COM_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TRAIL_COM_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TRAIL_COM_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-TRAIL_COM_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_TRAIL_COM_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__TRAIL_COM_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TRAIL_COM_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-TRAIL_COM_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_TRAIL_COM_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__TRAIL_COM_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TRAIL_COM_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TRAIL_COM_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TRAIL_COM_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TRAIL_COM_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label85">
		<span class="label" id="label85"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_WIND_EX_RED" for="ctl00_cntMainBody_MS_EXTENSIONS__WIND_EX_RED" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED" 
		id="pb-container-checkbox-MS_EXTENSIONS-WIND_EX_RED">	
		
		<asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label86">
		<span class="label" id="label86">Windscreen Excess Reducer</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-WIND_EX_RED_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_WIND_EX_RED_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__WIND_EX_RED_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-WIND_EX_RED_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_WIND_EX_RED_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__WIND_EX_RED_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-WIND_EX_RED_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_WIND_EX_RED_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__WIND_EX_RED_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-WIND_EX_RED_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_WIND_EX_RED_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__WIND_EX_RED_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WIND_EX_RED_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-WIND_EX_RED_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_WIND_EX_RED_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__WIND_EX_RED_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__WIND_EX_RED_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WIND_EX_RED_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WIND_EX_RED_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WIND_EX_RED_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label87">
		<span class="label" id="label87"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_POL_SPIL" for="ctl00_cntMainBody_MS_EXTENSIONS__POL_SPIL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL" 
		id="pb-container-checkbox-MS_EXTENSIONS-POL_SPIL">	
		
		<asp:TextBox ID="MS_EXTENSIONS__POL_SPIL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label88">
		<span class="label" id="label88">Pollution Spillage and Leakage
</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-POL_SPIL_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_POL_SPIL_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__POL_SPIL_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__POL_SPIL_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-POL_SPIL_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_POL_SPIL_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__POL_SPIL_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__POL_SPIL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-POL_SPIL_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_POL_SPIL_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__POL_SPIL_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__POL_SPIL_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-POL_SPIL_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_POL_SPIL_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__POL_SPIL_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__POL_SPIL_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="POL_SPIL_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-POL_SPIL_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_POL_SPIL_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__POL_SPIL_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__POL_SPIL_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_POL_SPIL_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.POL_SPIL_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__POL_SPIL_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label89">
		<span class="label" id="label89"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_REC" for="ctl00_cntMainBody_MS_EXTENSIONS__REC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC" 
		id="pb-container-checkbox-MS_EXTENSIONS-REC">	
		
		<asp:TextBox ID="MS_EXTENSIONS__REC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label90">
		<span class="label" id="label90">Recovery & Cross Border Towing</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-REC_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_REC_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__REC_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REC_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-REC_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_REC_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__REC_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REC_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-REC_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_REC_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__REC_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REC_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-REC_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_REC_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__REC_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__REC_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REC_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-REC_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_REC_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__REC_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REC_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REC_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REC_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REC_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label91">
		<span class="label" id="label91"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_REP" for="ctl00_cntMainBody_MS_EXTENSIONS__REP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP" 
		id="pb-container-checkbox-MS_EXTENSIONS-REP">	
		
		<asp:TextBox ID="MS_EXTENSIONS__REP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label92">
		<span class="label" id="label92">Repairable Own Damage Accident Excess Reducer</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP_LOI" 
		id="pb-container-currency-MS_EXTENSIONS-REP_LOI">
		<asp:Label ID="lblMS_EXTENSIONS_REP_LOI" runat="server" AssociatedControlID="MS_EXTENSIONS__REP_LOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REP_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP_LOI"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-REP_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_REP_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__REP_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REP_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP_POSTPRE" 
		id="pb-container-currency-MS_EXTENSIONS-REP_POSTPRE">
		<asp:Label ID="lblMS_EXTENSIONS_REP_POSTPRE" runat="server" AssociatedControlID="MS_EXTENSIONS__REP_POSTPRE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REP_POSTPRE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP_POSTPRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP_POSTPRE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP_POSTPRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP_FAP" 
		id="pb-container-percentage-MS_EXTENSIONS-REP_FAP">
		<asp:Label ID="lblMS_EXTENSIONS_REP_FAP" runat="server" AssociatedControlID="MS_EXTENSIONS__REP_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__REP_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP_FAP"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REP_MIN" 
		id="pb-container-currency-MS_EXTENSIONS-REP_MIN">
		<asp:Label ID="lblMS_EXTENSIONS_REP_MIN" runat="server" AssociatedControlID="MS_EXTENSIONS__REP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REP_MIN"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REP_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label93">
		<span class="label" id="label93"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_REPSAL" for="ctl00_cntMainBody_MS_EXTENSIONS__REPSAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL" 
		id="pb-container-checkbox-MS_EXTENSIONS-REPSAL">	
		
		<asp:TextBox ID="MS_EXTENSIONS__REPSAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label94">
		<span class="label" id="label94">Repatriation Salvage Buy-Back Percentage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-REPSAL_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_REPSAL_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__REPSAL_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REPSAL_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-REPSAL_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_REPSAL_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__REPSAL_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REPSAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-REPSAL_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_REPSAL_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__REPSAL_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REPSAL_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-REPSAL_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_REPSAL_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__REPSAL_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__REPSAL_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="REPSAL_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-REPSAL_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_REPSAL_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__REPSAL_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__REPSAL_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_REPSAL_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.REPSAL_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__REPSAL_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label95">
		<span class="label" id="label95"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_THPAEXRE" for="ctl00_cntMainBody_MS_EXTENSIONS__THPAEXRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE" 
		id="pb-container-checkbox-MS_EXTENSIONS-THPAEXRE">	
		
		<asp:TextBox ID="MS_EXTENSIONS__THPAEXRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label96">
		<span class="label" id="label96">Third Party Excess Reducer</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-THPAEXRE_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_THPAEXRE_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__THPAEXRE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__THPAEXRE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-THPAEXRE_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_THPAEXRE_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__THPAEXRE_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__THPAEXRE_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-THPAEXRE_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_THPAEXRE_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__THPAEXRE_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__THPAEXRE_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-THPAEXRE_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_THPAEXRE_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__THPAEXRE_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__THPAEXRE_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="THPAEXRE_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-THPAEXRE_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_THPAEXRE_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__THPAEXRE_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__THPAEXRE_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_THPAEXRE_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.THPAEXRE_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__THPAEXRE_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label97">
		<span class="label" id="label97"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_label98" for="ctl00_cntMainBody_MS_EXTENSIONS__label98" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="label98" 
		id="pb-container-checkbox-MS_EXTENSIONS-label98">	
		
		<asp:TextBox ID="MS_EXTENSIONS__label98" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_label98" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.label98"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__label98" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label99">
		<span class="label" id="label99">Tool Of Trade</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOT_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-TOT_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_TOT_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOT_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOT_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOT_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOT_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOT_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOT_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOT_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOT_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOT_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOT_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOT_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOT_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOT_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOT_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOT_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-TOT_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_TOT_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__TOT_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__TOT_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOT_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOT_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOT_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOT_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-TOT_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_TOT_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOT_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOT_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOT_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOT_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOT_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label100">
		<span class="label" id="label100"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_label101" for="ctl00_cntMainBody_MS_EXTENSIONS__label101" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="label101" 
		id="pb-container-checkbox-MS_EXTENSIONS-label101">	
		
		<asp:TextBox ID="MS_EXTENSIONS__label101" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_label101" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.label101"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__label101" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label102">
		<span class="label" id="label102">Total Loss/Theft or Hijack Excess Reducer
</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTLTHIJER_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-TOTLTHIJER_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_TOTLTHIJER_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTLTHIJER_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTLTHIJER_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTLTHIJER_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTLTHIJER_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTLTHIJER_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTLTHIJER_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTLTHIJER_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTLTHIJER_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTLTHIJER_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTLTHIJER_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTLTHIJER_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTLTHIJER_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTLTHIJER_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTLTHIJER_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTLTHIJER_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTLTHIJER_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTLTHIJER_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTLTHIJER_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTLTHIJER_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTLTHIJER_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTLTHIJER_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTLTHIJER_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-TOTLTHIJER_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_TOTLTHIJER_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTLTHIJER_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__TOTLTHIJER_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTLTHIJER_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTLTHIJER_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTLTHIJER_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTLTHIJER_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-TOTLTHIJER_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_TOTLTHIJER_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTLTHIJER_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTLTHIJER_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTLTHIJER_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTLTHIJER_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTLTHIJER_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label103">
		<span class="label" id="label103"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_label104" for="ctl00_cntMainBody_MS_EXTENSIONS__label104" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="label104" 
		id="pb-container-checkbox-MS_EXTENSIONS-label104">	
		
		<asp:TextBox ID="MS_EXTENSIONS__label104" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_label104" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.label104"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__label104" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label105">
		<span class="label" id="label105">Towing Cost following Mechanical Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTCFMB_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-TOTCFMB_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_TOTCFMB_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTCFMB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTCFMB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTCFMB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTCFMB_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTCFMB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTCFMB_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTCFMB_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTCFMB_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTCFMB_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTCFMB_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTCFMB_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTCFMB_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTCFMB_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTCFMB_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTCFMB_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTCFMB_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTCFMB_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTCFMB_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTCFMB_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTCFMB_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTCFMB_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTCFMB_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-TOTCFMB_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_TOTCFMB_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTCFMB_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__TOTCFMB_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTCFMB_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTCFMB_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTCFMB_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTCFMB_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-TOTCFMB_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_TOTCFMB_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTCFMB_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTCFMB_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTCFMB_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTCFMB_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTCFMB_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label106">
		<span class="label" id="label106"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_label107" for="ctl00_cntMainBody_MS_EXTENSIONS__label107" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="label107" 
		id="pb-container-checkbox-MS_EXTENSIONS-label107">	
		
		<asp:TextBox ID="MS_EXTENSIONS__label107" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_label107" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.label107"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__label107" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label108">
		<span class="label" id="label108">Extended Territories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TERT_LIMIT" 
		id="pb-container-currency-MS_EXTENSIONS-EXT_TERT_LIMIT">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TERT_LIMIT" runat="server" AssociatedControlID="MS_EXTENSIONS__EXT_TERT_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__EXT_TERT_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TERT_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TERT_LIMIT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TERT_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TERT_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-EXT_TERT_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TERT_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__EXT_TERT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__EXT_TERT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TERT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TERT_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TERT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TERT_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-EXT_TERT_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TERT_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__EXT_TERT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__EXT_TERT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TERT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TERT_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TERT_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TERT_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-EXT_TERT_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TERT_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__EXT_TERT_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__EXT_TERT_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TERT_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TERT_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TERT_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TERT_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-EXT_TERT_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TERT_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__EXT_TERT_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__EXT_TERT_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TERT_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TERT_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TERT_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label109">
		<span class="label" id="label109"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_RIOT" for="ctl00_cntMainBody_MS_EXTENSIONS__RIOT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="RIOT" 
		id="pb-container-checkbox-MS_EXTENSIONS-RIOT">	
		
		<asp:TextBox ID="MS_EXTENSIONS__RIOT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_RIOT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.RIOT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__RIOT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label110">
		<span class="label" id="label110">Riot & Strike </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label111">
		<span class="label" id="label111"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="RIOT_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-RIOT_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_RIOT_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__RIOT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__RIOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_RIOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.RIOT_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__RIOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="RIOT_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-RIOT_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_RIOT_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__RIOT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__RIOT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_RIOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.RIOT_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__RIOT_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label112">
		<span class="label" id="label112"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label113">
		<span class="label" id="label113"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label114">
		<span class="label" id="label114"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_WINDSCREEN" for="ctl00_cntMainBody_MS_EXTENSIONS__WINDSCREEN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WINDSCREEN" 
		id="pb-container-checkbox-MS_EXTENSIONS-WINDSCREEN">	
		
		<asp:TextBox ID="MS_EXTENSIONS__WINDSCREEN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_WINDSCREEN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WINDSCREEN"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WINDSCREEN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label115">
		<span class="label" id="label115">Windscreen</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label116">
		<span class="label" id="label116"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label117">
		<span class="label" id="label117"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label118">
		<span class="label" id="label118"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WINDSCREEN_FAP_PER" 
		id="pb-container-percentage-MS_EXTENSIONS-WINDSCREEN_FAP_PER">
		<asp:Label ID="lblMS_EXTENSIONS_WINDSCREEN_FAP_PER" runat="server" AssociatedControlID="MS_EXTENSIONS__WINDSCREEN_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MS_EXTENSIONS__WINDSCREEN_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WINDSCREEN_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WINDSCREEN_FAP_PER"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WINDSCREEN_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="WINDSCREEN_MIN_AMT" 
		id="pb-container-currency-MS_EXTENSIONS-WINDSCREEN_MIN_AMT">
		<asp:Label ID="lblMS_EXTENSIONS_WINDSCREEN_MIN_AMT" runat="server" AssociatedControlID="MS_EXTENSIONS__WINDSCREEN_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__WINDSCREEN_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_WINDSCREEN_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.WINDSCREEN_MIN_AMT"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__WINDSCREEN_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label119">
		<span class="label" id="label119"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_IS_NASRIA" for="ctl00_cntMainBody_MS_EXTENSIONS__IS_NASRIA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="IS_NASRIA" 
		id="pb-container-checkbox-MS_EXTENSIONS-IS_NASRIA">	
		
		<asp:TextBox ID="MS_EXTENSIONS__IS_NASRIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_IS_NASRIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.IS_NASRIA"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__IS_NASRIA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label120">
		<span class="label" id="label120">NASRIA - Motor Specified</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="IS_NASRIALOI" 
		id="pb-container-currency-MS_EXTENSIONS-IS_NASRIALOI">
		<asp:Label ID="lblMS_EXTENSIONS_IS_NASRIALOI" runat="server" AssociatedControlID="MS_EXTENSIONS__IS_NASRIALOI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__IS_NASRIALOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_IS_NASRIALOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.IS_NASRIALOI"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__IS_NASRIALOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-NASRIACAT">
		<span class="label" id="NASRIACAT"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label121">
		<span class="label" id="label121"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label122">
		<span class="label" id="label122"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label123">
		<span class="label" id="label123"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label124">
		<span class="label" id="label124"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMS_EXTENSIONS_ROAD_ASSIST" for="ctl00_cntMainBody_MS_EXTENSIONS__ROAD_ASSIST" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="ROAD_ASSIST" 
		id="pb-container-checkbox-MS_EXTENSIONS-ROAD_ASSIST">	
		
		<asp:TextBox ID="MS_EXTENSIONS__ROAD_ASSIST" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMS_EXTENSIONS_ROAD_ASSIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.ROAD_ASSIST"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__ROAD_ASSIST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label125">
		<span class="label" id="label125">Roadside Assist</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label126">
		<span class="label" id="label126"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label127">
		<span class="label" id="label127"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label128">
		<span class="label" id="label128"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label129">
		<span class="label" id="label129"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label130">
		<span class="label" id="label130"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label131">
		<span class="label" id="label131"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label132">
		<span class="label" id="label132"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label133">
		<span class="label" id="label133">Total</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label134">
		<span class="label" id="label134"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTAL_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTAL_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTAL_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTAL_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTAL_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTAL_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="TOTAL_POST_PREM" 
		id="pb-container-currency-MS_EXTENSIONS-TOTAL_POST_PREM">
		<asp:Label ID="lblMS_EXTENSIONS_TOTAL_POST_PREM" runat="server" AssociatedControlID="MS_EXTENSIONS__TOTAL_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MS_EXTENSIONS__TOTAL_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMS_EXTENSIONS_TOTAL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.TOTAL_POST_PREM"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__TOTAL_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label135">
		<span class="label" id="label135"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label136">
		<span class="label" id="label136"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label137">
		<span class="label" id="label137"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label138">
		<span class="label" id="label138"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label139">
		<span class="label" id="label139">Extended Territory Description</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="EXT_TER_DES" 
		id="pb-container-comment-MS_EXTENSIONS-EXT_TER_DES">
		<asp:Label ID="lblMS_EXTENSIONS_EXT_TER_DES" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="MS_EXTENSIONS__EXT_TER_DES" 
			Text=""></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="MS_EXTENSIONS__EXT_TER_DES" runat="server" />
		
		<asp:CustomValidator ID="valMS_EXTENSIONS_EXT_TER_DES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.EXT_TER_DES"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__EXT_TER_DES"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label140">
		<span class="label" id="label140"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label141">
		<span class="label" id="label141"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label142">
		<span class="label" id="label142"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label143">
		<span class="label" id="label143"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label144">
		<span class="label" id="label144"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label145">
		<span class="label" id="label145"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label146">
		<span class="label" id="label146">Loss of Use/Downtime Notes</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="MS_EXTENSIONS" 
		data-property-name="LOSS_DES" 
		id="pb-container-comment-MS_EXTENSIONS-LOSS_DES">
		<asp:Label ID="lblMS_EXTENSIONS_LOSS_DES" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="MS_EXTENSIONS__LOSS_DES" 
			Text=""></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="MS_EXTENSIONS__LOSS_DES" runat="server" />
		
		<asp:CustomValidator ID="valMS_EXTENSIONS_LOSS_DES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MS_EXTENSIONS.LOSS_DES"
			ClientValidationFunction="onValidate_MS_EXTENSIONS__LOSS_DES"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label147">
		<span class="label" id="label147"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label148">
		<span class="label" id="label148"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label149">
		<span class="label" id="label149"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label150">
		<span class="label" id="label150"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label151">
		<span class="label" id="label151"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label152">
		<span class="label" id="label152"></span>
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
		if ($("#id8ea66969f4bd46dfaa06cc68355e6145 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id8ea66969f4bd46dfaa06cc68355e6145 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id8ea66969f4bd46dfaa06cc68355e6145 div ul li").each(function(){		  
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
			$("#id8ea66969f4bd46dfaa06cc68355e6145 div ul li").each(function(){		  
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
		styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8ea66969f4bd46dfaa06cc68355e6145 input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- GeneralLayoutContainer -->
<div id="idb3356cd0faf949118d53336cf2e57406" class="general-layout-container">
				
         
			
				
					<legend><asp:Label ID="lblHeading37" runat="server" Text="Default Container" /></legend>
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label153">
		<span class="label" id="label153"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label154">
		<span class="label" id="label154">Car Hire Category</span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MS_EXTENSIONS" 
		data-property-name="CAR_CAT" 
		 
		
		 
		id="pb-container-text-MS_EXTENSIONS-CAR_CAT">

		
		<asp:Label ID="lblMS_EXTENSIONS_CAR_CAT" runat="server" AssociatedControlID="MS_EXTENSIONS__CAR_CAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MS_EXTENSIONS__CAR_CAT" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMS_EXTENSIONS_CAR_CAT" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for MS_EXTENSIONS.CAR_CAT"
					ClientValidationFunction="onValidate_MS_EXTENSIONS__CAR_CAT"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label155">
		<span class="label" id="label155"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label156">
		<span class="label" id="label156"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label157">
		<span class="label" id="label157"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label158">
		<span class="label" id="label158"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label159">
		<span class="label" id="label159"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label160">
		<span class="label" id="label160"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label161">
		<span class="label" id="label161">NASRIA Category</span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MS_EXTENSIONS" 
		data-property-name="NAS_CAT" 
		 
		
		 
		id="pb-container-text-MS_EXTENSIONS-NAS_CAT">

		
		<asp:Label ID="lblMS_EXTENSIONS_NAS_CAT" runat="server" AssociatedControlID="MS_EXTENSIONS__NAS_CAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MS_EXTENSIONS__NAS_CAT" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMS_EXTENSIONS_NAS_CAT" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for MS_EXTENSIONS.NAS_CAT"
					ClientValidationFunction="onValidate_MS_EXTENSIONS__NAS_CAT"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label162">
		<span class="label" id="label162"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label163">
		<span class="label" id="label163"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label164">
		<span class="label" id="label164"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label165">
		<span class="label" id="label165"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label166">
		<span class="label" id="label166"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- Label -->
	<span id="pb-container-label-label167">
		<span class="label" id="label167"></span>
	</span>
<!-- /Label -->
							
							</div>
					 
					
				
         
			
         
		
</div>


<!-- /GeneralLayoutContainer -->
							
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