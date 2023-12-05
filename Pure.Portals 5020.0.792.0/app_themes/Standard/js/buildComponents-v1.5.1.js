/**
 * @fileoverview Contains the main function that decorates any native html
 * fields on the screen. This adds additional html elemnents to display
 * things like number and date formatting without altering the actual value
 * submitted back to the server. It also instantiates each field to work
 * with expressions in the spreadsheet.
 */
 
/**
 * Decorates all the native fields as specified on the spreadsheet.
 */
function BuildComponents(){
	
  if (typeof performance !== 'undefined'){
    performance.mark('buildComponentsStart')
  }

	var decorateTextField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Text(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
		
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
		
		if (hasAttribute(container, "data-dre")){
			var listProperty = propertyName.slice(0, -4);
			if (hasAttribute(container, "data-suffix-id")){
				listProperty += "ID";
			}
			if (hasAttribute(container, "data-suffix-none")){
				listProperty += "";
			}
			var list = Field.getInstance(objectName, listProperty);
			if (list){
				goog.events.listen(list, "change", function(e){
					instance.setValue(list.getCode() || "");
				}, false, this);
				instance.setValue(list.getCode() || "");
			}
		}
	};
	
	var decorateListField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.List(objectName, propertyName);
		var parentNode = container.parentNode;
		var marker = document.createElement("span");
		parentNode.replaceChild(marker, container);
		
		instance.decorate(container);
		// Put the content back
		parentNode.replaceChild(container, marker);
		
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateCurrencyField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Currency(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateIntegerField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Integer(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
		
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decoratePercentageField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Percentage(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};

	var decorateBooleanListField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.BooleanList(objectName, propertyName);
		var parentNode = container.parentNode;
		var marker = document.createElement("span");
		parentNode.replaceChild(marker, container);
		
		instance.decorate(container);
		// Put the content back
		parentNode.replaceChild(container, marker);
		
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateBooleanRadioField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.BooleanRadio(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
		
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateCheckboxField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Checkbox(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateChildField = function(container){
	
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.ChildScreen(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateCommentField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Comment(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateDateField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.DateJQueryCompatible(
			objectName, 
			propertyName, 
			// This is the format that's stored and submitted back to Pure
			"dd/MM/yyyy", 
			// These are the alternative accepted formats when dates are input by the user.
			["d/M/yy", "d/M/yyyy","dd/M/yy", "d/MM/yyyy", "dd/MM/yy", "dd/MM/yyyy", "dd.MM.yy", "dd MM yy", "ddMMyyyy", "dd.MM.yyyy", "dd MM yyyy", "yyyy-MM-dd hh:mm:ss", "yyyy-MM-dd hh:mm"],
			// This is the format that's displayed
			"dd/MM/yyyy"
		);
		Field.registerInstance(instance);
		// Wait until the date picker has been applied
		//jQuery(document).ready(function(){
			instance.decorate(container);
		//});
		
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
		
	};
	
	var decorateInlineChildField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.ChildScreen(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
		
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
		
	};
	
	var decorateLegacyCheckboxField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.LegacyCheckbox(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTempField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Text(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();

	};
	
	var decorateTempCheckboxField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Checkbox(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTempCommentField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.Comment(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTempCurrencyField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.Currency(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTempDateField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.DateJQueryCompatible(
			objectName, 
			propertyName, 
			"dd/MM/yyyy", 
			["d/M/yy", "d/M/yyyy", "dd/MM/yy", "ddMMyy", "dd.MM.yy", "dd MM yy", "ddMMyyyy", "dd.MM.yyyy", "dd MM yyyy", "yyyy-MM-dd hh:mm:ss", "yyyy-MM-dd hh:mm"]
		);
		Field.registerInstance(instance);
		// Wait until the date picker has been applied
		//jQuery(document).ready(function(){
			instance.decorate(container);
		//});
		
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};

	var decorateTempIntegerField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.Integer(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);
	
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTempPercentageField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.Percentage(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decoratePartyField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");

		var instance = new fields.Party(objectName, propertyName);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	var decorateTimeField = function(container){
		var objectName = container.getAttribute("data-object-name");
		var propertyName = container.getAttribute("data-property-name");
		
		var instance = new fields.Time(
			objectName, 
			propertyName, 
			"HH:mm", 
			["HHmm", "Hmm", "H:mm"]
		);
		instance.decorate(container);
		Field.registerInstance(instance);

		if (window.rulesDisabled && instance.makeUnchangeable) instance.makeUnchangeable();
		if (window.rulesDisabled && instance.makeReadOnlyForever) instance.makeReadOnlyForever();
	};
	
	goog.array.forEach(goog.dom.query("[data-field-type]"), function(container){
		switch (container.getAttribute("data-field-type")){
			case "Text": return decorateTextField(container);
			case "List": return decorateListField(container);
			case "Currency": return decorateCurrencyField(container);
			case "Integer": return decorateIntegerField(container);
			case "Percentage": return decoratePercentageField(container);
			case "BooleanList": return decorateBooleanListField(container);
			case "BooleanRadio": return decorateBooleanRadioField(container);
			case "Checkbox": return decorateCheckboxField(container);
			case "Child": return decorateChildField(container);
			case "Comment": return decorateCommentField(container);
			case "Date": return decorateDateField(container);
			case "InlineChild": return decorateInlineChildField(container);
			case "LegacyCheckbox": return decorateLegacyCheckboxField(container);
			case "Temp": return decorateTempField(container);
			case "TempCheckbox": return decorateTempCheckboxField(container);
			case "TempComment": return decorateTempCommentField(container);
			case "TempCurrency": return decorateTempCurrencyField(container);
			case "TempDate": return decorateTempDateField(container);
			case "TempInteger": return decorateTempIntegerField(container);
			case "TempPercentage": return decorateTempPercentageField(container);
			case "Party": return decoratePartyField(container);
			case "Time": return decorateTimeField(container);
			default: //if (window.console) window.console.log("Unhandled field type.");
		}
	});
	
	window.buildComponentsDone = true;
	
  if (typeof performance !== 'undefined'){
    performance.mark('buildComponentsEnd')
  }

	if (window.delayedBuildComponentsFunctions){
		goog.array.forEach(window.delayedBuildComponentsFunctions, function(func){
			func();
		});
	}

  
};

/**
 * A helper function to delay a function's execution until
 * after BuildComponents has been run. Useful if the code you wish
 * to run requires some fields to be initilised with expressions
 * first.
 * @param {Function} func
 */
function fireAfterBuildComponents(func){
	if (window.buildComponentsDone) return func();
	
	window.delayedBuildComponentsFunctions = window.delayedBuildComponentsFunctions || [];
	window.delayedBuildComponentsFunctions.push(func);
};

/**
 * Element.prototype.hasAttribute is not supported in IE8,
 * so use this method instead.
 */
function hasAttribute(element, attr){
	if (element.hasAttribute) return element.hasAttribute(attr);

	return typeof element[attr] !== 'undefined'; 
	// You may also be able to check getAttribute() against null, though it is 
	// possible this could cause problems for any older browsers (if any) which 
	// followed the old DOM3 way of returning the empty string for an empty 
	// string (yet did not possess hasAttribute as per our checks above). 
	// See https://developer.mozilla.org/en-US/docs/Web/API/Element.getAttribute
};