<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/Default.master"
    CodeFile="DNOCLM_Reserves.aspx.vb" Inherits="Nexus.PB2_DNOCLM_Reserves" %>

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
function onValidate_DNOLBCLAIM__SOLSCREEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DNOLBCLAIM", "SOLSCREEN", "ChildScreen");
        })();
        /**
         * @fileoverview
         * DisableAddWhen, used only on child screen objects.
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("DNOLBCLAIM", "SOLSCREEN");
        		var update = function(){
                var links;
        		if (field.getType() == "child_screen"){
        			// Remove the options from the table
        		   links = goog.dom.query("#ctl00_cntMainBody_DNOLBCLAIM__SOLSCREEN table td a");
        				
        		} else {
        		   links = goog.dom.query("a", field.getElement());
        		}		
                var exp = new Expression("DNOLBCLAIM.TransactionType = 'PAYCLAIM' ||DNOLBCLAIM.TransactionType = 'TPRECOVERY' || DNOLBCLAIM.TransactionType = 'SALVAGECLAIM'");
        		goog.array.forEach(links, function(link){	
        				// Hide specified links
        				var linkCaption = $(link).text(); 
        				if (link != null && linkCaption.toLowerCase().trim() == 'add')
        		        {
        					if (exp.getValue() == true ){
        				       link.style.display = "none";
        					} else  {
        						link.style.display = "inline-block";
        					}
        		        }		
        		});		
        	};
        	 update();		
        		        goog.events.listen(field, "change", update); 
        	};
        })();
}
function onValidate_DNOLBCLAIM__SOL_COUNTER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DNOLBCLAIM", "SOL_COUNTER", "Integer");
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
        			var field = Field.getInstance("DNOLBCLAIM", "SOL_COUNTER");
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
function onValidate_DNOLBCLAIM__TransactionType(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DNOLBCLAIM", "TransactionType", "Text");
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
        			var field = Field.getInstance("DNOLBCLAIM", "TransactionType");
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
function onValidate_DNOLBCLAIM__RCVRSCREEN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DNOLBCLAIM", "RCVRSCREEN", "ChildScreen");
        })();
}
function onValidate_DNOLBCLAIM__RECO_COUNTER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "DNOLBCLAIM", "RECO_COUNTER", "Integer");
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
        			var field = Field.getInstance("DNOLBCLAIM", "RECO_COUNTER");
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
    onValidate_DNOLBCLAIM__SOLSCREEN(null, null, null, isOnLoad);
    onValidate_DNOLBCLAIM__SOL_COUNTER(null, null, null, isOnLoad);
    onValidate_DNOLBCLAIM__TransactionType(null, null, null, isOnLoad);
    onValidate_DNOLBCLAIM__RCVRSCREEN(null, null, null, isOnLoad);
    onValidate_DNOLBCLAIM__RECO_COUNTER(null, null, null, isOnLoad);
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
<div id="id976aa734c3584532ab6043b37a423113" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="id6870ccd801214f86a9b69e5528d5fa5c" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading29" runat="server" Text="Claim Reserves" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_DNOLBCLAIM__SOLSCREEN"
		data-field-type="Child" 
		data-object-name="DNOLBCLAIM" 
		data-property-name="SOLSCREEN" 
		id="pb-container-childscreen-DNOLBCLAIM-SOLSCREEN">
		
		    <legend>Schedule of Loss</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="DNOLBCLAIM__SCHEDULE_LOSS" runat="server" ScreenCode="SOLSCREEN" AutoGenerateColumns="false"
							GridLines="None" ChildPage="SOLSCREEN/SOLSCREEN_Schedule_of_Loss.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Item Number" DataField="ITEM_NUMBER" DataFormatString=""/>
<Nexus:GISLookupField HeaderText="Peril" ListType="PMLookup" ListCode="UDL_DNO_PERIL_TYPE" DataField="PERIL" DataItemValue="key" />
<Nexus:GISLookupField HeaderText="Reserve Description" ListType="PMLookup" ListCode="UDL_CLA_RESERVE" DataField="DESCRIPTION" DataItemValue="key" />
<Nexus:GISLookupField HeaderText="Tax Group" ListType="PMLookup" ListCode="UDL_[Tax_Group]" DataField="TAX_GROUP" DataItemValue="key" />
<Nexus:GISLookupField HeaderText="Payee Type" ListType="PMLookup" ListCode="UDL_COM_PAYEE_TYPE" DataField="PAYEE_TYPE" DataItemValue="key" />
<Nexus:RiskAttribute HeaderText="Other Party" DataField="PARTY_NAME" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Client" DataField="CLIENT" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Reference Number" DataField="MEDIA_REF" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Reserve" DataField="RESERVE" DataFormatString="{0:N}"/>
<Nexus:RiskAttribute HeaderText="Ex-Gratia" DataField="IS_EXGRATIA" DataFormatString="{0:Yes;;No}"/>
<Nexus:RiskAttribute HeaderText="Payment Amount" DataField="PAYMENT_AMOUNT" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valDNOLBCLAIM_SOLSCREEN" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Schedule of Loss"
						ClientValidationFunction="onValidate_DNOLBCLAIM__SOLSCREEN" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="DNOLBCLAIM" 
		data-property-name="SOL_COUNTER" 
		id="pb-container-integer-DNOLBCLAIM-SOL_COUNTER">
		<asp:Label ID="lblDNOLBCLAIM_SOL_COUNTER" runat="server" AssociatedControlID="DNOLBCLAIM__SOL_COUNTER" 
			Text="Schedule Item Counter " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="DNOLBCLAIM__SOL_COUNTER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valDNOLBCLAIM_SOL_COUNTER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Schedule Item Counter "
			ClientValidationFunction="onValidate_DNOLBCLAIM__SOL_COUNTER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="DNOLBCLAIM" 
		data-property-name="TransactionType" 
		 
		
		 
		id="pb-container-text-DNOLBCLAIM-TransactionType">

		
		<asp:Label ID="lblDNOLBCLAIM_TransactionType" runat="server" AssociatedControlID="DNOLBCLAIM__TransactionType" 
			Text="{none}" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="DNOLBCLAIM__TransactionType" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valDNOLBCLAIM_TransactionType" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for {none}"
					ClientValidationFunction="onValidate_DNOLBCLAIM__TransactionType"
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
		if ($("#id6870ccd801214f86a9b69e5528d5fa5c div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#id6870ccd801214f86a9b69e5528d5fa5c div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#id6870ccd801214f86a9b69e5528d5fa5c div ul li").each(function(){		  
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
			$("#id6870ccd801214f86a9b69e5528d5fa5c div ul li").each(function(){		  
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
		styleString += "#id6870ccd801214f86a9b69e5528d5fa5c label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#id6870ccd801214f86a9b69e5528d5fa5c label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6870ccd801214f86a9b69e5528d5fa5c label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6870ccd801214f86a9b69e5528d5fa5c label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#id6870ccd801214f86a9b69e5528d5fa5c input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#id6870ccd801214f86a9b69e5528d5fa5c input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#id6870ccd801214f86a9b69e5528d5fa5c input{text-align:left;}"; break;
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
<div id="idef9e22c6000446029024538c51250205" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading30" runat="server" Text="Claim Recoveries" /></legend>
				
				
				<div data-column-count="1" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Child -->
	<div class="child-card" id="ctl00_cntMainBody_DNOLBCLAIM__RCVRSCREEN"
		data-field-type="Child" 
		data-object-name="DNOLBCLAIM" 
		data-property-name="RCVRSCREEN" 
		id="pb-container-childscreen-DNOLBCLAIM-RCVRSCREEN">
		
		    <legend>Recoveries</legend>
		 
			        <div class="grid-card table-responsive no-margin">
						<nexus:ItemGrid ID="DNOLBCLAIM__RECOVERIES" runat="server" ScreenCode="RCVRSCREEN" AutoGenerateColumns="false"
							GridLines="None" ChildPage="RCVRSCREEN/RCVRSCREEN_Recovery.aspx" emptydatatext="sac">
							<columns>
						<Nexus:RiskAttribute HeaderText="Item Number" DataField="ITEM_NUMBER" DataFormatString=""/>
<Nexus:GISLookupField HeaderText="Peril" ListType="PMLookup" ListCode="UDL_DNO_PERIL_TYPE" DataField="PERIL" DataItemValue="key" />
<Nexus:GISLookupField HeaderText="Recovery Type" ListType="PMLookup" ListCode="UDL_SPECIAL_RECO_TYPE" DataField="RECOVERY_TYPE" DataItemValue="key" />
<Nexus:RiskAttribute HeaderText="Other Party" DataField="OTHER_PARTY" DataFormatString=""/>
<Nexus:RiskAttribute HeaderText="Negotiated Amount" DataField="NEGOTIATED_AMOUNT" DataFormatString="{0:N}"/>

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
				
					<asp:CustomValidator ID="valDNOLBCLAIM_RCVRSCREEN" 
						runat="server" 
						Text="*" 
						ErrorMessage="A validation error occurred for Recoveries"
						ClientValidationFunction="onValidate_DNOLBCLAIM__RCVRSCREEN" 
						Display="None"
						EnableClientScript="true"/>
	</div>
<!-- /Child -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:100%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="DNOLBCLAIM" 
		data-property-name="RECO_COUNTER" 
		id="pb-container-integer-DNOLBCLAIM-RECO_COUNTER">
		<asp:Label ID="lblDNOLBCLAIM_RECO_COUNTER" runat="server" AssociatedControlID="DNOLBCLAIM__RECO_COUNTER" 
			Text="Recoveries counter" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="DNOLBCLAIM__RECO_COUNTER" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valDNOLBCLAIM_RECO_COUNTER" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Recoveries counter"
			ClientValidationFunction="onValidate_DNOLBCLAIM__RECO_COUNTER" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
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
		if ($("#idef9e22c6000446029024538c51250205 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#idef9e22c6000446029024538c51250205 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#idef9e22c6000446029024538c51250205 div ul li").each(function(){		  
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
			$("#idef9e22c6000446029024538c51250205 div ul li").each(function(){		  
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
		styleString += "#idef9e22c6000446029024538c51250205 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#idef9e22c6000446029024538c51250205 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idef9e22c6000446029024538c51250205 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idef9e22c6000446029024538c51250205 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#idef9e22c6000446029024538c51250205 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#idef9e22c6000446029024538c51250205 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#idef9e22c6000446029024538c51250205 input{text-align:left;}"; break;
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