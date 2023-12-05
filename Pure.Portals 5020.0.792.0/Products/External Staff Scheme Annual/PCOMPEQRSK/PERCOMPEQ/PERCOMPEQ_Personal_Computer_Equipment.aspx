<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="PERCOMPEQ_Personal_Computer_Equipment.aspx.vb" Inherits="Nexus.PB2_PERCOMPEQ_Personal_Computer_Equipment" %>

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
function onValidate_COMPEQ_DET__COUNT_ID(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "COUNT_ID", "Text");
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
        			var field = Field.getInstance("COMPEQ_DET", "COUNT_ID");
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
function onValidate_COMPEQ_DET__CATEGORY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "CATEGORY", "List");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "CATEGORY");
        		var errorMessage = "Category Code is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.CATEGORY");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "CATEGORY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_CATEGORY");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__CATEGORY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__CATEGORY_lblFindParty");
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
         * @fileoverview
         * LoadDefaultsFromUDLToProperties
         */
        //Format used on PB2 HandleDynamicPost:{UDLNAME}{Object.Property,UDL_Columnname}{Object.Property,UDL_Columnname}
         //Cater for different property types
        
        $(document).ready(function () {
            var listInstance = Field.getInstance("COMPEQ_DET", "CATEGORY");
        		
            events.listen(listInstance, "change", function(e){		
                var COMPEQ_DET__CATEGORY_Value = listInstance.getValue();
        		var code = listInstance.getCode();
        		
                if (listInstance.getType() == "list")
                {
                    if (COMPEQ_DET__CATEGORY_Value != "" || COMPEQ_DET__CATEGORY_Value != null) {
                        __doPostBack('<%=asyncPanel.ClientID%>', 'PopulateDefaults_COMPEQ_DET_CATEGORY' + ',' + "CATEGORY" + ',' + code);
                    }
                }
                
        	}, false, this);
        });
}
function onValidate_COMPEQ_DET__COVER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "COVER", "Date");
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
        			var field = Field.getInstance("COMPEQ_DET", "COVER");
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
function onValidate_COMPEQ_DET__CATEGORY_CODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "CATEGORY_CODE", "Text");
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
        			var field = Field.getInstance("COMPEQ_DET", "CATEGORY_CODE");
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
        		var field = Field.getWithQuery("type=Text&objectName=COMPEQ_DET&propertyName=CATEGORY_CODE&name={name}");
        		
        		var value = new Expression("Code(COMPEQ_DET.CATEGORY)"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_COMPEQ_DET__DESCRIPTION(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "DESCRIPTION", "Comment");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "DESCRIPTION");
        		var errorMessage = "Description is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.DESCRIPTION");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "DESCRIPTION");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_DESCRIPTION");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__DESCRIPTION');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__DESCRIPTION_lblFindParty");
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
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","DESCRIPTION");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_COMPEQ_DET__SUMINSURED(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "SUMINSURED", "Currency");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "SUMINSURED");
        		var errorMessage = "Personal Computer Sum Insured is mandatory and an amount must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.SUMINSURED");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "SUMINSURED");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_SUMINSURED");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__SUMINSURED');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__SUMINSURED_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('COMPEQ_DET', 'SUMINSURED');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=COMPEQ_DET&propertyName=SUMINSURED&name={name}");
        		
        		var value = new Expression("COMPEQ_DET.MINSI"), 
        			condition = (Expression.isValidParameter("COMPEQ_DET.SUMINSURED <  COMPEQ_DET.MINSI")) ? new Expression("COMPEQ_DET.SUMINSURED <  COMPEQ_DET.MINSI") : null, 
        			elseValue = (Expression.isValidParameter("COMPEQ_DET.SUMINSURED")) ? new Expression("COMPEQ_DET.SUMINSURED") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_COMPEQ_DET__MINSI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "MINSI", "Currency");
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
        			var field = Field.getInstance("COMPEQ_DET", "MINSI");
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
function onValidate_COMPEQ_DET__MAXSI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "MAXSI", "Currency");
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
        			var field = Field.getInstance("COMPEQ_DET", "MAXSI");
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
function onValidate_COMPEQ_DET__YEARMAN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "YEARMAN", "Integer");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "YEARMAN");
        		var errorMessage = "Year of manufacture is mandatory and a date must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.YEARMAN");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "YEARMAN");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_YEARMAN");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__YEARMAN');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__YEARMAN_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('COMPEQ_DET', 'YEARMAN');
        			
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
         * @fileoverview SetFormat, Set the formatting of a field
         * @param {string} firstParam Takes the format pattern the field should be displayed in
         * SetFormat
         */
        (function(){
        	
        	if (isOnLoad) {	
        		var field = Field.getInstance("COMPEQ_DET", "YEARMAN");
        		
        		
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
        			return field.setFormatPattern("0000", optionalInputPatterns);
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
        			formatter.setCustomFormatPattern("0000");
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
        			var message = (Expression.isValidParameter("Age of item exceeds maximum age allowed")) ? "Age of item exceeds maximum age allowed" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "__" + "YEARMAN");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "_" + "YEARMAN");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("COMPEQ_DET.AGE <= COMPEQ_DET.MAXAGE");
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
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Invalid Year of Manufacture")) ? "Invalid Year of Manufacture" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "__" + "YEARMAN");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "_" + "YEARMAN");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("COMPEQ_DET.YEARMAN <= (GetYear(COMPEQ_DET.COVER))");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_COMPEQ_DET__AGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "AGE", "Integer");
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
        			var field = Field.getInstance("COMPEQ_DET", "AGE");
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
        		var field = Field.getWithQuery("type=Integer&objectName=COMPEQ_DET&propertyName=AGE&name={name}");
        		
        		var value = new Expression("GetYear(COMPEQ_DET.COVER) - COMPEQ_DET.YEARMAN"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_COMPEQ_DET__MAXAGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "MAXAGE", "Integer");
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
        			var field = Field.getInstance("COMPEQ_DET", "MAXAGE");
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
function onValidate_COMPEQ_DET__EXCESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "EXCESS", "Currency");
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "EXCESS");
        		var errorMessage = "Excess is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.EXCESS");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "EXCESS");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_EXCESS");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__EXCESS');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__EXCESS_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('COMPEQ_DET', 'EXCESS');
        			
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
        		var field = Field.getWithQuery("type=Currency&objectName=COMPEQ_DET&propertyName=EXCESS&name={name}");
        		
        		var value = new Expression("COMPEQ_DET.MINEXCESS"), 
        			condition = (Expression.isValidParameter("COMPEQ_DET.EXCESS < COMPEQ_DET.MINEXCESS")) ? new Expression("COMPEQ_DET.EXCESS < COMPEQ_DET.MINEXCESS") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_COMPEQ_DET__MINEXCESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "MINEXCESS", "Currency");
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
        			var field = Field.getInstance("COMPEQ_DET", "MINEXCESS");
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
function onValidate_COMPEQ_DET__REINDATA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "REINDATA", "Checkbox");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_REINDATA");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__REINDATA');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__REINDATA_lblFindParty");
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
function onValidate_COMPEQ_DET__COMPATIB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "COMPATIB", "Checkbox");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_COMPATIB");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__COMPATIB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__COMPATIB_lblFindParty");
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
function onValidate_COMPEQ_DET__INTPARTY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "INTPARTY", "Comment");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.INTPARTY");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "INTPARTY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_INTPARTY");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__INTPARTY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__INTPARTY_lblFindParty");
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
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","INTPARTY");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "INTPARTY");
        		var exp = new Expression("COMPEQ_DET.INTDATE != null ");
        		var errorMessage = "Name must be entered if Date is entered";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
        })();
}
function onValidate_COMPEQ_DET__INTDATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "INTDATE", "Date");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.INTDATE");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "INTDATE");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_INTDATE");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__INTDATE');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__INTDATE_lblFindParty");
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
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "INTDATE");
        		var exp = new Expression("COMPEQ_DET.INTPARTY  != ''  ");
        		var errorMessage = "Date must be entered if Name is entered ";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Date can't be less than the original Inception date of the Policy")) ? "Date can't be less than the original Inception date of the Policy" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "__" + "INTDATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "_" + "INTDATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(COMPEQ_DET.INTDATE >= COMPEQ_DET.COVER) OR (COMPEQ_DET.INTDATE = null)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","INTDATE");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_COMPEQ_DET__INDICATOR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "INDICATOR", "RateList");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.INDICATOR");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "INDICATOR");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_INDICATOR");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__INDICATOR');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__INDICATOR_lblFindParty");
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
function onValidate_COMPEQ_DET__IND_CODE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "IND_CODE", "Text");
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
        			var field = Field.getInstance("COMPEQ_DET", "IND_CODE");
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
        		var field = Field.getWithQuery("type=Text&objectName=COMPEQ_DET&propertyName=IND_CODE&name={name}");
        		
        		var value = new Expression("Code(COMPEQ_DET.INDICATOR)"), 
        			condition = (Expression.isValidParameter("{1}")) ? new Expression("{1}") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_COMPEQ_DET__INDICATOR_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "INDICATOR_PERC", "Percentage");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "INDICATOR_PERC");
        		var exp = new Expression("COMPEQ_DET.INDICATOR <> '' AND COMPEQ_DET.REASON <> ''");
        		var errorMessage = "Percentage must be entered if indicator and reason is selected";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.INDICATOR_PERC");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "INDICATOR_PERC");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_INDICATOR_PERC");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__INDICATOR_PERC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__INDICATOR_PERC_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('COMPEQ_DET', 'INDICATOR_PERC');
        			
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
         * @fileoverview Sets the default format for all percentage fields.
         * SetPercentageFormat
         */
        (function(){
            if (isOnLoad) {    
                window["PercentageFormat"] = "0.00#";
        		// Refresh all formatting fields
        		pb.formatting.Base.refresh();
            }
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Percentage&objectName=COMPEQ_DET&propertyName=INDICATOR_PERC&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("COMPEQ_DET.INDICATOR =''")) ? new Expression("COMPEQ_DET.INDICATOR =''") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        
        (()=>{
        
                $('#<%= COMPEQ_DET__INDICATOR_PERC.ClientID %>').bind("keypress",function(e){
                        
                    if (e.which == 45) 
        			{
                        return false;
                    }
                      
                });
        		
        		//-----
        		if (isOnLoad) {		
        			var field = Field.getInstance("COMPEQ_DET", "INDICATOR_PERC");
        			var update = function(){
        				if (field.getValue() == 0) {
        					if (field.setValueInternal){
        						// Do not trigger change events.
        						field.setValueInternal('');
        					} else { 
        						field.setValue('');
        					}
        				}
        				events.listenOnce(field, "change", update);
        			};
        			update();
        		};
        		//-----
        })();
        
}
function onValidate_COMPEQ_DET__REASON(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "REASON", "RateList");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.REASON");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "REASON");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_REASON");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__REASON');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__REASON_lblFindParty");
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
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("COMPEQ_DET", "REASON");
        		var exp = new Expression("COMPEQ_DET.INDICATOR <> '' AND COMPEQ_DET.INDICATOR_PERC > 0");
        		var errorMessage = "Reason must be selected if indicator and percentage is entered";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Loading/discount and percentage must be entered")) ? "Loading/discount and percentage must be entered" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "__" + "REASON");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "_" + "REASON");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(COMPEQ_DET.INDICATOR <> '' AND COMPEQ_DET.INDICATOR_PERC > 0 AND COMPEQ_DET.REASON <>'') OR (COMPEQ_DET.INDICATOR == '' AND COMPEQ_DET.INDICATOR_PERC == null AND COMPEQ_DET.REASON =='')");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=RateList&objectName=COMPEQ_DET&propertyName=REASON&name={name}");
        		
        		var value = new Expression("''"), 
        			condition = (Expression.isValidParameter("COMPEQ_DET.INDICATOR =''")) ? new Expression("COMPEQ_DET.INDICATOR =''") : null, 
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
        			var message = (Expression.isValidParameter("Discount % is more than allowed")) ? "Discount % is more than allowed" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "__" + "REASON");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "COMPEQ_DET".toUpperCase() + "_" + "REASON");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(Code(COMPEQ_DET.INDICATOR) == 'D' AND COMPEQ_DET.INDICATOR_PERC <= GENERAL.DISCSANC) OR (COMPEQ_DET.INDICATOR == '') OR (Code(COMPEQ_DET.INDICATOR) == 'L')");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","REASON");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","REASON");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_COMPEQ_DET__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "PREMIUM", "Currency");
        })();
        /**
         * @fileoverview
         * Read Only, make the field Read Only
         */
        (function(){
        	
        	var field = Field.getInstance("COMPEQ_DET", "PREMIUM");
        	field.setReadOnly(true);
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("COMPEQ_DET.PREMIUM");
        			window.setControlWidth(field, "0.7", "COMPEQ_DET", "PREMIUM");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCOMPEQ_DET_PREMIUM");
        			    var ele = document.getElementById('ctl00_cntMainBody_COMPEQ_DET__PREMIUM');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_COMPEQ_DET__PREMIUM_lblFindParty");
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
         * Set the field width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var field = Field.getInstance('COMPEQ_DET', 'PREMIUM');
        			
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
        $(document).ready(function() {
        	
        	var List = Field.getInstance("COMPEQ_DET", "CATEGORY");
        	var thisField = Field.getInstance("COMPEQ_DET","PREMIUM");
        	
        	events.listen(List, "change", function(e)
        	{
        		if (thisField.getType() == "checkbox")
        		{
        			thisField.setValue('0');
        		}
        		else
        		{
        			thisField.setValue('');
        		}
        	}, false, this);
        });
}
function onValidate_COMPEQ_DET__LSPSURGE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "LSPSURGE", "Percentage");
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
        			var field = Field.getInstance("COMPEQ_DET", "LSPSURGE");
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
function onValidate_COMPEQ_DET__LSPSURGEAM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMPEQ_DET", "LSPSURGEAM", "Integer");
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
        			var field = Field.getInstance("COMPEQ_DET", "LSPSURGEAM");
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
    onValidate_COMPEQ_DET__COUNT_ID(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__CATEGORY(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__COVER(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__CATEGORY_CODE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__DESCRIPTION(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__SUMINSURED(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__MINSI(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__MAXSI(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__YEARMAN(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__AGE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__MAXAGE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__EXCESS(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__MINEXCESS(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__REINDATA(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__COMPATIB(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__INTPARTY(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__INTDATE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__INDICATOR(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__IND_CODE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__INDICATOR_PERC(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__REASON(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__PREMIUM(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__LSPSURGE(null, null, null, isOnLoad);
    onValidate_COMPEQ_DET__LSPSURGEAM(null, null, null, isOnLoad);
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
<div id="idadb89ea86a044401a5d0d7e855c95e9a" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id4c0d1c95414e45a59404831a5662b247" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading7" runat="server" Text="Equipment Details " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="COMPEQ_DET" 
		data-property-name="COUNT_ID" 
		 
		
		 
		id="pb-container-text-COMPEQ_DET-COUNT_ID">

		
		<asp:Label ID="lblCOMPEQ_DET_COUNT_ID" runat="server" AssociatedControlID="COMPEQ_DET__COUNT_ID" 
			Text="Item Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="COMPEQ_DET__COUNT_ID" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCOMPEQ_DET_COUNT_ID" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Item Number"
					ClientValidationFunction="onValidate_COMPEQ_DET__COUNT_ID"
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
		data-object-name="COMPEQ_DET" 
		data-property-name="CATEGORY" 
		id="pb-container-list-COMPEQ_DET-CATEGORY">
		<asp:Label ID="lblCOMPEQ_DET_CATEGORY" runat="server" AssociatedControlID="COMPEQ_DET__CATEGORY" 
			Text="Category " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="COMPEQ_DET__CATEGORY" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_PCEQRITEM" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_COMPEQ_DET__CATEGORY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCOMPEQ_DET_CATEGORY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Category "
			ClientValidationFunction="onValidate_COMPEQ_DET__CATEGORY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="COMPEQ_DET" 
		data-property-name="COVER" 
		id="pb-container-datejquerycompatible-COMPEQ_DET-COVER">
		<asp:Label ID="lblCOMPEQ_DET_COVER" runat="server" AssociatedControlID="COMPEQ_DET__COVER" 
			Text="Cover start date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="COMPEQ_DET__COVER" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calCOMPEQ_DET__COVER" runat="server" LinkedControl="COMPEQ_DET__COVER" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valCOMPEQ_DET_COVER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Cover start date"
			ClientValidationFunction="onValidate_COMPEQ_DET__COVER" 
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
		
		data-object-name="COMPEQ_DET" 
		data-property-name="CATEGORY_CODE" 
		 
		
		 
		id="pb-container-text-COMPEQ_DET-CATEGORY_CODE">

		
		<asp:Label ID="lblCOMPEQ_DET_CATEGORY_CODE" runat="server" AssociatedControlID="COMPEQ_DET__CATEGORY_CODE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="COMPEQ_DET__CATEGORY_CODE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCOMPEQ_DET_CATEGORY_CODE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for COMPEQ_DET.CATEGORY_CODE"
					ClientValidationFunction="onValidate_COMPEQ_DET__CATEGORY_CODE"
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
		data-object-name="COMPEQ_DET" 
		data-property-name="DESCRIPTION" 
		id="pb-container-comment-COMPEQ_DET-DESCRIPTION">
		<asp:Label ID="lblCOMPEQ_DET_DESCRIPTION" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="COMPEQ_DET__DESCRIPTION" 
			Text="Description"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="COMPEQ_DET__DESCRIPTION" runat="server" />
		
		<asp:CustomValidator ID="valCOMPEQ_DET_DESCRIPTION" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Description"
			ClientValidationFunction="onValidate_COMPEQ_DET__DESCRIPTION"
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
		data-object-name="COMPEQ_DET" 
		data-property-name="SUMINSURED" 
		id="pb-container-currency-COMPEQ_DET-SUMINSURED">
		<asp:Label ID="lblCOMPEQ_DET_SUMINSURED" runat="server" AssociatedControlID="COMPEQ_DET__SUMINSURED" 
			Text="Sum Insured" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__SUMINSURED" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_SUMINSURED" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Sum Insured"
			ClientValidationFunction="onValidate_COMPEQ_DET__SUMINSURED" 
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
		data-object-name="COMPEQ_DET" 
		data-property-name="MINSI" 
		id="pb-container-currency-COMPEQ_DET-MINSI">
		<asp:Label ID="lblCOMPEQ_DET_MINSI" runat="server" AssociatedControlID="COMPEQ_DET__MINSI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__MINSI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_MINSI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMPEQ_DET.MINSI"
			ClientValidationFunction="onValidate_COMPEQ_DET__MINSI" 
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
		data-object-name="COMPEQ_DET" 
		data-property-name="MAXSI" 
		id="pb-container-currency-COMPEQ_DET-MAXSI">
		<asp:Label ID="lblCOMPEQ_DET_MAXSI" runat="server" AssociatedControlID="COMPEQ_DET__MAXSI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__MAXSI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_MAXSI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMPEQ_DET.MAXSI"
			ClientValidationFunction="onValidate_COMPEQ_DET__MAXSI" 
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
		data-object-name="COMPEQ_DET" 
		data-property-name="YEARMAN" 
		id="pb-container-integer-COMPEQ_DET-YEARMAN">
		<asp:Label ID="lblCOMPEQ_DET_YEARMAN" runat="server" AssociatedControlID="COMPEQ_DET__YEARMAN" 
			Text="Year of Manufacture" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="COMPEQ_DET__YEARMAN" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCOMPEQ_DET_YEARMAN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Year of Manufacture"
			ClientValidationFunction="onValidate_COMPEQ_DET__YEARMAN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="COMPEQ_DET" 
		data-property-name="AGE" 
		id="pb-container-integer-COMPEQ_DET-AGE">
		<asp:Label ID="lblCOMPEQ_DET_AGE" runat="server" AssociatedControlID="COMPEQ_DET__AGE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="COMPEQ_DET__AGE" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCOMPEQ_DET_AGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMPEQ_DET.AGE"
			ClientValidationFunction="onValidate_COMPEQ_DET__AGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="COMPEQ_DET" 
		data-property-name="MAXAGE" 
		id="pb-container-integer-COMPEQ_DET-MAXAGE">
		<asp:Label ID="lblCOMPEQ_DET_MAXAGE" runat="server" AssociatedControlID="COMPEQ_DET__MAXAGE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="COMPEQ_DET__MAXAGE" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCOMPEQ_DET_MAXAGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMPEQ_DET.MAXAGE"
			ClientValidationFunction="onValidate_COMPEQ_DET__MAXAGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="COMPEQ_DET" 
		data-property-name="EXCESS" 
		id="pb-container-currency-COMPEQ_DET-EXCESS">
		<asp:Label ID="lblCOMPEQ_DET_EXCESS" runat="server" AssociatedControlID="COMPEQ_DET__EXCESS" 
			Text="Excess" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__EXCESS" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_EXCESS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Excess"
			ClientValidationFunction="onValidate_COMPEQ_DET__EXCESS" 
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
		data-object-name="COMPEQ_DET" 
		data-property-name="MINEXCESS" 
		id="pb-container-currency-COMPEQ_DET-MINEXCESS">
		<asp:Label ID="lblCOMPEQ_DET_MINEXCESS" runat="server" AssociatedControlID="COMPEQ_DET__MINEXCESS" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__MINEXCESS" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_MINEXCESS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMPEQ_DET.MINEXCESS"
			ClientValidationFunction="onValidate_COMPEQ_DET__MINEXCESS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label0">
		<span class="label" id="label0"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblCOMPEQ_DET_REINDATA" for="ctl00_cntMainBody_COMPEQ_DET__REINDATA" class="col-md-4 col-sm-3 control-label">
		Reinstatement of Data</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="COMPEQ_DET" 
		data-property-name="REINDATA" 
		id="pb-container-checkbox-COMPEQ_DET-REINDATA">	
		
		<asp:TextBox ID="COMPEQ_DET__REINDATA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCOMPEQ_DET_REINDATA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Reinstatement of Data"
			ClientValidationFunction="onValidate_COMPEQ_DET__REINDATA" 
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
<label id="ctl00_cntMainBody_lblCOMPEQ_DET_COMPATIB" for="ctl00_cntMainBody_COMPEQ_DET__COMPATIB" class="col-md-4 col-sm-3 control-label">
		Compatibility</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="COMPEQ_DET" 
		data-property-name="COMPATIB" 
		id="pb-container-checkbox-COMPEQ_DET-COMPATIB">	
		
		<asp:TextBox ID="COMPEQ_DET__COMPATIB" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCOMPEQ_DET_COMPATIB" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Compatibility"
			ClientValidationFunction="onValidate_COMPEQ_DET__COMPATIB" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
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
		if ($("#id4c0d1c95414e45a59404831a5662b247 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4c0d1c95414e45a59404831a5662b247 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4c0d1c95414e45a59404831a5662b247 div ul li").each(function(){		  
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
			$("#id4c0d1c95414e45a59404831a5662b247 div ul li").each(function(){		  
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
		styleString += "#id4c0d1c95414e45a59404831a5662b247 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4c0d1c95414e45a59404831a5662b247 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c0d1c95414e45a59404831a5662b247 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c0d1c95414e45a59404831a5662b247 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4c0d1c95414e45a59404831a5662b247 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4c0d1c95414e45a59404831a5662b247 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4c0d1c95414e45a59404831a5662b247 input{text-align:left;}"; break;
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
<div id="id95ea891a70bf4fe89d83e46b59b760ca" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading8" runat="server" Text="Interest Party" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Comment -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Comment" 
		data-object-name="COMPEQ_DET" 
		data-property-name="INTPARTY" 
		id="pb-container-comment-COMPEQ_DET-INTPARTY">
		<asp:Label ID="lblCOMPEQ_DET_INTPARTY" runat="server" class="col-md-4 col-sm-3 control-label" AssociatedControlID="COMPEQ_DET__INTPARTY" 
			Text="Name"></asp:Label>
		
		 <div class="col-md-8 col-sm-9">
	        <asp:HiddenField ID="COMPEQ_DET__INTPARTY" runat="server" />
		
		<asp:CustomValidator ID="valCOMPEQ_DET_INTPARTY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Name"
			ClientValidationFunction="onValidate_COMPEQ_DET__INTPARTY"
			ValidationGroup="" 
			Display="None"
			EnableClientScript="true"/>
         </div>
		
	
	</span>
	
</div>
<!-- /Comment -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->
 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="COMPEQ_DET" 
		data-property-name="INTDATE" 
		id="pb-container-datejquerycompatible-COMPEQ_DET-INTDATE">
		<asp:Label ID="lblCOMPEQ_DET_INTDATE" runat="server" AssociatedControlID="COMPEQ_DET__INTDATE" 
			Text="Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
				<asp:TextBox ID="COMPEQ_DET__INTDATE" runat="server" CssClass="form-control" data-type="Date" />
				<uc1:CalendarLookup ID="calCOMPEQ_DET__INTDATE" runat="server" LinkedControl="COMPEQ_DET__INTDATE" HLevel="1" />
		     </div>
			 <asp:CustomValidator ID="valCOMPEQ_DET_INTDATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Date"
			ClientValidationFunction="onValidate_COMPEQ_DET__INTDATE" 
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
		if ($("#id95ea891a70bf4fe89d83e46b59b760ca div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id95ea891a70bf4fe89d83e46b59b760ca div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id95ea891a70bf4fe89d83e46b59b760ca div ul li").each(function(){		  
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
			$("#id95ea891a70bf4fe89d83e46b59b760ca div ul li").each(function(){		  
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
		styleString += "#id95ea891a70bf4fe89d83e46b59b760ca label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id95ea891a70bf4fe89d83e46b59b760ca label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id95ea891a70bf4fe89d83e46b59b760ca label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id95ea891a70bf4fe89d83e46b59b760ca label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id95ea891a70bf4fe89d83e46b59b760ca input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id95ea891a70bf4fe89d83e46b59b760ca input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id95ea891a70bf4fe89d83e46b59b760ca input{text-align:left;}"; break;
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
<div id="id0b2b575b30844d83a44bcdbd3d1ee8c7" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading9" runat="server" Text="Premium Load/Discount" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="COMPEQ_DET" 
		data-property-name="INDICATOR" 
		id="pb-container-list-COMPEQ_DET-INDICATOR">
		<asp:Label ID="lblCOMPEQ_DET_INDICATOR" runat="server" AssociatedControlID="COMPEQ_DET__INDICATOR" 
			Text="Indicator" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="COMPEQ_DET__INDICATOR" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="LOADDIND" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_COMPEQ_DET__INDICATOR(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCOMPEQ_DET_INDICATOR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Indicator"
			ClientValidationFunction="onValidate_COMPEQ_DET__INDICATOR" 
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
		
		data-object-name="COMPEQ_DET" 
		data-property-name="IND_CODE" 
		 
		
		 
		id="pb-container-text-COMPEQ_DET-IND_CODE">

		
		<asp:Label ID="lblCOMPEQ_DET_IND_CODE" runat="server" AssociatedControlID="COMPEQ_DET__IND_CODE" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="COMPEQ_DET__IND_CODE" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCOMPEQ_DET_IND_CODE" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for COMPEQ_DET.IND_CODE"
					ClientValidationFunction="onValidate_COMPEQ_DET__IND_CODE"
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
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="COMPEQ_DET" 
		data-property-name="INDICATOR_PERC" 
		id="pb-container-percentage-COMPEQ_DET-INDICATOR_PERC">
		<asp:Label ID="lblCOMPEQ_DET_INDICATOR_PERC" runat="server" AssociatedControlID="COMPEQ_DET__INDICATOR_PERC" 
			Text="Percentage" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="COMPEQ_DET__INDICATOR_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_INDICATOR_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Percentage"
			ClientValidationFunction="onValidate_COMPEQ_DET__INDICATOR_PERC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="COMPEQ_DET" 
		data-property-name="REASON" 
		id="pb-container-list-COMPEQ_DET-REASON">
		<asp:Label ID="lblCOMPEQ_DET_REASON" runat="server" AssociatedControlID="COMPEQ_DET__REASON" 
			Text="Reason" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="COMPEQ_DET__REASON" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="LOADDISC" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_COMPEQ_DET__REASON(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCOMPEQ_DET_REASON" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Reason"
			ClientValidationFunction="onValidate_COMPEQ_DET__REASON" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
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
		if ($("#id0b2b575b30844d83a44bcdbd3d1ee8c7 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id0b2b575b30844d83a44bcdbd3d1ee8c7 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id0b2b575b30844d83a44bcdbd3d1ee8c7 div ul li").each(function(){		  
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
			$("#id0b2b575b30844d83a44bcdbd3d1ee8c7 div ul li").each(function(){		  
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
		styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id0b2b575b30844d83a44bcdbd3d1ee8c7 input{text-align:left;}"; break;
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
<div id="frmPremium" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading10" runat="server" Text="Premium" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="COMPEQ_DET" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-COMPEQ_DET-PREMIUM">
		<asp:Label ID="lblCOMPEQ_DET_PREMIUM" runat="server" AssociatedControlID="COMPEQ_DET__PREMIUM" 
			Text="Total Premium" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMPEQ_DET__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Total Premium"
			ClientValidationFunction="onValidate_COMPEQ_DET__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="COMPEQ_DET" 
		data-property-name="LSPSURGE" 
		id="pb-container-percentage-COMPEQ_DET-LSPSURGE">
		<asp:Label ID="lblCOMPEQ_DET_LSPSURGE" runat="server" AssociatedControlID="COMPEQ_DET__LSPSURGE" 
			Text="Percent " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="COMPEQ_DET__LSPSURGE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valCOMPEQ_DET_LSPSURGE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Percent "
			ClientValidationFunction="onValidate_COMPEQ_DET__LSPSURGE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="COMPEQ_DET" 
		data-property-name="LSPSURGEAM" 
		id="pb-container-integer-COMPEQ_DET-LSPSURGEAM">
		<asp:Label ID="lblCOMPEQ_DET_LSPSURGEAM" runat="server" AssociatedControlID="COMPEQ_DET__LSPSURGEAM" 
			Text="Amount" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="COMPEQ_DET__LSPSURGEAM" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCOMPEQ_DET_LSPSURGEAM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Amount"
			ClientValidationFunction="onValidate_COMPEQ_DET__LSPSURGEAM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										

<!-- Button -->
    <asp:Button ID="btnPremiumCalculate" runat="server" Text="Calculate Premium" CssClass="btn btn-sm btn-primary" OnClientClick="clearCookieScrollPos()"/>
	<script type="text/javascript">
		if (window.rulesDisabled){
			document.getElementById('btnPremiumCalculate').style.display = "none";		
		} 
	</script>
<!-- /Button -->



								
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
		if ($("#frmPremium div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmPremium div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmPremium div ul li").each(function(){		  
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
			$("#frmPremium div ul li").each(function(){		  
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
		styleString += "#frmPremium label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmPremium label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPremium label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPremium label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmPremium input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmPremium input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmPremium input{text-align:left;}"; break;
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