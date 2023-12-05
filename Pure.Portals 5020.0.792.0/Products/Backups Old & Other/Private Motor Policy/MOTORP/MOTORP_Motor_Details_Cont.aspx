<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MOTORP_Motor_Details_Cont.aspx.vb" Inherits="Nexus.PB2_MOTORP_Motor_Details_Cont" %>

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
function onValidate_MOTOR__OWNER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER", "Text");
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
        			field = Field.getInstance("MOTOR", "OWNER");
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
}
function onValidate_MOTOR__ADDRESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ADDRESS", "Text");
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
        			field = Field.getInstance("MOTOR", "ADDRESS");
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
}
function onValidate_MOTOR__OWN_DOB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWN_DOB", "Date");
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
        			field = Field.getInstance("MOTOR", "OWN_DOB");
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
              var field = Field.getInstance("MOTOR.OWN_DOB");
        			window.setControlWidth(field, "0.5", "MOTOR", "OWN_DOB");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred, Owner's Date Of Birth can't  be greater than today's date")) ? "A validation error occurred, Owner's Date Of Birth can't  be greater than today's date" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "OWN_DOB");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "OWN_DOB");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.OWN_DOB <= NOW");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__OWNER_LIC_DATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_LIC_DATE", "Date");
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
        			field = Field.getInstance("MOTOR", "OWNER_LIC_DATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.OWNER_LIC_DATE");
        			window.setControlWidth(field, "0.5", "MOTOR", "OWNER_LIC_DATE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred, Owner's License Issue Date can't be greater than today's date")) ? "A validation error occurred, Owner's License Issue Date can't be greater than today's date" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "OWNER_LIC_DATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "OWNER_LIC_DATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.OWNER_LIC_DATE <= NOW");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__OWNER_VALID_LICENSE_DATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_VALID_LICENSE_DATE", "TempDate");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=TempDate&objectName=MOTOR&propertyName=OWNER_VALID_LICENSE_DATE&name={name}");
        		
        		var value = new Expression("AddYears(MOTOR.OWN_DOB, 18)"), 
        			condition = (Expression.isValidParameter("MOTOR.OWN_DOB <>null")) ? new Expression("MOTOR.OWN_DOB <>null") : null, 
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
        			var message = (Expression.isValidParameter("Licence date is less than 18 years after driver’s DOB.")) ? "Licence date is less than 18 years after driver’s DOB." : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "OWNER_VALID_LICENSE_DATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "OWNER_VALID_LICENSE_DATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.OWNER_VALID_LICENSE_DATE <= MOTOR.OWNER_LIC_DATE  || (MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR') ");
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
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("MOTOR", "OWNER_VALID_LICENSE_DATE");
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
function onValidate_MOTOR__OWNER_LIC_NO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_LIC_NO", "Text");
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
        			field = Field.getInstance("MOTOR", "OWNER_LIC_NO");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.OWNER_LIC_NO");
        			window.setControlWidth(field, "0.5", "MOTOR", "OWNER_LIC_NO");
        		})();
        	}
        })();
}
function onValidate_MOTOR__OWNER_GENDER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_GENDER", "RateList");
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
        			field = Field.getInstance("MOTOR", "OWNER_GENDER");
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
              var field = Field.getInstance("MOTOR.OWNER_GENDER");
        			window.setControlWidth(field, "0.5", "MOTOR", "OWNER_GENDER");
        		})();
        	}
        })();
}
function onValidate_MOTOR__DEFENSIVE_LIC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "DEFENSIVE_LIC", "BooleanRadio");
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
        			field = Field.getInstance("MOTOR", "DEFENSIVE_LIC");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=BooleanRadio&objectName=MOTOR&propertyName=DEFENSIVE_LIC&name={name}");
        		
        		var value = new Expression("false"), 
        			condition = (Expression.isValidParameter("MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR'")) ? new Expression("MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_MOTOR__OWNER_EXCLUDED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_EXCLUDED", "BooleanRadio");
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
        			field = Field.getInstance("MOTOR", "OWNER_EXCLUDED");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred: Owner is excluded but main driver not added")) ? "A validation error occurred: Owner is excluded but main driver not added" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "OWNER_EXCLUDED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "OWNER_EXCLUDED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR.COUNT_MAIN_DRIVERS == 0 && MOTOR.OWNER_EXCLUDED == 1)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__OWNER_CONVICT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_CONVICT", "BooleanRadio");
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
        			field = Field.getInstance("MOTOR", "OWNER_CONVICT");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR__OWNER_REFUSED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "OWNER_REFUSED", "BooleanRadio");
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
        			field = Field.getInstance("MOTOR", "OWNER_REFUSED");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR__ADD_DRVS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ADD_DRVS", "BooleanRadio");
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
        			field = Field.getInstance("MOTOR", "ADD_DRVS");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=BooleanRadio&objectName=MOTOR&propertyName=ADD_DRVS&name={name}");
        		
        		var value = new Expression("false"), 
        			condition = (Expression.isValidParameter("MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR'")) ? new Expression("MOTOR.VEHICLE_TYPE_CODE == 'DTRR' || MOTOR.VEHICLE_TYPE_CODE == 'CRVR'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmADD_DRIVERS The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("MOTOR","ADD_DRVS");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmADD_DRIVERS', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmADD_DRIVERS', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("MOTOR", "ADD_DRVS"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_MOTOR__COUNT_MAIN_DRIVERS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "COUNT_MAIN_DRIVERS", "TempInteger");
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
        			var field = Field.getInstance("MOTOR", "COUNT_MAIN_DRIVERS");
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
          * @param MOTOR The Parent (Root) object name.
          * @param DRV_MOTOR.DRV_NAME The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param DRV_MOTOR.MAIN_DRIVER == 1 Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "MOTOR".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "DRV_MOTOR.DRV_NAME";
        		//count, average, total, min, max
        		var type = "COUNT".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var condition = (Expression.isValidParameter("DRV_MOTOR.MAIN_DRIVER == 1")) ? ("DRV_MOTOR.MAIN_DRIVER == 1") : ("true");
        		
        		
        		// Get the object and property from the child field string expects object.property
        		var temp = childFieldStr.split(".");
                if (temp.length < 2 || temp.length > 2) {
                    var error = new Error("Invalid Object Property '" + childFieldStr + "' for GetColumn rule.");
                    error.display();
                    //throw error;
                };
                var strObject = temp[0].toUpperCase().replace(/^\s+|\s+$/g, '');
                var strProperty = temp[1].replace(/^\s+|\s+$/g, '');
        		
        		var field = Field.getInstance("MOTOR", "COUNT_MAIN_DRIVERS");
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
        			
        			var field = Field.getInstance("MOTOR", "COUNT_MAIN_DRIVERS");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred: Only one driver can be marked as Main Driver")) ? "A validation error occurred: Only one driver can be marked as Main Driver" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "COUNT_MAIN_DRIVERS");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "COUNT_MAIN_DRIVERS");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.COUNT_MAIN_DRIVERS <=1 ");
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
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred: NO additional driver should be marked as main driver if Owner is not excluded")) ? "A validation error occurred: NO additional driver should be marked as main driver if Owner is not excluded" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "COUNT_MAIN_DRIVERS");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "COUNT_MAIN_DRIVERS");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.COUNT_MAIN_DRIVERS > 0 && MOTOR.OWNER_EXCLUDED == 0");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() == true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__DRVS_DTLS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "DRVS_DTLS", "ChildScreen");
        })();
}
function onValidate_MOTOR__NUM_ADD_DRVS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "NUM_ADD_DRVS", "Integer");
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
        			var field = Field.getInstance("MOTOR", "NUM_ADD_DRVS");
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
          * @param MOTOR The Parent (Root) object name.
          * @param DRV_MOTOR.DRV_NAME The object.property to sum the totals of.
          * @param COUNT The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "MOTOR".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "DRV_MOTOR.DRV_NAME";
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
        		
        		var field = Field.getInstance("MOTOR", "NUM_ADD_DRVS");
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
        			
        			var field = Field.getInstance("MOTOR", "NUM_ADD_DRVS");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("At least one additional driver must be added to child screen as additional drivers flag  has been selected")) ? "At least one additional driver must be added to child screen as additional drivers flag  has been selected" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "NUM_ADD_DRVS");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "NUM_ADD_DRVS");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" (MOTOR.NUM_ADD_DRVS >= 1 && MOTOR.ADD_DRVS == true)||(MOTOR.NUM_ADD_DRVS >= 0 &&  MOTOR.ADD_DRVS == false ) || ( MOTOR.ADD_DRVS <>true &&  MOTOR.ADD_DRVS <>false)  ) ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "SUMINSURED", "Currency");
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
        			field = Field.getInstance("MOTOR", "SUMINSURED");
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
              var field = Field.getInstance("MOTOR.SUMINSURED");
        			window.setControlWidth(field, "0.5", "MOTOR", "SUMINSURED");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Vehicle Sum Insured must be greater than zero")) ? "Vehicle Sum Insured must be greater than zero" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "SUMINSURED");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "SUMINSURED");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR.SUMINSURED > 0 ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=MOTOR&propertyName=TOTAL_SI&name={name}");
        		
        		var value = new Expression("MOTOR.SUMINSURED + MOTOR.ACCESS_TOTAL"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
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
              var field = Field.getInstance("MOTOR.TOTAL_SI");
        			window.setControlWidth(field, "0.5", "MOTOR", "TOTAL_SI");
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
        			field = Field.getInstance("MOTOR", "TOTAL_SI");
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
function onValidate_MOTOR__TRCK_FITTED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "TRCK_FITTED", "BooleanRadio");
        })();
}
function onValidate_MOTOR__ALRM_IMMO_FITTED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ALRM_IMMO_FITTED", "BooleanRadio");
        })();
}
function onValidate_MOTOR__ACCESSORIES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ACCESSORIES", "BooleanRadio");
        })();
        /** 
         * ToggleContainer
         * @param frmAccessories The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("MOTOR","ACCESSORIES");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmAccessories', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmAccessories', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("MOTOR", "ACCESSORIES"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_MOTOR__MODIFICATIONS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "MODIFICATIONS", "BooleanRadio");
        })();
        /** 
         * ToggleContainer
         * @param frmModifications The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("MOTOR","MODIFICATIONS");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmModifications', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmModifications', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("MOTOR", "MODIFICATIONS"), "change", update);
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
        			field = Field.getInstance("MOTOR", "MODIFICATIONS");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR__NCD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "NCD", "List");
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
        			field = Field.getInstance("MOTOR", "NCD");
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
              var field = Field.getInstance("MOTOR.NCD");
        			window.setControlWidth(field, "0.5", "MOTOR", "NCD");
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
        			field = Field.getInstance("MOTOR", "NCD");
        		}
        		//window.setProperty(field, "VE", "(MOTOR.VEHICLE_TYPE_CODE == 'PMVR') && (MOTOR.COVER_TYPECode == 'COMP')", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "(MOTOR.VEHICLE_TYPE_CODE == 'PMVR') && (MOTOR.COVER_TYPECode == 'COMP')",
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
function onValidate_MOTOR__INTERNATIONAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "INTERNATIONAL", "List");
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
        			field = Field.getInstance("MOTOR", "INTERNATIONAL");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.INTERNATIONAL");
        			window.setControlWidth(field, "0.5", "MOTOR", "INTERNATIONAL");
        		})();
        	}
        })();
}
function onValidate_lbl_spacer(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("lbl_spacer" != "{na" + "me}"){
        			field = Field.getLabel("lbl_spacer");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR__INTERN_DETAILS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "INTERN_DETAILS", "Comment");
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
        			field = Field.getInstance("MOTOR", "INTERN_DETAILS");
        		}
        		//window.setProperty(field, "VE", "MOTOR.INTERNATIONALCode =='OTHER'||MOTOR.INTERNATIONALCode =='MULTI'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.INTERNATIONALCode =='OTHER'||MOTOR.INTERNATIONALCode =='MULTI'",
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
function onValidate_MOTOR__COVER_TYPECode(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "COVER_TYPECode", "Temp");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Temp&objectName=MOTOR&propertyName=COVER_TYPECode&name={name}");
        		
        		var value = new Expression("MOTOR.COVER_TYPECODE"), 
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
        			var field = Field.getInstance("MOTOR", "COVER_TYPECode");
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
function onValidate_MOTOR__ACCESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ACCESS", "ChildScreen");
        })();
}
function onValidate_MOTOR__ACCESS_TOTAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "ACCESS_TOTAL", "Currency");
        })();
        
         /**
          * @fileoverview GetColumn
          * @param MOTOR The Parent (Root) object name.
          * @param ACCESSDETS.ACC_VAL The object.property to sum the totals of.
          * @param SUM The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "MOTOR".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "ACCESSDETS.ACC_VAL";
        		//count, average, total, min, max
        		var type = "SUM".toUpperCase().replace(/^\s+|\s+$/g, '');
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
        		
        		var field = Field.getInstance("MOTOR", "ACCESS_TOTAL");
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
        			switch ("SUM".toUpperCase()){
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
        			
        			var field = Field.getInstance("MOTOR", "ACCESS_TOTAL");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.ACCESS_TOTAL");
        			window.setControlWidth(field, "0.5", "MOTOR", "ACCESS_TOTAL");
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
        			field = Field.getInstance("MOTOR", "ACCESS_TOTAL");
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
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("At least one accessory must be added to the accessories child screen as accessories flag has been selected")) ? "At least one accessory must be added to the accessories child screen as accessories flag has been selected" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "ACCESS_TOTAL");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "ACCESS_TOTAL");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" (MOTOR.ACCESS_TOTAL >= 1 && MOTOR.ACCESSORIES == true)||(MOTOR.ACCESS_TOTAL >= 0 &&  MOTOR.ACCESSORIES == false ) || ( MOTOR.ACCESSORIES <>true &&  MOTOR.ACCESSORIES <>false)  ) ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOTOR__MODS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "MODS", "ChildScreen");
        })();
}
function onValidate_MOTOR__MODS_TOTAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR", "MODS_TOTAL", "Currency");
        })();
        
         /**
          * @fileoverview GetColumn
          * @param MOTOR The Parent (Root) object name.
          * @param MODSDETS.MOD_VAL The object.property to sum the totals of.
          * @param SUM The type of query to do. Accepts TOTAL, COUNT, MIN, MAX, AVERAGE
          * @param {3} Deprecated, The condition for each child row, in the child row context
          */ 
        (function(){
        	
        	if (isOnLoad) {		
        	
        		var screenObjectStr = "MOTOR".toUpperCase().replace(/^\s+|\s+$/g, '');
        		var childFieldStr = "MODSDETS.MOD_VAL";
        		//count, average, total, min, max
        		var type = "SUM".toUpperCase().replace(/^\s+|\s+$/g, '');
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
        		
        		var field = Field.getInstance("MOTOR", "MODS_TOTAL");
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
        			switch ("SUM".toUpperCase()){
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
        			
        			var field = Field.getInstance("MOTOR", "MODS_TOTAL");
        			field.setValue(exp.getValue());
        		}
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR.MODS_TOTAL");
        			window.setControlWidth(field, "0.5", "MOTOR", "MODS_TOTAL");
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
        			field = Field.getInstance("MOTOR", "MODS_TOTAL");
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
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("At least one modification must be added to the modifications child screen as modifications flag has been selected")) ? "At least one modification must be added to the modifications child screen as modifications flag has been selected" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "__" + "MODS_TOTAL");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR".toUpperCase() + "_" + "MODS_TOTAL");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression(" (MOTOR.MODS_TOTAL >= 1 && MOTOR.MODIFICATIONS == true)||(MOTOR.MODS_TOTAL >= 0 &&  MOTOR.MODIFICATIONS == false ) || ( MOTOR.MODIFICATIONS <>true &&  MOTOR.MODIFICATIONS <>false)  ) ");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_MOT_EXC_TL1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_TL1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_TL1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_TL2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_TL2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_TL2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_TL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TL_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_TL_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_TL_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TL_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_TL_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_TL_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_TL_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_TL_RATE <= 100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TL_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_TL_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_TL_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_TL_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_TL_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_PL1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_PL1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_PL1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_PL2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_PL2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_PL2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_PL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_PL_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_PL_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_PL_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_PL_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100%")) ? "A validation error occurred:Values allowed 1 to 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_PL_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_PL_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_PL_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_PL_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_PL_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_PL_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_PL_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_PL_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_PL_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_WS1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_WS1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_WS1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'",
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
function onValidate_MOT_EXC_WSL2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_WSL2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_WSL2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_WSL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_WSL_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_WSL_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_WSL_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_WSL_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_WSL_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_WSL_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_WSL_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_WSL_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR' || MOTOR.VEHICLE_TYPE_CODE == 'DTRR') || (MOTOR.VEHICLE_TYPE_CODE != 'PMVR' && MOTOR.VEHICLE_TYPE_CODE != 'DTRR')");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_WSL_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_WSL_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_WSL_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_WSL_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_WSL_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_SE1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_SE1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_SE1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_SE2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_SE2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_SE2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_SE_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_SE_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_SE_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_SE_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_SE_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_SE_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_SE_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_SE_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_SE_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_SE_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_SE_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_SE_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_SE_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_SE_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_AC1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_AC1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_AC1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_AC2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_AC2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_AC2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_AC_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_AC_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_AC_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_AC_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_AC_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100%")) ? "A validation error occurred:Values allowed 1 to 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_AC_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_AC_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_AC_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_AC_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_AC_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_AC_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_AC_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_AC_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_AC_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_DE1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_DE1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_DE1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_DE2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_DE2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_DE2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_DE_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DE_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_DE_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_DE_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DE_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_DE_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_DE_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_DE_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_DE_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DE_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_DE_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_DE_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_DE_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_DE_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_DL1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_DL1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_DL1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOT_EXC_DL2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_DL2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_DL2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_DL_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DL_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'PMVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_DL_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_DL_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DL_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100%")) ? "A validation error occurred:Values allowed 1 to 100%" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_DL_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_DL_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_DL_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_DL_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'PMVR') || MOTOR.VEHICLE_TYPE_CODE != 'PMVR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DL_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_DL_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_DL_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_DL_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_DL_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_TC1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_TC1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_TC1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'",
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
function onValidate_MOT_EXC_TC2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_TC2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_TC2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_TC_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TC_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_TC_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_TC_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TC_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_TC_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_TC_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_TC_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_TC_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'DTRR'||MOTOR.VEHICLE_TYPE_CODE == 'CRVR') || (MOTOR.VEHICLE_TYPE_CODE != 'DTRR' && MOTOR.VEHICLE_TYPE_CODE != 'CRVR')");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TC_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_TC_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_TC_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_TC_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_TC_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_MC1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_MC1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_MC1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOT_EXC_MC2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_MC2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_MC2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_MC_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_MC_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_MC_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_MC_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_MC_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_MC_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_MC_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_MC_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_MC_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'MCR') || MOTOR.VEHICLE_TYPE_CODE != 'MCR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_MC_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_MC_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_MC_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_MC_RATE== null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_MC_RATE== null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOT_EXC_ML1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_ML1" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_ML1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOT_EXC_ML2(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("MOT_EXC_ML2" != "{na" + "me}"){
        			field = Field.getLabel("MOT_EXC_ML2");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "VE", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VE",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_ML_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_ML_RATE");
        		}
        		//window.setProperty(field, "VEM", "MOTOR.VEHICLE_TYPE_CODE == 'MCR'", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "MOTOR.VEHICLE_TYPE_CODE == 'MCR'",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_ML_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_ML_RATE");
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
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_ML_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
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
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_ML_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_ML_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(MOTOR_EXCESSES.MOT_EXC_ML_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_ML_RATE <=  100 && MOTOR.VEHICLE_TYPE_CODE == 'MCR') || MOTOR.VEHICLE_TYPE_CODE != 'MCR'");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_ML_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_ML_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_ML_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_ML_RATE == null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_ML_RATE == null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_OZ_RATE", "Percentage");
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OZ_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_OZ_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_OZ_RATE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OZ_RATE");
        		var errorMessage = "{0}";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_OZ_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_OZ_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXCESSES.MOT_EXC_OZ_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_OZ_RATE <=  100");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OZ_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_OZ_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_OZ_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_OZ_RATE == null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_OZ_RATE == null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_OP_RATE", "Percentage");
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OP_RATE");
        		
        		
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
        			return field.setFormatPattern("0.0%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0.0%");
        		} else {
        			// Only supports currency, integer and percent fields at the moment.
        		}
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("MOTOR_EXCESSES.MOT_EXC_OP_RATE");
        			window.setControlWidth(field, "0.3", "MOTOR_EXCESSES", "MOT_EXC_OP_RATE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OP_RATE");
        		var errorMessage = "{0}";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("A validation error occurred:Values allowed 1 to 100% ")) ? "A validation error occurred:Values allowed 1 to 100% " : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "__" + "MOT_EXC_OP_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "MOTOR_EXCESSES".toUpperCase() + "_" + "MOT_EXC_OP_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("MOTOR_EXCESSES.MOT_EXC_OP_RATE >= 1 && MOTOR_EXCESSES.MOT_EXC_OP_RATE <=  100");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview Listens and executes an expression when a control loses focus.
         * OnBlur
         */
        (function(){
        	
        	if (isOnLoad) {		
        		
        		// Setup an instance of the field
        		var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OP_RATE");
        		
        		var valueExp = new Expression("MOTOR_EXCESSES.MOT_EXC_OP_RATE.setValue(MOTOR_EXCESSES.MOT_EXC_OP_RATE_DEF)");
        		var whenExp = (Expression.isValidParameter("MOTOR_EXCESSES.MOT_EXC_OP_RATE == null")) ? new Expression("MOTOR_EXCESSES.MOT_EXC_OP_RATE == null") : null;
        		var elseExp = Expression.isValidParameter("{2}") ? new Expression("{2}") : null;
        		
        		var blurHandler = function(e){
        			
        			// Evaluate the expression when the field changes.
        			if (whenExp == null || whenExp.valueOf() == true){
        				valueExp.valueOf();
        			} else if (elseExp){
        				elseExp.valueOf();
        			}
        			
        		};
        		
        		// Does not work for integer, percentage and currency fields
        		if (field.getType() == "integer"
        			|| field.getType() == "currency"
        			|| field.getType() == "percentage"
        			&& field.getInput){
        			goog.events.listen(field.getInput(), "blur", blurHandler, false, this);
        			return;
        		}
        		
        		var container = field.getElement();
        		var inputs = goog.dom.query("input, textarea", container);
        		//inputs.push(field.getElement());
        		goog.array.forEach(inputs, function(input){
        			events.listen(input, "blur", blurHandler, false, this);
        		}, this);
        	
        		
        	};
        })();
}
function onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_TL_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TL_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_PL_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_PL_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_WSL_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_WSL_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_SE_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_SE_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_AC_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_AC_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_DE_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DE_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_DL_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_DL_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_OZ_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OZ_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_OP_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_OP_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_MC_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_MC_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_ML_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_ML_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXC_TC_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXC_TC_RATE_DEF");
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
function onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXT_THEFT_RATE", "Percentage");
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
        			field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXT_THEFT_RATE");
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
function onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE_DEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "MOTOR_EXCESSES", "MOT_EXT_THEFT_RATE_DEF", "Percentage");
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
        			var field = Field.getInstance("MOTOR_EXCESSES", "MOT_EXT_THEFT_RATE_DEF");
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
    onValidate_MOTOR__OWNER(null, null, null, isOnLoad);
    onValidate_MOTOR__ADDRESS(null, null, null, isOnLoad);
    onValidate_MOTOR__OWN_DOB(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_LIC_DATE(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_VALID_LICENSE_DATE(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_LIC_NO(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_GENDER(null, null, null, isOnLoad);
    onValidate_MOTOR__DEFENSIVE_LIC(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_EXCLUDED(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_CONVICT(null, null, null, isOnLoad);
    onValidate_MOTOR__OWNER_REFUSED(null, null, null, isOnLoad);
    onValidate_MOTOR__ADD_DRVS(null, null, null, isOnLoad);
    onValidate_MOTOR__COUNT_MAIN_DRIVERS(null, null, null, isOnLoad);
    onValidate_MOTOR__DRVS_DTLS(null, null, null, isOnLoad);
    onValidate_MOTOR__NUM_ADD_DRVS(null, null, null, isOnLoad);
    onValidate_MOTOR__SUMINSURED(null, null, null, isOnLoad);
    onValidate_MOTOR__TOTAL_SI(null, null, null, isOnLoad);
    onValidate_MOTOR__TRCK_FITTED(null, null, null, isOnLoad);
    onValidate_MOTOR__ALRM_IMMO_FITTED(null, null, null, isOnLoad);
    onValidate_MOTOR__ACCESSORIES(null, null, null, isOnLoad);
    onValidate_MOTOR__MODIFICATIONS(null, null, null, isOnLoad);
    onValidate_MOTOR__NCD(null, null, null, isOnLoad);
    onValidate_MOTOR__INTERNATIONAL(null, null, null, isOnLoad);
    onValidate_lbl_spacer(null, null, null, isOnLoad);
    onValidate_MOTOR__INTERN_DETAILS(null, null, null, isOnLoad);
    onValidate_MOTOR__COVER_TYPECode(null, null, null, isOnLoad);
    onValidate_MOTOR__ACCESS(null, null, null, isOnLoad);
    onValidate_MOTOR__ACCESS_TOTAL(null, null, null, isOnLoad);
    onValidate_MOTOR__MODS(null, null, null, isOnLoad);
    onValidate_MOTOR__MODS_TOTAL(null, null, null, isOnLoad);
    onValidate_MOT_EXC_TL1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_TL2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_PL1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_PL2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_WS1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_WSL2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_SE1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_SE2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_AC1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_AC2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_DE1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_DE2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_DL1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_DL2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_TC1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_TC2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_MC1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_MC2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE(null, null, null, isOnLoad);
    onValidate_MOT_EXC_ML1(null, null, null, isOnLoad);
    onValidate_MOT_EXC_ML2(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE_DEF(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE(null, null, null, isOnLoad);
    onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE_DEF(null, null, null, isOnLoad);
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
<div id="idbc25a9864223400ea2621b48d1dc03a1" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmPersDriverDet" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading12" runat="server" Text="Registered Owner" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="id7418472a075f4c2f85bd956104effecb" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading13" runat="server" Text="Owner Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="OWNER" 
		 
		
		 
		id="pb-container-text-MOTOR-OWNER">

		
		<asp:Label ID="lblMOTOR_OWNER" runat="server" AssociatedControlID="MOTOR__OWNER" 
			Text="Owner" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__OWNER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_OWNER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Owner"
					ClientValidationFunction="onValidate_MOTOR__OWNER"
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
		data-property-name="ADDRESS" 
		 
		
		 
		id="pb-container-text-MOTOR-ADDRESS">

		
		<asp:Label ID="lblMOTOR_ADDRESS" runat="server" AssociatedControlID="MOTOR__ADDRESS" 
			Text="Owner's Address " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__ADDRESS" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_ADDRESS" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Owner's Address "
					ClientValidationFunction="onValidate_MOTOR__ADDRESS"
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
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="MOTOR" 
		data-property-name="OWN_DOB" 
		id="pb-container-datejquerycompatible-MOTOR-OWN_DOB">
		<asp:Label ID="lblMOTOR_OWN_DOB" runat="server" AssociatedControlID="MOTOR__OWN_DOB" 
			Text="Owner's Date Of Birth " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="MOTOR__OWN_DOB" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calMOTOR__OWN_DOB" runat="server" LinkedControl="MOTOR__OWN_DOB" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valMOTOR_OWN_DOB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Owner's Date Of Birth "
			ClientValidationFunction="onValidate_MOTOR__OWN_DOB" 
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
		data-object-name="MOTOR" 
		data-property-name="OWNER_LIC_DATE" 
		id="pb-container-datejquerycompatible-MOTOR-OWNER_LIC_DATE">
		<asp:Label ID="lblMOTOR_OWNER_LIC_DATE" runat="server" AssociatedControlID="MOTOR__OWNER_LIC_DATE" 
			Text="Owner's License Issue Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="MOTOR__OWNER_LIC_DATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calMOTOR__OWNER_LIC_DATE" runat="server" LinkedControl="MOTOR__OWNER_LIC_DATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valMOTOR_OWNER_LIC_DATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Owner's License Issue Date"
			ClientValidationFunction="onValidate_MOTOR__OWNER_LIC_DATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- TempDate -->
	<span class="field-container"
		data-field-type="TempDate" 
		data-object-name="MOTOR" 
		data-property-name="OWNER_VALID_LICENSE_DATE" 
		id="pb-container-datejquerycompatible-MOTOR-OWNER_VALID_LICENSE_DATE"
	>
		<asp:Label ID="lblMOTOR_OWNER_VALID_LICENSE_DATE" runat="server" AssociatedControlID="MOTOR_OWNER_VALID_LICENSE_DATE" 
			Text="TempDate"
		></asp:Label>
		<asp:TextBox ID="MOTOR_OWNER_VALID_LICENSE_DATE" runat="server" CssClass="field-medium" data-type="Date" />

		<uc1:CalendarLookup ID="calMOTOR_OWNER_VALID_LICENSE_DATE" runat="server" LinkedControl="MOTOR_OWNER_VALID_LICENSE_DATE" HLevel="1" />

		<asp:CustomValidator ID="valMOTOR_OWNER_VALID_LICENSE_DATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TempDate"
			ClientValidationFunction="onValidate_MOTOR__OWNER_VALID_LICENSE_DATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>
<!-- /TempDate -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="OWNER_LIC_NO" 
		 
		
		 
		id="pb-container-text-MOTOR-OWNER_LIC_NO">

		
		<asp:Label ID="lblMOTOR_OWNER_LIC_NO" runat="server" AssociatedControlID="MOTOR__OWNER_LIC_NO" 
			Text="Owner's Licence Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="MOTOR__OWNER_LIC_NO" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valMOTOR_OWNER_LIC_NO" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Owner's Licence Number"
					ClientValidationFunction="onValidate_MOTOR__OWNER_LIC_NO"
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
		data-object-name="MOTOR" 
		data-property-name="OWNER_GENDER" 
		id="pb-container-list-MOTOR-OWNER_GENDER">
		
					
		<asp:Label ID="lblMOTOR_OWNER_GENDER" runat="server" AssociatedControlID="MOTOR__OWNER_GENDER" 
			Text="Owner’s Gender" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR__OWNER_GENDER" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="131091" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR__OWNER_GENDER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_OWNER_GENDER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Owner’s Gender"
			ClientValidationFunction="onValidate_MOTOR__OWNER_GENDER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
			  

					
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_DEFENSIVE_LIC" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_DEFENSIVE_LIC_select">Defensive Licence</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="DEFENSIVE_LIC" 
		id="pb-container-booleanradio-MOTOR-DEFENSIVE_LIC" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__DEFENSIVE_LIC" runat="server" />
		<asp:CustomValidator ID="valMOTOR_DEFENSIVE_LIC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Defensive Licence"
			ClientValidationFunction="onValidate_MOTOR__DEFENSIVE_LIC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_OWNER_EXCLUDED" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_OWNER_EXCLUDED_select">Excluded from Driving?</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="OWNER_EXCLUDED" 
		id="pb-container-booleanradio-MOTOR-OWNER_EXCLUDED" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__OWNER_EXCLUDED" runat="server" />
		<asp:CustomValidator ID="valMOTOR_OWNER_EXCLUDED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Excluded from Driving?"
			ClientValidationFunction="onValidate_MOTOR__OWNER_EXCLUDED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_OWNER_CONVICT" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_OWNER_CONVICT_select">Any Motoring Convictions in the Last 5 Years?</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="OWNER_CONVICT" 
		id="pb-container-booleanradio-MOTOR-OWNER_CONVICT" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__OWNER_CONVICT" runat="server" />
		<asp:CustomValidator ID="valMOTOR_OWNER_CONVICT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Any Motoring Convictions in the Last 5 Years?"
			ClientValidationFunction="onValidate_MOTOR__OWNER_CONVICT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_OWNER_REFUSED" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_OWNER_REFUSED_select">Cover Previously Refused or Cancelled?</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="OWNER_REFUSED" 
		id="pb-container-booleanradio-MOTOR-OWNER_REFUSED" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__OWNER_REFUSED" runat="server" />
		<asp:CustomValidator ID="valMOTOR_OWNER_REFUSED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cover Previously Refused or Cancelled?"
			ClientValidationFunction="onValidate_MOTOR__OWNER_REFUSED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_ADD_DRVS" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_ADD_DRVS_select">Additional Drivers</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="ADD_DRVS" 
		id="pb-container-booleanradio-MOTOR-ADD_DRVS" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__ADD_DRVS" runat="server" />
		<asp:CustomValidator ID="valMOTOR_ADD_DRVS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Additional Drivers"
			ClientValidationFunction="onValidate_MOTOR__ADD_DRVS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- TempInteger -->
	<span class="field-container"
		data-field-type="TempInteger" 
		data-object-name="MOTOR" 
		data-property-name="COUNT_MAIN_DRIVERS" 
		id="pb-container-integer-MOTOR-COUNT_MAIN_DRIVERS"
	>
		<label id="ctl00_cntMainBody_lblMOTOR_COUNT_MAIN_DRIVERS">Tem main drivers</label>
		<input id="ctl00_cntMainBody_MOTOR_COUNT_MAIN_DRIVERS" class="field-medium" />
		<asp:CustomValidator ID="valMOTOR_COUNT_MAIN_DRIVERS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tem main drivers"
			ClientValidationFunction="onValidate_MOTOR__COUNT_MAIN_DRIVERS" 
			Display="None"
			EnableClientScript="true"
		/>
	</span>
<!-- /TempInteger -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('id7418472a075f4c2f85bd956104effecb'),
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
		if ($("#id7418472a075f4c2f85bd956104effecb div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id7418472a075f4c2f85bd956104effecb div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id7418472a075f4c2f85bd956104effecb div ul li").each(function(){		  
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
			$("#id7418472a075f4c2f85bd956104effecb div ul li").each(function(){		  
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
		styleString += "#id7418472a075f4c2f85bd956104effecb label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id7418472a075f4c2f85bd956104effecb label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7418472a075f4c2f85bd956104effecb label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7418472a075f4c2f85bd956104effecb label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id7418472a075f4c2f85bd956104effecb input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id7418472a075f4c2f85bd956104effecb input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id7418472a075f4c2f85bd956104effecb input{text-align:left;}"; break;
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
<div id="frmADD_DRIVERS" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading14" runat="server" Text="Additional Drivers" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_MOTOR__DRVS_DTLS"
		data-field-type="Child" 
		data-object-name="MOTOR" 
		data-property-name="DRVS_DTLS" 
		id="pb-container-childscreen-MOTOR-DRVS_DTLS">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="MOTOR__DRV_MOTOR" runat="server" ScreenCode="DRVS_DTLS" AutoGenerateColumns="false"
							GridLines="None" ChildPage="DRVS_DTLS/DRVS_DTLS_Additional_Drivers_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Drivers Name" DataField="DRV_NAME" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Drivers Date of Birth" DataField="DOB" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Drivers Licence Issue Date" DataField="LICENSE_DATE" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Drivers Licence Number" DataField="LICENSE_NO" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Main Driver" DataField="MAIN_DRIVER" DataFormatString="{0:Yes;;No}"/>

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
				
					<asp:CustomValidator ID="valMOTOR_DRVS_DTLS" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for MOTOR.DRVS_DTLS"
						ClientValidationFunction="onValidate_MOTOR__DRVS_DTLS" 
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
		data-object-name="MOTOR" 
		data-property-name="NUM_ADD_DRVS" 
		id="pb-container-integer-MOTOR-NUM_ADD_DRVS">
		<asp:Label ID="lblMOTOR_NUM_ADD_DRVS" runat="server" AssociatedControlID="MOTOR__NUM_ADD_DRVS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="MOTOR__NUM_ADD_DRVS" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valMOTOR_NUM_ADD_DRVS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOTOR.NUM_ADD_DRVS"
			ClientValidationFunction="onValidate_MOTOR__NUM_ADD_DRVS" 
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
	(function(){
		var container = document.getElementById('frmADD_DRIVERS'),
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
		if ($("#frmADD_DRIVERS div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmADD_DRIVERS div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmADD_DRIVERS div ul li").each(function(){		  
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
			$("#frmADD_DRIVERS div ul li").each(function(){		  
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
		styleString += "#frmADD_DRIVERS label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmADD_DRIVERS label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmADD_DRIVERS label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmADD_DRIVERS label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmADD_DRIVERS input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmADD_DRIVERS input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmADD_DRIVERS input{text-align:left;}"; break;
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
		var container = document.getElementById('frmPersDriverDet'),
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
		if ($("#frmPersDriverDet div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmPersDriverDet div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmPersDriverDet div ul li").each(function(){		  
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
			$("#frmPersDriverDet div ul li").each(function(){		  
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
		styleString += "#frmPersDriverDet label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmPersDriverDet label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPersDriverDet label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPersDriverDet label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmPersDriverDet input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPersDriverDet input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPersDriverDet input{text-align:left;}"; break;
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
<div id="frmMTGen1" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading15" runat="server" Text="Motor General Details" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="idd909c9a7494e4dc49c0920814306a6e4" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading16" runat="server" Text="Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR" 
		data-property-name="SUMINSURED" 
		id="pb-container-currency-MOTOR-SUMINSURED">
		<asp:Label ID="lblMOTOR_SUMINSURED" runat="server" AssociatedControlID="MOTOR__SUMINSURED" 
			Text="Vehicle Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Vehicle Sum Insured"
			ClientValidationFunction="onValidate_MOTOR__SUMINSURED" 
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
		data-property-name="TOTAL_SI" 
		id="pb-container-currency-MOTOR-TOTAL_SI">
		<asp:Label ID="lblMOTOR_TOTAL_SI" runat="server" AssociatedControlID="MOTOR__TOTAL_SI" 
			Text="Total Sum Insured (Incl. Accessories SI)" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Sum Insured (Incl. Accessories SI)"
			ClientValidationFunction="onValidate_MOTOR__TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_TRCK_FITTED" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_TRCK_FITTED_select">Tracker Fitted</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="TRCK_FITTED" 
		id="pb-container-booleanradio-MOTOR-TRCK_FITTED" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__TRCK_FITTED" runat="server" />
		<asp:CustomValidator ID="valMOTOR_TRCK_FITTED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tracker Fitted"
			ClientValidationFunction="onValidate_MOTOR__TRCK_FITTED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_ALRM_IMMO_FITTED" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_ALRM_IMMO_FITTED_select">Alarm/Immobiliser Fitted</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="ALRM_IMMO_FITTED" 
		id="pb-container-booleanradio-MOTOR-ALRM_IMMO_FITTED" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__ALRM_IMMO_FITTED" runat="server" />
		<asp:CustomValidator ID="valMOTOR_ALRM_IMMO_FITTED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Alarm/Immobiliser Fitted"
			ClientValidationFunction="onValidate_MOTOR__ALRM_IMMO_FITTED" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_ACCESSORIES" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_ACCESSORIES_select">Accessories</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="ACCESSORIES" 
		id="pb-container-booleanradio-MOTOR-ACCESSORIES" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__ACCESSORIES" runat="server" />
		<asp:CustomValidator ID="valMOTOR_ACCESSORIES" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Accessories"
			ClientValidationFunction="onValidate_MOTOR__ACCESSORIES" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- BooleanRadio -->
<div class="form-group form-group-sm">
	
	<label id="ctl00_cntMainBody_lblMOTOR_MODIFICATIONS" class="col-md-4 col-sm-3 control-label" for="ctl00_cntMainBody_MOTOR_MODIFICATIONS_select">Modifications</label>
	<div class="col-md-8 col-sm-9">
	<span class="field-container" 
		data-field-type="BooleanRadio" 
		data-object-name="MOTOR" 
		data-property-name="MODIFICATIONS" 
		id="pb-container-booleanradio-MOTOR-MODIFICATIONS" style="display:inherit;">
		<div class="radio-block">
		<asp:HiddenField ID="MOTOR__MODIFICATIONS" runat="server" />
		<asp:CustomValidator ID="valMOTOR_MODIFICATIONS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Modifications"
			ClientValidationFunction="onValidate_MOTOR__MODIFICATIONS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		</div>	
	</span>
	</div>
</div>
<!-- BooleanRadio -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="MOTOR" 
		data-property-name="NCD" 
		id="pb-container-list-MOTOR-NCD">
		
					
		<asp:Label ID="lblMOTOR_NCD" runat="server" AssociatedControlID="MOTOR__NCD" 
			Text="NCD" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR__NCD" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_PM_NCD" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR__NCD(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_NCD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for NCD"
			ClientValidationFunction="onValidate_MOTOR__NCD" 
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
		data-object-name="MOTOR" 
		data-property-name="INTERNATIONAL" 
		id="pb-container-list-MOTOR-INTERNATIONAL">
		
					
		<asp:Label ID="lblMOTOR_INTERNATIONAL" runat="server" AssociatedControlID="MOTOR__INTERNATIONAL" 
			Text="International Travel?" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="MOTOR__INTERNATIONAL" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_INT_TRAVEL" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_MOTOR__INTERNATIONAL(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valMOTOR_INTERNATIONAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for International Travel?"
			ClientValidationFunction="onValidate_MOTOR__INTERNATIONAL" 
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
	<span id="pb-container-label-lbl_spacer">
		<span class="label" id="lbl_spacer"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="MOTOR" 
		data-property-name="INTERN_DETAILS" 
		id="pb-container-comment-MOTOR-INTERN_DETAILS">
		<asp:Label ID="lblMOTOR_INTERN_DETAILS" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="MOTOR__INTERN_DETAILS" 
			Text="More Details"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="MOTOR__INTERN_DETAILS" runat="server" />
		
		<asp:CustomValidator ID="valMOTOR_INTERN_DETAILS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for More Details"
			ClientValidationFunction="onValidate_MOTOR__INTERN_DETAILS"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Temp -->
	<label id="ctl00_cntMainBody_lblMOTOR_COVER_TYPECode">Cover Type</label>
	<span class="field-container"
		data-field-type="Temp" 
		data-object-name="MOTOR" 
		data-property-name="COVER_TYPECode" 
		id="pb-container-text-MOTOR-COVER_TYPECode"
	>
	<input id="ctl00_cntMainBody_MOTOR_COVER_TYPECode" class="field-medium" type="text" />
	</span>
	<asp:CustomValidator ID="valMOTOR_COVER_TYPECode" 
								runat="server" 
								Text="*" 
								ErrorMessage="A validation error occurred for Cover Type"
								ClientValidationFunction="onValidate_MOTOR__COVER_TYPECode" 
								Display="None"
								EnableClientScript="true"
								/>
<!-- /Temp -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="MOTOR" 
		data-property-name="NCDCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-MOTOR-NCDCode">

		
		
			
		
				<asp:HiddenField ID="MOTOR__NCDCode" runat="server" />

		

		
	
		
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
		data-property-name="INTERNATIONALCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-MOTOR-INTERNATIONALCode">

		
		
			
		
				<asp:HiddenField ID="MOTOR__INTERNATIONALCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('idd909c9a7494e4dc49c0920814306a6e4'),
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
		if ($("#idd909c9a7494e4dc49c0920814306a6e4 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idd909c9a7494e4dc49c0920814306a6e4 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idd909c9a7494e4dc49c0920814306a6e4 div ul li").each(function(){		  
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
			$("#idd909c9a7494e4dc49c0920814306a6e4 div ul li").each(function(){		  
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
		styleString += "#idd909c9a7494e4dc49c0920814306a6e4 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idd909c9a7494e4dc49c0920814306a6e4 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd909c9a7494e4dc49c0920814306a6e4 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd909c9a7494e4dc49c0920814306a6e4 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idd909c9a7494e4dc49c0920814306a6e4 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd909c9a7494e4dc49c0920814306a6e4 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd909c9a7494e4dc49c0920814306a6e4 input{text-align:left;}"; break;
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
<div id="frmAccessories" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading17" runat="server" Text="Accessories" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_MOTOR__ACCESS"
		data-field-type="Child" 
		data-object-name="MOTOR" 
		data-property-name="ACCESS" 
		id="pb-container-childscreen-MOTOR-ACCESS">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="MOTOR__ACCESSDETS" runat="server" ScreenCode="ACCESS" AutoGenerateColumns="false"
							GridLines="None" ChildPage="ACCESS/ACCESS_Accessory_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:GISLookupField HeaderText="Accessory Type" ListType="PMLookup" ListCode="UDL_PM_ACCESSORY" DataField="ACC_TYPE" DataItemValue="key" />
<Nexus:RiskAttribute HeaderText="Installer" DataField="INSTALL" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Value" DataField="ACC_VAL" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valMOTOR_ACCESS" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for MOTOR.ACCESS"
						ClientValidationFunction="onValidate_MOTOR__ACCESS" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR" 
		data-property-name="ACCESS_TOTAL" 
		id="pb-container-currency-MOTOR-ACCESS_TOTAL">
		<asp:Label ID="lblMOTOR_ACCESS_TOTAL" runat="server" AssociatedControlID="MOTOR__ACCESS_TOTAL" 
			Text="Total Accessories Value" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__ACCESS_TOTAL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_ACCESS_TOTAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Accessories Value"
			ClientValidationFunction="onValidate_MOTOR__ACCESS_TOTAL" 
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
		var container = document.getElementById('frmAccessories'),
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
		if ($("#frmAccessories div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmAccessories div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmAccessories div ul li").each(function(){		  
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
			$("#frmAccessories div ul li").each(function(){		  
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
		styleString += "#frmAccessories label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmAccessories label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAccessories label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAccessories label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmAccessories input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmAccessories input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmAccessories input{text-align:left;}"; break;
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
<div id="frmModifications" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading18" runat="server" Text="Modifications" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_MOTOR__MODS"
		data-field-type="Child" 
		data-object-name="MOTOR" 
		data-property-name="MODS" 
		id="pb-container-childscreen-MOTOR-MODS">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="MOTOR__MODSDETS" runat="server" ScreenCode="MODS" AutoGenerateColumns="false"
							GridLines="None" ChildPage="MODS/MODS_Modification_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:GISLookupField HeaderText="Modification Type" ListType="PMLookup" ListCode="UDL_PM_MODIF_TYPE" DataField="MODIF_TYPE" DataItemValue="key" />
<Nexus:RiskAttribute HeaderText="Value" DataField="MOD_VAL" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valMOTOR_MODS" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for MOTOR.MODS"
						ClientValidationFunction="onValidate_MOTOR__MODS" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="MOTOR" 
		data-property-name="MODS_TOTAL" 
		id="pb-container-currency-MOTOR-MODS_TOTAL">
		<asp:Label ID="lblMOTOR_MODS_TOTAL" runat="server" AssociatedControlID="MOTOR__MODS_TOTAL" 
			Text="Total Modification Value" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="MOTOR__MODS_TOTAL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valMOTOR_MODS_TOTAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Modification Value"
			ClientValidationFunction="onValidate_MOTOR__MODS_TOTAL" 
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
		var container = document.getElementById('frmModifications'),
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
		if ($("#frmModifications div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmModifications div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmModifications div ul li").each(function(){		  
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
			$("#frmModifications div ul li").each(function(){		  
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
		styleString += "#frmModifications label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmModifications label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmModifications label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmModifications label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmModifications input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmModifications input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmModifications input{text-align:left;}"; break;
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
		var container = document.getElementById('frmMTGen1'),
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
		if ($("#frmMTGen1 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmMTGen1 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmMTGen1 div ul li").each(function(){		  
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
			$("#frmMTGen1 div ul li").each(function(){		  
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
		styleString += "#frmMTGen1 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmMTGen1 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMTGen1 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMTGen1 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmMTGen1 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMTGen1 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMTGen1 input{text-align:left;}"; break;
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
<div id="frmMotorExcess" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading19" runat="server" Text="Motor Excess" /></legend>
				
				
				<div data-column-count="3" data-column-ratio="20:50:30" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Exc_Empty_lbl">
		<span class="label" id="Exc_Empty_lbl"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Exc_Type_lbl">
		<span class="label" id="Exc_Type_lbl"><U><B>Excess Type</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-Exc_Rate_lbl">
		<span class="label" id="Exc_Rate_lbl"><U><B>Excess Rate</B></U></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_TL1">
		<span class="label" id="MOT_EXC_TL1">Total Loss</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_TL2">
		<span class="label" id="MOT_EXC_TL2">Vehicle is uneconomical to repair or is stolen or hijacked</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_TL_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_TL_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_TL_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_TL_RATE" 
			Text="% of Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_TL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_TL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Sum Insured"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_PL1">
		<span class="label" id="MOT_EXC_PL1">Partial Loss</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_PL2">
		<span class="label" id="MOT_EXC_PL2">Vehicle is damaged</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_PL_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_PL_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_PL_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_PL_RATE" 
			Text="% of Loss " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_PL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_PL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Loss "
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_WS1">
		<span class="label" id="MOT_EXC_WS1">Windscreen/Glass</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_WSL2">
		<span class="label" id="MOT_EXC_WSL2">Damages to Windscreen, Side and Rear glass</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_WSL_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_WSL_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_WSL_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_WSL_RATE" 
			Text="% of Loss (Min $500 )" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_WSL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_WSL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Loss (Min $500 )"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_SE1">
		<span class="label" id="MOT_EXC_SE1">Vehicle Sound Equipment</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_SE2">
		<span class="label" id="MOT_EXC_SE2">For any type of vehicle radio, tape deck, compact disc player and ancillary equipment fitted to the insured vehicle, stolen</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_SE_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_SE_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_SE_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_SE_RATE" 
			Text="% of Loss (Min 1% of SI) " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_SE_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_SE_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Loss (Min 1% of SI) "
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_AC1">
		<span class="label" id="MOT_EXC_AC1">Accessories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_AC2">
		<span class="label" id="MOT_EXC_AC2">For any part(s) or accessory(ies) stolen</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_AC_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_AC_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_AC_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_AC_RATE" 
			Text="% of Loss (Min 1% of SI) " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_AC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_AC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Loss (Min 1% of SI) "
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_DE1">
		<span class="label" id="MOT_EXC_DE1">Driver Under 25 Excess</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_DE2">
		<span class="label" id="MOT_EXC_DE2">If damage occurs while any insured vehicle is being driven by a person under 25 years of age</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_DE_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_DE_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_DE_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_DE_RATE" 
			Text="% of Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_DE_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_DE_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Sum Insured"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_DL1">
		<span class="label" id="MOT_EXC_DL1">Driver’s License Less Than 2 Years</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_DL2">
		<span class="label" id="MOT_EXC_DL2">If damage occurs while any insured vehicle where the driver has not held a full driver’s licence for a minimum period of 24 months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_DL_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_DL_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_DL_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_DL_RATE" 
			Text="% of Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_DL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_DL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Sum Insured"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_TC1">
		<span class="label" id="MOT_EXC_TC1">Private Trailers and Caravans</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_TC2">
		<span class="label" id="MOT_EXC_TC2">In respect of Total or Partial Loss</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_TC_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_TC_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_TC_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_TC_RATE" 
			Text="% of the insured value of the private trailer or caravan" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_TC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_TC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of the insured value of the private trailer or caravan"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_MC1">
		<span class="label" id="MOT_EXC_MC1">Motor Cycle </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_MC2">
		<span class="label" id="MOT_EXC_MC2">In respect of Total or Partial Loss</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_MC_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_MC_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_MC_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_MC_RATE" 
			Text="% of the insured value of the motor cycle" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_MC_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_MC_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of the insured value of the motor cycle"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_ML1">
		<span class="label" id="MOT_EXC_ML1">Motor Cycle – Learner Driver </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_ML2">
		<span class="label" id="MOT_EXC_ML2">Whilst the motor cycle is being driven by any person who is learning to drive </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_ML_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_ML_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_ML_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_ML_RATE" 
			Text="% of Loss " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_ML_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_ML_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Loss "
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_OZ1">
		<span class="label" id="MOT_EXC_OZ1">Outside Zimbabwe</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_OZ2">
		<span class="label" id="MOT_EXC_OZ2">If damage occurs while any insured vehicle is outside Zimbabwe</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_OZ_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_OZ_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_OZ_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_OZ_RATE" 
			Text="% of Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_OZ_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_OZ_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Sum Insured"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_OP1">
		<span class="label" id="MOT_EXC_OP1">Other Persons/Named Drivers</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-MOT_EXC_OP2">
		<span class="label" id="MOT_EXC_OP2">If damage occurs while any insured vehicle is being driven by any person other than the Insured or Spouse, or his / her own children aged over 22 or named driver.
</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_OP_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_OP_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_OP_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_OP_RATE" 
			Text="% of Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_OP_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_OP_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for % of Sum Insured"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE" 
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
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_TL_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_TL_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_TL_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_TL_RATE_DEF" 
			Text="MOT_EXC_TL_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_TL_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_TL_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_TL_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_TL_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_PL_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_PL_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_PL_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_PL_RATE_DEF" 
			Text="MOT_EXC_PL_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_PL_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_PL_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_PL_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_PL_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_WSL_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_WSL_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_WSL_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_WSL_RATE_DEF" 
			Text="MOT_EXC_WSL_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_WSL_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_WSL_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_WSL_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_WSL_RATE_DEF" 
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
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_SE_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_SE_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_SE_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_SE_RATE_DEF" 
			Text="MOT_EXC_SE_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_SE_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_SE_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_SE_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_SE_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_AC_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_AC_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_AC_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_AC_RATE_DEF" 
			Text="MOT_EXC_AC_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_AC_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_AC_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_AC_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_AC_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_DE_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_DE_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_DE_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_DE_RATE_DEF" 
			Text="MOT_EXC_DE_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_DE_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_DE_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_DE_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_DE_RATE_DEF" 
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
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_DL_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_DL_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_DL_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_DL_RATE_DEF" 
			Text="MOT_EXC_DL_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_DL_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_DL_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_DL_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_DL_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_OZ_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_OZ_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_OZ_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_OZ_RATE_DEF" 
			Text="MOT_EXC_OZ_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_OZ_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_OZ_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_OZ_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_OZ_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_OP_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_OP_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_OP_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_OP_RATE_DEF" 
			Text="MOT_EXC_OP_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_OP_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_OP_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_OP_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_OP_RATE_DEF" 
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
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_MC_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_MC_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_MC_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_MC_RATE_DEF" 
			Text="MOT_EXC_MC_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_MC_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_MC_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_MC_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_MC_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_ML_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_ML_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_ML_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_ML_RATE_DEF" 
			Text="MOT_EXC_ML_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_ML_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_ML_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_ML_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_ML_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:30%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXC_TC_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXC_TC_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXC_TC_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXC_TC_RATE_DEF" 
			Text="MOT_EXC_TC_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXC_TC_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXC_TC_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXC_TC_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXC_TC_RATE_DEF" 
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
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXT_THEFT_RATE" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXT_THEFT_RATE">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXT_THEFT_RATE" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXT_THEFT_RATE" 
			Text="MOT_EXT_THEFT_RATE" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXT_THEFT_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXT_THEFT_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXT_THEFT_RATE"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="MOTOR_EXCESSES" 
		data-property-name="MOT_EXT_THEFT_RATE_DEF" 
		id="pb-container-percentage-MOTOR_EXCESSES-MOT_EXT_THEFT_RATE_DEF">
		<asp:Label ID="lblMOTOR_EXCESSES_MOT_EXT_THEFT_RATE_DEF" runat="server" AssociatedControlID="MOTOR_EXCESSES__MOT_EXT_THEFT_RATE_DEF" 
			Text="MOT_EXT_THEFT_RATE_DEF" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="MOTOR_EXCESSES__MOT_EXT_THEFT_RATE_DEF" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valMOTOR_EXCESSES_MOT_EXT_THEFT_RATE_DEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for MOT_EXT_THEFT_RATE_DEF"
			ClientValidationFunction="onValidate_MOTOR_EXCESSES__MOT_EXT_THEFT_RATE_DEF" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>

<script type="text/javascript">
	(function(){
		var container = document.getElementById('frmMotorExcess'),
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
		if ($("#frmMotorExcess div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmMotorExcess div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmMotorExcess div ul li").each(function(){		  
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
			$("#frmMotorExcess div ul li").each(function(){		  
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
		styleString += "#frmMotorExcess label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmMotorExcess label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMotorExcess label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMotorExcess label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmMotorExcess input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMotorExcess input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMotorExcess input{text-align:left;}"; break;
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