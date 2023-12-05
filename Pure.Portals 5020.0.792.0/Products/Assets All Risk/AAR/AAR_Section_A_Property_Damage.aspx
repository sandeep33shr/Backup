<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="AAR_Section_A_Property_Damage.aspx.vb" Inherits="Nexus.PB2_AAR_Section_A_Property_Damage" %>

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
function onValidate_SECTIONA__ATTACHMENTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "ATTACHMENTDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONA", "ATTACHMENTDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONA_ATTACHMENTDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONA__ATTACHMENTDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONA__ATTACHMENTDATE_lblFindParty");
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
              var field = Field.getInstance("SECTIONA.ATTACHMENTDATE");
        			window.setControlWidth(field, "0.8", "SECTIONA", "ATTACHMENTDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONA__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("SECTIONA", "EFFECTIVEDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONA_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONA__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONA__EFFECTIVEDATE_lblFindParty");
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
              var field = Field.getInstance("SECTIONA.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.8", "SECTIONA", "EFFECTIVEDATE");
        		})();
        	}
        })();
}
function onValidate_SECTIONA__IPAD_SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IPAD_SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("SECTIONA", "IPAD_SUMINSURED");
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
}
function onValidate_SECTIONA__IPAD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IPAD_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("SECTIONA", "IPAD_RATE");
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
}
function onValidate_SECTIONA__IPAD_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IPAD_PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("SECTIONA", "IPAD_PREMIUM");
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
}
function onValidate_label70(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label70" != "{na" + "me}"){
        			instance = Field.getLabel("label70");
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
function onValidate_SECTIONA__IS_PMO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_PMO", "Checkbox");
        })();
}
function onValidate_SECTIONA__PMO_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "PMO_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_AOLOM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_AOLOM", "Checkbox");
        })();
}
function onValidate_SECTIONA__AOLOM_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "AOLOM_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_SIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_SIL", "Checkbox");
        })();
}
function onValidate_SECTIONA__SIL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SIL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__SIL_FPER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SIL_FPER", "Text");
        })();
}
function onValidate_SECTIONA__SIL_TPER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SIL_TPER", "Text");
        })();
}
function onValidate_SECTIONA__IS_DAD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_DAD", "Checkbox");
        })();
}
function onValidate_SECTIONA__DAD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "DAD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_FAPAD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_FAPAD", "Checkbox");
        })();
}
function onValidate_SECTIONA__FAPDAD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "FAPDAD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_SC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_SC", "Checkbox");
        })();
}
function onValidate_SECTIONA__SC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_CH(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_CH", "Checkbox");
        })();
}
function onValidate_SECTIONA__CH_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "CH_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_SP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_SP", "Checkbox");
        })();
}
function onValidate_SECTIONA__SP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SP_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_ADL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_ADL", "Checkbox");
        })();
}
function onValidate_SECTIONA__ADL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "ADL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_MD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_MD", "Checkbox");
        })();
}
function onValidate_SECTIONA__MD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "MD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_TOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_TOT", "Checkbox");
        })();
}
function onValidate_SECTIONA__TOT_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "TOT_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_POD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_POD", "Checkbox");
        })();
}
function onValidate_SECTIONA__POD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "POD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_ACD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_ACD", "Checkbox");
        })();
}
function onValidate_SECTIONA__ACD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "ACD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_TAD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_TAD", "Checkbox");
        })();
}
function onValidate_SECTIONA__TAD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "TAD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__IS_SAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "IS_SAL", "Checkbox");
        })();
}
function onValidate_SECTIONA__SAL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SAL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA__OTHPROPDAM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "OTHPROPDAM", "ChildScreen");
        })();
}
function onValidate_SECTIONA__OTHPROPDAM_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "OTHPROPDAM_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONA", "OTHPROPDAM_CNT");
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
          * @param SECTIONA The Parent (Root) object name.
          * @param OTH_PROP_PD.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_PROP_PD.DESCRIP";
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
        		
        		var field = Field.getInstance("SECTIONA", "OTHPROPDAM_CNT");
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
        			
        			var field = Field.getInstance("SECTIONA", "OTHPROPDAM_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONA_EXT__IS_PAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_PAL", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__PAR_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "PAR_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_PF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_PF", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__PF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "PF_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_PSF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_PSF", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__PSF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "PSF_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_SD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_SD", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__SD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "SD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_FPSU(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_FPSU", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__FPSU_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "FPSU_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_FERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_FERC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__FERC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "FERC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_TMRAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_TMRAL", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__TMRAL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "TMRAL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_FEPE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_FEPE", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__FEPE_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "FEPE_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_CC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_CC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__CC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "CC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_CCN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_CCN", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__CCN_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "CCN_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_SOP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_SOP", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__SOP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "SOP_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_IN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_IN", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__IN_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IN_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_LOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_LOR", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__LOR_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "LOR_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_PITC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_PITC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__PITC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "PITC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_MVDIV(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_MVDIV", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__MVDIV_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "MVDIV_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_ROD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_ROD", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__ROD_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "ROD_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_ILHC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_ILHC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__ILHC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "ILHC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_TA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_TA", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__TA_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "TA_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_APF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_APF", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__APF_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "APF_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_FBC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_FBC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__FBC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "FBC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_MBS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_MBS", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__MBS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "MBS_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_RST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_RST", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__RST_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "RST_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_DBT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_DBT", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__DBT_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "DBT_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_ROK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_ROK", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__ROK_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "ROK_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_DADFC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_DADFC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__DADFC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "DADFC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_WGL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_WGL", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__WGL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "WGL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_EC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_EC", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__EC_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "EC_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_ACACS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_ACACS", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__ACACS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "ACACS_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_GL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_GL", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__GL_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "GL_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_PGS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_PGS", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__PGS_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "PGS_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_TEMP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_TEMP", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__TEMP_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "TEMP_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__IS_SOMGW(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "IS_SOMGW", "Checkbox");
        })();
}
function onValidate_SECTIONA_EXT__SOMGW_LOL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "SOMGW_LOL", "Currency");
        })();
}
function onValidate_SECTIONA_EXT__OTHPROPEX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "OTHPROPEX", "ChildScreen");
        })();
}
function onValidate_SECTIONA_EXT__OTHPROPEX_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_EXT", "OTHPROPEX_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONA_EXT", "OTHPROPEX_CNT");
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
          * @param SECTIONA_EXT The Parent (Root) object name.
          * @param OTH_PROP_EXT.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA_EXT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_PROP_EXT.DESCRIP";
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
        		
        		var field = Field.getInstance("SECTIONA_EXT", "OTHPROPEX_CNT");
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
        			
        			var field = Field.getInstance("SECTIONA_EXT", "OTHPROPEX_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONA_DED__IS_FAAP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_FAAP", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__FAAP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "FAAP_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__FAAP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "FAAP_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__FAAP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "FAAP_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_EIP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_EIP", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__EIP_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "EIP_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__EIP_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "EIP_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__EIP_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "EIP_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_PAMO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_PAMO", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__PAMO_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PAMO_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__PAMO_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PAMO_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__PAMO_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PAMO_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_AOLM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_AOLM", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__AOLM_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AOLM_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__AOLM_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AOLM_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__AOLM_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AOLM_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_SIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_SIL", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__SIL_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "SIL_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__SIL_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "SIL_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__SIL_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "SIL_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_DOC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_DOC", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__DOC_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "DOC_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__DOC_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "DOC_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__DOC_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "DOC_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_PIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_PIT", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__PIT_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PIT_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__PIT_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PIT_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__PIT_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "PIT_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_AD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_AD", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__AD_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AD_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__AD_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AD_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__AD_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AD_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_T(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_T", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__T_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "T_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__T_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "T_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__T_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "T_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_G(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_G", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__G_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "G_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__G_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "G_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__G_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "G_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__IS_AL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "IS_AL", "Checkbox");
        })();
}
function onValidate_SECTIONA_DED__AL_DED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AL_DED", "Percentage");
        })();
}
function onValidate_SECTIONA_DED__AL_MIN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AL_MIN", "Currency");
        })();
}
function onValidate_SECTIONA_DED__AL_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "AL_MAX", "Currency");
        })();
}
function onValidate_SECTIONA_DED__OTHERPDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "OTHERPDED", "ChildScreen");
        })();
}
function onValidate_SECTIONA_DED__OTHERPDED_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA_DED", "OTHERPDED_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONA_DED", "OTHERPDED_CNT");
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
          * @param SECTIONA_DED The Parent (Root) object name.
          * @param OTH_PROP_DED.DESCRIP The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA_DED".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "OTH_PROP_DED.DESCRIP";
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
        		
        		var field = Field.getInstance("SECTIONA_DED", "OTHERPDED_CNT");
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
        			
        			var field = Field.getInstance("SECTIONA_DED", "OTHERPDED_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONA__SECTIONA_COUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "SECTIONA_COUNT", "Integer");
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
        			var field = Field.getInstance("SECTIONA", "SECTIONA_COUNT");
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
          * @param SECTIONA The Parent (Root) object name.
          * @param SECTIONA_CLAUSEPREM.COUNTER_ID The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONA_CLAUSEPREM.COUNTER_ID";
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
        		
        		var field = Field.getInstance("SECTIONA", "SECTIONA_COUNT");
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
        			
        			var field = Field.getInstance("SECTIONA", "SECTIONA_COUNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONA__ENDORSE_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "ENDORSE_PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("SECTIONA", "ENDORSE_PREMIUM");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblSECTIONA_ENDORSE_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_SECTIONA__ENDORSE_PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_SECTIONA__ENDORSE_PREMIUM_lblFindParty");
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
              var field = Field.getInstance("SECTIONA.ENDORSE_PREMIUM");
        			window.setControlWidth(field, "1", "SECTIONA", "ENDORSE_PREMIUM");
        		})();
        	}
        })();
        
         /**
          * @fileoverview GetColumn
          * @param SECTIONA The Parent (Root) object name.
          * @param SECTIONA_CLAUSEPREM.PREMIUM The object.property to sum the totals of.
          * @param TOTAL The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECTIONA_CLAUSEPREM.PREMIUM";
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
        		
        		var field = Field.getInstance("SECTIONA", "ENDORSE_PREMIUM");
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
        			
        			var field = Field.getInstance("SECTIONA", "ENDORSE_PREMIUM");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_SECTIONA__PROPEND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "PROPEND", "ChildScreen");
        })();
}
function onValidate_SECTIONA__PROPNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "PROPNOTE", "ChildScreen");
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
        		var field = Field.getInstance("SECTIONA", "PROPNOTE");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONA__PROPNOTE table td a");
        				
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
        		var field = Field.getInstance("SECTIONA", "PROPNOTE");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'SECTIONA' and property 'PROPNOTE'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_SECTIONA__PROPNOTE table td a");
        				
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
function onValidate_SECTIONA__PROPPNOTE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "PROPPNOTE", "ChildScreen");
        })();
}
function onValidate_SECTIONA__PROPPNOTE_CNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "SECTIONA", "PROPPNOTE_CNT", "Integer");
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
        			var field = Field.getInstance("SECTIONA", "PROPPNOTE_CNT");
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
          * @param SECTIONA The Parent (Root) object name.
          * @param SECAS_DETAILS.DATE_CREATED The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "SECTIONA".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "SECAS_DETAILS.DATE_CREATED";
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
        		
        		var field = Field.getInstance("SECTIONA", "PROPPNOTE_CNT");
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
        			
        			var field = Field.getInstance("SECTIONA", "PROPPNOTE_CNT");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function DoLogic(isOnLoad) {
    onValidate_SECTIONA__ATTACHMENTDATE(null, null, null, isOnLoad);
    onValidate_SECTIONA__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_SECTIONA__IPAD_SUMINSURED(null, null, null, isOnLoad);
    onValidate_SECTIONA__IPAD_RATE(null, null, null, isOnLoad);
    onValidate_SECTIONA__IPAD_PREMIUM(null, null, null, isOnLoad);
    onValidate_label70(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_PMO(null, null, null, isOnLoad);
    onValidate_SECTIONA__PMO_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_AOLOM(null, null, null, isOnLoad);
    onValidate_SECTIONA__AOLOM_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_SIL(null, null, null, isOnLoad);
    onValidate_SECTIONA__SIL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__SIL_FPER(null, null, null, isOnLoad);
    onValidate_SECTIONA__SIL_TPER(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_DAD(null, null, null, isOnLoad);
    onValidate_SECTIONA__DAD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_FAPAD(null, null, null, isOnLoad);
    onValidate_SECTIONA__FAPDAD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_SC(null, null, null, isOnLoad);
    onValidate_SECTIONA__SC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_CH(null, null, null, isOnLoad);
    onValidate_SECTIONA__CH_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_SP(null, null, null, isOnLoad);
    onValidate_SECTIONA__SP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_ADL(null, null, null, isOnLoad);
    onValidate_SECTIONA__ADL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_MD(null, null, null, isOnLoad);
    onValidate_SECTIONA__MD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_TOT(null, null, null, isOnLoad);
    onValidate_SECTIONA__TOT_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_POD(null, null, null, isOnLoad);
    onValidate_SECTIONA__POD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_ACD(null, null, null, isOnLoad);
    onValidate_SECTIONA__ACD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_TAD(null, null, null, isOnLoad);
    onValidate_SECTIONA__TAD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__IS_SAL(null, null, null, isOnLoad);
    onValidate_SECTIONA__SAL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA__OTHPROPDAM(null, null, null, isOnLoad);
    onValidate_SECTIONA__OTHPROPDAM_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_PAL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__PAR_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_PF(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__PF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_PSF(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__PSF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_SD(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__SD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_FPSU(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__FPSU_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_FERC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__FERC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_TMRAL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__TMRAL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_FEPE(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__FEPE_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_CC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__CC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_CCN(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__CCN_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_SOP(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__SOP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_IN(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IN_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_LOR(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__LOR_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_PITC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__PITC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_MVDIV(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__MVDIV_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_ROD(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__ROD_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_ILHC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__ILHC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_TA(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__TA_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_APF(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__APF_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_FBC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__FBC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_MBS(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__MBS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_RST(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__RST_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_DBT(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__DBT_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_ROK(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__ROK_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_DADFC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__DADFC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_WGL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__WGL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_EC(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__EC_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_ACACS(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__ACACS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_GL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__GL_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_PGS(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__PGS_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_TEMP(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__TEMP_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__IS_SOMGW(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__SOMGW_LOL(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__OTHPROPEX(null, null, null, isOnLoad);
    onValidate_SECTIONA_EXT__OTHPROPEX_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_FAAP(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__FAAP_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__FAAP_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__FAAP_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_EIP(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__EIP_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__EIP_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__EIP_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_PAMO(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PAMO_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PAMO_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PAMO_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_AOLM(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AOLM_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AOLM_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AOLM_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_SIL(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__SIL_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__SIL_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__SIL_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_DOC(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__DOC_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__DOC_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__DOC_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_PIT(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PIT_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PIT_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__PIT_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_AD(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AD_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AD_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AD_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_T(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__T_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__T_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__T_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_G(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__G_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__G_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__G_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__IS_AL(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AL_DED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AL_MIN(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__AL_MAX(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__OTHERPDED(null, null, null, isOnLoad);
    onValidate_SECTIONA_DED__OTHERPDED_CNT(null, null, null, isOnLoad);
    onValidate_SECTIONA__SECTIONA_COUNT(null, null, null, isOnLoad);
    onValidate_SECTIONA__ENDORSE_PREMIUM(null, null, null, isOnLoad);
    onValidate_SECTIONA__PROPEND(null, null, null, isOnLoad);
    onValidate_SECTIONA__PROPNOTE(null, null, null, isOnLoad);
    onValidate_SECTIONA__PROPPNOTE(null, null, null, isOnLoad);
    onValidate_SECTIONA__PROPPNOTE_CNT(null, null, null, isOnLoad);
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
<div id="id7e40f77c3a6443a38586236c1d51c879" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id58d3cbc6346e4d71a6a4973fd5b626bf" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading39" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="SECTIONA" 
		data-property-name="ATTACHMENTDATE" 
		id="pb-container-datejquerycompatible-SECTIONA-ATTACHMENTDATE">
		<asp:Label ID="lblSECTIONA_ATTACHMENTDATE" runat="server" AssociatedControlID="SECTIONA__ATTACHMENTDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONA__ATTACHMENTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONA__ATTACHMENTDATE" runat="server" LinkedControl="SECTIONA__ATTACHMENTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONA_ATTACHMENTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_SECTIONA__ATTACHMENTDATE" 
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
		data-object-name="SECTIONA" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-SECTIONA-EFFECTIVEDATE">
		<asp:Label ID="lblSECTIONA_EFFECTIVEDATE" runat="server" AssociatedControlID="SECTIONA__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="SECTIONA__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calSECTIONA__EFFECTIVEDATE" runat="server" LinkedControl="SECTIONA__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valSECTIONA_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_SECTIONA__EFFECTIVEDATE" 
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
		if ($("#id58d3cbc6346e4d71a6a4973fd5b626bf div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id58d3cbc6346e4d71a6a4973fd5b626bf div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id58d3cbc6346e4d71a6a4973fd5b626bf div ul li").each(function(){		  
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
			$("#id58d3cbc6346e4d71a6a4973fd5b626bf div ul li").each(function(){		  
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
		styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id58d3cbc6346e4d71a6a4973fd5b626bf input{text-align:left;}"; break;
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
<div id="id7861f460d3ef4e47962efb3bfe5ebfd9" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading40" runat="server" Text="Risk Data " /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label57">
		<span class="label" id="label57"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label58">
		<span class="label" id="label58"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label59">
		<span class="label" id="label59">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label60">
		<span class="label" id="label60">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label61">
		<span class="label" id="label61">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label62">
		<span class="label" id="label62"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label63">
		<span class="label" id="label63">Insured Property (as defined)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="IPAD_SUMINSURED" 
		id="pb-container-currency-SECTIONA-IPAD_SUMINSURED">
		<asp:Label ID="lblSECTIONA_IPAD_SUMINSURED" runat="server" AssociatedControlID="SECTIONA__IPAD_SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__IPAD_SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_IPAD_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IPAD_SUMINSURED"
			ClientValidationFunction="onValidate_SECTIONA__IPAD_SUMINSURED" 
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
		data-object-name="SECTIONA" 
		data-property-name="IPAD_RATE" 
		id="pb-container-percentage-SECTIONA-IPAD_RATE">
		<asp:Label ID="lblSECTIONA_IPAD_RATE" runat="server" AssociatedControlID="SECTIONA__IPAD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA__IPAD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_IPAD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IPAD_RATE"
			ClientValidationFunction="onValidate_SECTIONA__IPAD_RATE" 
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
		data-object-name="SECTIONA" 
		data-property-name="IPAD_PREMIUM" 
		id="pb-container-currency-SECTIONA-IPAD_PREMIUM">
		<asp:Label ID="lblSECTIONA_IPAD_PREMIUM" runat="server" AssociatedControlID="SECTIONA__IPAD_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__IPAD_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_IPAD_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IPAD_PREMIUM"
			ClientValidationFunction="onValidate_SECTIONA__IPAD_PREMIUM" 
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
		if ($("#id7861f460d3ef4e47962efb3bfe5ebfd9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id7861f460d3ef4e47962efb3bfe5ebfd9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id7861f460d3ef4e47962efb3bfe5ebfd9 div ul li").each(function(){		  
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
			$("#id7861f460d3ef4e47962efb3bfe5ebfd9 div ul li").each(function(){		  
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
		styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7861f460d3ef4e47962efb3bfe5ebfd9 input{text-align:left;}"; break;
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
<div id="id1bd084d97dea4f468e71733fe5ff7af0" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading41" runat="server" Text="" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label64">
		<span class="label" id="label64"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label65">
		<span class="label" id="label65"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label66">
		<span class="label" id="label66">Limit Of Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label67">
		<span class="label" id="label67">From Period</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label68">
		<span class="label" id="label68">To Period</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label69">
		<span class="label" id="label69"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label70">
		<span class="label" id="label70">Money (as defined) (Property Damage and Business Interruption Limit Combined)</span>
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label72">
		<span class="label" id="label72"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label73">
		<span class="label" id="label73"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_PMO" for="ctl00_cntMainBody_SECTIONA__IS_PMO" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_PMO" 
		id="pb-container-checkbox-SECTIONA-IS_PMO">	
		
		<asp:TextBox ID="SECTIONA__IS_PMO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_PMO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_PMO"
			ClientValidationFunction="onValidate_SECTIONA__IS_PMO" 
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
	<span id="pb-container-label-label74">
		<span class="label" id="label74">Postal and Money Orders</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label75">
		<span class="label" id="label75"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label76">
		<span class="label" id="label76"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="PMO_LOL" 
		id="pb-container-currency-SECTIONA-PMO_LOL">
		<asp:Label ID="lblSECTIONA_PMO_LOL" runat="server" AssociatedControlID="SECTIONA__PMO_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__PMO_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_PMO_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.PMO_LOL"
			ClientValidationFunction="onValidate_SECTIONA__PMO_LOL" 
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
<label id="ctl00_cntMainBody_lblSECTIONA_IS_AOLOM" for="ctl00_cntMainBody_SECTIONA__IS_AOLOM" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_AOLOM" 
		id="pb-container-checkbox-SECTIONA-IS_AOLOM">	
		
		<asp:TextBox ID="SECTIONA__IS_AOLOM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_AOLOM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_AOLOM"
			ClientValidationFunction="onValidate_SECTIONA__IS_AOLOM" 
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
		<span class="label" id="label77">Any other Loss of Money</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label78">
		<span class="label" id="label78"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label79">
		<span class="label" id="label79"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="AOLOM_LOL" 
		id="pb-container-currency-SECTIONA-AOLOM_LOL">
		<asp:Label ID="lblSECTIONA_AOLOM_LOL" runat="server" AssociatedControlID="SECTIONA__AOLOM_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__AOLOM_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_AOLOM_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.AOLOM_LOL"
			ClientValidationFunction="onValidate_SECTIONA__AOLOM_LOL" 
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
<label id="ctl00_cntMainBody_lblSECTIONA_IS_SIL" for="ctl00_cntMainBody_SECTIONA__IS_SIL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_SIL" 
		id="pb-container-checkbox-SECTIONA-IS_SIL">	
		
		<asp:TextBox ID="SECTIONA__IS_SIL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_SIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_SIL"
			ClientValidationFunction="onValidate_SECTIONA__IS_SIL" 
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
		<span class="label" id="label80">Seasonal Increase Limit  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="SIL_LOL" 
		id="pb-container-currency-SECTIONA-SIL_LOL">
		<asp:Label ID="lblSECTIONA_SIL_LOL" runat="server" AssociatedControlID="SECTIONA__SIL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__SIL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_SIL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.SIL_LOL"
			ClientValidationFunction="onValidate_SECTIONA__SIL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONA" 
		data-property-name="SIL_FPER" 
		 
		
		 
		id="pb-container-text-SECTIONA-SIL_FPER">

		
		<asp:Label ID="lblSECTIONA_SIL_FPER" runat="server" AssociatedControlID="SECTIONA__SIL_FPER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="SECTIONA__SIL_FPER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valSECTIONA_SIL_FPER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for SECTIONA.SIL_FPER"
					ClientValidationFunction="onValidate_SECTIONA__SIL_FPER"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="SECTIONA" 
		data-property-name="SIL_TPER" 
		 
		
		 
		id="pb-container-text-SECTIONA-SIL_TPER">

		
		<asp:Label ID="lblSECTIONA_SIL_TPER" runat="server" AssociatedControlID="SECTIONA__SIL_TPER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="SECTIONA__SIL_TPER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valSECTIONA_SIL_TPER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for SECTIONA.SIL_TPER"
					ClientValidationFunction="onValidate_SECTIONA__SIL_TPER"
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
		if ($("#id1bd084d97dea4f468e71733fe5ff7af0 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id1bd084d97dea4f468e71733fe5ff7af0 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id1bd084d97dea4f468e71733fe5ff7af0 div ul li").each(function(){		  
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
			$("#id1bd084d97dea4f468e71733fe5ff7af0 div ul li").each(function(){		  
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
		styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id1bd084d97dea4f468e71733fe5ff7af0 input{text-align:left;}"; break;
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
<div id="id002f2da772914e88a29a473a6ac3d735" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading42" runat="server" Text="" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label81">
		<span class="label" id="label81"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label82">
		<span class="label" id="label82"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label83">
		<span class="label" id="label83">Limit Of Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label84">
		<span class="label" id="label84"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label85">
		<span class="label" id="label85"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_DAD" for="ctl00_cntMainBody_SECTIONA__IS_DAD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_DAD" 
		id="pb-container-checkbox-SECTIONA-IS_DAD">	
		
		<asp:TextBox ID="SECTIONA__IS_DAD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_DAD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_DAD"
			ClientValidationFunction="onValidate_SECTIONA__IS_DAD" 
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
	<span id="pb-container-label-label86">
		<span class="label" id="label86">Documents (as defined) (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="DAD_LOL" 
		id="pb-container-currency-SECTIONA-DAD_LOL">
		<asp:Label ID="lblSECTIONA_DAD_LOL" runat="server" AssociatedControlID="SECTIONA__DAD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__DAD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DAD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.DAD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__DAD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label87">
		<span class="label" id="label87"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label88">
		<span class="label" id="label88"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_FAPAD" for="ctl00_cntMainBody_SECTIONA__IS_FAPAD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_FAPAD" 
		id="pb-container-checkbox-SECTIONA-IS_FAPAD">	
		
		<asp:TextBox ID="SECTIONA__IS_FAPAD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_FAPAD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_FAPAD"
			ClientValidationFunction="onValidate_SECTIONA__IS_FAPAD" 
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
	<span id="pb-container-label-label89">
		<span class="label" id="label89">Fire and Allied Perils (as defined) other than</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="FAPDAD_LOL" 
		id="pb-container-currency-SECTIONA-FAPDAD_LOL">
		<asp:Label ID="lblSECTIONA_FAPDAD_LOL" runat="server" AssociatedControlID="SECTIONA__FAPDAD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__FAPDAD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_FAPDAD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.FAPDAD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__FAPDAD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label90">
		<span class="label" id="label90"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label91">
		<span class="label" id="label91"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_SC" for="ctl00_cntMainBody_SECTIONA__IS_SC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_SC" 
		id="pb-container-checkbox-SECTIONA-IS_SC">	
		
		<asp:TextBox ID="SECTIONA__IS_SC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_SC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_SC"
			ClientValidationFunction="onValidate_SECTIONA__IS_SC" 
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
	<span id="pb-container-label-label92">
		<span class="label" id="label92">Spontaneous Combustion</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="SC_LOL" 
		id="pb-container-currency-SECTIONA-SC_LOL">
		<asp:Label ID="lblSECTIONA_SC_LOL" runat="server" AssociatedControlID="SECTIONA__SC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__SC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_SC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.SC_LOL"
			ClientValidationFunction="onValidate_SECTIONA__SC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label93">
		<span class="label" id="label93"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label94">
		<span class="label" id="label94"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_CH" for="ctl00_cntMainBody_SECTIONA__IS_CH" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_CH" 
		id="pb-container-checkbox-SECTIONA-IS_CH">	
		
		<asp:TextBox ID="SECTIONA__IS_CH" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_CH" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_CH"
			ClientValidationFunction="onValidate_SECTIONA__IS_CH" 
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
	<span id="pb-container-label-label95">
		<span class="label" id="label95">Charring</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="CH_LOL" 
		id="pb-container-currency-SECTIONA-CH_LOL">
		<asp:Label ID="lblSECTIONA_CH_LOL" runat="server" AssociatedControlID="SECTIONA__CH_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__CH_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_CH_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.CH_LOL"
			ClientValidationFunction="onValidate_SECTIONA__CH_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label96">
		<span class="label" id="label96"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label97">
		<span class="label" id="label97"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_SP" for="ctl00_cntMainBody_SECTIONA__IS_SP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_SP" 
		id="pb-container-checkbox-SECTIONA-IS_SP">	
		
		<asp:TextBox ID="SECTIONA__IS_SP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_SP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_SP"
			ClientValidationFunction="onValidate_SECTIONA__IS_SP" 
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
	<span id="pb-container-label-label98">
		<span class="label" id="label98">Special Perils (as defined) other than</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="SP_LOL" 
		id="pb-container-currency-SECTIONA-SP_LOL">
		<asp:Label ID="lblSECTIONA_SP_LOL" runat="server" AssociatedControlID="SECTIONA__SP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__SP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_SP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.SP_LOL"
			ClientValidationFunction="onValidate_SECTIONA__SP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label99">
		<span class="label" id="label99"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label100">
		<span class="label" id="label100"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_ADL" for="ctl00_cntMainBody_SECTIONA__IS_ADL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_ADL" 
		id="pb-container-checkbox-SECTIONA-IS_ADL">	
		
		<asp:TextBox ID="SECTIONA__IS_ADL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_ADL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_ADL"
			ClientValidationFunction="onValidate_SECTIONA__IS_ADL" 
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
	<span id="pb-container-label-label101">
		<span class="label" id="label101">Accidental Discharge or Leakage from Tanks</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="ADL_LOL" 
		id="pb-container-currency-SECTIONA-ADL_LOL">
		<asp:Label ID="lblSECTIONA_ADL_LOL" runat="server" AssociatedControlID="SECTIONA__ADL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__ADL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_ADL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.ADL_LOL"
			ClientValidationFunction="onValidate_SECTIONA__ADL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label102">
		<span class="label" id="label102"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label103">
		<span class="label" id="label103"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_MD" for="ctl00_cntMainBody_SECTIONA__IS_MD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_MD" 
		id="pb-container-checkbox-SECTIONA-IS_MD">	
		
		<asp:TextBox ID="SECTIONA__IS_MD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_MD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_MD"
			ClientValidationFunction="onValidate_SECTIONA__IS_MD" 
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
	<span id="pb-container-label-label104">
		<span class="label" id="label104">Malicious Damage (as defined)  (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="MD_LOL" 
		id="pb-container-currency-SECTIONA-MD_LOL">
		<asp:Label ID="lblSECTIONA_MD_LOL" runat="server" AssociatedControlID="SECTIONA__MD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__MD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_MD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.MD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__MD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label105">
		<span class="label" id="label105"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label106">
		<span class="label" id="label106"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_TOT" for="ctl00_cntMainBody_SECTIONA__IS_TOT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_TOT" 
		id="pb-container-checkbox-SECTIONA-IS_TOT">	
		
		<asp:TextBox ID="SECTIONA__IS_TOT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_TOT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_TOT"
			ClientValidationFunction="onValidate_SECTIONA__IS_TOT" 
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
	<span id="pb-container-label-label107">
		<span class="label" id="label107">Transit other than (as defined)  (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="TOT_LOL" 
		id="pb-container-currency-SECTIONA-TOT_LOL">
		<asp:Label ID="lblSECTIONA_TOT_LOL" runat="server" AssociatedControlID="SECTIONA__TOT_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__TOT_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_TOT_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.TOT_LOL"
			ClientValidationFunction="onValidate_SECTIONA__TOT_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label108">
		<span class="label" id="label108"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label109">
		<span class="label" id="label109"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_POD" for="ctl00_cntMainBody_SECTIONA__IS_POD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_POD" 
		id="pb-container-checkbox-SECTIONA-IS_POD">	
		
		<asp:TextBox ID="SECTIONA__IS_POD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_POD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_POD"
			ClientValidationFunction="onValidate_SECTIONA__IS_POD" 
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
	<span id="pb-container-label-label110">
		<span class="label" id="label110">Property of Directors or Employees in Transit or on Business</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="POD_LOL" 
		id="pb-container-currency-SECTIONA-POD_LOL">
		<asp:Label ID="lblSECTIONA_POD_LOL" runat="server" AssociatedControlID="SECTIONA__POD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__POD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_POD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.POD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__POD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label111">
		<span class="label" id="label111"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label112">
		<span class="label" id="label112"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_ACD" for="ctl00_cntMainBody_SECTIONA__IS_ACD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_ACD" 
		id="pb-container-checkbox-SECTIONA-IS_ACD">	
		
		<asp:TextBox ID="SECTIONA__IS_ACD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_ACD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_ACD"
			ClientValidationFunction="onValidate_SECTIONA__IS_ACD" 
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
	<span id="pb-container-label-label113">
		<span class="label" id="label113">Accidental Damage (as defined)  (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="ACD_LOL" 
		id="pb-container-currency-SECTIONA-ACD_LOL">
		<asp:Label ID="lblSECTIONA_ACD_LOL" runat="server" AssociatedControlID="SECTIONA__ACD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__ACD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_ACD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.ACD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__ACD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label114">
		<span class="label" id="label114"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label115">
		<span class="label" id="label115"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_TAD" for="ctl00_cntMainBody_SECTIONA__IS_TAD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_TAD" 
		id="pb-container-checkbox-SECTIONA-IS_TAD">	
		
		<asp:TextBox ID="SECTIONA__IS_TAD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_TAD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_TAD"
			ClientValidationFunction="onValidate_SECTIONA__IS_TAD" 
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
	<span id="pb-container-label-label116">
		<span class="label" id="label116">Theft (as defined)  (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="TAD_LOL" 
		id="pb-container-currency-SECTIONA-TAD_LOL">
		<asp:Label ID="lblSECTIONA_TAD_LOL" runat="server" AssociatedControlID="SECTIONA__TAD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__TAD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_TAD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.TAD_LOL"
			ClientValidationFunction="onValidate_SECTIONA__TAD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label117">
		<span class="label" id="label117"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label118">
		<span class="label" id="label118"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_IS_SAL" for="ctl00_cntMainBody_SECTIONA__IS_SAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA" 
		data-property-name="IS_SAL" 
		id="pb-container-checkbox-SECTIONA-IS_SAL">	
		
		<asp:TextBox ID="SECTIONA__IS_SAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_IS_SAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.IS_SAL"
			ClientValidationFunction="onValidate_SECTIONA__IS_SAL" 
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
	<span id="pb-container-label-label119">
		<span class="label" id="label119">Subsidence and Landslip (as defined)  (Property Damage and Business Interruption Limit Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA" 
		data-property-name="SAL_LOL" 
		id="pb-container-currency-SECTIONA-SAL_LOL">
		<asp:Label ID="lblSECTIONA_SAL_LOL" runat="server" AssociatedControlID="SECTIONA__SAL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__SAL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_SAL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.SAL_LOL"
			ClientValidationFunction="onValidate_SECTIONA__SAL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label120">
		<span class="label" id="label120"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label121">
		<span class="label" id="label121"></span>
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
		if ($("#id002f2da772914e88a29a473a6ac3d735 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id002f2da772914e88a29a473a6ac3d735 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id002f2da772914e88a29a473a6ac3d735 div ul li").each(function(){		  
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
			$("#id002f2da772914e88a29a473a6ac3d735 div ul li").each(function(){		  
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
		styleString += "#id002f2da772914e88a29a473a6ac3d735 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id002f2da772914e88a29a473a6ac3d735 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id002f2da772914e88a29a473a6ac3d735 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id002f2da772914e88a29a473a6ac3d735 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id002f2da772914e88a29a473a6ac3d735 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id002f2da772914e88a29a473a6ac3d735 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id002f2da772914e88a29a473a6ac3d735 input{text-align:left;}"; break;
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
<div id="id8b1b29b2a7d0400faa0ac29b88e97cc9" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading43" runat="server" Text="Other Property Damage" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA__OTHPROPDAM"
		data-field-type="Child" 
		data-object-name="SECTIONA" 
		data-property-name="OTHPROPDAM" 
		id="pb-container-childscreen-SECTIONA-OTHPROPDAM">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA__OTH_PROP_PD" runat="server" ScreenCode="OTHPROPDAM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="OTHPROPDAM/OTHPROPDAM_Other_Property_Damage.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_OTHPROPDAM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA.OTHPROPDAM"
						ClientValidationFunction="onValidate_SECTIONA__OTHPROPDAM" 
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
		data-object-name="SECTIONA" 
		data-property-name="OTHPROPDAM_CNT" 
		id="pb-container-integer-SECTIONA-OTHPROPDAM_CNT">
		<asp:Label ID="lblSECTIONA_OTHPROPDAM_CNT" runat="server" AssociatedControlID="SECTIONA__OTHPROPDAM_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONA__OTHPROPDAM_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONA_OTHPROPDAM_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.OTHPROPDAM_CNT"
			ClientValidationFunction="onValidate_SECTIONA__OTHPROPDAM_CNT" 
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
		if ($("#id8b1b29b2a7d0400faa0ac29b88e97cc9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id8b1b29b2a7d0400faa0ac29b88e97cc9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id8b1b29b2a7d0400faa0ac29b88e97cc9 div ul li").each(function(){		  
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
			$("#id8b1b29b2a7d0400faa0ac29b88e97cc9 div ul li").each(function(){		  
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
		styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8b1b29b2a7d0400faa0ac29b88e97cc9 input{text-align:left;}"; break;
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
<div id="idbd6b8714a53245c7bc4ff0f58fe32804" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading44" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label122">
		<span class="label" id="label122"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label123">
		<span class="label" id="label123"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label124">
		<span class="label" id="label124">Limit Of Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label125">
		<span class="label" id="label125"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label126">
		<span class="label" id="label126"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_PAL" for="ctl00_cntMainBody_SECTIONA_EXT__IS_PAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_PAL" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_PAL">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_PAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_PAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_PAL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_PAL" 
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
	<span id="pb-container-label-label127">
		<span class="label" id="label127">Public Authorities Requirements</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="PAR_LOL" 
		id="pb-container-currency-SECTIONA_EXT-PAR_LOL">
		<asp:Label ID="lblSECTIONA_EXT_PAR_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__PAR_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__PAR_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_PAR_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.PAR_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__PAR_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label128">
		<span class="label" id="label128"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label129">
		<span class="label" id="label129"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_PF" for="ctl00_cntMainBody_SECTIONA_EXT__IS_PF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_PF" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_PF">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_PF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_PF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_PF"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_PF" 
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
	<span id="pb-container-label-label130">
		<span class="label" id="label130">Professional Fees</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="PF_LOL" 
		id="pb-container-currency-SECTIONA_EXT-PF_LOL">
		<asp:Label ID="lblSECTIONA_EXT_PF_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__PF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__PF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_PF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.PF_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__PF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label131">
		<span class="label" id="label131"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label132">
		<span class="label" id="label132"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_PSF" for="ctl00_cntMainBody_SECTIONA_EXT__IS_PSF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_PSF" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_PSF">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_PSF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_PSF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_PSF"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_PSF" 
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
	<span id="pb-container-label-label133">
		<span class="label" id="label133">Plans Scrutiny Fees</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="PSF_LOL" 
		id="pb-container-currency-SECTIONA_EXT-PSF_LOL">
		<asp:Label ID="lblSECTIONA_EXT_PSF_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__PSF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__PSF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_PSF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.PSF_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__PSF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label134">
		<span class="label" id="label134"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label135">
		<span class="label" id="label135"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_SD" for="ctl00_cntMainBody_SECTIONA_EXT__IS_SD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_SD" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_SD">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_SD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_SD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_SD"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_SD" 
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
	<span id="pb-container-label-label136">
		<span class="label" id="label136">Statutory Duties</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="SD_LOL" 
		id="pb-container-currency-SECTIONA_EXT-SD_LOL">
		<asp:Label ID="lblSECTIONA_EXT_SD_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__SD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__SD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_SD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.SD_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__SD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label137">
		<span class="label" id="label137"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label138">
		<span class="label" id="label138"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_FPSU" for="ctl00_cntMainBody_SECTIONA_EXT__IS_FPSU" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_FPSU" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_FPSU">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_FPSU" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_FPSU" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_FPSU"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_FPSU" 
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
	<span id="pb-container-label-label139">
		<span class="label" id="label139">Fire Protection System Updating</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="FPSU_LOL" 
		id="pb-container-currency-SECTIONA_EXT-FPSU_LOL">
		<asp:Label ID="lblSECTIONA_EXT_FPSU_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__FPSU_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__FPSU_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_FPSU_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.FPSU_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__FPSU_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label140">
		<span class="label" id="label140"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label141">
		<span class="label" id="label141"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_FERC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_FERC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_FERC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_FERC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_FERC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_FERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_FERC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_FERC" 
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
	<span id="pb-container-label-label142">
		<span class="label" id="label142">Fire Extinguishing Refill Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="FERC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-FERC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_FERC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__FERC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__FERC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_FERC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.FERC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__FERC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label143">
		<span class="label" id="label143"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label144">
		<span class="label" id="label144"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_TMRAL" for="ctl00_cntMainBody_SECTIONA_EXT__IS_TMRAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_TMRAL" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_TMRAL">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_TMRAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_TMRAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_TMRAL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_TMRAL" 
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
	<span id="pb-container-label-label145">
		<span class="label" id="label145">Temporary Measures and Repairs After Loss</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="TMRAL_LOL" 
		id="pb-container-currency-SECTIONA_EXT-TMRAL_LOL">
		<asp:Label ID="lblSECTIONA_EXT_TMRAL_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__TMRAL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__TMRAL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_TMRAL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.TMRAL_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__TMRAL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label146">
		<span class="label" id="label146"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label147">
		<span class="label" id="label147"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_FEPE" for="ctl00_cntMainBody_SECTIONA_EXT__IS_FEPE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_FEPE" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_FEPE">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_FEPE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_FEPE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_FEPE"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_FEPE" 
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
	<span id="pb-container-label-label148">
		<span class="label" id="label148">Fire Extinguishing and Prevention Expenses</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="FEPE_LOL" 
		id="pb-container-currency-SECTIONA_EXT-FEPE_LOL">
		<asp:Label ID="lblSECTIONA_EXT_FEPE_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__FEPE_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__FEPE_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_FEPE_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.FEPE_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__FEPE_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label149">
		<span class="label" id="label149"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label150">
		<span class="label" id="label150"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_CC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_CC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_CC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_CC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_CC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_CC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_CC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_CC" 
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
	<span id="pb-container-label-label151">
		<span class="label" id="label151">Clearance Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="CC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-CC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_CC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__CC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__CC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_CC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.CC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__CC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label152">
		<span class="label" id="label152"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label153">
		<span class="label" id="label153"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_CCN" for="ctl00_cntMainBody_SECTIONA_EXT__IS_CCN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_CCN" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_CCN">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_CCN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_CCN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_CCN"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_CCN" 
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
	<span id="pb-container-label-label154">
		<span class="label" id="label154">Clearance Costs – No Damage to Property Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="CCN_LOL" 
		id="pb-container-currency-SECTIONA_EXT-CCN_LOL">
		<asp:Label ID="lblSECTIONA_EXT_CCN_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__CCN_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__CCN_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_CCN_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.CCN_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__CCN_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label155">
		<span class="label" id="label155"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label156">
		<span class="label" id="label156"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_SOP" for="ctl00_cntMainBody_SECTIONA_EXT__IS_SOP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_SOP" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_SOP">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_SOP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_SOP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_SOP"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_SOP" 
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
	<span id="pb-container-label-label157">
		<span class="label" id="label157">Spoilage of Product</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="SOP_LOL" 
		id="pb-container-currency-SECTIONA_EXT-SOP_LOL">
		<asp:Label ID="lblSECTIONA_EXT_SOP_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__SOP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__SOP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_SOP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.SOP_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__SOP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label158">
		<span class="label" id="label158"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label159">
		<span class="label" id="label159"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_IN" for="ctl00_cntMainBody_SECTIONA_EXT__IS_IN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_IN" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_IN">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_IN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_IN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_IN"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_IN" 
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
	<span id="pb-container-label-label160">
		<span class="label" id="label160">Incompatibility</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IN_LOL" 
		id="pb-container-currency-SECTIONA_EXT-IN_LOL">
		<asp:Label ID="lblSECTIONA_EXT_IN_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__IN_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__IN_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_IN_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IN_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IN_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label161">
		<span class="label" id="label161"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label162">
		<span class="label" id="label162"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_LOR" for="ctl00_cntMainBody_SECTIONA_EXT__IS_LOR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_LOR" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_LOR">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_LOR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_LOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_LOR"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_LOR" 
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
	<span id="pb-container-label-label163">
		<span class="label" id="label163">Loss of Rent</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="LOR_LOL" 
		id="pb-container-currency-SECTIONA_EXT-LOR_LOL">
		<asp:Label ID="lblSECTIONA_EXT_LOR_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__LOR_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__LOR_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_LOR_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.LOR_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__LOR_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label164">
		<span class="label" id="label164"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label165">
		<span class="label" id="label165"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_PITC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_PITC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_PITC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_PITC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_PITC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_PITC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_PITC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_PITC" 
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
	<span id="pb-container-label-label166">
		<span class="label" id="label166">Property in the Course of Construction (combined with Business Interruption)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="PITC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-PITC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_PITC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__PITC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__PITC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_PITC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.PITC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__PITC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label167">
		<span class="label" id="label167"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label168">
		<span class="label" id="label168"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_MVDIV" for="ctl00_cntMainBody_SECTIONA_EXT__IS_MVDIV" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_MVDIV" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_MVDIV">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_MVDIV" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_MVDIV" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_MVDIV"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_MVDIV" 
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
	<span id="pb-container-label-label169">
		<span class="label" id="label169">Motor Vehicle Difference in Value</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="MVDIV_LOL" 
		id="pb-container-currency-SECTIONA_EXT-MVDIV_LOL">
		<asp:Label ID="lblSECTIONA_EXT_MVDIV_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__MVDIV_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__MVDIV_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_MVDIV_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.MVDIV_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__MVDIV_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label170">
		<span class="label" id="label170"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label171">
		<span class="label" id="label171"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_ROD" for="ctl00_cntMainBody_SECTIONA_EXT__IS_ROD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_ROD" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_ROD">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_ROD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_ROD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_ROD"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_ROD" 
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
	<span id="pb-container-label-label172">
		<span class="label" id="label172">Reconstitution of Data (Applicable to Electronic Equipment) </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="ROD_LOL" 
		id="pb-container-currency-SECTIONA_EXT-ROD_LOL">
		<asp:Label ID="lblSECTIONA_EXT_ROD_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__ROD_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__ROD_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_ROD_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.ROD_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__ROD_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label173">
		<span class="label" id="label173"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label174">
		<span class="label" id="label174"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_ILHC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_ILHC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_ILHC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_ILHC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_ILHC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_ILHC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_ILHC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_ILHC" 
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
	<span id="pb-container-label-label175">
		<span class="label" id="label175">Increased Leasing / Hire Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="ILHC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-ILHC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_ILHC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__ILHC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__ILHC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_ILHC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.ILHC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__ILHC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label176">
		<span class="label" id="label176"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label177">
		<span class="label" id="label177"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_TA" for="ctl00_cntMainBody_SECTIONA_EXT__IS_TA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_TA" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_TA">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_TA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_TA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_TA"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_TA" 
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
	<span id="pb-container-label-label178">
		<span class="label" id="label178">Theft / Assault</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="TA_LOL" 
		id="pb-container-currency-SECTIONA_EXT-TA_LOL">
		<asp:Label ID="lblSECTIONA_EXT_TA_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__TA_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__TA_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_TA_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.TA_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__TA_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label179">
		<span class="label" id="label179"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label180">
		<span class="label" id="label180"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_APF" for="ctl00_cntMainBody_SECTIONA_EXT__IS_APF" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_APF" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_APF">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_APF" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_APF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_APF"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_APF" 
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
	<span id="pb-container-label-label181">
		<span class="label" id="label181">Protection Fees</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="APF_LOL" 
		id="pb-container-currency-SECTIONA_EXT-APF_LOL">
		<asp:Label ID="lblSECTIONA_EXT_APF_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__APF_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__APF_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_APF_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.APF_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__APF_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label182">
		<span class="label" id="label182"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label183">
		<span class="label" id="label183"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_FBC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_FBC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_FBC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_FBC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_FBC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_FBC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_FBC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_FBC" 
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
	<span id="pb-container-label-label184">
		<span class="label" id="label184">Fire Brigade Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="FBC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-FBC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_FBC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__FBC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__FBC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_FBC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.FBC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__FBC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label185">
		<span class="label" id="label185"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label186">
		<span class="label" id="label186"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_MBS" for="ctl00_cntMainBody_SECTIONA_EXT__IS_MBS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_MBS" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_MBS">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_MBS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_MBS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_MBS"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_MBS" 
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
	<span id="pb-container-label-label187">
		<span class="label" id="label187">Material Breakout / Solidification</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="MBS_LOL" 
		id="pb-container-currency-SECTIONA_EXT-MBS_LOL">
		<asp:Label ID="lblSECTIONA_EXT_MBS_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__MBS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__MBS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_MBS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.MBS_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__MBS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label188">
		<span class="label" id="label188"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label189">
		<span class="label" id="label189"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_RST" for="ctl00_cntMainBody_SECTIONA_EXT__IS_RST" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_RST" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_RST">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_RST" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_RST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_RST"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_RST" 
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
	<span id="pb-container-label-label190">
		<span class="label" id="label190">Riot and Strike</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="RST_LOL" 
		id="pb-container-currency-SECTIONA_EXT-RST_LOL">
		<asp:Label ID="lblSECTIONA_EXT_RST_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__RST_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__RST_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_RST_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.RST_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__RST_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label191">
		<span class="label" id="label191"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label192">
		<span class="label" id="label192"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_DBT" for="ctl00_cntMainBody_SECTIONA_EXT__IS_DBT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_DBT" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_DBT">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_DBT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_DBT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_DBT"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_DBT" 
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
	<span id="pb-container-label-label193">
		<span class="label" id="label193">Damage by Thieves</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="DBT_LOL" 
		id="pb-container-currency-SECTIONA_EXT-DBT_LOL">
		<asp:Label ID="lblSECTIONA_EXT_DBT_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__DBT_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__DBT_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_DBT_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.DBT_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__DBT_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label194">
		<span class="label" id="label194"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label195">
		<span class="label" id="label195"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_ROK" for="ctl00_cntMainBody_SECTIONA_EXT__IS_ROK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_ROK" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_ROK">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_ROK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_ROK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_ROK"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_ROK" 
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
	<span id="pb-container-label-label196">
		<span class="label" id="label196">Replacement of Keys</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="ROK_LOL" 
		id="pb-container-currency-SECTIONA_EXT-ROK_LOL">
		<asp:Label ID="lblSECTIONA_EXT_ROK_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__ROK_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__ROK_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_ROK_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.ROK_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__ROK_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label197">
		<span class="label" id="label197"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label198">
		<span class="label" id="label198"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_DADFC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_DADFC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_DADFC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_DADFC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_DADFC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_DADFC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_DADFC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_DADFC" 
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
	<span id="pb-container-label-label199">
		<span class="label" id="label199">Demurrage and Dead Freight Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="DADFC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-DADFC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_DADFC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__DADFC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__DADFC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_DADFC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.DADFC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__DADFC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label200">
		<span class="label" id="label200"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label201">
		<span class="label" id="label201"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_WGL" for="ctl00_cntMainBody_SECTIONA_EXT__IS_WGL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_WGL" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_WGL">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_WGL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_WGL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_WGL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_WGL" 
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
	<span id="pb-container-label-label202">
		<span class="label" id="label202">Water / Gas Leakage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="WGL_LOL" 
		id="pb-container-currency-SECTIONA_EXT-WGL_LOL">
		<asp:Label ID="lblSECTIONA_EXT_WGL_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__WGL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__WGL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_WGL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.WGL_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__WGL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label203">
		<span class="label" id="label203"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label204">
		<span class="label" id="label204"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_EC" for="ctl00_cntMainBody_SECTIONA_EXT__IS_EC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_EC" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_EC">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_EC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_EC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_EC"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_EC" 
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
	<span id="pb-container-label-label205">
		<span class="label" id="label205">Expediting Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="EC_LOL" 
		id="pb-container-currency-SECTIONA_EXT-EC_LOL">
		<asp:Label ID="lblSECTIONA_EXT_EC_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__EC_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__EC_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_EC_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.EC_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__EC_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label206">
		<span class="label" id="label206"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label207">
		<span class="label" id="label207"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_ACACS" for="ctl00_cntMainBody_SECTIONA_EXT__IS_ACACS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_ACACS" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_ACACS">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_ACACS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_ACACS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_ACACS"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_ACACS" 
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
	<span id="pb-container-label-label208">
		<span class="label" id="label208">Accidental Contamination and Co-Mingling of Stock</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="ACACS_LOL" 
		id="pb-container-currency-SECTIONA_EXT-ACACS_LOL">
		<asp:Label ID="lblSECTIONA_EXT_ACACS_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__ACACS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__ACACS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_ACACS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.ACACS_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__ACACS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label209">
		<span class="label" id="label209"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label210">
		<span class="label" id="label210"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_GL" for="ctl00_cntMainBody_SECTIONA_EXT__IS_GL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_GL" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_GL">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_GL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_GL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_GL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_GL" 
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
	<span id="pb-container-label-label211">
		<span class="label" id="label211">Glass Reinstatement</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="GL_LOL" 
		id="pb-container-currency-SECTIONA_EXT-GL_LOL">
		<asp:Label ID="lblSECTIONA_EXT_GL_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__GL_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__GL_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_GL_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.GL_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__GL_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label212">
		<span class="label" id="label212"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label213">
		<span class="label" id="label213"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_PGS" for="ctl00_cntMainBody_SECTIONA_EXT__IS_PGS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_PGS" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_PGS">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_PGS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_PGS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_PGS"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_PGS" 
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
	<span id="pb-container-label-label214">
		<span class="label" id="label214">Power / Gas Supply</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="PGS_LOL" 
		id="pb-container-currency-SECTIONA_EXT-PGS_LOL">
		<asp:Label ID="lblSECTIONA_EXT_PGS_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__PGS_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__PGS_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_PGS_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.PGS_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__PGS_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label215">
		<span class="label" id="label215"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label216">
		<span class="label" id="label216"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_TEMP" for="ctl00_cntMainBody_SECTIONA_EXT__IS_TEMP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_TEMP" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_TEMP">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_TEMP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_TEMP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_TEMP"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_TEMP" 
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
	<span id="pb-container-label-label217">
		<span class="label" id="label217">Temperature</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="TEMP_LOL" 
		id="pb-container-currency-SECTIONA_EXT-TEMP_LOL">
		<asp:Label ID="lblSECTIONA_EXT_TEMP_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__TEMP_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__TEMP_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_TEMP_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.TEMP_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__TEMP_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label218">
		<span class="label" id="label218"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label219">
		<span class="label" id="label219"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_EXT_IS_SOMGW" for="ctl00_cntMainBody_SECTIONA_EXT__IS_SOMGW" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="IS_SOMGW" 
		id="pb-container-checkbox-SECTIONA_EXT-IS_SOMGW">	
		
		<asp:TextBox ID="SECTIONA_EXT__IS_SOMGW" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_EXT_IS_SOMGW" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.IS_SOMGW"
			ClientValidationFunction="onValidate_SECTIONA_EXT__IS_SOMGW" 
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
	<span id="pb-container-label-label220">
		<span class="label" id="label220">Supplier's or Manufacturers' Guarantee or Warranty</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="SOMGW_LOL" 
		id="pb-container-currency-SECTIONA_EXT-SOMGW_LOL">
		<asp:Label ID="lblSECTIONA_EXT_SOMGW_LOL" runat="server" AssociatedControlID="SECTIONA_EXT__SOMGW_LOL" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_EXT__SOMGW_LOL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_EXT_SOMGW_LOL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.SOMGW_LOL"
			ClientValidationFunction="onValidate_SECTIONA_EXT__SOMGW_LOL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label221">
		<span class="label" id="label221"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label222">
		<span class="label" id="label222"></span>
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
		if ($("#idbd6b8714a53245c7bc4ff0f58fe32804 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idbd6b8714a53245c7bc4ff0f58fe32804 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idbd6b8714a53245c7bc4ff0f58fe32804 div ul li").each(function(){		  
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
			$("#idbd6b8714a53245c7bc4ff0f58fe32804 div ul li").each(function(){		  
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
		styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbd6b8714a53245c7bc4ff0f58fe32804 input{text-align:left;}"; break;
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
<div id="id41bfbd3f4fc8487a98898dee5e0f418c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading45" runat="server" Text="Other Property Extensions" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA_EXT__OTHPROPEX"
		data-field-type="Child" 
		data-object-name="SECTIONA_EXT" 
		data-property-name="OTHPROPEX" 
		id="pb-container-childscreen-SECTIONA_EXT-OTHPROPEX">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA_EXT__OTH_PROP_EXT" runat="server" ScreenCode="OTHPROPEX" AutoGenerateColumns="false"
							GridLines="None" ChildPage="OTHPROPEX/OTHPROPEX_Other_Property_Extensions.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_EXT_OTHPROPEX" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA_EXT.OTHPROPEX"
						ClientValidationFunction="onValidate_SECTIONA_EXT__OTHPROPEX" 
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
		data-object-name="SECTIONA_EXT" 
		data-property-name="OTHPROPEX_CNT" 
		id="pb-container-integer-SECTIONA_EXT-OTHPROPEX_CNT">
		<asp:Label ID="lblSECTIONA_EXT_OTHPROPEX_CNT" runat="server" AssociatedControlID="SECTIONA_EXT__OTHPROPEX_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONA_EXT__OTHPROPEX_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONA_EXT_OTHPROPEX_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_EXT.OTHPROPEX_CNT"
			ClientValidationFunction="onValidate_SECTIONA_EXT__OTHPROPEX_CNT" 
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
		if ($("#id41bfbd3f4fc8487a98898dee5e0f418c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id41bfbd3f4fc8487a98898dee5e0f418c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id41bfbd3f4fc8487a98898dee5e0f418c div ul li").each(function(){		  
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
			$("#id41bfbd3f4fc8487a98898dee5e0f418c div ul li").each(function(){		  
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
		styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id41bfbd3f4fc8487a98898dee5e0f418c input{text-align:left;}"; break;
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
<div id="id7ade6268463f4c0aae428d8ff8a2a9fd" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading46" runat="server" Text=" Deductibles " /></legend>
				
				
				<div data-column-count="6" data-column-ratio="5:50:10:15:15:5" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label223">
		<span class="label" id="label223"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label224">
		<span class="label" id="label224"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label225">
		<span class="label" id="label225">Ded %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label226">
		<span class="label" id="label226">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label227">
		<span class="label" id="label227">Maximum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_FAAP" for="ctl00_cntMainBody_SECTIONA_DED__IS_FAAP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_FAAP" 
		id="pb-container-checkbox-SECTIONA_DED-IS_FAAP">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_FAAP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_FAAP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_FAAP"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_FAAP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label228">
		<span class="label" id="label228">Fire and Allied Perils</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="FAAP_DED" 
		id="pb-container-percentage-SECTIONA_DED-FAAP_DED">
		<asp:Label ID="lblSECTIONA_DED_FAAP_DED" runat="server" AssociatedControlID="SECTIONA_DED__FAAP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__FAAP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_FAAP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.FAAP_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__FAAP_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="FAAP_MIN" 
		id="pb-container-currency-SECTIONA_DED-FAAP_MIN">
		<asp:Label ID="lblSECTIONA_DED_FAAP_MIN" runat="server" AssociatedControlID="SECTIONA_DED__FAAP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__FAAP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_FAAP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.FAAP_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__FAAP_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="FAAP_MAX" 
		id="pb-container-currency-SECTIONA_DED-FAAP_MAX">
		<asp:Label ID="lblSECTIONA_DED_FAAP_MAX" runat="server" AssociatedControlID="SECTIONA_DED__FAAP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__FAAP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_FAAP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.FAAP_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__FAAP_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_EIP" for="ctl00_cntMainBody_SECTIONA_DED__IS_EIP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_EIP" 
		id="pb-container-checkbox-SECTIONA_DED-IS_EIP">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_EIP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_EIP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_EIP"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_EIP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label229">
		<span class="label" id="label229">Except if prevention measures were not implemented (Infrared thermography, tanks  or electrical rooms up to standards) </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="EIP_DED" 
		id="pb-container-percentage-SECTIONA_DED-EIP_DED">
		<asp:Label ID="lblSECTIONA_DED_EIP_DED" runat="server" AssociatedControlID="SECTIONA_DED__EIP_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__EIP_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_EIP_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.EIP_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__EIP_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="EIP_MIN" 
		id="pb-container-currency-SECTIONA_DED-EIP_MIN">
		<asp:Label ID="lblSECTIONA_DED_EIP_MIN" runat="server" AssociatedControlID="SECTIONA_DED__EIP_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__EIP_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_EIP_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.EIP_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__EIP_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="EIP_MAX" 
		id="pb-container-currency-SECTIONA_DED-EIP_MAX">
		<asp:Label ID="lblSECTIONA_DED_EIP_MAX" runat="server" AssociatedControlID="SECTIONA_DED__EIP_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__EIP_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_EIP_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.EIP_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__EIP_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label230">
		<span class="label" id="label230"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label231">
		<span class="label" id="label231">Money as follows:</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label232">
		<span class="label" id="label232"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label233">
		<span class="label" id="label233"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label234">
		<span class="label" id="label234"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_PAMO" for="ctl00_cntMainBody_SECTIONA_DED__IS_PAMO" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_PAMO" 
		id="pb-container-checkbox-SECTIONA_DED-IS_PAMO">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_PAMO" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_PAMO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_PAMO"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_PAMO" 
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
	<span id="pb-container-label-label235">
		<span class="label" id="label235">Postal and Money Orders</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="PAMO_DED" 
		id="pb-container-percentage-SECTIONA_DED-PAMO_DED">
		<asp:Label ID="lblSECTIONA_DED_PAMO_DED" runat="server" AssociatedControlID="SECTIONA_DED__PAMO_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__PAMO_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PAMO_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PAMO_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__PAMO_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="PAMO_MIN" 
		id="pb-container-currency-SECTIONA_DED-PAMO_MIN">
		<asp:Label ID="lblSECTIONA_DED_PAMO_MIN" runat="server" AssociatedControlID="SECTIONA_DED__PAMO_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__PAMO_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PAMO_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PAMO_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__PAMO_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="PAMO_MAX" 
		id="pb-container-currency-SECTIONA_DED-PAMO_MAX">
		<asp:Label ID="lblSECTIONA_DED_PAMO_MAX" runat="server" AssociatedControlID="SECTIONA_DED__PAMO_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__PAMO_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PAMO_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PAMO_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__PAMO_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_AOLM" for="ctl00_cntMainBody_SECTIONA_DED__IS_AOLM" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_AOLM" 
		id="pb-container-checkbox-SECTIONA_DED-IS_AOLM">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_AOLM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_AOLM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_AOLM"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_AOLM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label236">
		<span class="label" id="label236">Any other Loss of Money</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="AOLM_DED" 
		id="pb-container-percentage-SECTIONA_DED-AOLM_DED">
		<asp:Label ID="lblSECTIONA_DED_AOLM_DED" runat="server" AssociatedControlID="SECTIONA_DED__AOLM_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__AOLM_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AOLM_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AOLM_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__AOLM_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="AOLM_MIN" 
		id="pb-container-currency-SECTIONA_DED-AOLM_MIN">
		<asp:Label ID="lblSECTIONA_DED_AOLM_MIN" runat="server" AssociatedControlID="SECTIONA_DED__AOLM_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AOLM_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AOLM_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AOLM_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__AOLM_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="AOLM_MAX" 
		id="pb-container-currency-SECTIONA_DED-AOLM_MAX">
		<asp:Label ID="lblSECTIONA_DED_AOLM_MAX" runat="server" AssociatedControlID="SECTIONA_DED__AOLM_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AOLM_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AOLM_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AOLM_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__AOLM_MAX" 
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
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_SIL" for="ctl00_cntMainBody_SECTIONA_DED__IS_SIL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_SIL" 
		id="pb-container-checkbox-SECTIONA_DED-IS_SIL">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_SIL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_SIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_SIL"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_SIL" 
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
	<span id="pb-container-label-label237">
		<span class="label" id="label237">Seasonal Increase Limit  </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="SIL_DED" 
		id="pb-container-percentage-SECTIONA_DED-SIL_DED">
		<asp:Label ID="lblSECTIONA_DED_SIL_DED" runat="server" AssociatedControlID="SECTIONA_DED__SIL_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__SIL_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_SIL_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.SIL_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__SIL_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="SIL_MIN" 
		id="pb-container-currency-SECTIONA_DED-SIL_MIN">
		<asp:Label ID="lblSECTIONA_DED_SIL_MIN" runat="server" AssociatedControlID="SECTIONA_DED__SIL_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__SIL_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_SIL_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.SIL_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__SIL_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="SIL_MAX" 
		id="pb-container-currency-SECTIONA_DED-SIL_MAX">
		<asp:Label ID="lblSECTIONA_DED_SIL_MAX" runat="server" AssociatedControlID="SECTIONA_DED__SIL_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__SIL_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_SIL_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.SIL_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__SIL_MAX" 
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
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_DOC" for="ctl00_cntMainBody_SECTIONA_DED__IS_DOC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_DOC" 
		id="pb-container-checkbox-SECTIONA_DED-IS_DOC">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_DOC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_DOC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_DOC"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_DOC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label238">
		<span class="label" id="label238">Documents</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="DOC_DED" 
		id="pb-container-percentage-SECTIONA_DED-DOC_DED">
		<asp:Label ID="lblSECTIONA_DED_DOC_DED" runat="server" AssociatedControlID="SECTIONA_DED__DOC_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__DOC_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_DOC_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.DOC_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__DOC_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="DOC_MIN" 
		id="pb-container-currency-SECTIONA_DED-DOC_MIN">
		<asp:Label ID="lblSECTIONA_DED_DOC_MIN" runat="server" AssociatedControlID="SECTIONA_DED__DOC_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__DOC_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_DOC_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.DOC_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__DOC_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="DOC_MAX" 
		id="pb-container-currency-SECTIONA_DED-DOC_MAX">
		<asp:Label ID="lblSECTIONA_DED_DOC_MAX" runat="server" AssociatedControlID="SECTIONA_DED__DOC_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__DOC_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_DOC_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.DOC_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__DOC_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_PIT" for="ctl00_cntMainBody_SECTIONA_DED__IS_PIT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_PIT" 
		id="pb-container-checkbox-SECTIONA_DED-IS_PIT">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_PIT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_PIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_PIT"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_PIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label239">
		<span class="label" id="label239">Property in Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="PIT_DED" 
		id="pb-container-percentage-SECTIONA_DED-PIT_DED">
		<asp:Label ID="lblSECTIONA_DED_PIT_DED" runat="server" AssociatedControlID="SECTIONA_DED__PIT_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__PIT_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PIT_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PIT_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__PIT_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="PIT_MIN" 
		id="pb-container-currency-SECTIONA_DED-PIT_MIN">
		<asp:Label ID="lblSECTIONA_DED_PIT_MIN" runat="server" AssociatedControlID="SECTIONA_DED__PIT_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__PIT_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PIT_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PIT_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__PIT_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="PIT_MAX" 
		id="pb-container-currency-SECTIONA_DED-PIT_MAX">
		<asp:Label ID="lblSECTIONA_DED_PIT_MAX" runat="server" AssociatedControlID="SECTIONA_DED__PIT_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__PIT_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_PIT_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.PIT_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__PIT_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_AD" for="ctl00_cntMainBody_SECTIONA_DED__IS_AD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_AD" 
		id="pb-container-checkbox-SECTIONA_DED-IS_AD">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_AD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_AD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_AD"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_AD" 
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
	<span id="pb-container-label-label240">
		<span class="label" id="label240">Accidental Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="AD_DED" 
		id="pb-container-percentage-SECTIONA_DED-AD_DED">
		<asp:Label ID="lblSECTIONA_DED_AD_DED" runat="server" AssociatedControlID="SECTIONA_DED__AD_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__AD_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AD_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AD_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__AD_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="AD_MIN" 
		id="pb-container-currency-SECTIONA_DED-AD_MIN">
		<asp:Label ID="lblSECTIONA_DED_AD_MIN" runat="server" AssociatedControlID="SECTIONA_DED__AD_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AD_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AD_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AD_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__AD_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="AD_MAX" 
		id="pb-container-currency-SECTIONA_DED-AD_MAX">
		<asp:Label ID="lblSECTIONA_DED_AD_MAX" runat="server" AssociatedControlID="SECTIONA_DED__AD_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AD_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AD_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AD_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__AD_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_T" for="ctl00_cntMainBody_SECTIONA_DED__IS_T" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_T" 
		id="pb-container-checkbox-SECTIONA_DED-IS_T">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_T" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_T" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_T"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_T" 
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
	<span id="pb-container-label-label241">
		<span class="label" id="label241">Theft</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="T_DED" 
		id="pb-container-percentage-SECTIONA_DED-T_DED">
		<asp:Label ID="lblSECTIONA_DED_T_DED" runat="server" AssociatedControlID="SECTIONA_DED__T_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__T_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_T_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.T_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__T_DED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="T_MIN" 
		id="pb-container-currency-SECTIONA_DED-T_MIN">
		<asp:Label ID="lblSECTIONA_DED_T_MIN" runat="server" AssociatedControlID="SECTIONA_DED__T_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__T_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_T_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.T_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__T_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="T_MAX" 
		id="pb-container-currency-SECTIONA_DED-T_MAX">
		<asp:Label ID="lblSECTIONA_DED_T_MAX" runat="server" AssociatedControlID="SECTIONA_DED__T_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__T_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_T_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.T_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__T_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_G" for="ctl00_cntMainBody_SECTIONA_DED__IS_G" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_G" 
		id="pb-container-checkbox-SECTIONA_DED-IS_G">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_G" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_G" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_G"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_G" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label242">
		<span class="label" id="label242">Glass</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="G_DED" 
		id="pb-container-percentage-SECTIONA_DED-G_DED">
		<asp:Label ID="lblSECTIONA_DED_G_DED" runat="server" AssociatedControlID="SECTIONA_DED__G_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__G_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_G_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.G_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__G_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="G_MIN" 
		id="pb-container-currency-SECTIONA_DED-G_MIN">
		<asp:Label ID="lblSECTIONA_DED_G_MIN" runat="server" AssociatedControlID="SECTIONA_DED__G_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__G_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_G_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.G_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__G_MIN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="SECTIONA_DED" 
		data-property-name="G_MAX" 
		id="pb-container-currency-SECTIONA_DED-G_MAX">
		<asp:Label ID="lblSECTIONA_DED_G_MAX" runat="server" AssociatedControlID="SECTIONA_DED__G_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__G_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_G_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.G_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__G_MAX" 
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
<label id="ctl00_cntMainBody_lblSECTIONA_DED_IS_AL" for="ctl00_cntMainBody_SECTIONA_DED__IS_AL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="SECTIONA_DED" 
		data-property-name="IS_AL" 
		id="pb-container-checkbox-SECTIONA_DED-IS_AL">	
		
		<asp:TextBox ID="SECTIONA_DED__IS_AL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valSECTIONA_DED_IS_AL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.IS_AL"
			ClientValidationFunction="onValidate_SECTIONA_DED__IS_AL" 
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
	<span id="pb-container-label-label243">
		<span class="label" id="label243">All Other</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="SECTIONA_DED" 
		data-property-name="AL_DED" 
		id="pb-container-percentage-SECTIONA_DED-AL_DED">
		<asp:Label ID="lblSECTIONA_DED_AL_DED" runat="server" AssociatedControlID="SECTIONA_DED__AL_DED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="SECTIONA_DED__AL_DED" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AL_DED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AL_DED"
			ClientValidationFunction="onValidate_SECTIONA_DED__AL_DED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="AL_MIN" 
		id="pb-container-currency-SECTIONA_DED-AL_MIN">
		<asp:Label ID="lblSECTIONA_DED_AL_MIN" runat="server" AssociatedControlID="SECTIONA_DED__AL_MIN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AL_MIN" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AL_MIN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AL_MIN"
			ClientValidationFunction="onValidate_SECTIONA_DED__AL_MIN" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="AL_MAX" 
		id="pb-container-currency-SECTIONA_DED-AL_MAX">
		<asp:Label ID="lblSECTIONA_DED_AL_MAX" runat="server" AssociatedControlID="SECTIONA_DED__AL_MAX" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA_DED__AL_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_DED_AL_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.AL_MAX"
			ClientValidationFunction="onValidate_SECTIONA_DED__AL_MAX" 
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
		if ($("#id7ade6268463f4c0aae428d8ff8a2a9fd div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id7ade6268463f4c0aae428d8ff8a2a9fd div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id7ade6268463f4c0aae428d8ff8a2a9fd div ul li").each(function(){		  
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
			$("#id7ade6268463f4c0aae428d8ff8a2a9fd div ul li").each(function(){		  
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
		styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7ade6268463f4c0aae428d8ff8a2a9fd input{text-align:left;}"; break;
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
<div id="Other Property Deductibles" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading47" runat="server" Text="Other Extensions" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA_DED__OTHERPDED"
		data-field-type="Child" 
		data-object-name="SECTIONA_DED" 
		data-property-name="OTHERPDED" 
		id="pb-container-childscreen-SECTIONA_DED-OTHERPDED">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA_DED__OTH_PROP_DED" runat="server" ScreenCode="OTHERPDED" AutoGenerateColumns="false"
							GridLines="None" ChildPage="OTHERPDED/OTHERPDED_Other_Property_Deductibles.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_DED_OTHERPDED" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA_DED.OTHERPDED"
						ClientValidationFunction="onValidate_SECTIONA_DED__OTHERPDED" 
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
		data-object-name="SECTIONA_DED" 
		data-property-name="OTHERPDED_CNT" 
		id="pb-container-integer-SECTIONA_DED-OTHERPDED_CNT">
		<asp:Label ID="lblSECTIONA_DED_OTHERPDED_CNT" runat="server" AssociatedControlID="SECTIONA_DED__OTHERPDED_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONA_DED__OTHERPDED_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONA_DED_OTHERPDED_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA_DED.OTHERPDED_CNT"
			ClientValidationFunction="onValidate_SECTIONA_DED__OTHERPDED_CNT" 
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
		if ($("#Other Property Deductibles div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Other Property Deductibles div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Other Property Deductibles div ul li").each(function(){		  
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
			$("#Other Property Deductibles div ul li").each(function(){		  
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
		styleString += "#Other Property Deductibles label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Other Property Deductibles label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Property Deductibles label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Property Deductibles label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Other Property Deductibles input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Other Property Deductibles input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Other Property Deductibles input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading48" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- StandardWording -->
	<asp:Label ID="lblSECTIONA_SECTIONA_CLAUSES" runat="server" AssociatedControlID="SECTIONA__SECTIONA_CLAUSES" Text="<!-- &LabelCaption -->"></asp:Label>

	

	
		<uc7:SW ID="SECTIONA__SECTIONA_CLAUSES" runat="server" AllowAdd="true" AllowEdit="true" AllowPreview="true" SupportRiskLevel="true" />
	
<!-- /StandardWording -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="SECTIONA" 
		data-property-name="SECTIONA_COUNT" 
		id="pb-container-integer-SECTIONA-SECTIONA_COUNT">
		<asp:Label ID="lblSECTIONA_SECTIONA_COUNT" runat="server" AssociatedControlID="SECTIONA__SECTIONA_COUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONA__SECTIONA_COUNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONA_SECTIONA_COUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.SECTIONA_COUNT"
			ClientValidationFunction="onValidate_SECTIONA__SECTIONA_COUNT" 
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
		data-object-name="SECTIONA" 
		data-property-name="ENDORSE_PREMIUM" 
		id="pb-container-currency-SECTIONA-ENDORSE_PREMIUM">
		<asp:Label ID="lblSECTIONA_ENDORSE_PREMIUM" runat="server" AssociatedControlID="SECTIONA__ENDORSE_PREMIUM" 
			Text="Total Endorsement Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="SECTIONA__ENDORSE_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valSECTIONA_ENDORSE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Endorsement Premium"
			ClientValidationFunction="onValidate_SECTIONA__ENDORSE_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA__PROPEND"
		data-field-type="Child" 
		data-object-name="SECTIONA" 
		data-property-name="PROPEND" 
		id="pb-container-childscreen-SECTIONA-PROPEND">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA__SECTIONA_CLAUSEPREM" runat="server" ScreenCode="PROPEND" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PROPEND/PROPEND_Endorsement_Premium.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_PROPEND" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA.PROPEND"
						ClientValidationFunction="onValidate_SECTIONA__PROPEND" 
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
<div id="id4eeb46362dbd484d8e3b97e7facb99ab" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading49" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA__PROPNOTE"
		data-field-type="Child" 
		data-object-name="SECTIONA" 
		data-property-name="PROPNOTE" 
		id="pb-container-childscreen-SECTIONA-PROPNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA__SECAS_DETAILS" runat="server" ScreenCode="PROPNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PROPNOTE/PROPNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_PROPNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA.PROPNOTE"
						ClientValidationFunction="onValidate_SECTIONA__PROPNOTE" 
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
		if ($("#id4eeb46362dbd484d8e3b97e7facb99ab div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4eeb46362dbd484d8e3b97e7facb99ab div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4eeb46362dbd484d8e3b97e7facb99ab div ul li").each(function(){		  
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
			$("#id4eeb46362dbd484d8e3b97e7facb99ab div ul li").each(function(){		  
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
		styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4eeb46362dbd484d8e3b97e7facb99ab input{text-align:left;}"; break;
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
<div id="id2b701c6b3ec3408ca85a4942e299d9f1" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading50" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_SECTIONA__PROPPNOTE"
		data-field-type="Child" 
		data-object-name="SECTIONA" 
		data-property-name="PROPPNOTE" 
		id="pb-container-childscreen-SECTIONA-PROPPNOTE">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="SECTIONA__SECA_DETAILS" runat="server" ScreenCode="PROPPNOTE" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PROPPNOTE/PROPPNOTE_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valSECTIONA_PROPPNOTE" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for SECTIONA.PROPPNOTE"
						ClientValidationFunction="onValidate_SECTIONA__PROPPNOTE" 
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
		data-object-name="SECTIONA" 
		data-property-name="PROPPNOTE_CNT" 
		id="pb-container-integer-SECTIONA-PROPPNOTE_CNT">
		<asp:Label ID="lblSECTIONA_PROPPNOTE_CNT" runat="server" AssociatedControlID="SECTIONA__PROPPNOTE_CNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="SECTIONA__PROPPNOTE_CNT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valSECTIONA_PROPPNOTE_CNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for SECTIONA.PROPPNOTE_CNT"
			ClientValidationFunction="onValidate_SECTIONA__PROPPNOTE_CNT" 
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
		if ($("#id2b701c6b3ec3408ca85a4942e299d9f1 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id2b701c6b3ec3408ca85a4942e299d9f1 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id2b701c6b3ec3408ca85a4942e299d9f1 div ul li").each(function(){		  
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
			$("#id2b701c6b3ec3408ca85a4942e299d9f1 div ul li").each(function(){		  
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
		styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2b701c6b3ec3408ca85a4942e299d9f1 input{text-align:left;}"; break;
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