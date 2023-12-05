<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="CCAMBCLCLM_Overview.aspx.vb" Inherits="Nexus.PB2_CCAMBCLCLM_Overview" %>

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
function onValidate_label28(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label28" != "{na" + "me}"){
        			instance = Field.getLabel("label28");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label29(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label29" != "{na" + "me}"){
        			instance = Field.getLabel("label29");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label30(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label30" != "{na" + "me}"){
        			instance = Field.getLabel("label30");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label31(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label31" != "{na" + "me}"){
        			instance = Field.getLabel("label31");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_label32(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label32" != "{na" + "me}"){
        			instance = Field.getLabel("label32");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__MB_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_EML", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_EML");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_EML');
        			
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
function onValidate_EXPOSURE_SUMMARY__MB_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MB_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MB_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MB_RI_EXPVAT');
        			
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
function onValidate_label33(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label33" != "{na" + "me}"){
        			instance = Field.getLabel("label33");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBACPC_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_EML", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_EML");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_EML');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBACPC_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBACPC_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBACPC_RI_EXPVAT');
        			
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
function onValidate_label34(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label34" != "{na" + "me}"){
        			instance = Field.getLabel("label34");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_EML", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_EML");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_EML');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLGPR_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLGPR_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLGPR_RI_EXPVAT');
        			
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
function onValidate_label35(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label35" != "{na" + "me}"){
        			instance = Field.getLabel("label35");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_EML", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_EML");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_EML');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "CONSLACPC_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "CONSLACPC_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'CONSLACPC_RI_EXPVAT');
        			
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
function onValidate_label36(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label36" != "{na" + "me}"){
        			instance = Field.getLabel("label36");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBDETOST_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_EML", "Percentage");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_EML");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_EML');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "MBDETOST_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "MBDETOST_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'MBDETOST_RI_EXPVAT');
        			
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
function onValidate_label37(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("label37" != "{na" + "me}"){
        			instance = Field.getLabel("label37");
        		} else { 
        			instance = Field.getInstance("", "");
        		}
        		
        		// If instance implements setBold, then do it.
        		if (instance.setBold) {instance.setBold(true);
        		    if (instance.input_ != undefined)
        		    {   
        		        if($("#" + instance.input_.id).parent().prev("label")!= undefined)
        		            $("#" + instance.input_.id).parent().prev("label").css("font-weight", "bold");
        			
        		        if($("#" + instance.input_.id).prev("label")!= undefined)
        		            $("#" + instance.input_.id).prev("label").css("font-weight", "bold");
        		    }	
            
        		
        		}
        	}
        })();
}
function onValidate_EXPOSURE_SUMMARY__TOTAL_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_SI", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_SI");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_SI');
        			
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
function onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_RI_EXP", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXP");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_RI_EXP');
        			
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
function onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "EXPOSURE_SUMMARY", "TOTAL_RI_EXPVAT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("EXPOSURE_SUMMARY", "TOTAL_RI_EXPVAT");
        	field.setReadOnly(true);
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('EXPOSURE_SUMMARY', 'TOTAL_RI_EXPVAT');
        			
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
function DoLogic(isOnLoad) {
    onValidate_label28(null, null, null, isOnLoad);
    onValidate_label29(null, null, null, isOnLoad);
    onValidate_label30(null, null, null, isOnLoad);
    onValidate_label31(null, null, null, isOnLoad);
    onValidate_label32(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label33(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label34(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label35(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label36(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_EML(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT(null, null, null, isOnLoad);
    onValidate_label37(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_SI(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP(null, null, null, isOnLoad);
    onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT(null, null, null, isOnLoad);
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
<div id="id10d4d29aa13841cd9aebeca62bf6b257" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id9fccabe170cb4cb9bfe965403cb006b1" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading69" runat="server" Text="Combined Reinsurance Exposure" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="28:18:18:18:18" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label27">
		<span class="label" id="label27"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label28">
		<span class="label" id="label28">Total Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label29">
		<span class="label" id="label29">EML%</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label30">
		<span class="label" id="label30">RI Exposure (VAT Incl.)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label31">
		<span class="label" id="label31">RI Exposure (VAT Excl.)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label32">
		<span class="label" id="label32">Machinery Breakdown</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_TOTAL_SI" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MB_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MB_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_EML" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MB_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MB_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MB_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MB_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MB_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MB_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MB_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MB_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label33">
		<span class="label" id="label33">Machinery Breakdown Additional Claims Preparation Cost</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_TOTAL_SI" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MBACPC_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_EML" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBACPC_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBACPC_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBACPC_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBACPC_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBACPC_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBACPC_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label34">
		<span class="label" id="label34">Consequential Loss Gross Profit/Revenue</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_TOTAL_SI" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-CONSLGPR_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_EML" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLGPR_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLGPR_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLGPR_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLGPR_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLGPR_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLGPR_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label35">
		<span class="label" id="label35">Consequential Loss Additional Claims Preparation Cost</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_TOTAL_SI" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-CONSLACPC_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_EML" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="CONSLACPC_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-CONSLACPC_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_CONSLACPC_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_CONSLACPC_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.CONSLACPC_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__CONSLACPC_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label36">
		<span class="label" id="label36">Deterioration of Stock</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_TOTAL_SI" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_EML" 
		id="pb-container-percentage-EXPOSURE_SUMMARY-MBDETOST_EML">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_EML" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_EML"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_EML" 
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
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="MBDETOST_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-MBDETOST_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_MBDETOST_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_MBDETOST_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.MBDETOST_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__MBDETOST_RI_EXPVAT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:28%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label37">
		<span class="label" id="label37">Totals</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_SI" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_SI">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_SI" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_SI"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_SI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label38">
		<span class="label" id="label38"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_RI_EXP" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_RI_EXP">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_RI_EXP" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_RI_EXP" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_RI_EXP" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_RI_EXP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_RI_EXP"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:18%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="EXPOSURE_SUMMARY" 
		data-property-name="TOTAL_RI_EXPVAT" 
		id="pb-container-currency-EXPOSURE_SUMMARY-TOTAL_RI_EXPVAT">
		<asp:Label ID="lblEXPOSURE_SUMMARY_TOTAL_RI_EXPVAT" runat="server" AssociatedControlID="EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valEXPOSURE_SUMMARY_TOTAL_RI_EXPVAT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for EXPOSURE_SUMMARY.TOTAL_RI_EXPVAT"
			ClientValidationFunction="onValidate_EXPOSURE_SUMMARY__TOTAL_RI_EXPVAT" 
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
		if ($("#id9fccabe170cb4cb9bfe965403cb006b1 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id9fccabe170cb4cb9bfe965403cb006b1 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id9fccabe170cb4cb9bfe965403cb006b1 div ul li").each(function(){		  
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
			$("#id9fccabe170cb4cb9bfe965403cb006b1 div ul li").each(function(){		  
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
		styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id9fccabe170cb4cb9bfe965403cb006b1 input{text-align:left;}"; break;
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