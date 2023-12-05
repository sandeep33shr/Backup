<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMALIAB_Referrals.aspx.vb" Inherits="Nexus.PB2_CMALIAB_Referrals" %>

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
function onValidate_REFERRALS__LIABREFER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "LIABREFER", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("true") ? (new Expression("true")) : null;
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
        		var field = Field.getInstance("REFERRALS", "LIABREFER");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'REFERRALS' and property 'LIABREFER'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_REFERRALS__LIABREFER table td a");
        				
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
        		var field = Field.getInstance("REFERRALS", "LIABREFER");
        		var update = function(){
                var links;
        		if (field.getType() == "child_screen"){
        			// Remove the options from the table
        		   links = goog.dom.query("#ctl00_cntMainBody_REFERRALS__LIABREFER table td a");
        				
        		} else {
        		   links = goog.dom.query("a", field.getElement());
        		}		
                var exp = new Expression("true");
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
        /**
         * @fileoverview Renames the matching links found within an element.
         * @param 0 {Expression} Optional when condition, hide is only applied when this is true. If omitted all links are hid.
         * @param 1 {Array} Optional array of captions that specify the same caption as the links to be hidden, this is not case sensitive.
         * HideTableLinks
         */
        (function(){
        	//
        	if (isOnLoad) {	
        		
        		var whenCondition = Expression.isValidParameter("true") ? (new Expression("true")) : null;
        		var oldLinkCaption = "Edit".toLowerCase();
        		var newLinkCaption = "View";
        		var field = Field.getInstance("REFERRALS", "LIABREFER");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_REFERRALS__LIABREFER table td a");
        				
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
}
function onValidate_REFERRALS__RefCount(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "RefCount", "Integer");
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
        			var field = Field.getInstance("REFERRALS", "RefCount");
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
          * @param REFERRALS The Parent (Root) object name.
          * @param REFERRAL_DETAILS.RefCode The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "REFERRALS".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "REFERRAL_DETAILS.RefCode";
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
        		
        		var field = Field.getInstance("REFERRALS", "RefCount");
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
        			
        			var field = Field.getInstance("REFERRALS", "RefCount");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
}
function onValidate_REFERRALS__ISBROKER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "ISBROKER", "TempCheckbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=REFERRALS&propertyName=ISBROKER&name={name}");
        		
        		var value = new Expression("GENERAL.ISBROKER"), 
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
        			var field = Field.getInstance("REFERRALS", "ISBROKER");
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
function onValidate_REFERRALS__ShowHide(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "ShowHide", "TempCheckbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=REFERRALS&propertyName=ShowHide&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("REFERRALS.ISBROKER == 1")) ? new Expression("REFERRALS.ISBROKER == 1") : null, 
        			elseValue = (Expression.isValidParameter("1")) ? new Expression("1") : null;
        		
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
        			var field = Field.getInstance("REFERRALS", "ShowHide");
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
function onValidate_REFERRALS__RequestorComment(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "RequestorComment", "Comment");
        })();
        /**
         * Set the control height
         * SetControlRelativeHeight
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
        			var height = window.parseFloat("2.5");
        			
        			
        			// See if the field implements setHeight
        			var instance = Field.getWithQuery("type=Comment&objectName=REFERRALS&propertyName=RequestorComment&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_REFERRALS__RequestorComment');
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
        			var textarea = document.getElementById('ctl00_cntMainBody_REFERRALS_RequestorComment_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
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
        			field = Field.getInstance("REFERRALS", "RequestorComment");
        		}
        		//window.setProperty(field, "VE", "(REFERRALS.UserLevel   < REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount >  0)", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(REFERRALS.UserLevel   < REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount >  0)",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("REFERRALS.RequestorComment");
        			window.setControlWidth(field, "0.75", "REFERRALS", "RequestorComment");
        		})();
        	}
        })();
}
function onValidate_REFERRALS__ApproverComment(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "ApproverComment", "Comment");
        })();
        /**
         * Set the control height
         * SetControlRelativeHeight
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
        			var height = window.parseFloat("2.5");
        			
        			
        			// See if the field implements setHeight
        			var instance = Field.getWithQuery("type=Comment&objectName=REFERRALS&propertyName=ApproverComment&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_REFERRALS__ApproverComment');
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
        			var textarea = document.getElementById('ctl00_cntMainBody_REFERRALS_ApproverComment_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
        		})();
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("REFERRALS.ApproverComment");
        			window.setControlWidth(field, "0.75", "REFERRALS", "ApproverComment");
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
        			field = Field.getInstance("REFERRALS", "ApproverComment");
        		}
        		//window.setProperty(field, "VE", "(GENERAL.UserLevel    >= REFERRALS.MinimumApprovalLevel) ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(GENERAL.UserLevel    >= REFERRALS.MinimumApprovalLevel) ",
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
function onValidate_REFERRALS__UserLevel(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "UserLevel", "Integer");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Integer&objectName=REFERRALS&propertyName=UserLevel&name={name}");
        		
        		var value = new Expression("GENERAL.UserLevel"), 
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
        			var field = Field.getInstance("REFERRALS", "UserLevel");
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
function onValidate_REFERRALS__MinimumApprovalLevel(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "MinimumApprovalLevel", "Integer");
        })();
        
         /**
          * @fileoverview GetColumn
          * @param REFERRALS The Parent (Root) object name.
          * @param REFERRAL_DETAILS.ReferralApprovalLevel The object.property to sum the totals of.
          * @param MAX The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "REFERRALS".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "REFERRAL_DETAILS.ReferralApprovalLevel";
        		//count, average, total, min, max
        		var type = "MAX".toUpperCase().replace(/^\s+|\s+$/g, '');
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
        		
        		var field = Field.getInstance("REFERRALS", "MinimumApprovalLevel");
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
        			switch ("MAX".toUpperCase()){
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
        			
        			var field = Field.getInstance("REFERRALS", "MinimumApprovalLevel");
        			field.setValue(exp.getValue());
        		}
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
        			var field = Field.getInstance("REFERRALS", "MinimumApprovalLevel");
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
function onValidate_REFERRALS__ShowApprovalButton_Flag(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "ShowApprovalButton_Flag", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=REFERRALS&propertyName=ShowApprovalButton_Flag&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("(REFERRALS.UserLevel   >= REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount > 0)")) ? new Expression("(REFERRALS.UserLevel   >= REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount > 0)") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmApproval The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("REFERRALS","ShowApprovalButton_Flag");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmApproval', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmApproval', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("REFERRALS", "ShowApprovalButton_Flag"), "change", update);
        		update();
        	}
        
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
        			var field = Field.getInstance("REFERRALS", "ShowApprovalButton_Flag");
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
function onValidate_REFERRALS__UnApprovedReferralsCount(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "UnApprovedReferralsCount", "Integer");
        })();
        
         /**
          * @fileoverview GetColumn
          * @param REFERRALS The Parent (Root) object name.
          * @param REFERRAL_DETAILS.RefStatusCode The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param REFERRAL_DETAILS.RefStatusCode ==  'APPREQ' || REFERRAL_DETAILS.RefStatusCode ==  'AWAITAPPRO'  Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "REFERRALS".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "REFERRAL_DETAILS.RefStatusCode";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("REFERRAL_DETAILS.RefStatusCode ==  'APPREQ' || REFERRAL_DETAILS.RefStatusCode ==  'AWAITAPPRO' ")) ? ("REFERRAL_DETAILS.RefStatusCode ==  'APPREQ' || REFERRAL_DETAILS.RefStatusCode ==  'AWAITAPPRO' ") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("REFERRALS", "UnApprovedReferralsCount");
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
        			
        			var field = Field.getInstance("REFERRALS", "UnApprovedReferralsCount");
        			field.setValue(exp.getValue());
        		}
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
        			var field = Field.getInstance("REFERRALS", "UnApprovedReferralsCount");
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
function onValidate_REFERRALS__ShowApprovalRequestButton_Flag(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "REFERRALS", "ShowApprovalRequestButton_Flag", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=REFERRALS&propertyName=ShowApprovalRequestButton_Flag&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("(REFERRALS.UserLevel   < REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount > 0)")) ? new Expression("(REFERRALS.UserLevel   < REFERRALS.MinimumApprovalLevel) && (REFERRALS.UnApprovedReferralsCount > 0)") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmApprovalRequest The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("REFERRALS","ShowApprovalRequestButton_Flag");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmApprovalRequest', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmApprovalRequest', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("REFERRALS", "ShowApprovalRequestButton_Flag"), "change", update);
        		update();
        	}
        
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
        			var field = Field.getInstance("REFERRALS", "ShowApprovalRequestButton_Flag");
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
    onValidate_REFERRALS__LIABREFER(null, null, null, isOnLoad);
    onValidate_REFERRALS__RefCount(null, null, null, isOnLoad);
    onValidate_REFERRALS__ISBROKER(null, null, null, isOnLoad);
    onValidate_REFERRALS__ShowHide(null, null, null, isOnLoad);
    onValidate_REFERRALS__RequestorComment(null, null, null, isOnLoad);
    onValidate_REFERRALS__ApproverComment(null, null, null, isOnLoad);
    onValidate_REFERRALS__UserLevel(null, null, null, isOnLoad);
    onValidate_REFERRALS__MinimumApprovalLevel(null, null, null, isOnLoad);
    onValidate_REFERRALS__ShowApprovalButton_Flag(null, null, null, isOnLoad);
    onValidate_REFERRALS__UnApprovedReferralsCount(null, null, null, isOnLoad);
    onValidate_REFERRALS__ShowApprovalRequestButton_Flag(null, null, null, isOnLoad);
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
<div id="idc7950fe190db45dd8322af4c2b934810" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id9bb1dd562640405b8e4c864691c96c76" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading141" runat="server" Text="Referrals" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_REFERRALS__LIABREFER"
		data-field-type="Child" 
		data-object-name="REFERRALS" 
		data-property-name="LIABREFER" 
		id="pb-container-childscreen-REFERRALS-LIABREFER">
		
		    <legend>Referral Details</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="REFERRALS__REFERRAL_DETAILS" runat="server" ScreenCode="LIABREFER" AutoGenerateColumns="false"
							GridLines="None" ChildPage="LIABREFER/LIABREFER_Referral_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Ref Code" DataField="RefCode" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Reasons" DataField="RefMessage" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Originator" DataField="ReferralOriginName" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Approval Level" DataField="ReferralApprovalLevel" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Date Created" DataField="ReferrralDate" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Time Created" DataField="ReferralTime" DataFormatString=""/>
<Nexus:GISLookupField HeaderText="Status" ListType="PMLookup" ListCode="UDL_REF_STATUS" DataField="RefStatus" DataItemValue="key" />

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
				
					<asp:CustomValidator ID="valREFERRALS_LIABREFER" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Referral Details"
						ClientValidationFunction="onValidate_REFERRALS__LIABREFER" 
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
		data-object-name="REFERRALS" 
		data-property-name="RefCount" 
		id="pb-container-integer-REFERRALS-RefCount">
		<asp:Label ID="lblREFERRALS_RefCount" runat="server" AssociatedControlID="REFERRALS__RefCount" 
			Text="RefCount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="REFERRALS__RefCount" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valREFERRALS_RefCount" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RefCount"
			ClientValidationFunction="onValidate_REFERRALS__RefCount" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="REFERRALS" 
		data-property-name="ISBROKER" 
		id="pb-container-checkbox-REFERRALS-ISBROKER"
	>
		<label id="ctl00_cntMainBody_lblREFERRALS_ISBROKER" for="ctl00_cntMainBody_REFERRALS_ISBROKER_select"></label>
		<input id="ctl00_cntMainBody_REFERRALS_ISBROKER" class="field-medium hidden" />
			<asp:CustomValidator ID="valREFERRALS_ISBROKER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for REFERRALS.ISBROKER"
			ClientValidationFunction="onValidate_REFERRALS__ISBROKER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>

	
<!-- /TempCheckbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="REFERRALS" 
		data-property-name="ShowHide" 
		id="pb-container-checkbox-REFERRALS-ShowHide"
	>
		<label id="ctl00_cntMainBody_lblREFERRALS_ShowHide" for="ctl00_cntMainBody_REFERRALS_ShowHide_select">ShowHide</label>
		<input id="ctl00_cntMainBody_REFERRALS_ShowHide" class="field-medium hidden" />
			<asp:CustomValidator ID="valREFERRALS_ShowHide" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ShowHide"
			ClientValidationFunction="onValidate_REFERRALS__ShowHide" 
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
	(function(){
		var container = document.getElementById('id9bb1dd562640405b8e4c864691c96c76'),
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
		if ($("#id9bb1dd562640405b8e4c864691c96c76 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id9bb1dd562640405b8e4c864691c96c76 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id9bb1dd562640405b8e4c864691c96c76 div ul li").each(function(){		  
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
			$("#id9bb1dd562640405b8e4c864691c96c76 div ul li").each(function(){		  
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
		styleString += "#id9bb1dd562640405b8e4c864691c96c76 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id9bb1dd562640405b8e4c864691c96c76 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9bb1dd562640405b8e4c864691c96c76 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9bb1dd562640405b8e4c864691c96c76 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id9bb1dd562640405b8e4c864691c96c76 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9bb1dd562640405b8e4c864691c96c76 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9bb1dd562640405b8e4c864691c96c76 input{text-align:left;}"; break;
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
<div id="frmApproval" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading142" runat="server" Text="" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer1">
		<span class="label" id="Spacer1"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer2">
		<span class="label" id="Spacer2"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										



<!-- Button -->
     <asp:Button ID="btnSendApproval" runat="server" Text="Approve All Referrals" CssClass="btn btn-sm btn-primary" OnClientClick="clearCookieScrollPos()"/>
	<script type="text/javascript">
		if (window.rulesDisabled){
			document.getElementById('btnSendApproval').style.display = "none";
			
		} 
	</script>
<!-- /Button -->



								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer3">
		<span class="label" id="Spacer3"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer4">
		<span class="label" id="Spacer4"></span>
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
		if ($("#frmApproval div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmApproval div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmApproval div ul li").each(function(){		  
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
			$("#frmApproval div ul li").each(function(){		  
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
		styleString += "#frmApproval label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmApproval label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmApproval label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmApproval label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmApproval input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmApproval input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmApproval input{text-align:left;}"; break;
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
<div id="frmApprovalRequest" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading143" runat="server" Text="" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer5">
		<span class="label" id="Spacer5"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer6">
		<span class="label" id="Spacer6"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										



<!-- Button -->
     <asp:Button ID="btnRequestApproval" runat="server" Text="Request  Referral Approval" CssClass="btn btn-sm btn-primary" OnClientClick="clearCookieScrollPos()"/>
	<script type="text/javascript">
		if (window.rulesDisabled){
			document.getElementById('btnRequestApproval').style.display = "none";
			
		} 
	</script>
<!-- /Button -->



								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer7">
		<span class="label" id="Spacer7"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Spacer8">
		<span class="label" id="Spacer8"></span>
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
		if ($("#frmApprovalRequest div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmApprovalRequest div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmApprovalRequest div ul li").each(function(){		  
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
			$("#frmApprovalRequest div ul li").each(function(){		  
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
		styleString += "#frmApprovalRequest label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmApprovalRequest label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmApprovalRequest label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmApprovalRequest label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmApprovalRequest input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmApprovalRequest input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmApprovalRequest input{text-align:left;}"; break;
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
<div id="id11820ae3012e40759242d88bfbe608d6" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading144" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="REFERRALS" 
		data-property-name="RequestorComment" 
		id="pb-container-comment-REFERRALS-RequestorComment">
		<asp:Label ID="lblREFERRALS_RequestorComment" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="REFERRALS__RequestorComment" 
			Text="Requestor Comment"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="REFERRALS__RequestorComment" runat="server" />
		
		<asp:CustomValidator ID="valREFERRALS_RequestorComment" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Requestor Comment"
			ClientValidationFunction="onValidate_REFERRALS__RequestorComment"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="REFERRALS" 
		data-property-name="ApproverComment" 
		id="pb-container-comment-REFERRALS-ApproverComment">
		<asp:Label ID="lblREFERRALS_ApproverComment" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="REFERRALS__ApproverComment" 
			Text="Approver Comment"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="REFERRALS__ApproverComment" runat="server" />
		
		<asp:CustomValidator ID="valREFERRALS_ApproverComment" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Approver Comment"
			ClientValidationFunction="onValidate_REFERRALS__ApproverComment"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="REFERRALS" 
		data-property-name="UserLevel" 
		id="pb-container-integer-REFERRALS-UserLevel">
		<asp:Label ID="lblREFERRALS_UserLevel" runat="server" AssociatedControlID="REFERRALS__UserLevel" 
			Text="UserLevel" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="REFERRALS__UserLevel" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valREFERRALS_UserLevel" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UserLevel"
			ClientValidationFunction="onValidate_REFERRALS__UserLevel" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="REFERRALS" 
		data-property-name="MinimumApprovalLevel" 
		id="pb-container-integer-REFERRALS-MinimumApprovalLevel">
		<asp:Label ID="lblREFERRALS_MinimumApprovalLevel" runat="server" AssociatedControlID="REFERRALS__MinimumApprovalLevel" 
			Text="MinimumApprovalLevel" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="REFERRALS__MinimumApprovalLevel" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valREFERRALS_MinimumApprovalLevel" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MinimumApprovalLevel"
			ClientValidationFunction="onValidate_REFERRALS__MinimumApprovalLevel" 
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
<label id="ctl00_cntMainBody_lblREFERRALS_ShowApprovalButton_Flag" for="ctl00_cntMainBody_REFERRALS__ShowApprovalButton_Flag" class="col-md-4 col-sm-3 control-label">
		ShowApprovalButton_Flag</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="REFERRALS" 
		data-property-name="ShowApprovalButton_Flag" 
		id="pb-container-checkbox-REFERRALS-ShowApprovalButton_Flag">	
		
		<asp:TextBox ID="REFERRALS__ShowApprovalButton_Flag" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valREFERRALS_ShowApprovalButton_Flag" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ShowApprovalButton_Flag"
			ClientValidationFunction="onValidate_REFERRALS__ShowApprovalButton_Flag" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="REFERRALS" 
		data-property-name="UnApprovedReferralsCount" 
		id="pb-container-integer-REFERRALS-UnApprovedReferralsCount">
		<asp:Label ID="lblREFERRALS_UnApprovedReferralsCount" runat="server" AssociatedControlID="REFERRALS__UnApprovedReferralsCount" 
			Text="UnApprovedReferralsCount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="REFERRALS__UnApprovedReferralsCount" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valREFERRALS_UnApprovedReferralsCount" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UnApprovedReferralsCount"
			ClientValidationFunction="onValidate_REFERRALS__UnApprovedReferralsCount" 
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
<label id="ctl00_cntMainBody_lblREFERRALS_ShowApprovalRequestButton_Flag" for="ctl00_cntMainBody_REFERRALS__ShowApprovalRequestButton_Flag" class="col-md-4 col-sm-3 control-label">
		ShowApprovalRequestButton_Flag</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="REFERRALS" 
		data-property-name="ShowApprovalRequestButton_Flag" 
		id="pb-container-checkbox-REFERRALS-ShowApprovalRequestButton_Flag">	
		
		<asp:TextBox ID="REFERRALS__ShowApprovalRequestButton_Flag" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valREFERRALS_ShowApprovalRequestButton_Flag" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ShowApprovalRequestButton_Flag"
			ClientValidationFunction="onValidate_REFERRALS__ShowApprovalRequestButton_Flag" 
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
		if ($("#id11820ae3012e40759242d88bfbe608d6 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id11820ae3012e40759242d88bfbe608d6 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id11820ae3012e40759242d88bfbe608d6 div ul li").each(function(){		  
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
			$("#id11820ae3012e40759242d88bfbe608d6 div ul li").each(function(){		  
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
		styleString += "#id11820ae3012e40759242d88bfbe608d6 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id11820ae3012e40759242d88bfbe608d6 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id11820ae3012e40759242d88bfbe608d6 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id11820ae3012e40759242d88bfbe608d6 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id11820ae3012e40759242d88bfbe608d6 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id11820ae3012e40759242d88bfbe608d6 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id11820ae3012e40759242d88bfbe608d6 input{text-align:left;}"; break;
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