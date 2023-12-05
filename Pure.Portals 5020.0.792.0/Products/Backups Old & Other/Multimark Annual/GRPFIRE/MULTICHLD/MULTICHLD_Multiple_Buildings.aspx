<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MULTICHLD_Multiple_Buildings.aspx.vb" Inherits="Nexus.PB2_MULTICHLD_Multiple_Buildings" %>

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
        	
        	if (width == 2.5 )
        		sWidthClass2 ="col-md-12 col-sm-9";
        	
        	
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
function onValidate_MULTIPLE_BLD_ITEMS__COUNTER_ID(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "COUNTER_ID", "Text");
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
        			var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "COUNTER_ID");
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
function onValidate_MULTIPLE_BLD_ITEMS__DESCRIPTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "DESCRIPTION", "Text");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "DESCRIPTION");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.DESCRIPTION");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "DESCRIPTION");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_DESCRIPTION");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__DESCRIPTION');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__DESCRIPTION_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "DESCRIPTION");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_MULTIPLE_BLD_ITEMS__SUM_INSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "SUM_INSURED", "Currency");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "SUM_INSURED");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.SUM_INSURED");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "SUM_INSURED");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_SUM_INSURED");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__SUM_INSURED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__SUM_INSURED_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "SUM_INSURED");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "SUM_INSURED");
        		
        		
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
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'SUM_INSURED');
        			
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
function onValidate_MULTIPLE_BLD_ITEMS__RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "RATE", "Percentage");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "RATE");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.RATE");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "RATE");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_RATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__RATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__RATE_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "RATE");
        		
        		
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
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'RATE');
        			
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
function onValidate_MULTIPLE_BLD_ITEMS__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "PREMIUM", "Currency");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "PREMIUM");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.PREMIUM");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "PREMIUM");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__PREMIUM_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "PREMIUM");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "PREMIUM");
        		
        		
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
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MULTIPLE_BLD_ITEMS&propertyName=PREMIUM&name={name}");
        		
        		var value = new Expression("MULTIPLE_BLD_ITEMS.SUM_INSURED * (MULTIPLE_BLD_ITEMS.RATE * 0.01)"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        $(document).ready(function() {
        	
        	var SumInsured = Field.getInstance("MULTIPLE_BLD_ITEMS", "SUM_INSURED");
        	var Rate = Field.getInstance("MULTIPLE_BLD_ITEMS", "RATE");
        	var Premium = Field.getInstance("MULTIPLE_BLD_ITEMS", "PREMIUM");
        	
        	events.listen(Premium, "change", function(e)
        	{
        		var SI = SumInsured.getValue();
        		var Prem = Premium.getValue();
        
        		if (SI != null && Prem != null )
        		{
        			var newRate = ((Prem/SI) * 100);
        			Rate.setValue(newRate);
        		}
        	}, false, this);
        }, false, this);
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'PREMIUM');
        			
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
function onValidate_FAP_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("FAP_AMOUNT" != "{na" + "me}"){
        			instance = Field.getLabel("FAP_AMOUNT");
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
function onValidate_MULTIPLE_BLD_ITEMS__FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "FAP_PERC", "Percentage");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "FAP_PERC");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.FAP_PERC");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "FAP_PERC");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_FAP_PERC");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__FAP_PERC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__FAP_PERC_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "FAP_PERC");
        		
        		
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
        			return field.setFormatPattern("###.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("###.00%");
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
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'FAP_PERC');
        			
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("FAP% cannot be greater than 100%")) ? "FAP% cannot be greater than 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "__" + "FAP_PERC");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "_" + "FAP_PERC");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MULTIPLE_BLD_ITEMS.FAP_PERC<= 100");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MULTIPLE_BLD_ITEMS__MIN_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "MIN_AMOUNT", "Currency");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "MIN_AMOUNT");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.MIN_AMOUNT");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "MIN_AMOUNT");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_MIN_AMOUNT");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__MIN_AMOUNT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__MIN_AMOUNT_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "MIN_AMOUNT");
        		
        		
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
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'MIN_AMOUNT');
        			
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Minimum amount cannot be greater than maximum amount")) ? "Minimum amount cannot be greater than maximum amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "__" + "MIN_AMOUNT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "_" + "MIN_AMOUNT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MULTIPLE_BLD_ITEMS.MIN_AMOUNT <= MULTIPLE_BLD_ITEMS.MAX_AMOUNT");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MULTIPLE_BLD_ITEMS__MAX_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MULTIPLE_BLD_ITEMS", "MAX_AMOUNT", "Currency");
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
        			field = Field.getInstance("MULTIPLE_BLD_ITEMS", "MAX_AMOUNT");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MULTIPLE_BLD_ITEMS.MAX_AMOUNT");
        			window.setControlWidth(field, "0.7", "MULTIPLE_BLD_ITEMS", "MAX_AMOUNT");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMULTIPLE_BLD_ITEMS_MAX_AMOUNT");
        			    var ele = document.getElementById('ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__MAX_AMOUNT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MULTIPLE_BLD_ITEMS__MAX_AMOUNT_lblFindParty");
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
        	
        		if (width == 2.5 )
        			sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        		label.className = sWidthClass2;
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
        		var field = Field.getInstance("MULTIPLE_BLD_ITEMS", "MAX_AMOUNT");
        		
        		
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
        
        			var field = Field.getInstance('MULTIPLE_BLD_ITEMS', 'MAX_AMOUNT');
        			
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Maximum amount cannot be lesser than minimum amount")) ? "Maximum amount cannot be lesser than minimum amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "__" + "MAX_AMOUNT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MULTIPLE_BLD_ITEMS".toUpperCase() + "_" + "MAX_AMOUNT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MULTIPLE_BLD_ITEMS.MAX_AMOUNT>= MULTIPLE_BLD_ITEMS.MIN_AMOUNT");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function DoLogic(isOnLoad) {
    onValidate_MULTIPLE_BLD_ITEMS__COUNTER_ID(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__DESCRIPTION(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__SUM_INSURED(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__RATE(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__PREMIUM(null, null, null, isOnLoad);
    onValidate_FAP_AMOUNT(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__FAP_PERC(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__MIN_AMOUNT(null, null, null, isOnLoad);
    onValidate_MULTIPLE_BLD_ITEMS__MAX_AMOUNT(null, null, null, isOnLoad);
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
<div id="id1094d7ceb1dd443e9423c8d0f20bc2d5" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="ided53eac0845a4d26a27ef1c404e007be" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading17" runat="server" Text="Multiple Buildings" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="COUNTER_ID" 
		 
		
		 
		id="pb-container-text-MULTIPLE_BLD_ITEMS-COUNTER_ID">

		
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_COUNTER_ID" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__COUNTER_ID" 
			Text="ID" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MULTIPLE_BLD_ITEMS__COUNTER_ID" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_COUNTER_ID" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ID"
					ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__COUNTER_ID"
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
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="DESCRIPTION" 
		 
		
		 
		id="pb-container-text-MULTIPLE_BLD_ITEMS-DESCRIPTION">

		
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_DESCRIPTION" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__DESCRIPTION" 
			Text="Description" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MULTIPLE_BLD_ITEMS__DESCRIPTION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_DESCRIPTION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Description"
					ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__DESCRIPTION"
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
								
								
										<!-- Label -->
	<span id="pb-container-label-label159">
		<span class="label" id="label159"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="SUM_INSURED" 
		id="pb-container-currency-MULTIPLE_BLD_ITEMS-SUM_INSURED">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_SUM_INSURED" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__SUM_INSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MULTIPLE_BLD_ITEMS__SUM_INSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_SUM_INSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__SUM_INSURED" 
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
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="RATE" 
		id="pb-container-percentage-MULTIPLE_BLD_ITEMS-RATE">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_RATE" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__RATE" 
			Text="Rate" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MULTIPLE_BLD_ITEMS__RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Rate"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__RATE" 
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
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-MULTIPLE_BLD_ITEMS-PREMIUM">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_PREMIUM" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__PREMIUM" 
			Text="Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MULTIPLE_BLD_ITEMS__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Premium"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label160">
		<span class="label" id="label160"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-FAP_AMOUNT">
		<span class="label" id="FAP_AMOUNT"><B>First Amount Payable</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label161">
		<span class="label" id="label161"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="FAP_PERC" 
		id="pb-container-percentage-MULTIPLE_BLD_ITEMS-FAP_PERC">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_FAP_PERC" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__FAP_PERC" 
			Text="FAP %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MULTIPLE_BLD_ITEMS__FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP %"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__FAP_PERC" 
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
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="MIN_AMOUNT" 
		id="pb-container-currency-MULTIPLE_BLD_ITEMS-MIN_AMOUNT">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_MIN_AMOUNT" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__MIN_AMOUNT" 
			Text="Minimum Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MULTIPLE_BLD_ITEMS__MIN_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_MIN_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Minimum Amount"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__MIN_AMOUNT" 
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
		data-object-name="MULTIPLE_BLD_ITEMS" 
		data-property-name="MAX_AMOUNT" 
		id="pb-container-currency-MULTIPLE_BLD_ITEMS-MAX_AMOUNT">
		<asp:Label ID="lblMULTIPLE_BLD_ITEMS_MAX_AMOUNT" runat="server" AssociatedControlID="MULTIPLE_BLD_ITEMS__MAX_AMOUNT" 
			Text="Maximum Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MULTIPLE_BLD_ITEMS__MAX_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMULTIPLE_BLD_ITEMS_MAX_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Maximum Amount"
			ClientValidationFunction="onValidate_MULTIPLE_BLD_ITEMS__MAX_AMOUNT" 
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
		if ($("#ided53eac0845a4d26a27ef1c404e007be div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ided53eac0845a4d26a27ef1c404e007be div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ided53eac0845a4d26a27ef1c404e007be div ul li").each(function(){		  
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
			$("#ided53eac0845a4d26a27ef1c404e007be div ul li").each(function(){		  
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
		styleString += "#ided53eac0845a4d26a27ef1c404e007be label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ided53eac0845a4d26a27ef1c404e007be label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ided53eac0845a4d26a27ef1c404e007be label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ided53eac0845a4d26a27ef1c404e007be label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ided53eac0845a4d26a27ef1c404e007be input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ided53eac0845a4d26a27ef1c404e007be input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ided53eac0845a4d26a27ef1c404e007be input{text-align:left;}"; break;
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