<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MMFLEET_Extensions.aspx.vb" Inherits="Nexus.PB2_MMFLEET_Extensions" %>

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
function onValidate_COMM__COMM_WIND(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMM", "COMM_WIND", "Checkbox");
        })();
}
function onValidate_COMM__FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMM", "FAP_PER", "Percentage");
        })();
}
function onValidate_COMM__FAP_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "COMM", "FAP_AMT", "Currency");
        })();
}
function onValidate_LOSS__LOSS_KEYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "LOSS_KEYS", "Checkbox");
        })();
}
function onValidate_LOSS__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "LIMIT", "Currency");
        })();
}
function onValidate_LOSS__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "PREMIUM", "Currency");
        })();
}
function onValidate_LOSS__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "POST_PREM", "Currency");
        })();
}
function onValidate_LOSS__FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "FAP_PER", "Percentage");
        })();
}
function onValidate_LOSS__FAP_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS", "FAP_AMT", "Currency");
        })();
}
function onValidate_RIOT__RIOT_CHK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RIOT", "RIOT_CHK", "Checkbox");
        })();
}
function onValidate_RIOT__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RIOT", "PREMIUM", "Currency");
        })();
}
function onValidate_RIOT__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "RIOT", "POST_PREM", "Currency");
        })();
}
function onValidate_WRECK__WRECK(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WRECK", "WRECK", "Checkbox");
        })();
}
function onValidate_WRECK__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WRECK", "LIMIT", "Currency");
        })();
}
function onValidate_WRECK__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WRECK", "PREMIUM", "Currency");
        })();
}
function onValidate_WRECK__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WRECK", "POST_PREM", "Currency");
        })();
}
function onValidate_WAIVER__IS_EXCESS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WAIVER", "IS_EXCESS", "Checkbox");
        })();
}
function onValidate_WAIVER__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WAIVER", "PREMIUM", "Currency");
        })();
}
function onValidate_WAIVER__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "WAIVER", "POST_PREM", "Currency");
        })();
}
function onValidate_TERRITORY__IS_EXT_TERITORY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "IS_EXT_TERITORY", "Checkbox");
        })();
}
function onValidate_TERRITORY__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "PREMIUM", "Currency");
        })();
}
function onValidate_TERRITORY__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "POST_PREM", "Currency");
        })();
}
function onValidate_TERRITORY__FAP_PER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "FAP_PER", "Percentage");
        })();
}
function onValidate_TERRITORY__FAP_AMT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "FAP_AMT", "Currency");
        })();
}
function onValidate_TERRITORY__DESCRIPT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TERRITORY", "DESCRIPT", "Text");
        })();
}
function onValidate_HIRE__IS_HIRE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "HIRE", "IS_HIRE", "Checkbox");
        })();
}
function onValidate_HIRE__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "HIRE", "LIMIT", "Currency");
        })();
}
function onValidate_HIRE__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "HIRE", "PREMIUM", "Currency");
        })();
}
function onValidate_HIRE__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "HIRE", "POST_PREM", "Currency");
        })();
}
function onValidate_HIRE__DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "HIRE", "DAYS", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("HIRE.DAYS");
        			window.setControlWidth(field, "0.5", "HIRE", "DAYS");
        		})();
        	}
        })();
}
function onValidate_LOSS_USE__IS_LOSS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS_USE", "IS_LOSS", "Checkbox");
        })();
}
function onValidate_LOSS_USE__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS_USE", "LIMIT", "Currency");
        })();
}
function onValidate_LOSS_USE__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS_USE", "PREMIUM", "Currency");
        })();
}
function onValidate_LOSS_USE__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS_USE", "POST_PREM", "Currency");
        })();
}
function onValidate_LOSS_USE__DAYS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LOSS_USE", "DAYS", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("LOSS_USE.DAYS");
        			window.setControlWidth(field, "0.5", "LOSS_USE", "DAYS");
        		})();
        	}
        })();
}
function onValidate_ROAD_ASSIST__IS_ROAD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ROAD_ASSIST", "IS_ROAD", "Checkbox");
        })();
}
function onValidate_ROAD_ASSIST__TOTPREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ROAD_ASSIST", "TOTPREMIUM", "Currency");
        })();
}
function onValidate_ROAD_ASSIST__TOTPOST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ROAD_ASSIST", "TOTPOST_PREM", "Currency");
        })();
}
function DoLogic(isOnLoad) {
    onValidate_COMM__COMM_WIND(null, null, null, isOnLoad);
    onValidate_COMM__FAP_PER(null, null, null, isOnLoad);
    onValidate_COMM__FAP_AMT(null, null, null, isOnLoad);
    onValidate_LOSS__LOSS_KEYS(null, null, null, isOnLoad);
    onValidate_LOSS__LIMIT(null, null, null, isOnLoad);
    onValidate_LOSS__PREMIUM(null, null, null, isOnLoad);
    onValidate_LOSS__POST_PREM(null, null, null, isOnLoad);
    onValidate_LOSS__FAP_PER(null, null, null, isOnLoad);
    onValidate_LOSS__FAP_AMT(null, null, null, isOnLoad);
    onValidate_RIOT__RIOT_CHK(null, null, null, isOnLoad);
    onValidate_RIOT__PREMIUM(null, null, null, isOnLoad);
    onValidate_RIOT__POST_PREM(null, null, null, isOnLoad);
    onValidate_WRECK__WRECK(null, null, null, isOnLoad);
    onValidate_WRECK__LIMIT(null, null, null, isOnLoad);
    onValidate_WRECK__PREMIUM(null, null, null, isOnLoad);
    onValidate_WRECK__POST_PREM(null, null, null, isOnLoad);
    onValidate_WAIVER__IS_EXCESS(null, null, null, isOnLoad);
    onValidate_WAIVER__PREMIUM(null, null, null, isOnLoad);
    onValidate_WAIVER__POST_PREM(null, null, null, isOnLoad);
    onValidate_TERRITORY__IS_EXT_TERITORY(null, null, null, isOnLoad);
    onValidate_TERRITORY__PREMIUM(null, null, null, isOnLoad);
    onValidate_TERRITORY__POST_PREM(null, null, null, isOnLoad);
    onValidate_TERRITORY__FAP_PER(null, null, null, isOnLoad);
    onValidate_TERRITORY__FAP_AMT(null, null, null, isOnLoad);
    onValidate_TERRITORY__DESCRIPT(null, null, null, isOnLoad);
    onValidate_HIRE__IS_HIRE(null, null, null, isOnLoad);
    onValidate_HIRE__LIMIT(null, null, null, isOnLoad);
    onValidate_HIRE__PREMIUM(null, null, null, isOnLoad);
    onValidate_HIRE__POST_PREM(null, null, null, isOnLoad);
    onValidate_HIRE__DAYS(null, null, null, isOnLoad);
    onValidate_LOSS_USE__IS_LOSS(null, null, null, isOnLoad);
    onValidate_LOSS_USE__LIMIT(null, null, null, isOnLoad);
    onValidate_LOSS_USE__PREMIUM(null, null, null, isOnLoad);
    onValidate_LOSS_USE__POST_PREM(null, null, null, isOnLoad);
    onValidate_LOSS_USE__DAYS(null, null, null, isOnLoad);
    onValidate_ROAD_ASSIST__IS_ROAD(null, null, null, isOnLoad);
    onValidate_ROAD_ASSIST__TOTPREMIUM(null, null, null, isOnLoad);
    onValidate_ROAD_ASSIST__TOTPOST_PREM(null, null, null, isOnLoad);
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
<div id="idfe477ae1f99d406b970f9fc1601ec300" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="idfe9e77a462264e7a9f737ade0a8b23b9" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading26" runat="server" Text="Extensions" /></legend>
				
				
				<div data-column-count="8" data-column-ratio="9:13:13:13:13:13:13:13" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label32">
		<span class="label" id="label32"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label33">
		<span class="label" id="label33"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label34">
		<span class="label" id="label34">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label35">
		<span class="label" id="label35">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label36">
		<span class="label" id="label36">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label37">
		<span class="label" id="label37">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label38">
		<span class="label" id="label38">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label39">
		<span class="label" id="label39">Description</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblCOMM_COMM_WIND" for="ctl00_cntMainBody_COMM__COMM_WIND" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="COMM" 
		data-property-name="COMM_WIND" 
		id="pb-container-checkbox-COMM-COMM_WIND">	
		
		<asp:TextBox ID="COMM__COMM_WIND" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCOMM_COMM_WIND" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMM.COMM_WIND"
			ClientValidationFunction="onValidate_COMM__COMM_WIND" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label40">
		<span class="label" id="label40">Windscreen</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label41">
		<span class="label" id="label41"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label42">
		<span class="label" id="label42"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label43">
		<span class="label" id="label43"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="COMM" 
		data-property-name="FAP_PER" 
		id="pb-container-percentage-COMM-FAP_PER">
		<asp:Label ID="lblCOMM_FAP_PER" runat="server" AssociatedControlID="COMM__FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="COMM__FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valCOMM_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMM.FAP_PER"
			ClientValidationFunction="onValidate_COMM__FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="COMM" 
		data-property-name="FAP_AMT" 
		id="pb-container-currency-COMM-FAP_AMT">
		<asp:Label ID="lblCOMM_FAP_AMT" runat="server" AssociatedControlID="COMM__FAP_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="COMM__FAP_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCOMM_FAP_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for COMM.FAP_AMT"
			ClientValidationFunction="onValidate_COMM__FAP_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label44">
		<span class="label" id="label44"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblLOSS_LOSS_KEYS" for="ctl00_cntMainBody_LOSS__LOSS_KEYS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="LOSS" 
		data-property-name="LOSS_KEYS" 
		id="pb-container-checkbox-LOSS-LOSS_KEYS">	
		
		<asp:TextBox ID="LOSS__LOSS_KEYS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valLOSS_LOSS_KEYS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.LOSS_KEYS"
			ClientValidationFunction="onValidate_LOSS__LOSS_KEYS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label45">
		<span class="label" id="label45">Loss of Keys </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS" 
		data-property-name="LIMIT" 
		id="pb-container-currency-LOSS-LIMIT">
		<asp:Label ID="lblLOSS_LIMIT" runat="server" AssociatedControlID="LOSS__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.LIMIT"
			ClientValidationFunction="onValidate_LOSS__LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-LOSS-PREMIUM">
		<asp:Label ID="lblLOSS_PREMIUM" runat="server" AssociatedControlID="LOSS__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.PREMIUM"
			ClientValidationFunction="onValidate_LOSS__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-LOSS-POST_PREM">
		<asp:Label ID="lblLOSS_POST_PREM" runat="server" AssociatedControlID="LOSS__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.POST_PREM"
			ClientValidationFunction="onValidate_LOSS__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="LOSS" 
		data-property-name="FAP_PER" 
		id="pb-container-percentage-LOSS-FAP_PER">
		<asp:Label ID="lblLOSS_FAP_PER" runat="server" AssociatedControlID="LOSS__FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="LOSS__FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valLOSS_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.FAP_PER"
			ClientValidationFunction="onValidate_LOSS__FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS" 
		data-property-name="FAP_AMT" 
		id="pb-container-currency-LOSS-FAP_AMT">
		<asp:Label ID="lblLOSS_FAP_AMT" runat="server" AssociatedControlID="LOSS__FAP_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS__FAP_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_FAP_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS.FAP_AMT"
			ClientValidationFunction="onValidate_LOSS__FAP_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label46">
		<span class="label" id="label46"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblRIOT_RIOT_CHK" for="ctl00_cntMainBody_RIOT__RIOT_CHK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="RIOT" 
		data-property-name="RIOT_CHK" 
		id="pb-container-checkbox-RIOT-RIOT_CHK">	
		
		<asp:TextBox ID="RIOT__RIOT_CHK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valRIOT_RIOT_CHK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RIOT.RIOT_CHK"
			ClientValidationFunction="onValidate_RIOT__RIOT_CHK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label47">
		<span class="label" id="label47">Riot & Strike </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label48">
		<span class="label" id="label48"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RIOT" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-RIOT-PREMIUM">
		<asp:Label ID="lblRIOT_PREMIUM" runat="server" AssociatedControlID="RIOT__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RIOT__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRIOT_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RIOT.PREMIUM"
			ClientValidationFunction="onValidate_RIOT__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="RIOT" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-RIOT-POST_PREM">
		<asp:Label ID="lblRIOT_POST_PREM" runat="server" AssociatedControlID="RIOT__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="RIOT__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valRIOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for RIOT.POST_PREM"
			ClientValidationFunction="onValidate_RIOT__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label49">
		<span class="label" id="label49"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label50">
		<span class="label" id="label50"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label51">
		<span class="label" id="label51"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblWRECK_WRECK" for="ctl00_cntMainBody_WRECK__WRECK" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="WRECK" 
		data-property-name="WRECK" 
		id="pb-container-checkbox-WRECK-WRECK">	
		
		<asp:TextBox ID="WRECK__WRECK" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valWRECK_WRECK" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WRECK.WRECK"
			ClientValidationFunction="onValidate_WRECK__WRECK" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label52">
		<span class="label" id="label52">Wreckage Removal</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="WRECK" 
		data-property-name="LIMIT" 
		id="pb-container-currency-WRECK-LIMIT">
		<asp:Label ID="lblWRECK_LIMIT" runat="server" AssociatedControlID="WRECK__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="WRECK__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valWRECK_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WRECK.LIMIT"
			ClientValidationFunction="onValidate_WRECK__LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="WRECK" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-WRECK-PREMIUM">
		<asp:Label ID="lblWRECK_PREMIUM" runat="server" AssociatedControlID="WRECK__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="WRECK__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valWRECK_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WRECK.PREMIUM"
			ClientValidationFunction="onValidate_WRECK__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="WRECK" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-WRECK-POST_PREM">
		<asp:Label ID="lblWRECK_POST_PREM" runat="server" AssociatedControlID="WRECK__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="WRECK__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valWRECK_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WRECK.POST_PREM"
			ClientValidationFunction="onValidate_WRECK__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label53">
		<span class="label" id="label53"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label54">
		<span class="label" id="label54"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label55">
		<span class="label" id="label55"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblWAIVER_IS_EXCESS" for="ctl00_cntMainBody_WAIVER__IS_EXCESS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="WAIVER" 
		data-property-name="IS_EXCESS" 
		id="pb-container-checkbox-WAIVER-IS_EXCESS">	
		
		<asp:TextBox ID="WAIVER__IS_EXCESS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valWAIVER_IS_EXCESS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WAIVER.IS_EXCESS"
			ClientValidationFunction="onValidate_WAIVER__IS_EXCESS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label56">
		<span class="label" id="label56">Excess Waiver</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label57">
		<span class="label" id="label57"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="WAIVER" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-WAIVER-PREMIUM">
		<asp:Label ID="lblWAIVER_PREMIUM" runat="server" AssociatedControlID="WAIVER__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="WAIVER__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valWAIVER_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WAIVER.PREMIUM"
			ClientValidationFunction="onValidate_WAIVER__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="WAIVER" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-WAIVER-POST_PREM">
		<asp:Label ID="lblWAIVER_POST_PREM" runat="server" AssociatedControlID="WAIVER__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="WAIVER__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valWAIVER_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for WAIVER.POST_PREM"
			ClientValidationFunction="onValidate_WAIVER__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label58">
		<span class="label" id="label58"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label59">
		<span class="label" id="label59"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label60">
		<span class="label" id="label60"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTERRITORY_IS_EXT_TERITORY" for="ctl00_cntMainBody_TERRITORY__IS_EXT_TERITORY" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="TERRITORY" 
		data-property-name="IS_EXT_TERITORY" 
		id="pb-container-checkbox-TERRITORY-IS_EXT_TERITORY">	
		
		<asp:TextBox ID="TERRITORY__IS_EXT_TERITORY" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTERRITORY_IS_EXT_TERITORY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TERRITORY.IS_EXT_TERITORY"
			ClientValidationFunction="onValidate_TERRITORY__IS_EXT_TERITORY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label61">
		<span class="label" id="label61">Extended Territories</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label62">
		<span class="label" id="label62"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="TERRITORY" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-TERRITORY-PREMIUM">
		<asp:Label ID="lblTERRITORY_PREMIUM" runat="server" AssociatedControlID="TERRITORY__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TERRITORY__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTERRITORY_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TERRITORY.PREMIUM"
			ClientValidationFunction="onValidate_TERRITORY__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="TERRITORY" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-TERRITORY-POST_PREM">
		<asp:Label ID="lblTERRITORY_POST_PREM" runat="server" AssociatedControlID="TERRITORY__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TERRITORY__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTERRITORY_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TERRITORY.POST_PREM"
			ClientValidationFunction="onValidate_TERRITORY__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="TERRITORY" 
		data-property-name="FAP_PER" 
		id="pb-container-percentage-TERRITORY-FAP_PER">
		<asp:Label ID="lblTERRITORY_FAP_PER" runat="server" AssociatedControlID="TERRITORY__FAP_PER" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="TERRITORY__FAP_PER" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTERRITORY_FAP_PER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TERRITORY.FAP_PER"
			ClientValidationFunction="onValidate_TERRITORY__FAP_PER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="TERRITORY" 
		data-property-name="FAP_AMT" 
		id="pb-container-currency-TERRITORY-FAP_AMT">
		<asp:Label ID="lblTERRITORY_FAP_AMT" runat="server" AssociatedControlID="TERRITORY__FAP_AMT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TERRITORY__FAP_AMT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTERRITORY_FAP_AMT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TERRITORY.FAP_AMT"
			ClientValidationFunction="onValidate_TERRITORY__FAP_AMT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="TERRITORY" 
		data-property-name="DESCRIPT" 
		 
		
		 
		id="pb-container-text-TERRITORY-DESCRIPT">

		
		<asp:Label ID="lblTERRITORY_DESCRIPT" runat="server" AssociatedControlID="TERRITORY__DESCRIPT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="TERRITORY__DESCRIPT" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valTERRITORY_DESCRIPT" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for TERRITORY.DESCRIPT"
					ClientValidationFunction="onValidate_TERRITORY__DESCRIPT"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblHIRE_IS_HIRE" for="ctl00_cntMainBody_HIRE__IS_HIRE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="HIRE" 
		data-property-name="IS_HIRE" 
		id="pb-container-checkbox-HIRE-IS_HIRE">	
		
		<asp:TextBox ID="HIRE__IS_HIRE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valHIRE_IS_HIRE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for HIRE.IS_HIRE"
			ClientValidationFunction="onValidate_HIRE__IS_HIRE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label63">
		<span class="label" id="label63">Car Hire </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="HIRE" 
		data-property-name="LIMIT" 
		id="pb-container-currency-HIRE-LIMIT">
		<asp:Label ID="lblHIRE_LIMIT" runat="server" AssociatedControlID="HIRE__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="HIRE__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valHIRE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for HIRE.LIMIT"
			ClientValidationFunction="onValidate_HIRE__LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="HIRE" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-HIRE-PREMIUM">
		<asp:Label ID="lblHIRE_PREMIUM" runat="server" AssociatedControlID="HIRE__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="HIRE__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valHIRE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for HIRE.PREMIUM"
			ClientValidationFunction="onValidate_HIRE__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="HIRE" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-HIRE-POST_PREM">
		<asp:Label ID="lblHIRE_POST_PREM" runat="server" AssociatedControlID="HIRE__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="HIRE__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valHIRE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for HIRE.POST_PREM"
			ClientValidationFunction="onValidate_HIRE__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="HIRE" 
		data-property-name="DAYS" 
		 
		
		 
		id="pb-container-text-HIRE-DAYS">

		
		<asp:Label ID="lblHIRE_DAYS" runat="server" AssociatedControlID="HIRE__DAYS" 
			Text="No of Days " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="HIRE__DAYS" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valHIRE_DAYS" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for No of Days "
					ClientValidationFunction="onValidate_HIRE__DAYS"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label64">
		<span class="label" id="label64"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label65">
		<span class="label" id="label65"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblLOSS_USE_IS_LOSS" for="ctl00_cntMainBody_LOSS_USE__IS_LOSS" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="LOSS_USE" 
		data-property-name="IS_LOSS" 
		id="pb-container-checkbox-LOSS_USE-IS_LOSS">	
		
		<asp:TextBox ID="LOSS_USE__IS_LOSS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valLOSS_USE_IS_LOSS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS_USE.IS_LOSS"
			ClientValidationFunction="onValidate_LOSS_USE__IS_LOSS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label66">
		<span class="label" id="label66">Loss of use </span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS_USE" 
		data-property-name="LIMIT" 
		id="pb-container-currency-LOSS_USE-LIMIT">
		<asp:Label ID="lblLOSS_USE_LIMIT" runat="server" AssociatedControlID="LOSS_USE__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS_USE__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_USE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS_USE.LIMIT"
			ClientValidationFunction="onValidate_LOSS_USE__LIMIT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS_USE" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-LOSS_USE-PREMIUM">
		<asp:Label ID="lblLOSS_USE_PREMIUM" runat="server" AssociatedControlID="LOSS_USE__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS_USE__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_USE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS_USE.PREMIUM"
			ClientValidationFunction="onValidate_LOSS_USE__PREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LOSS_USE" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-LOSS_USE-POST_PREM">
		<asp:Label ID="lblLOSS_USE_POST_PREM" runat="server" AssociatedControlID="LOSS_USE__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LOSS_USE__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLOSS_USE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LOSS_USE.POST_PREM"
			ClientValidationFunction="onValidate_LOSS_USE__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="LOSS_USE" 
		data-property-name="DAYS" 
		 
		
		 
		id="pb-container-text-LOSS_USE-DAYS">

		
		<asp:Label ID="lblLOSS_USE_DAYS" runat="server" AssociatedControlID="LOSS_USE__DAYS" 
			Text="No of Days " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="LOSS_USE__DAYS" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valLOSS_USE_DAYS" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for No of Days "
					ClientValidationFunction="onValidate_LOSS_USE__DAYS"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label67">
		<span class="label" id="label67"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label68">
		<span class="label" id="label68"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblROAD_ASSIST_IS_ROAD" for="ctl00_cntMainBody_ROAD_ASSIST__IS_ROAD" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="ROAD_ASSIST" 
		data-property-name="IS_ROAD" 
		id="pb-container-checkbox-ROAD_ASSIST-IS_ROAD">	
		
		<asp:TextBox ID="ROAD_ASSIST__IS_ROAD" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valROAD_ASSIST_IS_ROAD" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ROAD_ASSIST.IS_ROAD"
			ClientValidationFunction="onValidate_ROAD_ASSIST__IS_ROAD" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label69">
		<span class="label" id="label69">Roadside Assist</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label70">
		<span class="label" id="label70"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label71">
		<span class="label" id="label71"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label72">
		<span class="label" id="label72"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label73">
		<span class="label" id="label73"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label74">
		<span class="label" id="label74"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label75">
		<span class="label" id="label75"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:9%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label76">
		<span class="label" id="label76"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label77">
		<span class="label" id="label77">Total</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label78">
		<span class="label" id="label78"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ROAD_ASSIST" 
		data-property-name="TOTPREMIUM" 
		id="pb-container-currency-ROAD_ASSIST-TOTPREMIUM">
		<asp:Label ID="lblROAD_ASSIST_TOTPREMIUM" runat="server" AssociatedControlID="ROAD_ASSIST__TOTPREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ROAD_ASSIST__TOTPREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valROAD_ASSIST_TOTPREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ROAD_ASSIST.TOTPREMIUM"
			ClientValidationFunction="onValidate_ROAD_ASSIST__TOTPREMIUM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ROAD_ASSIST" 
		data-property-name="TOTPOST_PREM" 
		id="pb-container-currency-ROAD_ASSIST-TOTPOST_PREM">
		<asp:Label ID="lblROAD_ASSIST_TOTPOST_PREM" runat="server" AssociatedControlID="ROAD_ASSIST__TOTPOST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ROAD_ASSIST__TOTPOST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valROAD_ASSIST_TOTPOST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ROAD_ASSIST.TOTPOST_PREM"
			ClientValidationFunction="onValidate_ROAD_ASSIST__TOTPOST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label79">
		<span class="label" id="label79"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label80">
		<span class="label" id="label80"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:13%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label81">
		<span class="label" id="label81"></span>
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
		if ($("#idfe9e77a462264e7a9f737ade0a8b23b9 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idfe9e77a462264e7a9f737ade0a8b23b9 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idfe9e77a462264e7a9f737ade0a8b23b9 div ul li").each(function(){		  
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
			$("#idfe9e77a462264e7a9f737ade0a8b23b9 div ul li").each(function(){		  
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
		styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idfe9e77a462264e7a9f737ade0a8b23b9 input{text-align:left;}"; break;
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