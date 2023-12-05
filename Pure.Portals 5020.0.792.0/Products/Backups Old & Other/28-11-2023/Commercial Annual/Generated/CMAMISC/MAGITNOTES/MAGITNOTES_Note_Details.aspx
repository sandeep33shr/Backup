﻿<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MAGITNOTES_Note_Details.aspx.vb" Inherits="Nexus.PB2_MAGITNOTES_Note_Details" %>

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
function onValidate_GIT_CNOTE_DETAILS__Date_Created(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Date_Created", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_CNOTE_DETAILS", "Date_Created");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=GIT_CNOTE_DETAILS&propertyName=Date_Created&name={name}");
        		
        		var value = new Expression("NOW"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * DisablePage
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=GIT_CNOTE_DETAILS&propertyName=Date_Created&name={name}");
        		
        		var disablePage = function(disable){
        			disable = !!disable;
        			for (var type in pb.fields.FieldType){
        				if (! pb.fields.FieldType.hasOwnProperty(type))
        					continue;
        					
        				var type = pb.fields.FieldType[type];
        				var fields = Field.fields[type];
        				for (var key in fields){
        					var field = fields[key];
        
        					if (field.getObjectName() == "GIT_CNOTE_DETAILS" && field.getPropertyName() == "Date_Created")
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
        		
        		var condition = (Expression.isValidParameter("GENERAL.CHECK_GITCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')")) ? new Expression("GENERAL.CHECK_GITCode == 'VIEW' && (GENERAL.TRANSACTION_TYPE =='MTA' || GENERAL.TRANSACTION_TYPE =='MTC')") : null;
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
function onValidate_GIT_CNOTE_DETAILS__Time_Created(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Time_Created", "Text");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Text&objectName=GIT_CNOTE_DETAILS&propertyName=Time_Created&name={name}");
        		
        		var value = new Expression("NOW.get2DigitHours() + ':' + NOW.get2DigitMinutes()"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_CNOTE_DETAILS", "Time_Created");
        	field.setReadOnly(true);
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
        			var field = Field.getInstance("GIT_CNOTE_DETAILS", "Time_Created");
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
function onValidate_GIT_CNOTE_DETAILS__Created_By(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Created_By", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_CNOTE_DETAILS", "Created_By");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT_CNOTE_DETAILS__Risk_Cover(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Risk_Cover", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT_CNOTE_DETAILS.Risk_Cover");
        			window.setControlWidth(field, "3", "GIT_CNOTE_DETAILS", "Risk_Cover");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_CNOTE_DETAILS", "Risk_Cover");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Text&objectName=GIT_CNOTE_DETAILS&propertyName=Risk_Cover&name={name}");
        		
        		var value = new Expression("'Goods In Transit'"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_GIT_CNOTE_DETAILS__Note_Subject(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Note_Subject", "Text");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Subject");
        		var errorMessage = "Note Description is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview
         * ReadOnlyWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Subject");
        		var exp = new Expression("GIT_CNOTE_DETAILS.NoteCheck = 1");
        
        		var update = function(){
        			if (exp.getValue() == true){
        				field.setReadOnly(true);
        				field.getElement().blur();
        			} else {
        				field.setReadOnly(false);
        			}
        		};
        		events.listen(exp, "change", update);
        		events.listen(field, "visibilitychange", update);
        		events.listen(field, "displaychange", update);
        		update();
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT_CNOTE_DETAILS.Note_Subject");
        			window.setControlWidth(field, "3", "GIT_CNOTE_DETAILS", "Note_Subject");
        		})();
        	}
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Subject");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
}
function onValidate_GIT_CNOTE_DETAILS__Note_Details(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "Note_Details", "Comment");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Details");
        		var errorMessage = "Details is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Details");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT_CNOTE_DETAILS.Note_Details");
        			window.setControlWidth(field, "3", "GIT_CNOTE_DETAILS", "Note_Details");
        		})();
        	}
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
        			var instance = Field.getWithQuery("type=Comment&objectName=GIT_CNOTE_DETAILS&propertyName=Note_Details&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_GIT_CNOTE_DETAILS__Note_Details');
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
        			var textarea = document.getElementById('ctl00_cntMainBody_GIT_CNOTE_DETAILS_Note_Details_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
        		})();
        	}
        })();
        //$(document).ready(function() {
        	
        	// Setup an instance of the field
        /*		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Details");
        		
        		var blurHandler = function(e){
        			
        			var MaxChars = 4000;
        			var TextString = field.getValue()
        
        			if (TextString.length > MaxChars)
        			{
        				field.setValue(TextString.substring(0,MaxChars));
        				alert("Details has exceeded maximum character length of 4000 characters");
        			}
        			
        		};
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "keyup", blurHandler, false, this);
        		}, this);
        }, false, this);*/
        
        
        $(document).ready(function() {
        
          var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Details");
        
         
        
          var keyupHandler = function() {
            var MaxChars = 4000; 
            var TextString = field.getValue();
        
         
        
            if (TextString.length > MaxChars) {
              field.setValue(TextString.substring(0, MaxChars));
                alert("Details has exceeded maximum character length of 4000 characters");
            }
          };
        
         
        
          var container = field.getElement();
          var inputs = goog.dom.query("input, textarea", container);
        
         
        
          goog.array.forEach(inputs, function(input) {
            goog.events.listen(input, "keyup", keyupHandler);
          });
        });
        /**
         * @fileoverview
         * ReadOnlyWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("GIT_CNOTE_DETAILS", "Note_Details");
        		var exp = new Expression("GIT_CNOTE_DETAILS.NoteCheck = 1");
        
        		var update = function(){
        			if (exp.getValue() == true){
        				field.setReadOnly(true);
        				field.getElement().blur();
        			} else {
        				field.setReadOnly(false);
        			}
        		};
        		events.listen(exp, "change", update);
        		events.listen(field, "visibilitychange", update);
        		events.listen(field, "displaychange", update);
        		update();
        	};
        })();
}
function onValidate_GIT_CNOTE_DETAILS__NoteCheck(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_CNOTE_DETAILS", "NoteCheck", "Checkbox");
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
        			var field = Field.getInstance("GIT_CNOTE_DETAILS", "NoteCheck");
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
    onValidate_GIT_CNOTE_DETAILS__Date_Created(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__Time_Created(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__Created_By(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__Risk_Cover(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__Note_Subject(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__Note_Details(null, null, null, isOnLoad);
    onValidate_GIT_CNOTE_DETAILS__NoteCheck(null, null, null, isOnLoad);
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
<div id="ide094492e0a2f48a1a1df2ae590998893" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idf19a225dee9049699984ad29375f2e0c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading102" runat="server" Text="Note Detail  (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Date_Created" 
		id="pb-container-datejquerycompatible-GIT_CNOTE_DETAILS-Date_Created">
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Date_Created" runat="server" AssociatedControlID="GIT_CNOTE_DETAILS__Date_Created" 
			Text="Date Created" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="GIT_CNOTE_DETAILS__Date_Created" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calGIT_CNOTE_DETAILS__Date_Created" runat="server" LinkedControl="GIT_CNOTE_DETAILS__Date_Created" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Date_Created" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Date Created"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Date_Created" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Text" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Time_Created" 
		id="pb-container-Text-GIT_CNOTE_DETAILS-Time_Created">
		
		
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Time_Created" runat="server" AssociatedControlID="GIT_CNOTE_DETAILS__Time_Created" 
			Text="Time Created" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_CNOTE_DETAILS__Time_Created" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Time_Created" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Time Created"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Time_Created" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			
		
			
		
	</span>
</div>	
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Text" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Created_By" 
		id="pb-container-Text-GIT_CNOTE_DETAILS-Created_By">
		
		
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Created_By" runat="server" AssociatedControlID="GIT_CNOTE_DETAILS__Created_By" 
			Text="Created by" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_CNOTE_DETAILS__Created_By" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Created_By" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Created by"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Created_By" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			
		
			
		
	</span>
</div>	
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Text" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Risk_Cover" 
		id="pb-container-Text-GIT_CNOTE_DETAILS-Risk_Cover">
		
		
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Risk_Cover" runat="server" AssociatedControlID="GIT_CNOTE_DETAILS__Risk_Cover" 
			Text="Cover Type" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_CNOTE_DETAILS__Risk_Cover" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Risk_Cover" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cover Type"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Risk_Cover" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			
		
			
		
	</span>
</div>	
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Text" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Note_Subject" 
		id="pb-container-Text-GIT_CNOTE_DETAILS-Note_Subject">
		
		
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Note_Subject" runat="server" AssociatedControlID="GIT_CNOTE_DETAILS__Note_Subject" 
			Text="Note Description" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_CNOTE_DETAILS__Note_Subject" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Note_Subject" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Note Description"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Note_Subject" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			
		
			
		
	</span>
</div>	
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="Note_Details" 
		id="pb-container-comment-GIT_CNOTE_DETAILS-Note_Details">
		<asp:Label ID="lblGIT_CNOTE_DETAILS_Note_Details" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="GIT_CNOTE_DETAILS__Note_Details" 
			Text="Details"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="GIT_CNOTE_DETAILS__Note_Details" runat="server" />
		
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_Note_Details" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Details"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__Note_Details"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblGIT_CNOTE_DETAILS_NoteCheck" for="ctl00_cntMainBody_GIT_CNOTE_DETAILS__NoteCheck" class="col-md-4 col-sm-3 control-label">
		Check If Note should be editable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="GIT_CNOTE_DETAILS" 
		data-property-name="NoteCheck" 
		id="pb-container-checkbox-GIT_CNOTE_DETAILS-NoteCheck">	
		
		<asp:TextBox ID="GIT_CNOTE_DETAILS__NoteCheck" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valGIT_CNOTE_DETAILS_NoteCheck" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Check If Note should be editable"
			ClientValidationFunction="onValidate_GIT_CNOTE_DETAILS__NoteCheck" 
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
		if ($("#idf19a225dee9049699984ad29375f2e0c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf19a225dee9049699984ad29375f2e0c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf19a225dee9049699984ad29375f2e0c div ul li").each(function(){		  
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
			$("#idf19a225dee9049699984ad29375f2e0c div ul li").each(function(){		  
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
		styleString += "#idf19a225dee9049699984ad29375f2e0c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf19a225dee9049699984ad29375f2e0c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf19a225dee9049699984ad29375f2e0c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf19a225dee9049699984ad29375f2e0c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf19a225dee9049699984ad29375f2e0c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf19a225dee9049699984ad29375f2e0c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf19a225dee9049699984ad29375f2e0c input{text-align:left;}"; break;
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