<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="GFIRECLM_Risk_Selection.aspx.vb" Inherits="Nexus.PB2_GFIRECLM_Risk_Selection" %>

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
         * @fileoverview Toggle Tab Based on the value of a checkbox control.
         * @param {boolean} value
         */
        function ToggleTabBasedOnClaim(tabId, value) {
        
        	if (value)
        	{
        		HideTab(tabId);
        		ShowTab(tabId);
        	}
        	else
        		HideTab(tabId);
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
function onValidate_RISK_SELECTION__FIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "FIRE", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "FIRE");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_fire == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_fire == true",
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
              var field = Field.getInstance("RISK_SELECTION.FIRE");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "FIRE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_FIRE");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__FIRE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__FIRE_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.FIRE");
        		var update = function(){
        			ToggleTabBasedOnClaim("4", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_fire(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_fire", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_fire");
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
function onValidate_RISK_SELECTION__BUILDINGS_COMB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "BUILDINGS_COMB", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "BUILDINGS_COMB");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_BC == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_BC == true",
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
              var field = Field.getInstance("RISK_SELECTION.BUILDINGS_COMB");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "BUILDINGS_COMB");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_BUILDINGS_COMB");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__BUILDINGS_COMB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__BUILDINGS_COMB_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.BUILDINGS_COMB");
        		var update = function(){
        			ToggleTabBasedOnClaim("5", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_BC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_BC", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_BC");
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
function onValidate_RISK_SELECTION__OFFICE_CONT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "OFFICE_CONT", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "OFFICE_CONT");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_OC == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_OC == true",
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
              var field = Field.getInstance("RISK_SELECTION.OFFICE_CONT");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "OFFICE_CONT");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_OFFICE_CONT");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__OFFICE_CONT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__OFFICE_CONT_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.OFFICE_CONT");
        		var update = function(){
        			ToggleTabBasedOnClaim("6", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_OC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_OC", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_OC");
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
function onValidate_RISK_SELECTION__BI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "BI", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "BI");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_BI == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_BI == true",
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
              var field = Field.getInstance("RISK_SELECTION.BI");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "BI");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_BI");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__BI');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__BI_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.BI");
        		var update = function(){
        			ToggleTabBasedOnClaim("7", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_BI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_BI", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_BI");
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
function onValidate_RISK_SELECTION__ACCOUNT_RECIEVE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "ACCOUNT_RECIEVE", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "ACCOUNT_RECIEVE");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_AR == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_AR == true",
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
              var field = Field.getInstance("RISK_SELECTION.ACCOUNT_RECIEVE");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "ACCOUNT_RECIEVE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_ACCOUNT_RECIEVE");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__ACCOUNT_RECIEVE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__ACCOUNT_RECIEVE_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.ACCOUNT_RECIEVE");
        		var update = function(){
        			ToggleTabBasedOnClaim("8", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_AR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_AR", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_AR");
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
function onValidate_RISK_SELECTION__ACCIDENTAL_DAMAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "ACCIDENTAL_DAMAGE", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "ACCIDENTAL_DAMAGE");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_AD == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_AD == true",
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
              var field = Field.getInstance("RISK_SELECTION.ACCIDENTAL_DAMAGE");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "ACCIDENTAL_DAMAGE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_ACCIDENTAL_DAMAGE");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__ACCIDENTAL_DAMAGE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__ACCIDENTAL_DAMAGE_lblFindParty");
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
        (function(){
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION.ACCIDENTAL_DAMAGE");
        		var update = function(){
        			ToggleTabBasedOnClaim("9", field.getValue());	
        		};
        		events.listen(field, "change", update);
        		update();
        	}
        })();
}
function onValidate_RISK_SELECTION__Is_temp_AD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_AD", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_AD");
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
function onValidate_RISK_SELECTION__RISK_BLOCKED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "RISK_BLOCKED", "Checkbox");
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
        			field = Field.getInstance("RISK_SELECTION", "RISK_BLOCKED");
        		}
        		//window.setProperty(field, "VE", "RISK_SELECTION.Is_temp_RB == true", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "RISK_SELECTION.Is_temp_RB == true",
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
              var field = Field.getInstance("RISK_SELECTION.RISK_BLOCKED");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "RISK_BLOCKED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_RISK_BLOCKED");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__RISK_BLOCKED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__RISK_BLOCKED_lblFindParty");
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
         * ToggleContainer
         * @param BlockedRisks The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("RISK_SELECTION","RISK_BLOCKED");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('BlockedRisks', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('BlockedRisks', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("RISK_SELECTION", "RISK_BLOCKED"), "change", update);
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=RISK_SELECTION&propertyName=RISK_BLOCKED&name={name}");
        		
        		var value = new Expression("RISK_SELECTION.Is_temp_RB"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_RISK_SELECTION__Is_temp_RB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "Is_temp_RB", "Checkbox");
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
        			var field = Field.getInstance("RISK_SELECTION", "Is_temp_RB");
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
function onValidate_RISK_SELECTION__POLICYTYPE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "POLICYTYPE", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "POLICYTYPE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.POLICYTYPE");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "POLICYTYPE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_POLICYTYPE");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__POLICYTYPE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__POLICYTYPE_lblFindParty");
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
function onValidate_RISK_SELECTION__LIMIT_NO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "LIMIT_NO", "Text");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "LIMIT_NO");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.LIMIT_NO");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "LIMIT_NO");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_LIMIT_NO");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__LIMIT_NO');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__LIMIT_NO_lblFindParty");
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
function onValidate_RISK_SELECTION__MANUAL_LIMIT_NO(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "MANUAL_LIMIT_NO", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "MANUAL_LIMIT_NO");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.MANUAL_LIMIT_NO");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "MANUAL_LIMIT_NO");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_MANUAL_LIMIT_NO");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__MANUAL_LIMIT_NO');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__MANUAL_LIMIT_NO_lblFindParty");
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
function onValidate_RISK_SELECTION__BRIGADE_AREA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "BRIGADE_AREA", "Integer");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "BRIGADE_AREA");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.BRIGADE_AREA");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "BRIGADE_AREA");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_BRIGADE_AREA");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__BRIGADE_AREA');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__BRIGADE_AREA_lblFindParty");
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
function onValidate_RISK_SELECTION__TYPE_OF_CONST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "TYPE_OF_CONST", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "TYPE_OF_CONST");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.TYPE_OF_CONST");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "TYPE_OF_CONST");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_TYPE_OF_CONST");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__TYPE_OF_CONST');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__TYPE_OF_CONST_lblFindParty");
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
function onValidate_RISK_SELECTION__CBLCKSCRN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "CBLCKSCRN", "ChildScreen");
        })();
        /** 
         * Note: This script removes the 'Delete' linkbutton in every row of the childscreen grid. It also renames 'Edit' to 'Select'
         * @param RISK_SELECTION The object name of the control to set.
         * @parma BLCKR_ITEM The property name of the control to set to the result of the calculated premium.
         */
        (function(){
        	if (isOnLoad) {
        		$('#<%=RISK_SELECTION__BLCKR_ITEM.ClientID %>').find('table').find('tr').each(function () {
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
        		var oldLinkCaption = "Select".toLowerCase();
        		var newLinkCaption = "View";
        		var field = Field.getInstance("RISK_SELECTION", "CBLCKSCRN");
        		
        		var update = function(){
        			
        			var links;
        			if (field.getType() == "child_screen"){
        				// Remove the options from the table
        				links = goog.dom.query("#ctl00_cntMainBody_RISK_SELECTION__CBLCKSCRN table td a");
        				
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
function onValidate_RISK_SELECTION__APPLICABLE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "APPLICABLE", "Checkbox");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "APPLICABLE");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.APPLICABLE");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "APPLICABLE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_APPLICABLE");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__APPLICABLE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__APPLICABLE_lblFindParty");
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
         * @fileoverview Makes a control bold.
         * MakeBold
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var instance;
        		if ("{name}" != "{na" + "me}"){
        			instance = Field.getLabel("{name}");
        		} else { 
        			instance = Field.getInstance("RISK_SELECTION", "APPLICABLE");
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
function onValidate_RISK_SELECTION__DATE_LASTSURVEY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "DATE_LASTSURVEY", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "DATE_LASTSURVEY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.DATE_LASTSURVEY");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "DATE_LASTSURVEY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_DATE_LASTSURVEY");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__DATE_LASTSURVEY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__DATE_LASTSURVEY_lblFindParty");
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
function onValidate_RISK_SELECTION__SURVEY_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "SURVEY_NUMBER", "Integer");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "SURVEY_NUMBER");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.SURVEY_NUMBER");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "SURVEY_NUMBER");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_SURVEY_NUMBER");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__SURVEY_NUMBER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__SURVEY_NUMBER_lblFindParty");
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
function onValidate_RISK_SELECTION__DATE_SUR_REQ(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "DATE_SUR_REQ", "Date");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "DATE_SUR_REQ");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.DATE_SUR_REQ");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "DATE_SUR_REQ");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_DATE_SUR_REQ");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__DATE_SUR_REQ');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__DATE_SUR_REQ_lblFindParty");
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
function onValidate_RISK_SELECTION__FREQUENCY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RISK_SELECTION", "FREQUENCY", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("RISK_SELECTION", "FREQUENCY");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("RISK_SELECTION.FREQUENCY");
        			window.setControlWidth(field, "0.7", "RISK_SELECTION", "FREQUENCY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblRISK_SELECTION_FREQUENCY");
        			    var ele = document.getElementById('ctl00_cntMainBody_RISK_SELECTION__FREQUENCY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_RISK_SELECTION__FREQUENCY_lblFindParty");
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
function onValidate_CLAIM_HISTORY__FIRE0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__FIRE0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__FIRE13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__FIRE13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__FIRE25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__FIRE25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "FIRE25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "FIRE25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BC25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BC25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BC25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__BI25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "BI25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "BI25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__OC25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "OC25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "OC25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AR25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AR25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AR25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC0_12_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC0_12_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC0_12_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC0_12_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC0_12_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC0_12_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC13_24_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC13_24_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC13_24_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC13_24_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC13_24_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC13_24_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC25_36_MONTHS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC25_36_MONTHS", "List");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC25_36_MONTHS");
        	field.setReadOnly(true);
        })();
}
function onValidate_CLAIM_HISTORY__AC25_36_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CLAIM_HISTORY", "AC25_36_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("CLAIM_HISTORY", "AC25_36_AMOUNT");
        	field.setReadOnly(true);
        })();
}
function DoLogic(isOnLoad) {
    onValidate_RISK_SELECTION__FIRE(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_fire(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__BUILDINGS_COMB(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_BC(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__OFFICE_CONT(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_OC(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__BI(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_BI(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__ACCOUNT_RECIEVE(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_AR(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__ACCIDENTAL_DAMAGE(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_AD(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__RISK_BLOCKED(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__Is_temp_RB(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__POLICYTYPE(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__LIMIT_NO(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__MANUAL_LIMIT_NO(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__BRIGADE_AREA(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__TYPE_OF_CONST(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__CBLCKSCRN(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__APPLICABLE(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__DATE_LASTSURVEY(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__SURVEY_NUMBER(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__DATE_SUR_REQ(null, null, null, isOnLoad);
    onValidate_RISK_SELECTION__FREQUENCY(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__FIRE25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BC25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__BI25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__OC25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AR25_36_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC0_12_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC0_12_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC13_24_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC13_24_AMOUNT(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC25_36_MONTHS(null, null, null, isOnLoad);
    onValidate_CLAIM_HISTORY__AC25_36_AMOUNT(null, null, null, isOnLoad);
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
<div id="id7c7a94e104eb433b8ffb5f91ab67eeb1" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idc6bbb922b91f4b688aafcf572b67d29b" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading12" runat="server" Text=" Section" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_SELECTION_FIRE" for="ctl00_cntMainBody_RISK_SELECTION__FIRE" class="col-md-4 col-sm-3 control-label">
		Fire</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="FIRE" 
		id="pb-container-checkbox-RISK_SELECTION-FIRE">	
		
		<asp:TextBox ID="RISK_SELECTION__FIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_FIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Fire"
			ClientValidationFunction="onValidate_RISK_SELECTION__FIRE" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_fire" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_fire" class="col-md-4 col-sm-3 control-label">
		Is Fire Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_fire" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_fire">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_fire" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_fire" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Fire Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_fire" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_BUILDINGS_COMB" for="ctl00_cntMainBody_RISK_SELECTION__BUILDINGS_COMB" class="col-md-4 col-sm-3 control-label">
		Buildings Combined</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="BUILDINGS_COMB" 
		id="pb-container-checkbox-RISK_SELECTION-BUILDINGS_COMB">	
		
		<asp:TextBox ID="RISK_SELECTION__BUILDINGS_COMB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_BUILDINGS_COMB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Buildings Combined"
			ClientValidationFunction="onValidate_RISK_SELECTION__BUILDINGS_COMB" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_BC" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_BC" class="col-md-4 col-sm-3 control-label">
		Is Buildings Combined Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_BC" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_BC">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_BC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_BC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Buildings Combined Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_BC" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_OFFICE_CONT" for="ctl00_cntMainBody_RISK_SELECTION__OFFICE_CONT" class="col-md-4 col-sm-3 control-label">
		Office Contents</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="OFFICE_CONT" 
		id="pb-container-checkbox-RISK_SELECTION-OFFICE_CONT">	
		
		<asp:TextBox ID="RISK_SELECTION__OFFICE_CONT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_OFFICE_CONT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Office Contents"
			ClientValidationFunction="onValidate_RISK_SELECTION__OFFICE_CONT" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_OC" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_OC" class="col-md-4 col-sm-3 control-label">
		Is Office Contents Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_OC" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_OC">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_OC" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_OC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Office Contents Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_OC" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_BI" for="ctl00_cntMainBody_RISK_SELECTION__BI" class="col-md-4 col-sm-3 control-label">
		Business Interruption</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="BI" 
		id="pb-container-checkbox-RISK_SELECTION-BI">	
		
		<asp:TextBox ID="RISK_SELECTION__BI" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_BI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Business Interruption"
			ClientValidationFunction="onValidate_RISK_SELECTION__BI" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_BI" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_BI" class="col-md-4 col-sm-3 control-label">
		Is Business Interruption Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_BI" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_BI">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_BI" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_BI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Business Interruption Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_BI" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_ACCOUNT_RECIEVE" for="ctl00_cntMainBody_RISK_SELECTION__ACCOUNT_RECIEVE" class="col-md-4 col-sm-3 control-label">
		Accounts Receivable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="ACCOUNT_RECIEVE" 
		id="pb-container-checkbox-RISK_SELECTION-ACCOUNT_RECIEVE">	
		
		<asp:TextBox ID="RISK_SELECTION__ACCOUNT_RECIEVE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_ACCOUNT_RECIEVE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Accounts Receivable"
			ClientValidationFunction="onValidate_RISK_SELECTION__ACCOUNT_RECIEVE" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_AR" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_AR" class="col-md-4 col-sm-3 control-label">
		Is Accounts Receivable Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_AR" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_AR">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_AR" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_AR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Accounts Receivable Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_AR" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_ACCIDENTAL_DAMAGE" for="ctl00_cntMainBody_RISK_SELECTION__ACCIDENTAL_DAMAGE" class="col-md-4 col-sm-3 control-label">
		Accidental Damage</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="ACCIDENTAL_DAMAGE" 
		id="pb-container-checkbox-RISK_SELECTION-ACCIDENTAL_DAMAGE">	
		
		<asp:TextBox ID="RISK_SELECTION__ACCIDENTAL_DAMAGE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_ACCIDENTAL_DAMAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Accidental Damage"
			ClientValidationFunction="onValidate_RISK_SELECTION__ACCIDENTAL_DAMAGE" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_AD" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_AD" class="col-md-4 col-sm-3 control-label">
		Is Accidental Damage Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_AD" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_AD">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_AD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_AD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Accidental Damage Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_AD" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_RISK_BLOCKED" for="ctl00_cntMainBody_RISK_SELECTION__RISK_BLOCKED" class="col-md-4 col-sm-3 control-label">
		Risk Blocked</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="RISK_BLOCKED" 
		id="pb-container-checkbox-RISK_SELECTION-RISK_BLOCKED">	
		
		<asp:TextBox ID="RISK_SELECTION__RISK_BLOCKED" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_RISK_BLOCKED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Risk Blocked"
			ClientValidationFunction="onValidate_RISK_SELECTION__RISK_BLOCKED" 
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
<label id="ctl00_cntMainBody_lblRISK_SELECTION_Is_temp_RB" for="ctl00_cntMainBody_RISK_SELECTION__Is_temp_RB" class="col-md-4 col-sm-3 control-label">
		Is Risk Blocked Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="Is_temp_RB" 
		id="pb-container-checkbox-RISK_SELECTION-Is_temp_RB">	
		
		<asp:TextBox ID="RISK_SELECTION__Is_temp_RB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_Is_temp_RB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Is Risk Blocked Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__Is_temp_RB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="RISK_SELECTION" 
		data-property-name="POLICYTYPE" 
		id="pb-container-list-RISK_SELECTION-POLICYTYPE">
		<asp:Label ID="lblRISK_SELECTION_POLICYTYPE" runat="server" AssociatedControlID="RISK_SELECTION__POLICYTYPE" 
			Text="Policy Type" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="RISK_SELECTION__POLICYTYPE" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_POLICYTYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_RISK_SELECTION__POLICYTYPE(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valRISK_SELECTION_POLICYTYPE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Policy Type"
			ClientValidationFunction="onValidate_RISK_SELECTION__POLICYTYPE" 
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
		
		data-object-name="RISK_SELECTION" 
		data-property-name="POLICYTYPECode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-RISK_SELECTION-POLICYTYPECode">

		
		
			
		
				<asp:HiddenField ID="RISK_SELECTION__POLICYTYPECode" runat="server" />

		

		
	
		
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
		if ($("#idc6bbb922b91f4b688aafcf572b67d29b div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idc6bbb922b91f4b688aafcf572b67d29b div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idc6bbb922b91f4b688aafcf572b67d29b div ul li").each(function(){		  
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
			$("#idc6bbb922b91f4b688aafcf572b67d29b div ul li").each(function(){		  
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
		styleString += "#idc6bbb922b91f4b688aafcf572b67d29b label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idc6bbb922b91f4b688aafcf572b67d29b label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc6bbb922b91f4b688aafcf572b67d29b label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc6bbb922b91f4b688aafcf572b67d29b label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idc6bbb922b91f4b688aafcf572b67d29b input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idc6bbb922b91f4b688aafcf572b67d29b input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idc6bbb922b91f4b688aafcf572b67d29b input{text-align:left;}"; break;
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
<div id="id10fb97b48089473383a4cb57047a7466" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading13" runat="server" Text="Premises Assessment" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_SELECTION" 
		data-property-name="LIMIT_NO" 
		 
		
		 
		id="pb-container-text-RISK_SELECTION-LIMIT_NO">

		
		<asp:Label ID="lblRISK_SELECTION_LIMIT_NO" runat="server" AssociatedControlID="RISK_SELECTION__LIMIT_NO" 
			Text="Reinsurance Limit Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="RISK_SELECTION__LIMIT_NO" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valRISK_SELECTION_LIMIT_NO" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Reinsurance Limit Number"
					ClientValidationFunction="onValidate_RISK_SELECTION__LIMIT_NO"
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
		data-object-name="RISK_SELECTION" 
		data-property-name="MANUAL_LIMIT_NO" 
		id="pb-container-list-RISK_SELECTION-MANUAL_LIMIT_NO">
		<asp:Label ID="lblRISK_SELECTION_MANUAL_LIMIT_NO" runat="server" AssociatedControlID="RISK_SELECTION__MANUAL_LIMIT_NO" 
			Text="Manual Reinsurance Limit Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="RISK_SELECTION__MANUAL_LIMIT_NO" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_REINS_MAN" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_RISK_SELECTION__MANUAL_LIMIT_NO(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valRISK_SELECTION_MANUAL_LIMIT_NO" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Manual Reinsurance Limit Number"
			ClientValidationFunction="onValidate_RISK_SELECTION__MANUAL_LIMIT_NO" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="RISK_SELECTION" 
		data-property-name="BRIGADE_AREA" 
		id="pb-container-integer-RISK_SELECTION-BRIGADE_AREA">
		<asp:Label ID="lblRISK_SELECTION_BRIGADE_AREA" runat="server" AssociatedControlID="RISK_SELECTION__BRIGADE_AREA" 
			Text="Fire Brigade Area" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="RISK_SELECTION__BRIGADE_AREA" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valRISK_SELECTION_BRIGADE_AREA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Fire Brigade Area"
			ClientValidationFunction="onValidate_RISK_SELECTION__BRIGADE_AREA" 
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
		data-object-name="RISK_SELECTION" 
		data-property-name="TYPE_OF_CONST" 
		id="pb-container-list-RISK_SELECTION-TYPE_OF_CONST">
		<asp:Label ID="lblRISK_SELECTION_TYPE_OF_CONST" runat="server" AssociatedControlID="RISK_SELECTION__TYPE_OF_CONST" 
			Text="Type of Construction" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="RISK_SELECTION__TYPE_OF_CONST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CONSTRUCT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_RISK_SELECTION__TYPE_OF_CONST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valRISK_SELECTION_TYPE_OF_CONST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Type of Construction"
			ClientValidationFunction="onValidate_RISK_SELECTION__TYPE_OF_CONST" 
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
		
		data-object-name="RISK_SELECTION" 
		data-property-name="MANUAL_LIMIT_NOCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-RISK_SELECTION-MANUAL_LIMIT_NOCode">

		
		
			
		
				<asp:HiddenField ID="RISK_SELECTION__MANUAL_LIMIT_NOCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="RISK_SELECTION" 
		data-property-name="TYPE_OF_CONSTCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-RISK_SELECTION-TYPE_OF_CONSTCode">

		
		
			
		
				<asp:HiddenField ID="RISK_SELECTION__TYPE_OF_CONSTCode" runat="server" />

		

		
	
		
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
		if ($("#id10fb97b48089473383a4cb57047a7466 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id10fb97b48089473383a4cb57047a7466 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id10fb97b48089473383a4cb57047a7466 div ul li").each(function(){		  
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
			$("#id10fb97b48089473383a4cb57047a7466 div ul li").each(function(){		  
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
		styleString += "#id10fb97b48089473383a4cb57047a7466 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id10fb97b48089473383a4cb57047a7466 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id10fb97b48089473383a4cb57047a7466 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id10fb97b48089473383a4cb57047a7466 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id10fb97b48089473383a4cb57047a7466 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id10fb97b48089473383a4cb57047a7466 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id10fb97b48089473383a4cb57047a7466 input{text-align:left;}"; break;
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
<div id="BlockedRisks" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading14" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_RISK_SELECTION__CBLCKSCRN"
		data-field-type="Child" 
		data-object-name="RISK_SELECTION" 
		data-property-name="CBLCKSCRN" 
		id="pb-container-childscreen-RISK_SELECTION-CBLCKSCRN">
		
		    <legend>Risk Blocked</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="RISK_SELECTION__BLCKR_ITEM" runat="server" ScreenCode="CBLCKSCRN" AutoGenerateColumns="false"
							GridLines="None" ChildPage="CBLCKSCRN/CBLCKSCRN_Blocked_Risks.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Policy Number" DataField="POLICY_NUMBER" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Client Name" DataField="CLIENT_NAME" DataFormatString=""/>

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
				
					<asp:CustomValidator ID="valRISK_SELECTION_CBLCKSCRN" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Risk Blocked"
						ClientValidationFunction="onValidate_RISK_SELECTION__CBLCKSCRN" 
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
		if ($("#BlockedRisks div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#BlockedRisks div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#BlockedRisks div ul li").each(function(){		  
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
			$("#BlockedRisks div ul li").each(function(){		  
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
		styleString += "#BlockedRisks label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#BlockedRisks label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#BlockedRisks label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#BlockedRisks label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#BlockedRisks input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#BlockedRisks input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#BlockedRisks input{text-align:left;}"; break;
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
<div id="SurveyReport" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading15" runat="server" Text="Survey Report" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRISK_SELECTION_APPLICABLE" for="ctl00_cntMainBody_RISK_SELECTION__APPLICABLE" class="col-md-4 col-sm-3 control-label">
		Applicable</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RISK_SELECTION" 
		data-property-name="APPLICABLE" 
		id="pb-container-checkbox-RISK_SELECTION-APPLICABLE">	
		
		<asp:TextBox ID="RISK_SELECTION__APPLICABLE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRISK_SELECTION_APPLICABLE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Applicable"
			ClientValidationFunction="onValidate_RISK_SELECTION__APPLICABLE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label2">
		<span class="label" id="label2"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="RISK_SELECTION" 
		data-property-name="DATE_LASTSURVEY" 
		id="pb-container-datejquerycompatible-RISK_SELECTION-DATE_LASTSURVEY">
		<asp:Label ID="lblRISK_SELECTION_DATE_LASTSURVEY" runat="server" AssociatedControlID="RISK_SELECTION__DATE_LASTSURVEY" 
			Text="Last Survey Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="RISK_SELECTION__DATE_LASTSURVEY" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calRISK_SELECTION__DATE_LASTSURVEY" runat="server" LinkedControl="RISK_SELECTION__DATE_LASTSURVEY" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valRISK_SELECTION_DATE_LASTSURVEY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Last Survey Date"
			ClientValidationFunction="onValidate_RISK_SELECTION__DATE_LASTSURVEY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="RISK_SELECTION" 
		data-property-name="SURVEY_NUMBER" 
		id="pb-container-integer-RISK_SELECTION-SURVEY_NUMBER">
		<asp:Label ID="lblRISK_SELECTION_SURVEY_NUMBER" runat="server" AssociatedControlID="RISK_SELECTION__SURVEY_NUMBER" 
			Text="Survey Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="RISK_SELECTION__SURVEY_NUMBER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valRISK_SELECTION_SURVEY_NUMBER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Survey Number"
			ClientValidationFunction="onValidate_RISK_SELECTION__SURVEY_NUMBER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="RISK_SELECTION" 
		data-property-name="DATE_SUR_REQ" 
		id="pb-container-datejquerycompatible-RISK_SELECTION-DATE_SUR_REQ">
		<asp:Label ID="lblRISK_SELECTION_DATE_SUR_REQ" runat="server" AssociatedControlID="RISK_SELECTION__DATE_SUR_REQ" 
			Text="Date Survey Requested" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="RISK_SELECTION__DATE_SUR_REQ" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calRISK_SELECTION__DATE_SUR_REQ" runat="server" LinkedControl="RISK_SELECTION__DATE_SUR_REQ" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valRISK_SELECTION_DATE_SUR_REQ" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Date Survey Requested"
			ClientValidationFunction="onValidate_RISK_SELECTION__DATE_SUR_REQ" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="RISK_SELECTION" 
		data-property-name="FREQUENCY" 
		id="pb-container-list-RISK_SELECTION-FREQUENCY">
		<asp:Label ID="lblRISK_SELECTION_FREQUENCY" runat="server" AssociatedControlID="RISK_SELECTION__FREQUENCY" 
			Text="Frequency" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="RISK_SELECTION__FREQUENCY" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_SURVEY_FREQ" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_RISK_SELECTION__FREQUENCY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valRISK_SELECTION_FREQUENCY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Frequency"
			ClientValidationFunction="onValidate_RISK_SELECTION__FREQUENCY" 
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
		
		data-object-name="RISK_SELECTION" 
		data-property-name="FREQUENCYCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-RISK_SELECTION-FREQUENCYCode">

		
		
			
		
				<asp:HiddenField ID="RISK_SELECTION__FREQUENCYCode" runat="server" />

		

		
	
		
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
		if ($("#SurveyReport div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#SurveyReport div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#SurveyReport div ul li").each(function(){		  
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
			$("#SurveyReport div ul li").each(function(){		  
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
		styleString += "#SurveyReport label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#SurveyReport label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#SurveyReport label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#SurveyReport label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#SurveyReport input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#SurveyReport input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#SurveyReport input{text-align:left;}"; break;
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
		
				
	              <legend><asp:Label ID="lblHeading16" runat="server" Text="Past Claims History" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="10:15:15:15:15:15:15" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label3">
		<span class="label" id="label3"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label4">
		<span class="label" id="label4">0-12 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label5">
		<span class="label" id="label5">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label6">
		<span class="label" id="label6">13-24 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label7">
		<span class="label" id="label7">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label8">
		<span class="label" id="label8">25-36 Months</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label9">
		<span class="label" id="label9">Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label10">
		<span class="label" id="label10"><B>Fire</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-FIRE0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__FIRE0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__FIRE0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-FIRE0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__FIRE0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-FIRE13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__FIRE13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__FIRE13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-FIRE13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__FIRE13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-FIRE25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__FIRE25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__FIRE25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-FIRE25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_FIRE25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__FIRE25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__FIRE25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_FIRE25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.FIRE25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__FIRE25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label11">
		<span class="label" id="label11"><B>Buildings Combined</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BC0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BC0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BC0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BC0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BC0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BC0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BC0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BC0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BC0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BC0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BC0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BC13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BC13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BC13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BC13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BC13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BC13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BC13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BC13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BC13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BC13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BC13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BC25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BC25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BC25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BC25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BC25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BC25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BC25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BC25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BC25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BC25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BC25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BC25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BC25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label12">
		<span class="label" id="label12"><B>Business Interruption</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BI0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BI0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BI0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BI0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BI0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BI0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BI0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BI0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BI0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BI0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BI0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BI13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BI13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BI13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BI13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BI13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BI13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BI13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BI13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BI13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BI13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BI13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-BI25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_BI25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__BI25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__BI25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__BI25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_BI25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-BI25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_BI25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__BI25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__BI25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_BI25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.BI25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__BI25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label13">
		<span class="label" id="label13"><B>Office Contents</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-OC0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_OC0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__OC0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__OC0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__OC0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_OC0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-OC0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_OC0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__OC0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__OC0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_OC0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-OC13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_OC13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__OC13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__OC13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__OC13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_OC13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-OC13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_OC13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__OC13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__OC13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_OC13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-OC25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_OC25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__OC25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__OC25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__OC25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_OC25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-OC25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_OC25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__OC25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__OC25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_OC25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.OC25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__OC25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label14">
		<span class="label" id="label14"><B>Accounts Receivable</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AR0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AR0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AR0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AR0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AR0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AR0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AR0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AR0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AR0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AR0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AR0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AR13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AR13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AR13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AR13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AR13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AR13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AR13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AR13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AR13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AR13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AR13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AR25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AR25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AR25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AR25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AR25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AR25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AR25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AR25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AR25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AR25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AR25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AR25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AR25_36_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:10%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label15">
		<span class="label" id="label15"><B>Accidental Damage</B></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC0_12_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AC0_12_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AC0_12_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AC0_12_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AC0_12_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AC0_12_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AC0_12_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC0_12_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC0_12_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC0_12_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AC0_12_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AC0_12_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AC0_12_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AC0_12_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AC0_12_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC0_12_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC0_12_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC13_24_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AC13_24_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AC13_24_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AC13_24_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AC13_24_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AC13_24_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AC13_24_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC13_24_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC13_24_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC13_24_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AC13_24_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AC13_24_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AC13_24_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AC13_24_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AC13_24_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC13_24_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC13_24_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC25_36_MONTHS" 
		id="pb-container-list-CLAIM_HISTORY-AC25_36_MONTHS">
		<asp:Label ID="lblCLAIM_HISTORY_AC25_36_MONTHS" runat="server" AssociatedControlID="CLAIM_HISTORY__AC25_36_MONTHS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CLAIM_HISTORY__AC25_36_MONTHS" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLAIMS_CNT" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CLAIM_HISTORY__AC25_36_MONTHS(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCLAIM_HISTORY_AC25_36_MONTHS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC25_36_MONTHS"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC25_36_MONTHS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:15%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC25_36_AMOUNT" 
		id="pb-container-currency-CLAIM_HISTORY-AC25_36_AMOUNT">
		<asp:Label ID="lblCLAIM_HISTORY_AC25_36_AMOUNT" runat="server" AssociatedControlID="CLAIM_HISTORY__AC25_36_AMOUNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CLAIM_HISTORY__AC25_36_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCLAIM_HISTORY_AC25_36_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for CLAIM_HISTORY.AC25_36_AMOUNT"
			ClientValidationFunction="onValidate_CLAIM_HISTORY__AC25_36_AMOUNT" 
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
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-FIRE0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__FIRE0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-FIRE13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__FIRE13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="FIRE25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-FIRE25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__FIRE25_36_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BC0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BC0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BC13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BC13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BC25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BC25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BC25_36_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BI0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BI0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BI13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BI13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="BI25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-BI25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__BI25_36_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-OC0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__OC0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-OC13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__OC13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="OC25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-OC25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__OC25_36_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AR0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AR0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AR13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AR13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AR25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AR25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AR25_36_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC0_12_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AC0_12_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AC0_12_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC13_24_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AC13_24_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AC13_24_MONTHSCode" runat="server" />

		

		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
									<li class="co-cell hidden-dre" style="display: none;">
								
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CLAIM_HISTORY" 
		data-property-name="AC25_36_MONTHSCode" 
		data-dre="true" 
		
		data-suffix-none="true" 
		id="pb-container-text-CLAIM_HISTORY-AC25_36_MONTHSCode">

		
		
			
		
				<asp:HiddenField ID="CLAIM_HISTORY__AC25_36_MONTHSCode" runat="server" />

		

		
	
		
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