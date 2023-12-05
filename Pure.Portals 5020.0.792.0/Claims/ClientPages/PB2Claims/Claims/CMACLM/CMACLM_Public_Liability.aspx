<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CMACLM_Public_Liability.aspx.vb" Inherits="Nexus.PB2_CMACLM_Public_Liability" %>

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
function onValidate_PUBCLM__ATTACHMENTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "ATTACHMENTDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "ATTACHMENTDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_ATTACHMENTDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__ATTACHMENTDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__ATTACHMENTDATE_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.ATTACHMENTDATE");
        			window.setControlWidth(field, "0.8", "PUBCLM", "ATTACHMENTDATE");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__EFFECTIVEDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "EFFECTIVEDATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "EFFECTIVEDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_EFFECTIVEDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__EFFECTIVEDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__EFFECTIVEDATE_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.EFFECTIVEDATE");
        			window.setControlWidth(field, "0.8", "PUBCLM", "EFFECTIVEDATE");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__IS_GENERAL_TENANTS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "IS_GENERAL_TENANTS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "IS_GENERAL_TENANTS");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__IS_DEF_WORKMAN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "IS_DEF_WORKMAN", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "IS_DEF_WORKMAN");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__IS_PRODUCT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "IS_PRODUCT", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "IS_PRODUCT");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__BASIS_COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "BASIS_COVER", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "BASIS_COVER");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_BASIS_COVER");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__BASIS_COVER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__BASIS_COVER_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.BASIS_COVER");
        			window.setControlWidth(field, "0.8", "PUBCLM", "BASIS_COVER");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__RETRO_DATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "RETRO_DATE", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "RETRO_DATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_RETRO_DATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__RETRO_DATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__RETRO_DATE_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.RETRO_DATE");
        			window.setControlWidth(field, "0.8", "PUBCLM", "RETRO_DATE");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__MULTI_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "MULTI_PREM", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "MULTI_PREM");
        	field.setReadOnly(true);
        })();
        /** 
         * ToggleContainer
         * @param frmMultiple The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("PUBCLM","MULTI_PREM");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmMultiple', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmMultiple', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("PUBCLM", "MULTI_PREM"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_PUBCLM__PREMISES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PREMISES", "ChildScreen");
        })();
}
function onValidate_PUBCLM__LIMIT_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "LIMIT_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "LIMIT_INDEMNITY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'LIMIT_INDEMNITY');
        			
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
function onValidate_PUBCLM__RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "RATE");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__FPAPERCENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "FPAPERCENT", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "FPAPERCENT");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__MINAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "MINAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "MINAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'MINAMOUNT');
        			
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
function onValidate_PUBCLM__MAXAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "MAXAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "MAXAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'MAXAMOUNT');
        			
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
function onValidate_PUBCLM__PBCNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PBCNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "PBCNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'PBCNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__PBCNOTES table td a");
        				
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
function onValidate_PUBCLM__PBCSNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PBCSNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "PBCSNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'PBCSNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__PBCSNOTES table td a");
        				
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
function onValidate_PUBCLM__BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "BASIS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "BASIS");
        	field.setReadOnly(true);
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PUBCLM", "BASIS");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_BASIS");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__BASIS');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__BASIS_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.BASIS");
        			window.setControlWidth(field, "0.4", "PUBCLM", "BASIS");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__DW_WAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_WAGE", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_WAGE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'DW_WAGE');
        			
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
function onValidate_PUBCLM__DW_LIMIT_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_LIMIT_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_LIMIT_INDEMNITY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'DW_LIMIT_INDEMNITY');
        			
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
function onValidate_PUBCLM__DW_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_RATE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'DW_RATE');
        			
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
function onValidate_PUBCLM__DW_FPAPERCENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_FPAPERCENT", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_FPAPERCENT");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__DW_MINAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_MINAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_MINAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'DW_MINAMOUNT');
        			
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
function onValidate_PUBCLM__DW_MAXAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DW_MAXAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "DW_MAXAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'DW_MAXAMOUNT');
        			
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
function onValidate_PUBCLM__QUE_RECIEVED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "QUE_RECIEVED", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "QUE_RECIEVED");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__DEFNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DEFNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "DEFNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'DEFNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__DEFNOTES table td a");
        				
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
function onValidate_PUBCLM__DEFSNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "DEFSNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "DEFSNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'DEFSNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__DEFSNOTES table td a");
        				
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
function onValidate_PUBCLM__PD_BASIS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_BASIS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_BASIS");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblPUBCLM_PD_BASIS");
        			    var ele = document.getElementById('ctl00_cntMainBody_PUBCLM__PD_BASIS');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PUBCLM__PD_BASIS_lblFindParty");
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
              var field = Field.getInstance("PUBCLM.PD_BASIS");
        			window.setControlWidth(field, "0.4", "PUBCLM", "PD_BASIS");
        		})();
        	}
        })();
}
function onValidate_PUBCLM__PD_WAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_WAGE", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_WAGE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'PD_WAGE');
        			
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
function onValidate_PUBCLM__PD_LIMIT_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_LIMIT_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_LIMIT_INDEMNITY");
        	field.setReadOnly(true);
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PUBCLM", "PD_LIMIT_INDEMNITY");
        		
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
        
        			var field = Field.getInstance('PUBCLM', 'PD_LIMIT_INDEMNITY');
        			
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
function onValidate_PUBCLM__PD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_RATE");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__PD_FPAPERCENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_FPAPERCENT", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_FPAPERCENT");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__PD_MINAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_MINAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_MINAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'PD_MINAMOUNT');
        			
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
function onValidate_PUBCLM__PD_MAXAMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_MAXAMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_MAXAMOUNT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM', 'PD_MAXAMOUNT');
        			
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
function onValidate_PUBCLM__PD_QUE_RECIEVED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PD_QUE_RECIEVED", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM", "PD_QUE_RECIEVED");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM__PRDNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PRDNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "PRDNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'PRDNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__PRDNOTES table td a");
        				
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
function onValidate_PUBCLM__PRDSNOTES(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM", "PRDSNOTES", "ChildScreen");
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
        		
        		var whenCondition = Expression.isValidParameter("Delete") ? (new Expression("Delete")) : null;
        		var validLinkCaptions = "{1}";
        		// Trim
        		if (Expression.isValidParameter(validLinkCaptions)){
        			validLinkCaptions = validLinkCaptions.replace(/^\s+|\s+$/g, '');
        			if (validLinkCaptions.slice(0,1) != "[") validLinkCaptions = "[" + validLinkCaptions;
        			if (validLinkCaptions.slice(validLinkCaptions.length - 1) != "]") validLinkCaptions = validLinkCaptions + "]";
        			var validLinkCaptions = (new Expression(validLinkCaptions)).valueOf();
        		} else {
        			validLinkCaptions = null;
        		}
        		var field = Field.getInstance("PUBCLM", "PRDSNOTES");
        		/*if (field.getType() != "child_screen"){
        			var error = new Error("HideTableLinks rule used on field which is not a child screen. Offending field has the object 'PUBCLM' and property 'PRDSNOTES'.");
        			error.display();
        			// Don't throw the error as we will let everything else carry on loading.
        			return;
        		}*/
        		
        		
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_PUBCLM__PRDSNOTES table td a");
        				
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
function onValidate_PUBCLM_EXT__ADDITIONAL_CLAIMS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "ADDITIONAL_CLAIMS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "ADDITIONAL_CLAIMS");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__ADD_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "ADD_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "ADD_INDEMNITY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM_EXT', 'ADD_INDEMNITY');
        			
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
function onValidate_PUBCLM_EXT__ADD_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "ADD_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "ADD_RATE");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__LEGAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "LEGAL", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "LEGAL");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__LEGAL_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "LEGAL_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "LEGAL_INDEMNITY");
        	field.setReadOnly(true);
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PUBCLM_EXT", "LEGAL_INDEMNITY");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PUBCLM_EXT&propertyName=LEGAL_INDEMNITY&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.LEGAL = 0")) ? new Expression("PUBLIAB_EXT.LEGAL = 0") : null, 
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
        
        			var field = Field.getInstance('PUBCLM_EXT', 'LEGAL_INDEMNITY');
        			
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
function onValidate_PUBCLM_EXT__LEGAL_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "LEGAL_EVENT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "LEGAL_EVENT");
        	field.setReadOnly(true);
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PUBCLM_EXT", "LEGAL_EVENT");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null;
        		var elseColour = (Expression.isValidParameter("{2}")) ? "{2}" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Cannot be greater than Per annum limit")) ? "Cannot be greater than Per annum limit" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PUBCLM_EXT".toUpperCase() + "__" + "LEGAL_EVENT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PUBCLM_EXT".toUpperCase() + "_" + "LEGAL_EVENT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PUBLIAB_EXT.LEGAL_EVENT > PUBLIAB_EXT.LEGAL_INDEMNITY");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PUBCLM_EXT&propertyName=LEGAL_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.LEGAL = 0")) ? new Expression("PUBLIAB_EXT.LEGAL = 0") : null, 
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
        
        			var field = Field.getInstance('PUBCLM_EXT', 'LEGAL_EVENT');
        			
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
function onValidate_PUBCLM_EXT__LEGAL_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "LEGAL_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "LEGAL_RATE");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * InvalidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Legal Defence Costs rate cannot be more than 100")) ? "Legal Defence Costs rate cannot be more than 100" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PUBCLM_EXT".toUpperCase() + "__" + "LEGAL_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PUBCLM_EXT".toUpperCase() + "_" + "LEGAL_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("PUBLIAB_EXT.LEGAL_RATE >100");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=PUBCLM_EXT&propertyName=LEGAL_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.LEGAL = 0")) ? new Expression("PUBLIAB_EXT.LEGAL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PUBCLM_EXT__WRONGFUL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "WRONGFUL", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "WRONGFUL");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__WRONG_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "WRONG_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "WRONG_INDEMNITY");
        	field.setReadOnly(true);
        })();
        
        /**
         * Set the background colour
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("PUBCLM_EXT", "WRONG_INDEMNITY");
        		
        		var colour = "#FFFFD9";
        		var condition = (Expression.isValidParameter("PUBLIAB_EXT.WRONGFUL == true")) ? new Expression("PUBLIAB_EXT.WRONGFUL == true") : null;
        		var elseColour = (Expression.isValidParameter(" #00000000")) ? " #00000000" : null;
        		
        		Colours.SetBackgroundColour(field, colour, condition, elseColour);
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PUBCLM_EXT&propertyName=WRONG_INDEMNITY&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.WRONGFUL = 0")) ? new Expression("PUBLIAB_EXT.WRONGFUL = 0") : null, 
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
        
        			var field = Field.getInstance('PUBCLM_EXT', 'WRONG_INDEMNITY');
        			
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
function onValidate_PUBCLM_EXT__WRONG_EVENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "WRONG_EVENT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "WRONG_EVENT");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=PUBCLM_EXT&propertyName=WRONG_EVENT&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.WRONGFUL = 0")) ? new Expression("PUBLIAB_EXT.WRONGFUL = 0") : null, 
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
        
        			var field = Field.getInstance('PUBCLM_EXT', 'WRONG_EVENT');
        			
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
function onValidate_PUBCLM_EXT__WRONG_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "WRONG_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "WRONG_RATE");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=PUBCLM_EXT&propertyName=WRONG_RATE&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("PUBLIAB_EXT.WRONGFUL = 0")) ? new Expression("PUBLIAB_EXT.WRONGFUL = 0") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_PUBCLM_EXT__SPECIAL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "SPECIAL", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "SPECIAL");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__SP_INDEMNITY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "SP_INDEMNITY", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "SP_INDEMNITY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('PUBCLM_EXT', 'SP_INDEMNITY');
        			
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
function onValidate_PUBCLM_EXT__SP_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "SP_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "SP_RATE");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__SP_FAP_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "SP_FAP_RATE", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "SP_FAP_RATE");
        	field.setReadOnly(true);
        })();
}
function onValidate_PUBCLM_EXT__SP_MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PUBCLM_EXT", "SP_MIN_AMNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("PUBCLM_EXT", "SP_MIN_AMNT");
        	field.setReadOnly(true);
        })();
}
function DoLogic(isOnLoad) {
    onValidate_PUBCLM__ATTACHMENTDATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__EFFECTIVEDATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__IS_GENERAL_TENANTS(null, null, null, isOnLoad);
    onValidate_PUBCLM__IS_DEF_WORKMAN(null, null, null, isOnLoad);
    onValidate_PUBCLM__IS_PRODUCT(null, null, null, isOnLoad);
    onValidate_PUBCLM__BASIS_COVER(null, null, null, isOnLoad);
    onValidate_PUBCLM__RETRO_DATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__MULTI_PREM(null, null, null, isOnLoad);
    onValidate_PUBCLM__PREMISES(null, null, null, isOnLoad);
    onValidate_PUBCLM__LIMIT_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM__RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__FPAPERCENT(null, null, null, isOnLoad);
    onValidate_PUBCLM__MINAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__MAXAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__PBCNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM__PBCSNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM__BASIS(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_WAGE(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_LIMIT_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_FPAPERCENT(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_MINAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__DW_MAXAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__QUE_RECIEVED(null, null, null, isOnLoad);
    onValidate_PUBCLM__DEFNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM__DEFSNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_BASIS(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_WAGE(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_LIMIT_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_FPAPERCENT(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_MINAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_MAXAMOUNT(null, null, null, isOnLoad);
    onValidate_PUBCLM__PD_QUE_RECIEVED(null, null, null, isOnLoad);
    onValidate_PUBCLM__PRDNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM__PRDSNOTES(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__ADDITIONAL_CLAIMS(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__ADD_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__ADD_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__LEGAL(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__LEGAL_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__LEGAL_EVENT(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__LEGAL_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__WRONGFUL(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__WRONG_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__WRONG_EVENT(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__WRONG_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__SPECIAL(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__SP_INDEMNITY(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__SP_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__SP_FAP_RATE(null, null, null, isOnLoad);
    onValidate_PUBCLM_EXT__SP_MIN_AMNT(null, null, null, isOnLoad);
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
<div id="id45cdf20f96cc4fbea3a0409a407b7cac" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id13629dc391e1449a81b2cbc20ddff1fe" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading86" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="PUBCLM" 
		data-property-name="ATTACHMENTDATE" 
		id="pb-container-datejquerycompatible-PUBCLM-ATTACHMENTDATE">
		<asp:Label ID="lblPUBCLM_ATTACHMENTDATE" runat="server" AssociatedControlID="PUBCLM__ATTACHMENTDATE" 
			Text="Attachment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="PUBCLM__ATTACHMENTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calPUBCLM__ATTACHMENTDATE" runat="server" LinkedControl="PUBCLM__ATTACHMENTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valPUBCLM_ATTACHMENTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Attachment Date"
			ClientValidationFunction="onValidate_PUBCLM__ATTACHMENTDATE" 
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
		data-object-name="PUBCLM" 
		data-property-name="EFFECTIVEDATE" 
		id="pb-container-datejquerycompatible-PUBCLM-EFFECTIVEDATE">
		<asp:Label ID="lblPUBCLM_EFFECTIVEDATE" runat="server" AssociatedControlID="PUBCLM__EFFECTIVEDATE" 
			Text="Effective Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="PUBCLM__EFFECTIVEDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calPUBCLM__EFFECTIVEDATE" runat="server" LinkedControl="PUBCLM__EFFECTIVEDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valPUBCLM_EFFECTIVEDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Effective Date"
			ClientValidationFunction="onValidate_PUBCLM__EFFECTIVEDATE" 
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
		if ($("#id13629dc391e1449a81b2cbc20ddff1fe div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id13629dc391e1449a81b2cbc20ddff1fe div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id13629dc391e1449a81b2cbc20ddff1fe div ul li").each(function(){		  
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
			$("#id13629dc391e1449a81b2cbc20ddff1fe div ul li").each(function(){		  
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
		styleString += "#id13629dc391e1449a81b2cbc20ddff1fe label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id13629dc391e1449a81b2cbc20ddff1fe label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id13629dc391e1449a81b2cbc20ddff1fe label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id13629dc391e1449a81b2cbc20ddff1fe label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id13629dc391e1449a81b2cbc20ddff1fe input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id13629dc391e1449a81b2cbc20ddff1fe input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id13629dc391e1449a81b2cbc20ddff1fe input{text-align:left;}"; break;
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
<div id="id9f6c53163e2b44a6871f2506655812e6" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading87" runat="server" Text="Cover Type" /></legend>
				
				
				<div data-column-count="3" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_IS_GENERAL_TENANTS" for="ctl00_cntMainBody_PUBCLM__IS_GENERAL_TENANTS" class="col-md-4 col-sm-3 control-label">
		General & Tenants</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="IS_GENERAL_TENANTS" 
		id="pb-container-checkbox-PUBCLM-IS_GENERAL_TENANTS">	
		
		<asp:TextBox ID="PUBCLM__IS_GENERAL_TENANTS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_IS_GENERAL_TENANTS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for General & Tenants"
			ClientValidationFunction="onValidate_PUBCLM__IS_GENERAL_TENANTS" 
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
<label id="ctl00_cntMainBody_lblPUBCLM_IS_DEF_WORKMAN" for="ctl00_cntMainBody_PUBCLM__IS_DEF_WORKMAN" class="col-md-4 col-sm-3 control-label">
		Defective Workmanship</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="IS_DEF_WORKMAN" 
		id="pb-container-checkbox-PUBCLM-IS_DEF_WORKMAN">	
		
		<asp:TextBox ID="PUBCLM__IS_DEF_WORKMAN" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_IS_DEF_WORKMAN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Defective Workmanship"
			ClientValidationFunction="onValidate_PUBCLM__IS_DEF_WORKMAN" 
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
<label id="ctl00_cntMainBody_lblPUBCLM_IS_PRODUCT" for="ctl00_cntMainBody_PUBCLM__IS_PRODUCT" class="col-md-4 col-sm-3 control-label">
		Products Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="IS_PRODUCT" 
		id="pb-container-checkbox-PUBCLM-IS_PRODUCT">	
		
		<asp:TextBox ID="PUBCLM__IS_PRODUCT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_IS_PRODUCT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Products Liability"
			ClientValidationFunction="onValidate_PUBCLM__IS_PRODUCT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PUBCLM" 
		data-property-name="BASIS_COVER" 
		 
		
		 
		id="pb-container-text-PUBCLM-BASIS_COVER">

		
		<asp:Label ID="lblPUBCLM_BASIS_COVER" runat="server" AssociatedControlID="PUBCLM__BASIS_COVER" 
			Text="Basis of Cover" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PUBCLM__BASIS_COVER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPUBCLM_BASIS_COVER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Basis of Cover"
					ClientValidationFunction="onValidate_PUBCLM__BASIS_COVER"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="PUBCLM" 
		data-property-name="RETRO_DATE" 
		id="pb-container-datejquerycompatible-PUBCLM-RETRO_DATE">
		<asp:Label ID="lblPUBCLM_RETRO_DATE" runat="server" AssociatedControlID="PUBCLM__RETRO_DATE" 
			Text="Retro Active Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="PUBCLM__RETRO_DATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calPUBCLM__RETRO_DATE" runat="server" LinkedControl="PUBCLM__RETRO_DATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valPUBCLM_RETRO_DATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Retro Active Date"
			ClientValidationFunction="onValidate_PUBCLM__RETRO_DATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:33%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_MULTI_PREM" for="ctl00_cntMainBody_PUBCLM__MULTI_PREM" class="col-md-4 col-sm-3 control-label">
		Multiple Premises</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="MULTI_PREM" 
		id="pb-container-checkbox-PUBCLM-MULTI_PREM">	
		
		<asp:TextBox ID="PUBCLM__MULTI_PREM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_MULTI_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Multiple Premises"
			ClientValidationFunction="onValidate_PUBCLM__MULTI_PREM" 
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
		if ($("#id9f6c53163e2b44a6871f2506655812e6 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id9f6c53163e2b44a6871f2506655812e6 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id9f6c53163e2b44a6871f2506655812e6 div ul li").each(function(){		  
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
			$("#id9f6c53163e2b44a6871f2506655812e6 div ul li").each(function(){		  
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
		styleString += "#id9f6c53163e2b44a6871f2506655812e6 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id9f6c53163e2b44a6871f2506655812e6 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9f6c53163e2b44a6871f2506655812e6 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9f6c53163e2b44a6871f2506655812e6 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id9f6c53163e2b44a6871f2506655812e6 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9f6c53163e2b44a6871f2506655812e6 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9f6c53163e2b44a6871f2506655812e6 input{text-align:left;}"; break;
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
<div id="frmMultiple" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading88" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__PREMISES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="PREMISES" 
		id="pb-container-childscreen-PUBCLM-PREMISES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__PREMISES_DETAILS" runat="server" ScreenCode="PREMISES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PREMISES/PREMISES_Multiple_Premises_Details.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="No. & Street name" DataField="LINE1" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Suburb" DataField="SUBURB" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Town" DataField="TOWN" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valPUBCLM_PREMISES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.PREMISES"
						ClientValidationFunction="onValidate_PUBCLM__PREMISES" 
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
		if ($("#frmMultiple div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmMultiple div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmMultiple div ul li").each(function(){		  
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
			$("#frmMultiple div ul li").each(function(){		  
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
		styleString += "#frmMultiple label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmMultiple label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMultiple label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMultiple label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmMultiple input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmMultiple input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmMultiple input{text-align:left;}"; break;
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
<div id="gt" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading89" runat="server" Text="General & Tenants" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label94">
		<span class="label" id="label94">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label95">
		<span class="label" id="label95">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label96">
		<span class="label" id="label96">FAP%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label97">
		<span class="label" id="label97">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label98">
		<span class="label" id="label98">Max Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="LIMIT_INDEMNITY" 
		id="pb-container-currency-PUBCLM-LIMIT_INDEMNITY">
		<asp:Label ID="lblPUBCLM_LIMIT_INDEMNITY" runat="server" AssociatedControlID="PUBCLM__LIMIT_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__LIMIT_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_LIMIT_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.LIMIT_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM__LIMIT_INDEMNITY" 
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
		data-object-name="PUBCLM" 
		data-property-name="RATE" 
		id="pb-container-percentage-PUBCLM-RATE">
		<asp:Label ID="lblPUBCLM_RATE" runat="server" AssociatedControlID="PUBCLM__RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.RATE"
			ClientValidationFunction="onValidate_PUBCLM__RATE" 
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
		data-object-name="PUBCLM" 
		data-property-name="FPAPERCENT" 
		id="pb-container-percentage-PUBCLM-FPAPERCENT">
		<asp:Label ID="lblPUBCLM_FPAPERCENT" runat="server" AssociatedControlID="PUBCLM__FPAPERCENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__FPAPERCENT" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_FPAPERCENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.FPAPERCENT"
			ClientValidationFunction="onValidate_PUBCLM__FPAPERCENT" 
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
		data-object-name="PUBCLM" 
		data-property-name="MINAMOUNT" 
		id="pb-container-currency-PUBCLM-MINAMOUNT">
		<asp:Label ID="lblPUBCLM_MINAMOUNT" runat="server" AssociatedControlID="PUBCLM__MINAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__MINAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_MINAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.MINAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__MINAMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="MAXAMOUNT" 
		id="pb-container-currency-PUBCLM-MAXAMOUNT">
		<asp:Label ID="lblPUBCLM_MAXAMOUNT" runat="server" AssociatedControlID="PUBCLM__MAXAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__MAXAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_MAXAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.MAXAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__MAXAMOUNT" 
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
		if ($("#gt div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#gt div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#gt div ul li").each(function(){		  
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
			$("#gt div ul li").each(function(){		  
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
		styleString += "#gt label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#gt label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#gt label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#gt label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#gt input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#gt input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#gt input{text-align:left;}"; break;
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
<div id="id5c79c703b0bc42009a4b1db503a19c8d" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading90" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__PBCNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="PBCNOTES" 
		id="pb-container-childscreen-PUBCLM-PBCNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__PUB_CNOTE_DETAILS" runat="server" ScreenCode="PBCNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PBCNOTES/PBCNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_PBCNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.PBCNOTES"
						ClientValidationFunction="onValidate_PUBCLM__PBCNOTES" 
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
		if ($("#id5c79c703b0bc42009a4b1db503a19c8d div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id5c79c703b0bc42009a4b1db503a19c8d div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id5c79c703b0bc42009a4b1db503a19c8d div ul li").each(function(){		  
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
			$("#id5c79c703b0bc42009a4b1db503a19c8d div ul li").each(function(){		  
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
		styleString += "#id5c79c703b0bc42009a4b1db503a19c8d label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id5c79c703b0bc42009a4b1db503a19c8d label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id5c79c703b0bc42009a4b1db503a19c8d label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id5c79c703b0bc42009a4b1db503a19c8d label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id5c79c703b0bc42009a4b1db503a19c8d input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id5c79c703b0bc42009a4b1db503a19c8d input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id5c79c703b0bc42009a4b1db503a19c8d input{text-align:left;}"; break;
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
<div id="idd5351fcc8aa24a93bd64fdf8d720f4be" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading91" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__PBCSNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="PBCSNOTES" 
		id="pb-container-childscreen-PUBCLM-PBCSNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__PUB_SNOTE_DETAILS" runat="server" ScreenCode="PBCSNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PBCSNOTES/PBCSNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_PBCSNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.PBCSNOTES"
						ClientValidationFunction="onValidate_PUBCLM__PBCSNOTES" 
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
		if ($("#idd5351fcc8aa24a93bd64fdf8d720f4be div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idd5351fcc8aa24a93bd64fdf8d720f4be div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idd5351fcc8aa24a93bd64fdf8d720f4be div ul li").each(function(){		  
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
			$("#idd5351fcc8aa24a93bd64fdf8d720f4be div ul li").each(function(){		  
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
		styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idd5351fcc8aa24a93bd64fdf8d720f4be input{text-align:left;}"; break;
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
<div id="idc32a573dcc5f47f0a80664da392fa5f5" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading92" runat="server" Text="Defective/Product Workmanship" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PUBCLM" 
		data-property-name="BASIS" 
		id="pb-container-list-PUBCLM-BASIS">
		<asp:Label ID="lblPUBCLM_BASIS" runat="server" AssociatedControlID="PUBCLM__BASIS" 
			Text="Basis of Cover" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PUBCLM__BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_PL_BASIS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PUBCLM__BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPUBCLM_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Basis of Cover"
			ClientValidationFunction="onValidate_PUBCLM__BASIS" 
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
		
		data-object-name="PUBCLM" 
		data-property-name="BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-PUBCLM-BASISCode">

		
		
			
		
				<asp:HiddenField ID="PUBCLM__BASISCode" runat="server" />

		

		
	
		
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
		if ($("#idc32a573dcc5f47f0a80664da392fa5f5 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idc32a573dcc5f47f0a80664da392fa5f5 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idc32a573dcc5f47f0a80664da392fa5f5 div ul li").each(function(){		  
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
			$("#idc32a573dcc5f47f0a80664da392fa5f5 div ul li").each(function(){		  
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
		styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc32a573dcc5f47f0a80664da392fa5f5 input{text-align:left;}"; break;
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
<div id="Defective Workmanship" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading93" runat="server" Text="" /></legend>
				
				
				<div data-column-count="6" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label99">
		<span class="label" id="label99">Turnover/Wages</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label100">
		<span class="label" id="label100">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label101">
		<span class="label" id="label101">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label102">
		<span class="label" id="label102">FAP%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label103">
		<span class="label" id="label103">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label104">
		<span class="label" id="label104">Max Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="DW_WAGE" 
		id="pb-container-currency-PUBCLM-DW_WAGE">
		<asp:Label ID="lblPUBCLM_DW_WAGE" runat="server" AssociatedControlID="PUBCLM__DW_WAGE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__DW_WAGE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_DW_WAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_WAGE"
			ClientValidationFunction="onValidate_PUBCLM__DW_WAGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="DW_LIMIT_INDEMNITY" 
		id="pb-container-currency-PUBCLM-DW_LIMIT_INDEMNITY">
		<asp:Label ID="lblPUBCLM_DW_LIMIT_INDEMNITY" runat="server" AssociatedControlID="PUBCLM__DW_LIMIT_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__DW_LIMIT_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_DW_LIMIT_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_LIMIT_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM__DW_LIMIT_INDEMNITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM" 
		data-property-name="DW_RATE" 
		id="pb-container-percentage-PUBCLM-DW_RATE">
		<asp:Label ID="lblPUBCLM_DW_RATE" runat="server" AssociatedControlID="PUBCLM__DW_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__DW_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_DW_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_RATE"
			ClientValidationFunction="onValidate_PUBCLM__DW_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM" 
		data-property-name="DW_FPAPERCENT" 
		id="pb-container-percentage-PUBCLM-DW_FPAPERCENT">
		<asp:Label ID="lblPUBCLM_DW_FPAPERCENT" runat="server" AssociatedControlID="PUBCLM__DW_FPAPERCENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__DW_FPAPERCENT" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_DW_FPAPERCENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_FPAPERCENT"
			ClientValidationFunction="onValidate_PUBCLM__DW_FPAPERCENT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="DW_MINAMOUNT" 
		id="pb-container-currency-PUBCLM-DW_MINAMOUNT">
		<asp:Label ID="lblPUBCLM_DW_MINAMOUNT" runat="server" AssociatedControlID="PUBCLM__DW_MINAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__DW_MINAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_DW_MINAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_MINAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__DW_MINAMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="DW_MAXAMOUNT" 
		id="pb-container-currency-PUBCLM-DW_MAXAMOUNT">
		<asp:Label ID="lblPUBCLM_DW_MAXAMOUNT" runat="server" AssociatedControlID="PUBCLM__DW_MAXAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__DW_MAXAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_DW_MAXAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.DW_MAXAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__DW_MAXAMOUNT" 
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
		if ($("#Defective Workmanship div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Defective Workmanship div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Defective Workmanship div ul li").each(function(){		  
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
			$("#Defective Workmanship div ul li").each(function(){		  
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
		styleString += "#Defective Workmanship label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Defective Workmanship label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Defective Workmanship label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Defective Workmanship label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Defective Workmanship input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Defective Workmanship input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Defective Workmanship input{text-align:left;}"; break;
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
<div id="Options" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading94" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_QUE_RECIEVED" for="ctl00_cntMainBody_PUBCLM__QUE_RECIEVED" class="col-md-4 col-sm-3 control-label">
		Questionnaire Received</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="QUE_RECIEVED" 
		id="pb-container-checkbox-PUBCLM-QUE_RECIEVED">	
		
		<asp:TextBox ID="PUBCLM__QUE_RECIEVED" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_QUE_RECIEVED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Questionnaire Received"
			ClientValidationFunction="onValidate_PUBCLM__QUE_RECIEVED" 
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
		if ($("#Options div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#Options div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#Options div ul li").each(function(){		  
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
			$("#Options div ul li").each(function(){		  
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
		styleString += "#Options label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#Options label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Options label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Options label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#Options input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#Options input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#Options input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading95" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
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
<div id="id4621ff16566e45fc8ae8560455b1a7e9" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading96" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__DEFNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="DEFNOTES" 
		id="pb-container-childscreen-PUBCLM-DEFNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__DEF_CNOTE_DETAILS" runat="server" ScreenCode="DEFNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="DEFNOTES/DEFNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_DEFNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.DEFNOTES"
						ClientValidationFunction="onValidate_PUBCLM__DEFNOTES" 
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
		if ($("#id4621ff16566e45fc8ae8560455b1a7e9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4621ff16566e45fc8ae8560455b1a7e9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4621ff16566e45fc8ae8560455b1a7e9 div ul li").each(function(){		  
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
			$("#id4621ff16566e45fc8ae8560455b1a7e9 div ul li").each(function(){		  
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
		styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4621ff16566e45fc8ae8560455b1a7e9 input{text-align:left;}"; break;
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
<div id="id20333dc0aa264716a4a6aeca0f4a25de" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading97" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__DEFSNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="DEFSNOTES" 
		id="pb-container-childscreen-PUBCLM-DEFSNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__DEF_SNOTE_DETAILS" runat="server" ScreenCode="DEFSNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="DEFSNOTES/DEFSNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_DEFSNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.DEFSNOTES"
						ClientValidationFunction="onValidate_PUBCLM__DEFSNOTES" 
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
		if ($("#id20333dc0aa264716a4a6aeca0f4a25de div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id20333dc0aa264716a4a6aeca0f4a25de div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id20333dc0aa264716a4a6aeca0f4a25de div ul li").each(function(){		  
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
			$("#id20333dc0aa264716a4a6aeca0f4a25de div ul li").each(function(){		  
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
		styleString += "#id20333dc0aa264716a4a6aeca0f4a25de label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id20333dc0aa264716a4a6aeca0f4a25de label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id20333dc0aa264716a4a6aeca0f4a25de label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id20333dc0aa264716a4a6aeca0f4a25de label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id20333dc0aa264716a4a6aeca0f4a25de input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id20333dc0aa264716a4a6aeca0f4a25de input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id20333dc0aa264716a4a6aeca0f4a25de input{text-align:left;}"; break;
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
<div id="idbadb9f4992db42db86f50252caaa3008" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading98" runat="server" Text="Products Liability" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PUBCLM" 
		data-property-name="PD_BASIS" 
		id="pb-container-list-PUBCLM-PD_BASIS">
		<asp:Label ID="lblPUBCLM_PD_BASIS" runat="server" AssociatedControlID="PUBCLM__PD_BASIS" 
			Text="Basis of Cover" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PUBCLM__PD_BASIS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CMA_PL_BASIS" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PUBCLM__PD_BASIS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPUBCLM_PD_BASIS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Basis of Cover"
			ClientValidationFunction="onValidate_PUBCLM__PD_BASIS" 
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
		
		data-object-name="PUBCLM" 
		data-property-name="PD_BASISCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-PUBCLM-PD_BASISCode">

		
		
			
		
				<asp:HiddenField ID="PUBCLM__PD_BASISCode" runat="server" />

		

		
	
		
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
		if ($("#idbadb9f4992db42db86f50252caaa3008 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idbadb9f4992db42db86f50252caaa3008 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idbadb9f4992db42db86f50252caaa3008 div ul li").each(function(){		  
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
			$("#idbadb9f4992db42db86f50252caaa3008 div ul li").each(function(){		  
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
		styleString += "#idbadb9f4992db42db86f50252caaa3008 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idbadb9f4992db42db86f50252caaa3008 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbadb9f4992db42db86f50252caaa3008 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbadb9f4992db42db86f50252caaa3008 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idbadb9f4992db42db86f50252caaa3008 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbadb9f4992db42db86f50252caaa3008 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbadb9f4992db42db86f50252caaa3008 input{text-align:left;}"; break;
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
<div id="ida4cfd77749b544fe963f4ad3dbeb01c0" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading99" runat="server" Text="" /></legend>
				
				
				<div data-column-count="6" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label105">
		<span class="label" id="label105">Turnover/Wages</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label106">
		<span class="label" id="label106">Limit Of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label107">
		<span class="label" id="label107">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label108">
		<span class="label" id="label108">FAP%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label109">
		<span class="label" id="label109">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label110">
		<span class="label" id="label110">Max Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="PD_WAGE" 
		id="pb-container-currency-PUBCLM-PD_WAGE">
		<asp:Label ID="lblPUBCLM_PD_WAGE" runat="server" AssociatedControlID="PUBCLM__PD_WAGE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__PD_WAGE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_PD_WAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_WAGE"
			ClientValidationFunction="onValidate_PUBCLM__PD_WAGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="PD_LIMIT_INDEMNITY" 
		id="pb-container-currency-PUBCLM-PD_LIMIT_INDEMNITY">
		<asp:Label ID="lblPUBCLM_PD_LIMIT_INDEMNITY" runat="server" AssociatedControlID="PUBCLM__PD_LIMIT_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__PD_LIMIT_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_PD_LIMIT_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_LIMIT_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM__PD_LIMIT_INDEMNITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM" 
		data-property-name="PD_RATE" 
		id="pb-container-percentage-PUBCLM-PD_RATE">
		<asp:Label ID="lblPUBCLM_PD_RATE" runat="server" AssociatedControlID="PUBCLM__PD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__PD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_PD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_RATE"
			ClientValidationFunction="onValidate_PUBCLM__PD_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM" 
		data-property-name="PD_FPAPERCENT" 
		id="pb-container-percentage-PUBCLM-PD_FPAPERCENT">
		<asp:Label ID="lblPUBCLM_PD_FPAPERCENT" runat="server" AssociatedControlID="PUBCLM__PD_FPAPERCENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM__PD_FPAPERCENT" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_PD_FPAPERCENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_FPAPERCENT"
			ClientValidationFunction="onValidate_PUBCLM__PD_FPAPERCENT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="PD_MINAMOUNT" 
		id="pb-container-currency-PUBCLM-PD_MINAMOUNT">
		<asp:Label ID="lblPUBCLM_PD_MINAMOUNT" runat="server" AssociatedControlID="PUBCLM__PD_MINAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__PD_MINAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_PD_MINAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_MINAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__PD_MINAMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM" 
		data-property-name="PD_MAXAMOUNT" 
		id="pb-container-currency-PUBCLM-PD_MAXAMOUNT">
		<asp:Label ID="lblPUBCLM_PD_MAXAMOUNT" runat="server" AssociatedControlID="PUBCLM__PD_MAXAMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM__PD_MAXAMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_PD_MAXAMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM.PD_MAXAMOUNT"
			ClientValidationFunction="onValidate_PUBCLM__PD_MAXAMOUNT" 
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
		if ($("#ida4cfd77749b544fe963f4ad3dbeb01c0 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ida4cfd77749b544fe963f4ad3dbeb01c0 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ida4cfd77749b544fe963f4ad3dbeb01c0 div ul li").each(function(){		  
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
			$("#ida4cfd77749b544fe963f4ad3dbeb01c0 div ul li").each(function(){		  
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
		styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida4cfd77749b544fe963f4ad3dbeb01c0 input{text-align:left;}"; break;
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
<div id="id06e8e5cf07804ba787a5daef60d2eb30" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading100" runat="server" Text="" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_PD_QUE_RECIEVED" for="ctl00_cntMainBody_PUBCLM__PD_QUE_RECIEVED" class="col-md-4 col-sm-3 control-label">
		Questionnaire Received</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM" 
		data-property-name="PD_QUE_RECIEVED" 
		id="pb-container-checkbox-PUBCLM-PD_QUE_RECIEVED">	
		
		<asp:TextBox ID="PUBCLM__PD_QUE_RECIEVED" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_PD_QUE_RECIEVED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Questionnaire Received"
			ClientValidationFunction="onValidate_PUBCLM__PD_QUE_RECIEVED" 
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
		if ($("#id06e8e5cf07804ba787a5daef60d2eb30 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id06e8e5cf07804ba787a5daef60d2eb30 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id06e8e5cf07804ba787a5daef60d2eb30 div ul li").each(function(){		  
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
			$("#id06e8e5cf07804ba787a5daef60d2eb30 div ul li").each(function(){		  
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
		styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id06e8e5cf07804ba787a5daef60d2eb30 input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading101" runat="server" Text="Endorsements" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
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
<div id="id974fd67b255e4a09b8dbe473624d40fc" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading102" runat="server" Text="Notes (Not Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__PRDNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="PRDNOTES" 
		id="pb-container-childscreen-PUBCLM-PRDNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__PRD_CNOTE_DETAILS" runat="server" ScreenCode="PRDNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PRDNOTES/PRDNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_PRDNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.PRDNOTES"
						ClientValidationFunction="onValidate_PUBCLM__PRDNOTES" 
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
		if ($("#id974fd67b255e4a09b8dbe473624d40fc div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id974fd67b255e4a09b8dbe473624d40fc div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id974fd67b255e4a09b8dbe473624d40fc div ul li").each(function(){		  
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
			$("#id974fd67b255e4a09b8dbe473624d40fc div ul li").each(function(){		  
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
		styleString += "#id974fd67b255e4a09b8dbe473624d40fc label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id974fd67b255e4a09b8dbe473624d40fc label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id974fd67b255e4a09b8dbe473624d40fc label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id974fd67b255e4a09b8dbe473624d40fc label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id974fd67b255e4a09b8dbe473624d40fc input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id974fd67b255e4a09b8dbe473624d40fc input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id974fd67b255e4a09b8dbe473624d40fc input{text-align:left;}"; break;
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
<div id="ida3131405f371455493b8cb6685b2818c" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading103" runat="server" Text="Notes (Printed on Schedule)" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_PUBCLM__PRDSNOTES"
		data-field-type="Child" 
		data-object-name="PUBCLM" 
		data-property-name="PRDSNOTES" 
		id="pb-container-childscreen-PUBCLM-PRDSNOTES">
		
		    <legend></legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="PUBCLM__PRD_SNOTE_DETAILS" runat="server" ScreenCode="PRDSNOTES" AutoGenerateColumns="false"
							GridLines="None" ChildPage="PRDSNOTES/PRDSNOTES_Note_Details.aspx" emptydatatext="sac">
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
				
					<asp:CustomValidator ID="valPUBCLM_PRDSNOTES" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for PUBCLM.PRDSNOTES"
						ClientValidationFunction="onValidate_PUBCLM__PRDSNOTES" 
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
		if ($("#ida3131405f371455493b8cb6685b2818c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ida3131405f371455493b8cb6685b2818c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ida3131405f371455493b8cb6685b2818c div ul li").each(function(){		  
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
			$("#ida3131405f371455493b8cb6685b2818c div ul li").each(function(){		  
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
		styleString += "#ida3131405f371455493b8cb6685b2818c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ida3131405f371455493b8cb6685b2818c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida3131405f371455493b8cb6685b2818c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida3131405f371455493b8cb6685b2818c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ida3131405f371455493b8cb6685b2818c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida3131405f371455493b8cb6685b2818c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida3131405f371455493b8cb6685b2818c input{text-align:left;}"; break;
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
<div id="id6ed43f5d560f4307aa9ecd6a85c6c276" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading104" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label111">
		<span class="label" id="label111"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label112">
		<span class="label" id="label112"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label113">
		<span class="label" id="label113">Limit Of Indemnity/Per Annum</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label114">
		<span class="label" id="label114">Limit Per Event</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label115">
		<span class="label" id="label115">Rate</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label116">
		<span class="label" id="label116">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label117">
		<span class="label" id="label117">Min Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_EXT_ADDITIONAL_CLAIMS" for="ctl00_cntMainBody_PUBCLM_EXT__ADDITIONAL_CLAIMS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="ADDITIONAL_CLAIMS" 
		id="pb-container-checkbox-PUBCLM_EXT-ADDITIONAL_CLAIMS">	
		
		<asp:TextBox ID="PUBCLM_EXT__ADDITIONAL_CLAIMS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_EXT_ADDITIONAL_CLAIMS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.ADDITIONAL_CLAIMS"
			ClientValidationFunction="onValidate_PUBCLM_EXT__ADDITIONAL_CLAIMS" 
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
	<span id="pb-container-label-label118">
		<span class="label" id="label118">Additional Claims Preparation Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="ADD_INDEMNITY" 
		id="pb-container-currency-PUBCLM_EXT-ADD_INDEMNITY">
		<asp:Label ID="lblPUBCLM_EXT_ADD_INDEMNITY" runat="server" AssociatedControlID="PUBCLM_EXT__ADD_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__ADD_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_ADD_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.ADD_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM_EXT__ADD_INDEMNITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label119">
		<span class="label" id="label119"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="ADD_RATE" 
		id="pb-container-percentage-PUBCLM_EXT-ADD_RATE">
		<asp:Label ID="lblPUBCLM_EXT_ADD_RATE" runat="server" AssociatedControlID="PUBCLM_EXT__ADD_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM_EXT__ADD_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_ADD_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.ADD_RATE"
			ClientValidationFunction="onValidate_PUBCLM_EXT__ADD_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label120">
		<span class="label" id="label120"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label121">
		<span class="label" id="label121"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_EXT_LEGAL" for="ctl00_cntMainBody_PUBCLM_EXT__LEGAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="LEGAL" 
		id="pb-container-checkbox-PUBCLM_EXT-LEGAL">	
		
		<asp:TextBox ID="PUBCLM_EXT__LEGAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_EXT_LEGAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.LEGAL"
			ClientValidationFunction="onValidate_PUBCLM_EXT__LEGAL" 
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
	<span id="pb-container-label-label122">
		<span class="label" id="label122">Legal Defence Costs</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="LEGAL_INDEMNITY" 
		id="pb-container-currency-PUBCLM_EXT-LEGAL_INDEMNITY">
		<asp:Label ID="lblPUBCLM_EXT_LEGAL_INDEMNITY" runat="server" AssociatedControlID="PUBCLM_EXT__LEGAL_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__LEGAL_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_LEGAL_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.LEGAL_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM_EXT__LEGAL_INDEMNITY" 
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
		data-object-name="PUBCLM_EXT" 
		data-property-name="LEGAL_EVENT" 
		id="pb-container-currency-PUBCLM_EXT-LEGAL_EVENT">
		<asp:Label ID="lblPUBCLM_EXT_LEGAL_EVENT" runat="server" AssociatedControlID="PUBCLM_EXT__LEGAL_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__LEGAL_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_LEGAL_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.LEGAL_EVENT"
			ClientValidationFunction="onValidate_PUBCLM_EXT__LEGAL_EVENT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="LEGAL_RATE" 
		id="pb-container-percentage-PUBCLM_EXT-LEGAL_RATE">
		<asp:Label ID="lblPUBCLM_EXT_LEGAL_RATE" runat="server" AssociatedControlID="PUBCLM_EXT__LEGAL_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM_EXT__LEGAL_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_LEGAL_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.LEGAL_RATE"
			ClientValidationFunction="onValidate_PUBCLM_EXT__LEGAL_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label123">
		<span class="label" id="label123"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label124">
		<span class="label" id="label124"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_EXT_WRONGFUL" for="ctl00_cntMainBody_PUBCLM_EXT__WRONGFUL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="WRONGFUL" 
		id="pb-container-checkbox-PUBCLM_EXT-WRONGFUL">	
		
		<asp:TextBox ID="PUBCLM_EXT__WRONGFUL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_EXT_WRONGFUL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.WRONGFUL"
			ClientValidationFunction="onValidate_PUBCLM_EXT__WRONGFUL" 
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
	<span id="pb-container-label-label125">
		<span class="label" id="label125">Wrongful Arrest</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="WRONG_INDEMNITY" 
		id="pb-container-currency-PUBCLM_EXT-WRONG_INDEMNITY">
		<asp:Label ID="lblPUBCLM_EXT_WRONG_INDEMNITY" runat="server" AssociatedControlID="PUBCLM_EXT__WRONG_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__WRONG_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_WRONG_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.WRONG_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM_EXT__WRONG_INDEMNITY" 
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
		data-object-name="PUBCLM_EXT" 
		data-property-name="WRONG_EVENT" 
		id="pb-container-currency-PUBCLM_EXT-WRONG_EVENT">
		<asp:Label ID="lblPUBCLM_EXT_WRONG_EVENT" runat="server" AssociatedControlID="PUBCLM_EXT__WRONG_EVENT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__WRONG_EVENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_WRONG_EVENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.WRONG_EVENT"
			ClientValidationFunction="onValidate_PUBCLM_EXT__WRONG_EVENT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="WRONG_RATE" 
		id="pb-container-percentage-PUBCLM_EXT-WRONG_RATE">
		<asp:Label ID="lblPUBCLM_EXT_WRONG_RATE" runat="server" AssociatedControlID="PUBCLM_EXT__WRONG_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM_EXT__WRONG_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_WRONG_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.WRONG_RATE"
			ClientValidationFunction="onValidate_PUBCLM_EXT__WRONG_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label126">
		<span class="label" id="label126"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label127">
		<span class="label" id="label127"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPUBCLM_EXT_SPECIAL" for="ctl00_cntMainBody_PUBCLM_EXT__SPECIAL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="SPECIAL" 
		id="pb-container-checkbox-PUBCLM_EXT-SPECIAL">	
		
		<asp:TextBox ID="PUBCLM_EXT__SPECIAL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPUBCLM_EXT_SPECIAL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.SPECIAL"
			ClientValidationFunction="onValidate_PUBCLM_EXT__SPECIAL" 
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
	<span id="pb-container-label-label128">
		<span class="label" id="label128">Spread of Fire</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="SP_INDEMNITY" 
		id="pb-container-currency-PUBCLM_EXT-SP_INDEMNITY">
		<asp:Label ID="lblPUBCLM_EXT_SP_INDEMNITY" runat="server" AssociatedControlID="PUBCLM_EXT__SP_INDEMNITY" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__SP_INDEMNITY" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_SP_INDEMNITY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.SP_INDEMNITY"
			ClientValidationFunction="onValidate_PUBCLM_EXT__SP_INDEMNITY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label129">
		<span class="label" id="label129"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="SP_RATE" 
		id="pb-container-percentage-PUBCLM_EXT-SP_RATE">
		<asp:Label ID="lblPUBCLM_EXT_SP_RATE" runat="server" AssociatedControlID="PUBCLM_EXT__SP_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM_EXT__SP_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_SP_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.SP_RATE"
			ClientValidationFunction="onValidate_PUBCLM_EXT__SP_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:14%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="PUBCLM_EXT" 
		data-property-name="SP_FAP_RATE" 
		id="pb-container-percentage-PUBCLM_EXT-SP_FAP_RATE">
		<asp:Label ID="lblPUBCLM_EXT_SP_FAP_RATE" runat="server" AssociatedControlID="PUBCLM_EXT__SP_FAP_RATE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PUBCLM_EXT__SP_FAP_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_SP_FAP_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.SP_FAP_RATE"
			ClientValidationFunction="onValidate_PUBCLM_EXT__SP_FAP_RATE" 
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
		data-object-name="PUBCLM_EXT" 
		data-property-name="SP_MIN_AMNT" 
		id="pb-container-currency-PUBCLM_EXT-SP_MIN_AMNT">
		<asp:Label ID="lblPUBCLM_EXT_SP_MIN_AMNT" runat="server" AssociatedControlID="PUBCLM_EXT__SP_MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PUBCLM_EXT__SP_MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPUBCLM_EXT_SP_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PUBCLM_EXT.SP_MIN_AMNT"
			ClientValidationFunction="onValidate_PUBCLM_EXT__SP_MIN_AMNT" 
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
		if ($("#id6ed43f5d560f4307aa9ecd6a85c6c276 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id6ed43f5d560f4307aa9ecd6a85c6c276 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id6ed43f5d560f4307aa9ecd6a85c6c276 div ul li").each(function(){		  
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
			$("#id6ed43f5d560f4307aa9ecd6a85c6c276 div ul li").each(function(){		  
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
		styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6ed43f5d560f4307aa9ecd6a85c6c276 input{text-align:left;}"; break;
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