<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CWORKCLM_Contact_Works.aspx.vb" Inherits="Nexus.PB2_CWORKCLM_Contact_Works" %>

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
function onValidate_CWORKCLAIM__C_INSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "C_INSURED", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "C_INSURED");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CWORKCLAIM.C_INSURED");
        			window.setControlWidth(field, "0.8", "CWORKCLAIM", "C_INSURED");
        		})();
        	}
        })();
}
function onValidate_CWORKCLAIM__CONTALLRKS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "CONTALLRKS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "CONTALLRKS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__ERECALLRKS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "ERECALLRKS", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "ERECALLRKS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__CONPUBLIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "CONPUBLIA", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "CONPUBLIA");
        	field.setReadOnly(true);
        })();
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("CWORKCLAIM.CONPUBLIA");
        		var update = function(){
        			ToggleTabBasedOn("9", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_CWORKCLAIM__PATDEF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "PATDEF", "Integer");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "PATDEF");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CWORKCLAIM.PATDEF");
        			window.setControlWidth(field, "0.8", "CWORKCLAIM", "PATDEF");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('CWORKCLAIM', 'PATDEF');
        			
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
function onValidate_CWORKCLAIM__CON_DESCRIPTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "CON_DESCRIPTION", "Comment");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "CON_DESCRIPTION");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CWORKCLAIM.CON_DESCRIPTION");
        			window.setControlWidth(field, "0.8", "CWORKCLAIM", "CON_DESCRIPTION");
        		})();
        	}
        })();
}
function onValidate_CWORKCLAIM__BUILD_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "BUILD_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "BUILD_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__DAMS_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "DAMS_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "DAMS_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__FACT_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "FACT_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "FACT_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__MINING_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "MINING_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "MINING_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__PIPE_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "PIPE_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "PIPE_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__SHOP_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "SHOP_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "SHOP_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__CONCR_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "CONCR_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "CONCR_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__DOMEST_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "DOMEST_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "DOMEST_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__MASSH_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "MASSH_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "MASSH_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__OFFBLK_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "OFFBLK_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "OFFBLK_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__ROADS_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "ROADS_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "ROADS_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__STEEL_IND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "STEEL_IND", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CWORKCLAIM", "STEEL_IND");
        	field.setReadOnly(true);
        })();
}
function onValidate_CWORKCLAIM__CTESTCLM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CWORKCLAIM", "CTESTCLM", "ChildScreen");
        })();
        /** 
         * Note: This script removes the 'Delete' linkbutton in every row of the childscreen grid. It also renames 'Edit' to 'Select'
         * @param CWORKCLAIM The object name of the control to set.
         * @parma CPERIODCLM The property name of the control to set to the result of the calculated premium.
         */
        (function(){
        	if (isOnLoad) {
        		$('#<%=CWORKCLAIM__CPERIODCLM.ClientID %>').find('table').find('tr').each(function () {
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
    onValidate_CWORKCLAIM__C_INSURED(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__CONTALLRKS(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__ERECALLRKS(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__CONPUBLIA(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__PATDEF(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__CON_DESCRIPTION(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__BUILD_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__DAMS_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__FACT_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__MINING_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__PIPE_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__SHOP_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__CONCR_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__DOMEST_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__MASSH_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__OFFBLK_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__ROADS_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__STEEL_IND(null, null, null, isOnLoad);
    onValidate_CWORKCLAIM__CTESTCLM(null, null, null, isOnLoad);
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
<div id="idf738f965d5ce41e8ae2daa5a56f29540" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id951f6fba40094ae2a9fb9ea809fccc8c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading11" runat="server" Text="Insured Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CWORKCLAIM" 
		data-property-name="C_INSURED" 
		 
		
		 
		id="pb-container-text-CWORKCLAIM-C_INSURED">

		
		<asp:Label ID="lblCWORKCLAIM_C_INSURED" runat="server" AssociatedControlID="CWORKCLAIM__C_INSURED" 
			Text="Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="CWORKCLAIM__C_INSURED" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCWORKCLAIM_C_INSURED" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Insured"
					ClientValidationFunction="onValidate_CWORKCLAIM__C_INSURED"
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
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id951f6fba40094ae2a9fb9ea809fccc8c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id951f6fba40094ae2a9fb9ea809fccc8c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id951f6fba40094ae2a9fb9ea809fccc8c div ul li").each(function(){		  
			  liElementHeight = $(this).height();	  
			  if (liElementHeight > liMaxHeight)
			  {
				  liMaxHeight = liElementHeight;			  
			  }	

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liMaxHeight;		  
				  arrayCount++;
				  liMaxHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id951f6fba40094ae2a9fb9ea809fccc8c div ul li").each(function(){		  
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
		styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id951f6fba40094ae2a9fb9ea809fccc8c input{text-align:left;}"; break;
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
<div id="id0d6e823ef65845378f706d50bdd37659" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading12" runat="server" Text="Cover Selection" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblCWORKCLAIM_CONTALLRKS" for="ctl00_cntMainBody_CWORKCLAIM__CONTALLRKS" class="col-md-4 col-sm-3 control-label">
		Contract All Risks</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="CONTALLRKS" 
		id="pb-container-checkbox-CWORKCLAIM-CONTALLRKS">	
		
		<asp:TextBox ID="CWORKCLAIM__CONTALLRKS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_CONTALLRKS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Contract All Risks"
			ClientValidationFunction="onValidate_CWORKCLAIM__CONTALLRKS" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_ERECALLRKS" for="ctl00_cntMainBody_CWORKCLAIM__ERECALLRKS" class="col-md-4 col-sm-3 control-label">
		Erection All Risks</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="ERECALLRKS" 
		id="pb-container-checkbox-CWORKCLAIM-ERECALLRKS">	
		
		<asp:TextBox ID="CWORKCLAIM__ERECALLRKS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_ERECALLRKS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Erection All Risks"
			ClientValidationFunction="onValidate_CWORKCLAIM__ERECALLRKS" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_CONPUBLIA" for="ctl00_cntMainBody_CWORKCLAIM__CONPUBLIA" class="col-md-4 col-sm-3 control-label">
		Construction Public Liability</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="CONPUBLIA" 
		id="pb-container-checkbox-CWORKCLAIM-CONPUBLIA">	
		
		<asp:TextBox ID="CWORKCLAIM__CONPUBLIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_CONPUBLIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Construction Public Liability"
			ClientValidationFunction="onValidate_CWORKCLAIM__CONPUBLIA" 
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
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id0d6e823ef65845378f706d50bdd37659 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id0d6e823ef65845378f706d50bdd37659 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id0d6e823ef65845378f706d50bdd37659 div ul li").each(function(){		  
			  liElementHeight = $(this).height();	  
			  if (liElementHeight > liMaxHeight)
			  {
				  liMaxHeight = liElementHeight;			  
			  }	

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liMaxHeight;		  
				  arrayCount++;
				  liMaxHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id0d6e823ef65845378f706d50bdd37659 div ul li").each(function(){		  
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
		styleString += "#id0d6e823ef65845378f706d50bdd37659 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id0d6e823ef65845378f706d50bdd37659 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0d6e823ef65845378f706d50bdd37659 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0d6e823ef65845378f706d50bdd37659 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id0d6e823ef65845378f706d50bdd37659 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0d6e823ef65845378f706d50bdd37659 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0d6e823ef65845378f706d50bdd37659 input{text-align:left;}"; break;
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
<div id="id0ba12b22773a43d3978b52a304b509d5" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading13" runat="server" Text="Cover Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="CWORKCLAIM" 
		data-property-name="PATDEF" 
		id="pb-container-integer-CWORKCLAIM-PATDEF">
		<asp:Label ID="lblCWORKCLAIM_PATDEF" runat="server" AssociatedControlID="CWORKCLAIM__PATDEF" 
			Text="Patent Defect Limitation Period/Maintenance Period (Months)" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="CWORKCLAIM__PATDEF" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCWORKCLAIM_PATDEF" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Patent Defect Limitation Period/Maintenance Period (Months)"
			ClientValidationFunction="onValidate_CWORKCLAIM__PATDEF" 
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
		data-object-name="CWORKCLAIM" 
		data-property-name="CON_DESCRIPTION" 
		id="pb-container-comment-CWORKCLAIM-CON_DESCRIPTION">
		<asp:Label ID="lblCWORKCLAIM_CON_DESCRIPTION" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="CWORKCLAIM__CON_DESCRIPTION" 
			Text="Description of Contracts Insured"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="CWORKCLAIM__CON_DESCRIPTION" runat="server" />
		
		<asp:CustomValidator ID="valCWORKCLAIM_CON_DESCRIPTION" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Description of Contracts Insured"
			ClientValidationFunction="onValidate_CWORKCLAIM__CON_DESCRIPTION"
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
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id0ba12b22773a43d3978b52a304b509d5 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id0ba12b22773a43d3978b52a304b509d5 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id0ba12b22773a43d3978b52a304b509d5 div ul li").each(function(){		  
			  liElementHeight = $(this).height();	  
			  if (liElementHeight > liMaxHeight)
			  {
				  liMaxHeight = liElementHeight;			  
			  }	

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liMaxHeight;		  
				  arrayCount++;
				  liMaxHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id0ba12b22773a43d3978b52a304b509d5 div ul li").each(function(){		  
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
		styleString += "#id0ba12b22773a43d3978b52a304b509d5 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id0ba12b22773a43d3978b52a304b509d5 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0ba12b22773a43d3978b52a304b509d5 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0ba12b22773a43d3978b52a304b509d5 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id0ba12b22773a43d3978b52a304b509d5 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0ba12b22773a43d3978b52a304b509d5 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0ba12b22773a43d3978b52a304b509d5 input{text-align:left;}"; break;
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
<div id="idbfeb540a54fc452091763a76dcbeed5d" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading14" runat="server" Text="Main Business Classification" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblCWORKCLAIM_BUILD_IND" for="ctl00_cntMainBody_CWORKCLAIM__BUILD_IND" class="col-md-4 col-sm-3 control-label">
		Buildings</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="BUILD_IND" 
		id="pb-container-checkbox-CWORKCLAIM-BUILD_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__BUILD_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_BUILD_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Buildings"
			ClientValidationFunction="onValidate_CWORKCLAIM__BUILD_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_DAMS_IND" for="ctl00_cntMainBody_CWORKCLAIM__DAMS_IND" class="col-md-4 col-sm-3 control-label">
		Dams</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="DAMS_IND" 
		id="pb-container-checkbox-CWORKCLAIM-DAMS_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__DAMS_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_DAMS_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Dams"
			ClientValidationFunction="onValidate_CWORKCLAIM__DAMS_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_FACT_IND" for="ctl00_cntMainBody_CWORKCLAIM__FACT_IND" class="col-md-4 col-sm-3 control-label">
		Factories</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="FACT_IND" 
		id="pb-container-checkbox-CWORKCLAIM-FACT_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__FACT_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_FACT_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Factories"
			ClientValidationFunction="onValidate_CWORKCLAIM__FACT_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_MINING_IND" for="ctl00_cntMainBody_CWORKCLAIM__MINING_IND" class="col-md-4 col-sm-3 control-label">
		Mining</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="MINING_IND" 
		id="pb-container-checkbox-CWORKCLAIM-MINING_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__MINING_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_MINING_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Mining"
			ClientValidationFunction="onValidate_CWORKCLAIM__MINING_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_PIPE_IND" for="ctl00_cntMainBody_CWORKCLAIM__PIPE_IND" class="col-md-4 col-sm-3 control-label">
		Pipelines/ Infrastructure</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="PIPE_IND" 
		id="pb-container-checkbox-CWORKCLAIM-PIPE_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__PIPE_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_PIPE_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Pipelines/ Infrastructure"
			ClientValidationFunction="onValidate_CWORKCLAIM__PIPE_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_SHOP_IND" for="ctl00_cntMainBody_CWORKCLAIM__SHOP_IND" class="col-md-4 col-sm-3 control-label">
		Shopping Complexes</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="SHOP_IND" 
		id="pb-container-checkbox-CWORKCLAIM-SHOP_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__SHOP_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_SHOP_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Shopping Complexes"
			ClientValidationFunction="onValidate_CWORKCLAIM__SHOP_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_CONCR_IND" for="ctl00_cntMainBody_CWORKCLAIM__CONCR_IND" class="col-md-4 col-sm-3 control-label">
		Concrete Structures</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="CONCR_IND" 
		id="pb-container-checkbox-CWORKCLAIM-CONCR_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__CONCR_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_CONCR_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Concrete Structures"
			ClientValidationFunction="onValidate_CWORKCLAIM__CONCR_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_DOMEST_IND" for="ctl00_cntMainBody_CWORKCLAIM__DOMEST_IND" class="col-md-4 col-sm-3 control-label">
		Domestic</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="DOMEST_IND" 
		id="pb-container-checkbox-CWORKCLAIM-DOMEST_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__DOMEST_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_DOMEST_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Domestic"
			ClientValidationFunction="onValidate_CWORKCLAIM__DOMEST_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_MASSH_IND" for="ctl00_cntMainBody_CWORKCLAIM__MASSH_IND" class="col-md-4 col-sm-3 control-label">
		Mass Housing</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="MASSH_IND" 
		id="pb-container-checkbox-CWORKCLAIM-MASSH_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__MASSH_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_MASSH_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Mass Housing"
			ClientValidationFunction="onValidate_CWORKCLAIM__MASSH_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_OFFBLK_IND" for="ctl00_cntMainBody_CWORKCLAIM__OFFBLK_IND" class="col-md-4 col-sm-3 control-label">
		Office Blocks</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="OFFBLK_IND" 
		id="pb-container-checkbox-CWORKCLAIM-OFFBLK_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__OFFBLK_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_OFFBLK_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Office Blocks"
			ClientValidationFunction="onValidate_CWORKCLAIM__OFFBLK_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_ROADS_IND" for="ctl00_cntMainBody_CWORKCLAIM__ROADS_IND" class="col-md-4 col-sm-3 control-label">
		Roads</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="ROADS_IND" 
		id="pb-container-checkbox-CWORKCLAIM-ROADS_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__ROADS_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_ROADS_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Roads"
			ClientValidationFunction="onValidate_CWORKCLAIM__ROADS_IND" 
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
<label id="ctl00_cntMainBody_lblCWORKCLAIM_STEEL_IND" for="ctl00_cntMainBody_CWORKCLAIM__STEEL_IND" class="col-md-4 col-sm-3 control-label">
		Steel Structures</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CWORKCLAIM" 
		data-property-name="STEEL_IND" 
		id="pb-container-checkbox-CWORKCLAIM-STEEL_IND">	
		
		<asp:TextBox ID="CWORKCLAIM__STEEL_IND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCWORKCLAIM_STEEL_IND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Steel Structures"
			ClientValidationFunction="onValidate_CWORKCLAIM__STEEL_IND" 
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
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#idbfeb540a54fc452091763a76dcbeed5d div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idbfeb540a54fc452091763a76dcbeed5d div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idbfeb540a54fc452091763a76dcbeed5d div ul li").each(function(){		  
			  liElementHeight = $(this).height();	  
			  if (liElementHeight > liMaxHeight)
			  {
				  liMaxHeight = liElementHeight;			  
			  }	

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liMaxHeight;		  
				  arrayCount++;
				  liMaxHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#idbfeb540a54fc452091763a76dcbeed5d div ul li").each(function(){		  
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
		styleString += "#idbfeb540a54fc452091763a76dcbeed5d label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idbfeb540a54fc452091763a76dcbeed5d label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbfeb540a54fc452091763a76dcbeed5d label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbfeb540a54fc452091763a76dcbeed5d label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idbfeb540a54fc452091763a76dcbeed5d input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idbfeb540a54fc452091763a76dcbeed5d input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idbfeb540a54fc452091763a76dcbeed5d input{text-align:left;}"; break;
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
<div id="id8883670d026f4bf893f8405f0f0adee9" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading15" runat="server" Text="Contract Testing Periods" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_CWORKCLAIM__CTESTCLM"
		data-field-type="Child" 
		data-object-name="CWORKCLAIM" 
		data-property-name="CTESTCLM" 
		id="pb-container-childscreen-CWORKCLAIM-CTESTCLM">
		
		    <legend>Testing Period</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="CWORKCLAIM__CPERIODCLM" runat="server" ScreenCode="CTESTCLM" AutoGenerateColumns="false"
							GridLines="None" ChildPage="CTESTCLM/CTESTCLM_Testing_Period.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Description" DataField="DESCRIPTION" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Period (Days)" DataField="PERIOD" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Deductible %" DataField="DEDUCTIBLE" DataFormatString="{0:0.0000}"/>
<Nexus:RiskAttribute HeaderText="Minimum Amount" DataField="MIN_AMT" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Maximum Amount" DataField="MAX_AMT" DataFormatString="{0:N}"/>
<Nexus:GISLookupField HeaderText="Basis of Deductible" ListType="UserDefined" ListCode="BASISDED" DataField="BASIS_DED" DataItemValue="key" />

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
				
					<asp:CustomValidator ID="valCWORKCLAIM_CTESTCLM" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Testing Period"
						ClientValidationFunction="onValidate_CWORKCLAIM__CTESTCLM" 
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
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#id8883670d026f4bf893f8405f0f0adee9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id8883670d026f4bf893f8405f0f0adee9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id8883670d026f4bf893f8405f0f0adee9 div ul li").each(function(){		  
			  liElementHeight = $(this).height();	  
			  if (liElementHeight > liMaxHeight)
			  {
				  liMaxHeight = liElementHeight;			  
			  }	

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liMaxHeight;		  
				  arrayCount++;
				  liMaxHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#id8883670d026f4bf893f8405f0f0adee9 div ul li").each(function(){		  
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
		styleString += "#id8883670d026f4bf893f8405f0f0adee9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id8883670d026f4bf893f8405f0f0adee9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8883670d026f4bf893f8405f0f0adee9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8883670d026f4bf893f8405f0f0adee9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id8883670d026f4bf893f8405f0f0adee9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id8883670d026f4bf893f8405f0f0adee9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id8883670d026f4bf893f8405f0f0adee9 input{text-align:left;}"; break;
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