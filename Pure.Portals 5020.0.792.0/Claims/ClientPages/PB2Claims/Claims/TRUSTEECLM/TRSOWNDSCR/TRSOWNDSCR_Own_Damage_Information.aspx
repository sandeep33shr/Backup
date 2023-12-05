<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="TRSOWNDSCR_Own_Damage_Information.aspx.vb" Inherits="Nexus.PB2_TRSOWNDSCR_Own_Damage_Information" %>

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
        	if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        			{
        				ele= document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop + '_' + 'txtPartyName');
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
        		
        		
        		if (parentClassName !="col-md-8 col-sm-9")
        		{
        			ele.parentElement.parentElement.className = sWidthClass2 ;
        		}
        		else
        			ele.parentElement.className = sWidthClass2;
        		
        		
        		
        		
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
function onValidate_OWNDCLAIM__TransactionType(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "TransactionType", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "TransactionType");
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
function onValidate_OWNDCLAIM__ITEM_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "ITEM_NUMBER", "Text");
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
        			var field = Field.getInstance("OWNDCLAIM", "ITEM_NUMBER");
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
function onValidate_OWNDCLAIM__PERIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PERIL", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("OWNDCLAIM", "PERIL");
        		var errorMessage = "Peril is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=List&objectName=OWNDCLAIM&propertyName=PERIL&name={name}");
        		
        		var value = new Expression("2"), 
        			condition = (Expression.isValidParameter("TRUSTEECLAIM.ITOOAPPROV== false")) ? new Expression("TRUSTEECLAIM.ITOOAPPROV== false") : null, 
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PERIL");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PERIL');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PERIL_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PERIL");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PERIL");
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
        			var message = (Expression.isValidParameter("Peril is invalid")) ? "Peril is invalid" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "__" + "PERIL");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "_" + "PERIL");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(Code(OWNDCLAIM.PERIL) == 'TRSTLIAB' AND TRUSTEECLAIM.ITOOAPPROV == true) || (Code(OWNDCLAIM.PERIL) == 'TRSTLIABEX' AND TRUSTEECLAIM.ITOOAPPROV == false) || (Code(OWNDCLAIM.PERIL) == 'EXTCPC' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.CPC_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXCOR' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.COR_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXELC' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.ELC_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXERP' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.CPC_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXIC' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.IC_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXROR' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.ROR_TOP == true) || (Code(OWNDCLAIM.PERIL) == 'TREXTPLC' AND TRUSTEECLAIM.ITOOAPPROV == true AND TRUSTEECLAIM_EXT.TPLC_TOP == true)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_OWNDCLAIM__DESCRIPTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "DESCRIPTION", "List");
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
        			field = Field.getInstance("OWNDCLAIM", "DESCRIPTION");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_DESCRIPTION");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__DESCRIPTION');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__DESCRIPTION_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.DESCRIPTION");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "DESCRIPTION");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__RESERVE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "RESERVE", "Currency");
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
        			field = Field.getInstance("OWNDCLAIM", "RESERVE");
        		}
        		//window.setProperty(field, "VEM", "OWNDCLAIM.TransactionType = 'NEWCLAIM' || OWNDCLAIM.TransactionType = 'EDITCLAIM'", "V", "Reserve is a mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "OWNDCLAIM.TransactionType = 'NEWCLAIM' || OWNDCLAIM.TransactionType = 'EDITCLAIM'",
            paramElseValue = "V",
            paramValidationMessage = "Reserve is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_RESERVE");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__RESERVE');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__RESERVE_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.RESERVE");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "RESERVE");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('OWNDCLAIM', 'RESERVE');
        			
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
function onValidate_OWNDCLAIM__IS_PAYCLAIM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "IS_PAYCLAIM", "Checkbox");
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
        			var field = Field.getInstance("OWNDCLAIM", "IS_PAYCLAIM");
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=OWNDCLAIM&propertyName=IS_PAYCLAIM&name={name}");
        		
        		var value = new Expression("true"), 
        			condition = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM'")) ? new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmPayment The element to toggle
         * @param OWNDCLAIM.TransactionType = 'PAYCLAIM' True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("OWNDCLAIM","IS_PAYCLAIM");
        	
        		var inverse = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM'") && ("OWNDCLAIM.TransactionType = 'PAYCLAIM'".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmPayment', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmPayment', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("OWNDCLAIM", "IS_PAYCLAIM"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_OWNDCLAIM__IS_EFT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "IS_EFT", "Checkbox");
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
        			var field = Field.getInstance("OWNDCLAIM", "IS_EFT");
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
        		var field = Field.getWithQuery("type=Checkbox&objectName=OWNDCLAIM&propertyName=IS_EFT&name={name}");
        		
        		var value = new Expression("true"), 
        			condition = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM' AND Code(OWNDCLAIM.PAYMENT_TYPE)=='EFT'")) ? new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM' AND Code(OWNDCLAIM.PAYMENT_TYPE)=='EFT'") : null, 
        			elseValue = (Expression.isValidParameter("false")) ? new Expression("false") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmBankInfo The element to toggle
         * @param OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (OWNDCLAIM.IS_PAYCLAIM ==1) AND Code(OWNDCLAIM.PAYMENT_TYPE)=='EFT' True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("OWNDCLAIM","IS_EFT");
        	
        		var inverse = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (OWNDCLAIM.IS_PAYCLAIM ==1) AND Code(OWNDCLAIM.PAYMENT_TYPE)=='EFT'") && ("OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (OWNDCLAIM.IS_PAYCLAIM ==1) AND Code(OWNDCLAIM.PAYMENT_TYPE)=='EFT'".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmBankInfo', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmBankInfo', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("OWNDCLAIM", "IS_EFT"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_OWNDCLAIM__PAYMENT_TYPE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PAYMENT_TYPE", "List");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PAYMENT_TYPE");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PAYMENT_TYPE');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PAYMENT_TYPE_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PAYMENT_TYPE");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PAYMENT_TYPE");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__PAYEE_TYPE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PAYEE_TYPE", "List");
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
        			field = Field.getInstance("OWNDCLAIM", "PAYEE_TYPE");
        		}
        		//window.setProperty(field, "VEM", "OWNDCLAIM.TransactionType = 'PAYCLAIM'", "R", "Payee Type is a mandatory and an option must be entered");
        
            var paramValue = "VEM",
            paramCondition = "OWNDCLAIM.TransactionType = 'PAYCLAIM'",
            paramElseValue = "R",
            paramValidationMessage = "Payee Type is a mandatory and an option must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PAYEE_TYPE");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PAYEE_TYPE');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PAYEE_TYPE_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PAYEE_TYPE");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PAYEE_TYPE");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__PARTYNAME(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PARTYNAME", "Text");
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
        			var field = Field.getInstance("OWNDCLAIM", "PARTYNAME");
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
        		var field = Field.getWithQuery("type=Text&objectName=OWNDCLAIM&propertyName=PARTYNAME&name={name}");
        		
        		var value = new Expression("OWNDCLAIM.Payee_Name"), 
        			condition = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM'")) ? new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_OWNDCLAIM__CLIENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "CLIENT", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "CLIENT");
        		}
        		//window.setProperty(field, "V", "Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'",
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
        		var field = Field.getWithQuery("type=Text&objectName=OWNDCLAIM&propertyName=CLIENT&name={name}");
        		
        		var value = new Expression("TRUSTEECLAIM.INSURED"), 
        			condition = (Expression.isValidParameter("Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'")) ? new Expression("Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'") : null, 
        			elseValue = (Expression.isValidParameter("''")) ? new Expression("''") : null;
        		
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_CLIENT");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__CLIENT');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__CLIENT_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.CLIENT");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "CLIENT");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__PARTY_NAME(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PARTY_NAME", "Party");
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
        			field = Field.getInstance("OWNDCLAIM", "PARTY_NAME");
        		}
        		//window.setProperty(field, "VEM", "Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY'", "R", "Other Party is a mandatory and an option must be entered");
        
            var paramValue = "VEM",
            paramCondition = "Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY'",
            paramElseValue = "R",
            paramValidationMessage = "Other Party is a mandatory and an option must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PARTY_NAME");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PARTY_NAME');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PARTY_NAME_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PARTY_NAME");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PARTY_NAME");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__BASEPARTYKEY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "BASEPARTYKEY", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "BASEPARTYKEY");
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
function onValidate_OWNDCLAIM__PARTYKEY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PARTYKEY", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "PARTYKEY");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Text&objectName=OWNDCLAIM&propertyName=PARTYKEY&name={name}");
        		
        		var value = new Expression("OWNDCLAIM.PARTY_NAME"), 
        			condition = (Expression.isValidParameter("Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' AND (OWNDCLAIM.PARTY_NAME > 0)")) ? new Expression("Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' AND (OWNDCLAIM.PARTY_NAME > 0)") : null, 
        			elseValue = (Expression.isValidParameter("OWNDCLAIM.BASEPARTYKEY")) ? new Expression("OWNDCLAIM.BASEPARTYKEY") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_OWNDCLAIM__MEDIA_REF(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "MEDIA_REF", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "MEDIA_REF");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_MEDIA_REF");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__MEDIA_REF');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__MEDIA_REF_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.MEDIA_REF");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "MEDIA_REF");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__PAID_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PAID_AMOUNT", "Currency");
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
        			field = Field.getInstance("OWNDCLAIM", "PAID_AMOUNT");
        		}
        		//window.setProperty(field, "VEM", "OWNDCLAIM.TransactionType = 'PAYCLAIM'", "R", "Payment Amount is a mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "OWNDCLAIM.TransactionType = 'PAYCLAIM'",
            paramElseValue = "R",
            paramValidationMessage = "Payment Amount is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PAID_AMOUNT");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PAID_AMOUNT');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PAID_AMOUNT_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PAID_AMOUNT");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PAID_AMOUNT");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('OWNDCLAIM', 'PAID_AMOUNT');
        			
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
function onValidate_OWNDCLAIM__TAX_GROUP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "TAX_GROUP", "List");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_TAX_GROUP");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__TAX_GROUP');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__TAX_GROUP_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.TAX_GROUP");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "TAX_GROUP");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__TAX_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "TAX_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("OWNDCLAIM", "TAX_AMOUNT");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_TAX_AMOUNT");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__TAX_AMOUNT');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__TAX_AMOUNT_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.TAX_AMOUNT");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "TAX_AMOUNT");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('OWNDCLAIM', 'TAX_AMOUNT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=OWNDCLAIM&propertyName=TAX_AMOUNT&name={name}");
        		
        		var value = new Expression("OWNDCLAIM.PAID_AMOUNT - OWNDCLAIM.PAYMENT_AMOUNT"), 
        			condition = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM'")) ? new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_OWNDCLAIM__PAYMENT_AMOUNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "PAYMENT_AMOUNT", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("OWNDCLAIM", "PAYMENT_AMOUNT");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_PAYMENT_AMOUNT");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__PAYMENT_AMOUNT');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__PAYMENT_AMOUNT_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.PAYMENT_AMOUNT");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "PAYMENT_AMOUNT");
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
        		var field = Field.getWithQuery("type=Currency&objectName=OWNDCLAIM&propertyName=PAYMENT_AMOUNT&name={name}");
        		
        		var value = new Expression("OWNDCLAIM.PAID_AMOUNT/1.15"), 
        			condition = (Expression.isValidParameter("Code(OWNDCLAIM.TAX_GROUP)=='VAT' AND (OWNDCLAIM.TransactionType = 'PAYCLAIM')")) ? new Expression("Code(OWNDCLAIM.TAX_GROUP)=='VAT' AND (OWNDCLAIM.TransactionType = 'PAYCLAIM')") : null, 
        			elseValue = (Expression.isValidParameter("OWNDCLAIM.PAID_AMOUNT")) ? new Expression("OWNDCLAIM.PAID_AMOUNT") : null;
        		
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
        			var message = (Expression.isValidParameter("Payment Amount can not be more than the raised reserve amount")) ? "Payment Amount can not be more than the raised reserve amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "__" + "PAYMENT_AMOUNT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "_" + "PAYMENT_AMOUNT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("OWNDCLAIM.PAYMENT_AMOUNT <= OWNDCLAIM.RESERVE");
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
        
        			var field = Field.getInstance('OWNDCLAIM', 'PAYMENT_AMOUNT');
        			
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
function onValidate_OWNDCLAIM__OUT_PAYMENT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "OUT_PAYMENT", "Currency");
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
        			field = Field.getInstance("OWNDCLAIM", "OUT_PAYMENT");
        		}
        		//window.setProperty(field, "V", "OWNDCLAIM.TransactionType = 'PAYCLAIM'", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "OWNDCLAIM.TransactionType = 'PAYCLAIM'",
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_OUT_PAYMENT");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__OUT_PAYMENT');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__OUT_PAYMENT_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.OUT_PAYMENT");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "OUT_PAYMENT");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('OWNDCLAIM', 'OUT_PAYMENT');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=OWNDCLAIM&propertyName=OUT_PAYMENT&name={name}");
        		
        		var value = new Expression("OWNDCLAIM.RESERVE - OWNDCLAIM.PAYMENT_AMOUNT"), 
        			condition = (Expression.isValidParameter("OWNDCLAIM.TransactionType = 'PAYCLAIM'")) ? new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM'") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_OWNDCLAIM__IS_EXGRATIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "IS_EXGRATIA", "Checkbox");
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
        			field = Field.getInstance("OWNDCLAIM", "IS_EXGRATIA");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_IS_EXGRATIA");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__IS_EXGRATIA');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__IS_EXGRATIA_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.IS_EXGRATIA");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "IS_EXGRATIA");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__BANKLIST(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "BANKLIST", "List");
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
        			field = Field.getInstance("OWNDCLAIM", "BANKLIST");
        		}
        		//window.setProperty(field, "VEM", "OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')", "R", "Bank list is a mandatory and an option must be entered");
        
            var paramValue = "VEM",
            paramCondition = "OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')",
            paramElseValue = "R",
            paramValidationMessage = "Bank list is a mandatory and an option must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_BANKLIST");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__BANKLIST');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__BANKLIST_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.BANKLIST");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "BANKLIST");
        		})();
        	}
        })();
        $(document).ready(function()
        {
        	
        	var account_field = Field.getInstance ("OWNDCLAIM","BANKLIST");
        	events.listen(account_field,"change", function (e)
        	{
        		var bank_result= account_field.getCode();
        		if (bank_result != null && bank_result != "")
        		{
        			__doPostBack('<%=asyncPanel.ClientID%>', 'Clientbank,' + bank_result);
        		}
        		
        	},false, this);
        	
        	var agentKey
        	var client_key_field = Field.getInstance ("OWNDCLAIM","BASEPARTYKEY");
        	var payee_key_field = Field.getInstance ("OWNDCLAIM","PAYEE_TYPE");
        	var otherParty_field = Field.getInstance ("OWNDCLAIM","PARTY_NAME");
        	
        	events.listen(payee_key_field,"change", function (e)
        	{
        		var clientKey 
        		var party_key
        		
        		 
        		if (payee_key_field.getCaption() =="Client")
        		{
        			clientKey = client_key_field.getValue();
        			party_key = clientKey;
        			//alert("Client " + party_key);
        				if (party_key != null && party_key != "")
        			{
        				__doPostBack('', 'party_key,' + party_key);
        			}
        		}
        	},false, this);
        	
        	
        	events.listen(otherParty_field,"change", function (e)
        	{	
        		var party_key
        		var agentKey
        		if (payee_key_field.getCaption() =="Other Party")
        		{
        			agentKey = otherParty_field.getValue();
        			party_key = agentKey;
        			//alert("Party " + party_key);
        			
        				if (party_key != null && party_key != "")
        			{
        				__doPostBack('', 'party_key,' + party_key);
        			}
        		}
        		
        	},false, this);	
        	
        	
        	
        	
        	
        });
}
function onValidate_OWNDCLAIM__Account_Type(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Account_Type", "List");
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
        			field = Field.getInstance("OWNDCLAIM", "Account_Type");
        		}
        		//window.setProperty(field, "VEM", "OWNDCLAIM.TransactionType = 'PAYCLAIM'", "R", "Account Type is a mandatory and an option must be entered");
        
            var paramValue = "VEM",
            paramCondition = "OWNDCLAIM.TransactionType = 'PAYCLAIM'",
            paramElseValue = "R",
            paramValidationMessage = "Account Type is a mandatory and an option must be entered";
            
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
         * ReadOnlyWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("OWNDCLAIM", "Account_Type");
        		var exp = new Expression("OWNDCLAIM.TransactionType = 'PAYCLAIM' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')");
        
        		var update = function(){
        			if (exp.getValue() == true){
        				field.setReadOnly(true);
        				field.getElement().blur();
        			} else {
        				field.setReadOnly(false);
        			}
        		};
        		events.listen(exp, "change", update);
        		events.listen(field, "visibilitychange", update);
        		events.listen(field, "displaychange", update);
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Account_Type");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Account_Type');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Account_Type_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Account_Type");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Account_Type");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Payee_Name(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Payee_Name", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "Payee_Name");
        		}
        		//window.setProperty(field, "V", "Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'", "VEM", "Account Holder Name is a mandatory and must be entered");
        
            var paramValue = "V",
            paramCondition = "Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT'",
            paramElseValue = "VEM",
            paramValidationMessage = "Account Holder Name is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Payee_Name");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Payee_Name');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Payee_Name_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Payee_Name");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Payee_Name");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Payment_Date(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Payment_Date", "Date");
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Date&objectName=OWNDCLAIM&propertyName=Payment_Date&name={name}");
        		
        		var value = new Expression("TODAY"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("OWNDCLAIM", "Payment_Date");
        		var errorMessage = "Payment Date is a mandatory and an option must be entered";
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Payment_Date");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Payment_Date');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Payment_Date_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Payment_Date");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Payment_Date");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Bank_Name(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Bank_Name", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "Bank_Name");
        		}
        		//window.setProperty(field, "V", "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')", "VEM", "Bank Name is a mandatory and must be entered");
        
            var paramValue = "V",
            paramCondition = "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')",
            paramElseValue = "VEM",
            paramValidationMessage = "Bank Name is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Bank_Name");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Bank_Name');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Bank_Name_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Bank_Name");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Bank_Name");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Branch_Code(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Branch_Code", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "Branch_Code");
        		}
        		//window.setProperty(field, "V", "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')", "VEM", "Branch Code is a mandatory and must be entered");
        
            var paramValue = "V",
            paramCondition = "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')",
            paramElseValue = "VEM",
            paramValidationMessage = "Branch Code is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Branch_Code");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Branch_Code');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Branch_Code_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Branch_Code");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Branch_Code");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Bank_Account_No(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Bank_Account_No", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "Bank_Account_No");
        		}
        		//window.setProperty(field, "V", "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')", "VEM", "Bank Account Number is a mandatory and must be entered");
        
            var paramValue = "V",
            paramCondition = "Code(OWNDCLAIM.PAYMENT_TYPE) == 'EFT' AND (Code(OWNDCLAIM.PAYEE_TYPE) == 'PARTY' OR Code(OWNDCLAIM.PAYEE_TYPE) == 'CLIENT')",
            paramElseValue = "VEM",
            paramValidationMessage = "Bank Account Number is a mandatory and must be entered";
            
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Bank_Account_No");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Bank_Account_No');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Bank_Account_No_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Bank_Account_No");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Bank_Account_No");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Their_Ref(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Their_Ref", "Text");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Their_Ref");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Their_Ref');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Their_Ref_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Their_Ref");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Their_Ref");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Our_Ref(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Our_Ref", "Text");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Our_Ref");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Our_Ref');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Our_Ref_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.Our_Ref");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "Our_Ref");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__BIC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "BIC", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "BIC");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_BIC");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__BIC');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__BIC_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.BIC");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "BIC");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__IBAN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "IBAN", "Text");
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
        			field = Field.getInstance("OWNDCLAIM", "IBAN");
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_IBAN");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__IBAN');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__IBAN_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.IBAN");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "IBAN");
        		})();
        	}
        })();
}
function onValidate_OWNDCLAIM__Comments(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "Comments", "Comment");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("OWNDCLAIM.Comments");
        			window.setControlWidth(field, "0.5", "OWNDCLAIM", "Comments");
        		})();
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
        			var instance = Field.getWithQuery("type=Comment&objectName=OWNDCLAIM&propertyName=Comments&name={name}");
        			if (instance && instance.setHeight && instance.getHeight){
        				if (instance.getHeight() == 0){
        					//	If field is hidden, getHeight() returns 0 so set to 20px X height
        					instance.setHeight(20 * height);
        				} else {
        					instance.setHeight(instance.getHeight() * height);
        				}
        			}
        			
        			var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Comments');
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
        			var textarea = document.getElementById('ctl00_cntMainBody_OWNDCLAIM_Comments_textarea');
        			if (textarea != null){
        				bounds = window.getBounds(textarea);
        				textarea.style.height = height + "px";
        			}
        			
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_Comments");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__Comments');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__Comments_lblFindParty");							
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
function onValidate_OWNDCLAIM__TOTAL_PAID(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "OWNDCLAIM", "TOTAL_PAID", "Currency");
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
        			field = Field.getInstance("OWNDCLAIM", "TOTAL_PAID");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Currency&objectName=OWNDCLAIM&propertyName=TOTAL_PAID&name={name}");
        		
        		var value = new Expression("TRUSTEECLAIM.TOTALPAID"), 
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
        				var label = document.getElementById("ctl00_cntMainBody_lblOWNDCLAIM_TOTAL_PAID");
        					var ele = document.getElementById('ctl00_cntMainBody_OWNDCLAIM__TOTAL_PAID');
        					if(ele.firstElementChild != null && ele.firstElementChild.id=='Controls_FindParty')
        						{
        							label= document.getElementById("ctl00_cntMainBody_OWNDCLAIM__TOTAL_PAID_lblFindParty");							
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
              var field = Field.getInstance("OWNDCLAIM.TOTAL_PAID");
        			window.setControlWidth(field, "0.8", "OWNDCLAIM", "TOTAL_PAID");
        		})();
        	}
        })();
        /**
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('OWNDCLAIM', 'TOTAL_PAID');
        			
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
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("OWNDCLAIM", "TOTAL_PAID");
        	field.setReadOnly(true);
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Total Payment Amount can not be more than the raised reserve amount")) ? "Total Payment Amount can not be more than the raised reserve amount" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "__" + "TOTAL_PAID");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "OWNDCLAIM".toUpperCase() + "_" + "TOTAL_PAID");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("OWNDCLAIM.TOTAL_PAID <= OWNDCLAIM.RESERVE");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function DoLogic(isOnLoad) {
    onValidate_OWNDCLAIM__TransactionType(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__ITEM_NUMBER(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PERIL(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__DESCRIPTION(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__RESERVE(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__IS_PAYCLAIM(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__IS_EFT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PAYMENT_TYPE(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PAYEE_TYPE(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PARTYNAME(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__CLIENT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PARTY_NAME(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__BASEPARTYKEY(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PARTYKEY(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__MEDIA_REF(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PAID_AMOUNT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__TAX_GROUP(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__TAX_AMOUNT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__PAYMENT_AMOUNT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__OUT_PAYMENT(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__IS_EXGRATIA(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__BANKLIST(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Account_Type(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Payee_Name(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Payment_Date(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Bank_Name(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Branch_Code(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Bank_Account_No(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Their_Ref(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Our_Ref(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__BIC(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__IBAN(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__Comments(null, null, null, isOnLoad);
    onValidate_OWNDCLAIM__TOTAL_PAID(null, null, null, isOnLoad);
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
<div id="id71a918786504484f899f63110498240b" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idf13dc4901085495ea1c431e48cd45c68" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading33" runat="server" Text="Own Damage Detail" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="OWNDCLAIM" 
		data-property-name="TransactionType" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-TransactionType">

		
		<asp:Label ID="lblOWNDCLAIM_TransactionType" runat="server" AssociatedControlID="OWNDCLAIM__TransactionType" 
			Text="{none}" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__TransactionType" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_TransactionType" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for {none}"
					ClientValidationFunction="onValidate_OWNDCLAIM__TransactionType"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="ITEM_NUMBER" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-ITEM_NUMBER">

		
		<asp:Label ID="lblOWNDCLAIM_ITEM_NUMBER" runat="server" AssociatedControlID="OWNDCLAIM__ITEM_NUMBER" 
			Text="Item Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__ITEM_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_ITEM_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Item Number"
					ClientValidationFunction="onValidate_OWNDCLAIM__ITEM_NUMBER"
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
		data-object-name="OWNDCLAIM" 
		data-property-name="PERIL" 
		id="pb-container-list-OWNDCLAIM-PERIL">
		<asp:Label ID="lblOWNDCLAIM_PERIL" runat="server" AssociatedControlID="OWNDCLAIM__PERIL" 
			Text="Peril" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__PERIL" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_TRST_PERIL_TYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__PERIL(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_PERIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Peril"
			ClientValidationFunction="onValidate_OWNDCLAIM__PERIL" 
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
		data-object-name="OWNDCLAIM" 
		data-property-name="DESCRIPTION" 
		id="pb-container-list-OWNDCLAIM-DESCRIPTION">
		<asp:Label ID="lblOWNDCLAIM_DESCRIPTION" runat="server" AssociatedControlID="OWNDCLAIM__DESCRIPTION" 
			Text="Reserve Description" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__DESCRIPTION" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLA_INDEMNITY" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__DESCRIPTION(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_DESCRIPTION" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Reserve Description"
			ClientValidationFunction="onValidate_OWNDCLAIM__DESCRIPTION" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="OWNDCLAIM" 
		data-property-name="RESERVE" 
		id="pb-container-currency-OWNDCLAIM-RESERVE">
		<asp:Label ID="lblOWNDCLAIM_RESERVE" runat="server" AssociatedControlID="OWNDCLAIM__RESERVE" 
			Text="Reserve" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__RESERVE" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_RESERVE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Reserve"
			ClientValidationFunction="onValidate_OWNDCLAIM__RESERVE" 
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
<label id="ctl00_cntMainBody_lblOWNDCLAIM_IS_PAYCLAIM" for="ctl00_cntMainBody_OWNDCLAIM__IS_PAYCLAIM" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="OWNDCLAIM" 
		data-property-name="IS_PAYCLAIM" 
		id="pb-container-checkbox-OWNDCLAIM-IS_PAYCLAIM">	
		
		<asp:TextBox ID="OWNDCLAIM__IS_PAYCLAIM" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valOWNDCLAIM_IS_PAYCLAIM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for OWNDCLAIM.IS_PAYCLAIM"
			ClientValidationFunction="onValidate_OWNDCLAIM__IS_PAYCLAIM" 
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
<label id="ctl00_cntMainBody_lblOWNDCLAIM_IS_EFT" for="ctl00_cntMainBody_OWNDCLAIM__IS_EFT" class="col-md-4 col-sm-3 control-label">
		Check EFT Payment</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="OWNDCLAIM" 
		data-property-name="IS_EFT" 
		id="pb-container-checkbox-OWNDCLAIM-IS_EFT">	
		
		<asp:TextBox ID="OWNDCLAIM__IS_EFT" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valOWNDCLAIM_IS_EFT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Check EFT Payment"
			ClientValidationFunction="onValidate_OWNDCLAIM__IS_EFT" 
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
		if ($("#idf13dc4901085495ea1c431e48cd45c68 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idf13dc4901085495ea1c431e48cd45c68 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idf13dc4901085495ea1c431e48cd45c68 div ul li").each(function(){		  
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
			$("#idf13dc4901085495ea1c431e48cd45c68 div ul li").each(function(){		  
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
		styleString += "#idf13dc4901085495ea1c431e48cd45c68 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idf13dc4901085495ea1c431e48cd45c68 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf13dc4901085495ea1c431e48cd45c68 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf13dc4901085495ea1c431e48cd45c68 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idf13dc4901085495ea1c431e48cd45c68 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idf13dc4901085495ea1c431e48cd45c68 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idf13dc4901085495ea1c431e48cd45c68 input{text-align:left;}"; break;
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
<div id="frmPayment" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading34" runat="server" Text="Payment Detail" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="OWNDCLAIM" 
		data-property-name="PAYMENT_TYPE" 
		id="pb-container-list-OWNDCLAIM-PAYMENT_TYPE">
		<asp:Label ID="lblOWNDCLAIM_PAYMENT_TYPE" runat="server" AssociatedControlID="OWNDCLAIM__PAYMENT_TYPE" 
			Text="Payment Method" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__PAYMENT_TYPE" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLA_MEDIATYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__PAYMENT_TYPE(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_PAYMENT_TYPE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Payment Method"
			ClientValidationFunction="onValidate_OWNDCLAIM__PAYMENT_TYPE" 
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
		data-object-name="OWNDCLAIM" 
		data-property-name="PAYEE_TYPE" 
		id="pb-container-list-OWNDCLAIM-PAYEE_TYPE">
		<asp:Label ID="lblOWNDCLAIM_PAYEE_TYPE" runat="server" AssociatedControlID="OWNDCLAIM__PAYEE_TYPE" 
			Text="Payee Type" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__PAYEE_TYPE" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_COM_PAYEE_TYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__PAYEE_TYPE(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_PAYEE_TYPE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Payee Type"
			ClientValidationFunction="onValidate_OWNDCLAIM__PAYEE_TYPE" 
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="PARTYNAME" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-PARTYNAME">

		
		<asp:Label ID="lblOWNDCLAIM_PARTYNAME" runat="server" AssociatedControlID="OWNDCLAIM__PARTYNAME" 
			Text="Payee Name" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__PARTYNAME" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_PARTYNAME" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Payee Name"
					ClientValidationFunction="onValidate_OWNDCLAIM__PARTYNAME"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="CLIENT" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-CLIENT">

		
		<asp:Label ID="lblOWNDCLAIM_CLIENT" runat="server" AssociatedControlID="OWNDCLAIM__CLIENT" 
			Text="Client" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__CLIENT" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_CLIENT" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Client"
					ClientValidationFunction="onValidate_OWNDCLAIM__CLIENT"
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
								
								
										<!-- Party -->
 <div class="form-group form-group-sm">
	<span class="field-container" 
		data-field-type="Party" 
		data-object-name="OWNDCLAIM" 
		data-property-name="PARTY_NAME" 
		id="pb-container-party-OWNDCLAIM-PARTY_NAME"
	>
		<div id="ctl00_cntMainBody_OWNDCLAIM__PARTY_NAME">
			<NexusControl:FindParty ID="OWNDCLAIM__PARTY_NAME" ModalURL="Modal/FindOtherParty.aspx" runat="server" EnabledWriteOnly="True" TextToShow="Other Party" Type="ALL" />
		</div>
		
		<asp:CustomValidator ID="valOWNDCLAIM_PARTY_NAME" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for <!-- &LabelCaption -->"
			ClientValidationFunction="onValidate_OWNDCLAIM__PARTY_NAME"
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"
		/>
	</span>
	</div>
<!-- /Party -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="OWNDCLAIM" 
		data-property-name="BASEPARTYKEY" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-BASEPARTYKEY">

		
		<asp:Label ID="lblOWNDCLAIM_BASEPARTYKEY" runat="server" AssociatedControlID="OWNDCLAIM__BASEPARTYKEY" 
			Text="Key" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__BASEPARTYKEY" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_BASEPARTYKEY" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Key"
					ClientValidationFunction="onValidate_OWNDCLAIM__BASEPARTYKEY"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="PARTYKEY" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-PARTYKEY">

		
		<asp:Label ID="lblOWNDCLAIM_PARTYKEY" runat="server" AssociatedControlID="OWNDCLAIM__PARTYKEY" 
			Text="Party Key" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__PARTYKEY" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_PARTYKEY" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Party Key"
					ClientValidationFunction="onValidate_OWNDCLAIM__PARTYKEY"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="MEDIA_REF" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-MEDIA_REF">

		
		<asp:Label ID="lblOWNDCLAIM_MEDIA_REF" runat="server" AssociatedControlID="OWNDCLAIM__MEDIA_REF" 
			Text="Reference Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__MEDIA_REF" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_MEDIA_REF" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Reference Number"
					ClientValidationFunction="onValidate_OWNDCLAIM__MEDIA_REF"
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
		data-object-name="OWNDCLAIM" 
		data-property-name="PAID_AMOUNT" 
		id="pb-container-currency-OWNDCLAIM-PAID_AMOUNT">
		<asp:Label ID="lblOWNDCLAIM_PAID_AMOUNT" runat="server" AssociatedControlID="OWNDCLAIM__PAID_AMOUNT" 
			Text="Payment Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__PAID_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_PAID_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Payment Amount"
			ClientValidationFunction="onValidate_OWNDCLAIM__PAID_AMOUNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="OWNDCLAIM" 
		data-property-name="TAX_GROUP" 
		id="pb-container-list-OWNDCLAIM-TAX_GROUP">
		<asp:Label ID="lblOWNDCLAIM_TAX_GROUP" runat="server" AssociatedControlID="OWNDCLAIM__TAX_GROUP" 
			Text="Tax Group" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__TAX_GROUP" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLA_TAXGROUP" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__TAX_GROUP(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_TAX_GROUP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tax Group"
			ClientValidationFunction="onValidate_OWNDCLAIM__TAX_GROUP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="OWNDCLAIM" 
		data-property-name="TAX_AMOUNT" 
		id="pb-container-currency-OWNDCLAIM-TAX_AMOUNT">
		<asp:Label ID="lblOWNDCLAIM_TAX_AMOUNT" runat="server" AssociatedControlID="OWNDCLAIM__TAX_AMOUNT" 
			Text="Tax Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__TAX_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_TAX_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tax Amount"
			ClientValidationFunction="onValidate_OWNDCLAIM__TAX_AMOUNT" 
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
		data-object-name="OWNDCLAIM" 
		data-property-name="PAYMENT_AMOUNT" 
		id="pb-container-currency-OWNDCLAIM-PAYMENT_AMOUNT">
		<asp:Label ID="lblOWNDCLAIM_PAYMENT_AMOUNT" runat="server" AssociatedControlID="OWNDCLAIM__PAYMENT_AMOUNT" 
			Text="Net Payment" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__PAYMENT_AMOUNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_PAYMENT_AMOUNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Net Payment"
			ClientValidationFunction="onValidate_OWNDCLAIM__PAYMENT_AMOUNT" 
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
		data-object-name="OWNDCLAIM" 
		data-property-name="OUT_PAYMENT" 
		id="pb-container-currency-OWNDCLAIM-OUT_PAYMENT">
		<asp:Label ID="lblOWNDCLAIM_OUT_PAYMENT" runat="server" AssociatedControlID="OWNDCLAIM__OUT_PAYMENT" 
			Text="Outstanding Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__OUT_PAYMENT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_OUT_PAYMENT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Outstanding Amount"
			ClientValidationFunction="onValidate_OWNDCLAIM__OUT_PAYMENT" 
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
<label id="ctl00_cntMainBody_lblOWNDCLAIM_IS_EXGRATIA" for="ctl00_cntMainBody_OWNDCLAIM__IS_EXGRATIA" class="col-md-4 col-sm-3 control-label">
		Ex-Gratia</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="OWNDCLAIM" 
		data-property-name="IS_EXGRATIA" 
		id="pb-container-checkbox-OWNDCLAIM-IS_EXGRATIA">	
		
		<asp:TextBox ID="OWNDCLAIM__IS_EXGRATIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valOWNDCLAIM_IS_EXGRATIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Ex-Gratia"
			ClientValidationFunction="onValidate_OWNDCLAIM__IS_EXGRATIA" 
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
		if ($("#frmPayment div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmPayment div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmPayment div ul li").each(function(){		  
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
			$("#frmPayment div ul li").each(function(){		  
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
		styleString += "#frmPayment label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmPayment label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPayment label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPayment label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmPayment input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPayment input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPayment input{text-align:left;}"; break;
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
<div id="frmBankInfo" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading35" runat="server" Text="Banking Detail" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="OWNDCLAIM" 
		data-property-name="BANKLIST" 
		id="pb-container-list-OWNDCLAIM-BANKLIST">
		<asp:Label ID="lblOWNDCLAIM_BANKLIST" runat="server" AssociatedControlID="OWNDCLAIM__BANKLIST" 
			Text="Bank List" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__BANKLIST" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLA_BANKTYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__BANKLIST(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_BANKLIST" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Bank List"
			ClientValidationFunction="onValidate_OWNDCLAIM__BANKLIST" 
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
		data-object-name="OWNDCLAIM" 
		data-property-name="Account_Type" 
		id="pb-container-list-OWNDCLAIM-Account_Type">
		<asp:Label ID="lblOWNDCLAIM_Account_Type" runat="server" AssociatedControlID="OWNDCLAIM__Account_Type" 
			Text="Account Type" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="OWNDCLAIM__Account_Type" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_CLA_ACCTYPE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_OWNDCLAIM__Account_Type(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valOWNDCLAIM_Account_Type" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Account Type"
			ClientValidationFunction="onValidate_OWNDCLAIM__Account_Type" 
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Payee_Name" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Payee_Name">

		
		<asp:Label ID="lblOWNDCLAIM_Payee_Name" runat="server" AssociatedControlID="OWNDCLAIM__Payee_Name" 
			Text="Account Holder Name" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Payee_Name" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Payee_Name" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Account Holder Name"
					ClientValidationFunction="onValidate_OWNDCLAIM__Payee_Name"
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
		data-object-name="OWNDCLAIM" 
		data-property-name="Payment_Date" 
		id="pb-container-datejquerycompatible-OWNDCLAIM-Payment_Date">
		<asp:Label ID="lblOWNDCLAIM_Payment_Date" runat="server" AssociatedControlID="OWNDCLAIM__Payment_Date" 
			Text="Payment Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="OWNDCLAIM__Payment_Date" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calOWNDCLAIM__Payment_Date" runat="server" LinkedControl="OWNDCLAIM__Payment_Date" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valOWNDCLAIM_Payment_Date" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Payment Date"
			ClientValidationFunction="onValidate_OWNDCLAIM__Payment_Date" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
	</span>
</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Bank_Name" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Bank_Name">

		
		<asp:Label ID="lblOWNDCLAIM_Bank_Name" runat="server" AssociatedControlID="OWNDCLAIM__Bank_Name" 
			Text="Bank Name" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Bank_Name" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Bank_Name" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Bank Name"
					ClientValidationFunction="onValidate_OWNDCLAIM__Bank_Name"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Branch_Code" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Branch_Code">

		
		<asp:Label ID="lblOWNDCLAIM_Branch_Code" runat="server" AssociatedControlID="OWNDCLAIM__Branch_Code" 
			Text="Branch Code" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Branch_Code" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Branch_Code" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Branch Code"
					ClientValidationFunction="onValidate_OWNDCLAIM__Branch_Code"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Bank_Account_No" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Bank_Account_No">

		
		<asp:Label ID="lblOWNDCLAIM_Bank_Account_No" runat="server" AssociatedControlID="OWNDCLAIM__Bank_Account_No" 
			Text="Bank Account Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Bank_Account_No" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Bank_Account_No" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Bank Account Number"
					ClientValidationFunction="onValidate_OWNDCLAIM__Bank_Account_No"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Their_Ref" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Their_Ref">

		
		<asp:Label ID="lblOWNDCLAIM_Their_Ref" runat="server" AssociatedControlID="OWNDCLAIM__Their_Ref" 
			Text="Their Reference" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Their_Ref" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Their_Ref" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Their Reference"
					ClientValidationFunction="onValidate_OWNDCLAIM__Their_Ref"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="Our_Ref" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-Our_Ref">

		
		<asp:Label ID="lblOWNDCLAIM_Our_Ref" runat="server" AssociatedControlID="OWNDCLAIM__Our_Ref" 
			Text="Our Reference" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__Our_Ref" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_Our_Ref" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Our Reference"
					ClientValidationFunction="onValidate_OWNDCLAIM__Our_Ref"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="BIC" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-BIC">

		
		<asp:Label ID="lblOWNDCLAIM_BIC" runat="server" AssociatedControlID="OWNDCLAIM__BIC" 
			Text="BIC" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__BIC" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_BIC" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for BIC"
					ClientValidationFunction="onValidate_OWNDCLAIM__BIC"
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
		
		data-object-name="OWNDCLAIM" 
		data-property-name="IBAN" 
		 
		
		 
		id="pb-container-text-OWNDCLAIM-IBAN">

		
		<asp:Label ID="lblOWNDCLAIM_IBAN" runat="server" AssociatedControlID="OWNDCLAIM__IBAN" 
			Text="IBAN" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="OWNDCLAIM__IBAN" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valOWNDCLAIM_IBAN" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for IBAN"
					ClientValidationFunction="onValidate_OWNDCLAIM__IBAN"
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
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="OWNDCLAIM" 
		data-property-name="Comments" 
		id="pb-container-comment-OWNDCLAIM-Comments">
		<asp:Label ID="lblOWNDCLAIM_Comments" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="OWNDCLAIM__Comments" 
			Text="Comments"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="OWNDCLAIM__Comments" runat="server" />
		
		<asp:CustomValidator ID="valOWNDCLAIM_Comments" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Comments"
			ClientValidationFunction="onValidate_OWNDCLAIM__Comments"
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
		data-object-name="OWNDCLAIM" 
		data-property-name="TOTAL_PAID" 
		id="pb-container-currency-OWNDCLAIM-TOTAL_PAID">
		<asp:Label ID="lblOWNDCLAIM_TOTAL_PAID" runat="server" AssociatedControlID="OWNDCLAIM__TOTAL_PAID" 
			Text="Total Paid" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="OWNDCLAIM__TOTAL_PAID" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valOWNDCLAIM_TOTAL_PAID" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Paid"
			ClientValidationFunction="onValidate_OWNDCLAIM__TOTAL_PAID" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
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
		if ($("#frmBankInfo div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmBankInfo div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmBankInfo div ul li").each(function(){		  
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
			$("#frmBankInfo div ul li").each(function(){		  
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
		styleString += "#frmBankInfo label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmBankInfo label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmBankInfo label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmBankInfo label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmBankInfo input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmBankInfo input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmBankInfo input{text-align:left;}"; break;
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