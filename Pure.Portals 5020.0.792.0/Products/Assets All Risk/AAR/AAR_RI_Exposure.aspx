<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="AAR_RI_Exposure.aspx.vb" Inherits="Nexus.PB2_AAR_RI_Exposure" %>

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
function onValidate_ALLRISK_RI__FVM_PROP_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_PROP_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__FVM_PROP_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_PROP_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__FVM_PROP_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_PROP_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__FVM_PROP_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_PROP_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__FVM_BI_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_BI_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__FVM_BI_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_BI_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__FVM_BI_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_BI_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__FVM_BI_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "FVM_BI_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__GEN_EXT_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "GEN_EXT_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__GEN_EXT_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "GEN_EXT_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__GEN_EXT_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "GEN_EXT_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__GEN_EXT_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "GEN_EXT_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__PROP_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_EXT_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_EXT_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_EXT_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_EXT_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__PROP_EXT_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_EXT_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__PROP_EXT_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "PROP_EXT_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__BI_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_EXT_TOT_SI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_EXT_TOT_SI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_EXT_KR(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_EXT_KR", "Currency");
        })();
}
function onValidate_ALLRISK_RI__BI_EXT_EML(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_EXT_EML", "Percentage");
        })();
}
function onValidate_ALLRISK_RI__BI_EXT_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "BI_EXT_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__MLL_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "MLL_RI", "Currency");
        })();
}
function onValidate_ALLRISK_RI__TOT_RI(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "ALLRISK_RI", "TOT_RI", "Currency");
        })();
}
function DoLogic(isOnLoad) {
    onValidate_ALLRISK_RI__FVM_PROP_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_PROP_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_PROP_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_PROP_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_BI_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_BI_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_BI_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__FVM_BI_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__GEN_EXT_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__GEN_EXT_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__GEN_EXT_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__GEN_EXT_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_EXT_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_EXT_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_EXT_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__PROP_EXT_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_EXT_TOT_SI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_EXT_KR(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_EXT_EML(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__BI_EXT_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__MLL_RI(null, null, null, isOnLoad);
    onValidate_ALLRISK_RI__TOT_RI(null, null, null, isOnLoad);
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
<div id="ida0391fc796824bcb8e4248ab5013fb81" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id4725427ae5634030a94cfcd80c5308f7" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading99" runat="server" Text="Risk Data" /></legend>
				
				
				<div data-column-count="5" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label537">
		<span class="label" id="label537"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label538">
		<span class="label" id="label538">Total Sum Insured</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label539">
		<span class="label" id="label539">Key Risk SI</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label540">
		<span class="label" id="label540">EML %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label541">
		<span class="label" id="label541">RI Exposure</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label542">
		<span class="label" id="label542">Full Value Margin: Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_PROP_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-FVM_PROP_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_FVM_PROP_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__FVM_PROP_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_PROP_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_PROP_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_PROP_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_PROP_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_PROP_KR" 
		id="pb-container-currency-ALLRISK_RI-FVM_PROP_KR">
		<asp:Label ID="lblALLRISK_RI_FVM_PROP_KR" runat="server" AssociatedControlID="ALLRISK_RI__FVM_PROP_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_PROP_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_PROP_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_PROP_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_PROP_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_PROP_EML" 
		id="pb-container-percentage-ALLRISK_RI-FVM_PROP_EML">
		<asp:Label ID="lblALLRISK_RI_FVM_PROP_EML" runat="server" AssociatedControlID="ALLRISK_RI__FVM_PROP_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__FVM_PROP_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_PROP_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_PROP_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_PROP_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_PROP_RI" 
		id="pb-container-currency-ALLRISK_RI-FVM_PROP_RI">
		<asp:Label ID="lblALLRISK_RI_FVM_PROP_RI" runat="server" AssociatedControlID="ALLRISK_RI__FVM_PROP_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_PROP_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_PROP_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_PROP_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_PROP_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label543">
		<span class="label" id="label543">Full Value Margin: Business Interruption</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_BI_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-FVM_BI_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_FVM_BI_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__FVM_BI_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_BI_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_BI_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_BI_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_BI_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_BI_KR" 
		id="pb-container-currency-ALLRISK_RI-FVM_BI_KR">
		<asp:Label ID="lblALLRISK_RI_FVM_BI_KR" runat="server" AssociatedControlID="ALLRISK_RI__FVM_BI_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_BI_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_BI_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_BI_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_BI_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_BI_EML" 
		id="pb-container-percentage-ALLRISK_RI-FVM_BI_EML">
		<asp:Label ID="lblALLRISK_RI_FVM_BI_EML" runat="server" AssociatedControlID="ALLRISK_RI__FVM_BI_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__FVM_BI_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_BI_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_BI_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_BI_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="FVM_BI_RI" 
		id="pb-container-currency-ALLRISK_RI-FVM_BI_RI">
		<asp:Label ID="lblALLRISK_RI_FVM_BI_RI" runat="server" AssociatedControlID="ALLRISK_RI__FVM_BI_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__FVM_BI_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_FVM_BI_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.FVM_BI_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__FVM_BI_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label544">
		<span class="label" id="label544">General Extensions</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="GEN_EXT_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-GEN_EXT_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_GEN_EXT_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__GEN_EXT_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__GEN_EXT_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_GEN_EXT_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.GEN_EXT_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__GEN_EXT_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="GEN_EXT_KR" 
		id="pb-container-currency-ALLRISK_RI-GEN_EXT_KR">
		<asp:Label ID="lblALLRISK_RI_GEN_EXT_KR" runat="server" AssociatedControlID="ALLRISK_RI__GEN_EXT_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__GEN_EXT_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_GEN_EXT_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.GEN_EXT_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__GEN_EXT_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="GEN_EXT_EML" 
		id="pb-container-percentage-ALLRISK_RI-GEN_EXT_EML">
		<asp:Label ID="lblALLRISK_RI_GEN_EXT_EML" runat="server" AssociatedControlID="ALLRISK_RI__GEN_EXT_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__GEN_EXT_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_GEN_EXT_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.GEN_EXT_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__GEN_EXT_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="GEN_EXT_RI" 
		id="pb-container-currency-ALLRISK_RI-GEN_EXT_RI">
		<asp:Label ID="lblALLRISK_RI_GEN_EXT_RI" runat="server" AssociatedControlID="ALLRISK_RI__GEN_EXT_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__GEN_EXT_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_GEN_EXT_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.GEN_EXT_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__GEN_EXT_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label545">
		<span class="label" id="label545">Property</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-PROP_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_PROP_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__PROP_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_KR" 
		id="pb-container-currency-ALLRISK_RI-PROP_KR">
		<asp:Label ID="lblALLRISK_RI_PROP_KR" runat="server" AssociatedControlID="ALLRISK_RI__PROP_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_EML" 
		id="pb-container-percentage-ALLRISK_RI-PROP_EML">
		<asp:Label ID="lblALLRISK_RI_PROP_EML" runat="server" AssociatedControlID="ALLRISK_RI__PROP_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__PROP_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_RI" 
		id="pb-container-currency-ALLRISK_RI-PROP_RI">
		<asp:Label ID="lblALLRISK_RI_PROP_RI" runat="server" AssociatedControlID="ALLRISK_RI__PROP_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label546">
		<span class="label" id="label546">Property Extensions</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_EXT_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-PROP_EXT_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_PROP_EXT_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__PROP_EXT_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_EXT_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_EXT_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_EXT_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_EXT_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_EXT_KR" 
		id="pb-container-currency-ALLRISK_RI-PROP_EXT_KR">
		<asp:Label ID="lblALLRISK_RI_PROP_EXT_KR" runat="server" AssociatedControlID="ALLRISK_RI__PROP_EXT_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_EXT_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_EXT_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_EXT_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_EXT_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_EXT_EML" 
		id="pb-container-percentage-ALLRISK_RI-PROP_EXT_EML">
		<asp:Label ID="lblALLRISK_RI_PROP_EXT_EML" runat="server" AssociatedControlID="ALLRISK_RI__PROP_EXT_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__PROP_EXT_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_EXT_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_EXT_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_EXT_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="PROP_EXT_RI" 
		id="pb-container-currency-ALLRISK_RI-PROP_EXT_RI">
		<asp:Label ID="lblALLRISK_RI_PROP_EXT_RI" runat="server" AssociatedControlID="ALLRISK_RI__PROP_EXT_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__PROP_EXT_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_PROP_EXT_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.PROP_EXT_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__PROP_EXT_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label547">
		<span class="label" id="label547">Business Interruption</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-BI_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_BI_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__BI_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_KR" 
		id="pb-container-currency-ALLRISK_RI-BI_KR">
		<asp:Label ID="lblALLRISK_RI_BI_KR" runat="server" AssociatedControlID="ALLRISK_RI__BI_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_EML" 
		id="pb-container-percentage-ALLRISK_RI-BI_EML">
		<asp:Label ID="lblALLRISK_RI_BI_EML" runat="server" AssociatedControlID="ALLRISK_RI__BI_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__BI_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_RI" 
		id="pb-container-currency-ALLRISK_RI-BI_RI">
		<asp:Label ID="lblALLRISK_RI_BI_RI" runat="server" AssociatedControlID="ALLRISK_RI__BI_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label548">
		<span class="label" id="label548">Business Interruption Extensions</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_EXT_TOT_SI" 
		id="pb-container-currency-ALLRISK_RI-BI_EXT_TOT_SI">
		<asp:Label ID="lblALLRISK_RI_BI_EXT_TOT_SI" runat="server" AssociatedControlID="ALLRISK_RI__BI_EXT_TOT_SI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_EXT_TOT_SI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_EXT_TOT_SI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_EXT_TOT_SI"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_EXT_TOT_SI" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_EXT_KR" 
		id="pb-container-currency-ALLRISK_RI-BI_EXT_KR">
		<asp:Label ID="lblALLRISK_RI_BI_EXT_KR" runat="server" AssociatedControlID="ALLRISK_RI__BI_EXT_KR" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_EXT_KR" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_EXT_KR" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_EXT_KR"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_EXT_KR" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_EXT_EML" 
		id="pb-container-percentage-ALLRISK_RI-BI_EXT_EML">
		<asp:Label ID="lblALLRISK_RI_BI_EXT_EML" runat="server" AssociatedControlID="ALLRISK_RI__BI_EXT_EML" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="ALLRISK_RI__BI_EXT_EML" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_EXT_EML" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_EXT_EML"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_EXT_EML" 
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
		data-object-name="ALLRISK_RI" 
		data-property-name="BI_EXT_RI" 
		id="pb-container-currency-ALLRISK_RI-BI_EXT_RI">
		<asp:Label ID="lblALLRISK_RI_BI_EXT_RI" runat="server" AssociatedControlID="ALLRISK_RI__BI_EXT_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__BI_EXT_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_BI_EXT_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.BI_EXT_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__BI_EXT_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label549">
		<span class="label" id="label549">Maximum Loss Limit</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label550">
		<span class="label" id="label550"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label551">
		<span class="label" id="label551"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label552">
		<span class="label" id="label552"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="MLL_RI" 
		id="pb-container-currency-ALLRISK_RI-MLL_RI">
		<asp:Label ID="lblALLRISK_RI_MLL_RI" runat="server" AssociatedControlID="ALLRISK_RI__MLL_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__MLL_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_MLL_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.MLL_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__MLL_RI" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label553">
		<span class="label" id="label553">TOTAL RI Exposure (Vat Exclusive)</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label554">
		<span class="label" id="label554"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label555">
		<span class="label" id="label555"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label556">
		<span class="label" id="label556"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:20%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="ALLRISK_RI" 
		data-property-name="TOT_RI" 
		id="pb-container-currency-ALLRISK_RI-TOT_RI">
		<asp:Label ID="lblALLRISK_RI_TOT_RI" runat="server" AssociatedControlID="ALLRISK_RI__TOT_RI" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="ALLRISK_RI__TOT_RI" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valALLRISK_RI_TOT_RI" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for ALLRISK_RI.TOT_RI"
			ClientValidationFunction="onValidate_ALLRISK_RI__TOT_RI" 
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
		if ($("#id4725427ae5634030a94cfcd80c5308f7 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id4725427ae5634030a94cfcd80c5308f7 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id4725427ae5634030a94cfcd80c5308f7 div ul li").each(function(){		  
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
			$("#id4725427ae5634030a94cfcd80c5308f7 div ul li").each(function(){		  
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
		styleString += "#id4725427ae5634030a94cfcd80c5308f7 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id4725427ae5634030a94cfcd80c5308f7 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4725427ae5634030a94cfcd80c5308f7 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4725427ae5634030a94cfcd80c5308f7 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id4725427ae5634030a94cfcd80c5308f7 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id4725427ae5634030a94cfcd80c5308f7 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id4725427ae5634030a94cfcd80c5308f7 input{text-align:left;}"; break;
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