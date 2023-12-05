<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="MMFLEET_Liabilities.aspx.vb" Inherits="Nexus.PB2_MMFLEET_Liabilities" %>

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
function onValidate_LIAB_TP_NONFARE__TP_NONFARE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "TP_NONFARE", "Checkbox");
        })();
}
function onValidate_LIAB_TP_NONFARE__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "LIMIT", "Currency");
        })();
}
function onValidate_LIAB_TP_NONFARE__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "PREMIUM", "Currency");
        })();
}
function onValidate_LIAB_TP_NONFARE__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "POST_PREM", "Currency");
        })();
}
function onValidate_LIAB_TP_NONFARE__MIN_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "MIN_PERC", "Percentage");
        })();
}
function onValidate_LIAB_TP_NONFARE__MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "LIAB_TP_NONFARE", "MIN_AMNT", "Currency");
        })();
}
function onValidate_TP__TP(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "TP", "Checkbox");
        })();
}
function onValidate_TP__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "LIMIT", "Currency");
        })();
}
function onValidate_TP__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "PREMIUM", "Currency");
        })();
}
function onValidate_TP__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "POST_PREM", "Currency");
        })();
}
function onValidate_TP__MIN_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "MIN_PERC", "Percentage");
        })();
}
function onValidate_TP__MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TP", "MIN_AMNT", "Currency");
        })();
}
function onValidate_PL_FARE__PL_FARE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "PL_FARE", "Checkbox");
        })();
}
function onValidate_PL_FARE__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "LIMIT", "Currency");
        })();
}
function onValidate_PL_FARE__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "PREMIUM", "Currency");
        })();
}
function onValidate_PL_FARE__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "POST_PREM", "Currency");
        })();
}
function onValidate_PL_FARE__MIN_PERC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "MIN_PERC", "Percentage");
        })();
}
function onValidate_PL_FARE__MIN_AMNT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PL_FARE", "MIN_AMNT", "Currency");
        })();
}
function onValidate_UN_PL__UN_PL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "UN_PL", "UN_PL", "Checkbox");
        })();
}
function onValidate_UN_PL__LIMIT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "UN_PL", "LIMIT", "Currency");
        })();
}
function onValidate_UN_PL__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "UN_PL", "PREMIUM", "Currency");
        })();
}
function onValidate_UN_PL__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "UN_PL", "POST_PREM", "Currency");
        })();
}
function onValidate_TOT__PREMIUM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TOT", "PREMIUM", "Currency");
        })();
}
function onValidate_TOT__POST_PREM(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "TOT", "POST_PREM", "Currency");
        })();
}
function DoLogic(isOnLoad) {
    onValidate_LIAB_TP_NONFARE__TP_NONFARE(null, null, null, isOnLoad);
    onValidate_LIAB_TP_NONFARE__LIMIT(null, null, null, isOnLoad);
    onValidate_LIAB_TP_NONFARE__PREMIUM(null, null, null, isOnLoad);
    onValidate_LIAB_TP_NONFARE__POST_PREM(null, null, null, isOnLoad);
    onValidate_LIAB_TP_NONFARE__MIN_PERC(null, null, null, isOnLoad);
    onValidate_LIAB_TP_NONFARE__MIN_AMNT(null, null, null, isOnLoad);
    onValidate_TP__TP(null, null, null, isOnLoad);
    onValidate_TP__LIMIT(null, null, null, isOnLoad);
    onValidate_TP__PREMIUM(null, null, null, isOnLoad);
    onValidate_TP__POST_PREM(null, null, null, isOnLoad);
    onValidate_TP__MIN_PERC(null, null, null, isOnLoad);
    onValidate_TP__MIN_AMNT(null, null, null, isOnLoad);
    onValidate_PL_FARE__PL_FARE(null, null, null, isOnLoad);
    onValidate_PL_FARE__LIMIT(null, null, null, isOnLoad);
    onValidate_PL_FARE__PREMIUM(null, null, null, isOnLoad);
    onValidate_PL_FARE__POST_PREM(null, null, null, isOnLoad);
    onValidate_PL_FARE__MIN_PERC(null, null, null, isOnLoad);
    onValidate_PL_FARE__MIN_AMNT(null, null, null, isOnLoad);
    onValidate_UN_PL__UN_PL(null, null, null, isOnLoad);
    onValidate_UN_PL__LIMIT(null, null, null, isOnLoad);
    onValidate_UN_PL__PREMIUM(null, null, null, isOnLoad);
    onValidate_UN_PL__POST_PREM(null, null, null, isOnLoad);
    onValidate_TOT__PREMIUM(null, null, null, isOnLoad);
    onValidate_TOT__POST_PREM(null, null, null, isOnLoad);
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
<div id="id9797c26bbe4640eba6274017f36716bd" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id73cda24bd9d94164ac15fec08c7a47a2" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading24" runat="server" Text="Liabilities (Sub-Section B)" /></legend>
				
				
				<div data-column-count="7" data-column-ratio="4:16:16:16:16:16:16" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label14">
		<span class="label" id="label14"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label15">
		<span class="label" id="label15"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label16">
		<span class="label" id="label16">Limit of Indemnity</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label17">
		<span class="label" id="label17">Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label18">
		<span class="label" id="label18">Posting Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label19">
		<span class="label" id="label19">FAP %</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label20">
		<span class="label" id="label20">Minimum Amount</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblLIAB_TP_NONFARE_TP_NONFARE" for="ctl00_cntMainBody_LIAB_TP_NONFARE__TP_NONFARE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="TP_NONFARE" 
		id="pb-container-checkbox-LIAB_TP_NONFARE-TP_NONFARE">	
		
		<asp:TextBox ID="LIAB_TP_NONFARE__TP_NONFARE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_TP_NONFARE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.TP_NONFARE"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__TP_NONFARE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label21">
		<span class="label" id="label21">Third Party and Non-Fare Paying Passengers Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="LIMIT" 
		id="pb-container-currency-LIAB_TP_NONFARE-LIMIT">
		<asp:Label ID="lblLIAB_TP_NONFARE_LIMIT" runat="server" AssociatedControlID="LIAB_TP_NONFARE__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LIAB_TP_NONFARE__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.LIMIT"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__LIMIT" 
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
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-LIAB_TP_NONFARE-PREMIUM">
		<asp:Label ID="lblLIAB_TP_NONFARE_PREMIUM" runat="server" AssociatedControlID="LIAB_TP_NONFARE__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LIAB_TP_NONFARE__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.PREMIUM"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__PREMIUM" 
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
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-LIAB_TP_NONFARE-POST_PREM">
		<asp:Label ID="lblLIAB_TP_NONFARE_POST_PREM" runat="server" AssociatedControlID="LIAB_TP_NONFARE__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LIAB_TP_NONFARE__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.POST_PREM"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__POST_PREM" 
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
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="MIN_PERC" 
		id="pb-container-percentage-LIAB_TP_NONFARE-MIN_PERC">
		<asp:Label ID="lblLIAB_TP_NONFARE_MIN_PERC" runat="server" AssociatedControlID="LIAB_TP_NONFARE__MIN_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="LIAB_TP_NONFARE__MIN_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_MIN_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.MIN_PERC"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__MIN_PERC" 
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
		data-object-name="LIAB_TP_NONFARE" 
		data-property-name="MIN_AMNT" 
		id="pb-container-currency-LIAB_TP_NONFARE-MIN_AMNT">
		<asp:Label ID="lblLIAB_TP_NONFARE_MIN_AMNT" runat="server" AssociatedControlID="LIAB_TP_NONFARE__MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="LIAB_TP_NONFARE__MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valLIAB_TP_NONFARE_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for LIAB_TP_NONFARE.MIN_AMNT"
			ClientValidationFunction="onValidate_LIAB_TP_NONFARE__MIN_AMNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblTP_TP" for="ctl00_cntMainBody_TP__TP" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="TP" 
		data-property-name="TP" 
		id="pb-container-checkbox-TP-TP">	
		
		<asp:TextBox ID="TP__TP" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valTP_TP" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.TP"
			ClientValidationFunction="onValidate_TP__TP" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label22">
		<span class="label" id="label22">Third Party Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="TP" 
		data-property-name="LIMIT" 
		id="pb-container-currency-TP-LIMIT">
		<asp:Label ID="lblTP_LIMIT" runat="server" AssociatedControlID="TP__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TP__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTP_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.LIMIT"
			ClientValidationFunction="onValidate_TP__LIMIT" 
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
		data-object-name="TP" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-TP-PREMIUM">
		<asp:Label ID="lblTP_PREMIUM" runat="server" AssociatedControlID="TP__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TP__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTP_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.PREMIUM"
			ClientValidationFunction="onValidate_TP__PREMIUM" 
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
		data-object-name="TP" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-TP-POST_PREM">
		<asp:Label ID="lblTP_POST_PREM" runat="server" AssociatedControlID="TP__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TP__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTP_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.POST_PREM"
			ClientValidationFunction="onValidate_TP__POST_PREM" 
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
		data-object-name="TP" 
		data-property-name="MIN_PERC" 
		id="pb-container-percentage-TP-MIN_PERC">
		<asp:Label ID="lblTP_MIN_PERC" runat="server" AssociatedControlID="TP__MIN_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="TP__MIN_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valTP_MIN_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.MIN_PERC"
			ClientValidationFunction="onValidate_TP__MIN_PERC" 
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
		data-object-name="TP" 
		data-property-name="MIN_AMNT" 
		id="pb-container-currency-TP-MIN_AMNT">
		<asp:Label ID="lblTP_MIN_AMNT" runat="server" AssociatedControlID="TP__MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TP__MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTP_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TP.MIN_AMNT"
			ClientValidationFunction="onValidate_TP__MIN_AMNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblPL_FARE_PL_FARE" for="ctl00_cntMainBody_PL_FARE__PL_FARE" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="PL_FARE" 
		data-property-name="PL_FARE" 
		id="pb-container-checkbox-PL_FARE-PL_FARE">	
		
		<asp:TextBox ID="PL_FARE__PL_FARE" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valPL_FARE_PL_FARE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.PL_FARE"
			ClientValidationFunction="onValidate_PL_FARE__PL_FARE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label23">
		<span class="label" id="label23">Non-Fare Paying Passengers Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="PL_FARE" 
		data-property-name="LIMIT" 
		id="pb-container-currency-PL_FARE-LIMIT">
		<asp:Label ID="lblPL_FARE_LIMIT" runat="server" AssociatedControlID="PL_FARE__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PL_FARE__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPL_FARE_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.LIMIT"
			ClientValidationFunction="onValidate_PL_FARE__LIMIT" 
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
		data-object-name="PL_FARE" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-PL_FARE-PREMIUM">
		<asp:Label ID="lblPL_FARE_PREMIUM" runat="server" AssociatedControlID="PL_FARE__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PL_FARE__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPL_FARE_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.PREMIUM"
			ClientValidationFunction="onValidate_PL_FARE__PREMIUM" 
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
		data-object-name="PL_FARE" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-PL_FARE-POST_PREM">
		<asp:Label ID="lblPL_FARE_POST_PREM" runat="server" AssociatedControlID="PL_FARE__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PL_FARE__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPL_FARE_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.POST_PREM"
			ClientValidationFunction="onValidate_PL_FARE__POST_PREM" 
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
		data-object-name="PL_FARE" 
		data-property-name="MIN_PERC" 
		id="pb-container-percentage-PL_FARE-MIN_PERC">
		<asp:Label ID="lblPL_FARE_MIN_PERC" runat="server" AssociatedControlID="PL_FARE__MIN_PERC" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="PL_FARE__MIN_PERC" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valPL_FARE_MIN_PERC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.MIN_PERC"
			ClientValidationFunction="onValidate_PL_FARE__MIN_PERC" 
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
		data-object-name="PL_FARE" 
		data-property-name="MIN_AMNT" 
		id="pb-container-currency-PL_FARE-MIN_AMNT">
		<asp:Label ID="lblPL_FARE_MIN_AMNT" runat="server" AssociatedControlID="PL_FARE__MIN_AMNT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="PL_FARE__MIN_AMNT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valPL_FARE_MIN_AMNT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for PL_FARE.MIN_AMNT"
			ClientValidationFunction="onValidate_PL_FARE__MIN_AMNT" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblUN_PL_UN_PL" for="ctl00_cntMainBody_UN_PL__UN_PL" class="col-md-4 col-sm-3 control-label">
		</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="UN_PL" 
		data-property-name="UN_PL" 
		id="pb-container-checkbox-UN_PL-UN_PL">	
		
		<asp:TextBox ID="UN_PL__UN_PL" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valUN_PL_UN_PL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UN_PL.UN_PL"
			ClientValidationFunction="onValidate_UN_PL__UN_PL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label24">
		<span class="label" id="label24">Unauthorised Passenger Liability</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="UN_PL" 
		data-property-name="LIMIT" 
		id="pb-container-currency-UN_PL-LIMIT">
		<asp:Label ID="lblUN_PL_LIMIT" runat="server" AssociatedControlID="UN_PL__LIMIT" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="UN_PL__LIMIT" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valUN_PL_LIMIT" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UN_PL.LIMIT"
			ClientValidationFunction="onValidate_UN_PL__LIMIT" 
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
		data-object-name="UN_PL" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-UN_PL-PREMIUM">
		<asp:Label ID="lblUN_PL_PREMIUM" runat="server" AssociatedControlID="UN_PL__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="UN_PL__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valUN_PL_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UN_PL.PREMIUM"
			ClientValidationFunction="onValidate_UN_PL__PREMIUM" 
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
		data-object-name="UN_PL" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-UN_PL-POST_PREM">
		<asp:Label ID="lblUN_PL_POST_PREM" runat="server" AssociatedControlID="UN_PL__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="UN_PL__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valUN_PL_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for UN_PL.POST_PREM"
			ClientValidationFunction="onValidate_UN_PL__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label25">
		<span class="label" id="label25"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label26">
		<span class="label" id="label26"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:4%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label27">
		<span class="label" id="label27"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label28">
		<span class="label" id="label28">Total Premium</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label29">
		<span class="label" id="label29"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="TOT" 
		data-property-name="PREMIUM" 
		id="pb-container-currency-TOT-PREMIUM">
		<asp:Label ID="lblTOT_PREMIUM" runat="server" AssociatedControlID="TOT__PREMIUM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TOT__PREMIUM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTOT_PREMIUM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TOT.PREMIUM"
			ClientValidationFunction="onValidate_TOT__PREMIUM" 
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
		data-object-name="TOT" 
		data-property-name="POST_PREM" 
		id="pb-container-currency-TOT-POST_PREM">
		<asp:Label ID="lblTOT_POST_PREM" runat="server" AssociatedControlID="TOT__POST_PREM" 
			Text="" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="TOT__POST_PREM" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valTOT_POST_PREM" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for TOT.POST_PREM"
			ClientValidationFunction="onValidate_TOT__POST_PREM" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label30">
		<span class="label" id="label30"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:16%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label31">
		<span class="label" id="label31"></span>
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
		if ($("#id73cda24bd9d94164ac15fec08c7a47a2 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id73cda24bd9d94164ac15fec08c7a47a2 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id73cda24bd9d94164ac15fec08c7a47a2 div ul li").each(function(){		  
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
			$("#id73cda24bd9d94164ac15fec08c7a47a2 div ul li").each(function(){		  
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
		styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id73cda24bd9d94164ac15fec08c7a47a2 input{text-align:left;}"; break;
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