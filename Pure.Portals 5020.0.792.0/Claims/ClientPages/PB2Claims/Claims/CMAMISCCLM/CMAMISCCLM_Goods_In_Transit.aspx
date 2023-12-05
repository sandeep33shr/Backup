<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMAMISCCLM_Goods_In_Transit.aspx.vb" Inherits="Nexus.PB2_CMAMISCCLM_Goods_In_Transit" %>

<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="NexusControl" %>
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

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" Runat="Server" xmlns:asp="remove" xmlns:Nexus="remove" xmlns:NexusControl="remove" xmlns:NexusProvider="remove">
<div class="itl">
  <asp:ScriptManager ID="ScriptManagerMainDetails" runat="server" />

  <script type="text/javascript">
	window['NoCurrencySymbols'] = true;
	window['XMLDataSet'] = '<asp:Literal ID="XMLDataSet" runat="server"></asp:Literal>';
	window['ThisOI'] = '<asp:Literal ID="ThisOI" runat="server"></asp:Literal>';

	<% If CType(Session.Item(Nexus.Constants.CNMode), Nexus.Constants.Mode) = Nexus.Constants.Mode.View Or CType(Session.Item(Nexus.Constants.CNMode), Nexus.Constants.Mode) = Nexus.Constants.Mode.Review Or CType(Session.Item(Nexus.Constants.CNMode), Nexus.Constants.Mode) = Nexus.Constants.Mode.ViewClaim Then %>
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
function onValidate_GIT__RISKATTACHDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "RISKATTACHDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "RISKATTACHDATE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT.RISKATTACHDATE");
        			window.setControlWidth(field, "0.3", "GIT", "RISKATTACHDATE");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_RISKATTACHDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__RISKATTACHDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__RISKATTACHDATE_lblFindParty");
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
function onValidate_GIT__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "EFFECTIVEDATE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.3", "GIT", "EFFECTIVEDATE");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__EFFECTIVEDATE_lblFindParty");
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
function onValidate_GIT__GIT0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT__GIT0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('GIT', 'GIT0_12_AMOUNT');
        			
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
        		var field = Field.getInstance("GIT", "GIT0_12_AMOUNT");
        		
        		
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
}
function onValidate_GIT__GIT13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT__GIT13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "GIT13_24_AMOUNT");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'GIT13_24_AMOUNT');
        			
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
function onValidate_GIT__GIT25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT__GIT25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GIT25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "GIT25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "GIT25_36_AMOUNT");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'GIT25_36_AMOUNT');
        			
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
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "BASIS_OF_COVER", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "BASIS_OF_COVER");
        	field.setReadOnly(true);
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
        
        			var width = window.parseFloat("0.9");
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
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "BASIS_OF_RATING");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("GIT.BASIS_OF_RATING");
        			window.setControlWidth(field, "0.5", "GIT", "BASIS_OF_RATING");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
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
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "ROAD");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_ROAD");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__ROAD');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__ROAD_lblFindParty");
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
function onValidate_GIT__AIR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AIR", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "AIR");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_AIR");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__AIR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__AIR_lblFindParty");
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
function onValidate_GIT__RAIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "RAIL", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "RAIL");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_RAIL");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT__RAIL');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT__RAIL_lblFindParty");
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
function onValidate_GIT__DESC_GOODS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "DESC_GOODS", "Comment");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "DESC_GOODS");
        	field.setReadOnly(true);
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
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "AC_SI");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "AC_SI");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'AC_SI');
        			
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
function onValidate_GIT__AC_LOAD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AC_LOAD_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "AC_LOAD_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "AC_LOAD_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'AC_LOAD_LIMIT');
        			
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
function onValidate_GIT__LL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "LL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "LL_SI");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'LL_SI');
        			
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
function onValidate_GIT__LL_NUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "LL_NUM", "Integer");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("GIT", "LL_NUM");
        		var errorMessage = "Load Limit Number of Vehicles is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('GIT', 'LL_NUM');
        			
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
function onValidate_GIT__AH_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "AH_SI");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "AH_SI");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'AH_SI');
        			
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
function onValidate_GIT__AH_LOAD_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "AH_LOAD_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT", "AH_LOAD_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT", "AH_LOAD_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT', 'AH_LOAD_LIMIT');
        			
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
function onValidate_GIT_FAP__FAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "FAP_PERC", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "FAP_PERC");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "FAP_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_FAP', 'FAP_PERC');
        			
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
function onValidate_GIT_FAP__FAP_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "FAP_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "FAP_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "FAP_MIN_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'FAP_MIN_AMT');
        			
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
function onValidate_GIT_FAP__FAP_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "FAP_MAX_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "FAP_MAX_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "FAP_MAX_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'FAP_MAX_AMT');
        			
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
function onValidate_GIT_FAP__THEFT_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "THEFT_PERC", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "THEFT_PERC");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "THEFT_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_FAP', 'THEFT_PERC');
        			
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
function onValidate_GIT_FAP__THEFT_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "THEFT_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "THEFT_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "THEFT_MIN_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'THEFT_MIN_AMT');
        			
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
function onValidate_GIT_FAP__THEFT_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "THEFT_MAX_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "THEFT_MAX_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "THEFT_MAX_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'THEFT_MAX_AMT');
        			
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
function onValidate_GIT_FAP__AFAP_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "AFAP_PERC", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "AFAP_PERC");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "AFAP_PERC");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_FAP', 'AFAP_PERC');
        			
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
function onValidate_GIT_FAP__AFAP_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "AFAP_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "AFAP_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "AFAP_MIN_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'AFAP_MIN_AMT');
        			
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
function onValidate_GIT_FAP__AFAP_MAX_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_FAP", "AFAP_MAX_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_FAP", "AFAP_MAX_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_FAP", "AFAP_MAX_AMT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_FAP', 'AFAP_MAX_AMT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_ACPC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_ACPC", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_ACPC");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "ACPC_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "ACPC_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'ACPC_LIMIT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_DEB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_DEB", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_DEB");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "DEB_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "DEB_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'DEB_LIMIT');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "DEB_FAP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "DEB_FAP");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'DEB_FAP');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "DEB_MIN_AMNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "DEB_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'DEB_MIN_AMNT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_FIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_FIRE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_FIRE");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'FIRE_LIMIT');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_FAP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_FAP");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'FIRE_FAP');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_MIN_AMNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "FIRE_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'FIRE_MIN_AMNT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_HIJACK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_HIJACK", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_HIJACK");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_FAP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_FAP");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'HIJACK_FAP');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_MIN_AMNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "HIJACK_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'HIJACK_MIN_AMNT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_RIOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_RIOT", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_RIOT");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "RIOT_FAP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "RIOT_FAP");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'RIOT_FAP');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "RIOT_MIN_AMNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "RIOT_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'RIOT_MIN_AMNT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_EXT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_EXT", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_EXT");
        	field.setReadOnly(true);
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "EXT_FAP");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "EXT_FAP");
        		
        		
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
        			return field.setFormatPattern("##0.00%", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##0.00%");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'EXT_FAP');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "EXT_MIN_AMNT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "EXT_MIN_AMNT");
        		
        		
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
        			return field.setFormatPattern("##,###,###,##0.00", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("##,###,###,##0.00");
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'EXT_MIN_AMNT');
        			
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
function onValidate_GIT_EXTENSIONS__IS_NASRIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "IS_NASRIA", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "IS_NASRIA");
        	field.setReadOnly(true);
        })();
}
function onValidate_GIT_EXTENSIONS__NASRIA_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "NASRIA_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "NASRIA_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("GIT_EXTENSIONS", "NASRIA_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('GIT_EXTENSIONS', 'NASRIA_LIMIT');
        			
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
function onValidate_GIT_EXTENSIONS__EXT_DESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT_EXTENSIONS", "EXT_DESC", "Comment");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("GIT_EXTENSIONS", "EXT_DESC");
        	field.setReadOnly(true);
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.9");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblGIT_EXTENSIONS_EXT_DESC");
        			    var ele = document.getElementById('ctl00_cntMainBody_GIT_EXTENSIONS__EXT_DESC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_GIT_EXTENSIONS__EXT_DESC_lblFindParty");
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
function onValidate_GIT__GITENDCLM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GITENDCLM", "ChildScreen");
        })();
        /** 
         * Note: This script removes the 'Delete' linkbutton in every row of the childscreen grid. It also renames 'Edit' to 'Select'
         * @param GIT The object name of the control to set.
         * @parma GIT_CLAUSEPREM The property name of the control to set to the result of the calculated premium.
         */
        (function(){
        	if (isOnLoad) {
        		$('#<%=GIT__GIT_CLAUSEPREM.ClientID %>').find('table').find('tr').each(function () {
        			$(this).find('td:last').find('a').each(function () {
        				var linkVal = $.trim($(this).text());
        				if (linkVal.toUpperCase() == 'EDIT') {
        					$(this).text('Select');
        				}
        				if (linkVal.toUpperCase() == 'ADD') {
        					$(this).remove();
        				}
        				if (linkVal.toUpperCase() == 'DELETE') {
        					$(this).remove();
        				}
        			});
        		});
        	}
        })();
}
function onValidate_GIT__GITNOTECLM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GITNOTECLM", "ChildScreen");
        })();
        /** 
         * Note: This script removes the 'Delete' linkbutton in every row of the childscreen grid. It also renames 'Edit' to 'Select'
         * @param GIT The object name of the control to set.
         * @parma GIT_CNOTE_DETAILS The property name of the control to set to the result of the calculated premium.
         */
        (function(){
        	if (isOnLoad) {
        		$('#<%=GIT__GIT_CNOTE_DETAILS.ClientID %>').find('table').find('tr').each(function () {
        			$(this).find('td:last').find('a').each(function () {
        				var linkVal = $.trim($(this).text());
        				if (linkVal.toUpperCase() == 'EDIT') {
        					$(this).text('Select');
        				}
        				if (linkVal.toUpperCase() == 'ADD') {
        					$(this).remove();
        				}
        				if (linkVal.toUpperCase() == 'DELETE') {
        					$(this).remove();
        				}
        			});
        		});
        	}
        })();
}
function onValidate_GIT__GITSNOTCLM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "GIT", "GITSNOTCLM", "ChildScreen");
        })();
        /** 
         * Note: This script removes the 'Delete' linkbutton in every row of the childscreen grid. It also renames 'Edit' to 'Select'
         * @param GIT The object name of the control to set.
         * @parma GIT_SCNOTE_DETAILS The property name of the control to set to the result of the calculated premium.
         */
        (function(){
        	if (isOnLoad) {
        		$('#<%=GIT__GIT_SCNOTE_DETAILS.ClientID %>').find('table').find('tr').each(function () {
        			$(this).find('td:last').find('a').each(function () {
        				var linkVal = $.trim($(this).text());
        				if (linkVal.toUpperCase() == 'EDIT') {
        					$(this).text('Select');
        				}
        				if (linkVal.toUpperCase() == 'ADD') {
        					$(this).remove();
        				}
        				if (linkVal.toUpperCase() == 'DELETE') {
        					$(this).remove();
        				}
        			});
        		});
        	}
        })();
}
function DoLogic(isOnLoad) {
    onValidate_GIT__RISKATTACHDATE(null, null, null, isOnLoad);
    onValidate_GIT__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_GIT__GIT0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_GIT__GIT0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_GIT__GIT13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_GIT__GIT13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_GIT__GIT25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_GIT__GIT25_36_AMOUNT(null, null, null, isOnLoad);
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
    onValidate_GIT__LL_SI(null, null, null, isOnLoad);
    onValidate_GIT__LL_NUM(null, null, null, isOnLoad);
    onValidate_GIT__AH_SI(null, null, null, isOnLoad);
    onValidate_GIT__AH_LOAD_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__FAP_PERC(null, null, null, isOnLoad);
    onValidate_GIT_FAP__FAP_MIN_AMT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__FAP_MAX_AMT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__THEFT_PERC(null, null, null, isOnLoad);
    onValidate_GIT_FAP__THEFT_MIN_AMT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__THEFT_MAX_AMT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__AFAP_PERC(null, null, null, isOnLoad);
    onValidate_GIT_FAP__AFAP_MIN_AMT(null, null, null, isOnLoad);
    onValidate_GIT_FAP__AFAP_MAX_AMT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_ACPC(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__ACPC_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_DEB(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__DEB_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_FIRE(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__FIRE_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_HIJACK(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__HIJACK_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_RIOT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__RIOT_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_EXT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_FAP(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_MIN_AMNT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__IS_NASRIA(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__NASRIA_LIMIT(null, null, null, isOnLoad);
    onValidate_GIT_EXTENSIONS__EXT_DESC(null, null, null, isOnLoad);
    onValidate_GIT__GITENDCLM(null, null, null, isOnLoad);
    onValidate_GIT__GITNOTECLM(null, null, null, isOnLoad);
    onValidate_GIT__GITSNOTCLM(null, null, null, isOnLoad);
}
</script>

  
  <div class="risk-screen">
        <NexusControl:ProgressBar ID="ucProgressBar" runat="server" />
	 <div class="card">
        <Nexus:ImprovedTabIndex ID="TabIndex" runat="server" CssClass="TabContainer" TabContainerClass="TabNav" ActiveTabClass="ActiveTab" />
               
        <div class="card-footer clearfix">
            <asp:Button ID="btnBackTop" runat="server" SkinID="buttonSecondary" Text="Back" OnClick="BackButton" CausesValidation="false" />
			<asp:Button ID="btnNextTop" runat="server" SkinID="buttonPrimary" Text="Next" OnClick="NextButton" />
        </div>
		<div class="card-body clearfix">
			<div id="inner_content" style="">
				<!-- GeneralLayoutContainer -->
<div id="id6d0d6023b4824a1d8a93ce106faf7991" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idc737403840724870b15217f903b6b0f6" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading97" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="GIT" 
		data-property-name="RISKATTACHDATE" 
		id="pb-container-datejquerycompatible-GIT-RISKATTACHDATE">
		<asp:Label ID="lblGIT_RISKATTACHDATE" runat="server" AssociatedControlID="GIT__RISKATTACHDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="GIT__RISKATTACHDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calGIT__RISKATTACHDATE" runat="server" LinkedControl="GIT__RISKATTACHDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valGIT_RISKATTACHDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_GIT__RISKATTACHDATE" 
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
		data-object-name="GIT" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-GIT-EFFECTIVEDATE">
		<asp:Label ID="lblGIT_EFFECTIVEDATE" runat="server" AssociatedControlID="GIT__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="GIT__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calGIT__EFFECTIVEDATE" runat="server" LinkedControl="GIT__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valGIT_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_GIT__EFFECTIVEDATE" 
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
		if ($("#idc737403840724870b15217f903b6b0f6 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idc737403840724870b15217f903b6b0f6 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idc737403840724870b15217f903b6b0f6 div ul li").each(function(){		  
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
			$("#idc737403840724870b15217f903b6b0f6 div ul li").each(function(){		  
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
		styleString += "#idc737403840724870b15217f903b6b0f6 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idc737403840724870b15217f903b6b0f6 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc737403840724870b15217f903b6b0f6 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc737403840724870b15217f903b6b0f6 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idc737403840724870b15217f903b6b0f6 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc737403840724870b15217f903b6b0f6 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc737403840724870b15217f903b6b0f6 input{text-align:left;}"; break;
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
<div id="Pastclaimscount" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading98" runat="server" Text="Past Claims Count" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="7:17:14:17:14:17:14" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:7%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label183">
		<span class="label" id="label183"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label184">
		<span class="label" id="label184">0-12 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label185">
		<span class="label" id="label185">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label186">
		<span class="label" id="label186">13-24 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label187">
		<span class="label" id="label187">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label188">
		<span class="label" id="label188">25-36 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label189">
		<span class="label" id="label189">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:7%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label190">
		<span class="label" id="label190">Goods in Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GIT" 
		data-property-name="GIT0_12_MONTHS" 
		id="pb-container-list-GIT-GIT0_12_MONTHS">
		<asp:Label ID="lblGIT_GIT0_12_MONTHS" runat="server" AssociatedControlID="GIT__GIT0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GIT__GIT0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GIT__GIT0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGIT_GIT0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT0_12_MONTHS"
			ClientValidationFunction="onValidate_GIT__GIT0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="GIT0_12_AMOUNT" 
		id="pb-container-currency-GIT-GIT0_12_AMOUNT">
		<asp:Label ID="lblGIT_GIT0_12_AMOUNT" runat="server" AssociatedControlID="GIT__GIT0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__GIT0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_GIT0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT0_12_AMOUNT"
			ClientValidationFunction="onValidate_GIT__GIT0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GIT" 
		data-property-name="GIT13_24_MONTHS" 
		id="pb-container-list-GIT-GIT13_24_MONTHS">
		<asp:Label ID="lblGIT_GIT13_24_MONTHS" runat="server" AssociatedControlID="GIT__GIT13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GIT__GIT13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GIT__GIT13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGIT_GIT13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT13_24_MONTHS"
			ClientValidationFunction="onValidate_GIT__GIT13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="GIT13_24_AMOUNT" 
		id="pb-container-currency-GIT-GIT13_24_AMOUNT">
		<asp:Label ID="lblGIT_GIT13_24_AMOUNT" runat="server" AssociatedControlID="GIT__GIT13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__GIT13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_GIT13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT13_24_AMOUNT"
			ClientValidationFunction="onValidate_GIT__GIT13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:17%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GIT" 
		data-property-name="GIT25_36_MONTHS" 
		id="pb-container-list-GIT-GIT25_36_MONTHS">
		<asp:Label ID="lblGIT_GIT25_36_MONTHS" runat="server" AssociatedControlID="GIT__GIT25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GIT__GIT25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_CLAIMS_COUNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GIT__GIT25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGIT_GIT25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT25_36_MONTHS"
			ClientValidationFunction="onValidate_GIT__GIT25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="GIT25_36_AMOUNT" 
		id="pb-container-currency-GIT-GIT25_36_AMOUNT">
		<asp:Label ID="lblGIT_GIT25_36_AMOUNT" runat="server" AssociatedControlID="GIT__GIT25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__GIT25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_GIT25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.GIT25_36_AMOUNT"
			ClientValidationFunction="onValidate_GIT__GIT25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="GIT0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-GIT-GIT0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="GIT__GIT0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="GIT13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-GIT-GIT13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="GIT__GIT13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="GIT25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-GIT-GIT25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="GIT__GIT25_36_MONTHSCode" runat="server" />

		

		
	
		
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
		if ($("#Pastclaimscount div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Pastclaimscount div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Pastclaimscount div ul li").each(function(){		  
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
			$("#Pastclaimscount div ul li").each(function(){		  
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
		styleString += "#Pastclaimscount label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Pastclaimscount label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Pastclaimscount label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Pastclaimscount label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Pastclaimscount input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Pastclaimscount input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Pastclaimscount input{text-align:left;}"; break;
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
<div id="id577d74be6fb541aa9400696ea98a5004" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading99" runat="server" Text="Rating Method" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="GIT" 
		data-property-name="BASIS_OF_COVER" 
		id="pb-container-list-GIT-BASIS_OF_COVER">
		<asp:Label ID="lblGIT_BASIS_OF_COVER" runat="server" AssociatedControlID="GIT__BASIS_OF_COVER" 
			Text="Basis of Cover" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="GIT__BASIS_OF_COVER" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_GIT_BASISCOVER" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_GIT__BASIS_OF_COVER(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valGIT_BASIS_OF_COVER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Basis of Cover"
			ClientValidationFunction="onValidate_GIT__BASIS_OF_COVER" 
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
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="BASIS_OF_COVERCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-GIT-BASIS_OF_COVERCode">

		
		
			
		
				<asp:HiddenField ID="GIT__BASIS_OF_COVERCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="GIT" 
		data-property-name="BASIS_OF_RATINGCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-GIT-BASIS_OF_RATINGCode">

		
		
			
		
				<asp:HiddenField ID="GIT__BASIS_OF_RATINGCode" runat="server" />

		

		
	
		
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
		if ($("#id577d74be6fb541aa9400696ea98a5004 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id577d74be6fb541aa9400696ea98a5004 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id577d74be6fb541aa9400696ea98a5004 div ul li").each(function(){		  
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
			$("#id577d74be6fb541aa9400696ea98a5004 div ul li").each(function(){		  
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
		styleString += "#id577d74be6fb541aa9400696ea98a5004 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id577d74be6fb541aa9400696ea98a5004 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id577d74be6fb541aa9400696ea98a5004 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id577d74be6fb541aa9400696ea98a5004 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id577d74be6fb541aa9400696ea98a5004 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id577d74be6fb541aa9400696ea98a5004 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id577d74be6fb541aa9400696ea98a5004 input{text-align:left;}"; break;
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
<div id="idaef95cb4b52c49f09ad999abfe99ad0f" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading100" runat="server" Text="Means of Conveyance" /></legend>
				
				
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
		if ($("#idaef95cb4b52c49f09ad999abfe99ad0f div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idaef95cb4b52c49f09ad999abfe99ad0f div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idaef95cb4b52c49f09ad999abfe99ad0f div ul li").each(function(){		  
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
			$("#idaef95cb4b52c49f09ad999abfe99ad0f div ul li").each(function(){		  
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
		styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idaef95cb4b52c49f09ad999abfe99ad0f input{text-align:left;}"; break;
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
<div id="id3e6597d53a244aeda699042ea1fff835" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading101" runat="server" Text="Description of Goods Carried" /></legend>
				
				
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
		if ($("#id3e6597d53a244aeda699042ea1fff835 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id3e6597d53a244aeda699042ea1fff835 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id3e6597d53a244aeda699042ea1fff835 div ul li").each(function(){		  
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
			$("#id3e6597d53a244aeda699042ea1fff835 div ul li").each(function(){		  
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
		styleString += "#id3e6597d53a244aeda699042ea1fff835 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id3e6597d53a244aeda699042ea1fff835 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3e6597d53a244aeda699042ea1fff835 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3e6597d53a244aeda699042ea1fff835 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id3e6597d53a244aeda699042ea1fff835 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3e6597d53a244aeda699042ea1fff835 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3e6597d53a244aeda699042ea1fff835 input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading102" runat="server" Text="Goods in Transit - Annual Carry" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label191">
		<span class="label" id="label191">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label192">
		<span class="label" id="label192">Load Limit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="AC_SI" 
		id="pb-container-currency-GIT-AC_SI">
		<asp:Label ID="lblGIT_AC_SI" runat="server" AssociatedControlID="GIT__AC_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AC_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AC_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AC_SI"
			ClientValidationFunction="onValidate_GIT__AC_SI" 
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
		
				
	              <legend><asp:Label ID="lblHeading103" runat="server" Text="Goods in Transit - Load Limit" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label193">
		<span class="label" id="label193">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label194">
		<span class="label" id="label194">Number of Vehicles</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="LL_SI" 
		id="pb-container-currency-GIT-LL_SI">
		<asp:Label ID="lblGIT_LL_SI" runat="server" AssociatedControlID="GIT__LL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__LL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_LL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.LL_SI"
			ClientValidationFunction="onValidate_GIT__LL_SI" 
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
		
				
	              <legend><asp:Label ID="lblHeading104" runat="server" Text="Goods in Transit - Annual Haulage Fee" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label195">
		<span class="label" id="label195">Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label196">
		<span class="label" id="label196">Load Limit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT" 
		data-property-name="AH_SI" 
		id="pb-container-currency-GIT-AH_SI">
		<asp:Label ID="lblGIT_AH_SI" runat="server" AssociatedControlID="GIT__AH_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT__AH_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_AH_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT.AH_SI"
			ClientValidationFunction="onValidate_GIT__AH_SI" 
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
<div id="id842e0e4ab3794fed9063596f44ba5cd9" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading105" runat="server" Text="First Amount Payable" /></legend>
				
				
				<div data-column-count="4" data-column-ratio="13:29:29:29" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label197">
		<span class="label" id="label197"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label198">
		<span class="label" id="label198">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label199">
		<span class="label" id="label199">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label200">
		<span class="label" id="label200">Max Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label201">
		<span class="label" id="label201">Basic</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT_FAP" 
		data-property-name="FAP_PERC" 
		id="pb-container-percentage-GIT_FAP-FAP_PERC">
		<asp:Label ID="lblGIT_FAP_FAP_PERC" runat="server" AssociatedControlID="GIT_FAP__FAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_FAP__FAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_FAP_FAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.FAP_PERC"
			ClientValidationFunction="onValidate_GIT_FAP__FAP_PERC" 
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
		data-object-name="GIT_FAP" 
		data-property-name="FAP_MIN_AMT" 
		id="pb-container-currency-GIT_FAP-FAP_MIN_AMT">
		<asp:Label ID="lblGIT_FAP_FAP_MIN_AMT" runat="server" AssociatedControlID="GIT_FAP__FAP_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__FAP_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_FAP_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.FAP_MIN_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__FAP_MIN_AMT" 
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
		data-object-name="GIT_FAP" 
		data-property-name="FAP_MAX_AMT" 
		id="pb-container-currency-GIT_FAP-FAP_MAX_AMT">
		<asp:Label ID="lblGIT_FAP_FAP_MAX_AMT" runat="server" AssociatedControlID="GIT_FAP__FAP_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__FAP_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_FAP_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.FAP_MAX_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__FAP_MAX_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label202">
		<span class="label" id="label202">Theft</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT_FAP" 
		data-property-name="THEFT_PERC" 
		id="pb-container-percentage-GIT_FAP-THEFT_PERC">
		<asp:Label ID="lblGIT_FAP_THEFT_PERC" runat="server" AssociatedControlID="GIT_FAP__THEFT_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_FAP__THEFT_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_FAP_THEFT_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.THEFT_PERC"
			ClientValidationFunction="onValidate_GIT_FAP__THEFT_PERC" 
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
		data-object-name="GIT_FAP" 
		data-property-name="THEFT_MIN_AMT" 
		id="pb-container-currency-GIT_FAP-THEFT_MIN_AMT">
		<asp:Label ID="lblGIT_FAP_THEFT_MIN_AMT" runat="server" AssociatedControlID="GIT_FAP__THEFT_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__THEFT_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_THEFT_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.THEFT_MIN_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__THEFT_MIN_AMT" 
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
		data-object-name="GIT_FAP" 
		data-property-name="THEFT_MAX_AMT" 
		id="pb-container-currency-GIT_FAP-THEFT_MAX_AMT">
		<asp:Label ID="lblGIT_FAP_THEFT_MAX_AMT" runat="server" AssociatedControlID="GIT_FAP__THEFT_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__THEFT_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_THEFT_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.THEFT_MAX_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__THEFT_MAX_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label203">
		<span class="label" id="label203">Additional First Amount Payable</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:29%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="GIT_FAP" 
		data-property-name="AFAP_PERC" 
		id="pb-container-percentage-GIT_FAP-AFAP_PERC">
		<asp:Label ID="lblGIT_FAP_AFAP_PERC" runat="server" AssociatedControlID="GIT_FAP__AFAP_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="GIT_FAP__AFAP_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valGIT_FAP_AFAP_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.AFAP_PERC"
			ClientValidationFunction="onValidate_GIT_FAP__AFAP_PERC" 
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
		data-object-name="GIT_FAP" 
		data-property-name="AFAP_MIN_AMT" 
		id="pb-container-currency-GIT_FAP-AFAP_MIN_AMT">
		<asp:Label ID="lblGIT_FAP_AFAP_MIN_AMT" runat="server" AssociatedControlID="GIT_FAP__AFAP_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__AFAP_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_AFAP_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.AFAP_MIN_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__AFAP_MIN_AMT" 
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
		data-object-name="GIT_FAP" 
		data-property-name="AFAP_MAX_AMT" 
		id="pb-container-currency-GIT_FAP-AFAP_MAX_AMT">
		<asp:Label ID="lblGIT_FAP_AFAP_MAX_AMT" runat="server" AssociatedControlID="GIT_FAP__AFAP_MAX_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_FAP__AFAP_MAX_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_FAP_AFAP_MAX_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_FAP.AFAP_MAX_AMT"
			ClientValidationFunction="onValidate_GIT_FAP__AFAP_MAX_AMT" 
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
		if ($("#id842e0e4ab3794fed9063596f44ba5cd9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id842e0e4ab3794fed9063596f44ba5cd9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id842e0e4ab3794fed9063596f44ba5cd9 div ul li").each(function(){		  
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
			$("#id842e0e4ab3794fed9063596f44ba5cd9 div ul li").each(function(){		  
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
		styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id842e0e4ab3794fed9063596f44ba5cd9 input{text-align:left;}"; break;
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
<div id="id148397e7739145c6965bb5796b861e8c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading106" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="8:23:23:23:23" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label204">
		<span class="label" id="label204"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label205">
		<span class="label" id="label205"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label206">
		<span class="label" id="label206">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label207">
		<span class="label" id="label207">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label208">
		<span class="label" id="label208">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label209">
		<span class="label" id="label209">Additional Claims Preparation Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label210">
		<span class="label" id="label210"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label211">
		<span class="label" id="label211"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label212">
		<span class="label" id="label212">Debris Removal</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label213">
		<span class="label" id="label213">Fire Extinguishing Charges</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label214">
		<span class="label" id="label214">Hijacking of Conveying Vehicle</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label215">
		<span class="label" id="label215"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label216">
		<span class="label" id="label216">Riot & Strike</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label217">
		<span class="label" id="label217"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label218">
		<span class="label" id="label218">Extended Territories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label219">
		<span class="label" id="label219"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:8%;" >
								
								
										 
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
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label220">
		<span class="label" id="label220">NASRIA - Goods in Transit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="GIT_EXTENSIONS" 
		data-property-name="NASRIA_LIMIT" 
		id="pb-container-currency-GIT_EXTENSIONS-NASRIA_LIMIT">
		<asp:Label ID="lblGIT_EXTENSIONS_NASRIA_LIMIT" runat="server" AssociatedControlID="GIT_EXTENSIONS__NASRIA_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="GIT_EXTENSIONS__NASRIA_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valGIT_EXTENSIONS_NASRIA_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for GIT_EXTENSIONS.NASRIA_LIMIT"
			ClientValidationFunction="onValidate_GIT_EXTENSIONS__NASRIA_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label221">
		<span class="label" id="label221"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:23%;" >
								
								
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
		if ($("#id148397e7739145c6965bb5796b861e8c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id148397e7739145c6965bb5796b861e8c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id148397e7739145c6965bb5796b861e8c div ul li").each(function(){		  
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
			$("#id148397e7739145c6965bb5796b861e8c div ul li").each(function(){		  
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
		styleString += "#id148397e7739145c6965bb5796b861e8c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id148397e7739145c6965bb5796b861e8c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id148397e7739145c6965bb5796b861e8c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id148397e7739145c6965bb5796b861e8c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id148397e7739145c6965bb5796b861e8c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id148397e7739145c6965bb5796b861e8c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id148397e7739145c6965bb5796b861e8c input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading107" runat="server" Text="Extended Territories Description" /></legend>
				
				
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
		
				
	              <legend><asp:Label ID="lblHeading108" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_GIT__GITENDCLM"
		data-field-type="Child" 
		data-object-name="GIT" 
		data-property-name="GITENDCLM" 
		id="pb-container-childscreen-GIT-GITENDCLM">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="GIT__GIT_CLAUSEPREM" runat="server" ScreenCode="GITENDCLM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITENDCLM/GITENDCLM_Endorsement_Premium.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Endorsement" DataField="ENDORSE_CAP" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valGIT_GITENDCLM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for GIT.GITENDCLM"
						ClientValidationFunction="onValidate_GIT__GITENDCLM" 
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
<div id="id3b08d2057450437b85ae68937dba76d1" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading109" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_GIT__GITNOTECLM"
		data-field-type="Child" 
		data-object-name="GIT" 
		data-property-name="GITNOTECLM" 
		id="pb-container-childscreen-GIT-GITNOTECLM">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="GIT__GIT_CNOTE_DETAILS" runat="server" ScreenCode="GITNOTECLM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITNOTECLM/GITNOTECLM_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="Date_Created" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="Created_By" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="Risk_Cover" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="Note_Subject" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valGIT_GITNOTECLM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for GIT.GITNOTECLM"
						ClientValidationFunction="onValidate_GIT__GITNOTECLM" 
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
		if ($("#id3b08d2057450437b85ae68937dba76d1 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id3b08d2057450437b85ae68937dba76d1 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id3b08d2057450437b85ae68937dba76d1 div ul li").each(function(){		  
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
			$("#id3b08d2057450437b85ae68937dba76d1 div ul li").each(function(){		  
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
		styleString += "#id3b08d2057450437b85ae68937dba76d1 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id3b08d2057450437b85ae68937dba76d1 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3b08d2057450437b85ae68937dba76d1 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3b08d2057450437b85ae68937dba76d1 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id3b08d2057450437b85ae68937dba76d1 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3b08d2057450437b85ae68937dba76d1 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3b08d2057450437b85ae68937dba76d1 input{text-align:left;}"; break;
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
<div id="id582f0cf25c814b64b90ced5b9796fcb3" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading110" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_GIT__GITSNOTCLM"
		data-field-type="Child" 
		data-object-name="GIT" 
		data-property-name="GITSNOTCLM" 
		id="pb-container-childscreen-GIT-GITSNOTCLM">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="GIT__GIT_SCNOTE_DETAILS" runat="server" ScreenCode="GITSNOTCLM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="GITSNOTCLM/GITSNOTCLM_Note_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Date Created" DataField="Date_Created" DataFormatString="{0:d}"/>
<Nexus:RiskAttribute HeaderText="Created by" DataField="Created_By" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Cover Type" DataField="Risk_Cover" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Note Description" DataField="Note_Subject" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valGIT_GITSNOTCLM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for GIT.GITSNOTCLM"
						ClientValidationFunction="onValidate_GIT__GITSNOTCLM" 
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
		if ($("#id582f0cf25c814b64b90ced5b9796fcb3 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id582f0cf25c814b64b90ced5b9796fcb3 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id582f0cf25c814b64b90ced5b9796fcb3 div ul li").each(function(){		  
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
			$("#id582f0cf25c814b64b90ced5b9796fcb3 div ul li").each(function(){		  
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
		styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id582f0cf25c814b64b90ced5b9796fcb3 input{text-align:left;}"; break;
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
        <div class="card-footer clearfix">
            <asp:Button ID="btnBack" runat="server" SkinID="buttonSecondary" Text="Back" OnClick="BackButton" CausesValidation="false" />
			<asp:Button ID="btnNext" runat="server" SkinID="buttonPrimary" Text="Next" OnClick="NextButton" />
            
        </div>
    </div>
     <asp:ValidationSummary ID="validationSummeryBox" runat="server" DisplayMode="BulletList" HeaderText="Correct the below given errors" EnableClientScript="true" CssClass="validation-summary" /> 
   </div>
</div>
</asp:Content>