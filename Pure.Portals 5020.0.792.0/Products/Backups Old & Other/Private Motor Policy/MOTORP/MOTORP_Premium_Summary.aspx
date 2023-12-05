<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MOTORP_Premium_Summary.aspx.vb" Inherits="Nexus.PB2_MOTORP_Premium_Summary" %>

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
        /**
         * Set the label of a field. If the field object passed in is 
         * a label it will set the value of that label. If it is any 
         * other field it will set the label of that field.
         * @param {pb.fields.AbstractBase} field The field
         * @param {Expression} value The value to give the field
         * @param {Expression} opt_condition If specified the value will 
         * only be set when this evaluates to true.
         * @param {Expression} opt_elseValue If specified this is the value
         * that will be set when the condition evaluates to false, if 
         * omitted then no value will be set on condition false.
         */
        window.setLabel = function(field, value, opt_condition, opt_elseValue){
        	
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
        			
        			if (field.getType() == "label"){
        				field.setValue(value);
        			} else if (field.setLabelText){
        				field.setLabelText(value);
        			} else if (window.console && window.console.log) {
        				window.console.log("Unable to set the label text for field.");
        			}
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
        
        /**
         ****************************************** ICECash Methods ***************************************
         */
         //Added temporariry for display
         $().ready(function () {
        	$(".icGet").hide();
        	$(".icRej").hide();
        	$(".icVal").hide();
        });
        
        var partnerID = '20117842'
        var key = '821782335222216376130519';
        var apiURL = 'http://test.api.ice.cash/request/' + partnerID;
        //var postURL = 'http://zimnatlion.icecash.mobi/External/insurance_quote_request?InsuranceQuoteRequest=';
        var loadingGifURL = '../../../app_themes/internal/images/loader.gif';
        
        		
        function onPostClick() {
        	if (typeof (Page_ClientValidate) == 'function') {
        		Page_ClientValidate();
        	}
        
        	if (Page_IsValid) {
        		var vcRef = Field.getInstance('MOTOR', 'VCREF').getValue();
        		if (vcRef == "")
        		{
        			//If no Vendor Client Reference exists, generate a new one using the first 10 characters of a random guid
        			vcRef = guid().substring(0,10);
        			Field.getInstance('MOTOR', 'VCREF').setValue(vcRef);
        		}
        	
        		var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        		if (tokenSession) {
        			postAPIPolicy();
        		}
        		else {
        			GetPartnerToken("POST");
        			return;
        		}
        	}
        	else
        	{
        		//if page validation fails, scroll to bottom of page where the validation errors reside
        		$('#divMain').animate({
        			scrollTop: $('.page-container').height()
        		}, 400);
        	}
        }
        
        function onGetClick() {
        	var icIDNum = Field.getInstance('MOTOR', 'ID_NUMBER').getValue();
        	
        	if (icIDNum != "")
        	{
        		var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        		if (tokenSession) {
        			getAPIPolicy();
        		}
        		else {
        			GetPartnerToken("GET");
        			return;
        		}
        	}
        	else
        	{
                displayResult("<span style='color:red;'>Please enter your ICECash Identity Number</span>");
        	}
        }
        
        function onRejClick() {
        	var icIDNum = Field.getInstance('MOTOR', 'ID_NUMBER').getValue();
        
        	if (icIDNum != "")
        	{
        		var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        		if (tokenSession) {
        			rejectAPIPolicy();
        		}
        		else {
        			GetPartnerToken("REJ");
        			return;
        		}
        	}
        	else
        	{
        		displayResult("<span style='color:red;'>Please enter your ICECash Identity Number</span>")
        	}
        }
        
        function onValClick(){
        	var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        	if (tokenSession) {
        		validateAPIPolicy();
        	}
        	else {
        		GetPartnerToken("VAL");
        		return;
        	}
        }
        
        function postAPIPolicy(){ //Create ICECash Quote JSON
        	var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        	var months = parseFloat(Field.getInstance("MOTOR", "ICDURATION").getValue());
        	var premium = parseFloat(Field.getInstance("PREMIUM_SUMMARY", "TOTAL_ANNUAL_PREMIUM").getValue());
        	//var prorataprem = (premium/12)*months; //Commented out, cause on-screen premium will already be pro-rated
        	var json = {
        		"PartnerReference": guid(),
        		"Date": getDateTimeString(),
        		"Version": "2.0",
        		"PartnerToken": tokenSession,
        		"Request": {
        			"Function": "TPIQuote",
        			"Vehicles":[{
        				"VRN": Field.getInstance("MOTOR", "REG_NO").getValue(),
        				"EntityType": "Personal",
        				"IDNumber": Field.getInstance("MOTOR", "ID_NUMBER").getValue(),	 //When creating quote, only CLIENT ID number is required					
        				"CompanyName": "",	 //Empty, for now
        				"FirstName": Field.getInstance("GENERAL", "ICFIELD1").getValue(),
        				"LastName": Field.getInstance("GENERAL", "ICFIELD2").getValue(),
        				"MSISDN": Field.getInstance("GENERAL", "ICFIELD3").getValue(),
        				"Email": Field.getInstance("GENERAL", "ICFIELD4").getValue(),
        				"Address1": Field.getInstance("GENERAL", "ICFIELD5").getValue(),
        				"Address2": "", //Empty, for now					
        				"Town": "", //Empty, for now					
        				"Make": Field.getInstance("MOTOR", "VEHICLE_MAKE").getValue(),						
        				"Model": Field.getInstance("MOTOR", "VEHICLE_MODEL").getValue(),						
        				"TaxClass": Field.getInstance("MOTOR", "ICTAXCLASS").getValue(), //INT datatype - from IC lookup						
        				"YearManufacture": Field.getInstance("MOTOR", "YEAROFMAN").getValue(),					
        				"InsuranceType": Field.getInstance("MOTOR", "ICINSURETYPE").getValue(), //INT datatype - from IC lookup						
        				"VehicleType": Field.getInstance("MOTOR", "ICVEHTYPECODE").getValue(), //INT datatype - from IC lookup						
        				"VehicleValue": Field.getInstance("MOTOR", "SUMINSURED").getValue(),						
        				"PremiumAmount": premium,
        				"DurationMonths": months
        			}]
        		}
        	};
        	
        	//normal base64 encoding of the json
        	//var encodedJson = btoa(JSON.stringify(json));
        	//var newurl = postURL + encodedJson;
        	//PopupCenter(newurl, '', 800, 600);
        
        	var hmac = GenerateHMAC(json, key);
        	apiCall(json, hmac, apiURL, "CreateQuote");
        }
        
        function getAPIPolicy() { //Approve ICECash Quote JSON
        	var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        	var json = {
        		"PartnerReference": guid(),
        		"Date": getDateTimeString(),
        		"Version": "2.0",
        		"PartnerToken": tokenSession,
        		"Request": {
        			"Function": "TPIQuoteUpdate",
        			"PaymentMethod": "1", // 1 - Cash
        			"Identifier": Field.getInstance("MOTOR", "ID_NUMBER").getValue(),					
        			"MSISDN": Field.getInstance("GENERAL", "ICFIELD3").getValue(),	
        			"Quotes":[{
        				"InsuranceID": Field.getInstance("MOTOR", "ICQUOTEID").getValue(),
        				"Status": 1 // 1 - Approved
        			}]
        		}
        	};
        	var hmac = GenerateHMAC(json, key);
        	apiCall(json, hmac, apiURL, "GetPolicy");
        }
        		
        function rejectAPIPolicy() { //Reject ICECash Quote JSON
        	var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        	var json = {
        		"PartnerReference": guid(),
        		"Date": getDateTimeString(),
        		"Version": "2.0",
        		"PartnerToken": tokenSession,
        		"Request": {
        			"Function": "TPIQuoteUpdate",
        			"PaymentMethod": "1", // 1 - Cash
        			"Identifier": Field.getInstance("MOTOR", "ID_NUMBER").getValue(),					
        			"MSISDN": Field.getInstance("GENERAL", "ICFIELD3").getValue(),	
        			"Quotes":[{
        				"InsuranceID": Field.getInstance("MOTOR", "ICQUOTEID").getValue(),
        				"Status": 0 // 0 - Rejected
        			}]
        		}
        	};
        	var hmac = GenerateHMAC(json, key);
        	apiCall(json, hmac, apiURL, "RejectQuote");
        }
        
        function validateAPIPolicy() { //Retrieve policy details from ICECash
        	var tokenSession = Field.getInstance("MOTOR", "SESSIONTOKEN").getValue();
        	var json = {
        		"PartnerReference": guid(),
        		"Date": getDateTimeString(),
        		"Version": "2.0",
        		"PartnerToken": tokenSession,
        		"Request": {
        				"Function": "TPIPolicy",
        				"InsuranceID": Field.getInstance("MOTOR", "ICQUOTEID").getValue()
        			}
        	};
        	var hmac = GenerateHMAC(json, key);
        	apiCall(json, hmac, apiURL, "ValidatePolicy");
        }
        
        function GetPartnerToken(nextStep) {
        	var json = {
        		"PartnerReference": guid(),
        		"Date": getDateTimeString(),
        		"Version": "2.0",
        		"Request": {
        			"Function": "PartnerToken"
        		}
        	};
        	var hmac = GenerateHMAC(json, key);
        	nextStep = nextStep || "TOK";
        	apiCall(json, hmac, apiURL, nextStep);
        }
        
        function apiCall(json, hmac, url, func) {
        	var data = {
        		"Arguments": JSON.stringify(json),
        		'MAC': hmac,
        		'Mode': 'SH'
        	}
        	if (window.console) console.log(JSON.stringify(json));
        	$.ajax({
        		url: url,
        		data: data,
        		type: "POST",
        		headers: {
        			'Content-type': 'application/x-www-form-urlencoded'
        		},
        		beforeSend: function () {
        			switch (func) {
        				case "CreateQuote":
        					displayResult('Creating quote on ICECash... <img src="'+loadingGifURL+'" />');
        					break;
        				case "PartnerToken":
        					displayResult('Retrieving Token... <img src="'+loadingGifURL+'" />');
        					break;
        				case "GetPolicy":
        					displayResult('Approving quote on ICEcash... <img src="'+loadingGifURL+'" />');
        					break;
        				case "RejectQuote":
        					displayResult('Rejecting quote on ICEcash... <img src="'+loadingGifURL+'" />');
        					break;
        				case "ValidatePolicy":
        					displayResult('Validating Policy... <img src="'+loadingGifURL+'" />');
        					break;
        				default: //PartnerToken
        					displayResult('Working... <img src="'+loadingGifURL+'" />');
        			}
        		},
        		success: function (data) {
        			switch (func) {
        				case "CreateQuote":
        					postSuccess(data);
        					break;
        				case "GetPolicy":
        					setResults(data);
        					break;
        				case "RejectQuote":
        					rejectSuccess(data);
        					break;
        				case "ValidatePolicy":
        					validateSuccess(data);
        					break;
        				default:
        					setToken(data, func);
        			}
        		},
        		error: function (request, status, err) {
        			displayResult("<span style='color:red;'>Error contacting ICECash API: "+status+" | " + err + "</span>");
        		}
        	});
        }
        
         function displayResult(html) {
        	$('.icResult').html('<p>' + html + '</p>');
        }
        
         function setToken(resultdata, nextStep) {
        	var data = resultdata;
        	if (data.Response.Result == 1) {
        		if (data.Response.PartnerToken) {
        			__doPostBack($('#<%=asyncPanel.ClientID%>').attr('id'), 'SETTOKEN,' + data.Response.PartnerToken + ',' + nextStep);
        		}
        	}
        }
        
        function postSuccess(resultdata){
        	var data = resultdata;
        	switch (parseInt(data.Response.Result))
        	{
        		case 0: //general error
        			$.each(data.Response.Quotes, function(index, element){
        				displayResult("<span style='color:red;'>Message from ICECash: " + element.Message + "</span>");
        			});
        			break;
        		case 1: //success
        			var ic_quoted = Field.getInstance("MOTOR", "ICISQUOTED")
        			ic_quoted.setValue('true');
        			//Populate results data
        			$.each(data.Response.Quotes, function(index, element){
        				var quoteID = element.InsuranceID;
        				
        				var premium = parseFloat(element.Policy.CoverAmount);
        				var totalPremium = parseFloat(element.Policy.PremiumAmount);
        				var stampDuty = parseFloat(element.Policy.StampDuty);
        				var levy = parseFloat(element.Policy.GovernmentLevy);
        				
        				var startDate = element.Policy.StartDate;
        				var endDate = element.Policy.EndDate;						
        				var startMatch = startDate.match(/(\d{4})(\d{2})(\d{2})/);
        				var startDateStr = startMatch[2] + '/' + startMatch[3] + '/' + startMatch[1];						
        				var endMatch = endDate.match(/(\d{4})(\d{2})(\d{2})/);
        				var endDateStr = endMatch[2] + '/' + endMatch[3] + '/' + endMatch[1];
        				
        				Field.getInstance('MOTOR', 'ICPOLSTART').setValue(startDateStr);
        				Field.getInstance('MOTOR', 'CPOLEND').setValue(endDateStr);
        				
        				if (quoteID != null && quoteID != '') { Field.getInstance('MOTOR', 'ICQUOTEID').setValue(quoteID); }
        				
        				if (premium != null && premium > 0) { Field.getInstance('PREMIUM_SUMMARY', 'RTA_PRORATA_PREM').setValue(premium); }
        				//if (totalPremium != null && totalPremium > 0) { Field.getInstance('PREMIUM_SUMMARY', 'GROSSPREM').setValue(totalPremium); }
        				if (stampDuty != null && stampDuty > 0) {
        					Field.getInstance('MOTOR', 'ICSTAMPDUTY').setValue(stampDuty);
        					//Field.getInstance('PREMIUM_SUMMARY', 'STAMPDUTY').setValue(stampDuty);
        				}
        				if (levy != null && levy > 0) {
        					Field.getInstance('MOTOR', 'ICLEVY').setValue(levy);
        					//Field.getInstance('PREMIUM_SUMMARY', 'LEVY').setValue(levy);
        				}
        			});
        			$(".icGet").show();
        			$(".icRej").show();
        			$(".icPost").hide();
        			displayResult(data.Response.Message);
        			break;
        		case 25: //Token expired - generate new tokenSession
        			GetPartnerToken("POST") ;
        			break;
        		default:
        			displayResult("<span style='color:red;'>Message from ICECash: " + data.Response.Message + "</span>");
        	}
        }
        
        function setResults(resultdata) {
        	var data = resultdata;
        	switch (parseInt(data.Response.Result))
        	{	
        		case 1: //success					
        			displayResult("Quote approved");
        			$(".icGet").hide();
        			$(".icRej").hide();
        			$(".icVal").show();
        			validateAPIPolicy();
        			break;
        		case 25: //Token expired - generate new tokenSession
        			GetPartnerToken("GET");
        			break;
        		default:
        			displayResult("<span style='color:red;'>Message from ICECash: " + data.Response.Message + "</span>");
        	}
        }
        
        function rejectSuccess(resultdata){
        	var data = resultdata;
        	switch (parseInt(data.Response.Result))
        	{	
        		case 0:
        		case 1: //success					
        			displayResult("Quote rejected");
        			var ic_quoted = Field.getInstance("MOTOR", "ICISQUOTED")
        			ic_quoted.setValue('false');
        			$(".icPost").show();
        			$(".icGet").hide();
        			$(".icRej").hide();
        			$(".icVal").hide();
        			break;
        		case 25: //Token expired - generate new tokenSession
        			GetPartnerToken("GET");
        			break;
        		default:
        			alert(JSON.stringify(data));
        			displayResult("<span style='color:red;'>Message from ICECash: " + data.Response.Message + "</span>");
        	}
        }
        
        function validateSuccess(resultdata) {
        	var data = resultdata;
        	switch (parseInt(data.Response.Result))
        	{	
        		case 1: //success					
        			//Update ICECash Ref(Cert number) and vehicle details
        			var icRef = data.Response.PolicyNo;				
        			var vrn = data.Response.VRN;
        			var make = data.Response.Make;
        			var model = data.Response.Model;
        			var year = data.Response.YearManufacture;
        			var msg = "Validation complete";
        				
        			Field.getInstance('MOTOR', 'ICECASHSN').setValue(icRef);
        			Field.getInstance('MOTOR', 'REG_NO').setValue(vrn);
        			if (make != null && make != '' && $.trim(make) != $.trim(Field.getInstance('MOTOR', 'VEHICLE_MAKE').getValue())) 
        			{ 
        				//Field.getInstance('MOTOR', 'VEHICLE_MAKE').setValue(make); 
        				msg += "<br/>Vehicle make mismatch. ICECash Vehicle make: " + make;
        			}
        			if (model != null && model != '' && $.trim(model) != $.trim(Field.getInstance('MOTOR', 'VEHICLE_MODEL').getValue())) 
        			{ 
        				//Field.getInstance('MOTOR', 'VEHICLE_MODEL').setValue(model); 
        				msg += "<br/>Vehicle model mismatch. ICECash Vehicle model: " + model;
        			}
        			if (year != null && year != '' && $.trim(year) != $.trim(Field.getInstance('MOTOR', 'YEAROFMAN').getValue())) 
        			{ 
        				//Field.getInstance('MOTOR', 'YEAROFMAN').setValue(year); 
        				msg += "<br/>Vehicle year mismatch. ICECash Vehicle year: " + year;
        			}
        
        			displayResult(msg);
        			break;
        		case 25: //Token expired - generate new tokenSession
        			GetPartnerToken("GET");
        			break;
        		default:
        			displayResult("<span style='color:red;'>Message from ICECash: " + data.Response.Message + "</span>");
        	}
        }
        
        function guid() {
        	function s4() {
        		return Math.floor((1 + Math.random()) * 0x10000)
        			.toString(16)
        			.substring(1);
        	}
        	return s4() + s4() + s4() + s4() + s4() + s4() + s4() + s4();
        }
        
        function GenerateHMAC(json, key) {
        	var base64encoded = btoa(reverse(JSON.stringify(json)) + reverse(key));
        	var md = forge.md.sha512.create();
        	md.update(base64encoded);
        	var crypt = md.digest().toHex();
        	var hash = [];
        	var x;
        	for (x = 0; x < 16; x++) {
        		hash.push(crypt.substr(x * 8, 1));
        	}
        	var request = hash.join('').toUpperCase();
        	return request
        }
        
        function reverse(s) {
        	for (var i = s.length - 1, o = ''; i >= 0; o += s[i--]) { }
        	return o;
        }
        
        function getDateTimeString() {
        	var currentdate = new Date();
        	var datetime = "";
        	var datetime = currentdate.getFullYear().toString()
        		+ (((currentdate.getMonth() + 1) < 10) ? "0" + (currentdate.getMonth() + 1).toString() : (currentdate.getMonth() + 1).toString())
        		+ ((currentdate.getDate() < 10) ? "0" + currentdate.getDate().toString() : currentdate.getDate().toString())
        		+ ((currentdate.getHours() < 10) ? "0" + currentdate.getHours().toString() : currentdate.getHours().toString())
        		+ ((currentdate.getMinutes() < 10) ? "0" + currentdate.getMinutes().toString() : currentdate.getMinutes().toString())
        		+ ((currentdate.getSeconds() < 10) ? "0" + currentdate.getSeconds().toString() : currentdate.getSeconds().toString());
        	return datetime;
        }
        
        /**
         ****************************************** ICECash Methods ***************************************
         */
         
         
function onValidate_PREMIUM_SUMMARY__VEHICLE_TYPE_CODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "VEHICLE_TYPE_CODE", "Temp");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Temp&objectName=PREMIUM_SUMMARY&propertyName=VEHICLE_TYPE_CODE&name={name}");
        		
        		var value = new Expression("MOTOR.VEHICLE_TYPE_CODE"), 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "VEHICLE_TYPE_CODE");
        		}
        		//window.setProperty(field, "R", "{1}", "{2}", "{3}");
        
            var paramValue = "R",
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
function onValidate_PREMIUM_SUMMARY__COVER_TYPE_DESCRIPTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "COVER_TYPE_DESCRIPTION", "Temp");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Temp&objectName=PREMIUM_SUMMARY&propertyName=COVER_TYPE_DESCRIPTION&name={name}");
        		
        		var value = new Expression("MOTOR.COVER_TYPE_DESCRIPTION"), 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "COVER_TYPE_DESCRIPTION");
        		}
        		//window.setProperty(field, "R", "{1}", "{2}", "{3}");
        
            var paramValue = "R",
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
function onValidate_PREMIUM_SUMMARY__COVER_TYPE_CODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "COVER_TYPE_CODE", "Temp");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Temp&objectName=PREMIUM_SUMMARY&propertyName=COVER_TYPE_CODE&name={name}");
        		
        		var value = new Expression("MOTOR.COVER_TYPECode"), 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "COVER_TYPE_CODE");
        		}
        		//window.setProperty(field, "R", "{1}", "{2}", "{3}");
        
            var paramValue = "R",
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
function onValidate_PREMIUM_SUMMARY__UserLevel(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "UserLevel", "TempInteger");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempInteger&objectName=PREMIUM_SUMMARY&propertyName=UserLevel&name={name}");
        		
        		var value = new Expression("GENERAL.UserLevel"), 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "UserLevel");
        		}
        		//window.setProperty(field, "R", "{1}", "{2}", "{3}");
        
            var paramValue = "R",
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
function onValidate_PREMIUM_SUMMARY__LoggedInUserFullName(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "LoggedInUserFullName", "Temp");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Temp&objectName=PREMIUM_SUMMARY&propertyName=LoggedInUserFullName&name={name}");
        		
        		var value = new Expression("GENERAL.LoggedInUserFullName"), 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "LoggedInUserFullName");
        		}
        		//window.setProperty(field, "R", "{1}", "{2}", "{3}");
        
            var paramValue = "R",
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
function onValidate_PREMIUM_SUMMARY__RTA_ANNUAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RTA_ANNUAL_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RTA_ANNUAL_PREM");
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
function onValidate_PREMIUM_SUMMARY__RTA_PREV_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RTA_PREV_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RTA_PREV_PREM");
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
function onValidate_PREMIUM_SUMMARY__RTA_PRORATA_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RTA_PRORATA_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RTA_PRORATA_PREM");
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
function onValidate_PREMIUM_SUMMARY__RSA_ANNUAL_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RSA_ANNUAL_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RSA_ANNUAL_PREM");
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
function onValidate_PREMIUM_SUMMARY__RSA_PREV_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RSA_PREV_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RSA_PREV_PREM");
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
function onValidate_PREMIUM_SUMMARY__FR_PRORATA_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "FR_PRORATA_PREM", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "FR_PRORATA_PREM");
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
function onValidate_lbl_Cover(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * SetLabel Identical to SetLabelText
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Label&objectName=&propertyName=&name=lbl_Cover");
        		
        		var value = new Expression("PREMIUM_SUMMARY.COVER_TYPE_DESCRIPTION"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setLabel(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PREMIUM_SUMMARY__SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PREMIUM_SUMMARY&propertyName=SUMINSURED&name={name}");
        		
        		var value = new Expression("MOTOR.TOTAL_SI"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.COVER_TYPE_CODE == 'COMP' || PREMIUM_SUMMARY.COVER_TYPE_CODE == 'FTPFT'")) ? new Expression("PREMIUM_SUMMARY.COVER_TYPE_CODE == 'COMP' || PREMIUM_SUMMARY.COVER_TYPE_CODE == 'FTPFT'") : null, 
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "SUMINSURED");
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
function onValidate_PREMIUM_SUMMARY__RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RATE", "Percentage");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "RATE");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PREMIUM_SUMMARY.RATE");
        			window.setControlWidth(field, "0.5", "PREMIUM_SUMMARY", "RATE");
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
        		var field = Field.getInstance("PREMIUM_SUMMARY", "RATE");
        		
        		
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
        			return field.setFormatPattern("0.0000%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0000%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
}
function onValidate_PREMIUM_SUMMARY__ANNUAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "ANNUAL_PREMIUM", "Currency");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "ANNUAL_PREMIUM");
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
function onValidate_PREMIUM_SUMMARY__EXTENSIONS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "EXTENSIONS", "Currency");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "EXTENSIONS");
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
function onValidate_PREMIUM_SUMMARY__ADDONS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "ADDONS", "Currency");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "ADDONS");
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
function onValidate_PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "TOTAL_ANNUAL_PREMIUM", "Currency");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "TOTAL_ANNUAL_PREMIUM");
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
function onValidate_PREMIUM_SUMMARY__ShowHideOverrideFrame(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "ShowHideOverrideFrame", "TempCheckbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempCheckbox&objectName=PREMIUM_SUMMARY&propertyName=ShowHideOverrideFrame&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.UserLevel == 3 && PREMIUM_SUMMARY.COVER_TYPE_CODE != 'RTA' ")) ? new Expression("PREMIUM_SUMMARY.UserLevel == 3 && PREMIUM_SUMMARY.COVER_TYPE_CODE != 'RTA' ") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmOverride The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("PREMIUM_SUMMARY","ShowHideOverrideFrame");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmOverride', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmOverride', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("PREMIUM_SUMMARY", "ShowHideOverrideFrame"), "change", update);
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "ShowHideOverrideFrame");
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
function onValidate_lbl_OverrideReason(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Adds an info icon and appends to the info icon's tooltip.
         */
        (function(){
        	var helpText = goog.string.unescapeEntities("You need to select a reason first to be able to override Premium");
        	
        	// Get the field
        	var field = Field.getWithQuery("type=Label&objectName=&propertyName=&name=lbl_OverrideReason");
        		
        	field.addHelpText(helpText);
        })();
}
function onValidate_lbl_OverrideDetails(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lbl_OverrideDetails" != "{na" + "me}"){
        			field = Field.getLabel("lbl_OverrideDetails");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VEM", "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) == 'OTHER'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) == 'OTHER'",
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
function onValidate_lbl_OverrideDetailsSpacer(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lbl_OverrideDetailsSpacer" != "{na" + "me}"){
        			field = Field.getLabel("lbl_OverrideDetailsSpacer");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VEM", "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) <>  'OTHER'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) <>  'OTHER'",
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
function onValidate_lbl_OverridePremium(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Adds an info icon and appends to the info icon's tooltip.
         */
        (function(){
        	var helpText = goog.string.unescapeEntities("Ensure you enter Annual Premium");
        	
        	// Get the field
        	var field = Field.getWithQuery("type=Label&objectName=&propertyName=&name=lbl_OverridePremium");
        		
        	field.addHelpText(helpText);
        })();
}
function onValidate_PREMIUM_SUMMARY__REASON_OVERRIDE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "REASON_OVERRIDE", "List");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "REASON_OVERRIDE");
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
function onValidate_PREMIUM_SUMMARY__USER_OVERRIDE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "USER_OVERRIDE", "Text");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "USER_OVERRIDE");
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
        		var field = Field.getWithQuery("type=Text&objectName=PREMIUM_SUMMARY&propertyName=USER_OVERRIDE&name={name}");
        		
        		var value = new Expression("GENERAL.LoggedInUserFullName"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''")) ? new Expression("PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PREMIUM_SUMMARY__OVERRIDE_OTHER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "OVERRIDE_OTHER", "Comment");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "OVERRIDE_OTHER");
        		}
        		//window.setProperty(field, "VEM", "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) == 'OTHER'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) == 'OTHER'",
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
function onValidate_lbl_OverrideDetailsFieldSpacer(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lbl_OverrideDetailsFieldSpacer" != "{na" + "me}"){
        			field = Field.getLabel("lbl_OverrideDetailsFieldSpacer");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VEM", "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) <>  'OTHER'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "Code(PREMIUM_SUMMARY.REASON_OVERRIDE) <>  'OTHER'",
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
function onValidate_PREMIUM_SUMMARY__PREM_OVERRIDE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "PREM_OVERRIDE", "Currency");
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
        			field = Field.getInstance("PREMIUM_SUMMARY", "PREM_OVERRIDE");
        		}
        		//window.setProperty(field, "VEM", "PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''", "V", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''",
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
        		var field = Field.getWithQuery("type=Currency&objectName=PREMIUM_SUMMARY&propertyName=PREM_OVERRIDE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.REASON_OVERRIDE == ''")) ? new Expression("PREMIUM_SUMMARY.REASON_OVERRIDE == ''") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PREMIUM_SUMMARY__ISPREMIUM_OVERRIDDEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "ISPREMIUM_OVERRIDDEN", "Checkbox");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=PREMIUM_SUMMARY&propertyName=ISPREMIUM_OVERRIDDEN&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''")) ? new Expression("PREMIUM_SUMMARY.REASON_OVERRIDE <>  ''") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "ISPREMIUM_OVERRIDDEN");
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
function onValidate_PREMIUM_SUMMARY__OVERRIDE_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "OVERRIDE_AMOUNT", "Currency");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "OVERRIDE_AMOUNT");
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
function onValidate_PREMIUM_SUMMARY__OVERRIDE_RATING_SECTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "OVERRIDE_RATING_SECTION", "Text");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "OVERRIDE_RATING_SECTION");
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
function onValidate_PREMIUM_SUMMARY__RefCount(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "RefCount", "TempInteger");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempInteger&objectName=PREMIUM_SUMMARY&propertyName=RefCount&name={name}");
        		
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "RefCount");
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
function onValidate_PREMIUM_SUMMARY__ShowReferralsTab(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PREMIUM_SUMMARY", "ShowReferralsTab", "Checkbox");
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
        			var field = Field.getInstance("PREMIUM_SUMMARY", "ShowReferralsTab");
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
        		var field = Field.getInstance("PREMIUM_SUMMARY.ShowReferralsTab");
        		var update = function(){
        			ToggleTabBasedOn("7", field.getValue());	
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=PREMIUM_SUMMARY&propertyName=ShowReferralsTab&name={name}");
        		
        		var value = new Expression("1"), 
        			condition = (Expression.isValidParameter("PREMIUM_SUMMARY.RefCount > 0")) ? new Expression("PREMIUM_SUMMARY.RefCount > 0") : null, 
        			elseValue = (Expression.isValidParameter("0")) ? new Expression("0") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR__ICTAXCLASSLOOKUP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICTAXCLASSLOOKUP", "List");
        })();
}
function onValidate_MOTOR__ICTAXCLASSLOOKUPALL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICTAXCLASSLOOKUPALL", "List");
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
        			var field = Field.getInstance("MOTOR", "ICTAXCLASSLOOKUPALL");
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
function onValidate_MOTOR__ICVEHTYPECODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICVEHTYPECODE", "Text");
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
        			var field = Field.getInstance("MOTOR", "ICVEHTYPECODE");
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
function onValidate_MOTOR__ICINSURETYPE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICINSURETYPE", "Text");
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
        			var field = Field.getInstance("MOTOR", "ICINSURETYPE");
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
function onValidate_MOTOR__ICTAXCLASS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICTAXCLASS", "Text");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Text&objectName=MOTOR&propertyName=ICTAXCLASS&name={name}");
        		
        		var value = new Expression("Code(MOTOR.ICTAXCLASSLOOKUP)"), 
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
        			var field = Field.getInstance("MOTOR", "ICTAXCLASS");
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
function onValidate_MOTOR__ID_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ID_NUMBER", "Text");
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
        			field = Field.getInstance("MOTOR", "ID_NUMBER");
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
              var field = Field.getInstance("MOTOR.ID_NUMBER");
        			window.setControlWidth(field, "0.5", "MOTOR", "ID_NUMBER");
        		})();
        	}
        })();
}
function onValidate_MOTOR__ICDURATION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICDURATION", "Integer");
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
        			field = Field.getInstance("MOTOR", "ICDURATION");
        		}
        		//window.setProperty(field, "VE", "TransactionType = 'NB' || TransactionType = 'REN' ", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "TransactionType = 'NB' || TransactionType = 'REN' ",
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
              var field = Field.getInstance("MOTOR.ICDURATION");
        			window.setControlWidth(field, "0.5", "MOTOR", "ICDURATION");
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
        		var field = Field.getWithQuery("type=Integer&objectName=MOTOR&propertyName=ICDURATION&name={name}");
        		
        		var value = new Expression("MOTOR.RENFREQ_MONTHS"), 
        			condition = (Expression.isValidParameter("MOTOR.ICDURATION > MOTOR.RENFREQ_MONTHS")) ? new Expression("MOTOR.ICDURATION > MOTOR.RENFREQ_MONTHS") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR__ICPOLSTART(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICPOLSTART", "Text");
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
        			field = Field.getInstance("MOTOR", "ICPOLSTART");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.ICPOLSTART");
        			window.setControlWidth(field, "0.5", "MOTOR", "ICPOLSTART");
        		})();
        	}
        })();
}
function onValidate_MOTOR__CPOLEND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "CPOLEND", "Text");
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
        			field = Field.getInstance("MOTOR", "CPOLEND");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.CPOLEND");
        			window.setControlWidth(field, "0.5", "MOTOR", "CPOLEND");
        		})();
        	}
        })();
        $(document).ready(function(){
        
        });
        /* @fileoverview
         * Methods required for the implementation of ICCash integration
         */
}
function onValidate_MOTOR__ICECASHSN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICECASHSN", "Text");
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
        			field = Field.getInstance("MOTOR", "ICECASHSN");
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
function onValidate_MOTOR__VCREF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "VCREF", "Text");
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
        			var field = Field.getInstance("MOTOR", "VCREF");
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
function onValidate_MOTOR__SESSIONTOKEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "SESSIONTOKEN", "Text");
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
        			var field = Field.getInstance("MOTOR", "SESSIONTOKEN");
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
function onValidate_MOTOR__USERIDNUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "USERIDNUM", "Text");
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
        			var field = Field.getInstance("MOTOR", "USERIDNUM");
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
function onValidate_MOTOR__ICSTAMPDUTY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICSTAMPDUTY", "Currency");
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
        			var field = Field.getInstance("MOTOR", "ICSTAMPDUTY");
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
function onValidate_MOTOR__ICLEVY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICLEVY", "Currency");
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
        			var field = Field.getInstance("MOTOR", "ICLEVY");
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
function onValidate_MOTOR__ICISQUOTED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICISQUOTED", "Checkbox");
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
        			var field = Field.getInstance("MOTOR", "ICISQUOTED");
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
function onValidate_MOTOR__ICQUOTEID(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ICQUOTEID", "Text");
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
        			var field = Field.getInstance("MOTOR", "ICQUOTEID");
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
function onValidate_MOTOR__REF_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "REF_NUMBER", "Text");
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
        			var field = Field.getInstance("MOTOR", "REF_NUMBER");
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
function onValidate_MOTOR__RENFREQ_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "RENFREQ_MONTHS", "Integer");
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
        			var field = Field.getInstance("MOTOR", "RENFREQ_MONTHS");
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
    onValidate_PREMIUM_SUMMARY__VEHICLE_TYPE_CODE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__COVER_TYPE_DESCRIPTION(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__COVER_TYPE_CODE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__UserLevel(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__LoggedInUserFullName(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RTA_ANNUAL_PREM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RTA_PREV_PREM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RTA_PRORATA_PREM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RSA_ANNUAL_PREM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RSA_PREV_PREM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__FR_PRORATA_PREM(null, null, null, isOnLoad);
    onValidate_lbl_Cover(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__SUMINSURED(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RATE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__ANNUAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__EXTENSIONS(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__ADDONS(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__ShowHideOverrideFrame(null, null, null, isOnLoad);
    onValidate_lbl_OverrideReason(null, null, null, isOnLoad);
    onValidate_lbl_OverrideDetails(null, null, null, isOnLoad);
    onValidate_lbl_OverrideDetailsSpacer(null, null, null, isOnLoad);
    onValidate_lbl_OverridePremium(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__REASON_OVERRIDE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__USER_OVERRIDE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__OVERRIDE_OTHER(null, null, null, isOnLoad);
    onValidate_lbl_OverrideDetailsFieldSpacer(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__PREM_OVERRIDE(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__ISPREMIUM_OVERRIDDEN(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__OVERRIDE_AMOUNT(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__OVERRIDE_RATING_SECTION(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__RefCount(null, null, null, isOnLoad);
    onValidate_PREMIUM_SUMMARY__ShowReferralsTab(null, null, null, isOnLoad);
    onValidate_MOTOR__ICTAXCLASSLOOKUP(null, null, null, isOnLoad);
    onValidate_MOTOR__ICTAXCLASSLOOKUPALL(null, null, null, isOnLoad);
    onValidate_MOTOR__ICVEHTYPECODE(null, null, null, isOnLoad);
    onValidate_MOTOR__ICINSURETYPE(null, null, null, isOnLoad);
    onValidate_MOTOR__ICTAXCLASS(null, null, null, isOnLoad);
    onValidate_MOTOR__ID_NUMBER(null, null, null, isOnLoad);
    onValidate_MOTOR__ICDURATION(null, null, null, isOnLoad);
    onValidate_MOTOR__ICPOLSTART(null, null, null, isOnLoad);
    onValidate_MOTOR__CPOLEND(null, null, null, isOnLoad);
    onValidate_MOTOR__ICECASHSN(null, null, null, isOnLoad);
    onValidate_MOTOR__VCREF(null, null, null, isOnLoad);
    onValidate_MOTOR__SESSIONTOKEN(null, null, null, isOnLoad);
    onValidate_MOTOR__USERIDNUM(null, null, null, isOnLoad);
    onValidate_MOTOR__ICSTAMPDUTY(null, null, null, isOnLoad);
    onValidate_MOTOR__ICLEVY(null, null, null, isOnLoad);
    onValidate_MOTOR__ICISQUOTED(null, null, null, isOnLoad);
    onValidate_MOTOR__ICQUOTEID(null, null, null, isOnLoad);
    onValidate_MOTOR__REF_NUMBER(null, null, null, isOnLoad);
    onValidate_MOTOR__RENFREQ_MONTHS(null, null, null, isOnLoad);
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
<div id="idae2782d94d664b6db87a41d29811c82c" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmPrmSum" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading30" runat="server" Text="Annual Premium Summary" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_VEHICLE_TYPE_CODE">VEHICLE_TYPE_CODE</label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="VEHICLE_TYPE_CODE" 
		id="pb-container-text-PREMIUM_SUMMARY-VEHICLE_TYPE_CODE"
	>
	<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_VEHICLE_TYPE_CODE" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valPREMIUM_SUMMARY_VEHICLE_TYPE_CODE" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for VEHICLE_TYPE_CODE"
								ClientValidationFunction="onValidate_PREMIUM_SUMMARY__VEHICLE_TYPE_CODE" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_COVER_TYPE_DESCRIPTION">COVER_TYPE_DESCRIPTION</label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="COVER_TYPE_DESCRIPTION" 
		id="pb-container-text-PREMIUM_SUMMARY-COVER_TYPE_DESCRIPTION"
	>
	<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_COVER_TYPE_DESCRIPTION" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valPREMIUM_SUMMARY_COVER_TYPE_DESCRIPTION" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for COVER_TYPE_DESCRIPTION"
								ClientValidationFunction="onValidate_PREMIUM_SUMMARY__COVER_TYPE_DESCRIPTION" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_COVER_TYPE_CODE">COVER_TYPE_CODE</label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="COVER_TYPE_CODE" 
		id="pb-container-text-PREMIUM_SUMMARY-COVER_TYPE_CODE"
	>
	<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_COVER_TYPE_CODE" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valPREMIUM_SUMMARY_COVER_TYPE_CODE" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for COVER_TYPE_CODE"
								ClientValidationFunction="onValidate_PREMIUM_SUMMARY__COVER_TYPE_CODE" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- TempInteger -->
	<span class="field-container"
		data-field-type="TempInteger" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="UserLevel" 
		id="pb-container-integer-PREMIUM_SUMMARY-UserLevel"
	>
		<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_UserLevel">UserLevel</label>
		<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_UserLevel" class="field-medium" />
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_UserLevel" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UserLevel"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__UserLevel" 
			Display="None"
			EnableClientScript="true"
		/>
	</span>
<!-- /TempInteger -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_LoggedInUserFullName">LoggedInUserFullName</label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="LoggedInUserFullName" 
		id="pb-container-text-PREMIUM_SUMMARY-LoggedInUserFullName"
	>
	<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_LoggedInUserFullName" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valPREMIUM_SUMMARY_LoggedInUserFullName" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for LoggedInUserFullName"
								ClientValidationFunction="onValidate_PREMIUM_SUMMARY__LoggedInUserFullName" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RTA_ANNUAL_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-RTA_ANNUAL_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_RTA_ANNUAL_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RTA_ANNUAL_PREM" 
			Text="RTA_ANNUAL_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__RTA_ANNUAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RTA_ANNUAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RTA_ANNUAL_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RTA_ANNUAL_PREM" 
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
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RTA_PREV_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-RTA_PREV_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_RTA_PREV_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RTA_PREV_PREM" 
			Text="RTA_PREV_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__RTA_PREV_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RTA_PREV_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RTA_PREV_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RTA_PREV_PREM" 
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
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RTA_PRORATA_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-RTA_PRORATA_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_RTA_PRORATA_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RTA_PRORATA_PREM" 
			Text="RTA_PRORATA_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__RTA_PRORATA_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RTA_PRORATA_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RTA_PRORATA_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RTA_PRORATA_PREM" 
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
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RSA_ANNUAL_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-RSA_ANNUAL_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_RSA_ANNUAL_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RSA_ANNUAL_PREM" 
			Text="RSA_ANNUAL_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__RSA_ANNUAL_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RSA_ANNUAL_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RSA_ANNUAL_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RSA_ANNUAL_PREM" 
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
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RSA_PREV_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-RSA_PREV_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_RSA_PREV_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RSA_PREV_PREM" 
			Text="RSA_PREV_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__RSA_PREV_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RSA_PREV_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RSA_PREV_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RSA_PREV_PREM" 
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
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="FR_PRORATA_PREM" 
		id="pb-container-currency-PREMIUM_SUMMARY-FR_PRORATA_PREM">
		<asp:Label ID="lblPREMIUM_SUMMARY_FR_PRORATA_PREM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__FR_PRORATA_PREM" 
			Text="FR_PRORATA_PREM" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__FR_PRORATA_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_FR_PRORATA_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FR_PRORATA_PREM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__FR_PRORATA_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="id3eb0f310e8fc45c3ade20d2075992ac4" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading31" runat="server" Text="" /></legend>
				
				
				<div data-column-count="4" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Header_one">
		<span class="label" id="lbl_Header_one"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Header_two">
		<span class="label" id="lbl_Header_two"><b>Total Sum Insured</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Header_three">
		<span class="label" id="lbl_Header_three"><b>Rate</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Header_Four">
		<span class="label" id="lbl_Header_Four"><b>Calculated Annual Premium</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Cover">
		<span class="label" id="lbl_Cover">Comprehensive</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="SUMINSURED" 
		id="pb-container-currency-PREMIUM_SUMMARY-SUMINSURED">
		<asp:Label ID="lblPREMIUM_SUMMARY_SUMINSURED" runat="server" AssociatedControlID="PREMIUM_SUMMARY__SUMINSURED" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.SUMINSURED"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__SUMINSURED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RATE" 
		id="pb-container-percentage-PREMIUM_SUMMARY-RATE">
		<asp:Label ID="lblPREMIUM_SUMMARY_RATE" runat="server" AssociatedControlID="PREMIUM_SUMMARY__RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PREMIUM_SUMMARY__RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.RATE"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="ANNUAL_PREMIUM" 
		id="pb-container-currency-PREMIUM_SUMMARY-ANNUAL_PREMIUM">
		<asp:Label ID="lblPREMIUM_SUMMARY_ANNUAL_PREMIUM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__ANNUAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__ANNUAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_ANNUAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.ANNUAL_PREMIUM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__ANNUAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_Extensions">
		<span class="label" id="lbl_Extensions">Extensions</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_ExtensionsSI">
		<span class="label" id="lbl_ExtensionsSI"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_ExtensionsRate">
		<span class="label" id="lbl_ExtensionsRate"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="EXTENSIONS" 
		id="pb-container-currency-PREMIUM_SUMMARY-EXTENSIONS">
		<asp:Label ID="lblPREMIUM_SUMMARY_EXTENSIONS" runat="server" AssociatedControlID="PREMIUM_SUMMARY__EXTENSIONS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__EXTENSIONS" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_EXTENSIONS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.EXTENSIONS"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__EXTENSIONS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblAddOns">
		<span class="label" id="lblAddOns">Add Ons</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblAddOnsSIColumn">
		<span class="label" id="lblAddOnsSIColumn"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblAddOnsRateColumn">
		<span class="label" id="lblAddOnsRateColumn"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="ADDONS" 
		id="pb-container-currency-PREMIUM_SUMMARY-ADDONS">
		<asp:Label ID="lblPREMIUM_SUMMARY_ADDONS" runat="server" AssociatedControlID="PREMIUM_SUMMARY__ADDONS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__ADDONS" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_ADDONS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.ADDONS"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__ADDONS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblTotalPremium">
		<span class="label" id="lblTotalPremium"><B>Total Calculated Annual Premium</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblTotalPremiumSIColumn">
		<span class="label" id="lblTotalPremiumSIColumn"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lblTotalPremiumRateColumn">
		<span class="label" id="lblTotalPremiumRateColumn"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="TOTAL_ANNUAL_PREMIUM" 
		id="pb-container-currency-PREMIUM_SUMMARY-TOTAL_ANNUAL_PREMIUM">
		<asp:Label ID="lblPREMIUM_SUMMARY_TOTAL_ANNUAL_PREMIUM" runat="server" AssociatedControlID="PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_TOTAL_ANNUAL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.TOTAL_ANNUAL_PREMIUM"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- TempCheckbox -->
	
	<span class="field-container"
		data-field-type="TempCheckbox" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="ShowHideOverrideFrame" 
		id="pb-container-checkbox-PREMIUM_SUMMARY-ShowHideOverrideFrame"
	>
		<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_ShowHideOverrideFrame" for="ctl00_cntMainBody_PREMIUM_SUMMARY_ShowHideOverrideFrame_select"></label>
		<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_ShowHideOverrideFrame" class="field-medium hidden" />
			<asp:CustomValidator ID="valPREMIUM_SUMMARY_ShowHideOverrideFrame" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.ShowHideOverrideFrame"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__ShowHideOverrideFrame" 
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
		if ($("#id3eb0f310e8fc45c3ade20d2075992ac4 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id3eb0f310e8fc45c3ade20d2075992ac4 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id3eb0f310e8fc45c3ade20d2075992ac4 div ul li").each(function(){		  
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
			$("#id3eb0f310e8fc45c3ade20d2075992ac4 div ul li").each(function(){		  
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
		styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3eb0f310e8fc45c3ade20d2075992ac4 input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="frmOverride" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading32" runat="server" Text="Override Premium" /></legend>
				
				
				<div data-column-count="4" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverrideReason">
		<span class="label" id="lbl_OverrideReason"><b>Override Reason&nbsp;&nbsp;</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverridenBy">
		<span class="label" id="lbl_OverridenBy"><b>Overridden By</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverrideDetails">
		<span class="label" id="lbl_OverrideDetails"><b>Override Details</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverrideDetailsSpacer">
		<span class="label" id="lbl_OverrideDetailsSpacer"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverridePremium">
		<span class="label" id="lbl_OverridePremium"><b>Override Premium&nbsp;&nbsp;</b></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="REASON_OVERRIDE" 
		id="pb-container-list-PREMIUM_SUMMARY-REASON_OVERRIDE">
		
					
		<asp:Label ID="lblPREMIUM_SUMMARY_REASON_OVERRIDE" runat="server" AssociatedControlID="PREMIUM_SUMMARY__REASON_OVERRIDE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PREMIUM_SUMMARY__REASON_OVERRIDE" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_REASONOVER" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PREMIUM_SUMMARY__REASON_OVERRIDE(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPREMIUM_SUMMARY_REASON_OVERRIDE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.REASON_OVERRIDE"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__REASON_OVERRIDE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
			  

					
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="USER_OVERRIDE" 
		 
		
		 
		id="pb-container-text-PREMIUM_SUMMARY-USER_OVERRIDE">

		
		<asp:Label ID="lblPREMIUM_SUMMARY_USER_OVERRIDE" runat="server" AssociatedControlID="PREMIUM_SUMMARY__USER_OVERRIDE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PREMIUM_SUMMARY__USER_OVERRIDE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPREMIUM_SUMMARY_USER_OVERRIDE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.USER_OVERRIDE"
					ClientValidationFunction="onValidate_PREMIUM_SUMMARY__USER_OVERRIDE"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="OVERRIDE_OTHER" 
		id="pb-container-comment-PREMIUM_SUMMARY-OVERRIDE_OTHER">
		<asp:Label ID="lblPREMIUM_SUMMARY_OVERRIDE_OTHER" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="PREMIUM_SUMMARY__OVERRIDE_OTHER" 
			Text=""></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="PREMIUM_SUMMARY__OVERRIDE_OTHER" runat="server" />
		
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_OVERRIDE_OTHER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.OVERRIDE_OTHER"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__OVERRIDE_OTHER"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-lbl_OverrideDetailsFieldSpacer">
		<span class="label" id="lbl_OverrideDetailsFieldSpacer"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="PREM_OVERRIDE" 
		id="pb-container-currency-PREMIUM_SUMMARY-PREM_OVERRIDE">
		<asp:Label ID="lblPREMIUM_SUMMARY_PREM_OVERRIDE" runat="server" AssociatedControlID="PREMIUM_SUMMARY__PREM_OVERRIDE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__PREM_OVERRIDE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_PREM_OVERRIDE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.PREM_OVERRIDE"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__PREM_OVERRIDE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_ISPREMIUM_OVERRIDDEN" for="ctl00_cntMainBody_PREMIUM_SUMMARY__ISPREMIUM_OVERRIDDEN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="ISPREMIUM_OVERRIDDEN" 
		id="pb-container-checkbox-PREMIUM_SUMMARY-ISPREMIUM_OVERRIDDEN">	
		
		<asp:TextBox ID="PREMIUM_SUMMARY__ISPREMIUM_OVERRIDDEN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_ISPREMIUM_OVERRIDDEN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.ISPREMIUM_OVERRIDDEN"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__ISPREMIUM_OVERRIDDEN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="OVERRIDE_AMOUNT" 
		id="pb-container-currency-PREMIUM_SUMMARY-OVERRIDE_AMOUNT">
		<asp:Label ID="lblPREMIUM_SUMMARY_OVERRIDE_AMOUNT" runat="server" AssociatedControlID="PREMIUM_SUMMARY__OVERRIDE_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PREMIUM_SUMMARY__OVERRIDE_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_OVERRIDE_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.OVERRIDE_AMOUNT"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__OVERRIDE_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="OVERRIDE_RATING_SECTION" 
		 
		
		 
		id="pb-container-text-PREMIUM_SUMMARY-OVERRIDE_RATING_SECTION">

		
		<asp:Label ID="lblPREMIUM_SUMMARY_OVERRIDE_RATING_SECTION" runat="server" AssociatedControlID="PREMIUM_SUMMARY__OVERRIDE_RATING_SECTION" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PREMIUM_SUMMARY__OVERRIDE_RATING_SECTION" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPREMIUM_SUMMARY_OVERRIDE_RATING_SECTION" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for PREMIUM_SUMMARY.OVERRIDE_RATING_SECTION"
					ClientValidationFunction="onValidate_PREMIUM_SUMMARY__OVERRIDE_RATING_SECTION"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- TempInteger -->
	<span class="field-container"
		data-field-type="TempInteger" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="RefCount" 
		id="pb-container-integer-PREMIUM_SUMMARY-RefCount"
	>
		<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_RefCount">RefCount</label>
		<input id="ctl00_cntMainBody_PREMIUM_SUMMARY_RefCount" class="field-medium" />
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_RefCount" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RefCount"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__RefCount" 
			Display="None"
			EnableClientScript="true"
		/>
	</span>
<!-- /TempInteger -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPREMIUM_SUMMARY_ShowReferralsTab" for="ctl00_cntMainBody_PREMIUM_SUMMARY__ShowReferralsTab" class="col-md-4 col-sm-3 control-label">
		ShowReferralsTab</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="ShowReferralsTab" 
		id="pb-container-checkbox-PREMIUM_SUMMARY-ShowReferralsTab">	
		
		<asp:TextBox ID="PREMIUM_SUMMARY__ShowReferralsTab" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPREMIUM_SUMMARY_ShowReferralsTab" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ShowReferralsTab"
			ClientValidationFunction="onValidate_PREMIUM_SUMMARY__ShowReferralsTab" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PREMIUM_SUMMARY" 
		data-property-name="REASON_OVERRIDECode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-PREMIUM_SUMMARY-REASON_OVERRIDECode">

		
		
			
		
				<asp:HiddenField ID="PREMIUM_SUMMARY__REASON_OVERRIDECode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('frmOverride'),
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
		if ($("#frmOverride div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmOverride div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmOverride div ul li").each(function(){		  
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
			$("#frmOverride div ul li").each(function(){		  
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
		styleString += "#frmOverride label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmOverride label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmOverride label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmOverride label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmOverride input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmOverride input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmOverride input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('frmPrmSum'),
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
		if ($("#frmPrmSum div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmPrmSum div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmPrmSum div ul li").each(function(){		  
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
			$("#frmPrmSum div ul li").each(function(){		  
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
		styleString += "#frmPrmSum label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmPrmSum label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPrmSum label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPrmSum label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmPrmSum input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPrmSum input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPrmSum input{text-align:left;}"; break;
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
<div id="frmIcecash" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading33" runat="server" Text="ICECash" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="frmIcecashTaxClass" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading34" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="MOTOR" 
		data-property-name="ICTAXCLASSLOOKUP" 
		id="pb-container-list-MOTOR-ICTAXCLASSLOOKUP">
		
					
		<asp:Label ID="lblMOTOR_ICTAXCLASSLOOKUP" runat="server" AssociatedControlID="MOTOR__ICTAXCLASSLOOKUP" 
			Text="ICECash Tax Class" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR__ICTAXCLASSLOOKUP" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_ICTAXCLASS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR__ICTAXCLASSLOOKUP(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_ICTAXCLASSLOOKUP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ICECash Tax Class"
			ClientValidationFunction="onValidate_MOTOR__ICTAXCLASSLOOKUP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
			  

					
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="ICTAXCLASSLOOKUPCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-MOTOR-ICTAXCLASSLOOKUPCode">

		
		
			
		
				<asp:HiddenField ID="MOTOR__ICTAXCLASSLOOKUPCode" runat="server" />

		

		
	
		
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
		if ($("#frmIcecashTaxClass div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmIcecashTaxClass div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmIcecashTaxClass div ul li").each(function(){		  
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
			$("#frmIcecashTaxClass div ul li").each(function(){		  
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
		styleString += "#frmIcecashTaxClass label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmIcecashTaxClass label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecashTaxClass label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecashTaxClass label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmIcecashTaxClass input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecashTaxClass input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecashTaxClass input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="frmIcecashDet_2" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading35" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="MOTOR" 
		data-property-name="ICTAXCLASSLOOKUPALL" 
		id="pb-container-list-MOTOR-ICTAXCLASSLOOKUPALL">
		
					
		<asp:Label ID="lblMOTOR_ICTAXCLASSLOOKUPALL" runat="server" AssociatedControlID="MOTOR__ICTAXCLASSLOOKUPALL" 
			Text="All ICECash Tax Class items" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR__ICTAXCLASSLOOKUPALL" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_ICTAXCLASS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR__ICTAXCLASSLOOKUPALL(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_ICTAXCLASSLOOKUPALL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for All ICECash Tax Class items"
			ClientValidationFunction="onValidate_MOTOR__ICTAXCLASSLOOKUPALL" 
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
		
		data-object-name="MOTOR" 
		data-property-name="ICVEHTYPECODE" 
		 
		
		 
		id="pb-container-text-MOTOR-ICVEHTYPECODE">

		
		<asp:Label ID="lblMOTOR_ICVEHTYPECODE" runat="server" AssociatedControlID="MOTOR__ICVEHTYPECODE" 
			Text="ICECash Vehicle Type Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICVEHTYPECODE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICVEHTYPECODE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Vehicle Type Code"
					ClientValidationFunction="onValidate_MOTOR__ICVEHTYPECODE"
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
		
		data-object-name="MOTOR" 
		data-property-name="ICINSURETYPE" 
		 
		
		 
		id="pb-container-text-MOTOR-ICINSURETYPE">

		
		<asp:Label ID="lblMOTOR_ICINSURETYPE" runat="server" AssociatedControlID="MOTOR__ICINSURETYPE" 
			Text="ICECash Insurance Type Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICINSURETYPE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICINSURETYPE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Insurance Type Code"
					ClientValidationFunction="onValidate_MOTOR__ICINSURETYPE"
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
		
		data-object-name="MOTOR" 
		data-property-name="ICTAXCLASS" 
		 
		
		 
		id="pb-container-text-MOTOR-ICTAXCLASS">

		
		<asp:Label ID="lblMOTOR_ICTAXCLASS" runat="server" AssociatedControlID="MOTOR__ICTAXCLASS" 
			Text="ICECash Tax Class Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICTAXCLASS" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICTAXCLASS" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Tax Class Code"
					ClientValidationFunction="onValidate_MOTOR__ICTAXCLASS"
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
		
		data-object-name="MOTOR" 
		data-property-name="ID_NUMBER" 
		 
		
		 
		id="pb-container-text-MOTOR-ID_NUMBER">

		
		<asp:Label ID="lblMOTOR_ID_NUMBER" runat="server" AssociatedControlID="MOTOR__ID_NUMBER" 
			Text="Client Identity Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ID_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ID_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Client Identity Number"
					ClientValidationFunction="onValidate_MOTOR__ID_NUMBER"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="ICTAXCLASSLOOKUPALLCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-MOTOR-ICTAXCLASSLOOKUPALLCode">

		
		
			
		
				<asp:HiddenField ID="MOTOR__ICTAXCLASSLOOKUPALLCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- ICButtons -->
<div>
	<div class="icPost">
		<input type="button" SkinID="buttonPrimary" class="btn btn-primary ice-cash-align" id="btnICPost" value="Create ICECash Quote" onclick="onPostClick();" />
	</div>
	<div class="icGet">
		<input type="button" SkinID="buttonPrimary" class="btn btn-primary ice-cash-align" id="btnICGet" value="Approve ICECash Quote" onclick="onGetClick();" />
	</div>
	<div class="icRej">
		<input type="button" SkinID="buttonPrimary" class="btn btn-primary ice-cash-align" id="btnICRej" value="Reject ICECash Quote" onclick="onRejClick();" />
	</div>
	<div class="icVal">
		<input type="button" SkinID="buttonPrimary" class="btn btn-primary ice-cash-align" id="btnICVal" value="Validate ICECash Policy" onclick="onValClick();" />
	</div>
	<div>
	<span class="icResult"></span>
	</div>
</div>
<!-- /ICButtons -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="MOTOR" 
		data-property-name="ICDURATION" 
		id="pb-container-integer-MOTOR-ICDURATION">
		<asp:Label ID="lblMOTOR_ICDURATION" runat="server" AssociatedControlID="MOTOR__ICDURATION" 
			Text="Duration (Months)" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR__ICDURATION" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_ICDURATION" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Duration (Months)"
			ClientValidationFunction="onValidate_MOTOR__ICDURATION" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label0">
		<span class="label" id="label0"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="ICPOLSTART" 
		 
		
		 
		id="pb-container-text-MOTOR-ICPOLSTART">

		
		<asp:Label ID="lblMOTOR_ICPOLSTART" runat="server" AssociatedControlID="MOTOR__ICPOLSTART" 
			Text="ICECash Policy start date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICPOLSTART" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICPOLSTART" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Policy start date"
					ClientValidationFunction="onValidate_MOTOR__ICPOLSTART"
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
	<span id="pb-container-label-label1">
		<span class="label" id="label1"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="CPOLEND" 
		 
		
		 
		id="pb-container-text-MOTOR-CPOLEND">

		
		<asp:Label ID="lblMOTOR_CPOLEND" runat="server" AssociatedControlID="MOTOR__CPOLEND" 
			Text="ICECash Policy end date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__CPOLEND" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_CPOLEND" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Policy end date"
					ClientValidationFunction="onValidate_MOTOR__CPOLEND"
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
	<span id="pb-container-label-label2">
		<span class="label" id="label2"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="ICECASHSN" 
		 
		
		 
		id="pb-container-text-MOTOR-ICECASHSN">

		
		<asp:Label ID="lblMOTOR_ICECASHSN" runat="server" AssociatedControlID="MOTOR__ICECASHSN" 
			Text="ICECash Serial Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICECASHSN" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICECASHSN" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Serial Number"
					ClientValidationFunction="onValidate_MOTOR__ICECASHSN"
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
		
		data-object-name="MOTOR" 
		data-property-name="VCREF" 
		 
		
		 
		id="pb-container-text-MOTOR-VCREF">

		
		<asp:Label ID="lblMOTOR_VCREF" runat="server" AssociatedControlID="MOTOR__VCREF" 
			Text="Vendor Client Ref" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__VCREF" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_VCREF" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Vendor Client Ref"
					ClientValidationFunction="onValidate_MOTOR__VCREF"
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
		
		data-object-name="MOTOR" 
		data-property-name="SESSIONTOKEN" 
		 
		
		 
		id="pb-container-text-MOTOR-SESSIONTOKEN">

		
		<asp:Label ID="lblMOTOR_SESSIONTOKEN" runat="server" AssociatedControlID="MOTOR__SESSIONTOKEN" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__SESSIONTOKEN" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_SESSIONTOKEN" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for MOTOR.SESSIONTOKEN"
					ClientValidationFunction="onValidate_MOTOR__SESSIONTOKEN"
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
		
		data-object-name="MOTOR" 
		data-property-name="USERIDNUM" 
		 
		
		 
		id="pb-container-text-MOTOR-USERIDNUM">

		
		<asp:Label ID="lblMOTOR_USERIDNUM" runat="server" AssociatedControlID="MOTOR__USERIDNUM" 
			Text="Pure User ID" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__USERIDNUM" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_USERIDNUM" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Pure User ID"
					ClientValidationFunction="onValidate_MOTOR__USERIDNUM"
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
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR" 
		data-property-name="ICSTAMPDUTY" 
		id="pb-container-currency-MOTOR-ICSTAMPDUTY">
		<asp:Label ID="lblMOTOR_ICSTAMPDUTY" runat="server" AssociatedControlID="MOTOR__ICSTAMPDUTY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__ICSTAMPDUTY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ICSTAMPDUTY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR.ICSTAMPDUTY"
			ClientValidationFunction="onValidate_MOTOR__ICSTAMPDUTY" 
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
		data-object-name="MOTOR" 
		data-property-name="ICLEVY" 
		id="pb-container-currency-MOTOR-ICLEVY">
		<asp:Label ID="lblMOTOR_ICLEVY" runat="server" AssociatedControlID="MOTOR__ICLEVY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__ICLEVY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ICLEVY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR.ICLEVY"
			ClientValidationFunction="onValidate_MOTOR__ICLEVY" 
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
<label id="ctl00_cntMainBody_lblMOTOR_ICISQUOTED" for="ctl00_cntMainBody_MOTOR__ICISQUOTED" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="MOTOR" 
		data-property-name="ICISQUOTED" 
		id="pb-container-checkbox-MOTOR-ICISQUOTED">	
		
		<asp:TextBox ID="MOTOR__ICISQUOTED" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valMOTOR_ICISQUOTED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR.ICISQUOTED"
			ClientValidationFunction="onValidate_MOTOR__ICISQUOTED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="ICQUOTEID" 
		 
		
		 
		id="pb-container-text-MOTOR-ICQUOTEID">

		
		<asp:Label ID="lblMOTOR_ICQUOTEID" runat="server" AssociatedControlID="MOTOR__ICQUOTEID" 
			Text="ICECash Quote ID" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ICQUOTEID" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ICQUOTEID" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ICECash Quote ID"
					ClientValidationFunction="onValidate_MOTOR__ICQUOTEID"
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
		
		data-object-name="MOTOR" 
		data-property-name="REF_NUMBER" 
		 
		
		 
		id="pb-container-text-MOTOR-REF_NUMBER">

		
		<asp:Label ID="lblMOTOR_REF_NUMBER" runat="server" AssociatedControlID="MOTOR__REF_NUMBER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__REF_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_REF_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for MOTOR.REF_NUMBER"
					ClientValidationFunction="onValidate_MOTOR__REF_NUMBER"
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
		data-object-name="MOTOR" 
		data-property-name="RENFREQ_MONTHS" 
		id="pb-container-integer-MOTOR-RENFREQ_MONTHS">
		<asp:Label ID="lblMOTOR_RENFREQ_MONTHS" runat="server" AssociatedControlID="MOTOR__RENFREQ_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR__RENFREQ_MONTHS" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_RENFREQ_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR.RENFREQ_MONTHS"
			ClientValidationFunction="onValidate_MOTOR__RENFREQ_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
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
		if ($("#frmIcecashDet_2 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmIcecashDet_2 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmIcecashDet_2 div ul li").each(function(){		  
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
			$("#frmIcecashDet_2 div ul li").each(function(){		  
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
		styleString += "#frmIcecashDet_2 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmIcecashDet_2 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecashDet_2 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecashDet_2 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmIcecashDet_2 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecashDet_2 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecashDet_2 input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('frmIcecash'),
		zippy = new pb.ui.Zippy(
			container,
			goog.dom.query("legend", container)[0],
			goog.dom.query(".column-content", container)[0],
			true
		);
		
		zippy.collapse();
		
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
		if ($("#frmIcecash div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmIcecash div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmIcecash div ul li").each(function(){		  
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
			$("#frmIcecash div ul li").each(function(){		  
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
		styleString += "#frmIcecash label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmIcecash label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecash label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecash label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmIcecash input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIcecash input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIcecash input{text-align:left;}"; break;
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