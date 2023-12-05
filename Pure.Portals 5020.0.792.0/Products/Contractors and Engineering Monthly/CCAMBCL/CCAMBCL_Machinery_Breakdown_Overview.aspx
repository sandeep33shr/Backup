<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CCAMBCL_Machinery_Breakdown_Overview.aspx.vb" Inherits="Nexus.PB2_CCAMBCL_Machinery_Breakdown_Overview" %>

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
function onValidate_label43(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label43" != "{na" + "me}"){
        			instance = Field.getLabel("label43");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label44(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label44" != "{na" + "me}"){
        			instance = Field.getLabel("label44");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label45(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label45" != "{na" + "me}"){
        			instance = Field.getLabel("label45");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label46(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label46" != "{na" + "me}"){
        			instance = Field.getLabel("label46");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label47(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label47" != "{na" + "me}"){
        			instance = Field.getLabel("label47");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MB_TOTAL_SI&name={name}");
        		
        		var value = new Expression("MBREAK.MB_TOTSUMIN"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MB_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_EML", "Percentage");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MB_EML");
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
         * @fileoverview
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Machinery Breakdown EML amount cannot be over 100% or Less than 50% ")) ? "Machinery Breakdown EML amount cannot be over 100% or Less than 50% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "__" + "MB_EML");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "_" + "MB_EML");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("EXPOSURE_SUMMARY.MB_EML > 100 OR EXPOSURE_SUMMARY.MB_EML < GENERAL.EML_MIN ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_EML');
        			
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
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=MB_EML&name={name}");
        		
        		var value = new Expression("GENERAL.EML"), 
        			condition = (Expression.isValidParameter("EXPOSURE_SUMMARY.MB_EML == '' OR EXPOSURE_SUMMARY.MB_EML == null")) ? new Expression("EXPOSURE_SUMMARY.MB_EML == '' OR EXPOSURE_SUMMARY.MB_EML == null") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MB_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MB_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MB_TOTAL_SI * EXPOSURE_SUMMARY.MB_EML / 100"), 
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
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_RI_EXP');
        			
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_RI_EXPVAT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MB_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MB_RI_EXP/1.15"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_label48(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label48" != "{na" + "me}"){
        			instance = Field.getLabel("label48");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("label48" != "{na" + "me}"){
        			field = Field.getLabel("label48");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_ACPC == true", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_ACPC == true",
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
function onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_TOTAL_SI", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_TOTAL_SI");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_ACPC == true", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_ACPC == true",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_TOTAL_SI&name={name}");
        		
        		var value = new Expression("MBREAK.ACPC_SUMINSURED"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_ACPC = 1")) ? new Expression("MBREAK.IS_ACPC = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBACPC_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_EML", "Percentage");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_EML");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_ACPC == true", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_ACPC == true",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_EML');
        			
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Machinery Breakdown Additiona Claims Preparation Cost EML amount cannot be over 100% or Less than 50% ")) ? "Machinery Breakdown Additiona Claims Preparation Cost EML amount cannot be over 100% or Less than 50% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "__" + "MBACPC_EML");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "_" + "MBACPC_EML");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(EXPOSURE_SUMMARY.MBACPC_EML > GENERAL.EML OR EXPOSURE_SUMMARY.MBACPC_EML < GENERAL.EML_MIN) AND MBREAK.IS_ACPC = 1");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_EML&name={name}");
        		
        		var value = new Expression("General.EML"), 
        			condition = (Expression.isValidParameter("EXPOSURE_SUMMARY.MBACPC_EML == '' OR EXPOSURE_SUMMARY.MBACPC_EML == null AND MBREAK.IS_ACPC = 1")) ? new Expression("EXPOSURE_SUMMARY.MBACPC_EML == '' OR EXPOSURE_SUMMARY.MBACPC_EML == null AND MBREAK.IS_ACPC = 1") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_EML&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_ACPC = 0")) ? new Expression("MBREAK.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_RI_EXP", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXP");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_ACPC == true", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_ACPC == true",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_RI_EXP');
        			
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBACPC_TOTAL_SI * EXPOSURE_SUMMARY.MBACPC_EML / 100"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_ACPC = 1")) ? new Expression("MBREAK.IS_ACPC = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_RI_EXP&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_ACPC = 0")) ? new Expression("MBREAK.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_RI_EXPVAT", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXPVAT");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_ACPC == true", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_ACPC == true",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_RI_EXPVAT');
        			
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBACPC_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBACPC_RI_EXP/1.15"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_ACPC = 1")) ? new Expression("MBREAK.IS_ACPC = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_label49(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label49" != "{na" + "me}"){
        			instance = Field.getLabel("label49");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("label49" != "{na" + "me}"){
        			field = Field.getLabel("label49");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1",
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
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_TOTAL_SI", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_TOTAL_SI");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_TOTAL_SI&name={name}");
        		
        		var value = new Expression("CLOSS.CL_TOTSUMIN"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 1")) ? new Expression("MBREAK.IS_CL_BI = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_EML", "Percentage");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_EML");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_CL_BI = 1", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_CL_BI = 1",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_EML');
        			
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Consequential Loss Gross Profit/Revenue EML amount cannot be over 100% or Less than 50% ")) ? "Consequential Loss Gross Profit/Revenue EML amount cannot be over 100% or Less than 50% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "__" + "CONSLGPR_EML");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "_" + "CONSLGPR_EML");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(EXPOSURE_SUMMARY.CONSLGPR_EML > GENERAL.EML OR EXPOSURE_SUMMARY.CONSLGPR_EML < GENERAL.EML_MIN) AND MBREAK.IS_CL_BI = 1");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_EML&name={name}");
        		
        		var value = new Expression("General.EML"), 
        			condition = (Expression.isValidParameter("(EXPOSURE_SUMMARY.CONSLGPR_EML == '' OR EXPOSURE_SUMMARY.CONSLGPR_EML == null) and MBREAK.IS_CL_BI = 1")) ? new Expression("(EXPOSURE_SUMMARY.CONSLGPR_EML == '' OR EXPOSURE_SUMMARY.CONSLGPR_EML == null) and MBREAK.IS_CL_BI = 1") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_EML&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI == false")) ? new Expression("MBREAK.IS_CL_BI == false") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_RI_EXP", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXP");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_CL_BI = 1", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_CL_BI = 1",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_RI_EXP');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.CONSLGPR_TOTAL_SI * EXPOSURE_SUMMARY.CONSLGPR_EML / 100"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 1")) ? new Expression("MBREAK.IS_CL_BI = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_RI_EXP&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI == false")) ? new Expression("MBREAK.IS_CL_BI == false") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_RI_EXPVAT", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXPVAT");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_RI_EXPVAT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLGPR_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.CONSLGPR_RI_EXP/1.15"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI == true")) ? new Expression("MBREAK.IS_CL_BI == true") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_label50(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label50" != "{na" + "me}"){
        			instance = Field.getLabel("label50");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("label50" != "{na" + "me}"){
        			field = Field.getLabel("label50");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1",
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
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_TOTAL_SI", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_TOTAL_SI");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_TOTAL_SI&name={name}");
        		
        		var value = new Expression("CLOSS.ACPC_SUMINSURED"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1")) ? new Expression("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_EML", "Percentage");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_EML");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_EML');
        			
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Consequential Loss Additional Claims Preparation Cost EML amount cannot be over 100% or Less than 50% ")) ? "Consequential Loss Additional Claims Preparation Cost EML amount cannot be over 100% or Less than 50% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "__" + "CONSLACPC_EML");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "_" + "CONSLACPC_EML");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(EXPOSURE_SUMMARY.CONSLACPC_EML > GENERAL.EML OR EXPOSURE_SUMMARY.CONSLACPC_EML< GENERAL.EML_MIN) AND (MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_EML&name={name}");
        		
        		var value = new Expression("General.EML"), 
        			condition = (Expression.isValidParameter("(EXPOSURE_SUMMARY.CONSLACPC_EML == '' OR EXPOSURE_SUMMARY.CONSLACPC_EML == null) and (MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1)")) ? new Expression("(EXPOSURE_SUMMARY.CONSLACPC_EML == '' OR EXPOSURE_SUMMARY.CONSLACPC_EML == null) and (MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1)") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_EML&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 0 OR CLOSS.IS_ACPC = 0")) ? new Expression("MBREAK.IS_CL_BI = 0 OR CLOSS.IS_ACPC = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_RI_EXP", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXP");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_RI_EXP');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.CONSLACPC_TOTAL_SI * EXPOSURE_SUMMARY.CONSLACPC_EML / 100"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1")) ? new Expression("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_RI_EXP&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 0 OR CLOSS.IS_ACPC == false")) ? new Expression("MBREAK.IS_CL_BI = 0 OR CLOSS.IS_ACPC == false") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_RI_EXPVAT", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXPVAT");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_RI_EXPVAT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=CONSLACPC_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.CONSLACPC_RI_EXP/1.15"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1")) ? new Expression("MBREAK.IS_CL_BI = 1 AND CLOSS.IS_ACPC = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_label51(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label51" != "{na" + "me}"){
        			instance = Field.getLabel("label51");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("label51" != "{na" + "me}"){
        			field = Field.getLabel("label51");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_DOS == true", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_DOS == true",
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
function onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_TOTAL_SI", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_TOTAL_SI");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_DOS == true", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_DOS == true",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_TOTAL_SI&name={name}");
        		
        		var value = new Expression("DSTOCK.DET_TOTSUMIN"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_DOS = 1")) ? new Expression("MBREAK.IS_DOS = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBDETOST_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_EML", "Percentage");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_EML");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_DOS == true", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_DOS == true",
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_EML');
        			
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Deterioration of Stock EML amount cannot be over 100% or Less than 50% ")) ? "Deterioration of Stock EML amount cannot be over 100% or Less than 50% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "__" + "MBDETOST_EML");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "EXPOSURE_SUMMARY".toUpperCase() + "_" + "MBDETOST_EML");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(EXPOSURE_SUMMARY.MBDETOST_EML > GENERAL.EML OR EXPOSURE_SUMMARY.MBDETOST_EML < GENERAL.EML_MIN) AND MBREAK.IS_DOS = 1");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_EML&name={name}");
        		
        		var value = new Expression("General.EML"), 
        			condition = (Expression.isValidParameter("(EXPOSURE_SUMMARY.MBDETOST_EML == '' OR EXPOSURE_SUMMARY.MBDETOST_EML == null) AND MBREAK.IS_DOS = 1")) ? new Expression("(EXPOSURE_SUMMARY.MBDETOST_EML == '' OR EXPOSURE_SUMMARY.MBDETOST_EML == null) AND MBREAK.IS_DOS = 1") : null, 
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
        		var field = Field.getWithQuery("type=Percentage&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_EML&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_DOS = 0")) ? new Expression("MBREAK.IS_DOS = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_RI_EXP", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXP");
        		}
        		//window.setProperty(field, "VE", "MBREAK.IS_DOS == true", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MBREAK.IS_DOS == true",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_RI_EXP');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBDETOST_TOTAL_SI * EXPOSURE_SUMMARY.MBDETOST_EML / 100"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_DOS == true")) ? new Expression("MBREAK.IS_DOS == true") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_RI_EXP&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_DOS == false")) ? new Expression("MBREAK.IS_DOS == false") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_RI_EXPVAT", "Currency");
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
        			field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXPVAT");
        		}
        		//window.setProperty(field, "V", "MBREAK.IS_DOS == true ", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "MBREAK.IS_DOS == true ",
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
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_RI_EXPVAT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=MBDETOST_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBDETOST_RI_EXP/1.15"), 
        			condition = (Expression.isValidParameter("MBREAK.IS_DOS = 1")) ? new Expression("MBREAK.IS_DOS = 1") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_label52(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label52" != "{na" + "me}"){
        			instance = Field.getLabel("label52");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_SI');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=TOTAL_SI&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBDETOST_TOTAL_SI + EXPOSURE_SUMMARY.CONSLACPC_TOTAL_SI + EXPOSURE_SUMMARY.CONSLGPR_TOTAL_SI + EXPOSURE_SUMMARY.MBACPC_TOTAL_SI + EXPOSURE_SUMMARY.MB_TOTAL_SI"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_SI");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_RI_EXP');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=TOTAL_RI_EXP&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MBDETOST_RI_EXP + EXPOSURE_SUMMARY.CONSLACPC_RI_EXP + EXPOSURE_SUMMARY.CONSLGPR_RI_EXP +  EXPOSURE_SUMMARY.MBACPC_RI_EXP + EXPOSURE_SUMMARY.MB_RI_EXP"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXP");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_RI_EXPVAT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=EXPOSURE_SUMMARY&propertyName=TOTAL_RI_EXPVAT&name={name}");
        		
        		var value = new Expression("EXPOSURE_SUMMARY.MB_RI_EXPVAT  + EXPOSURE_SUMMARY.MBACPC_RI_EXPVAT + EXPOSURE_SUMMARY.CONSLGPR_RI_EXPVAT +  EXPOSURE_SUMMARY.CONSLACPC_RI_EXPVAT + EXPOSURE_SUMMARY.MBDETOST_RI_EXPVAT"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXPVAT");
        		var update = function(){
        			if (field.getValue() == 0) {
        				if (field.setValueInternal){
        					// Do not trigger change events.
        					field.setValueInternal('');
        				} else { 
        					field.setValue('');
        				}
        			}
        			events.listenOnce(field, "change", update);
        		};
        		update();
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_label43(null, null, null, isOnLoad);
    onValidate_label44(null, null, null, isOnLoad);
    onValidate_label45(null, null, null, isOnLoad);
    onValidate_label46(null, null, null, isOnLoad);
    onValidate_label47(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label48(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label49(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label50(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label51(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label52(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT(null, null, null, isOnLoad);
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
<div id="idde504ec9b4b6432197bfecea407ee581" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id2b2316ab55b24705a0226f42447c804b" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading81" runat="server" Text="Combined Reinsurance Exposure" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="28:18:18:18:18" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label42">
		<span class="label" id="label42"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label43">
		<span class="label" id="label43">Total Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label44">
		<span class="label" id="label44">EML%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label45">
		<span class="label" id="label45">RI Exposure (VAT Incl.)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label46">
		<span class="label" id="label46">RI Exposure (VAT Excl.)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label47">
		<span class="label" id="label47">Machinery Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MB_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MB_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_EML" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label48">
		<span class="label" id="label48">Machinery Breakdown Additional Claims Preparation Cost</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MBACPC_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_EML" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label49">
		<span class="label" id="label49">Consequential Loss Gross Profit/Revenue</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-CONSLGPR_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label50">
		<span class="label" id="label50">Consequential Loss Additional Claims Preparation Cost</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-CONSLACPC_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label51">
		<span class="label" id="label51">Deterioration of Stock</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MBDETOST_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_EML" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label52">
		<span class="label" id="label52">Totals</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label53">
		<span class="label" id="label53"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" 
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
		if ($("#id2b2316ab55b24705a0226f42447c804b div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id2b2316ab55b24705a0226f42447c804b div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id2b2316ab55b24705a0226f42447c804b div ul li").each(function(){		  
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
			$("#id2b2316ab55b24705a0226f42447c804b div ul li").each(function(){		  
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
		styleString += "#id2b2316ab55b24705a0226f42447c804b label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id2b2316ab55b24705a0226f42447c804b label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2b2316ab55b24705a0226f42447c804b label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2b2316ab55b24705a0226f42447c804b label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id2b2316ab55b24705a0226f42447c804b input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2b2316ab55b24705a0226f42447c804b input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2b2316ab55b24705a0226f42447c804b input{text-align:left;}"; break;
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