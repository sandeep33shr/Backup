<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMAGIT_Risk_Details.aspx.vb" Inherits="Nexus.PB2_CMAGIT_Risk_Details" %>

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
         * @fileoverview Toggle Tab Based on the value of a checkbox control.
         * @param {boolean} value
         */
        function ToggleTabBasedOn(tabId, value) {
        
        	if (value)
        		ShowTab(tabId);
        	else
        		HideTab(tabId);
        	
        }
function onValidate_GENERAL__RISKATTACHDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "RISKATTACHDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GENERAL", "RISKATTACHDATE");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=GENERAL&propertyName=RISKATTACHDATE&name={name}");
        		
        		var value = new Expression("NOW"), 
        			condition = (Expression.isValidParameter("GENERAL.RISKATTACHDATE = '' OR GENERAL.RISKATTACHDATE = null")) ? new Expression("GENERAL.RISKATTACHDATE = '' OR GENERAL.RISKATTACHDATE = null") : null, 
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_RISKATTACHDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__RISKATTACHDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__RISKATTACHDATE_lblFindParty");
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
              var field = Field.getInstance("GENERAL.RISKATTACHDATE");
        			window.setControlWidth(field, "0.8", "GENERAL", "RISKATTACHDATE");
        		})();
        	}
        })();
}
function onValidate_GENERAL__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GENERAL", "EFFECTIVEDATE");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=GENERAL&propertyName=EFFECTIVEDATE&name={name}");
        		
        		var value = new Expression("NOW"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__EFFECTIVEDATE_lblFindParty");
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
              var field = Field.getInstance("GENERAL.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.8", "GENERAL", "EFFECTIVEDATE");
        		})();
        	}
        })();
}
function onValidate_GENERAL__IS_VAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "IS_VAT", "List");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_IS_VAT");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__IS_VAT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__IS_VAT_lblFindParty");
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
              var field = Field.getInstance("GENERAL.IS_VAT");
        			window.setControlWidth(field, "0.8", "GENERAL", "IS_VAT");
        		})();
        	}
        })();
}
function onValidate_GENERAL__FLAT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "FLAT_PREM", "Checkbox");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_FLAT_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__FLAT_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__FLAT_PREM_lblFindParty");
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
              var field = Field.getInstance("GENERAL.FLAT_PREM");
        			window.setControlWidth(field, "0.8", "GENERAL", "FLAT_PREM");
        		})();
        	}
        })();
}
function onValidate_GENERAL__TOTAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "TOTAL_PREM", "Currency");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_TOTAL_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__TOTAL_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__TOTAL_PREM_lblFindParty");
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
              var field = Field.getInstance("GENERAL.TOTAL_PREM");
        			window.setControlWidth(field, "0.8", "GENERAL", "TOTAL_PREM");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__ADDRESSLIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "ADDRESSLIST", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("ADDRESS", "ADDRESSLIST");
        		var errorMessage = "Address Type is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_ADDRESSLIST");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__ADDRESSLIST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__ADDRESSLIST_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.ADDRESSLIST");
        			window.setControlWidth(field, "0.8", "ADDRESS", "ADDRESSLIST");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__SITEADDRESSLIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "SITEADDRESSLIST", "List");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "SITEADDRESSLIST");
        		}
        		//window.setProperty(field, "VEM", "Code(ADDRESS.ADDRESSLIST) == '3131XSA'", "R", "Site Address is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "Code(ADDRESS.ADDRESSLIST) == '3131XSA'",
            paramElseValue = "R",
            paramValidationMessage = "Site Address is mandatory and an option must be selected";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        		var field = Field.getWithQuery("type=List&objectName=ADDRESS&propertyName=SITEADDRESSLIST&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("Code(ADDRESS.ADDRESSLIST) != '3131XSA'")) ? new Expression("Code(ADDRESS.ADDRESSLIST) != '3131XSA'") : null, 
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_SITEADDRESSLIST");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__SITEADDRESSLIST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__SITEADDRESSLIST_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.SITEADDRESSLIST");
        			window.setControlWidth(field, "0.8", "ADDRESS", "SITEADDRESSLIST");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__HOMEADDRESSLIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "HOMEADDRESSLIST", "List");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "HOMEADDRESSLIST");
        		}
        		//window.setProperty(field, "VEM", "Code(ADDRESS.ADDRESSLIST) == '3131001'", "R", "Home Address is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "Code(ADDRESS.ADDRESSLIST) == '3131001'",
            paramElseValue = "R",
            paramValidationMessage = "Home Address is mandatory and an option must be selected";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        		var field = Field.getWithQuery("type=List&objectName=ADDRESS&propertyName=HOMEADDRESSLIST&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("Code(ADDRESS.ADDRESSLIST) != '3131001'")) ? new Expression("Code(ADDRESS.ADDRESSLIST) != '3131001'") : null, 
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_HOMEADDRESSLIST");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__HOMEADDRESSLIST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__HOMEADDRESSLIST_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.HOMEADDRESSLIST");
        			window.setControlWidth(field, "0.8", "ADDRESS", "HOMEADDRESSLIST");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__B_ADDRESSLIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "B_ADDRESSLIST", "List");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "B_ADDRESSLIST");
        		}
        		//window.setProperty(field, "VEM", "Code(ADDRESS.ADDRESSLIST) == '3131002'", "R", "Business Address is mandatory and an option must be selected");
        
            var paramValue = "VEM",
            paramCondition = "Code(ADDRESS.ADDRESSLIST) == '3131002'",
            paramElseValue = "R",
            paramValidationMessage = "Business Address is mandatory and an option must be selected";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        		var field = Field.getWithQuery("type=List&objectName=ADDRESS&propertyName=B_ADDRESSLIST&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("Code(ADDRESS.ADDRESSLIST) != '3131002'")) ? new Expression("Code(ADDRESS.ADDRESSLIST) != '3131002'") : null, 
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_B_ADDRESSLIST");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__B_ADDRESSLIST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__B_ADDRESSLIST_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.B_ADDRESSLIST");
        			window.setControlWidth(field, "0.8", "ADDRESS", "B_ADDRESSLIST");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__LINE1(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "LINE1", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "LINE1");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_LINE1");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__LINE1');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__LINE1_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.LINE1");
        			window.setControlWidth(field, "0.8", "ADDRESS", "LINE1");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__SUBURB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "SUBURB", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "SUBURB");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_SUBURB");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__SUBURB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__SUBURB_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.SUBURB");
        			window.setControlWidth(field, "0.8", "ADDRESS", "SUBURB");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__TOWN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "TOWN", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "TOWN");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_TOWN");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__TOWN');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__TOWN_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.TOWN");
        			window.setControlWidth(field, "0.8", "ADDRESS", "TOWN");
        		})();
        	}
        })();
        $(document).ready(function()
        {
        	
        	var address_field = Field.getInstance ("ADDRESS","ADDRESSLIST");
        	events.listen(address_field,"change", function (e)
        	{
        		var address_result = address_field.getCode();
        		if (address_result != null && address_result != "")
        		{
        			var val = 'ClientAddress,' + address_result;
        			PostBack(val);
        		}
        		
        	},false, this);
        	
        	var site_field = Field.getInstance ("ADDRESS","SITEADDRESSLIST");
        	events.listen(site_field,"change", function (e)
        	{
        		var site_result = site_field.getCode();
        		if (site_result != null && site_result != "")
        		{
        			var val = 'SiteAddress,' + site_result;
        			PostBack(val);
        		}
        		
        	},false, this);
        	
        	var home_field = Field.getInstance ("ADDRESS","HOMEADDRESSLIST");
        	events.listen(home_field,"change", function (e)
        	{
        		var home_result = home_field.getCode();
        		if (home_result != null && home_result != "")
        		{
        			var val = 'HomeAddress,' + home_result;
        			PostBack(val);
        		}
        		
        	},false, this);
        	
        	var business_field = Field.getInstance ("ADDRESS","B_ADDRESSLIST");
        	events.listen(business_field,"change", function (e)
        	{
        		var business_result = business_field.getCode();
        		if (business_result != null && business_result != "")
        		{
        			var val = 'BusinessAddress,' + business_result;
        			PostBack(val);
        		}
        		
        	},false, this);
        	
        	function PostBack(Value)
        	{
        		__doPostBack('<%=asyncPanel.ClientID%>', Value);
        	}
        	
        });
}
function onValidate_ADDRESS__POSTCODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "POSTCODE", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "POSTCODE");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_POSTCODE");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__POSTCODE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__POSTCODE_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.POSTCODE");
        			window.setControlWidth(field, "0.8", "ADDRESS", "POSTCODE");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__REGION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "REGION", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "REGION");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_REGION");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__REGION');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__REGION_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.REGION");
        			window.setControlWidth(field, "0.8", "ADDRESS", "REGION");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__COUNTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "COUNTRY", "List");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("ADDRESS", "COUNTRY");
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
        
        			var width = window.parseFloat("0.7");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_COUNTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__COUNTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__COUNTRY_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.COUNTRY");
        			window.setControlWidth(field, "0.8", "ADDRESS", "COUNTRY");
        		})();
        	}
        })();
}
function onValidate_ADDRESS__AREACODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ADDRESS", "AREACODE", "Text");
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
        			var field = Field.getInstance("ADDRESS", "AREACODE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblADDRESS_AREACODE");
        			    var ele = document.getElementById('ctl00_cntMainBody_ADDRESS__AREACODE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_ADDRESS__AREACODE_lblFindParty");
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
              var field = Field.getInstance("ADDRESS.AREACODE");
        			window.setControlWidth(field, "0.8", "ADDRESS", "AREACODE");
        		})();
        	}
        })();
}
function onValidate_GENERAL__PRIMARY_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "PRIMARY_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_PRIMARY_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__PRIMARY_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__PRIMARY_INDUSTRY_lblFindParty");
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
              var field = Field.getInstance("GENERAL.PRIMARY_INDUSTRY");
        			window.setControlWidth(field, "0.8", "GENERAL", "PRIMARY_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_GENERAL__SECOND_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "SECOND_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_SECOND_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__SECOND_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__SECOND_INDUSTRY_lblFindParty");
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
              var field = Field.getInstance("GENERAL.SECOND_INDUSTRY");
        			window.setControlWidth(field, "0.8", "GENERAL", "SECOND_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_GENERAL__TERTIARY_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "TERTIARY_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_TERTIARY_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__TERTIARY_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__TERTIARY_INDUSTRY_lblFindParty");
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
              var field = Field.getInstance("GENERAL.TERTIARY_INDUSTRY");
        			window.setControlWidth(field, "0.8", "GENERAL", "TERTIARY_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_GENERAL__INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGENERAL_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_GENERAL__INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GENERAL__INDUSTRY_lblFindParty");
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
              var field = Field.getInstance("GENERAL.INDUSTRY");
        			window.setControlWidth(field, "0.8", "GENERAL", "INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_CLAIM_HISTORY__MS0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("CLAIM_HISTORY", "MS0_12_MONTHS");
        		var errorMessage = "0-12 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("CLAIM_HISTORY", "MS0_12_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_CLAIM_HISTORY__MS0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("CLAIM_HISTORY", "MS0_12_AMOUNT");
        		}
        		//window.setProperty(field, "V", "CLAIM_HISTORY.MS0_12_MONTHSCode = 1 OR CLAIM_HISTORY.MS0_12_MONTHSCode = 2", "VEM", "0-12 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "CLAIM_HISTORY.MS0_12_MONTHSCode = 1 OR CLAIM_HISTORY.MS0_12_MONTHSCode = 2",
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
        		var field = Field.getInstance("CLAIM_HISTORY", "MS0_12_AMOUNT");
        		
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
        
        			var field = Field.getInstance('CLAIM_HISTORY', 'MS0_12_AMOUNT');
        			
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
        		var field = Field.getInstance("CLAIM_HISTORY", "MS0_12_AMOUNT");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=CLAIM_HISTORY&propertyName=MS0_12_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("CLAIM_HISTORY.MS0_12_MONTHSCode = 1 OR CLAIM_HISTORY.MS0_12_MONTHSCode = 2")) ? new Expression("CLAIM_HISTORY.MS0_12_MONTHSCode = 1 OR CLAIM_HISTORY.MS0_12_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_CLAIM_HISTORY__MS13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("CLAIM_HISTORY", "MS13_24_MONTHS");
        		var errorMessage = "13-24 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("CLAIM_HISTORY", "MS13_24_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_CLAIM_HISTORY__MS13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("CLAIM_HISTORY", "MS13_24_AMOUNT");
        		}
        		//window.setProperty(field, "V", "CLAIM_HISTORY.MS13_24_MONTHSCode = 1 OR CLAIM_HISTORY.MS13_24_MONTHSCode = 2", "VEM", "13-24 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "CLAIM_HISTORY.MS13_24_MONTHSCode = 1 OR CLAIM_HISTORY.MS13_24_MONTHSCode = 2",
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
        		var field = Field.getInstance("CLAIM_HISTORY", "MS13_24_AMOUNT");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=CLAIM_HISTORY&propertyName=MS13_24_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("CLAIM_HISTORY.MS13_24_MONTHSCode = 1 OR CLAIM_HISTORY.MS13_24_MONTHSCode = 2")) ? new Expression("CLAIM_HISTORY.MS13_24_MONTHSCode = 1 OR CLAIM_HISTORY.MS13_24_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("CLAIM_HISTORY", "MS13_24_AMOUNT");
        		
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
        
        			var field = Field.getInstance('CLAIM_HISTORY', 'MS13_24_AMOUNT');
        			
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
function onValidate_CLAIM_HISTORY__MS25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("CLAIM_HISTORY", "MS25_36_MONTHS");
        		var errorMessage = "25-36 Months is mandatory and must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("CLAIM_HISTORY", "MS25_36_MONTHS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_CLAIM_HISTORY__MS25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "MS25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("CLAIM_HISTORY", "MS25_36_AMOUNT");
        		}
        		//window.setProperty(field, "V", "CLAIM_HISTORY.MS25_36_MONTHSCode = 1 OR CLAIM_HISTORY.MS25_36_MONTHSCode = 2", "VEM", "25-36 Months Amount is mandatory and an amount must be entered");
        
            var paramValue = "V",
            paramCondition = "CLAIM_HISTORY.MS25_36_MONTHSCode = 1 OR CLAIM_HISTORY.MS25_36_MONTHSCode = 2",
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
        		var field = Field.getInstance("CLAIM_HISTORY", "MS25_36_AMOUNT");
        		
        		
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
        		var field = Field.getWithQuery("type=Currency&objectName=CLAIM_HISTORY&propertyName=MS25_36_AMOUNT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("CLAIM_HISTORY.MS25_36_MONTHSCode = 1 OR CLAIM_HISTORY.MS25_36_MONTHSCode = 2")) ? new Expression("CLAIM_HISTORY.MS25_36_MONTHSCode = 1 OR CLAIM_HISTORY.MS25_36_MONTHSCode = 2") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("CLAIM_HISTORY", "MS25_36_AMOUNT");
        		
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
        
        			var field = Field.getInstance('CLAIM_HISTORY', 'MS25_36_AMOUNT');
        			
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
function onValidate_GIT__BASIS_OF_COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_OF_COVER", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT.BASIS_OF_COVER");
        			window.setControlWidth(field, "0.8", "GIT", "BASIS_OF_COVER");
        		})();
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_BASIS_OF_COVER");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__BASIS_OF_COVER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__BASIS_OF_COVER_lblFindParty");
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
function onValidate_GIT__BASIS_OF_RATING(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_OF_RATING", "List");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT.BASIS_OF_RATING");
        			window.setControlWidth(field, "0.8", "GIT", "BASIS_OF_RATING");
        		})();
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_BASIS_OF_RATING");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__BASIS_OF_RATING');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__BASIS_OF_RATING_lblFindParty");
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
function onValidate_GIT__BASIS_AC_CHECK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_AC_CHECK", "Checkbox");
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
        			var field = Field.getInstance("GIT", "BASIS_AC_CHECK");
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=GIT&propertyName=BASIS_AC_CHECK&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("Code(GIT.BASIS_OF_RATING) = 1")) ? new Expression("Code(GIT.BASIS_OF_RATING) = 1") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmAC The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("GIT","BASIS_AC_CHECK");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmAC', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmAC', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("GIT", "BASIS_AC_CHECK"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_GIT__BASIS_LL_CHECK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_LL_CHECK", "Checkbox");
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
        			var field = Field.getInstance("GIT", "BASIS_LL_CHECK");
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=GIT&propertyName=BASIS_LL_CHECK&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("Code(GIT.BASIS_OF_RATING) = 2")) ? new Expression("Code(GIT.BASIS_OF_RATING) = 2") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmLL The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("GIT","BASIS_LL_CHECK");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmLL', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmLL', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("GIT", "BASIS_LL_CHECK"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_GIT__BASIS_AH_CHECK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_AH_CHECK", "Checkbox");
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
        			var field = Field.getInstance("GIT", "BASIS_AH_CHECK");
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=GIT&propertyName=BASIS_AH_CHECK&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("Code(GIT.BASIS_OF_RATING) = 3")) ? new Expression("Code(GIT.BASIS_OF_RATING) = 3") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmAH The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("GIT","BASIS_AH_CHECK");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmAH', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmAH', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("GIT", "BASIS_AH_CHECK"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_GIT__ROAD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "ROAD", "Checkbox");
        })();
}
function onValidate_GIT__AIR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AIR", "Checkbox");
        })();
}
function onValidate_GIT__RAIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "RAIL", "Checkbox");
        })();
}
function onValidate_GIT__DESC_GOODS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "DESC_GOODS", "Comment");
        })();
        /**
         * Set the control height
         * SetControlRelativeHeight
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
        			var height = window.parseFloat("2.0");
        			
        			
        			// See if the field implements setHeight
        			var instance = Field.getWithQuery("type=Comment&objectName=GIT&propertyName=DESC_GOODS&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_GIT__DESC_GOODS');
        			if (ele){
        				var bounds = window.getBounds(ele);
        				height = Math.round(height * bounds.height);
        				ele.style.height = height + "px";
        				// Need to update the fake input too
        				if (window.Formatting){
        					var fake = window.Formatting.getFakeInput(ele);
        					if (fake != null)
        						fake.style.height = height + "px";
        				}
        			}
        			// Check for text area also
        			var textarea = document.getElementById('ctl00_cntMainBody_GIT_DESC_GOODS_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
        		})();
        	}
        })();
}
function onValidate_GIT__AC_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_SI", "Integer");
        })();
}
function onValidate_GIT__AC_LOAD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_LOAD_LIMIT", "Currency");
        })();
}
function onValidate_GIT__AC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_RATE", "Percentage");
        })();
}
function onValidate_GIT__AC_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_PREM", "Percentage");
        })();
}
function onValidate_GIT__AC_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_POST_PREM", "Currency");
        })();
}
function onValidate_GIT__LL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_SI", "Integer");
        })();
}
function onValidate_GIT__LL_NUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_NUM", "Integer");
        })();
}
function onValidate_GIT__LL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_RATE", "Percentage");
        })();
}
function onValidate_GIT__LL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_PREM", "Percentage");
        })();
}
function onValidate_GIT__LL_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_POST_PREM", "Currency");
        })();
}
function onValidate_GIT__AH_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_SI", "Integer");
        })();
}
function onValidate_GIT__AH_LOAD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_LOAD_LIMIT", "Currency");
        })();
}
function onValidate_GIT__AH_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_RATE", "Percentage");
        })();
}
function onValidate_GIT__AH_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_PREM", "Percentage");
        })();
}
function onValidate_GIT__AH_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_POST_PREM", "Currency");
        })();
}
function onValidate_FAP__FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "FAP_PERC", "Percentage");
        })();
}
function onValidate_FAP__FAP_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "FAP_MIN_AMT", "Currency");
        })();
}
function onValidate_FAP__FAP_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "FAP_MAX_AMT", "Currency");
        })();
}
function onValidate_FAP__THEFT_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "THEFT_PERC", "Percentage");
        })();
}
function onValidate_FAP__THEFT_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "THEFT_MIN_AMT", "Currency");
        })();
}
function onValidate_FAP__THEFT_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "THEFT_MAX_AMT", "Currency");
        })();
}
function onValidate_FAP__AFAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "AFAP_PERC", "Percentage");
        })();
}
function onValidate_FAP__AFAP_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "AFAP_MIN_AMT", "Currency");
        })();
}
function onValidate_FAP__AFAP_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FAP", "AFAP_MAX_AMT", "Currency");
        })();
}
function onValidate_GIT_EXTENSIONS__IS_ACPC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_ACPC", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__ACPC_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "ACPC_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "ACPC_LIMIT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_ACPC=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_ACPC=1",
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
function onValidate_GIT_EXTENSIONS__ACPC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "ACPC_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "ACPC_RATE");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_ACPC=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_ACPC=1",
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
function onValidate_GIT_EXTENSIONS__ACPC_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "ACPC_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "ACPC_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_ACPC=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_ACPC=1",
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
function onValidate_GIT_EXTENSIONS__ACPC_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "ACPC_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "ACPC_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_ACPC=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_ACPC=1",
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
function onValidate_GIT_EXTENSIONS__IS_DEB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_DEB", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__DEB_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_LIMIT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__DEB_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_RATE");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__DEB_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__DEB_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__DEB_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_FAP", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_FAP");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__DEB_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "DEB_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "DEB_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_DEB=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_DEB=1",
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
function onValidate_GIT_EXTENSIONS__IS_FIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_FIRE", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__FIRE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_LIMIT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__FIRE_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_RATE");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__FIRE_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__FIRE_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__FIRE_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_FAP", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_FAP");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__FIRE_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "FIRE_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "FIRE_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_FIRE=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_FIRE=1",
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
function onValidate_GIT_EXTENSIONS__IS_HIJACK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_HIJACK", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__HIJACK_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "HIJACK_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_HIJACK=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_HIJACK=1",
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
function onValidate_GIT_EXTENSIONS__HIJACK_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "HIJACK_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_HIJACK=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_HIJACK=1",
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
function onValidate_GIT_EXTENSIONS__HIJACK_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "HIJACK_FAP", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_FAP");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_HIJACK=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_HIJACK=1",
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
function onValidate_GIT_EXTENSIONS__HIJACK_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "HIJACK_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_HIJACK=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_HIJACK=1",
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
function onValidate_GIT_EXTENSIONS__IS_RIOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_RIOT", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__RIOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "RIOT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "RIOT_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_RIOT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_RIOT=1",
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
function onValidate_GIT_EXTENSIONS__RIOT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "RIOT_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "RIOT_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_RIOT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_RIOT=1",
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
function onValidate_GIT_EXTENSIONS__RIOT_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "RIOT_FAP", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "RIOT_FAP");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_RIOT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_RIOT=1",
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
function onValidate_GIT_EXTENSIONS__RIOT_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "RIOT_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "RIOT_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_RIOT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_RIOT=1",
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
function onValidate_GIT_EXTENSIONS__IS_EXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_EXT", "Checkbox");
        })();
        /** 
         * ToggleContainer
         * @param frmExtDesc The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("GIT_EXTENSIONS","IS_EXT");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmExtDesc', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmExtDesc', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("GIT_EXTENSIONS", "IS_EXT"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_GIT_EXTENSIONS__EXT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "EXT_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_EXT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_EXT=1",
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
function onValidate_GIT_EXTENSIONS__EXT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "EXT_POST_PREM");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_EXT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_EXT=1",
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
function onValidate_GIT_EXTENSIONS__EXT_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_FAP", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "EXT_FAP");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_EXT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_EXT=1",
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
function onValidate_GIT_EXTENSIONS__EXT_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "EXT_MIN_AMNT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_EXT=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_EXT=1",
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
function onValidate_GIT_EXTENSIONS__IS_NASRIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_NASRIA", "Checkbox");
        })();
}
function onValidate_GIT_EXTENSIONS__NASRIA_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "NASRIA_LIMIT", "Integer");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("GIT_EXTENSIONS", "NASRIA_LIMIT");
        		}
        		//window.setProperty(field, "VE", "GIT_EXTENSIONS.IS_NASRIA=1", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "GIT_EXTENSIONS.IS_NASRIA=1",
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
function onValidate_GIT_EXTENSIONS__TOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "TOT_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "TOT_PREM");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT_EXTENSIONS__TOT_POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "TOT_POST_PREM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "TOT_POST_PREM");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT_EXTENSIONS__EXT_DESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_DESC", "Comment");
        })();
        /**
         * Set the control height
         * SetControlRelativeHeight
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
        			var height = window.parseFloat("2.0");
        			
        			
        			// See if the field implements setHeight
        			var instance = Field.getWithQuery("type=Comment&objectName=GIT_EXTENSIONS&propertyName=EXT_DESC&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_GIT_EXTENSIONS__EXT_DESC');
        			if (ele){
        				var bounds = window.getBounds(ele);
        				height = Math.round(height * bounds.height);
        				ele.style.height = height + "px";
        				// Need to update the fake input too
        				if (window.Formatting){
        					var fake = window.Formatting.getFakeInput(ele);
        					if (fake != null)
        						fake.style.height = height + "px";
        				}
        			}
        			// Check for text area also
        			var textarea = document.getElementById('ctl00_cntMainBody_GIT_EXTENSIONS_EXT_DESC_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
        		})();
        	}
        })();
}
function onValidate_REFERRAL_CLAUSES__TOT_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRAL_CLAUSES", "TOT_PREM", "Currency");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("REFERRAL_CLAUSES.TOT_PREM");
        			window.setControlWidth(field, "0.8", "REFERRAL_CLAUSES", "TOT_PREM");
        		})();
        	}
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblREFERRAL_CLAUSES_TOT_PREM");
        			    var ele = document.getElementById('ctl00_cntMainBody_REFERRAL_CLAUSES__TOT_PREM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_REFERRAL_CLAUSES__TOT_PREM_lblFindParty");
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
function onValidate_REFERRAL_CLAUSES__GITENDPREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRAL_CLAUSES", "GITENDPREM", "ChildScreen");
        })();
}
function onValidate_NOTES__GITNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NOTES", "GITNOTES", "ChildScreen");
        })();
}
function onValidate_NOTES__GITSNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "NOTES", "GITSNOTES", "ChildScreen");
        })();
}
function onValidate_GENERAL__UserLevel(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "UserLevel", "Integer");
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
        			var field = Field.getInstance("GENERAL", "UserLevel");
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
function onValidate_GENERAL__IsBroker(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "IsBroker", "Checkbox");
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
        			var field = Field.getInstance("GENERAL", "IsBroker");
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
function onValidate_GENERAL__UserGroup(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "UserGroup", "Text");
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
        			var field = Field.getInstance("GENERAL", "UserGroup");
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
function onValidate_GENERAL__LoggedInUser(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "LoggedInUser", "Text");
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
        			var field = Field.getInstance("GENERAL", "LoggedInUser");
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
function onValidate_GENERAL__LoggedInUserFullName(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "LoggedInUserFullName", "Text");
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
        			var field = Field.getInstance("GENERAL", "LoggedInUserFullName");
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
function onValidate_GENERAL__LoggedInUserEmail(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "LoggedInUserEmail", "Text");
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
        			var field = Field.getInstance("GENERAL", "LoggedInUserEmail");
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
function onValidate_GENERAL__RunDefaultRuleFlag(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "RunDefaultRuleFlag", "Integer");
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
        			var field = Field.getInstance("GENERAL", "RunDefaultRuleFlag");
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
function onValidate_GENERAL__RefCount(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "RefCount", "TempInteger");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempInteger&objectName=GENERAL&propertyName=RefCount&name={name}");
        		
        		var value = new Expression("REFERRALS.RefCount"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
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
        			var field = Field.getInstance("GENERAL", "RefCount");
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
function onValidate_GENERAL__ShowReferralsTab(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "ShowReferralsTab", "Checkbox");
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
        			var field = Field.getInstance("GENERAL", "ShowReferralsTab");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("GENERAL.ShowReferralsTab");
        		var update = function(){
        			ToggleTabBasedOn("3", field.getValue());	
        		};
        		events.listen(field, "change", update);
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=GENERAL&propertyName=ShowReferralsTab&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("GENERAL.RefCount > 0")) ? new Expression("GENERAL.RefCount > 0") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_GENERAL__FD_DEP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "FD_DEP_PER", "Percentage");
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
        			var field = Field.getInstance("GENERAL", "FD_DEP_PER");
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
function onValidate_GENERAL__FD_FRE_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "FD_FRE_PER", "Percentage");
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
        			var field = Field.getInstance("GENERAL", "FD_FRE_PER");
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
function onValidate_GENERAL__FD_SRE_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "FD_SRE_PER", "Percentage");
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
        			var field = Field.getInstance("GENERAL", "FD_SRE_PER");
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
function onValidate_GENERAL__LB_NF_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "LB_NF_LOI", "Currency");
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
        			var field = Field.getInstance("GENERAL", "LB_NF_LOI");
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
function onValidate_GENERAL__LB_TP_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "LB_TP_LOI", "Currency");
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
        			var field = Field.getInstance("GENERAL", "LB_TP_LOI");
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
function onValidate_GENERAL__EXT_WS_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EXT_WS_FAP", "Percentage");
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
        			var field = Field.getInstance("GENERAL", "EXT_WS_FAP");
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
function onValidate_GENERAL__EXT_LK_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EXT_LK_LOI", "Currency");
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
        			var field = Field.getInstance("GENERAL", "EXT_LK_LOI");
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
function onValidate_GENERAL__EXT_LK_FAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EXT_LK_FAP", "Percentage");
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
        			var field = Field.getInstance("GENERAL", "EXT_LK_FAP");
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
function onValidate_GENERAL__EXT_LK_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EXT_LK_MIN", "Currency");
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
        			var field = Field.getInstance("GENERAL", "EXT_LK_MIN");
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
function onValidate_GENERAL__EXT_WR_LOI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "EXT_WR_LOI", "Currency");
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
        			var field = Field.getInstance("GENERAL", "EXT_WR_LOI");
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
function onValidate_GENERAL__NEXUSQS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GENERAL", "NEXUSQS", "Integer");
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
        			var field = Field.getInstance("GENERAL", "NEXUSQS");
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
function onValidate_POLICYHEADER__COVERSTARTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "POLICYHEADER", "COVERSTARTDATE", "Date");
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
        			var field = Field.getInstance("POLICYHEADER", "COVERSTARTDATE");
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
function onValidate_POLICYHEADER__POLICYNUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "POLICYHEADER", "POLICYNUMBER", "Text");
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
        			var field = Field.getInstance("POLICYHEADER", "POLICYNUMBER");
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
function DoLogic(isOnLoad) {
    onValidate_GENERAL__RISKATTACHDATE(null, null, null, isOnLoad);
    onValidate_GENERAL__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_GENERAL__IS_VAT(null, null, null, isOnLoad);
    onValidate_GENERAL__FLAT_PREM(null, null, null, isOnLoad);
    onValidate_GENERAL__TOTAL_PREM(null, null, null, isOnLoad);
    onValidate_ADDRESS__ADDRESSLIST(null, null, null, isOnLoad);
    onValidate_ADDRESS__SITEADDRESSLIST(null, null, null, isOnLoad);
    onValidate_ADDRESS__HOMEADDRESSLIST(null, null, null, isOnLoad);
    onValidate_ADDRESS__B_ADDRESSLIST(null, null, null, isOnLoad);
    onValidate_ADDRESS__LINE1(null, null, null, isOnLoad);
    onValidate_ADDRESS__SUBURB(null, null, null, isOnLoad);
    onValidate_ADDRESS__TOWN(null, null, null, isOnLoad);
    onValidate_ADDRESS__POSTCODE(null, null, null, isOnLoad);
    onValidate_ADDRESS__REGION(null, null, null, isOnLoad);
    onValidate_ADDRESS__COUNTRY(null, null, null, isOnLoad);
    onValidate_ADDRESS__AREACODE(null, null, null, isOnLoad);
    onValidate_GENERAL__PRIMARY_INDUSTRY(null, null, null, isOnLoad);
    onValidate_GENERAL__SECOND_INDUSTRY(null, null, null, isOnLoad);
    onValidate_GENERAL__TERTIARY_INDUSTRY(null, null, null, isOnLoad);
    onValidate_GENERAL__INDUSTRY(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__MS25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_GIT__BASIS_OF_COVER(null, null, null, isOnLoad);
    onValidate_GIT__BASIS_OF_RATING(null, null, null, isOnLoad);
    onValidate_GIT__BASIS_AC_CHECK(null, null, null, isOnLoad);
    onValidate_GIT__BASIS_LL_CHECK(null, null, null, isOnLoad);
    onValidate_GIT__BASIS_AH_CHECK(null, null, null, isOnLoad);
    onValidate_GIT__ROAD(null, null, null, isOnLoad);
    onValidate_GIT__AIR(null, null, null, isOnLoad);
    onValidate_GIT__RAIL(null, null, null, isOnLoad);
    onValidate_GIT__DESC_GOODS(null, null, null, isOnLoad);
    onValidate_GIT__AC_SI(null, null, null, isOnLoad);
    onValidate_GIT__AC_LOAD_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT__AC_RATE(null, null, null, isOnLoad);
    onValidate_GIT__AC_PREM(null, null, null, isOnLoad);
    onValidate_GIT__AC_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT__LL_SI(null, null, null, isOnLoad);
    onValidate_GIT__LL_NUM(null, null, null, isOnLoad);
    onValidate_GIT__LL_RATE(null, null, null, isOnLoad);
    onValidate_GIT__LL_PREM(null, null, null, isOnLoad);
    onValidate_GIT__LL_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT__AH_SI(null, null, null, isOnLoad);
    onValidate_GIT__AH_LOAD_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT__AH_RATE(null, null, null, isOnLoad);
    onValidate_GIT__AH_PREM(null, null, null, isOnLoad);
    onValidate_GIT__AH_POST_PREM(null, null, null, isOnLoad);
    onValidate_FAP__FAP_PERC(null, null, null, isOnLoad);
    onValidate_FAP__FAP_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FAP__FAP_MAX_AMT(null, null, null, isOnLoad);
    onValidate_FAP__THEFT_PERC(null, null, null, isOnLoad);
    onValidate_FAP__THEFT_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FAP__THEFT_MAX_AMT(null, null, null, isOnLoad);
    onValidate_FAP__AFAP_PERC(null, null, null, isOnLoad);
    onValidate_FAP__AFAP_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FAP__AFAP_MAX_AMT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_ACPC(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__ACPC_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__ACPC_RATE(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__ACPC_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__ACPC_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_DEB(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_RATE(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_FIRE(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_RATE(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_HIJACK(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_RIOT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_EXT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_NASRIA(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__NASRIA_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__TOT_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__TOT_POST_PREM(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_DESC(null, null, null, isOnLoad);
    onValidate_REFERRAL_CLAUSES__TOT_PREM(null, null, null, isOnLoad);
    onValidate_REFERRAL_CLAUSES__GITENDPREM(null, null, null, isOnLoad);
    onValidate_NOTES__GITNOTES(null, null, null, isOnLoad);
    onValidate_NOTES__GITSNOTES(null, null, null, isOnLoad);
    onValidate_GENERAL__UserLevel(null, null, null, isOnLoad);
    onValidate_GENERAL__IsBroker(null, null, null, isOnLoad);
    onValidate_GENERAL__UserGroup(null, null, null, isOnLoad);
    onValidate_GENERAL__LoggedInUser(null, null, null, isOnLoad);
    onValidate_GENERAL__LoggedInUserFullName(null, null, null, isOnLoad);
    onValidate_GENERAL__LoggedInUserEmail(null, null, null, isOnLoad);
    onValidate_GENERAL__RunDefaultRuleFlag(null, null, null, isOnLoad);
    onValidate_GENERAL__RefCount(null, null, null, isOnLoad);
    onValidate_GENERAL__ShowReferralsTab(null, null, null, isOnLoad);
    onValidate_GENERAL__FD_DEP_PER(null, null, null, isOnLoad);
    onValidate_GENERAL__FD_FRE_PER(null, null, null, isOnLoad);
    onValidate_GENERAL__FD_SRE_PER(null, null, null, isOnLoad);
    onValidate_GENERAL__LB_NF_LOI(null, null, null, isOnLoad);
    onValidate_GENERAL__LB_TP_LOI(null, null, null, isOnLoad);
    onValidate_GENERAL__EXT_WS_FAP(null, null, null, isOnLoad);
    onValidate_GENERAL__EXT_LK_LOI(null, null, null, isOnLoad);
    onValidate_GENERAL__EXT_LK_FAP(null, null, null, isOnLoad);
    onValidate_GENERAL__EXT_LK_MIN(null, null, null, isOnLoad);
    onValidate_GENERAL__EXT_WR_LOI(null, null, null, isOnLoad);
    onValidate_GENERAL__NEXUSQS(null, null, null, isOnLoad);
    onValidate_POLICYHEADER__COVERSTARTDATE(null, null, null, isOnLoad);
    onValidate_POLICYHEADER__POLICYNUMBER(null, null, null, isOnLoad);
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
<div id="iddcbeda054dcd468d88abceb6502093a3" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id17b3f9108b9a4252aafbc8e3f42bfbf9" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading7" runat="server" Text="Effective Date" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="GENERAL" 
		data-property-name="RISKATTACHDATE" 
		id="pb-container-datejquerycompatible-GENERAL-RISKATTACHDATE">
		<asp:Label ID="lblGENERAL_RISKATTACHDATE" runat="server" AssociatedControlID="GENERAL__RISKATTACHDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="GENERAL__RISKATTACHDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calGENERAL__RISKATTACHDATE" runat="server" LinkedControl="GENERAL__RISKATTACHDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valGENERAL_RISKATTACHDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_GENERAL__RISKATTACHDATE" 
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
		data-object-name="GENERAL" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-GENERAL-EFFECTIVEDATE">
		<asp:Label ID="lblGENERAL_EFFECTIVEDATE" runat="server" AssociatedControlID="GENERAL__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="GENERAL__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calGENERAL__EFFECTIVEDATE" runat="server" LinkedControl="GENERAL__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valGENERAL_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_GENERAL__EFFECTIVEDATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GENERAL" 
		data-property-name="IS_VAT" 
		id="pb-container-list-GENERAL-IS_VAT">
		<asp:Label ID="lblGENERAL_IS_VAT" runat="server" AssociatedControlID="GENERAL__IS_VAT" 
			Text="VAT" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GENERAL__IS_VAT" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_VAT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GENERAL__IS_VAT(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGENERAL_IS_VAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for VAT"
			ClientValidationFunction="onValidate_GENERAL__IS_VAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGENERAL_FLAT_PREM" for="ctl00_cntMainBody_GENERAL__FLAT_PREM" class="col-md-4 col-sm-3 control-label">
		Flat Premium</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GENERAL" 
		data-property-name="FLAT_PREM" 
		id="pb-container-checkbox-GENERAL-FLAT_PREM">	
		
		<asp:TextBox ID="GENERAL__FLAT_PREM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGENERAL_FLAT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Flat Premium"
			ClientValidationFunction="onValidate_GENERAL__FLAT_PREM" 
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
		data-object-name="GENERAL" 
		data-property-name="TOTAL_PREM" 
		id="pb-container-currency-GENERAL-TOTAL_PREM">
		<asp:Label ID="lblGENERAL_TOTAL_PREM" runat="server" AssociatedControlID="GENERAL__TOTAL_PREM" 
			Text="Total Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__TOTAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_TOTAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Premium"
			ClientValidationFunction="onValidate_GENERAL__TOTAL_PREM" 
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
		if ($("#id17b3f9108b9a4252aafbc8e3f42bfbf9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id17b3f9108b9a4252aafbc8e3f42bfbf9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id17b3f9108b9a4252aafbc8e3f42bfbf9 div ul li").each(function(){		  
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
			$("#id17b3f9108b9a4252aafbc8e3f42bfbf9 div ul li").each(function(){		  
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
		styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id17b3f9108b9a4252aafbc8e3f42bfbf9 input{text-align:left;}"; break;
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
<div id="id4c62574d5b7b4aa980c634d90c0e4b74" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading8" runat="server" Text="Address" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="ADDRESS" 
		data-property-name="ADDRESSLIST" 
		id="pb-container-list-ADDRESS-ADDRESSLIST">
		<asp:Label ID="lblADDRESS_ADDRESSLIST" runat="server" AssociatedControlID="ADDRESS__ADDRESSLIST" 
			Text="Address Type" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="ADDRESS__ADDRESSLIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_ADDRESSLIST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_ADDRESS__ADDRESSLIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valADDRESS_ADDRESSLIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Address Type"
			ClientValidationFunction="onValidate_ADDRESS__ADDRESSLIST" 
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
		data-object-name="ADDRESS" 
		data-property-name="SITEADDRESSLIST" 
		id="pb-container-list-ADDRESS-SITEADDRESSLIST">
		<asp:Label ID="lblADDRESS_SITEADDRESSLIST" runat="server" AssociatedControlID="ADDRESS__SITEADDRESSLIST" 
			Text="Site Address" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="ADDRESS__SITEADDRESSLIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_SITEADDRLIST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_ADDRESS__SITEADDRESSLIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valADDRESS_SITEADDRESSLIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Site Address"
			ClientValidationFunction="onValidate_ADDRESS__SITEADDRESSLIST" 
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
		data-object-name="ADDRESS" 
		data-property-name="HOMEADDRESSLIST" 
		id="pb-container-list-ADDRESS-HOMEADDRESSLIST">
		<asp:Label ID="lblADDRESS_HOMEADDRESSLIST" runat="server" AssociatedControlID="ADDRESS__HOMEADDRESSLIST" 
			Text="Home Address" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="ADDRESS__HOMEADDRESSLIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_HOMEADDRLIST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_ADDRESS__HOMEADDRESSLIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valADDRESS_HOMEADDRESSLIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Home Address"
			ClientValidationFunction="onValidate_ADDRESS__HOMEADDRESSLIST" 
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
		data-object-name="ADDRESS" 
		data-property-name="B_ADDRESSLIST" 
		id="pb-container-list-ADDRESS-B_ADDRESSLIST">
		<asp:Label ID="lblADDRESS_B_ADDRESSLIST" runat="server" AssociatedControlID="ADDRESS__B_ADDRESSLIST" 
			Text="Business Address" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="ADDRESS__B_ADDRESSLIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_BUSIADDRLIST" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_ADDRESS__B_ADDRESSLIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valADDRESS_B_ADDRESSLIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Business Address"
			ClientValidationFunction="onValidate_ADDRESS__B_ADDRESSLIST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="ADDRESS" 
		data-property-name="LINE1" 
		 
		
		 
		id="pb-container-text-ADDRESS-LINE1">

		
		<asp:Label ID="lblADDRESS_LINE1" runat="server" AssociatedControlID="ADDRESS__LINE1" 
			Text="No. & Street name" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__LINE1" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_LINE1" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for No. & Street name"
					ClientValidationFunction="onValidate_ADDRESS__LINE1"
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
		
		data-object-name="ADDRESS" 
		data-property-name="SUBURB" 
		 
		
		 
		id="pb-container-text-ADDRESS-SUBURB">

		
		<asp:Label ID="lblADDRESS_SUBURB" runat="server" AssociatedControlID="ADDRESS__SUBURB" 
			Text="Suburb" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__SUBURB" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_SUBURB" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Suburb"
					ClientValidationFunction="onValidate_ADDRESS__SUBURB"
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
		
		data-object-name="ADDRESS" 
		data-property-name="TOWN" 
		 
		
		 
		id="pb-container-text-ADDRESS-TOWN">

		
		<asp:Label ID="lblADDRESS_TOWN" runat="server" AssociatedControlID="ADDRESS__TOWN" 
			Text="Town" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__TOWN" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_TOWN" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Town"
					ClientValidationFunction="onValidate_ADDRESS__TOWN"
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
		
		data-object-name="ADDRESS" 
		data-property-name="POSTCODE" 
		 
		
		 
		id="pb-container-text-ADDRESS-POSTCODE">

		
		<asp:Label ID="lblADDRESS_POSTCODE" runat="server" AssociatedControlID="ADDRESS__POSTCODE" 
			Text="Post Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__POSTCODE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_POSTCODE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Post Code"
					ClientValidationFunction="onValidate_ADDRESS__POSTCODE"
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
		
		data-object-name="ADDRESS" 
		data-property-name="REGION" 
		 
		
		 
		id="pb-container-text-ADDRESS-REGION">

		
		<asp:Label ID="lblADDRESS_REGION" runat="server" AssociatedControlID="ADDRESS__REGION" 
			Text="Region" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__REGION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_REGION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Region"
					ClientValidationFunction="onValidate_ADDRESS__REGION"
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
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="ADDRESS" 
		data-property-name="COUNTRY" 
		id="pb-container-list-ADDRESS-COUNTRY">
		<asp:Label ID="lblADDRESS_COUNTRY" runat="server" AssociatedControlID="ADDRESS__COUNTRY" 
			Text="Country" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="ADDRESS__COUNTRY" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="Country" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_ADDRESS__COUNTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valADDRESS_COUNTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Country"
			ClientValidationFunction="onValidate_ADDRESS__COUNTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="ADDRESS" 
		data-property-name="AREACODE" 
		 
		
		 
		id="pb-container-text-ADDRESS-AREACODE">

		
		<asp:Label ID="lblADDRESS_AREACODE" runat="server" AssociatedControlID="ADDRESS__AREACODE" 
			Text="Area Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="ADDRESS__AREACODE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valADDRESS_AREACODE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Area Code"
					ClientValidationFunction="onValidate_ADDRESS__AREACODE"
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
								
								
										<!-- asyncpostbackpanel -->
	<asp:UpdatePanel ID="asyncPanel" runat="server" UpdateMode="Conditional" >
		<ContentTemplate>
			<asp:Label ID="hidLabel" runat="server"/>
		</ContentTemplate>
	</asp:UpdatePanel>
<!-- /asyncpostbackpanel -->
								
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
		if ($("#id4c62574d5b7b4aa980c634d90c0e4b74 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4c62574d5b7b4aa980c634d90c0e4b74 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4c62574d5b7b4aa980c634d90c0e4b74 div ul li").each(function(){		  
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
			$("#id4c62574d5b7b4aa980c634d90c0e4b74 div ul li").each(function(){		  
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
		styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c62574d5b7b4aa980c634d90c0e4b74 input{text-align:left;}"; break;
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
<div id="idff11284ab068486db8ca6cc277f9ae18" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading9" runat="server" Text="Industry" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GENERAL" 
		data-property-name="PRIMARY_INDUSTRY" 
		id="pb-container-list-GENERAL-PRIMARY_INDUSTRY">
		<asp:Label ID="lblGENERAL_PRIMARY_INDUSTRY" runat="server" AssociatedControlID="GENERAL__PRIMARY_INDUSTRY" 
			Text="Primary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GENERAL__PRIMARY_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDONE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GENERAL__PRIMARY_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGENERAL_PRIMARY_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Primary Industry"
			ClientValidationFunction="onValidate_GENERAL__PRIMARY_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label0">
		<span class="label" id="label0"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GENERAL" 
		data-property-name="SECOND_INDUSTRY" 
		id="pb-container-list-GENERAL-SECOND_INDUSTRY">
		<asp:Label ID="lblGENERAL_SECOND_INDUSTRY" runat="server" AssociatedControlID="GENERAL__SECOND_INDUSTRY" 
			Text="Secondary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GENERAL__SECOND_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDTWO" ParentLookupListID="GENERAL__PRIMARY_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GENERAL__SECOND_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGENERAL_SECOND_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Secondary Industry"
			ClientValidationFunction="onValidate_GENERAL__SECOND_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label1">
		<span class="label" id="label1"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GENERAL" 
		data-property-name="TERTIARY_INDUSTRY" 
		id="pb-container-list-GENERAL-TERTIARY_INDUSTRY">
		<asp:Label ID="lblGENERAL_TERTIARY_INDUSTRY" runat="server" AssociatedControlID="GENERAL__TERTIARY_INDUSTRY" 
			Text="Tertiary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GENERAL__TERTIARY_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDTHR" ParentLookupListID="GENERAL__SECOND_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GENERAL__TERTIARY_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGENERAL_TERTIARY_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tertiary Industry"
			ClientValidationFunction="onValidate_GENERAL__TERTIARY_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label2">
		<span class="label" id="label2"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GENERAL" 
		data-property-name="INDUSTRY" 
		id="pb-container-list-GENERAL-INDUSTRY">
		<asp:Label ID="lblGENERAL_INDUSTRY" runat="server" AssociatedControlID="GENERAL__INDUSTRY" 
			Text="Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GENERAL__INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDUST" ParentLookupListID="GENERAL__TERTIARY_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GENERAL__INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGENERAL_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Industry"
			ClientValidationFunction="onValidate_GENERAL__INDUSTRY" 
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
		if ($("#idff11284ab068486db8ca6cc277f9ae18 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idff11284ab068486db8ca6cc277f9ae18 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idff11284ab068486db8ca6cc277f9ae18 div ul li").each(function(){		  
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
			$("#idff11284ab068486db8ca6cc277f9ae18 div ul li").each(function(){		  
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
		styleString += "#idff11284ab068486db8ca6cc277f9ae18 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idff11284ab068486db8ca6cc277f9ae18 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idff11284ab068486db8ca6cc277f9ae18 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idff11284ab068486db8ca6cc277f9ae18 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idff11284ab068486db8ca6cc277f9ae18 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idff11284ab068486db8ca6cc277f9ae18 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idff11284ab068486db8ca6cc277f9ae18 input{text-align:left;}"; break;
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
<div id="frmClaims History" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading10" runat="server" Text="Past Claims History" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="10:15:15:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label3">
		<span class="label" id="label3"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label4">
		<span class="label" id="label4">0-12 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label5">
		<span class="label" id="label5">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label6">
		<span class="label" id="label6">13-24 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label7">
		<span class="label" id="label7">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label8">
		<span class="label" id="label8">25-36 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label9">
		<span class="label" id="label9">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label10">
		<span class="label" id="label10">Goods in Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-MS0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_MS0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__MS0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__MS0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__MS0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_MS0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS0_12_MONTHS" 
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
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-MS0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_MS0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__MS0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__MS0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_MS0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS0_12_AMOUNT" 
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
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-MS13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_MS13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__MS13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__MS13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__MS13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_MS13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS13_24_MONTHS" 
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
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-MS13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_MS13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__MS13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__MS13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_MS13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS13_24_AMOUNT" 
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
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-MS25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_MS25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__MS25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__MS25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__MS25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_MS25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS25_36_MONTHS" 
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
		data-object-name="CLAIM_HISTORY" 
		data-property-name="MS25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-MS25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_MS25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__MS25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__MS25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_MS25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.MS25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__MS25_36_AMOUNT" 
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
		if ($("#frmClaims History div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmClaims History div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmClaims History div ul li").each(function(){		  
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
			$("#frmClaims History div ul li").each(function(){		  
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
		styleString += "#frmClaims History label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmClaims History label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmClaims History label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmClaims History label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmClaims History input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmClaims History input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmClaims History input{text-align:left;}"; break;
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
<div id="id8b0353d467794ba0a97b26083c6ed7db" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading11" runat="server" Text="Rating Method" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="BASIS_OF_COVER" 
		 
		
		 
		id="pb-container-text-GIT-BASIS_OF_COVER">

		
		<asp:Label ID="lblGIT_BASIS_OF_COVER" runat="server" AssociatedControlID="GIT__BASIS_OF_COVER" 
			Text="Basis of Cover" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="GIT__BASIS_OF_COVER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valGIT_BASIS_OF_COVER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Basis of Cover"
					ClientValidationFunction="onValidate_GIT__BASIS_OF_COVER"
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
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GIT" 
		data-property-name="BASIS_OF_RATING" 
		id="pb-container-list-GIT-BASIS_OF_RATING">
		<asp:Label ID="lblGIT_BASIS_OF_RATING" runat="server" AssociatedControlID="GIT__BASIS_OF_RATING" 
			Text="Basis of Rating" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GIT__BASIS_OF_RATING" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_GIT_BASISRATING" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GIT__BASIS_OF_RATING(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGIT_BASIS_OF_RATING" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Basis of Rating"
			ClientValidationFunction="onValidate_GIT__BASIS_OF_RATING" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_BASIS_AC_CHECK" for="ctl00_cntMainBody_GIT__BASIS_AC_CHECK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="BASIS_AC_CHECK" 
		id="pb-container-checkbox-GIT-BASIS_AC_CHECK">	
		
		<asp:TextBox ID="GIT__BASIS_AC_CHECK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_BASIS_AC_CHECK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.BASIS_AC_CHECK"
			ClientValidationFunction="onValidate_GIT__BASIS_AC_CHECK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_BASIS_LL_CHECK" for="ctl00_cntMainBody_GIT__BASIS_LL_CHECK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="BASIS_LL_CHECK" 
		id="pb-container-checkbox-GIT-BASIS_LL_CHECK">	
		
		<asp:TextBox ID="GIT__BASIS_LL_CHECK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_BASIS_LL_CHECK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.BASIS_LL_CHECK"
			ClientValidationFunction="onValidate_GIT__BASIS_LL_CHECK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_BASIS_AH_CHECK" for="ctl00_cntMainBody_GIT__BASIS_AH_CHECK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="BASIS_AH_CHECK" 
		id="pb-container-checkbox-GIT-BASIS_AH_CHECK">	
		
		<asp:TextBox ID="GIT__BASIS_AH_CHECK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_BASIS_AH_CHECK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.BASIS_AH_CHECK"
			ClientValidationFunction="onValidate_GIT__BASIS_AH_CHECK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
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
		if ($("#id8b0353d467794ba0a97b26083c6ed7db div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id8b0353d467794ba0a97b26083c6ed7db div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id8b0353d467794ba0a97b26083c6ed7db div ul li").each(function(){		  
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
			$("#id8b0353d467794ba0a97b26083c6ed7db div ul li").each(function(){		  
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
		styleString += "#id8b0353d467794ba0a97b26083c6ed7db label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id8b0353d467794ba0a97b26083c6ed7db label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8b0353d467794ba0a97b26083c6ed7db label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8b0353d467794ba0a97b26083c6ed7db label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id8b0353d467794ba0a97b26083c6ed7db input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8b0353d467794ba0a97b26083c6ed7db input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8b0353d467794ba0a97b26083c6ed7db input{text-align:left;}"; break;
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
<div id="idc52e2ef2ee194b1caabf89af8d74e7d0" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading12" runat="server" Text="Means of Conveyance" /></legend>
				
				
				<div data-column-count="3" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_ROAD" for="ctl00_cntMainBody_GIT__ROAD" class="col-md-4 col-sm-3 control-label">
		Road</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="ROAD" 
		id="pb-container-checkbox-GIT-ROAD">	
		
		<asp:TextBox ID="GIT__ROAD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_ROAD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Road"
			ClientValidationFunction="onValidate_GIT__ROAD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_AIR" for="ctl00_cntMainBody_GIT__AIR" class="col-md-4 col-sm-3 control-label">
		Air</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="AIR" 
		id="pb-container-checkbox-GIT-AIR">	
		
		<asp:TextBox ID="GIT__AIR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_AIR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Air"
			ClientValidationFunction="onValidate_GIT__AIR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_RAIL" for="ctl00_cntMainBody_GIT__RAIL" class="col-md-4 col-sm-3 control-label">
		Rail</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT" 
		data-property-name="RAIL" 
		id="pb-container-checkbox-GIT-RAIL">	
		
		<asp:TextBox ID="GIT__RAIL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_RAIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Rail"
			ClientValidationFunction="onValidate_GIT__RAIL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
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
		if ($("#idc52e2ef2ee194b1caabf89af8d74e7d0 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idc52e2ef2ee194b1caabf89af8d74e7d0 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idc52e2ef2ee194b1caabf89af8d74e7d0 div ul li").each(function(){		  
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
			$("#idc52e2ef2ee194b1caabf89af8d74e7d0 div ul li").each(function(){		  
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
		styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc52e2ef2ee194b1caabf89af8d74e7d0 input{text-align:left;}"; break;
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
<div id="id422949bb9759456e882039e5cd2151c2" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading13" runat="server" Text="Description of Goods Carried" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="GIT" 
		data-property-name="DESC_GOODS" 
		id="pb-container-comment-GIT-DESC_GOODS">
		<asp:Label ID="lblGIT_DESC_GOODS" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="GIT__DESC_GOODS" 
			Text=""></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="GIT__DESC_GOODS" runat="server" />
		
		<asp:CustomValidator ID="valGIT_DESC_GOODS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.DESC_GOODS"
			ClientValidationFunction="onValidate_GIT__DESC_GOODS"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
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
		if ($("#id422949bb9759456e882039e5cd2151c2 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id422949bb9759456e882039e5cd2151c2 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id422949bb9759456e882039e5cd2151c2 div ul li").each(function(){		  
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
			$("#id422949bb9759456e882039e5cd2151c2 div ul li").each(function(){		  
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
		styleString += "#id422949bb9759456e882039e5cd2151c2 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id422949bb9759456e882039e5cd2151c2 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id422949bb9759456e882039e5cd2151c2 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id422949bb9759456e882039e5cd2151c2 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id422949bb9759456e882039e5cd2151c2 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id422949bb9759456e882039e5cd2151c2 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id422949bb9759456e882039e5cd2151c2 input{text-align:left;}"; break;
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
<div id="frmAC" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading14" runat="server" Text="Goods in Transit - Annual Carry" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="20:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label11">
		<span class="label" id="label11">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label12">
		<span class="label" id="label12">Load Limit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label13">
		<span class="label" id="label13">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label14">
		<span class="label" id="label14">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label15">
		<span class="label" id="label15">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GIT" 
		data-property-name="AC_SI" 
		id="pb-container-integer-GIT-AC_SI">
		<asp:Label ID="lblGIT_AC_SI" runat="server" AssociatedControlID="GIT__AC_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GIT__AC_SI" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGIT_AC_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_SI"
			ClientValidationFunction="onValidate_GIT__AC_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="AC_LOAD_LIMIT" 
		id="pb-container-currency-GIT-AC_LOAD_LIMIT">
		<asp:Label ID="lblGIT_AC_LOAD_LIMIT" runat="server" AssociatedControlID="GIT__AC_LOAD_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AC_LOAD_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AC_LOAD_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_LOAD_LIMIT"
			ClientValidationFunction="onValidate_GIT__AC_LOAD_LIMIT" 
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
		data-object-name="GIT" 
		data-property-name="AC_RATE" 
		id="pb-container-percentage-GIT-AC_RATE">
		<asp:Label ID="lblGIT_AC_RATE" runat="server" AssociatedControlID="GIT__AC_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__AC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_AC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_RATE"
			ClientValidationFunction="onValidate_GIT__AC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT" 
		data-property-name="AC_PREM" 
		id="pb-container-percentage-GIT-AC_PREM">
		<asp:Label ID="lblGIT_AC_PREM" runat="server" AssociatedControlID="GIT__AC_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__AC_PREM" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_AC_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_PREM"
			ClientValidationFunction="onValidate_GIT__AC_PREM" 
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
		data-object-name="GIT" 
		data-property-name="AC_POST_PREM" 
		id="pb-container-currency-GIT-AC_POST_PREM">
		<asp:Label ID="lblGIT_AC_POST_PREM" runat="server" AssociatedControlID="GIT__AC_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AC_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AC_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_POST_PREM"
			ClientValidationFunction="onValidate_GIT__AC_POST_PREM" 
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
		if ($("#frmAC div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmAC div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmAC div ul li").each(function(){		  
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
			$("#frmAC div ul li").each(function(){		  
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
		styleString += "#frmAC label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmAC label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAC label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAC label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmAC input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAC input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAC input{text-align:left;}"; break;
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
<div id="frmLL" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading15" runat="server" Text="Goods in Transit - Load Limit" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="20:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label16">
		<span class="label" id="label16">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label17">
		<span class="label" id="label17">Number of Vehicles</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label18">
		<span class="label" id="label18">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label19">
		<span class="label" id="label19">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label20">
		<span class="label" id="label20">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GIT" 
		data-property-name="LL_SI" 
		id="pb-container-integer-GIT-LL_SI">
		<asp:Label ID="lblGIT_LL_SI" runat="server" AssociatedControlID="GIT__LL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GIT__LL_SI" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGIT_LL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_SI"
			ClientValidationFunction="onValidate_GIT__LL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GIT" 
		data-property-name="LL_NUM" 
		id="pb-container-integer-GIT-LL_NUM">
		<asp:Label ID="lblGIT_LL_NUM" runat="server" AssociatedControlID="GIT__LL_NUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GIT__LL_NUM" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGIT_LL_NUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_NUM"
			ClientValidationFunction="onValidate_GIT__LL_NUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT" 
		data-property-name="LL_RATE" 
		id="pb-container-percentage-GIT-LL_RATE">
		<asp:Label ID="lblGIT_LL_RATE" runat="server" AssociatedControlID="GIT__LL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__LL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_LL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_RATE"
			ClientValidationFunction="onValidate_GIT__LL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT" 
		data-property-name="LL_PREM" 
		id="pb-container-percentage-GIT-LL_PREM">
		<asp:Label ID="lblGIT_LL_PREM" runat="server" AssociatedControlID="GIT__LL_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__LL_PREM" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_LL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_PREM"
			ClientValidationFunction="onValidate_GIT__LL_PREM" 
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
		data-object-name="GIT" 
		data-property-name="LL_POST_PREM" 
		id="pb-container-currency-GIT-LL_POST_PREM">
		<asp:Label ID="lblGIT_LL_POST_PREM" runat="server" AssociatedControlID="GIT__LL_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__LL_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_LL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_POST_PREM"
			ClientValidationFunction="onValidate_GIT__LL_POST_PREM" 
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
		if ($("#frmLL div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmLL div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmLL div ul li").each(function(){		  
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
			$("#frmLL div ul li").each(function(){		  
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
		styleString += "#frmLL label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmLL label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmLL label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmLL label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmLL input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmLL input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmLL input{text-align:left;}"; break;
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
<div id="frmAH" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading16" runat="server" Text="Goods in Transit - Annual Haulage Fee" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="20:20:20:20:20" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label21">
		<span class="label" id="label21">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label22">
		<span class="label" id="label22">Load Limit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label23">
		<span class="label" id="label23">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label24">
		<span class="label" id="label24">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label25">
		<span class="label" id="label25">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GIT" 
		data-property-name="AH_SI" 
		id="pb-container-integer-GIT-AH_SI">
		<asp:Label ID="lblGIT_AH_SI" runat="server" AssociatedControlID="GIT__AH_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GIT__AH_SI" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGIT_AH_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_SI"
			ClientValidationFunction="onValidate_GIT__AH_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="AH_LOAD_LIMIT" 
		id="pb-container-currency-GIT-AH_LOAD_LIMIT">
		<asp:Label ID="lblGIT_AH_LOAD_LIMIT" runat="server" AssociatedControlID="GIT__AH_LOAD_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AH_LOAD_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AH_LOAD_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_LOAD_LIMIT"
			ClientValidationFunction="onValidate_GIT__AH_LOAD_LIMIT" 
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
		data-object-name="GIT" 
		data-property-name="AH_RATE" 
		id="pb-container-percentage-GIT-AH_RATE">
		<asp:Label ID="lblGIT_AH_RATE" runat="server" AssociatedControlID="GIT__AH_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__AH_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_AH_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_RATE"
			ClientValidationFunction="onValidate_GIT__AH_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT" 
		data-property-name="AH_PREM" 
		id="pb-container-percentage-GIT-AH_PREM">
		<asp:Label ID="lblGIT_AH_PREM" runat="server" AssociatedControlID="GIT__AH_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT__AH_PREM" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_AH_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_PREM"
			ClientValidationFunction="onValidate_GIT__AH_PREM" 
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
		data-object-name="GIT" 
		data-property-name="AH_POST_PREM" 
		id="pb-container-currency-GIT-AH_POST_PREM">
		<asp:Label ID="lblGIT_AH_POST_PREM" runat="server" AssociatedControlID="GIT__AH_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AH_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AH_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_POST_PREM"
			ClientValidationFunction="onValidate_GIT__AH_POST_PREM" 
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
		if ($("#frmAH div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmAH div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmAH div ul li").each(function(){		  
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
			$("#frmAH div ul li").each(function(){		  
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
		styleString += "#frmAH label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmAH label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAH label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAH label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmAH input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAH input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAH input{text-align:left;}"; break;
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
<div id="idb8e65b9f841d4f82a193ebf9cde76ab3" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading17" runat="server" Text="First Amount Payable" /></legend>
				
				
				<div data-column-count="4" data-column-ratio="13:29:29:29" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label26">
		<span class="label" id="label26"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label27">
		<span class="label" id="label27">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label28">
		<span class="label" id="label28">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label29">
		<span class="label" id="label29">Max Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label30">
		<span class="label" id="label30">Basic</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FAP" 
		data-property-name="FAP_PERC" 
		id="pb-container-percentage-FAP-FAP_PERC">
		<asp:Label ID="lblFAP_FAP_PERC" runat="server" AssociatedControlID="FAP__FAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FAP__FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFAP_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.FAP_PERC"
			ClientValidationFunction="onValidate_FAP__FAP_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="FAP_MIN_AMT" 
		id="pb-container-currency-FAP-FAP_MIN_AMT">
		<asp:Label ID="lblFAP_FAP_MIN_AMT" runat="server" AssociatedControlID="FAP__FAP_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__FAP_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_FAP_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.FAP_MIN_AMT"
			ClientValidationFunction="onValidate_FAP__FAP_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="FAP_MAX_AMT" 
		id="pb-container-currency-FAP-FAP_MAX_AMT">
		<asp:Label ID="lblFAP_FAP_MAX_AMT" runat="server" AssociatedControlID="FAP__FAP_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__FAP_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_FAP_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.FAP_MAX_AMT"
			ClientValidationFunction="onValidate_FAP__FAP_MAX_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label31">
		<span class="label" id="label31">Theft</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FAP" 
		data-property-name="THEFT_PERC" 
		id="pb-container-percentage-FAP-THEFT_PERC">
		<asp:Label ID="lblFAP_THEFT_PERC" runat="server" AssociatedControlID="FAP__THEFT_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FAP__THEFT_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFAP_THEFT_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.THEFT_PERC"
			ClientValidationFunction="onValidate_FAP__THEFT_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="THEFT_MIN_AMT" 
		id="pb-container-currency-FAP-THEFT_MIN_AMT">
		<asp:Label ID="lblFAP_THEFT_MIN_AMT" runat="server" AssociatedControlID="FAP__THEFT_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__THEFT_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_THEFT_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.THEFT_MIN_AMT"
			ClientValidationFunction="onValidate_FAP__THEFT_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="THEFT_MAX_AMT" 
		id="pb-container-currency-FAP-THEFT_MAX_AMT">
		<asp:Label ID="lblFAP_THEFT_MAX_AMT" runat="server" AssociatedControlID="FAP__THEFT_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__THEFT_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_THEFT_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.THEFT_MAX_AMT"
			ClientValidationFunction="onValidate_FAP__THEFT_MAX_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label32">
		<span class="label" id="label32">Additional First Amount Payable</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FAP" 
		data-property-name="AFAP_PERC" 
		id="pb-container-percentage-FAP-AFAP_PERC">
		<asp:Label ID="lblFAP_AFAP_PERC" runat="server" AssociatedControlID="FAP__AFAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FAP__AFAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFAP_AFAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.AFAP_PERC"
			ClientValidationFunction="onValidate_FAP__AFAP_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="AFAP_MIN_AMT" 
		id="pb-container-currency-FAP-AFAP_MIN_AMT">
		<asp:Label ID="lblFAP_AFAP_MIN_AMT" runat="server" AssociatedControlID="FAP__AFAP_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__AFAP_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_AFAP_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.AFAP_MIN_AMT"
			ClientValidationFunction="onValidate_FAP__AFAP_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FAP" 
		data-property-name="AFAP_MAX_AMT" 
		id="pb-container-currency-FAP-AFAP_MAX_AMT">
		<asp:Label ID="lblFAP_AFAP_MAX_AMT" runat="server" AssociatedControlID="FAP__AFAP_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FAP__AFAP_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFAP_AFAP_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FAP.AFAP_MAX_AMT"
			ClientValidationFunction="onValidate_FAP__AFAP_MAX_AMT" 
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
		if ($("#idb8e65b9f841d4f82a193ebf9cde76ab3 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idb8e65b9f841d4f82a193ebf9cde76ab3 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idb8e65b9f841d4f82a193ebf9cde76ab3 div ul li").each(function(){		  
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
			$("#idb8e65b9f841d4f82a193ebf9cde76ab3 div ul li").each(function(){		  
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
		styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idb8e65b9f841d4f82a193ebf9cde76ab3 input{text-align:left;}"; break;
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
<div id="ide1201d10ca0c461981fbf710c9a494a2" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading18" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="8" data-column-ratio="5:14:14:13:14:14:13:13" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label33">
		<span class="label" id="label33"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label34">
		<span class="label" id="label34"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label35">
		<span class="label" id="label35">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label36">
		<span class="label" id="label36">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label37">
		<span class="label" id="label37">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label38">
		<span class="label" id="label38">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label39">
		<span class="label" id="label39">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label40">
		<span class="label" id="label40">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_ACPC" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_ACPC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_ACPC" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_ACPC">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_ACPC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_ACPC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_ACPC"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_ACPC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label41">
		<span class="label" id="label41">Additional Claims Preparation Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="ACPC_LIMIT" 
		id="pb-container-currency-GIT_EXTENSIONS-ACPC_LIMIT">
		<asp:Label ID="lblGIT_EXTENSIONS_ACPC_LIMIT" runat="server" AssociatedControlID="GIT_EXTENSIONS__ACPC_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__ACPC_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_ACPC_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.ACPC_LIMIT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__ACPC_LIMIT" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="ACPC_RATE" 
		id="pb-container-percentage-GIT_EXTENSIONS-ACPC_RATE">
		<asp:Label ID="lblGIT_EXTENSIONS_ACPC_RATE" runat="server" AssociatedControlID="GIT_EXTENSIONS__ACPC_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__ACPC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_ACPC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.ACPC_RATE"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__ACPC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="ACPC_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-ACPC_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_ACPC_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__ACPC_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__ACPC_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_ACPC_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.ACPC_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__ACPC_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="ACPC_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-ACPC_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_ACPC_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__ACPC_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__ACPC_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_ACPC_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.ACPC_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__ACPC_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label42">
		<span class="label" id="label42"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label43">
		<span class="label" id="label43"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_DEB" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_DEB" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_DEB" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_DEB">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_DEB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_DEB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_DEB"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_DEB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label44">
		<span class="label" id="label44">Debris Removal</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_LIMIT" 
		id="pb-container-currency-GIT_EXTENSIONS-DEB_LIMIT">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_LIMIT" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__DEB_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_LIMIT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_LIMIT" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_RATE" 
		id="pb-container-percentage-GIT_EXTENSIONS-DEB_RATE">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_RATE" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__DEB_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_RATE"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-DEB_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__DEB_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-DEB_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__DEB_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_POST_PREM" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_FAP" 
		id="pb-container-percentage-GIT_EXTENSIONS-DEB_FAP">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_FAP" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__DEB_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_FAP"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_FAP" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="DEB_MIN_AMNT" 
		id="pb-container-currency-GIT_EXTENSIONS-DEB_MIN_AMNT">
		<asp:Label ID="lblGIT_EXTENSIONS_DEB_MIN_AMNT" runat="server" AssociatedControlID="GIT_EXTENSIONS__DEB_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__DEB_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_DEB_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.DEB_MIN_AMNT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__DEB_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_FIRE" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_FIRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_FIRE" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_FIRE">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_FIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_FIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_FIRE"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_FIRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label45">
		<span class="label" id="label45">Fire Extinguishing Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_LIMIT" 
		id="pb-container-currency-GIT_EXTENSIONS-FIRE_LIMIT">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_LIMIT" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__FIRE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_LIMIT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_LIMIT" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_RATE" 
		id="pb-container-percentage-GIT_EXTENSIONS-FIRE_RATE">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_RATE" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__FIRE_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_RATE"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-FIRE_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__FIRE_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-FIRE_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__FIRE_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_POST_PREM" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_FAP" 
		id="pb-container-percentage-GIT_EXTENSIONS-FIRE_FAP">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_FAP" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__FIRE_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_FAP"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_FAP" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="FIRE_MIN_AMNT" 
		id="pb-container-currency-GIT_EXTENSIONS-FIRE_MIN_AMNT">
		<asp:Label ID="lblGIT_EXTENSIONS_FIRE_MIN_AMNT" runat="server" AssociatedControlID="GIT_EXTENSIONS__FIRE_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__FIRE_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_FIRE_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.FIRE_MIN_AMNT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__FIRE_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_HIJACK" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_HIJACK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_HIJACK" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_HIJACK">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_HIJACK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_HIJACK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_HIJACK"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_HIJACK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label46">
		<span class="label" id="label46">Hijacking of Conveying Vehicle</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label47">
		<span class="label" id="label47"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label48">
		<span class="label" id="label48"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="HIJACK_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-HIJACK_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_HIJACK_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__HIJACK_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__HIJACK_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_HIJACK_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.HIJACK_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__HIJACK_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="HIJACK_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-HIJACK_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_HIJACK_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__HIJACK_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__HIJACK_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_HIJACK_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.HIJACK_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__HIJACK_POST_PREM" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="HIJACK_FAP" 
		id="pb-container-percentage-GIT_EXTENSIONS-HIJACK_FAP">
		<asp:Label ID="lblGIT_EXTENSIONS_HIJACK_FAP" runat="server" AssociatedControlID="GIT_EXTENSIONS__HIJACK_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__HIJACK_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_HIJACK_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.HIJACK_FAP"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__HIJACK_FAP" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="HIJACK_MIN_AMNT" 
		id="pb-container-currency-GIT_EXTENSIONS-HIJACK_MIN_AMNT">
		<asp:Label ID="lblGIT_EXTENSIONS_HIJACK_MIN_AMNT" runat="server" AssociatedControlID="GIT_EXTENSIONS__HIJACK_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__HIJACK_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_HIJACK_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.HIJACK_MIN_AMNT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__HIJACK_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_RIOT" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_RIOT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_RIOT" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_RIOT">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_RIOT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_RIOT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_RIOT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_RIOT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label49">
		<span class="label" id="label49">Riot & Strike</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label50">
		<span class="label" id="label50"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label51">
		<span class="label" id="label51"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="RIOT_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-RIOT_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_RIOT_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__RIOT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__RIOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_RIOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.RIOT_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__RIOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="RIOT_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-RIOT_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_RIOT_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__RIOT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__RIOT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_RIOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.RIOT_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__RIOT_POST_PREM" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="RIOT_FAP" 
		id="pb-container-percentage-GIT_EXTENSIONS-RIOT_FAP">
		<asp:Label ID="lblGIT_EXTENSIONS_RIOT_FAP" runat="server" AssociatedControlID="GIT_EXTENSIONS__RIOT_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__RIOT_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_RIOT_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.RIOT_FAP"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__RIOT_FAP" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="RIOT_MIN_AMNT" 
		id="pb-container-currency-GIT_EXTENSIONS-RIOT_MIN_AMNT">
		<asp:Label ID="lblGIT_EXTENSIONS_RIOT_MIN_AMNT" runat="server" AssociatedControlID="GIT_EXTENSIONS__RIOT_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__RIOT_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_RIOT_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.RIOT_MIN_AMNT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__RIOT_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_EXT" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_EXT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_EXT" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_EXT">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_EXT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_EXT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_EXT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_EXT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label52">
		<span class="label" id="label52">Extended Territories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label53">
		<span class="label" id="label53"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label54">
		<span class="label" id="label54"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="EXT_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-EXT_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_EXT_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__EXT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__EXT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_EXT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.EXT_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__EXT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="EXT_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-EXT_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_EXT_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__EXT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__EXT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_EXT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.EXT_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__EXT_POST_PREM" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="EXT_FAP" 
		id="pb-container-percentage-GIT_EXTENSIONS-EXT_FAP">
		<asp:Label ID="lblGIT_EXTENSIONS_EXT_FAP" runat="server" AssociatedControlID="GIT_EXTENSIONS__EXT_FAP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_EXTENSIONS__EXT_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_EXT_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.EXT_FAP"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__EXT_FAP" 
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
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="EXT_MIN_AMNT" 
		id="pb-container-currency-GIT_EXTENSIONS-EXT_MIN_AMNT">
		<asp:Label ID="lblGIT_EXTENSIONS_EXT_MIN_AMNT" runat="server" AssociatedControlID="GIT_EXTENSIONS__EXT_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__EXT_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_EXT_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.EXT_MIN_AMNT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__EXT_MIN_AMNT" 
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
<label id="ctl00_cntMainBody_lblGIT_EXTENSIONS_IS_NASRIA" for="ctl00_cntMainBody_GIT_EXTENSIONS__IS_NASRIA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="IS_NASRIA" 
		id="pb-container-checkbox-GIT_EXTENSIONS-IS_NASRIA">	
		
		<asp:TextBox ID="GIT_EXTENSIONS__IS_NASRIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_EXTENSIONS_IS_NASRIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.IS_NASRIA"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__IS_NASRIA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label55">
		<span class="label" id="label55">NASRIA - Goods in Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="NASRIA_LIMIT" 
		id="pb-container-integer-GIT_EXTENSIONS-NASRIA_LIMIT">
		<asp:Label ID="lblGIT_EXTENSIONS_NASRIA_LIMIT" runat="server" AssociatedControlID="GIT_EXTENSIONS__NASRIA_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GIT_EXTENSIONS__NASRIA_LIMIT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGIT_EXTENSIONS_NASRIA_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.NASRIA_LIMIT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__NASRIA_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label56">
		<span class="label" id="label56"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label57">
		<span class="label" id="label57"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label58">
		<span class="label" id="label58"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label59">
		<span class="label" id="label59"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label60">
		<span class="label" id="label60"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label61">
		<span class="label" id="label61"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label62">
		<span class="label" id="label62">Total</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label63">
		<span class="label" id="label63"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label64">
		<span class="label" id="label64"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="TOT_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-TOT_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_TOT_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__TOT_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__TOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_TOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.TOT_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__TOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="TOT_POST_PREM" 
		id="pb-container-currency-GIT_EXTENSIONS-TOT_POST_PREM">
		<asp:Label ID="lblGIT_EXTENSIONS_TOT_POST_PREM" runat="server" AssociatedControlID="GIT_EXTENSIONS__TOT_POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__TOT_POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_TOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.TOT_POST_PREM"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__TOT_POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label65">
		<span class="label" id="label65"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label66">
		<span class="label" id="label66"></span>
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
		if ($("#ide1201d10ca0c461981fbf710c9a494a2 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ide1201d10ca0c461981fbf710c9a494a2 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ide1201d10ca0c461981fbf710c9a494a2 div ul li").each(function(){		  
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
			$("#ide1201d10ca0c461981fbf710c9a494a2 div ul li").each(function(){		  
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
		styleString += "#ide1201d10ca0c461981fbf710c9a494a2 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ide1201d10ca0c461981fbf710c9a494a2 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ide1201d10ca0c461981fbf710c9a494a2 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ide1201d10ca0c461981fbf710c9a494a2 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ide1201d10ca0c461981fbf710c9a494a2 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ide1201d10ca0c461981fbf710c9a494a2 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ide1201d10ca0c461981fbf710c9a494a2 input{text-align:left;}"; break;
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
<div id="frmExtDesc" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading19" runat="server" Text="Extended Territories Description" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="EXT_DESC" 
		id="pb-container-comment-GIT_EXTENSIONS-EXT_DESC">
		<asp:Label ID="lblGIT_EXTENSIONS_EXT_DESC" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="GIT_EXTENSIONS__EXT_DESC" 
			Text=""></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="GIT_EXTENSIONS__EXT_DESC" runat="server" />
		
		<asp:CustomValidator ID="valGIT_EXTENSIONS_EXT_DESC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.EXT_DESC"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__EXT_DESC"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
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
		if ($("#frmExtDesc div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmExtDesc div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmExtDesc div ul li").each(function(){		  
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
			$("#frmExtDesc div ul li").each(function(){		  
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
		styleString += "#frmExtDesc label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmExtDesc label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmExtDesc label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmExtDesc label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmExtDesc input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmExtDesc input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmExtDesc input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading20" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblREFERRAL_CLAUSES_REFERRAL_CLAUSES" runat="server" AssociatedControlID="REFERRAL_CLAUSES__REFERRAL_CLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="REFERRAL_CLAUSES__REFERRAL_CLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="REFERRAL_CLAUSES" 
		data-property-name="TOT_PREM" 
		id="pb-container-currency-REFERRAL_CLAUSES-TOT_PREM">
		<asp:Label ID="lblREFERRAL_CLAUSES_TOT_PREM" runat="server" AssociatedControlID="REFERRAL_CLAUSES__TOT_PREM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="REFERRAL_CLAUSES__TOT_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valREFERRAL_CLAUSES_TOT_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_REFERRAL_CLAUSES__TOT_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_REFERRAL_CLAUSES__GITENDPREM"
		data-field-type="Child" 
		data-object-name="REFERRAL_CLAUSES" 
		data-property-name="GITENDPREM" 
		id="pb-container-childscreen-REFERRAL_CLAUSES-GITENDPREM">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="REFERRAL_CLAUSES__CLAUSEPREM" runat="server" ScreenCode="GITENDPREM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITENDPREM/GITENDPREM_Endorsement_Premium.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valREFERRAL_CLAUSES_GITENDPREM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for REFERRAL_CLAUSES.GITENDPREM"
						ClientValidationFunction="onValidate_REFERRAL_CLAUSES__GITENDPREM" 
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
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idf7e9f0313df74a5993d4bba919b28a45" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading21" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_NOTES__GITNOTES"
		data-field-type="Child" 
		data-object-name="NOTES" 
		data-property-name="GITNOTES" 
		id="pb-container-childscreen-NOTES-GITNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="NOTES__CNOTE_DETAILS" runat="server" ScreenCode="GITNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITNOTES/GITNOTES_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="Date_Created" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="Created_By" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="Risk_Cover" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="Note_Subject" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Details" DataField="Note_Details" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valNOTES_GITNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for NOTES.GITNOTES"
						ClientValidationFunction="onValidate_NOTES__GITNOTES" 
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
		if ($("#idf7e9f0313df74a5993d4bba919b28a45 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf7e9f0313df74a5993d4bba919b28a45 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf7e9f0313df74a5993d4bba919b28a45 div ul li").each(function(){		  
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
			$("#idf7e9f0313df74a5993d4bba919b28a45 div ul li").each(function(){		  
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
		styleString += "#idf7e9f0313df74a5993d4bba919b28a45 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf7e9f0313df74a5993d4bba919b28a45 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf7e9f0313df74a5993d4bba919b28a45 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf7e9f0313df74a5993d4bba919b28a45 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf7e9f0313df74a5993d4bba919b28a45 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf7e9f0313df74a5993d4bba919b28a45 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf7e9f0313df74a5993d4bba919b28a45 input{text-align:left;}"; break;
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
<div id="idfc3d5957e77b4101b236e70793ff2e58" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading22" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_NOTES__GITSNOTES"
		data-field-type="Child" 
		data-object-name="NOTES" 
		data-property-name="GITSNOTES" 
		id="pb-container-childscreen-NOTES-GITSNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="NOTES__SCNOTE_DETAILS" runat="server" ScreenCode="GITSNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITSNOTES/GITSNOTES_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="Date_Created" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="Created_By" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="Risk_Cover" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="Note_Subject" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Details" DataField="Note_Details" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valNOTES_GITSNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for NOTES.GITSNOTES"
						ClientValidationFunction="onValidate_NOTES__GITSNOTES" 
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
		if ($("#idfc3d5957e77b4101b236e70793ff2e58 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idfc3d5957e77b4101b236e70793ff2e58 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idfc3d5957e77b4101b236e70793ff2e58 div ul li").each(function(){		  
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
			$("#idfc3d5957e77b4101b236e70793ff2e58 div ul li").each(function(){		  
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
		styleString += "#idfc3d5957e77b4101b236e70793ff2e58 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idfc3d5957e77b4101b236e70793ff2e58 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idfc3d5957e77b4101b236e70793ff2e58 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idfc3d5957e77b4101b236e70793ff2e58 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idfc3d5957e77b4101b236e70793ff2e58 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idfc3d5957e77b4101b236e70793ff2e58 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idfc3d5957e77b4101b236e70793ff2e58 input{text-align:left;}"; break;
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
<div id="id2e0772f274394becba6699d81a76f251" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading23" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GENERAL" 
		data-property-name="UserLevel" 
		id="pb-container-integer-GENERAL-UserLevel">
		<asp:Label ID="lblGENERAL_UserLevel" runat="server" AssociatedControlID="GENERAL__UserLevel" 
			Text="UserLevel" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GENERAL__UserLevel" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGENERAL_UserLevel" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UserLevel"
			ClientValidationFunction="onValidate_GENERAL__UserLevel" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGENERAL_IsBroker" for="ctl00_cntMainBody_GENERAL__IsBroker" class="col-md-4 col-sm-3 control-label">
		IsBroker</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GENERAL" 
		data-property-name="IsBroker" 
		id="pb-container-checkbox-GENERAL-IsBroker">	
		
		<asp:TextBox ID="GENERAL__IsBroker" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGENERAL_IsBroker" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for IsBroker"
			ClientValidationFunction="onValidate_GENERAL__IsBroker" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GENERAL" 
		data-property-name="UserGroup" 
		 
		
		 
		id="pb-container-text-GENERAL-UserGroup">

		
		<asp:Label ID="lblGENERAL_UserGroup" runat="server" AssociatedControlID="GENERAL__UserGroup" 
			Text="UserGroup" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="GENERAL__UserGroup" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valGENERAL_UserGroup" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for UserGroup"
					ClientValidationFunction="onValidate_GENERAL__UserGroup"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GENERAL" 
		data-property-name="LoggedInUser" 
		 
		
		 
		id="pb-container-text-GENERAL-LoggedInUser">

		
		<asp:Label ID="lblGENERAL_LoggedInUser" runat="server" AssociatedControlID="GENERAL__LoggedInUser" 
			Text="LoggedInUser" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="GENERAL__LoggedInUser" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valGENERAL_LoggedInUser" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for LoggedInUser"
					ClientValidationFunction="onValidate_GENERAL__LoggedInUser"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GENERAL" 
		data-property-name="LoggedInUserFullName" 
		 
		
		 
		id="pb-container-text-GENERAL-LoggedInUserFullName">

		
		<asp:Label ID="lblGENERAL_LoggedInUserFullName" runat="server" AssociatedControlID="GENERAL__LoggedInUserFullName" 
			Text="LoggedInUserFullName" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="GENERAL__LoggedInUserFullName" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valGENERAL_LoggedInUserFullName" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for LoggedInUserFullName"
					ClientValidationFunction="onValidate_GENERAL__LoggedInUserFullName"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GENERAL" 
		data-property-name="LoggedInUserEmail" 
		 
		
		 
		id="pb-container-text-GENERAL-LoggedInUserEmail">

		
		<asp:Label ID="lblGENERAL_LoggedInUserEmail" runat="server" AssociatedControlID="GENERAL__LoggedInUserEmail" 
			Text="LoggedInUserEmail" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="GENERAL__LoggedInUserEmail" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valGENERAL_LoggedInUserEmail" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for LoggedInUserEmail"
					ClientValidationFunction="onValidate_GENERAL__LoggedInUserEmail"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GENERAL" 
		data-property-name="RunDefaultRuleFlag" 
		id="pb-container-integer-GENERAL-RunDefaultRuleFlag">
		<asp:Label ID="lblGENERAL_RunDefaultRuleFlag" runat="server" AssociatedControlID="GENERAL__RunDefaultRuleFlag" 
			Text="RunDefaultRuleFlag" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GENERAL__RunDefaultRuleFlag" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGENERAL_RunDefaultRuleFlag" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RunDefaultRuleFlag"
			ClientValidationFunction="onValidate_GENERAL__RunDefaultRuleFlag" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- TempInteger -->
	<span class="field-container"
		data-field-type="TempInteger" 
		data-object-name="GENERAL" 
		data-property-name="RefCount" 
		id="pb-container-integer-GENERAL-RefCount"
	>
		<label id="ctl00_cntMainBody_lblGENERAL_RefCount">RefCount</label>
		<input id="ctl00_cntMainBody_GENERAL_RefCount" class="field-medium" />
		<asp:CustomValidator ID="valGENERAL_RefCount" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RefCount"
			ClientValidationFunction="onValidate_GENERAL__RefCount" 
			Display="None"
			EnableClientScript="true"
		/>
	</span>
<!-- /TempInteger -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGENERAL_ShowReferralsTab" for="ctl00_cntMainBody_GENERAL__ShowReferralsTab" class="col-md-4 col-sm-3 control-label">
		ShowReferralsTab</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GENERAL" 
		data-property-name="ShowReferralsTab" 
		id="pb-container-checkbox-GENERAL-ShowReferralsTab">	
		
		<asp:TextBox ID="GENERAL__ShowReferralsTab" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGENERAL_ShowReferralsTab" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ShowReferralsTab"
			ClientValidationFunction="onValidate_GENERAL__ShowReferralsTab" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GENERAL" 
		data-property-name="FD_DEP_PER" 
		id="pb-container-percentage-GENERAL-FD_DEP_PER">
		<asp:Label ID="lblGENERAL_FD_DEP_PER" runat="server" AssociatedControlID="GENERAL__FD_DEP_PER" 
			Text="Deposit %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GENERAL__FD_DEP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGENERAL_FD_DEP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Deposit %"
			ClientValidationFunction="onValidate_GENERAL__FD_DEP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GENERAL" 
		data-property-name="FD_FRE_PER" 
		id="pb-container-percentage-GENERAL-FD_FRE_PER">
		<asp:Label ID="lblGENERAL_FD_FRE_PER" runat="server" AssociatedControlID="GENERAL__FD_FRE_PER" 
			Text="First Retained %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GENERAL__FD_FRE_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGENERAL_FD_FRE_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for First Retained %"
			ClientValidationFunction="onValidate_GENERAL__FD_FRE_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GENERAL" 
		data-property-name="FD_SRE_PER" 
		id="pb-container-percentage-GENERAL-FD_SRE_PER">
		<asp:Label ID="lblGENERAL_FD_SRE_PER" runat="server" AssociatedControlID="GENERAL__FD_SRE_PER" 
			Text="Second Retained %" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GENERAL__FD_SRE_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGENERAL_FD_SRE_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Second Retained %"
			ClientValidationFunction="onValidate_GENERAL__FD_SRE_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GENERAL" 
		data-property-name="LB_NF_LOI" 
		id="pb-container-currency-GENERAL-LB_NF_LOI">
		<asp:Label ID="lblGENERAL_LB_NF_LOI" runat="server" AssociatedControlID="GENERAL__LB_NF_LOI" 
			Text="Third Party and Non-Fare Paying Passengers Liability Limit of Indemnity Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__LB_NF_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_LB_NF_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Third Party and Non-Fare Paying Passengers Liability Limit of Indemnity Default"
			ClientValidationFunction="onValidate_GENERAL__LB_NF_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GENERAL" 
		data-property-name="LB_TP_LOI" 
		id="pb-container-currency-GENERAL-LB_TP_LOI">
		<asp:Label ID="lblGENERAL_LB_TP_LOI" runat="server" AssociatedControlID="GENERAL__LB_TP_LOI" 
			Text="Third Party Liability Limit Of Indemnity Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__LB_TP_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_LB_TP_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Third Party Liability Limit Of Indemnity Default"
			ClientValidationFunction="onValidate_GENERAL__LB_TP_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GENERAL" 
		data-property-name="EXT_WS_FAP" 
		id="pb-container-percentage-GENERAL-EXT_WS_FAP">
		<asp:Label ID="lblGENERAL_EXT_WS_FAP" runat="server" AssociatedControlID="GENERAL__EXT_WS_FAP" 
			Text="Windscreen FAP % Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GENERAL__EXT_WS_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGENERAL_EXT_WS_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Windscreen FAP % Default"
			ClientValidationFunction="onValidate_GENERAL__EXT_WS_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GENERAL" 
		data-property-name="EXT_LK_LOI" 
		id="pb-container-currency-GENERAL-EXT_LK_LOI">
		<asp:Label ID="lblGENERAL_EXT_LK_LOI" runat="server" AssociatedControlID="GENERAL__EXT_LK_LOI" 
			Text="Loss of Keys Limit of Indemnity Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__EXT_LK_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_EXT_LK_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Loss of Keys Limit of Indemnity Default"
			ClientValidationFunction="onValidate_GENERAL__EXT_LK_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GENERAL" 
		data-property-name="EXT_LK_FAP" 
		id="pb-container-percentage-GENERAL-EXT_LK_FAP">
		<asp:Label ID="lblGENERAL_EXT_LK_FAP" runat="server" AssociatedControlID="GENERAL__EXT_LK_FAP" 
			Text="Loss of Keys FAP% Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GENERAL__EXT_LK_FAP" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGENERAL_EXT_LK_FAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Loss of Keys FAP% Default"
			ClientValidationFunction="onValidate_GENERAL__EXT_LK_FAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GENERAL" 
		data-property-name="EXT_LK_MIN" 
		id="pb-container-currency-GENERAL-EXT_LK_MIN">
		<asp:Label ID="lblGENERAL_EXT_LK_MIN" runat="server" AssociatedControlID="GENERAL__EXT_LK_MIN" 
			Text="Loss of Keys Minimum Amount Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__EXT_LK_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_EXT_LK_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Loss of Keys Minimum Amount Default"
			ClientValidationFunction="onValidate_GENERAL__EXT_LK_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GENERAL" 
		data-property-name="EXT_WR_LOI" 
		id="pb-container-currency-GENERAL-EXT_WR_LOI">
		<asp:Label ID="lblGENERAL_EXT_WR_LOI" runat="server" AssociatedControlID="GENERAL__EXT_WR_LOI" 
			Text="Wreckage Removal Limit of Indemnity Default" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GENERAL__EXT_WR_LOI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGENERAL_EXT_WR_LOI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Wreckage Removal Limit of Indemnity Default"
			ClientValidationFunction="onValidate_GENERAL__EXT_WR_LOI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="GENERAL" 
		data-property-name="NEXUSQS" 
		id="pb-container-integer-GENERAL-NEXUSQS">
		<asp:Label ID="lblGENERAL_NEXUSQS" runat="server" AssociatedControlID="GENERAL__NEXUSQS" 
			Text="NEXUSQS" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="GENERAL__NEXUSQS" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valGENERAL_NEXUSQS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NEXUSQS"
			ClientValidationFunction="onValidate_GENERAL__NEXUSQS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="POLICYHEADER" 
		data-property-name="COVERSTARTDATE" 
		id="pb-container-datejquerycompatible-POLICYHEADER-COVERSTARTDATE">
		<asp:Label ID="lblPOLICYHEADER_COVERSTARTDATE" runat="server" AssociatedControlID="POLICYHEADER__COVERSTARTDATE" 
			Text="Cover Start Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="POLICYHEADER__COVERSTARTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calPOLICYHEADER__COVERSTARTDATE" runat="server" LinkedControl="POLICYHEADER__COVERSTARTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valPOLICYHEADER_COVERSTARTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cover Start Date"
			ClientValidationFunction="onValidate_POLICYHEADER__COVERSTARTDATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="POLICYHEADER" 
		data-property-name="POLICYNUMBER" 
		 
		
		 
		id="pb-container-text-POLICYHEADER-POLICYNUMBER">

		
		<asp:Label ID="lblPOLICYHEADER_POLICYNUMBER" runat="server" AssociatedControlID="POLICYHEADER__POLICYNUMBER" 
			Text="Policy Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="POLICYHEADER__POLICYNUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPOLICYHEADER_POLICYNUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Policy Number"
					ClientValidationFunction="onValidate_POLICYHEADER__POLICYNUMBER"
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
		if ($("#id2e0772f274394becba6699d81a76f251 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id2e0772f274394becba6699d81a76f251 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id2e0772f274394becba6699d81a76f251 div ul li").each(function(){		  
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
			$("#id2e0772f274394becba6699d81a76f251 div ul li").each(function(){		  
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
		styleString += "#id2e0772f274394becba6699d81a76f251 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id2e0772f274394becba6699d81a76f251 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2e0772f274394becba6699d81a76f251 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2e0772f274394becba6699d81a76f251 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id2e0772f274394becba6699d81a76f251 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2e0772f274394becba6699d81a76f251 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2e0772f274394becba6699d81a76f251 input{text-align:left;}"; break;
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