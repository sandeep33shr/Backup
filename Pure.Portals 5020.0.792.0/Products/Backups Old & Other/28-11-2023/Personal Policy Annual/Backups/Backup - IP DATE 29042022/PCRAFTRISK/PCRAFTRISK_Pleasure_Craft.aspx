<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="PCRAFTRISK_Pleasure_Craft.aspx.vb" Inherits="Nexus.PB2_PCRAFTRISK_Pleasure_Craft" %>

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
function onValidate_PCRAFTRISK__VESSELNAME(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "VESSELNAME", "Comment");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "VESSELNAME");
        		var errorMessage = "Vessel Name is mandatory and must be entered";
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_VESSELNAME");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__VESSELNAME');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__VESSELNAME_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.VESSELNAME");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "VESSELNAME");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__VESSELDESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "VESSELDESC", "Comment");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "VESSELDESC");
        		var errorMessage = "Vessel Description is mandatory and must be entered";
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_VESSELDESC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__VESSELDESC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__VESSELDESC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.VESSELDESC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "VESSELDESC");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__TYPEBOAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "TYPEBOAT", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        		var errorMessage = "Type of Boat is mandatory and must be selected";
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_TYPEBOAT");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__TYPEBOAT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__TYPEBOAT_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.TYPEBOAT");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "TYPEBOAT");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * LoadDefaultsFromUDLToProperties
         */
        //Format used on PB2 HandleDynamicPost:{UDLNAME}{Object.Property,UDL_Columnname}{Object.Property,UDL_Columnname}
         //Cater for different property types
        
        $(document).ready(function () {
            var fieldInstance = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        		
            events.listen(fieldInstance, "change", function(e){		
                var PCRAFTRISK__TYPEBOAT_Value = fieldInstance.getValue();
        		
        		
                if (fieldInstance.getType() == "list")
                {
        			var code = fieldInstance.getCode();
        			
                    if (PCRAFTRISK__TYPEBOAT_Value != "" || PCRAFTRISK__TYPEBOAT_Value != null) {
                        __doPostBack('<%=asyncPanel.ClientID%>', 'PopulateDefaults_PCRAFTRISK_TYPEBOAT' + ',' + "TYPEBOAT" + ',' + code);
                    }
                }
        		
        		  if (fieldInstance.getType() == "checkbox")
                {
        			
                    if (PCRAFTRISK__TYPEBOAT_Value != false) {
                        __doPostBack('<%=asyncPanel.ClientID%>', 'PopulateCheckboxDefaults_PCRAFTRISK_TYPEBOAT' + ',' + "TYPEBOAT");
                    }
                } 
                
        	}, false, this);
        });
        
}
function onValidate_PCRAFTRISK__BOATDESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "BOATDESC", "Comment");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "BOATDESC");
        		}
        		//window.setProperty(field, "VEM", "Code(PCRAFTRISK.TYPEBOAT) == 'X'", "H", "Boat Description is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "Code(PCRAFTRISK.TYPEBOAT) == 'X'",
            paramElseValue = "H",
            paramValidationMessage = "Boat Description is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_BOATDESC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__BOATDESC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__BOATDESC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.BOATDESC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "BOATDESC");
        		})();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        	var thisField = Field.getInstance("PCRAFTRISK","BOATDESC");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_PCRAFTRISK__TYPEUSE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "TYPEUSE", "RateList");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PCRAFTRISK", "TYPEUSE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_TYPEUSE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__TYPEUSE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__TYPEUSE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.TYPEUSE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "TYPEUSE");
        		})();
        	}
        })();
        /**
         * @fileoverview Sets the selected list option by it's code value.
         * SetByCode
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("PCRAFTRISK", "TYPEUSE");
        		
        		// Field must be a list
        		if (field.getType() != "list")
        			throw "SetByCode used on a non list field.";
        		
        		var valueWhen = new ValueWhenHelper(new Expression("1"), (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			if (valueWhen.valueOf() == undefined)
        				return;
        			
        			field.setByCode(valueWhen.valueOf());
        		}, false, this);
        		update();
        		
        		
        	};
        })();
}
function onValidate_PCRAFTRISK__YEARMANUFACTURE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "YEARMANUFACTURE", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "YEARMANUFACTURE");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>''", "V", "Year of Manufacture is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>''",
            paramElseValue = "V",
            paramValidationMessage = "Year of Manufacture is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_YEARMANUFACTURE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__YEARMANUFACTURE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__YEARMANUFACTURE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.YEARMANUFACTURE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "YEARMANUFACTURE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * This rule is the same as ValidWnen, except the error message can be an expression.
         * This cant be incorporated into the ValidWhen rule as all existing error messages would have to be quoted.
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("'Year of Manufacture is invalid. For example 2000'")) ? (new Expression("'Year of Manufacture is invalid. For example 2000'")).valueOf() : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "YEARMANUFACTURE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "YEARMANUFACTURE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("Matches('^[1-2][0-9][0-9][0-9]*$', PCRAFTRISK.YEARMANUFACTURE) || PCRAFTRISK.YEARMANUFACTURE == ''");
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Year of manufacture can't be empty")) ? "Year of manufacture can't be empty" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "YEARMANUFACTURE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "YEARMANUFACTURE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.YEARMANUFACTURE !=''");
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Year of manufacture can't be in the future")) ? "Year of manufacture can't be in the future" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "YEARMANUFACTURE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "YEARMANUFACTURE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.CURRENTYEAR >= PCRAFTRISK.YEARMANUFACTURE");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'YEARMANUFACTURE');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
function onValidate_PCRAFTRISK__SPEEDBOAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "SPEEDBOAT", "Integer");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "SPEEDBOAT");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAXSPEED != 0", "V", "Speed of the Boat is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAXSPEED != 0",
            paramElseValue = "V",
            paramValidationMessage = "Speed of the Boat is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_SPEEDBOAT");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__SPEEDBOAT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__SPEEDBOAT_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.SPEEDBOAT");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "SPEEDBOAT");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Integer&objectName=PCRAFTRISK&propertyName=SPEEDBOAT&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.MAXSPEED == 0")) ? new Expression("PCRAFTRISK.MAXSPEED == 0") : null, 
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
        			var message = (Expression.isValidParameter("Speed is greater than the maximum allowed for the type of boat")) ? "Speed is greater than the maximum allowed for the type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "SPEEDBOAT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "SPEEDBOAT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PCRAFTRISK.MAXSPEED >= PCRAFTRISK.SPEEDBOAT) ||PCRAFTRISK.SPEEDBOAT ==''");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'SPEEDBOAT');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__SPEEDBOAT.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "SPEEDBOAT");
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
        		//-----
        })();
        
        /**
         * @fileoverview
         * Set field to space if zero.
         * ZeroSuppress
         */
        (function(){
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "SPEEDBOAT");
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
function onValidate_PCRAFTRISK__HORSEPOWER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "HORSEPOWER", "Integer");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "HORSEPOWER");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAXHORSEPOWER !=0", "V", "Total Horse Power is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAXHORSEPOWER !=0",
            paramElseValue = "V",
            paramValidationMessage = "Total Horse Power is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_HORSEPOWER");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__HORSEPOWER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__HORSEPOWER_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.HORSEPOWER");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "HORSEPOWER");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'HORSEPOWER');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        		var field = Field.getWithQuery("type=Integer&objectName=PCRAFTRISK&propertyName=HORSEPOWER&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.MAXHORSEPOWER == 0")) ? new Expression("PCRAFTRISK.MAXHORSEPOWER == 0") : null, 
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
        		var field = Field.getInstance("PCRAFTRISK", "HORSEPOWER");
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__HORSEPOWER.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "HORSEPOWER");
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
        		//-----
        })();
        
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Total horse power is greater than the maximum allowed for the type of boat")) ? "Total horse power is greater than the maximum allowed for the type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "HORSEPOWER");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "HORSEPOWER");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PCRAFTRISK.MAXHORSEPOWER >= PCRAFTRISK.HORSEPOWER) ||PCRAFTRISK.HORSEPOWER ==''");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PCRAFTRISK__MOTORVALUE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MOTORVALUE", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "MOTORVALUE");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.IS_MOTORVALUE_REQUIRED== 'Y'", "V", "Motor Value is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.IS_MOTORVALUE_REQUIRED== 'Y'",
            paramElseValue = "V",
            paramValidationMessage = "Motor Value is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MOTORVALUE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MOTORVALUE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MOTORVALUE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MOTORVALUE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MOTORVALUE");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'MOTORVALUE');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__MOTORVALUE.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "MOTORVALUE");
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
        		//-----
        })();
        
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PCRAFTRISK&propertyName=MOTORVALUE&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.IS_MOTORVALUE_REQUIRED== 'N'")) ? new Expression("PCRAFTRISK.IS_MOTORVALUE_REQUIRED== 'N'") : null, 
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
        		var field = Field.getInstance("PCRAFTRISK", "MOTORVALUE");
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
function onValidate_PCRAFTRISK__NUMBERMOTOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "NUMBERMOTOR", "Integer");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "NUMBERMOTOR");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAX_NO_MOTOR != 0", "V", "Number of Motors is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAX_NO_MOTOR != 0",
            paramElseValue = "V",
            paramValidationMessage = "Number of Motors is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_NUMBERMOTOR");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__NUMBERMOTOR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__NUMBERMOTOR_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.NUMBERMOTOR");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "NUMBERMOTOR");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'NUMBERMOTOR');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        		var field = Field.getWithQuery("type=Integer&objectName=PCRAFTRISK&propertyName=NUMBERMOTOR&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.MAX_NO_MOTOR == 0")) ? new Expression("PCRAFTRISK.MAX_NO_MOTOR == 0") : null, 
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
        		var field = Field.getInstance("PCRAFTRISK", "NUMBERMOTOR");
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__NUMBERMOTOR.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "NUMBERMOTOR");
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
        		//-----
        })();
        
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("No of Motors is outside allowable range for the type of boat")) ? "No of Motors is outside allowable range for the type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "NUMBERMOTOR");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "NUMBERMOTOR");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PCRAFTRISK.MAX_NO_MOTOR >= PCRAFTRISK.NUMBERMOTOR)||PCRAFTRISK.NUMBERMOTOR ==null");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PCRAFTRISK__MOTORDESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MOTORDESC", "Comment");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "MOTORDESC");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAX_NO_MOTOR != 0", "V", "Motor Description is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.MAX_NO_MOTOR != 0",
            paramElseValue = "V",
            paramValidationMessage = "Motor Description is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MOTORDESC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MOTORDESC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MOTORDESC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MOTORDESC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MOTORDESC");
        		})();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        	var thisField = Field.getInstance("PCRAFTRISK","MOTORDESC");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_PCRAFTRISK__HULLVALUE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "HULLVALUE", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "HULLVALUE");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.IS_HULLVALUE_REQUIRED == 'Y'", "V", "Hull Value is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.IS_HULLVALUE_REQUIRED == 'Y'",
            paramElseValue = "V",
            paramValidationMessage = "Hull Value is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_HULLVALUE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__HULLVALUE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__HULLVALUE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.HULLVALUE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "HULLVALUE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PCRAFTRISK&propertyName=HULLVALUE&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.IS_HULLVALUE_REQUIRED == 'N'")) ? new Expression("PCRAFTRISK.IS_HULLVALUE_REQUIRED == 'N'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        (()=>{
        
                $('#<%= PCRAFTRISK__HULLVALUE.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "HULLVALUE");
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
        		//-----
        })();
        
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'HULLVALUE');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
function onValidate_PCRAFTRISK__HULL_LENGTH(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "HULL_LENGTH", "Integer");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "HULL_LENGTH");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.LENGHTHULL !=0", "V", "Length of Hull is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.LENGHTHULL !=0",
            paramElseValue = "V",
            paramValidationMessage = "Length of Hull is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_HULL_LENGTH");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__HULL_LENGTH');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__HULL_LENGTH_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.HULL_LENGTH");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "HULL_LENGTH");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'HULL_LENGTH');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        		var field = Field.getWithQuery("type=Integer&objectName=PCRAFTRISK&propertyName=HULL_LENGTH&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.LENGHTHULL == 0")) ? new Expression("PCRAFTRISK.LENGHTHULL == 0") : null, 
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
        		var field = Field.getInstance("PCRAFTRISK", "HULL_LENGTH");
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__HULL_LENGTH.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "HULL_LENGTH");
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
        		//-----
        })();
        
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Length of Hull is outside allowable range for the type of boat")) ? "Length of Hull is outside allowable range for the type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "HULL_LENGTH");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "HULL_LENGTH");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PCRAFTRISK.LENGHTHULL >= PCRAFTRISK.HULL_LENGTH) ||PCRAFTRISK.HULL_LENGTH==null");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PCRAFTRISK__SAIL_VALUE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "SAIL_VALUE", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "SAIL_VALUE");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.IS_SAILVALUE_REQUIRED == 'Y'", "V", "Sail Value is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.IS_SAILVALUE_REQUIRED == 'Y'",
            paramElseValue = "V",
            paramValidationMessage = "Sail Value is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_SAIL_VALUE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__SAIL_VALUE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__SAIL_VALUE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.SAIL_VALUE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "SAIL_VALUE");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'SAIL_VALUE');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        		var field = Field.getWithQuery("type=Currency&objectName=PCRAFTRISK&propertyName=SAIL_VALUE&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.IS_SAILVALUE_REQUIRED == 'N'")) ? new Expression("PCRAFTRISK.IS_SAILVALUE_REQUIRED == 'N'") : null, 
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
        		var field = Field.getInstance("PCRAFTRISK", "SAIL_VALUE");
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__SAIL_VALUE.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "SAIL_VALUE");
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
        		//-----
        })();
        
}
function onValidate_PCRAFTRISK__SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "SUMINSURED");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PCRAFTRISK&propertyName=SUMINSURED&name={name}");
        		
        		var value = new Expression("PCRAFTRISK.SAIL_VALUE + PCRAFTRISK.HULLVALUE  + PCRAFTRISK.MOTORVALUE"), 
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_SUMINSURED");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__SUMINSURED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__SUMINSURED_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.SUMINSURED");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "SUMINSURED");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'SUMINSURED');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        			var message = (Expression.isValidParameter("Total Sum Insured is below the minimum for this type of boat")) ? "Total Sum Insured is below the minimum for this type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "SUMINSURED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "SUMINSURED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.SUMINSURED >= PCRAFTRISK.MIN_SI");
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Total Sum Insured exceeds maximum for this type of boat")) ? "Total Sum Insured exceeds maximum for this type of boat" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "SUMINSURED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "SUMINSURED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.MAX_SI >= PCRAFTRISK.SUMINSURED");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        
        (()=>{
        
                $('#<%= PCRAFTRISK__SUMINSURED.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "SUMINSURED");
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
        		//-----
        })();
        
}
function onValidate_PCRAFTRISK__EXCESSPERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "EXCESSPERC", "Percentage");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "EXCESSPERC");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_EXCESSPERC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__EXCESSPERC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__EXCESSPERC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.EXCESSPERC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "EXCESSPERC");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=PCRAFTRISK&propertyName=EXCESSPERC&name={name}");
        		
        		var value = new Expression("PCRAFTRISK.XSPERC"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.EXCESSPERC < PCRAFTRISK.XSPERC")) ? new Expression("PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.EXCESSPERC < PCRAFTRISK.XSPERC") : null, 
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
        
        			var field = Field.getInstance('PCRAFTRISK', 'EXCESSPERC');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        			var message = (Expression.isValidParameter("Standard excess percentage is below minimum excess percentage")) ? "Standard excess percentage is below minimum excess percentage" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "EXCESSPERC");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "EXCESSPERC");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.EXCESSPERC >= PCRAFTRISK.XSPERC");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PCRAFTRISK", "EXCESSPERC");
        		
        		
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
        			return field.setFormatPattern("00.0000#", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("00.0000#");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        
        (()=>{
        
                $('#<%= PCRAFTRISK__EXCESSPERC.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "EXCESSPERC");
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
        		//-----
        })();
        
}
function onValidate_PCRAFTRISK__EXCESSAMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "EXCESSAMT", "Currency");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "EXCESSAMT");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_EXCESSAMT");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__EXCESSAMT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__EXCESSAMT_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.EXCESSAMT");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "EXCESSAMT");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PCRAFTRISK&propertyName=EXCESSAMT&name={name}");
        		
        		var value = new Expression("PCRAFTRISK.XSAMT"), 
        			condition = (Expression.isValidParameter("PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.EXCESSAMT <PCRAFTRISK.XSAMT ")) ? new Expression("PCRAFTRISK.TYPEBOAT <>'' AND PCRAFTRISK.EXCESSAMT <PCRAFTRISK.XSAMT ") : null, 
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
        			var message = (Expression.isValidParameter("Standard excess amount is below minimum excess amount")) ? "Standard excess amount is below minimum excess amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "EXCESSAMT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "EXCESSAMT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PCRAFTRISK.EXCESSAMT >= PCRAFTRISK.XSAMT");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'EXCESSAMT');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        
        (()=>{
        
                $('#<%= PCRAFTRISK__EXCESSAMT.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "EXCESSAMT");
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
        		//-----
        })();
        
}
function onValidate_PCRAFTRISK__MAXSPEED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MAXSPEED", "Integer");
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
        			var field = Field.getInstance("PCRAFTRISK", "MAXSPEED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MAXSPEED");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MAXSPEED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MAXSPEED_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MAXSPEED");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MAXSPEED");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__MAXHORSEPOWER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MAXHORSEPOWER", "Integer");
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
        			var field = Field.getInstance("PCRAFTRISK", "MAXHORSEPOWER");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MAXHORSEPOWER");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MAXHORSEPOWER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MAXHORSEPOWER_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MAXHORSEPOWER");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MAXHORSEPOWER");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__MAX_NO_MOTOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MAX_NO_MOTOR", "Integer");
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
        			var field = Field.getInstance("PCRAFTRISK", "MAX_NO_MOTOR");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MAX_NO_MOTOR");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MAX_NO_MOTOR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MAX_NO_MOTOR_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MAX_NO_MOTOR");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MAX_NO_MOTOR");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__LENGHTHULL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "LENGHTHULL", "Integer");
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
        			var field = Field.getInstance("PCRAFTRISK", "LENGHTHULL");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_LENGHTHULL");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__LENGHTHULL');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__LENGHTHULL_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.LENGHTHULL");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "LENGHTHULL");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__IS_HULLVALUE_REQUIRED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "IS_HULLVALUE_REQUIRED", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "IS_HULLVALUE_REQUIRED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_IS_HULLVALUE_REQUIRED");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__IS_HULLVALUE_REQUIRED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__IS_HULLVALUE_REQUIRED_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.IS_HULLVALUE_REQUIRED");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "IS_HULLVALUE_REQUIRED");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__IS_MOTORVALUE_REQUIRED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "IS_MOTORVALUE_REQUIRED", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "IS_MOTORVALUE_REQUIRED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_IS_MOTORVALUE_REQUIRED");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__IS_MOTORVALUE_REQUIRED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__IS_MOTORVALUE_REQUIRED_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.IS_MOTORVALUE_REQUIRED");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "IS_MOTORVALUE_REQUIRED");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__IS_SAILVALUE_REQUIRED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "IS_SAILVALUE_REQUIRED", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "IS_SAILVALUE_REQUIRED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_IS_SAILVALUE_REQUIRED");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__IS_SAILVALUE_REQUIRED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__IS_SAILVALUE_REQUIRED_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.IS_SAILVALUE_REQUIRED");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "IS_SAILVALUE_REQUIRED");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__XSPERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "XSPERC", "Percentage");
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
        			var field = Field.getInstance("PCRAFTRISK", "XSPERC");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_XSPERC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__XSPERC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__XSPERC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.XSPERC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "XSPERC");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__XSAMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "XSAMT", "Currency");
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
        			var field = Field.getInstance("PCRAFTRISK", "XSAMT");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_XSAMT");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__XSAMT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__XSAMT_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.XSAMT");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "XSAMT");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__MIN_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MIN_SI", "Currency");
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
        			var field = Field.getInstance("PCRAFTRISK", "MIN_SI");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MIN_SI");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MIN_SI');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MIN_SI_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MIN_SI");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MIN_SI");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__MAX_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "MAX_SI", "Currency");
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
        			var field = Field.getInstance("PCRAFTRISK", "MAX_SI");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_MAX_SI");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__MAX_SI');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__MAX_SI_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.MAX_SI");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "MAX_SI");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__CURRENTYEAR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "CURRENTYEAR", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "CURRENTYEAR");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'CURRENTYEAR');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_CURRENTYEAR");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__CURRENTYEAR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__CURRENTYEAR_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.CURRENTYEAR");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "CURRENTYEAR");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Text&objectName=PCRAFTRISK&propertyName=CURRENTYEAR&name={name}");
        		
        		var value = new Expression("NOW.getYear() + 1900"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PCRAFTRISK__VATNUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "VATNUMBER", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "VATNUMBER");
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
function onValidate_PCRAFTRISK__INDICATOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "INDICATOR", "RateList");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "INDICATOR");
        		var exp = new Expression("PCRAFTRISK.INDICATOR_PERC > 0 AND PCRAFTRISK.REASON <> ''");
        		var errorMessage = "Indicator must be selected if Percentage and Reason is selected";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_INDICATOR");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__INDICATOR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__INDICATOR_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.INDICATOR");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "INDICATOR");
        		})();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        	var thisField = Field.getInstance("PCRAFTRISK","INDICATOR");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_PCRAFTRISK__INDICATORCDE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "INDICATORCDE", "Text");
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
        			var field = Field.getInstance("PCRAFTRISK", "INDICATORCDE");
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
        		var field = Field.getWithQuery("type=Text&objectName=PCRAFTRISK&propertyName=INDICATORCDE&name={name}");
        		
        		var value = new Expression("Code(PCRAFTRISK.INDICATOR)"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PCRAFTRISK__INDICATOR_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "INDICATOR_PERC", "Percentage");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "INDICATOR_PERC");
        		var exp = new Expression("PCRAFTRISK.INDICATOR <> '' AND PCRAFTRISK.REASON <> ''");
        		var errorMessage = "Percentage must be entered if indicator and reason is selected";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_INDICATOR_PERC");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__INDICATOR_PERC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__INDICATOR_PERC_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.INDICATOR_PERC");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "INDICATOR_PERC");
        		})();
        	}
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PCRAFTRISK", "INDICATOR_PERC");
        		
        		
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
        			return field.setFormatPattern("0.00#", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.00#");
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
        
        			var field = Field.getInstance('PCRAFTRISK', 'INDICATOR_PERC');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
         * @fileoverview Evaluate an expression when the field value changes.
         * OnChange
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("PCRAFTRISK", "INDICATOR_PERC");
        		
        		var valueExp = new Expression("PCRAFTRISK.PREMIUM.setValue('')");
        		var whenExp = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
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
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "INDICATOR");
        	var thisField = Field.getInstance("PCRAFTRISK","INDICATOR_PERC");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
        
        (()=>{
        
                $('#<%= PCRAFTRISK__INDICATOR_PERC.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("PCRAFTRISK", "INDICATOR_PERC");
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
        		//-----
        })();
        
}
function onValidate_PCRAFTRISK__REASON(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "REASON", "RateList");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PCRAFTRISK", "REASON");
        		var exp = new Expression("PCRAFTRISK.INDICATOR <> '' AND PCRAFTRISK.INDICATOR_PERC > 0");
        		var errorMessage = "Reason must be selected if indicator and percentage is entered";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_REASON");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__REASON');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__REASON_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.REASON");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "REASON");
        		})();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "INDICATOR");
        	var thisField = Field.getInstance("PCRAFTRISK","REASON");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Loadings/Discounts Indicator, Percentage and Reason must be entered")) ? "Loadings/Discounts Indicator, Percentage and Reason must be entered" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "REASON");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "REASON");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PCRAFTRISK.INDICATOR <> '' AND PCRAFTRISK.INDICATOR_PERC > 0 AND PCRAFTRISK.REASON <>'') OR (PCRAFTRISK.INDICATOR == '' AND PCRAFTRISK.INDICATOR_PERC == null AND PCRAFTRISK.REASON =='') OR ((PCRAFTRISK.INDICATOR <> '' AND PCRAFTRISK.INDICATOR_PERC > 0) OR (PCRAFTRISK.INDICATOR_PERC > 0 AND PCRAFTRISK.REASON <> '') OR (PCRAFTRISK.INDICATOR <> '' AND PCRAFTRISK.REASON <> ''))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PCRAFTRISK__INTERESTEDPTY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "INTERESTEDPTY", "Comment");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "INTERESTEDPTY");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.INTERESTEDDATE != null", "VE", "Interest Party name is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.INTERESTEDDATE != null",
            paramElseValue = "VE",
            paramValidationMessage = "Interest Party name is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_INTERESTEDPTY");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__INTERESTEDPTY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__INTERESTEDPTY_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.INTERESTEDPTY");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "INTERESTEDPTY");
        		})();
        	}
        })();
}
function onValidate_PCRAFTRISK__INTERESTEDDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "INTERESTEDDATE", "Date");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PCRAFTRISK", "INTERESTEDDATE");
        		}
        		//window.setProperty(field, "VEM", "PCRAFTRISK.INTERESTEDPTY != ''", "VE", "Interest Party date is mandatory and date must be entered or date format is invalid");
        
            var paramValue = "VEM",
            paramCondition = "PCRAFTRISK.INTERESTEDPTY != ''",
            paramElseValue = "VE",
            paramValidationMessage = "Interest Party date is mandatory and date must be entered or date format is invalid";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_INTERESTEDDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__INTERESTEDDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__INTERESTEDDATE_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.INTERESTEDDATE");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "INTERESTEDDATE");
        		})();
        	}
        })();
        /**
         * @CheckTime
         *  GENERAL.QUOTEDATE --> Property name with Object.
        			Date value.
            {1} --> Error message to be displayed.
         * Checks if the time entered is valid and also checks if the time is in future or not.	
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(message){
        			
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "__" + "INTERESTEDDATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PCRAFTRISK".toUpperCase() + "_" + "INTERESTEDDATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        var errorMessage = '';
        
        	try
        	{		
        		
        		var dateFieldName = (Expression.isValidParameter("GENERAL.QUOTEDATE")) ? "GENERAL.QUOTEDATE" : null;
        		var dateFieldNameSplit = dateFieldName.split(',');
        		var dateField = Field.getInstance(dateFieldNameSplit[0], dateFieldNameSplit[1]);
        		var dateValue = new Date(dateField.getValue());
        		
        		var timeField = Field.getInstance("PCRAFTRISK", "INTERESTEDDATE");
        		var timeValue = timeField.getValue();
        		if($.trim(timeValue) != '')
        			{
        				var labelTimeElement = timeField.getLabel();
        				var labelTimeText = labelTimeElement.textContent || labelTimeElement.innerHTML || "";
        			
        			
        				
        					if(timeValue < dateValue)
        						{
        							errorMessage = (Expression.isValidParameter("{1}")) ? "{1}" : labelTimeText +' cannot be before the inception date.';
        						}
        				
        			}
        		
        			
        	}
        	catch (e) 
        	{
        			errorMessage = 'Please Enter Valid Date dd/MM/yyyy';			
        	}
        		
        	if(errorMessage.length >0)
        		{	
        			setInvalid(errorMessage);
        		}
        		
        	}
        })();
}
function onValidate_PCRAFTRISK__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PCRAFTRISK", "PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PCRAFTRISK", "PREMIUM");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPCRAFTRISK_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_PCRAFTRISK__PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PCRAFTRISK__PREMIUM_lblFindParty");
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
              var field = Field.getInstance("PCRAFTRISK.PREMIUM");
        			window.setControlWidth(field, "0.7", "PCRAFTRISK", "PREMIUM");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PCRAFTRISK', 'PREMIUM');
        			
        			if (field.setTextAlign){
        				field.setTextAlign("right");
        				return;
        			}
        			
        			if (! (field && field.getInput)) return;
        			
        			var textAlign;
        			switch ("right".toLowerCase()){
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
        $(document).ready(function() {
        	
        	var List = Field.getInstance("PCRAFTRISK", "TYPEBOAT");
        	var thisField = Field.getInstance("PCRAFTRISK","PREMIUM");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function DoLogic(isOnLoad) {
    onValidate_PCRAFTRISK__VESSELNAME(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__VESSELDESC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__TYPEBOAT(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__BOATDESC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__TYPEUSE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__YEARMANUFACTURE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__SPEEDBOAT(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__HORSEPOWER(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MOTORVALUE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__NUMBERMOTOR(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MOTORDESC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__HULLVALUE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__HULL_LENGTH(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__SAIL_VALUE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__SUMINSURED(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__EXCESSPERC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__EXCESSAMT(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MAXSPEED(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MAXHORSEPOWER(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MAX_NO_MOTOR(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__LENGHTHULL(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__IS_HULLVALUE_REQUIRED(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__IS_MOTORVALUE_REQUIRED(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__IS_SAILVALUE_REQUIRED(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__XSPERC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__XSAMT(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MIN_SI(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__MAX_SI(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__CURRENTYEAR(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__VATNUMBER(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__INDICATOR(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__INDICATORCDE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__INDICATOR_PERC(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__REASON(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__INTERESTEDPTY(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__INTERESTEDDATE(null, null, null, isOnLoad);
    onValidate_PCRAFTRISK__PREMIUM(null, null, null, isOnLoad);
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
<div id="id33224aa434e64875866a195f230149a3" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id24794bfcb3264814ac4ee2aa9c8da10a" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading8" runat="server" Text="Vessel Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PCRAFTRISK" 
		data-property-name="VESSELNAME" 
		id="pb-container-comment-PCRAFTRISK-VESSELNAME">
		<asp:Label ID="lblPCRAFTRISK_VESSELNAME" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PCRAFTRISK__VESSELNAME" 
			Text="Vessel Name"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PCRAFTRISK__VESSELNAME" runat="server" />
		
		<asp:CustomValidator ID="valPCRAFTRISK_VESSELNAME" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Vessel Name"
			ClientValidationFunction="onValidate_PCRAFTRISK__VESSELNAME"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PCRAFTRISK" 
		data-property-name="VESSELDESC" 
		id="pb-container-comment-PCRAFTRISK-VESSELDESC">
		<asp:Label ID="lblPCRAFTRISK_VESSELDESC" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PCRAFTRISK__VESSELDESC" 
			Text="Vessel Description"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PCRAFTRISK__VESSELDESC" runat="server" />
		
		<asp:CustomValidator ID="valPCRAFTRISK_VESSELDESC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Vessel Description"
			ClientValidationFunction="onValidate_PCRAFTRISK__VESSELDESC"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PCRAFTRISK" 
		data-property-name="TYPEBOAT" 
		id="pb-container-list-PCRAFTRISK-TYPEBOAT">
		<asp:Label ID="lblPCRAFTRISK_TYPEBOAT" runat="server" AssociatedControlID="PCRAFTRISK__TYPEBOAT" 
			Text="Type of Boat" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PCRAFTRISK__TYPEBOAT" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_KBOATTYP" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PCRAFTRISK__TYPEBOAT(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPCRAFTRISK_TYPEBOAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Type of Boat"
			ClientValidationFunction="onValidate_PCRAFTRISK__TYPEBOAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PCRAFTRISK" 
		data-property-name="BOATDESC" 
		id="pb-container-comment-PCRAFTRISK-BOATDESC">
		<asp:Label ID="lblPCRAFTRISK_BOATDESC" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PCRAFTRISK__BOATDESC" 
			Text="Boat Description"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PCRAFTRISK__BOATDESC" runat="server" />
		
		<asp:CustomValidator ID="valPCRAFTRISK_BOATDESC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Boat Description"
			ClientValidationFunction="onValidate_PCRAFTRISK__BOATDESC"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PCRAFTRISK" 
		data-property-name="TYPEUSE" 
		id="pb-container-list-PCRAFTRISK-TYPEUSE">
		<asp:Label ID="lblPCRAFTRISK_TYPEUSE" runat="server" AssociatedControlID="PCRAFTRISK__TYPEUSE" 
			Text="Type of Use" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PCRAFTRISK__TYPEUSE" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="KTYPEUSE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PCRAFTRISK__TYPEUSE(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPCRAFTRISK_TYPEUSE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Type of Use"
			ClientValidationFunction="onValidate_PCRAFTRISK__TYPEUSE" 
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="YEARMANUFACTURE" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-YEARMANUFACTURE">

		
		<asp:Label ID="lblPCRAFTRISK_YEARMANUFACTURE" runat="server" AssociatedControlID="PCRAFTRISK__YEARMANUFACTURE" 
			Text="Year of  Manufacture" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__YEARMANUFACTURE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_YEARMANUFACTURE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Year of  Manufacture"
					ClientValidationFunction="onValidate_PCRAFTRISK__YEARMANUFACTURE"
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
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="SPEEDBOAT" 
		id="pb-container-integer-PCRAFTRISK-SPEEDBOAT">
		<asp:Label ID="lblPCRAFTRISK_SPEEDBOAT" runat="server" AssociatedControlID="PCRAFTRISK__SPEEDBOAT" 
			Text="Speed of the Boat" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__SPEEDBOAT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_SPEEDBOAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Speed of the Boat"
			ClientValidationFunction="onValidate_PCRAFTRISK__SPEEDBOAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="HORSEPOWER" 
		id="pb-container-integer-PCRAFTRISK-HORSEPOWER">
		<asp:Label ID="lblPCRAFTRISK_HORSEPOWER" runat="server" AssociatedControlID="PCRAFTRISK__HORSEPOWER" 
			Text="Total Horse Power" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__HORSEPOWER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_HORSEPOWER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Horse Power"
			ClientValidationFunction="onValidate_PCRAFTRISK__HORSEPOWER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PCRAFTRISK" 
		data-property-name="MOTORVALUE" 
		id="pb-container-currency-PCRAFTRISK-MOTORVALUE">
		<asp:Label ID="lblPCRAFTRISK_MOTORVALUE" runat="server" AssociatedControlID="PCRAFTRISK__MOTORVALUE" 
			Text="Motor Value" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__MOTORVALUE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_MOTORVALUE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Motor Value"
			ClientValidationFunction="onValidate_PCRAFTRISK__MOTORVALUE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="NUMBERMOTOR" 
		id="pb-container-integer-PCRAFTRISK-NUMBERMOTOR">
		<asp:Label ID="lblPCRAFTRISK_NUMBERMOTOR" runat="server" AssociatedControlID="PCRAFTRISK__NUMBERMOTOR" 
			Text="Number of Motors" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__NUMBERMOTOR" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_NUMBERMOTOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Number of Motors"
			ClientValidationFunction="onValidate_PCRAFTRISK__NUMBERMOTOR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PCRAFTRISK" 
		data-property-name="MOTORDESC" 
		id="pb-container-comment-PCRAFTRISK-MOTORDESC">
		<asp:Label ID="lblPCRAFTRISK_MOTORDESC" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PCRAFTRISK__MOTORDESC" 
			Text="Motor Description"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PCRAFTRISK__MOTORDESC" runat="server" />
		
		<asp:CustomValidator ID="valPCRAFTRISK_MOTORDESC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Motor Description"
			ClientValidationFunction="onValidate_PCRAFTRISK__MOTORDESC"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PCRAFTRISK" 
		data-property-name="HULLVALUE" 
		id="pb-container-currency-PCRAFTRISK-HULLVALUE">
		<asp:Label ID="lblPCRAFTRISK_HULLVALUE" runat="server" AssociatedControlID="PCRAFTRISK__HULLVALUE" 
			Text="Hull Value" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__HULLVALUE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_HULLVALUE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Hull Value"
			ClientValidationFunction="onValidate_PCRAFTRISK__HULLVALUE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="HULL_LENGTH" 
		id="pb-container-integer-PCRAFTRISK-HULL_LENGTH">
		<asp:Label ID="lblPCRAFTRISK_HULL_LENGTH" runat="server" AssociatedControlID="PCRAFTRISK__HULL_LENGTH" 
			Text="Length of Hull" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__HULL_LENGTH" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_HULL_LENGTH" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Length of Hull"
			ClientValidationFunction="onValidate_PCRAFTRISK__HULL_LENGTH" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PCRAFTRISK" 
		data-property-name="SAIL_VALUE" 
		id="pb-container-currency-PCRAFTRISK-SAIL_VALUE">
		<asp:Label ID="lblPCRAFTRISK_SAIL_VALUE" runat="server" AssociatedControlID="PCRAFTRISK__SAIL_VALUE" 
			Text="Sail Value" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__SAIL_VALUE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_SAIL_VALUE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sail Value"
			ClientValidationFunction="onValidate_PCRAFTRISK__SAIL_VALUE" 
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
		data-object-name="PCRAFTRISK" 
		data-property-name="SUMINSURED" 
		id="pb-container-currency-PCRAFTRISK-SUMINSURED">
		<asp:Label ID="lblPCRAFTRISK_SUMINSURED" runat="server" AssociatedControlID="PCRAFTRISK__SUMINSURED" 
			Text="Total Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Sum Insured"
			ClientValidationFunction="onValidate_PCRAFTRISK__SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label0">
		<span class="label" id="label0"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PCRAFTRISK" 
		data-property-name="EXCESSPERC" 
		id="pb-container-percentage-PCRAFTRISK-EXCESSPERC">
		<asp:Label ID="lblPCRAFTRISK_EXCESSPERC" runat="server" AssociatedControlID="PCRAFTRISK__EXCESSPERC" 
			Text="Excess percentage" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PCRAFTRISK__EXCESSPERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPCRAFTRISK_EXCESSPERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Excess percentage"
			ClientValidationFunction="onValidate_PCRAFTRISK__EXCESSPERC" 
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
		data-object-name="PCRAFTRISK" 
		data-property-name="EXCESSAMT" 
		id="pb-container-currency-PCRAFTRISK-EXCESSAMT">
		<asp:Label ID="lblPCRAFTRISK_EXCESSAMT" runat="server" AssociatedControlID="PCRAFTRISK__EXCESSAMT" 
			Text="Excess amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__EXCESSAMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_EXCESSAMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Excess amount"
			ClientValidationFunction="onValidate_PCRAFTRISK__EXCESSAMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="MAXSPEED" 
		id="pb-container-integer-PCRAFTRISK-MAXSPEED">
		<asp:Label ID="lblPCRAFTRISK_MAXSPEED" runat="server" AssociatedControlID="PCRAFTRISK__MAXSPEED" 
			Text="Maximum Speed" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__MAXSPEED" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_MAXSPEED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Maximum Speed"
			ClientValidationFunction="onValidate_PCRAFTRISK__MAXSPEED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="MAXHORSEPOWER" 
		id="pb-container-integer-PCRAFTRISK-MAXHORSEPOWER">
		<asp:Label ID="lblPCRAFTRISK_MAXHORSEPOWER" runat="server" AssociatedControlID="PCRAFTRISK__MAXHORSEPOWER" 
			Text="Maximum Horse Power" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__MAXHORSEPOWER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_MAXHORSEPOWER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Maximum Horse Power"
			ClientValidationFunction="onValidate_PCRAFTRISK__MAXHORSEPOWER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="MAX_NO_MOTOR" 
		id="pb-container-integer-PCRAFTRISK-MAX_NO_MOTOR">
		<asp:Label ID="lblPCRAFTRISK_MAX_NO_MOTOR" runat="server" AssociatedControlID="PCRAFTRISK__MAX_NO_MOTOR" 
			Text="Maximum Number of Motors" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__MAX_NO_MOTOR" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_MAX_NO_MOTOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Maximum Number of Motors"
			ClientValidationFunction="onValidate_PCRAFTRISK__MAX_NO_MOTOR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="PCRAFTRISK" 
		data-property-name="LENGHTHULL" 
		id="pb-container-integer-PCRAFTRISK-LENGHTHULL">
		<asp:Label ID="lblPCRAFTRISK_LENGHTHULL" runat="server" AssociatedControlID="PCRAFTRISK__LENGHTHULL" 
			Text="Default Length of Hull" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="PCRAFTRISK__LENGHTHULL" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valPCRAFTRISK_LENGHTHULL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Default Length of Hull"
			ClientValidationFunction="onValidate_PCRAFTRISK__LENGHTHULL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PCRAFTRISK" 
		data-property-name="IS_HULLVALUE_REQUIRED" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-IS_HULLVALUE_REQUIRED">

		
		<asp:Label ID="lblPCRAFTRISK_IS_HULLVALUE_REQUIRED" runat="server" AssociatedControlID="PCRAFTRISK__IS_HULLVALUE_REQUIRED" 
			Text="Hull Value Required" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__IS_HULLVALUE_REQUIRED" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_IS_HULLVALUE_REQUIRED" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Hull Value Required"
					ClientValidationFunction="onValidate_PCRAFTRISK__IS_HULLVALUE_REQUIRED"
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="IS_MOTORVALUE_REQUIRED" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-IS_MOTORVALUE_REQUIRED">

		
		<asp:Label ID="lblPCRAFTRISK_IS_MOTORVALUE_REQUIRED" runat="server" AssociatedControlID="PCRAFTRISK__IS_MOTORVALUE_REQUIRED" 
			Text="Motor Value Required" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__IS_MOTORVALUE_REQUIRED" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_IS_MOTORVALUE_REQUIRED" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Motor Value Required"
					ClientValidationFunction="onValidate_PCRAFTRISK__IS_MOTORVALUE_REQUIRED"
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="IS_SAILVALUE_REQUIRED" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-IS_SAILVALUE_REQUIRED">

		
		<asp:Label ID="lblPCRAFTRISK_IS_SAILVALUE_REQUIRED" runat="server" AssociatedControlID="PCRAFTRISK__IS_SAILVALUE_REQUIRED" 
			Text="Sail Value Required" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__IS_SAILVALUE_REQUIRED" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_IS_SAILVALUE_REQUIRED" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Sail Value Required"
					ClientValidationFunction="onValidate_PCRAFTRISK__IS_SAILVALUE_REQUIRED"
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
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PCRAFTRISK" 
		data-property-name="XSPERC" 
		id="pb-container-percentage-PCRAFTRISK-XSPERC">
		<asp:Label ID="lblPCRAFTRISK_XSPERC" runat="server" AssociatedControlID="PCRAFTRISK__XSPERC" 
			Text="Default Excess Percentage" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PCRAFTRISK__XSPERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPCRAFTRISK_XSPERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Default Excess Percentage"
			ClientValidationFunction="onValidate_PCRAFTRISK__XSPERC" 
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
		data-object-name="PCRAFTRISK" 
		data-property-name="XSAMT" 
		id="pb-container-currency-PCRAFTRISK-XSAMT">
		<asp:Label ID="lblPCRAFTRISK_XSAMT" runat="server" AssociatedControlID="PCRAFTRISK__XSAMT" 
			Text="Default Excess Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__XSAMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_XSAMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Default Excess Amount"
			ClientValidationFunction="onValidate_PCRAFTRISK__XSAMT" 
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
		data-object-name="PCRAFTRISK" 
		data-property-name="MIN_SI" 
		id="pb-container-currency-PCRAFTRISK-MIN_SI">
		<asp:Label ID="lblPCRAFTRISK_MIN_SI" runat="server" AssociatedControlID="PCRAFTRISK__MIN_SI" 
			Text="Default Minimum Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__MIN_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_MIN_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Default Minimum Sum Insured"
			ClientValidationFunction="onValidate_PCRAFTRISK__MIN_SI" 
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
		data-object-name="PCRAFTRISK" 
		data-property-name="MAX_SI" 
		id="pb-container-currency-PCRAFTRISK-MAX_SI">
		<asp:Label ID="lblPCRAFTRISK_MAX_SI" runat="server" AssociatedControlID="PCRAFTRISK__MAX_SI" 
			Text="Default Maximum Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__MAX_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_MAX_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Default Maximum Sum Insured"
			ClientValidationFunction="onValidate_PCRAFTRISK__MAX_SI" 
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="CURRENTYEAR" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-CURRENTYEAR">

		
		<asp:Label ID="lblPCRAFTRISK_CURRENTYEAR" runat="server" AssociatedControlID="PCRAFTRISK__CURRENTYEAR" 
			Text="Current Year" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__CURRENTYEAR" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_CURRENTYEAR" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Current Year"
					ClientValidationFunction="onValidate_PCRAFTRISK__CURRENTYEAR"
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="VATNUMBER" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-VATNUMBER">

		
		<asp:Label ID="lblPCRAFTRISK_VATNUMBER" runat="server" AssociatedControlID="PCRAFTRISK__VATNUMBER" 
			Text="Vat Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__VATNUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_VATNUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Vat Number"
					ClientValidationFunction="onValidate_PCRAFTRISK__VATNUMBER"
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
		if ($("#id24794bfcb3264814ac4ee2aa9c8da10a div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id24794bfcb3264814ac4ee2aa9c8da10a div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id24794bfcb3264814ac4ee2aa9c8da10a div ul li").each(function(){		  
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
			$("#id24794bfcb3264814ac4ee2aa9c8da10a div ul li").each(function(){		  
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
		styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id24794bfcb3264814ac4ee2aa9c8da10a input{text-align:left;}"; break;
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
<div id="id63881eeb60054514a89e4e3a7f1a2846" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading9" runat="server" Text="Premium Load/Discount" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PCRAFTRISK" 
		data-property-name="INDICATOR" 
		id="pb-container-list-PCRAFTRISK-INDICATOR">
		<asp:Label ID="lblPCRAFTRISK_INDICATOR" runat="server" AssociatedControlID="PCRAFTRISK__INDICATOR" 
			Text="Loading/Discount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PCRAFTRISK__INDICATOR" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="LOADDIND" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PCRAFTRISK__INDICATOR(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPCRAFTRISK_INDICATOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Loading/Discount"
			ClientValidationFunction="onValidate_PCRAFTRISK__INDICATOR" 
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
		
		data-object-name="PCRAFTRISK" 
		data-property-name="INDICATORCDE" 
		 
		
		 
		id="pb-container-text-PCRAFTRISK-INDICATORCDE">

		
		<asp:Label ID="lblPCRAFTRISK_INDICATORCDE" runat="server" AssociatedControlID="PCRAFTRISK__INDICATORCDE" 
			Text="Indicator Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PCRAFTRISK__INDICATORCDE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPCRAFTRISK_INDICATORCDE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Indicator Code"
					ClientValidationFunction="onValidate_PCRAFTRISK__INDICATORCDE"
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
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PCRAFTRISK" 
		data-property-name="INDICATOR_PERC" 
		id="pb-container-percentage-PCRAFTRISK-INDICATOR_PERC">
		<asp:Label ID="lblPCRAFTRISK_INDICATOR_PERC" runat="server" AssociatedControlID="PCRAFTRISK__INDICATOR_PERC" 
			Text="Percentage" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PCRAFTRISK__INDICATOR_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPCRAFTRISK_INDICATOR_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Percentage"
			ClientValidationFunction="onValidate_PCRAFTRISK__INDICATOR_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PCRAFTRISK" 
		data-property-name="REASON" 
		id="pb-container-list-PCRAFTRISK-REASON">
		<asp:Label ID="lblPCRAFTRISK_REASON" runat="server" AssociatedControlID="PCRAFTRISK__REASON" 
			Text="Reason" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PCRAFTRISK__REASON" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="LOADDISC" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PCRAFTRISK__REASON(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPCRAFTRISK_REASON" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Reason"
			ClientValidationFunction="onValidate_PCRAFTRISK__REASON" 
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
		if ($("#id63881eeb60054514a89e4e3a7f1a2846 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id63881eeb60054514a89e4e3a7f1a2846 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id63881eeb60054514a89e4e3a7f1a2846 div ul li").each(function(){		  
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
			$("#id63881eeb60054514a89e4e3a7f1a2846 div ul li").each(function(){		  
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
		styleString += "#id63881eeb60054514a89e4e3a7f1a2846 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id63881eeb60054514a89e4e3a7f1a2846 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id63881eeb60054514a89e4e3a7f1a2846 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id63881eeb60054514a89e4e3a7f1a2846 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id63881eeb60054514a89e4e3a7f1a2846 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id63881eeb60054514a89e4e3a7f1a2846 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id63881eeb60054514a89e4e3a7f1a2846 input{text-align:left;}"; break;
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
<div id="id77d319e9b23a4d3e96959571c39b8e17" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading10" runat="server" Text="Interest Party" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PCRAFTRISK" 
		data-property-name="INTERESTEDPTY" 
		id="pb-container-comment-PCRAFTRISK-INTERESTEDPTY">
		<asp:Label ID="lblPCRAFTRISK_INTERESTEDPTY" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PCRAFTRISK__INTERESTEDPTY" 
			Text="Name"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PCRAFTRISK__INTERESTEDPTY" runat="server" />
		
		<asp:CustomValidator ID="valPCRAFTRISK_INTERESTEDPTY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Name"
			ClientValidationFunction="onValidate_PCRAFTRISK__INTERESTEDPTY"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="PCRAFTRISK" 
		data-property-name="INTERESTEDDATE" 
		id="pb-container-datejquerycompatible-PCRAFTRISK-INTERESTEDDATE">
		<asp:Label ID="lblPCRAFTRISK_INTERESTEDDATE" runat="server" AssociatedControlID="PCRAFTRISK__INTERESTEDDATE" 
			Text="Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="PCRAFTRISK__INTERESTEDDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calPCRAFTRISK__INTERESTEDDATE" runat="server" LinkedControl="PCRAFTRISK__INTERESTEDDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valPCRAFTRISK_INTERESTEDDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Date"
			ClientValidationFunction="onValidate_PCRAFTRISK__INTERESTEDDATE" 
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
		if ($("#id77d319e9b23a4d3e96959571c39b8e17 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id77d319e9b23a4d3e96959571c39b8e17 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id77d319e9b23a4d3e96959571c39b8e17 div ul li").each(function(){		  
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
			$("#id77d319e9b23a4d3e96959571c39b8e17 div ul li").each(function(){		  
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
		styleString += "#id77d319e9b23a4d3e96959571c39b8e17 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id77d319e9b23a4d3e96959571c39b8e17 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id77d319e9b23a4d3e96959571c39b8e17 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id77d319e9b23a4d3e96959571c39b8e17 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id77d319e9b23a4d3e96959571c39b8e17 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id77d319e9b23a4d3e96959571c39b8e17 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id77d319e9b23a4d3e96959571c39b8e17 input{text-align:left;}"; break;
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
<div id="id2962ebf2af6b4aafa4bd817e02e4fb79" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading11" runat="server" Text="Premium Section" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PCRAFTRISK" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-PCRAFTRISK-PREMIUM">
		<asp:Label ID="lblPCRAFTRISK_PREMIUM" runat="server" AssociatedControlID="PCRAFTRISK__PREMIUM" 
			Text="Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PCRAFTRISK__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPCRAFTRISK_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Premium"
			ClientValidationFunction="onValidate_PCRAFTRISK__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										



<!-- Button -->
     <asp:Button ID="btnPCraftCalculate" runat="server" Text="Calculate Premium" CssClass="btn btn-sm btn-primary" OnClientClick="clearCookieScrollPos()"/>
	<script type="text/javascript">
		if (window.rulesDisabled){
			document.getElementById('btnPCraftCalculate').style.display = "none";
			
		} 
	</script>
<!-- /Button -->



								
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
		if ($("#id2962ebf2af6b4aafa4bd817e02e4fb79 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id2962ebf2af6b4aafa4bd817e02e4fb79 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id2962ebf2af6b4aafa4bd817e02e4fb79 div ul li").each(function(){		  
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
			$("#id2962ebf2af6b4aafa4bd817e02e4fb79 div ul li").each(function(){		  
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
		styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id2962ebf2af6b4aafa4bd817e02e4fb79 input{text-align:left;}"; break;
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