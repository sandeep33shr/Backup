<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CBLCKSCRN_Blocked_Risks.aspx.vb" Inherits="Nexus.PB2_CBLCKSCRN_Blocked_Risks" %>

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
function onValidate_BLCKR_ITEM__POLICY_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "POLICY_NUMBER", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "POLICY_NUMBER");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("BLCKR_ITEM.POLICY_NUMBER");
        			window.setControlWidth(field, "0.7", "BLCKR_ITEM", "POLICY_NUMBER");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblBLCKR_ITEM_POLICY_NUMBER");
        			    var ele = document.getElementById('ctl00_cntMainBody_BLCKR_ITEM__POLICY_NUMBER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_BLCKR_ITEM__POLICY_NUMBER_lblFindParty");
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
function onValidate_BLCKR_ITEM__CLIENT_NAME(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "CLIENT_NAME", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "CLIENT_NAME");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("BLCKR_ITEM.CLIENT_NAME");
        			window.setControlWidth(field, "0.7", "BLCKR_ITEM", "CLIENT_NAME");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("0.8");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblBLCKR_ITEM_CLIENT_NAME");
        			    var ele = document.getElementById('ctl00_cntMainBody_BLCKR_ITEM__CLIENT_NAME');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_BLCKR_ITEM__CLIENT_NAME_lblFindParty");
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
function onValidate_BLCKR_ITEM__IS_MPL_FIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_FIRE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_FIRE");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_FIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_FIRE", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_FIRE");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__IS_MPL_BC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_BC", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_BC");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_BC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_BC", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_BC");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__IS_MPL_OC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_OC", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_OC");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_OC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_OC", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_OC");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__IS_MPL_BI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_BI", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_BI");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_BI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_BI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_BI");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__IS_MPL_AR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_AR", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_AR");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_AR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_AR", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_AR");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__IS_MPL_AD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "IS_MPL_AD", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "IS_MPL_AD");
        	field.setReadOnly(true);
        })();
}
function onValidate_BLCKR_ITEM__MPL_AD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "BLCKR_ITEM", "MPL_AD", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("BLCKR_ITEM", "MPL_AD");
        	field.setReadOnly(true);
        })();
}
function DoLogic(isOnLoad) {
    onValidate_BLCKR_ITEM__POLICY_NUMBER(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__CLIENT_NAME(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_FIRE(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_FIRE(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_BC(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_BC(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_OC(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_OC(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_BI(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_BI(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_AR(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_AR(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__IS_MPL_AD(null, null, null, isOnLoad);
    onValidate_BLCKR_ITEM__MPL_AD(null, null, null, isOnLoad);
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
<div id="id4ada24db49764eae860d8e7f12be4de8" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id455904c8c9ce47a895d34452e317d344" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading8" runat="server" Text="" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- ColumnLayoutContainer -->
<div id="ida79bb7f6963e497bb6f707ba3608ea48" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading9" runat="server" Text="Information Detail" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="BLCKR_ITEM" 
		data-property-name="POLICY_NUMBER" 
		 
		
		 
		id="pb-container-text-BLCKR_ITEM-POLICY_NUMBER">

		
		<asp:Label ID="lblBLCKR_ITEM_POLICY_NUMBER" runat="server" AssociatedControlID="BLCKR_ITEM__POLICY_NUMBER" 
			Text="Policy Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="BLCKR_ITEM__POLICY_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valBLCKR_ITEM_POLICY_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Policy Number"
					ClientValidationFunction="onValidate_BLCKR_ITEM__POLICY_NUMBER"
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
	<span id="pb-container-label-label16">
		<span class="label" id="label16"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="BLCKR_ITEM" 
		data-property-name="CLIENT_NAME" 
		 
		
		 
		id="pb-container-text-BLCKR_ITEM-CLIENT_NAME">

		
		<asp:Label ID="lblBLCKR_ITEM_CLIENT_NAME" runat="server" AssociatedControlID="BLCKR_ITEM__CLIENT_NAME" 
			Text="Client Name" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="BLCKR_ITEM__CLIENT_NAME" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valBLCKR_ITEM_CLIENT_NAME" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Client Name"
					ClientValidationFunction="onValidate_BLCKR_ITEM__CLIENT_NAME"
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
		if ($("#ida79bb7f6963e497bb6f707ba3608ea48 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#ida79bb7f6963e497bb6f707ba3608ea48 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#ida79bb7f6963e497bb6f707ba3608ea48 div ul li").each(function(){		  
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
			$("#ida79bb7f6963e497bb6f707ba3608ea48 div ul li").each(function(){		  
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
		styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#ida79bb7f6963e497bb6f707ba3608ea48 input{text-align:left;}"; break;
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
<div id="id3d248904c53f485db5fe64339dc119ae" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading10" runat="server" Text="MPL" /></legend>
				
				
				<div data-column-count="3" data-column-ratio="5:25:70" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label17">
		<span class="label" id="label17"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label18">
		<span class="label" id="label18"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label19">
		<span class="label" id="label19">MPL Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:5%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_FIRE" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_FIRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_FIRE" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_FIRE">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_FIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_FIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_FIRE"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_FIRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label20">
		<span class="label" id="label20">Fire</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_FIRE" 
		id="pb-container-currency-BLCKR_ITEM-MPL_FIRE">
		<asp:Label ID="lblBLCKR_ITEM_MPL_FIRE" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_FIRE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_FIRE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_FIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_FIRE"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_FIRE" 
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
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_BC" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_BC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_BC" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_BC">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_BC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_BC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_BC"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_BC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label21">
		<span class="label" id="label21">Building Combined</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_BC" 
		id="pb-container-currency-BLCKR_ITEM-MPL_BC">
		<asp:Label ID="lblBLCKR_ITEM_MPL_BC" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_BC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_BC" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_BC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_BC"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_BC" 
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
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_OC" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_OC" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_OC" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_OC">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_OC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_OC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_OC"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_OC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label22">
		<span class="label" id="label22">Office Contents</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_OC" 
		id="pb-container-currency-BLCKR_ITEM-MPL_OC">
		<asp:Label ID="lblBLCKR_ITEM_MPL_OC" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_OC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_OC" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_OC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_OC"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_OC" 
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
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_BI" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_BI" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_BI" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_BI">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_BI" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_BI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_BI"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_BI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label23">
		<span class="label" id="label23">Business Interruption</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_BI" 
		id="pb-container-currency-BLCKR_ITEM-MPL_BI">
		<asp:Label ID="lblBLCKR_ITEM_MPL_BI" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_BI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_BI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_BI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_BI"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_BI" 
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
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_AR" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_AR" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_AR" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_AR">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_AR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_AR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_AR"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_AR" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label24">
		<span class="label" id="label24">Accounts Receivable</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_AR" 
		id="pb-container-currency-BLCKR_ITEM-MPL_AR">
		<asp:Label ID="lblBLCKR_ITEM_MPL_AR" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_AR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_AR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_AR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_AR"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_AR" 
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
<label id="ctl00_cntMainBody_lblBLCKR_ITEM_IS_MPL_AD" for="ctl00_cntMainBody_BLCKR_ITEM__IS_MPL_AD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="IS_MPL_AD" 
		id="pb-container-checkbox-BLCKR_ITEM-IS_MPL_AD">	
		
		<asp:TextBox ID="BLCKR_ITEM__IS_MPL_AD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valBLCKR_ITEM_IS_MPL_AD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.IS_MPL_AD"
			ClientValidationFunction="onValidate_BLCKR_ITEM__IS_MPL_AD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:25%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label25">
		<span class="label" id="label25">Accidental Damage</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:70%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="BLCKR_ITEM" 
		data-property-name="MPL_AD" 
		id="pb-container-currency-BLCKR_ITEM-MPL_AD">
		<asp:Label ID="lblBLCKR_ITEM_MPL_AD" runat="server" AssociatedControlID="BLCKR_ITEM__MPL_AD" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="BLCKR_ITEM__MPL_AD" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valBLCKR_ITEM_MPL_AD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for BLCKR_ITEM.MPL_AD"
			ClientValidationFunction="onValidate_BLCKR_ITEM__MPL_AD" 
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
		if ($("#id3d248904c53f485db5fe64339dc119ae div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id3d248904c53f485db5fe64339dc119ae div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id3d248904c53f485db5fe64339dc119ae div ul li").each(function(){		  
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
			$("#id3d248904c53f485db5fe64339dc119ae div ul li").each(function(){		  
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
		styleString += "#id3d248904c53f485db5fe64339dc119ae label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id3d248904c53f485db5fe64339dc119ae label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3d248904c53f485db5fe64339dc119ae label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3d248904c53f485db5fe64339dc119ae label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id3d248904c53f485db5fe64339dc119ae input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id3d248904c53f485db5fe64339dc119ae input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id3d248904c53f485db5fe64339dc119ae input{text-align:left;}"; break;
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
		if ($("#id455904c8c9ce47a895d34452e317d344 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id455904c8c9ce47a895d34452e317d344 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id455904c8c9ce47a895d34452e317d344 div ul li").each(function(){		  
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
			$("#id455904c8c9ce47a895d34452e317d344 div ul li").each(function(){		  
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
		styleString += "#id455904c8c9ce47a895d34452e317d344 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id455904c8c9ce47a895d34452e317d344 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id455904c8c9ce47a895d34452e317d344 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id455904c8c9ce47a895d34452e317d344 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id455904c8c9ce47a895d34452e317d344 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id455904c8c9ce47a895d34452e317d344 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id455904c8c9ce47a895d34452e317d344 input{text-align:left;}"; break;
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