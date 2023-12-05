<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MOTORP_Motor_Extensions.aspx.vb" Inherits="Nexus.PB2_MOTORP_Motor_Extensions" %>

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
	
	<!-- OMICO -->	
		<script src="<%=ResolveUrl("~/App_themes/internal/js/forge.min.js")%>" type="text/javascript"></script>
	    <link href="<%=ResolveUrl("~/App_Themes/Internal/Omico.css")%>" rel="stylesheet" type="text/css" />
	<!-- OMICO -->
	
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
function onValidate_MOTOR_TP__IS_TPPROP_DAMAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "IS_TPPROP_DAMAGE", "Checkbox");
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
        			field = Field.getInstance("MOTOR_TP", "IS_TPPROP_DAMAGE");
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
}
function onValidate_MOTOR_TP__TPPD_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPPD_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPPD_STANDLIMIT");
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
}
function onValidate_MOTOR_TP__TPPD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPPD_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPPD_LIMIT");
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
        			var message = (Expression.isValidParameter("A validation error occurred - Property Damage Limit can't be less than Standard Limit")) ? "A validation error occurred - Property Damage Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_TP".toUpperCase() + "__" + "TPPD_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_TP".toUpperCase() + "_" + "TPPD_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" MOTOR_TP.TPPD_LIMIT <  MOTOR_TP.TPPD_STANDLIMIT && MOTOR_TP.IS_TPPROP_DAMAGE==1 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_TP__TPPD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPPD_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_TP", "TPPD_RATE");
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
}
function onValidate_MOTOR_TP__TPPD_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPPD_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPPD_PREMIUM");
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
         * @fileoverview
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_TP", "TPPD_PREMIUM");
        		
        		var value = new Expression("(MOTOR_TP.TPPD_LIMIT-MOTOR_TP.TPPD_STANDLIMIT) * MOTOR_TP.TPPD_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_TP__IS_TPBODILY_INJURY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "IS_TPBODILY_INJURY", "Checkbox");
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
        			field = Field.getInstance("MOTOR_TP", "IS_TPBODILY_INJURY");
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
}
function onValidate_MOTOR_TP__TPBI_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPBI_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPBI_STANDLIMIT");
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
}
function onValidate_MOTOR_TP__TPBI_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPBI_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPBI_LIMIT");
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
        			var message = (Expression.isValidParameter("A validation error occurred - Bodily Injury Limit can't be less than Standard Limit")) ? "A validation error occurred - Bodily Injury Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_TP".toUpperCase() + "__" + "TPBI_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_TP".toUpperCase() + "_" + "TPBI_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" MOTOR_TP.TPBI_LIMIT < MOTOR_TP.TPBI_STANDLIMIT && MOTOR_TP.IS_TPBODILY_INJURY==1 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_TP__TPBI_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPBI_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_TP", "TPBI_RATE");
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
}
function onValidate_MOTOR_TP__TPBI_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_TP", "TPBI_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_TP", "TPBI_PREMIUM");
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
         * @fileoverview
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_TP", "TPBI_PREMIUM");
        		
        		var value = new Expression("(MOTOR_TP.TPBI_LIMIT-MOTOR_TP.TPBI_STANDLIMIT) * MOTOR_TP.TPBI_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_CONTINGENT_LIAB", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_CONTINGENT_LIAB");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'|| MOTOR.VEHICLE_TYPE_CODE == 'CRVR') ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'|| MOTOR.VEHICLE_TYPE_CODE == 'CRVR') ",
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
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_CONTINGENT_LIAB");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB_lblFindParty");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_CONTINGENT_LIAB&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CONTINGENT_LIAB_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CONTINGENT_LIAB_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CONTINGENT_LIAB_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CONTINGENT_LIAB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ",
            paramElseValue = "H",
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
        			var message = (Expression.isValidParameter("A validation error occurred - Contingent Liability Limit can't be less than Standard Limit")) ? "A validation error occurred - Contingent Liability Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "CONTINGENT_LIAB_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "CONTINGENT_LIAB_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" MOTOR_EXTENSIONS.CONTINGENT_LIAB_LIMIT < MOTOR_EXTENSIONS.CONTINGENT_LIAB_STANDLIMIT && MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB==1 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CONTINGENT_LIAB_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CONTINGENT_LIAB_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CONTINGENT_LIAB_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CONTINGENT_LIAB_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "CONTINGENT_LIAB_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.CONTINGENT_LIAB_LIMIT-MOTOR_EXTENSIONS.CONTINGENT_LIAB_STANDLIMIT) * MOTOR_EXTENSIONS.CONTINGENT_LIAB_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_CONTINGENT_LIAB == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_UNAUTH_PASSENGER_LIABILITY", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_UNAUTH_PASSENGER_LIABILITY");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')",
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
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_UNAUTH_PASSENGER_LIABILITY");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY_lblFindParty");
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
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Unauthorised Passenger Liabilty Applicable?'"), (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_UNAUTH_PASSENGER_LIABILITY&name={name}");
        			
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_UNAUTH_PASSENGER_LIABILITY&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
        			var message = (Expression.isValidParameter("A validation error occurred - Unauth. Passenger Liability Limit can't be less than Standard Limit")) ? "A validation error occurred - Unauth. Passenger Liability Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "UNAUTH_PASSENGER_LIAB_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "UNAUTH_PASSENGER_LIAB_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_LIMIT < MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_STANDLIMIT && MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY==1  ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "UNAUTH_PASSENGER_LIAB_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_LIMIT-MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_STANDLIMIT) * MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_UNAUTH_PASSENGER_LIABILITY == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_PASSENGER_LIABILITY", "Checkbox");
        })();
        /**
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Authorised Passenger Liabilty Applicable?'"), (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_PASSENGER_LIABILITY&name={name}");
        			
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
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_PASSENGER_LIABILITY");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_PASSENGER_LIABILITY&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_PASSENGER_LIABILITY");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY_lblFindParty");
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
function onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "PASSENGER_LIAB_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "PASSENGER_LIAB_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "PASSENGER_LIAB_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "PASSENGER_LIAB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
        			var message = (Expression.isValidParameter("A validation error occurred - Auth. Passenger Liability Limit can't be less than Standard Limit")) ? "A validation error occurred - Auth. Passenger Liability Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "PASSENGER_LIAB_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "PASSENGER_LIAB_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXTENSIONS.PASSENGER_LIAB_LIMIT < MOTOR_EXTENSIONS.PASSENGER_LIAB_STANDLIMIT && MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY==1");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "PASSENGER_LIAB_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "PASSENGER_LIAB_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "PASSENGER_LIAB_PREM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "PASSENGER_LIAB_PREM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "PASSENGER_LIAB_PREM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.PASSENGER_LIAB_LIMIT-MOTOR_EXTENSIONS.PASSENGER_LIAB_STANDLIMIT)*MOTOR_EXTENSIONS.PASSENGER_LIAB_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_PASSENGER_LIABILITY == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_CROS_LIAB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_CROS_LIAB", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_CROS_LIAB");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')",
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
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_CROS_LIAB");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CROS_LIAB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CROS_LIAB_lblFindParty");
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
         * Set a tooltip in expression format. Therefore the tooltip string must be surrounded by single quotes. 
         * Can also set a condition and else value.
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var valueWhen = new ValueWhenHelper(new Expression("'Cross Laibility Applicable?'"), (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_CROS_LIAB&name={name}");
        			
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_CROS_LIAB&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__CROS_LIAB_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CROS_LIAB_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__CROS_LIAB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CROS_LIAB_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ",
            paramElseValue = "H",
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
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_LIMIT");
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred - Cross Liability Limit can't be less than Standard Limit")) ? "A validation error occurred - Cross Liability Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "CROS_LIAB_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "CROS_LIAB_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXTENSIONS.CROS_LIAB_LIMIT < MOTOR_EXTENSIONS.CROS_LIAB_STANDLIMIT && MOTOR_EXTENSIONS.IS_CROS_LIAB==1");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__CROS_LIAB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CROS_LIAB_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__CROS_LIAB_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "CROS_LIAB_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_CROS_LIAB == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "CROS_LIAB_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.CROS_LIAB_LIMIT-MOTOR_EXTENSIONS.CROS_LIAB_STANDLIMIT) * MOTOR_EXTENSIONS.CROS_LIAB_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_CROS_LIAB == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_CROS_LIAB == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_MEDICAL_EXPENSES", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_MEDICAL_EXPENSES");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')",
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
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_MEDICAL_EXPENSES");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES_lblFindParty");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_MEDICAL_EXPENSES&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' &&  MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_STANDSI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "MEDICAL_EXPE_STANDSI", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "MEDICAL_EXPE_STANDSI");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "MEDICAL_EXPE_SI", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "MEDICAL_EXPE_SI");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ",
            paramElseValue = "H",
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
        			var message = (Expression.isValidParameter("A validation error occurred - Medical Expenses Limit can't be less than Standard Limit")) ? "A validation error occurred - Medical Expenses Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "MEDICAL_EXPE_SI");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "MEDICAL_EXPE_SI");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXTENSIONS.MEDICAL_EXPE_SI <  MOTOR_EXTENSIONS.MEDICAL_EXPE_STANDSI && MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES==1 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__MEDICAL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "MEDICAL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "MEDICAL_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__MEDICAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "MEDICAL_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "MEDICAL_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "MEDICAL_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.MEDICAL_EXPE_SI-MOTOR_EXTENSIONS.MEDICAL_EXPE_STANDSI)*MOTOR_EXTENSIONS.MEDICAL_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_MEDICAL_EXPENSES == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_LOSS_OF_KEYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_LOSS_OF_KEYS", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_LOSS_OF_KEYS");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_LOSS_OF_KEYS&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=LOSS_OF_KEYS_STANDLIMIT&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI*0.02"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=LOSS_OF_KEYS_LIMIT&name={name}");
        		
        		var value = new Expression("MOTOR_EXTENSIONS.LOSS_OF_KEYS_STANDLIMIT"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT ==  0")) ? new Expression("MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT ==  0") : null, 
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
        			var message = (Expression.isValidParameter("A validation error occurred - Loss Of Car Keys Limit can't be less than Standard Limit")) ? "A validation error occurred - Loss Of Car Keys Limit can't be less than Standard Limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "__" + "LOSS_OF_KEYS_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXTENSIONS".toUpperCase() + "_" + "LOSS_OF_KEYS_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT >= MOTOR_EXTENSIONS.LOSS_OF_KEYS_STANDLIMIT && MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS==1 ) ||MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS==0 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=LOSS_OF_KEYS_LIMIT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 0")) ? new Expression("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_FNL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_FNL_RATE", "Text");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_FNL_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Text&objectName=MOTOR_EXTENSIONS&propertyName=LOSS_OF_KEYS_FNL_RATE&name={name}");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE * 0.25) + '%'"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode == 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode == 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE + '%'")) ? new Expression("MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE + '%'") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT-MOTOR_EXTENSIONS.LOSS_OF_KEYS_STANDLIMIT)*MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1 && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1 && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_PREMIUM");
        		
        		var value = new Expression("(MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT-MOTOR_EXTENSIONS.LOSS_OF_KEYS_STANDLIMIT)*(MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE* 0.25 * 0.01)"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1 && MOTOR.COVER_TYPECode == 'LAIDUP'")) ? new Expression("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 1 && MOTOR.COVER_TYPECode == 'LAIDUP'") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=LOSS_OF_KEYS_PREMIUM&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 0")) ? new Expression("MOTOR_EXTENSIONS.IS_LOSS_OF_KEYS == 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__IS_SELF_AUTH(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_SELF_AUTH", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_SELF_AUTH");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT'|| MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT'|| MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_SELF_AUTH&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__SELF_AUTH_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "SELF_AUTH_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "SELF_AUTH_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_SELF_AUTH == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_SELF_AUTH == true ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=SELF_AUTH_STANDLIMIT&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI*0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_SELF_AUTH == 1")) ? new Expression("MOTOR_EXTENSIONS.IS_SELF_AUTH == 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__SELF_AUTH_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "SELF_AUTH_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "SELF_AUTH_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_SELF_AUTH == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_SELF_AUTH == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__IS_TOWING(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_TOWING", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_TOWING");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT'|| MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT'|| MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_TOWING&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_lblExtHeader15(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader15" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader15");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_TOWING == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_TOWING == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__TOWING_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "TOWING_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "TOWING_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_TOWING == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_TOWING == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNSPEC_AUDIO", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNSPEC_AUDIO");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && MOTOR.VEHICLE_TYPE_CODE == 'PMVR' ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && MOTOR.VEHICLE_TYPE_CODE == 'PMVR' ",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=UNSPEC_AUDIO&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNSPEC_AUDIO_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNSPEC_AUDIO_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.UNSPEC_AUDIO == 1 ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.UNSPEC_AUDIO == 1 ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=UNSPEC_AUDIO_STANDLIMIT&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.UNSPEC_AUDIO ==  1")) ? new Expression("MOTOR_EXTENSIONS.UNSPEC_AUDIO ==  1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNSPEC_AUDIO_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "UNSPEC_AUDIO_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.UNSPEC_AUDIO == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.UNSPEC_AUDIO == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__IS_ACCOMM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_ACCOMM", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_ACCOMM");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode== 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR')",
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
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_ACCOMM");
        			    var ele = document.getElementById('ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_ACCOMM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_ACCOMM_lblFindParty");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_ACCOMM&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__ACCOMM_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "ACCOMM_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "ACCOMM_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_ACCOMM == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_ACCOMM == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__ACCOMM_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "ACCOMM_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "ACCOMM_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_ACCOMM == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_ACCOMM == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_EXTENSIONS__IS_EXC_WAV(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "IS_EXC_WAV", "Checkbox");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "IS_EXC_WAV");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP')  && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'  || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode == 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP')  && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'  || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_EXTENSIONS&propertyName=IS_EXC_WAV&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__EXC_WAV_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "EXC_WAV_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "EXC_WAV_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_EXTENSIONS.IS_EXC_WAV == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_EXTENSIONS.IS_EXC_WAV == true ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=EXC_WAV_PREMIUM&name={name}");
        		
        		var value = new Expression("MOTOR_EXTENSIONS.TOTAL_SI_LAIDUP *  MOTOR_EXTENSIONS.EXC_WAV_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_EXTENSIONS.IS_EXC_WAV==true")) ? new Expression("MOTOR_EXTENSIONS.IS_EXC_WAV==true") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_lblExtHeader25(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader25" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader25");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader26(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader26" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader26");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader27(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader27" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader27");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader28(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("lblExtHeader28" != "{na" + "me}"){
        			instance = Field.getLabel("lblExtHeader28");
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
function onValidate_MOTOR_EXTENSIONS__TOTAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "TOTAL_PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_EXTENSIONS&propertyName=TOTAL_PREMIUM&name={name}");
        		
        		var value = new Expression("MOTOR_EXTENSIONS.CONTINGENT_LIAB_PREMIUM + MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_PREMIUM + MOTOR_EXTENSIONS.PASSENGER_LIAB_PREM + MOTOR_EXTENSIONS.CROS_LIAB_PREMIUM + MOTOR_EXTENSIONS.MEDICAL_PREMIUM + MOTOR_EXTENSIONS.LOSS_OF_KEYS_PREMIUM + MOTOR_EXTENSIONS.SELF_AUTH_PREMIUM + MOTOR_EXTENSIONS.UNSPEC_AUDIO_PREMIUM + MOTOR_EXTENSIONS.ACCOMM_PREMIUM + MOTOR_EXTENSIONS.EXC_WAV_PREMIUM + MOTOR_EXTENSIONS.TOWING_PREMIUM"), 
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
        			field = Field.getInstance("MOTOR_EXTENSIONS", "TOTAL_PREMIUM");
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
}
function onValidate_MOTOR_EXTENSIONS__EXC_WAV_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "EXC_WAV_RATE", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "EXC_WAV_RATE");
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
function onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "UNSPEC_AUDIO_RATE", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "UNSPEC_AUDIO_RATE");
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
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_RATE", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_RATE");
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
function onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE_LAIDUP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "LOSS_OF_KEYS_RATE_LAIDUP", "Currency");
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_RATE_LAIDUP");
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MOTOR_EXTENSIONS", "LOSS_OF_KEYS_RATE_LAIDUP");
        		
        		
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
        			return field.setFormatPattern("#,###,###,##0.000", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("#,###,###,##0.000");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
}
function onValidate_MOTOR_EXTENSIONS__SelectedCurrency(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "SelectedCurrency", "Temp");
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "SelectedCurrency");
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
        		var field = Field.getWithQuery("type=Temp&objectName=MOTOR_EXTENSIONS&propertyName=SelectedCurrency&name={name}");
        		
        		var value = new Expression("GENERAL.SelectedCurrency"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_EXTENSIONS__TOTAL_SI_LAIDUP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXTENSIONS", "TOTAL_SI_LAIDUP", "TempCurrency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCurrency&objectName=MOTOR_EXTENSIONS&propertyName=TOTAL_SI_LAIDUP&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI/4"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode == 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode == 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("MOTOR.TOTAL_SI")) ? new Expression("MOTOR.TOTAL_SI") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
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
        			var field = Field.getInstance("MOTOR_EXTENSIONS", "TOTAL_SI_LAIDUP");
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
function onValidate_MOTOR_ADDON__ROADSIDE_ASSIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "ROADSIDE_ASSIST", "List");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=MOTOR_ADDON&propertyName=ROADSIDE_ASSIST&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'  && MOTOR.COVER_TYPECode != 'FTP'  ")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'  && MOTOR.COVER_TYPECode != 'FTP'  ") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_ADDON.ROADSIDE_ASSIST");
        			window.setControlWidth(field, "0.5", "MOTOR_ADDON", "ROADSIDE_ASSIST");
        		})();
        	}
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
        			field = Field.getInstance("MOTOR_ADDON", "ROADSIDE_ASSIST");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT'  || MOTOR.COVER_TYPECode== 'FTP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')  ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT'  || MOTOR.COVER_TYPECode== 'FTP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')  ",
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_ADDON", "ROADSIDE_ASSIST");
        		
        		var valueExp = new Expression("MOTOR_ADDON.ROADSIDE_ASSIST_PREMIUM.setValue(0)");
        		var whenExp = (Expression.isValidParameter("Code(MOTOR_ADDON.ROADSIDE_ASSIST)<>'SUPREME' || Code(MOTOR_ADDON.ROADSIDE_ASSIST)<>'BASIC'")) ? new Expression("Code(MOTOR_ADDON.ROADSIDE_ASSIST)<>'SUPREME' || Code(MOTOR_ADDON.ROADSIDE_ASSIST)<>'BASIC'") : null;
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
function onValidate_lblExtHeader34(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader34" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader34");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader35(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader35" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader35");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader36(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader36" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader36");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_MOTOR_ADDON__ROADSIDE_ASSIST_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "ROADSIDE_ASSIST_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "ROADSIDE_ASSIST_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT'  || MOTOR.COVER_TYPECode== 'FTP' ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT'  || MOTOR.COVER_TYPECode== 'FTP' ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=ROADSIDE_ASSIST_PREMIUM&name={name}");
        		
        		var value = new Expression("MOTOR_ADDON.RATE1 * MOTOR_ADDON.RSA_MULTIPLIER"), 
        			condition = (Expression.isValidParameter("Code(MOTOR_ADDON.ROADSIDE_ASSIST)=='BASIC' ")) ? new Expression("Code(MOTOR_ADDON.ROADSIDE_ASSIST)=='BASIC' ") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=ROADSIDE_ASSIST_PREMIUM&name={name}");
        		
        		var value = new Expression("MOTOR_ADDON.RATE2 * MOTOR_ADDON.RSA_MULTIPLIER"), 
        			condition = (Expression.isValidParameter("Code(MOTOR_ADDON.ROADSIDE_ASSIST)=='SUPREME'")) ? new Expression("Code(MOTOR_ADDON.ROADSIDE_ASSIST)=='SUPREME'") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=ROADSIDE_ASSIST_PREMIUM&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("Code(MOTOR_ADDON.ROADSIDE_ASSIST)==''")) ? new Expression("Code(MOTOR_ADDON.ROADSIDE_ASSIST)==''") : null, 
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=ROADSIDE_ASSIST_PREMIUM&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode == 'LAIDUP' || MOTOR.COVER_TYPECode== 'RTA' ")) ? new Expression("MOTOR.COVER_TYPECode == 'LAIDUP' || MOTOR.COVER_TYPECode== 'RTA' ") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_ADDON__POLITICAL_RIOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "POLITICAL_RIOT", "Checkbox");
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
        			field = Field.getInstance("MOTOR_ADDON", "POLITICAL_RIOT");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT' || MOTOR.COVER_TYPECode == 'LAIDUP') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR')",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_ADDON&propertyName=POLITICAL_RIOT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT' && MOTOR.COVER_TYPECode != 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_ADDON__POLRIOT_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "POLRIOT_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "POLRIOT_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.POLITICAL_RIOT == 1 ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.POLITICAL_RIOT == 1 ",
            paramElseValue = "H",
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
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=POLRIOT_STANDLIMIT&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI"), 
        			condition = (Expression.isValidParameter("MOTOR_ADDON.POLITICAL_RIOT == true")) ? new Expression("MOTOR_ADDON.POLITICAL_RIOT == true") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_ADDON__POLRIOT_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "POLRIOT_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "POLRIOT_LIMIT");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_MOTOR_ADDON__POLRIOT_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "POLRIOT_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_ADDON", "POLRIOT_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.POLITICAL_RIOT == 1 ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.POLITICAL_RIOT == 1 ",
            paramElseValue = "H",
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
function onValidate_MOTOR_ADDON__POLRIOT_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "POLRIOT_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "POLRIOT_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.POLITICAL_RIOT == 1 ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.POLITICAL_RIOT == 1 ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_ADDON", "POLRIOT_PREMIUM");
        		
        		var value = new Expression("MOTOR_ADDON.POLRIOT_STANDLIMIT * MOTOR_ADDON.POLRIOT_RATE * 0.01"), 
        			condition = (Expression.isValidParameter("MOTOR_ADDON.POLITICAL_RIOT== 1 ")) ? new Expression("MOTOR_ADDON.POLITICAL_RIOT== 1 ") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_ADDON__FUNERAL_RIDER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "FUNERAL_RIDER", "Checkbox");
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
        			field = Field.getInstance("MOTOR_ADDON", "FUNERAL_RIDER");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR') ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.COVER_TYPECode == 'COMP' || MOTOR.COVER_TYPECode== 'FTPFT') && (MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR') ",
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
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=MOTOR_ADDON&propertyName=FUNERAL_RIDER&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'")) ? new Expression("MOTOR.COVER_TYPECode != 'COMP' && MOTOR.COVER_TYPECode != 'FTPFT'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR_ADDON__FUNERAL_STANDLIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "FUNERAL_STANDLIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "FUNERAL_STANDLIMIT");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.FUNERAL_RIDER == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.FUNERAL_RIDER == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_ADDON__FUNERAL_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "FUNERAL_LIMIT", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "FUNERAL_LIMIT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR_ADDON.FUNERAL_RIDER == true ", "H", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR_ADDON.FUNERAL_RIDER == true ",
            paramElseValue = "H",
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
        			var message = (Expression.isValidParameter("A validation error occurred - Funeral Rider Limit can't be less than ZWL$50,000 or  greater than ZWL$250,000")) ? "A validation error occurred - Funeral Rider Limit can't be less than ZWL$50,000 or  greater than ZWL$250,000" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_ADDON".toUpperCase() + "__" + "FUNERAL_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_ADDON".toUpperCase() + "_" + "FUNERAL_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" (MOTOR_ADDON.FUNERAL_RIDER==1 &&  (MOTOR_ADDON.FUNERAL_LIMIT < 50000 || MOTOR_ADDON.FUNERAL_LIMIT > 250000) && MOTOR_EXTENSIONS.SelectedCurrency == 'ZWL' )");
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred - Funeral Rider Limit can't be less than USD$5,000 or  greater than USD$25,000")) ? "A validation error occurred - Funeral Rider Limit can't be less than USD$5,000 or  greater than USD$25,000" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_ADDON".toUpperCase() + "__" + "FUNERAL_LIMIT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_ADDON".toUpperCase() + "_" + "FUNERAL_LIMIT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" (MOTOR_ADDON.FUNERAL_RIDER==1) &&  (MOTOR_ADDON.FUNERAL_LIMIT < 5000 || MOTOR_ADDON.FUNERAL_LIMIT > 25000) && (MOTOR_EXTENSIONS.SelectedCurrency == 'USD' )");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR_ADDON__FUNERAL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "FUNERAL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_ADDON", "FUNERAL_RATE");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.FUNERAL_RIDER == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.FUNERAL_RIDER == true ",
            paramElseValue = "H",
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
function onValidate_MOTOR_ADDON__FUNERAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "FUNERAL_PREMIUM", "Currency");
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
        			field = Field.getInstance("MOTOR_ADDON", "FUNERAL_PREMIUM");
        		}
        		//window.setProperty(field, "V", "MOTOR_ADDON.FUNERAL_RIDER == true ", "H", "{3}");
        
            var paramValue = "V",
            paramCondition = "MOTOR_ADDON.FUNERAL_RIDER == true ",
            paramElseValue = "H",
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
         * Set Value, this is a duplicate of SetValue, this version
         * is deprecated.
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getInstance("MOTOR_ADDON", "FUNERAL_PREMIUM");
        		
        		var value = new Expression("(MOTOR_ADDON.FUNERAL_LIMIT-MOTOR_ADDON.FUNERAL_STANDLIMIT) * MOTOR_ADDON.FUNERAL_RATE * 0.01 "), 
        			condition = (Expression.isValidParameter("MOTOR_ADDON.FUNERAL_RIDER==true")) ? new Expression("MOTOR_ADDON.FUNERAL_RIDER==true") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_lblExtHeader37(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader37" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader37");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader38(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader38" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader38");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader39(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lblExtHeader39" != "{na" + "me}"){
        			field = Field.getLabel("lblExtHeader39");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "H", "{1}", "{2}", "{3}");
        
            var paramValue = "H",
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
}
function onValidate_lblExtHeader40(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("lblExtHeader40" != "{na" + "me}"){
        			instance = Field.getLabel("lblExtHeader40");
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
function onValidate_MOTOR_ADDON__TOTAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "TOTAL_PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR_ADDON&propertyName=TOTAL_PREMIUM&name={name}");
        		
        		var value = new Expression("MOTOR_ADDON.ROADSIDE_ASSIST_PREMIUM + MOTOR_ADDON.POLRIOT_PREMIUM + MOTOR_ADDON.FUNERAL_PREMIUM"), 
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
        			field = Field.getInstance("MOTOR_ADDON", "TOTAL_PREMIUM");
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
}
function onValidate_MOTOR_ADDON__RSA_MULTIPLIER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "RSA_MULTIPLIER", "Integer");
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
        			var field = Field.getInstance("MOTOR_ADDON", "RSA_MULTIPLIER");
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
function onValidate_MOTOR_ADDON__RATE1(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "RATE1", "Integer");
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
        			var field = Field.getInstance("MOTOR_ADDON", "RATE1");
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
function onValidate_MOTOR_ADDON__RATE2(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "RATE2", "Integer");
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
        			var field = Field.getInstance("MOTOR_ADDON", "RATE2");
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
function onValidate_MOTOR_ADDON__ShowHideLaidUp(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_ADDON", "ShowHideLaidUp", "TempCheckbox");
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
        			var field = Field.getInstance("MOTOR_ADDON", "ShowHideLaidUp");
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
         * ToggleContainer
         * @param frmTP The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("MOTOR_ADDON","ShowHideLaidUp");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmTP', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmTP', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("MOTOR_ADDON", "ShowHideLaidUp"), "change", update);
        		update();
        	}
        
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=MOTOR_ADDON&propertyName=ShowHideLaidUp&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("MOTOR.COVER_TYPECode == 'LAIDUP'")) ? new Expression("MOTOR.COVER_TYPECode == 'LAIDUP'") : null, 
        			elseValue = (Expression.isValidParameter("1")) ? new Expression("1") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_MOTOR_TP__IS_TPPROP_DAMAGE(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPPD_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPPD_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPPD_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPPD_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__IS_TPBODILY_INJURY(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPBI_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPBI_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPBI_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_TP__TPBI_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_PREM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_CROS_LIAB(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CROS_LIAB_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CROS_LIAB_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CROS_LIAB_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__CROS_LIAB_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_STANDSI(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_SI(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__MEDICAL_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__MEDICAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_LOSS_OF_KEYS(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_FNL_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_SELF_AUTH(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__SELF_AUTH_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__SELF_AUTH_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_TOWING(null, null, null, isOnLoad);
    onValidate_lblExtHeader15(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__TOWING_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_ACCOMM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__ACCOMM_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__ACCOMM_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__IS_EXC_WAV(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__EXC_WAV_PREMIUM(null, null, null, isOnLoad);
    onValidate_lblExtHeader25(null, null, null, isOnLoad);
    onValidate_lblExtHeader26(null, null, null, isOnLoad);
    onValidate_lblExtHeader27(null, null, null, isOnLoad);
    onValidate_lblExtHeader28(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__TOTAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__EXC_WAV_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE_LAIDUP(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__SelectedCurrency(null, null, null, isOnLoad);
    onValidate_MOTOR_EXTENSIONS__TOTAL_SI_LAIDUP(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__ROADSIDE_ASSIST(null, null, null, isOnLoad);
    onValidate_lblExtHeader34(null, null, null, isOnLoad);
    onValidate_lblExtHeader35(null, null, null, isOnLoad);
    onValidate_lblExtHeader36(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__ROADSIDE_ASSIST_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__POLITICAL_RIOT(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__POLRIOT_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__POLRIOT_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__POLRIOT_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__POLRIOT_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__FUNERAL_RIDER(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__FUNERAL_STANDLIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__FUNERAL_LIMIT(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__FUNERAL_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__FUNERAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_lblExtHeader37(null, null, null, isOnLoad);
    onValidate_lblExtHeader38(null, null, null, isOnLoad);
    onValidate_lblExtHeader39(null, null, null, isOnLoad);
    onValidate_lblExtHeader40(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__TOTAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__RSA_MULTIPLIER(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__RATE1(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__RATE2(null, null, null, isOnLoad);
    onValidate_MOTOR_ADDON__ShowHideLaidUp(null, null, null, isOnLoad);
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
<div id="idb1977b85f73c4c1aa027a8cb9fcaad96" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmTP" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading21" runat="server" Text="Third Party Liability" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="40:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader1">
		<span class="label" id="lblExtHeader1"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader2">
		<span class="label" id="lblExtHeader2"><B><U>Standard Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader3">
		<span class="label" id="lblExtHeader3"><B><U>Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader4">
		<span class="label" id="lblExtHeader4"><B><U>Rate</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader5">
		<span class="label" id="lblExtHeader5"><B><U>Premium</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_TP_IS_TPPROP_DAMAGE" for="ctl00_cntMainBody_MOTOR_TP__IS_TPPROP_DAMAGE" class="col-md-4 col-sm-3 control-label">
		Property Damage Limit</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_TP" 
		data-property-name="IS_TPPROP_DAMAGE" 
		id="pb-container-checkbox-MOTOR_TP-IS_TPPROP_DAMAGE">	
		
		<asp:TextBox ID="MOTOR_TP__IS_TPPROP_DAMAGE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_TP_IS_TPPROP_DAMAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Property Damage Limit"
			ClientValidationFunction="onValidate_MOTOR_TP__IS_TPPROP_DAMAGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_TP" 
		data-property-name="TPPD_STANDLIMIT" 
		id="pb-container-currency-MOTOR_TP-TPPD_STANDLIMIT">
		<asp:Label ID="lblMOTOR_TP_TPPD_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_TP__TPPD_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPPD_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPPD_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPPD_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_TP__TPPD_STANDLIMIT" 
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
		data-object-name="MOTOR_TP" 
		data-property-name="TPPD_LIMIT" 
		id="pb-container-currency-MOTOR_TP-TPPD_LIMIT">
		<asp:Label ID="lblMOTOR_TP_TPPD_LIMIT" runat="server" AssociatedControlID="MOTOR_TP__TPPD_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPPD_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPPD_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPPD_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_TP__TPPD_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_TP" 
		data-property-name="TPPD_RATE" 
		id="pb-container-percentage-MOTOR_TP-TPPD_RATE">
		<asp:Label ID="lblMOTOR_TP_TPPD_RATE" runat="server" AssociatedControlID="MOTOR_TP__TPPD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_TP__TPPD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPPD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPPD_RATE"
			ClientValidationFunction="onValidate_MOTOR_TP__TPPD_RATE" 
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
		data-object-name="MOTOR_TP" 
		data-property-name="TPPD_PREMIUM" 
		id="pb-container-currency-MOTOR_TP-TPPD_PREMIUM">
		<asp:Label ID="lblMOTOR_TP_TPPD_PREMIUM" runat="server" AssociatedControlID="MOTOR_TP__TPPD_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPPD_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPPD_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPPD_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_TP__TPPD_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_TP_IS_TPBODILY_INJURY" for="ctl00_cntMainBody_MOTOR_TP__IS_TPBODILY_INJURY" class="col-md-4 col-sm-3 control-label">
		Bodily Injury Limit</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_TP" 
		data-property-name="IS_TPBODILY_INJURY" 
		id="pb-container-checkbox-MOTOR_TP-IS_TPBODILY_INJURY">	
		
		<asp:TextBox ID="MOTOR_TP__IS_TPBODILY_INJURY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_TP_IS_TPBODILY_INJURY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Bodily Injury Limit"
			ClientValidationFunction="onValidate_MOTOR_TP__IS_TPBODILY_INJURY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_TP" 
		data-property-name="TPBI_STANDLIMIT" 
		id="pb-container-currency-MOTOR_TP-TPBI_STANDLIMIT">
		<asp:Label ID="lblMOTOR_TP_TPBI_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_TP__TPBI_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPBI_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPBI_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPBI_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_TP__TPBI_STANDLIMIT" 
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
		data-object-name="MOTOR_TP" 
		data-property-name="TPBI_LIMIT" 
		id="pb-container-currency-MOTOR_TP-TPBI_LIMIT">
		<asp:Label ID="lblMOTOR_TP_TPBI_LIMIT" runat="server" AssociatedControlID="MOTOR_TP__TPBI_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPBI_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPBI_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPBI_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_TP__TPBI_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_TP" 
		data-property-name="TPBI_RATE" 
		id="pb-container-percentage-MOTOR_TP-TPBI_RATE">
		<asp:Label ID="lblMOTOR_TP_TPBI_RATE" runat="server" AssociatedControlID="MOTOR_TP__TPBI_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_TP__TPBI_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPBI_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPBI_RATE"
			ClientValidationFunction="onValidate_MOTOR_TP__TPBI_RATE" 
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
		data-object-name="MOTOR_TP" 
		data-property-name="TPBI_PREMIUM" 
		id="pb-container-currency-MOTOR_TP-TPBI_PREMIUM">
		<asp:Label ID="lblMOTOR_TP_TPBI_PREMIUM" runat="server" AssociatedControlID="MOTOR_TP__TPBI_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_TP__TPBI_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TP_TPBI_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_TP.TPBI_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_TP__TPBI_PREMIUM" 
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
	(function(){
		var container = document.getElementById('frmTP'),
		zippy = new pb.ui.Zippy(
			container,
			goog.dom.query("legend", container)[0],
			goog.dom.query(".column-content", container)[0],
			true
		);
		
	})();
</script>


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
		if ($("#frmTP div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmTP div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmTP div ul li").each(function(){		  
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
			$("#frmTP div ul li").each(function(){		  
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
		styleString += "#frmTP label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmTP label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmTP label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmTP label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmTP input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmTP input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmTP input{text-align:left;}"; break;
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
<div id="id790b1ff29b504a8ab78f432e9b0c20fb" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading22" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="40:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader6">
		<span class="label" id="lblExtHeader6"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader7">
		<span class="label" id="lblExtHeader7"><B><U>Standard Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader8">
		<span class="label" id="lblExtHeader8"><B><U>Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader9">
		<span class="label" id="lblExtHeader9"><B><U>Rate</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader10">
		<span class="label" id="lblExtHeader10"><B><U>Premium</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_CONTINGENT_LIAB" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB" class="col-md-4 col-sm-3 control-label">
		Contingent Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_CONTINGENT_LIAB" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_CONTINGENT_LIAB">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_CONTINGENT_LIAB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Contingent Liability"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_CONTINGENT_LIAB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CONTINGENT_LIAB_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CONTINGENT_LIAB_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CONTINGENT_LIAB_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CONTINGENT_LIAB_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CONTINGENT_LIAB_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_STANDLIMIT" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CONTINGENT_LIAB_LIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CONTINGENT_LIAB_LIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CONTINGENT_LIAB_LIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CONTINGENT_LIAB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CONTINGENT_LIAB_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CONTINGENT_LIAB_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-CONTINGENT_LIAB_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CONTINGENT_LIAB_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CONTINGENT_LIAB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CONTINGENT_LIAB_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CONTINGENT_LIAB_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CONTINGENT_LIAB_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CONTINGENT_LIAB_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CONTINGENT_LIAB_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CONTINGENT_LIAB_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CONTINGENT_LIAB_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CONTINGENT_LIAB_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_UNAUTH_PASSENGER_LIABILITY" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY" class="col-md-4 col-sm-3 control-label">
		Unauth. Passenger Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_UNAUTH_PASSENGER_LIABILITY" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_UNAUTH_PASSENGER_LIABILITY">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_UNAUTH_PASSENGER_LIABILITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Unauth. Passenger Liability"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_UNAUTH_PASSENGER_LIABILITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNAUTH_PASSENGER_LIAB_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-UNAUTH_PASSENGER_LIAB_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_STANDLIMIT" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNAUTH_PASSENGER_LIAB_LIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-UNAUTH_PASSENGER_LIAB_LIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_LIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNAUTH_PASSENGER_LIAB_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-UNAUTH_PASSENGER_LIAB_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNAUTH_PASSENGER_LIAB_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-UNAUTH_PASSENGER_LIAB_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNAUTH_PASSENGER_LIAB_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNAUTH_PASSENGER_LIAB_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNAUTH_PASSENGER_LIAB_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_PASSENGER_LIABILITY" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY" class="col-md-4 col-sm-3 control-label">
		Auth. Passenger Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_PASSENGER_LIABILITY" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_PASSENGER_LIABILITY">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_PASSENGER_LIABILITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Auth. Passenger Liability"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_PASSENGER_LIABILITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="PASSENGER_LIAB_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-PASSENGER_LIAB_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_PASSENGER_LIAB_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__PASSENGER_LIAB_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__PASSENGER_LIAB_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_PASSENGER_LIAB_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.PASSENGER_LIAB_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_STANDLIMIT" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="PASSENGER_LIAB_LIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-PASSENGER_LIAB_LIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_PASSENGER_LIAB_LIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__PASSENGER_LIAB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__PASSENGER_LIAB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_PASSENGER_LIAB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.PASSENGER_LIAB_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="PASSENGER_LIAB_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-PASSENGER_LIAB_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_PASSENGER_LIAB_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__PASSENGER_LIAB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__PASSENGER_LIAB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_PASSENGER_LIAB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.PASSENGER_LIAB_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="PASSENGER_LIAB_PREM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-PASSENGER_LIAB_PREM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_PASSENGER_LIAB_PREM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__PASSENGER_LIAB_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__PASSENGER_LIAB_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_PASSENGER_LIAB_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.PASSENGER_LIAB_PREM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__PASSENGER_LIAB_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_CROS_LIAB" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_CROS_LIAB" class="col-md-4 col-sm-3 control-label">
		Cross Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_CROS_LIAB" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_CROS_LIAB">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_CROS_LIAB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_CROS_LIAB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cross Liability"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_CROS_LIAB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CROS_LIAB_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CROS_LIAB_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CROS_LIAB_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CROS_LIAB_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CROS_LIAB_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CROS_LIAB_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CROS_LIAB_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CROS_LIAB_STANDLIMIT" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CROS_LIAB_LIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CROS_LIAB_LIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CROS_LIAB_LIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CROS_LIAB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CROS_LIAB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CROS_LIAB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CROS_LIAB_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CROS_LIAB_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CROS_LIAB_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-CROS_LIAB_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CROS_LIAB_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CROS_LIAB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__CROS_LIAB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CROS_LIAB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CROS_LIAB_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CROS_LIAB_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="CROS_LIAB_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-CROS_LIAB_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_CROS_LIAB_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__CROS_LIAB_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__CROS_LIAB_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_CROS_LIAB_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.CROS_LIAB_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__CROS_LIAB_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_MEDICAL_EXPENSES" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES" class="col-md-4 col-sm-3 control-label">
		Medical Expenses</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_MEDICAL_EXPENSES" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_MEDICAL_EXPENSES">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_MEDICAL_EXPENSES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Medical Expenses"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_MEDICAL_EXPENSES" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="MEDICAL_EXPE_STANDSI" 
		id="pb-container-currency-MOTOR_EXTENSIONS-MEDICAL_EXPE_STANDSI">
		<asp:Label ID="lblMOTOR_EXTENSIONS_MEDICAL_EXPE_STANDSI" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__MEDICAL_EXPE_STANDSI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__MEDICAL_EXPE_STANDSI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_MEDICAL_EXPE_STANDSI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.MEDICAL_EXPE_STANDSI"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_STANDSI" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="MEDICAL_EXPE_SI" 
		id="pb-container-currency-MOTOR_EXTENSIONS-MEDICAL_EXPE_SI">
		<asp:Label ID="lblMOTOR_EXTENSIONS_MEDICAL_EXPE_SI" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__MEDICAL_EXPE_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__MEDICAL_EXPE_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_MEDICAL_EXPE_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.MEDICAL_EXPE_SI"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__MEDICAL_EXPE_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="MEDICAL_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-MEDICAL_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_MEDICAL_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__MEDICAL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__MEDICAL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_MEDICAL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.MEDICAL_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__MEDICAL_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="MEDICAL_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-MEDICAL_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_MEDICAL_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__MEDICAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__MEDICAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_MEDICAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.MEDICAL_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__MEDICAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_LOSS_OF_KEYS" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_LOSS_OF_KEYS" class="col-md-4 col-sm-3 control-label">
		Loss Of Car Keys</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_LOSS_OF_KEYS" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_LOSS_OF_KEYS">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_LOSS_OF_KEYS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_LOSS_OF_KEYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Loss Of Car Keys"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_LOSS_OF_KEYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-LOSS_OF_KEYS_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_STANDLIMIT" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_LIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-LOSS_OF_KEYS_LIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_LIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_FNL_RATE" 
		 
		
		 
		id="pb-container-text-MOTOR_EXTENSIONS-LOSS_OF_KEYS_FNL_RATE">

		
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_FNL_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_FNL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_FNL_RATE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_FNL_RATE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_FNL_RATE"
					ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_FNL_RATE"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-LOSS_OF_KEYS_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_SELF_AUTH" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_SELF_AUTH" class="col-md-4 col-sm-3 control-label">
		Self-Authorization</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_SELF_AUTH" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_SELF_AUTH">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_SELF_AUTH" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_SELF_AUTH" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Self-Authorization"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_SELF_AUTH" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="SELF_AUTH_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-SELF_AUTH_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_SELF_AUTH_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__SELF_AUTH_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__SELF_AUTH_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_SELF_AUTH_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.SELF_AUTH_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__SELF_AUTH_STANDLIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader13">
		<span class="label" id="lblExtHeader13"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader14">
		<span class="label" id="lblExtHeader14"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="SELF_AUTH_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-SELF_AUTH_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_SELF_AUTH_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__SELF_AUTH_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__SELF_AUTH_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_SELF_AUTH_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.SELF_AUTH_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__SELF_AUTH_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_TOWING" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_TOWING" class="col-md-4 col-sm-3 control-label">
		Towing</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_TOWING" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_TOWING">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_TOWING" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_TOWING" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Towing"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_TOWING" 
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
	<span id="pb-container-label-lblExtHeader15">
		<span class="label" id="lblExtHeader15">Reasonable to nearest garage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader16">
		<span class="label" id="lblExtHeader16"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader17">
		<span class="label" id="lblExtHeader17"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="TOWING_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-TOWING_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_TOWING_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__TOWING_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__TOWING_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_TOWING_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.TOWING_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__TOWING_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_UNSPEC_AUDIO" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__UNSPEC_AUDIO" class="col-md-4 col-sm-3 control-label">
		Unspecified Audio Equipment</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNSPEC_AUDIO" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-UNSPEC_AUDIO">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__UNSPEC_AUDIO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNSPEC_AUDIO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Unspecified Audio Equipment"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNSPEC_AUDIO_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-UNSPEC_AUDIO_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNSPEC_AUDIO_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNSPEC_AUDIO_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNSPEC_AUDIO_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_STANDLIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader19">
		<span class="label" id="lblExtHeader19"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader20">
		<span class="label" id="lblExtHeader20"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNSPEC_AUDIO_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-UNSPEC_AUDIO_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNSPEC_AUDIO_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNSPEC_AUDIO_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNSPEC_AUDIO_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_ACCOMM" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_ACCOMM" class="col-md-4 col-sm-3 control-label">
		Emergency Accommodation</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_ACCOMM" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_ACCOMM">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_ACCOMM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_ACCOMM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Emergency Accommodation"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_ACCOMM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="ACCOMM_STANDLIMIT" 
		id="pb-container-currency-MOTOR_EXTENSIONS-ACCOMM_STANDLIMIT">
		<asp:Label ID="lblMOTOR_EXTENSIONS_ACCOMM_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__ACCOMM_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__ACCOMM_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_ACCOMM_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.ACCOMM_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__ACCOMM_STANDLIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader41">
		<span class="label" id="lblExtHeader41"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader21">
		<span class="label" id="lblExtHeader21"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="ACCOMM_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-ACCOMM_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_ACCOMM_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__ACCOMM_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__ACCOMM_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_ACCOMM_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.ACCOMM_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__ACCOMM_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_IS_EXC_WAV" for="ctl00_cntMainBody_MOTOR_EXTENSIONS__IS_EXC_WAV" class="col-md-4 col-sm-3 control-label">
		Excess Buy Back </label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="IS_EXC_WAV" 
		id="pb-container-checkbox-MOTOR_EXTENSIONS-IS_EXC_WAV">	
		
		<asp:TextBox ID="MOTOR_EXTENSIONS__IS_EXC_WAV" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_IS_EXC_WAV" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Excess Buy Back "
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__IS_EXC_WAV" 
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
	<span id="pb-container-label-lblExtHeader22">
		<span class="label" id="lblExtHeader22"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader23">
		<span class="label" id="lblExtHeader23"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader24">
		<span class="label" id="lblExtHeader24"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="EXC_WAV_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-EXC_WAV_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_EXC_WAV_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__EXC_WAV_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__EXC_WAV_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_EXC_WAV_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.EXC_WAV_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__EXC_WAV_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader25">
		<span class="label" id="lblExtHeader25"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader26">
		<span class="label" id="lblExtHeader26"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader27">
		<span class="label" id="lblExtHeader27"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader28">
		<span class="label" id="lblExtHeader28">Total Extensions Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="TOTAL_PREMIUM" 
		id="pb-container-currency-MOTOR_EXTENSIONS-TOTAL_PREMIUM">
		<asp:Label ID="lblMOTOR_EXTENSIONS_TOTAL_PREMIUM" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__TOTAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__TOTAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_TOTAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.TOTAL_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__TOTAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="EXC_WAV_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-EXC_WAV_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_EXC_WAV_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__EXC_WAV_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__EXC_WAV_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_EXC_WAV_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.EXC_WAV_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__EXC_WAV_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="UNSPEC_AUDIO_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-UNSPEC_AUDIO_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_UNSPEC_AUDIO_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__UNSPEC_AUDIO_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_UNSPEC_AUDIO_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.UNSPEC_AUDIO_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__UNSPEC_AUDIO_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_RATE" 
		id="pb-container-percentage-MOTOR_EXTENSIONS-LOSS_OF_KEYS_RATE">
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_RATE" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE" 
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
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="LOSS_OF_KEYS_RATE_LAIDUP" 
		id="pb-container-currency-MOTOR_EXTENSIONS-LOSS_OF_KEYS_RATE_LAIDUP">
		<asp:Label ID="lblMOTOR_EXTENSIONS_LOSS_OF_KEYS_RATE_LAIDUP" runat="server" AssociatedControlID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE_LAIDUP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE_LAIDUP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_EXTENSIONS_LOSS_OF_KEYS_RATE_LAIDUP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.LOSS_OF_KEYS_RATE_LAIDUP"
			ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__LOSS_OF_KEYS_RATE_LAIDUP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_SelectedCurrency"></label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="SelectedCurrency" 
		id="pb-container-text-MOTOR_EXTENSIONS-SelectedCurrency"
	>
	<input id="ctl00_cntMainBody_MOTOR_EXTENSIONS_SelectedCurrency" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valMOTOR_EXTENSIONS_SelectedCurrency" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for MOTOR_EXTENSIONS.SelectedCurrency"
								ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__SelectedCurrency" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- TempCurrency -->
	<label id="ctl00_cntMainBody_lblMOTOR_EXTENSIONS_TOTAL_SI_LAIDUP">TOTAL_SI_LAIDUP</label>
	<span class="field-container"
		data-field-type="TempCurrency" 
		data-object-name="MOTOR_EXTENSIONS" 
		data-property-name="TOTAL_SI_LAIDUP" 
		id="pb-container-currency-MOTOR_EXTENSIONS-TOTAL_SI_LAIDUP"
	>
	<input id="ctl00_cntMainBody_MOTOR_EXTENSIONS_TOTAL_SI_LAIDUP" class="field-medium" />
	</span>
	<asp:CustomValidator ID="valMOTOR_EXTENSIONS_TOTAL_SI_LAIDUP" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for TOTAL_SI_LAIDUP"
								ClientValidationFunction="onValidate_MOTOR_EXTENSIONS__TOTAL_SI_LAIDUP" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /TempCurrency -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('id790b1ff29b504a8ab78f432e9b0c20fb'),
		zippy = new pb.ui.Zippy(
			container,
			goog.dom.query("legend", container)[0],
			goog.dom.query(".column-content", container)[0],
			true
		);
		
	})();
</script>


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
		if ($("#id790b1ff29b504a8ab78f432e9b0c20fb div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id790b1ff29b504a8ab78f432e9b0c20fb div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id790b1ff29b504a8ab78f432e9b0c20fb div ul li").each(function(){		  
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
			$("#id790b1ff29b504a8ab78f432e9b0c20fb div ul li").each(function(){		  
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
		styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id790b1ff29b504a8ab78f432e9b0c20fb input{text-align:left;}"; break;
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
<div id="id00786ce59d1f47d98bbf9d63d99e9c60" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading23" runat="server" Text="Add Ons" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="40:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader29">
		<span class="label" id="lblExtHeader29"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader30">
		<span class="label" id="lblExtHeader30"><B><U>Standard Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader31">
		<span class="label" id="lblExtHeader31"><B><U>Limit</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader32">
		<span class="label" id="lblExtHeader32"><B><U>Rate</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader33">
		<span class="label" id="lblExtHeader33"><B><U>Premium</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="ROADSIDE_ASSIST" 
		id="pb-container-list-MOTOR_ADDON-ROADSIDE_ASSIST">
		
					
		<asp:Label ID="lblMOTOR_ADDON_ROADSIDE_ASSIST" runat="server" AssociatedControlID="MOTOR_ADDON__ROADSIDE_ASSIST" 
			Text="Roadside Assist" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR_ADDON__ROADSIDE_ASSIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_PM_ROAD_ASSIST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR_ADDON__ROADSIDE_ASSIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_ADDON_ROADSIDE_ASSIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Roadside Assist"
			ClientValidationFunction="onValidate_MOTOR_ADDON__ROADSIDE_ASSIST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
			  

					
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader34">
		<span class="label" id="lblExtHeader34"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader35">
		<span class="label" id="lblExtHeader35"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader36">
		<span class="label" id="lblExtHeader36"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="ROADSIDE_ASSIST_PREMIUM" 
		id="pb-container-currency-MOTOR_ADDON-ROADSIDE_ASSIST_PREMIUM">
		<asp:Label ID="lblMOTOR_ADDON_ROADSIDE_ASSIST_PREMIUM" runat="server" AssociatedControlID="MOTOR_ADDON__ROADSIDE_ASSIST_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__ROADSIDE_ASSIST_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_ROADSIDE_ASSIST_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.ROADSIDE_ASSIST_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_ADDON__ROADSIDE_ASSIST_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_ADDON_POLITICAL_RIOT" for="ctl00_cntMainBody_MOTOR_ADDON__POLITICAL_RIOT" class="col-md-4 col-sm-3 control-label">
		Political Riot</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="POLITICAL_RIOT" 
		id="pb-container-checkbox-MOTOR_ADDON-POLITICAL_RIOT">	
		
		<asp:TextBox ID="MOTOR_ADDON__POLITICAL_RIOT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_ADDON_POLITICAL_RIOT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Political Riot"
			ClientValidationFunction="onValidate_MOTOR_ADDON__POLITICAL_RIOT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="POLRIOT_STANDLIMIT" 
		id="pb-container-currency-MOTOR_ADDON-POLRIOT_STANDLIMIT">
		<asp:Label ID="lblMOTOR_ADDON_POLRIOT_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_ADDON__POLRIOT_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__POLRIOT_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_POLRIOT_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.POLRIOT_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_ADDON__POLRIOT_STANDLIMIT" 
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
		data-object-name="MOTOR_ADDON" 
		data-property-name="POLRIOT_LIMIT" 
		id="pb-container-currency-MOTOR_ADDON-POLRIOT_LIMIT">
		<asp:Label ID="lblMOTOR_ADDON_POLRIOT_LIMIT" runat="server" AssociatedControlID="MOTOR_ADDON__POLRIOT_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__POLRIOT_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_POLRIOT_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.POLRIOT_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_ADDON__POLRIOT_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="POLRIOT_RATE" 
		id="pb-container-percentage-MOTOR_ADDON-POLRIOT_RATE">
		<asp:Label ID="lblMOTOR_ADDON_POLRIOT_RATE" runat="server" AssociatedControlID="MOTOR_ADDON__POLRIOT_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_ADDON__POLRIOT_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_POLRIOT_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.POLRIOT_RATE"
			ClientValidationFunction="onValidate_MOTOR_ADDON__POLRIOT_RATE" 
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
		data-object-name="MOTOR_ADDON" 
		data-property-name="POLRIOT_PREMIUM" 
		id="pb-container-currency-MOTOR_ADDON-POLRIOT_PREMIUM">
		<asp:Label ID="lblMOTOR_ADDON_POLRIOT_PREMIUM" runat="server" AssociatedControlID="MOTOR_ADDON__POLRIOT_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__POLRIOT_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_POLRIOT_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.POLRIOT_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_ADDON__POLRIOT_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblMOTOR_ADDON_FUNERAL_RIDER" for="ctl00_cntMainBody_MOTOR_ADDON__FUNERAL_RIDER" class="col-md-4 col-sm-3 control-label">
		Funeral Rider</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="FUNERAL_RIDER" 
		id="pb-container-checkbox-MOTOR_ADDON-FUNERAL_RIDER">	
		
		<asp:TextBox ID="MOTOR_ADDON__FUNERAL_RIDER" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_ADDON_FUNERAL_RIDER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Funeral Rider"
			ClientValidationFunction="onValidate_MOTOR_ADDON__FUNERAL_RIDER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="FUNERAL_STANDLIMIT" 
		id="pb-container-currency-MOTOR_ADDON-FUNERAL_STANDLIMIT">
		<asp:Label ID="lblMOTOR_ADDON_FUNERAL_STANDLIMIT" runat="server" AssociatedControlID="MOTOR_ADDON__FUNERAL_STANDLIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__FUNERAL_STANDLIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_FUNERAL_STANDLIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.FUNERAL_STANDLIMIT"
			ClientValidationFunction="onValidate_MOTOR_ADDON__FUNERAL_STANDLIMIT" 
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
		data-object-name="MOTOR_ADDON" 
		data-property-name="FUNERAL_LIMIT" 
		id="pb-container-currency-MOTOR_ADDON-FUNERAL_LIMIT">
		<asp:Label ID="lblMOTOR_ADDON_FUNERAL_LIMIT" runat="server" AssociatedControlID="MOTOR_ADDON__FUNERAL_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__FUNERAL_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_FUNERAL_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.FUNERAL_LIMIT"
			ClientValidationFunction="onValidate_MOTOR_ADDON__FUNERAL_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="FUNERAL_RATE" 
		id="pb-container-percentage-MOTOR_ADDON-FUNERAL_RATE">
		<asp:Label ID="lblMOTOR_ADDON_FUNERAL_RATE" runat="server" AssociatedControlID="MOTOR_ADDON__FUNERAL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_ADDON__FUNERAL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_FUNERAL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.FUNERAL_RATE"
			ClientValidationFunction="onValidate_MOTOR_ADDON__FUNERAL_RATE" 
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
		data-object-name="MOTOR_ADDON" 
		data-property-name="FUNERAL_PREMIUM" 
		id="pb-container-currency-MOTOR_ADDON-FUNERAL_PREMIUM">
		<asp:Label ID="lblMOTOR_ADDON_FUNERAL_PREMIUM" runat="server" AssociatedControlID="MOTOR_ADDON__FUNERAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__FUNERAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_FUNERAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.FUNERAL_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_ADDON__FUNERAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader37">
		<span class="label" id="lblExtHeader37"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader38">
		<span class="label" id="lblExtHeader38"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader39">
		<span class="label" id="lblExtHeader39"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblExtHeader40">
		<span class="label" id="lblExtHeader40">Total Add On Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="TOTAL_PREMIUM" 
		id="pb-container-currency-MOTOR_ADDON-TOTAL_PREMIUM">
		<asp:Label ID="lblMOTOR_ADDON_TOTAL_PREMIUM" runat="server" AssociatedControlID="MOTOR_ADDON__TOTAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR_ADDON__TOTAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ADDON_TOTAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.TOTAL_PREMIUM"
			ClientValidationFunction="onValidate_MOTOR_ADDON__TOTAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:40%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="RSA_MULTIPLIER" 
		id="pb-container-integer-MOTOR_ADDON-RSA_MULTIPLIER">
		<asp:Label ID="lblMOTOR_ADDON_RSA_MULTIPLIER" runat="server" AssociatedControlID="MOTOR_ADDON__RSA_MULTIPLIER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR_ADDON__RSA_MULTIPLIER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_ADDON_RSA_MULTIPLIER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.RSA_MULTIPLIER"
			ClientValidationFunction="onValidate_MOTOR_ADDON__RSA_MULTIPLIER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="RATE1" 
		id="pb-container-integer-MOTOR_ADDON-RATE1">
		<asp:Label ID="lblMOTOR_ADDON_RATE1" runat="server" AssociatedControlID="MOTOR_ADDON__RATE1" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR_ADDON__RATE1" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_ADDON_RATE1" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.RATE1"
			ClientValidationFunction="onValidate_MOTOR_ADDON__RATE1" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="RATE2" 
		id="pb-container-integer-MOTOR_ADDON-RATE2">
		<asp:Label ID="lblMOTOR_ADDON_RATE2" runat="server" AssociatedControlID="MOTOR_ADDON__RATE2" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR_ADDON__RATE2" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_ADDON_RATE2" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.RATE2"
			ClientValidationFunction="onValidate_MOTOR_ADDON__RATE2" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="MOTOR_ADDON" 
		data-property-name="ShowHideLaidUp" 
		id="pb-container-checkbox-MOTOR_ADDON-ShowHideLaidUp"
	>
		<label id="ctl00_cntMainBody_lblMOTOR_ADDON_ShowHideLaidUp" for="ctl00_cntMainBody_MOTOR_ADDON_ShowHideLaidUp_select"></label>
		<input id="ctl00_cntMainBody_MOTOR_ADDON_ShowHideLaidUp" class="field-medium hidden" />
			<asp:CustomValidator ID="valMOTOR_ADDON_ShowHideLaidUp" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR_ADDON.ShowHideLaidUp"
			ClientValidationFunction="onValidate_MOTOR_ADDON__ShowHideLaidUp" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>

	
<!-- /TempCheckbox -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR_ADDON" 
		data-property-name="ROADSIDE_ASSISTCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-MOTOR_ADDON-ROADSIDE_ASSISTCode">

		
		
			
		
				<asp:HiddenField ID="MOTOR_ADDON__ROADSIDE_ASSISTCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('id00786ce59d1f47d98bbf9d63d99e9c60'),
		zippy = new pb.ui.Zippy(
			container,
			goog.dom.query("legend", container)[0],
			goog.dom.query(".column-content", container)[0],
			true
		);
		
	})();
</script>


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
		if ($("#id00786ce59d1f47d98bbf9d63d99e9c60 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id00786ce59d1f47d98bbf9d63d99e9c60 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id00786ce59d1f47d98bbf9d63d99e9c60 div ul li").each(function(){		  
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
			$("#id00786ce59d1f47d98bbf9d63d99e9c60 div ul li").each(function(){		  
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
		styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id00786ce59d1f47d98bbf9d63d99e9c60 input{text-align:left;}"; break;
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