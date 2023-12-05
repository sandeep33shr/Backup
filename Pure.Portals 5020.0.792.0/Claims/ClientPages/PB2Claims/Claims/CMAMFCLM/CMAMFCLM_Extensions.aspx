<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMAMFCLM_Extensions.aspx.vb" Inherits="Nexus.PB2_CMAMFCLM_Extensions" %>

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
function onValidate_FLEET_EXTENSIONS__LOSS_KEYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_KEYS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__LOSS_KEYS_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_KEYS_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'LOSS_KEYS_LIMIT');
        			
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
function onValidate_FLEET_EXTENSIONS__LOSS_KEYS_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_KEYS_FAP_PER", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_FAP_PER");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'LOSS_KEYS_FAP_PER');
        			
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
function onValidate_FLEET_EXTENSIONS__LOSS_KEYS_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_KEYS_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_KEYS_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'LOSS_KEYS_MIN_AMT');
        			
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
function onValidate_FLEET_EXTENSIONS__CAR_HIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "CAR_HIRE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "CAR_HIRE");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__CAR_HIRE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "CAR_HIRE_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "CAR_HIRE_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "CAR_HIRE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'CAR_HIRE_LIMIT');
        			
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
function onValidate_FLEET_EXTENSIONS__CAR_HIRE_DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "CAR_HIRE_DAYS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "CAR_HIRE_DAYS");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__LOSS_USE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_USE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_USE");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__LOSS_USE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_USE_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_USE_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_USE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'LOSS_USE_LIMIT');
        			
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
function onValidate_FLEET_EXTENSIONS__LOSS_USE_DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "LOSS_USE_DAYS", "Integer");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "LOSS_USE_DAYS");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__WRECKAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "WRECKAGE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "WRECKAGE");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__WRECKAGE_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "WRECKAGE_LIMIT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "WRECKAGE_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "WRECKAGE_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'WRECKAGE_LIMIT');
        			
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
function onValidate_FLEET_EXTENSIONS__EXT_TERITORY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "EXT_TERITORY", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__EXT_TERITORY_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "EXT_TERITORY_FAP_PER", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY_FAP_PER");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'EXT_TERITORY_FAP_PER');
        			
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
function onValidate_FLEET_EXTENSIONS__EXT_TERITORY_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "EXT_TERITORY_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'EXT_TERITORY_MIN_AMT');
        			
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
function onValidate_FLEET_EXTENSIONS__EXT_TERITORY_DESC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "EXT_TERITORY_DESC", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "EXT_TERITORY_DESC");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__RIOT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "RIOT", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "RIOT");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__EXCESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "EXCESS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "EXCESS");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__WINDSCREEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "WINDSCREEN", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "WINDSCREEN");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__WINDSCREEN_FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "WINDSCREEN_FAP_PER", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "WINDSCREEN_FAP_PER");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "WINDSCREEN_FAP_PER");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'WINDSCREEN_FAP_PER');
        			
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
function onValidate_FLEET_EXTENSIONS__WINDSCREEN_MIN_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "WINDSCREEN_MIN_AMT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "WINDSCREEN_MIN_AMT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "WINDSCREEN_MIN_AMT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'WINDSCREEN_MIN_AMT');
        			
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
function onValidate_FLEET_EXTENSIONS__IS_NASRIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "IS_NASRIA", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "IS_NASRIA");
        	field.setReadOnly(true);
        })();
        /** 
         * ToggleContainer
         * @param frmFleetNASRIA The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("FLEET_EXTENSIONS","IS_NASRIA");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmFleetNASRIA', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmFleetNASRIA', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("FLEET_EXTENSIONS", "IS_NASRIA"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_FLEET_EXTENSIONS__ROAD_ASSIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "ROAD_ASSIST", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "ROAD_ASSIST");
        	field.setReadOnly(true);
        })();
}
function onValidate_FLEET_EXTENSIONS__NASRIA_LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "NASRIA_LIMIT", "Integer");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "NASRIA_LIMIT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("FLEET_EXTENSIONS", "NASRIA_LIMIT");
        		
        		
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
        
        			var field = Field.getInstance('FLEET_EXTENSIONS', 'NASRIA_LIMIT');
        			
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("FLEET_EXTENSIONS.NASRIA_LIMIT");
        			window.setControlWidth(field, "0.8", "FLEET_EXTENSIONS", "NASRIA_LIMIT");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblFLEET_EXTENSIONS_NASRIA_LIMIT");
        			    var ele = document.getElementById('ctl00_cntMainBody_FLEET_EXTENSIONS__NASRIA_LIMIT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_FLEET_EXTENSIONS__NASRIA_LIMIT_lblFindParty");
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
function onValidate_FLEET_EXTENSIONS__NASRIA_CATEGORY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "FLEET_EXTENSIONS", "NASRIA_CATEGORY", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("FLEET_EXTENSIONS", "NASRIA_CATEGORY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("FLEET_EXTENSIONS.NASRIA_CATEGORY");
        			window.setControlWidth(field, "0.8", "FLEET_EXTENSIONS", "NASRIA_CATEGORY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblFLEET_EXTENSIONS_NASRIA_CATEGORY");
        			    var ele = document.getElementById('ctl00_cntMainBody_FLEET_EXTENSIONS__NASRIA_CATEGORY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_FLEET_EXTENSIONS__NASRIA_CATEGORY_lblFindParty");
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
function DoLogic(isOnLoad) {
    onValidate_FLEET_EXTENSIONS__LOSS_KEYS(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_KEYS_LIMIT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_KEYS_FAP_PER(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_KEYS_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__CAR_HIRE(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__CAR_HIRE_LIMIT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__CAR_HIRE_DAYS(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_USE(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_USE_LIMIT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__LOSS_USE_DAYS(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__WRECKAGE(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__WRECKAGE_LIMIT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__EXT_TERITORY(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__EXT_TERITORY_FAP_PER(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__EXT_TERITORY_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__EXT_TERITORY_DESC(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__RIOT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__EXCESS(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__WINDSCREEN(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__WINDSCREEN_FAP_PER(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__WINDSCREEN_MIN_AMT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__IS_NASRIA(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__ROAD_ASSIST(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__NASRIA_LIMIT(null, null, null, isOnLoad);
    onValidate_FLEET_EXTENSIONS__NASRIA_CATEGORY(null, null, null, isOnLoad);
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
<div id="id154b4772a7c14060aedeeee80211cf3f" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idad8d85b5b3434be0be28a21706c57174" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading29" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="6" data-column-ratio="10:18:18:18:18:18" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label25">
		<span class="label" id="label25"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label26">
		<span class="label" id="label26"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label27">
		<span class="label" id="label27">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label28">
		<span class="label" id="label28">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label29">
		<span class="label" id="label29">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label30">
		<span class="label" id="label30">Description</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_LOSS_KEYS" for="ctl00_cntMainBody_FLEET_EXTENSIONS__LOSS_KEYS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_KEYS" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-LOSS_KEYS">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__LOSS_KEYS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_KEYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_KEYS"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_KEYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label31">
		<span class="label" id="label31">Loss of Keys </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_KEYS_LIMIT" 
		id="pb-container-currency-FLEET_EXTENSIONS-LOSS_KEYS_LIMIT">
		<asp:Label ID="lblFLEET_EXTENSIONS_LOSS_KEYS_LIMIT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__LOSS_KEYS_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__LOSS_KEYS_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_KEYS_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_KEYS_LIMIT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_KEYS_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_KEYS_FAP_PER" 
		id="pb-container-percentage-FLEET_EXTENSIONS-LOSS_KEYS_FAP_PER">
		<asp:Label ID="lblFLEET_EXTENSIONS_LOSS_KEYS_FAP_PER" runat="server" AssociatedControlID="FLEET_EXTENSIONS__LOSS_KEYS_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FLEET_EXTENSIONS__LOSS_KEYS_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_KEYS_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_KEYS_FAP_PER"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_KEYS_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_KEYS_MIN_AMT" 
		id="pb-container-currency-FLEET_EXTENSIONS-LOSS_KEYS_MIN_AMT">
		<asp:Label ID="lblFLEET_EXTENSIONS_LOSS_KEYS_MIN_AMT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__LOSS_KEYS_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__LOSS_KEYS_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_KEYS_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_KEYS_MIN_AMT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_KEYS_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label32">
		<span class="label" id="label32"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_CAR_HIRE" for="ctl00_cntMainBody_FLEET_EXTENSIONS__CAR_HIRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="CAR_HIRE" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-CAR_HIRE">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__CAR_HIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_CAR_HIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.CAR_HIRE"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__CAR_HIRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label33">
		<span class="label" id="label33">Vehicle Hire </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="CAR_HIRE_LIMIT" 
		id="pb-container-currency-FLEET_EXTENSIONS-CAR_HIRE_LIMIT">
		<asp:Label ID="lblFLEET_EXTENSIONS_CAR_HIRE_LIMIT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__CAR_HIRE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__CAR_HIRE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_CAR_HIRE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.CAR_HIRE_LIMIT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__CAR_HIRE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label34">
		<span class="label" id="label34">Number of Days </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="CAR_HIRE_DAYS" 
		id="pb-container-list-FLEET_EXTENSIONS-CAR_HIRE_DAYS">
		<asp:Label ID="lblFLEET_EXTENSIONS_CAR_HIRE_DAYS" runat="server" AssociatedControlID="FLEET_EXTENSIONS__CAR_HIRE_DAYS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="FLEET_EXTENSIONS__CAR_HIRE_DAYS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_NO_DAYS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_FLEET_EXTENSIONS__CAR_HIRE_DAYS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valFLEET_EXTENSIONS_CAR_HIRE_DAYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.CAR_HIRE_DAYS"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__CAR_HIRE_DAYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label35">
		<span class="label" id="label35"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_LOSS_USE" for="ctl00_cntMainBody_FLEET_EXTENSIONS__LOSS_USE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_USE" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-LOSS_USE">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__LOSS_USE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_USE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_USE"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_USE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label36">
		<span class="label" id="label36">Loss of Use </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_USE_LIMIT" 
		id="pb-container-currency-FLEET_EXTENSIONS-LOSS_USE_LIMIT">
		<asp:Label ID="lblFLEET_EXTENSIONS_LOSS_USE_LIMIT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__LOSS_USE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__LOSS_USE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_USE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_USE_LIMIT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_USE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label37">
		<span class="label" id="label37">Number of Days </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="LOSS_USE_DAYS" 
		id="pb-container-integer-FLEET_EXTENSIONS-LOSS_USE_DAYS">
		<asp:Label ID="lblFLEET_EXTENSIONS_LOSS_USE_DAYS" runat="server" AssociatedControlID="FLEET_EXTENSIONS__LOSS_USE_DAYS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="FLEET_EXTENSIONS__LOSS_USE_DAYS" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valFLEET_EXTENSIONS_LOSS_USE_DAYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.LOSS_USE_DAYS"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__LOSS_USE_DAYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label38">
		<span class="label" id="label38"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_WRECKAGE" for="ctl00_cntMainBody_FLEET_EXTENSIONS__WRECKAGE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="WRECKAGE" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-WRECKAGE">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__WRECKAGE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_WRECKAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.WRECKAGE"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__WRECKAGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label39">
		<span class="label" id="label39">Wreckage Removal</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="WRECKAGE_LIMIT" 
		id="pb-container-currency-FLEET_EXTENSIONS-WRECKAGE_LIMIT">
		<asp:Label ID="lblFLEET_EXTENSIONS_WRECKAGE_LIMIT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__WRECKAGE_LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__WRECKAGE_LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_WRECKAGE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.WRECKAGE_LIMIT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__WRECKAGE_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label40">
		<span class="label" id="label40"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label41">
		<span class="label" id="label41"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label42">
		<span class="label" id="label42"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_EXT_TERITORY" for="ctl00_cntMainBody_FLEET_EXTENSIONS__EXT_TERITORY" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="EXT_TERITORY" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-EXT_TERITORY">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__EXT_TERITORY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_EXT_TERITORY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.EXT_TERITORY"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__EXT_TERITORY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label43">
		<span class="label" id="label43">Extended Territories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label44">
		<span class="label" id="label44"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="EXT_TERITORY_FAP_PER" 
		id="pb-container-percentage-FLEET_EXTENSIONS-EXT_TERITORY_FAP_PER">
		<asp:Label ID="lblFLEET_EXTENSIONS_EXT_TERITORY_FAP_PER" runat="server" AssociatedControlID="FLEET_EXTENSIONS__EXT_TERITORY_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FLEET_EXTENSIONS__EXT_TERITORY_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_EXT_TERITORY_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for "
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__EXT_TERITORY_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="EXT_TERITORY_MIN_AMT" 
		id="pb-container-currency-FLEET_EXTENSIONS-EXT_TERITORY_MIN_AMT">
		<asp:Label ID="lblFLEET_EXTENSIONS_EXT_TERITORY_MIN_AMT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__EXT_TERITORY_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__EXT_TERITORY_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_EXT_TERITORY_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.EXT_TERITORY_MIN_AMT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__EXT_TERITORY_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="EXT_TERITORY_DESC" 
		 
		
		 
		id="pb-container-text-FLEET_EXTENSIONS-EXT_TERITORY_DESC">

		
		<asp:Label ID="lblFLEET_EXTENSIONS_EXT_TERITORY_DESC" runat="server" AssociatedControlID="FLEET_EXTENSIONS__EXT_TERITORY_DESC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="FLEET_EXTENSIONS__EXT_TERITORY_DESC" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valFLEET_EXTENSIONS_EXT_TERITORY_DESC" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.EXT_TERITORY_DESC"
					ClientValidationFunction="onValidate_FLEET_EXTENSIONS__EXT_TERITORY_DESC"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_RIOT" for="ctl00_cntMainBody_FLEET_EXTENSIONS__RIOT" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="RIOT" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-RIOT">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__RIOT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_RIOT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.RIOT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__RIOT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label45">
		<span class="label" id="label45">Riot & Strike </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label46">
		<span class="label" id="label46"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label47">
		<span class="label" id="label47"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label48">
		<span class="label" id="label48"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label49">
		<span class="label" id="label49"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_EXCESS" for="ctl00_cntMainBody_FLEET_EXTENSIONS__EXCESS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="EXCESS" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-EXCESS">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__EXCESS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_EXCESS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.EXCESS"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__EXCESS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label50">
		<span class="label" id="label50">Excess Waiver</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label51">
		<span class="label" id="label51"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label52">
		<span class="label" id="label52"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label53">
		<span class="label" id="label53"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label54">
		<span class="label" id="label54"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_WINDSCREEN" for="ctl00_cntMainBody_FLEET_EXTENSIONS__WINDSCREEN" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="WINDSCREEN" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-WINDSCREEN">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__WINDSCREEN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_WINDSCREEN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.WINDSCREEN"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__WINDSCREEN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label55">
		<span class="label" id="label55">Windscreen</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label56">
		<span class="label" id="label56"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="WINDSCREEN_FAP_PER" 
		id="pb-container-percentage-FLEET_EXTENSIONS-WINDSCREEN_FAP_PER">
		<asp:Label ID="lblFLEET_EXTENSIONS_WINDSCREEN_FAP_PER" runat="server" AssociatedControlID="FLEET_EXTENSIONS__WINDSCREEN_FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="FLEET_EXTENSIONS__WINDSCREEN_FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_WINDSCREEN_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.WINDSCREEN_FAP_PER"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__WINDSCREEN_FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="WINDSCREEN_MIN_AMT" 
		id="pb-container-currency-FLEET_EXTENSIONS-WINDSCREEN_MIN_AMT">
		<asp:Label ID="lblFLEET_EXTENSIONS_WINDSCREEN_MIN_AMT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__WINDSCREEN_MIN_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="FLEET_EXTENSIONS__WINDSCREEN_MIN_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_WINDSCREEN_MIN_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.WINDSCREEN_MIN_AMT"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__WINDSCREEN_MIN_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label57">
		<span class="label" id="label57"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_IS_NASRIA" for="ctl00_cntMainBody_FLEET_EXTENSIONS__IS_NASRIA" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="IS_NASRIA" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-IS_NASRIA">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__IS_NASRIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_IS_NASRIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.IS_NASRIA"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__IS_NASRIA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label58">
		<span class="label" id="label58">NASRIA - Motor Fleet</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label59">
		<span class="label" id="label59"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label60">
		<span class="label" id="label60"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label61">
		<span class="label" id="label61"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label62">
		<span class="label" id="label62"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblFLEET_EXTENSIONS_ROAD_ASSIST" for="ctl00_cntMainBody_FLEET_EXTENSIONS__ROAD_ASSIST" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="ROAD_ASSIST" 
		id="pb-container-checkbox-FLEET_EXTENSIONS-ROAD_ASSIST">	
		
		<asp:TextBox ID="FLEET_EXTENSIONS__ROAD_ASSIST" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valFLEET_EXTENSIONS_ROAD_ASSIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FLEET_EXTENSIONS.ROAD_ASSIST"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__ROAD_ASSIST" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label63">
		<span class="label" id="label63">Roadside Assist</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label64">
		<span class="label" id="label64"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label65">
		<span class="label" id="label65"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label66">
		<span class="label" id="label66"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label67">
		<span class="label" id="label67"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="CAR_HIRE_DAYSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-FLEET_EXTENSIONS-CAR_HIRE_DAYSCode">

		
		
			
		
				<asp:HiddenField ID="FLEET_EXTENSIONS__CAR_HIRE_DAYSCode" runat="server" />

		

		
	
		
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
		if ($("#idad8d85b5b3434be0be28a21706c57174 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idad8d85b5b3434be0be28a21706c57174 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idad8d85b5b3434be0be28a21706c57174 div ul li").each(function(){		  
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
			$("#idad8d85b5b3434be0be28a21706c57174 div ul li").each(function(){		  
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
		styleString += "#idad8d85b5b3434be0be28a21706c57174 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idad8d85b5b3434be0be28a21706c57174 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idad8d85b5b3434be0be28a21706c57174 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idad8d85b5b3434be0be28a21706c57174 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idad8d85b5b3434be0be28a21706c57174 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idad8d85b5b3434be0be28a21706c57174 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idad8d85b5b3434be0be28a21706c57174 input{text-align:left;}"; break;
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
<div id="frmFleetNASRIA" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading30" runat="server" Text="NASRIA - Motor Fleet" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="NASRIA_LIMIT" 
		id="pb-container-integer-FLEET_EXTENSIONS-NASRIA_LIMIT">
		<asp:Label ID="lblFLEET_EXTENSIONS_NASRIA_LIMIT" runat="server" AssociatedControlID="FLEET_EXTENSIONS__NASRIA_LIMIT" 
			Text="Limit of Indemnity" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="FLEET_EXTENSIONS__NASRIA_LIMIT" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valFLEET_EXTENSIONS_NASRIA_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Limit of Indemnity"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__NASRIA_LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="NASRIA_CATEGORY" 
		id="pb-container-list-FLEET_EXTENSIONS-NASRIA_CATEGORY">
		<asp:Label ID="lblFLEET_EXTENSIONS_NASRIA_CATEGORY" runat="server" AssociatedControlID="FLEET_EXTENSIONS__NASRIA_CATEGORY" 
			Text="Vehicle Category" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="FLEET_EXTENSIONS__NASRIA_CATEGORY" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_MOT_NASRIA_CATEG" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_FLEET_EXTENSIONS__NASRIA_CATEGORY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valFLEET_EXTENSIONS_NASRIA_CATEGORY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Vehicle Category"
			ClientValidationFunction="onValidate_FLEET_EXTENSIONS__NASRIA_CATEGORY" 
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
		
		data-object-name="FLEET_EXTENSIONS" 
		data-property-name="NASRIA_CATEGORYCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-FLEET_EXTENSIONS-NASRIA_CATEGORYCode">

		
		
			
		
				<asp:HiddenField ID="FLEET_EXTENSIONS__NASRIA_CATEGORYCode" runat="server" />

		

		
	
		
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
		if ($("#frmFleetNASRIA div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmFleetNASRIA div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmFleetNASRIA div ul li").each(function(){		  
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
			$("#frmFleetNASRIA div ul li").each(function(){		  
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
		styleString += "#frmFleetNASRIA label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmFleetNASRIA label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFleetNASRIA label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFleetNASRIA label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmFleetNASRIA input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFleetNASRIA input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFleetNASRIA input{text-align:left;}"; break;
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